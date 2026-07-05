import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/companies/company_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import 'main_screen_contro.dart';
import 'websocket_controller.dart';

class CompanyController extends GetxController {
  RxBool isScreenLoding = RxBool(false);
  TextEditingController companyName = TextEditingController();
  Rx<TextEditingController> industry = TextEditingController().obs;
  RxString industryId = RxString('');
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController city = TextEditingController();
  final RxList<CompanyModel> allCompanies = RxList<CompanyModel>([]);
  RxMap userDetails = RxMap({});
  final RxList<CompanyModel> filteredCompanies = RxList<CompanyModel>([]);
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool warningForImage = RxBool(false);
  RxBool addingNewCompanyProcess = RxBool(false);
  RxBool isEditingCompany = RxBool(false);
  RxString deletingCompanyId = RxString('');
  RxString changingCompanyStatusId = RxString('');
  Uint8List? imageBytes;
  RxList<MainUserRoles> roleIDFromList = RxList<MainUserRoles>([]);
  RxMap allRoles = RxMap({});
  RxMap allCountries = RxMap({});
  RxMap allCities = RxMap({});
  RxString selectedCountryId = RxString('');
  RxString selectedCityId = RxString('');
  RxString logoUrl = RxString('');
  RxMap industryMap = RxMap({});
  String backendUrl = backendTestURI;
  WebSocketService ws = Get.find<WebSocketService>();
  StreamSubscription<Map<String, dynamic>>? _companyEventsSubscription;

  @override
  void onInit() {
    connectWebSocket();
    getAllCompanies();
    getCountries();
    getIndustries();
    getAllRoles();

    super.onInit();
  }

  @override
  void onClose() {
    _companyEventsSubscription?.cancel();
    companyName.dispose();
    industry.value.dispose();
    userName.dispose();
    password.dispose();
    phoneNumber.dispose();
    email.dispose();
    address.dispose();
    country.dispose();
    city.dispose();
    search.value.dispose();
    super.onClose();
  }

  void connectWebSocket() {
    _companyEventsSubscription?.cancel();
    _companyEventsSubscription = ws.events.listen((message) {
      switch (message["type"]) {
        case "company_created":
          final newCompany = CompanyModel.fromJson(message["data"]);
          _upsertCompany(newCompany, insertAtStart: true);
          break;

        case "company_status_updated":
          final companyId = message["data"]['_id']?.toString() ?? '';
          final companyStatus = message["data"]['status'];
          if (companyId.isNotEmpty && companyStatus is bool) {
            _updateCompanyStatusLocally(companyId, companyStatus);
          }
          break;

        case "company_updated":
          final updated = CompanyModel.fromJson(message["data"]);
          _upsertCompany(updated);
          break;

        case "company_deleted":
          final deletedId = message["data"]["_id"]?.toString() ?? '';
          _removeCompany(deletedId);
          break;
      }
    });
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  Future<void> getCountries() async {
    allCountries.assignAll(await helper.getCountries());
  }

  Future<void> getCitiesByCountryId(String countryId) async {
    allCities.assignAll(await helper.getCitiesValues(countryId));
  }

  Future<Map<String, dynamic>> getAllRoles() async {
    return await helper.getAllRoles();
  }

  Future<void> getIndustries() async {
    industryMap.assignAll(await helper.getAllListValues('INDUSTRIES'));
  }

  Future<void> getAllCompanies() async {
    try {
      isScreenLoding.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/companies/get_all_companies');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List comps = decoded["companies"];
        allCompanies.assignAll(
          comps.map((comp) => CompanyModel.fromJson(comp)),
        );
        _sortCompanyList(allCompanies);
        _refreshFilteredCompanies();
        isScreenLoding.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllCompanies();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        isScreenLoding.value = false;
        logout();
      } else {
        isScreenLoding.value = false;
        showSnackBar('Alert', _messageFromJsonBody(response.body));
      }
    } catch (e) {
      isScreenLoding.value = false;
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  Future<bool> addNewCompany() async {
    if (!_validateCompanyForm(requirePassword: true)) return false;
    try {
      addingNewCompanyProcess.value = true;
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      final refreshToken = await secureStorage.read(key: "refreshToken") ?? '';

      final url = Uri.parse('$backendUrl/companies/register_company');
      final request = http.MultipartRequest('POST', url);

      request.headers['Authorization'] = 'Bearer $accessToken';

      request.fields.addAll({
        "company_name": companyName.text.trim(),
        "admin_email": email.text.trim(),
        "admin_password": password.text.trim(),
        "industry": industryId.value,
        "admin_name": userName.text.trim(),
        "phone_number": phoneNumber.text.trim(),
        "address": address.text.trim(),
        "country": selectedCountryId.value,
        "city": selectedCityId.value,
      });
      for (var role in roleIDFromList) {
        if (role.sId != null) {
          request.files.add(
            http.MultipartFile.fromString('roles_ids', role.sId!),
          );
        }
      }

      if (imageBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'company_logo',
            imageBytes!,
            filename: "company_logo_${companyName.text}.png",
          ),
        );
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        _applyCompanyResponseUpdate(responseBody, insertAtStart: true);
        Get.back();
        showSnackBar(
          'Done',
          _messageFromJsonBody(responseBody, 'Company added successfully'),
        );
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await addNewCompany();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        showSnackBar('Error', _messageFromJsonBody(responseBody));
      }
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
    } finally {
      addingNewCompanyProcess.value = false;
    }
    return false;
  }

