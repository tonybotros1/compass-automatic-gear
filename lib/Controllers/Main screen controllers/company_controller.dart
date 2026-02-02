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

  @override
  void onInit() {
    connectWebSocket();
    getAllCompanies();
    getCountries();
    getIndustries();
    getAllRoles();

    super.onInit();
  }

  void connectWebSocket() {
    ws.events.listen((message) {
      switch (message["type"]) {
        case "company_created":
          final newCounter = CompanyModel.fromJson(message["data"]);
          allCompanies.add(newCounter);
          break;

        case "company_status_updated":
          final branchId = message["data"]['_id'];
          final branchStatus = message["data"]['status'];
          final index = allCompanies.indexWhere((m) => m.id == branchId);
          if (index != -1) {
            allCompanies[index].status = branchStatus;
            allCompanies.refresh();
          }
          break;

        case "company_updated":
          final updated = CompanyModel.fromJson(message["data"]);
          final index = allCompanies.indexWhere((m) => m.id == updated.id);
          if (index != -1) {
            allCompanies[index] = updated;
          }
          break;

        case "company_deleted":
          final deletedId = message["data"]["_id"];
          allCompanies.removeWhere((m) => m.id == deletedId);
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
      }
    } catch (e) {
      isScreenLoding.value = false;
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  Future<void> addNewCompany() async {
    try {
      addingNewCompanyProcess.value = true;
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      final refreshToken = await secureStorage.read(key: "refreshToken") ?? '';

      final url = Uri.parse('$backendUrl/companies/register_company');
      final request = http.MultipartRequest('POST', url);

      request.headers['Authorization'] = 'Bearer $accessToken';

      request.fields.addAll({
        "company_name": companyName.text,
        "admin_email": email.text,
        "admin_password": password.text,
        "industry": industryId.value,
        "admin_name": userName.text,
        "phone_number": phoneNumber.text,
        "address": address.text,
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

      if (response.statusCode == 200) {
        Get.back();
        addingNewCompanyProcess.value = false;
      } else if (response.statusCode == 400) {
        final respStr = await response.stream.bytesToString();
        final decoded = jsonDecode(respStr);
        showSnackBar('Error', decoded['detail'] ?? 'Bad Request');
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          // maybe add retry limit here
          await addNewCompany();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
    } catch (e) {
      print(e);
      showSnackBar('Alert', 'Something went wrong please try again');
    } finally {
      addingNewCompanyProcess.value = false;
    }
  }

  Future<void> updateCompany(String companyID, String userID) async {
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
        "company_name": companyName.text,
        "admin_email": email.text,
        "admin_password": password.text,
        "industry": industryId.value,
        "admin_name": userName.text,
        "phone_number": phoneNumber.text,
        "address": address.text,
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

      if (response.statusCode == 200) {
        Get.back();
        addingNewCompanyProcess.value = false;
      } else if (response.statusCode == 400) {
        final respStr = await response.stream.bytesToString();
        final decoded = jsonDecode(respStr);
        showSnackBar('Error', decoded['detail'] ?? 'Bad Request');
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await updateCompany(companyID, userID);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
    } finally {
      addingNewCompanyProcess.value = false;
    }
  }

  Future<void> deleteCompany(String companyID, String userID) async {
    try {
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
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteCompany(companyID, userID);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      Get.back();
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  Future<void> changeCompanyStatus(String companyID, bool status) async {
    try {
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
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await changeCompanyStatus(companyID, status);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
    } catch (e) {
      //
    }
  }

  // =====================================================================================================

  // this function is to select an image for logo
  Future<void> pickImage() async {
    try {
      // Use file_picker to pick an image file
      final result = await FilePicker.platform.pickFiles(
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

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allCompanies.sort((screen1, screen2) {
        final String? value1 = screen1.companyName;
        final String? value2 = screen2.companyName;

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 3) {
      allCompanies.sort((screen1, screen2) {
        final String? value1 = screen1.userName;
        final String? value2 = screen2.userName;

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 5) {
      allCompanies.sort((screen1, screen2) {
        final String? value1 = screen1.createdAt;
        final String? value2 = screen2.createdAt;

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    }
    sortColumnIndex.value = columnIndex;
    isAscending.value = ascending;
  }

  int compareString(bool ascending, String value1, String value2) {
    int comparison = value1.compareTo(value2);
    return ascending ? comparison : -comparison; // Reverse if descending
  }

  // this function is to filter the search results for web
  void filterCompanies() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredCompanies.clear();
    } else {
      filteredCompanies.assignAll(
        allCompanies.where((company) {
          return company.companyName.toString().toLowerCase().contains(query) ||
              company.createdAt.toString().toLowerCase().contains(query) ||
              company.userCountry.toString().toLowerCase().contains(query) ||
              company.userCity.toString().toLowerCase().contains(query) ||
              company.userPhoneNumber.toString().toLowerCase().contains(
                query,
              ) ||
              company.userName.toString().toLowerCase().contains(query);
        }).toList(),
      );
    }
  }
}