  Future<bool> updateCompany(String companyID, String userID) async {
    if (!_validateCompanyForm(requirePassword: false)) return false;
    try {
      addingNewCompanyProcess.value = true;
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      final refreshToken = await secureStorage.read(key: "refreshToken") ?? '';

      final url = Uri.parse(
        '$backendUrl/companies/update_company/$companyID/$userID',
      );
      final request = http.MultipartRequest('PATCH', url);

      request.headers['Authorization'] = 'Bearer $accessToken';

      request.fields.addAll({
        "company_name": companyName.text.trim(),
        "admin_email": email.text.trim(),
        "industry": industryId.value,
        "admin_name": userName.text.trim(),
        "phone_number": phoneNumber.text.trim(),
        "address": address.text.trim(),
        "country": selectedCountryId.value,
        "city": selectedCityId.value,
      });
      final cleanPassword = password.text.trim();
      if (cleanPassword.isNotEmpty) {
        request.fields["admin_password"] = cleanPassword;
      }
      for (var role in roleIDFromList) {
        if (role.sId != null) {
          request.files.add(
            http.MultipartFile.fromString('roles_ids', role.sId!),
          );
        }
      }

      if (imageBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'company_logo',
            imageBytes!,
            filename: "company_logo_${companyName.text}.png",
          ),
        );
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        _applyCompanyResponseUpdate(responseBody);
        Get.back();
        showSnackBar(
          'Done',
          _messageFromJsonBody(responseBody, 'Company updated successfully'),
        );
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await updateCompany(companyID, userID);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        showSnackBar('Error', _messageFromJsonBody(responseBody));
      }
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
    } finally {
      addingNewCompanyProcess.value = false;
    }
    return false;
  }

  Future<bool> deleteCompany(String companyID, String userID) async {
    if (companyID.isEmpty || userID.isEmpty) {
      showSnackBar('Alert', 'can\'t proceed');
      return false;
    }
    try {
      deletingCompanyId.value = companyID;
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      final refreshToken = await secureStorage.read(key: "refreshToken") ?? '';
      final url = Uri.parse(
        '$backendUrl/companies/delete_company/$companyID/$userID',
      );
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        _removeCompany(companyID);
        showSnackBar(
          'Done',
          _messageFromJsonBody(response.body, 'Company deleted successfully'),
        );
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await deleteCompany(companyID, userID);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        showSnackBar('Alert', _messageFromJsonBody(response.body));
      }
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
    } finally {
      if (deletingCompanyId.value == companyID) {
        deletingCompanyId.value = '';
      }
    }
    return false;
  }

  Future<bool> changeCompanyStatus(String companyID, bool status) async {
    try {
      changingCompanyStatusId.value = companyID;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/companies/change_company_status/$companyID',
      );
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode(status),
      );
      if (response.statusCode == 200) {
        _updateCompanyStatusLocally(companyID, status);
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await changeCompanyStatus(companyID, status);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        showSnackBar('Alert', _messageFromJsonBody(response.body));
      }
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
    } finally {
      if (changingCompanyStatusId.value == companyID) {
        changingCompanyStatusId.value = '';
      }
    }
    return false;
  }

  // =====================================================================================================

  // this function is to select an image for logo
  Future<void> pickImage() async {
    try {
      // Use file_picker to pick an image file
      final result = await FilePicker.pickFiles(
        type: FileType.image, // Filter by image file types
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        // Store the file bytes directly into imageBytes
        imageBytes = file.bytes;
        update(); // Trigger any necessary update in your controller
      }
    } catch (e) {
      // Handle error
      // print('Error picking image: $e');
    }
  }

  // this function is to remove a menu from the list
  void removeMenuFromList(int index) {
    roleIDFromList.removeAt(index);
  }

  bool _validateCompanyForm({required bool requirePassword}) {
    if (companyName.text.trim().isEmpty ||
        industryId.value.trim().isEmpty ||
        userName.text.trim().isEmpty ||
        phoneNumber.text.trim().isEmpty ||
        email.text.trim().isEmpty ||
        address.text.trim().isEmpty ||
        selectedCountryId.value.trim().isEmpty ||
        selectedCityId.value.trim().isEmpty ||
        roleIDFromList.isEmpty ||
        (requirePassword && password.text.trim().isEmpty)) {
      showSnackBar('Note', 'Please fill all fields');
      return false;
    }
    return true;
  }

  String _messageFromJsonBody(
    String body, [
    String fallback = 'Something went wrong please try again',
  ]) {
    if (body.trim().isEmpty) return fallback;
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final detail = decoded['detail'] ?? decoded['message'];
        if (detail is String && detail.trim().isNotEmpty) return detail;
        if (detail is List && detail.isNotEmpty) return detail.join(', ');
      }
    } catch (_) {
      return fallback;
    }
    return fallback;
  }

  void _applyCompanyResponseUpdate(String body, {bool insertAtStart = false}) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic> && decoded['data'] is Map) {
        _upsertCompany(
          CompanyModel.fromJson(Map<String, dynamic>.from(decoded['data'])),
          insertAtStart: insertAtStart,
        );
      }
    } catch (_) {
      // Websocket will still refresh the row when the response has no payload.
    }
  }

  void _upsertCompany(CompanyModel company, {bool insertAtStart = false}) {
    final companyId = company.id ?? '';
    if (companyId.isEmpty) return;
    final index = allCompanies.indexWhere((m) => m.id == companyId);
    if (index == -1) {
      insertAtStart
          ? allCompanies.insert(0, company)
          : allCompanies.add(company);
    } else {
      allCompanies[index] = company;
    }
    _sortCompanyList(allCompanies);
    allCompanies.refresh();
    _refreshFilteredCompanies();
  }

  void _removeCompany(String companyId) {
    if (companyId.isEmpty) return;
    allCompanies.removeWhere((m) => m.id == companyId);
    filteredCompanies.removeWhere((m) => m.id == companyId);
  }

  void _updateCompanyStatusLocally(String companyId, bool status) {
    final index = allCompanies.indexWhere((m) => m.id == companyId);
    if (index != -1) {
      allCompanies[index].status = status;
      allCompanies.refresh();
    }
    final filteredIndex = filteredCompanies.indexWhere(
      (m) => m.id == companyId,
    );
    if (filteredIndex != -1) {
      filteredCompanies[filteredIndex].status = status;
      filteredCompanies.refresh();
    }
  }

  void _refreshFilteredCompanies() {
    if (search.value.text.trim().isEmpty) {
      filteredCompanies.clear();
      return;
    }
    filterCompanies();
  }

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    isAscending.value = ascending;
    _sortCompanyList(allCompanies);
    allCompanies.refresh();
    if (filteredCompanies.isNotEmpty) {
      _sortCompanyList(filteredCompanies);
      filteredCompanies.refresh();
    }
  }

  void _sortCompanyList(List<CompanyModel> companies) {
    companies.sort((company1, company2) {
      final value1 = _sortValue(company1, sortColumnIndex.value);
      final value2 = _sortValue(company2, sortColumnIndex.value);
      return compareString(isAscending.value, value1, value2);
    });
  }

  String _sortValue(CompanyModel company, int columnIndex) {
    switch (columnIndex) {
      case 0:
        return company.companyName?.toLowerCase() ?? '';
      case 2:
        return '${company.userCountry ?? ''} ${company.userCity ?? ''}'
            .toLowerCase();
      case 3:
        return company.userName?.toLowerCase() ?? '';
      case 4:
        return company.userExpiryDate ?? '';
      case 6:
        return company.createdAt ?? '';
      default:
        return company.companyName?.toLowerCase() ?? '';
    }
  }

  int compareString(bool ascending, String value1, String value2) {
    final comparison = value1.compareTo(value2);
    return ascending ? comparison : -comparison;
  }

  // this function is to filter the search results for web
  void filterCompanies() {
    final queryText = search.value.text.toLowerCase().trim();
    query.value = queryText;
    if (queryText.isEmpty) {
      filteredCompanies.clear();
    } else {
      filteredCompanies.assignAll(
        allCompanies.where((company) {
          return company.companyName.toString().toLowerCase().contains(
                queryText,
              ) ||
              company.createdAt.toString().toLowerCase().contains(queryText) ||
              company.userCountry.toString().toLowerCase().contains(
                queryText,
              ) ||
              company.userCity.toString().toLowerCase().contains(queryText) ||
              company.userEmail.toString().toLowerCase().contains(queryText) ||
              company.userPhoneNumber.toString().toLowerCase().contains(
                queryText,
              ) ||
              company.userName.toString().toLowerCase().contains(queryText);
        }).toList(),
      );
      _sortCompanyList(filteredCompanies);
    }
  }
}
