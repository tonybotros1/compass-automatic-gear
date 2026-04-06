import 'dart:convert';
import 'dart:typed_data';

import 'package:datahubai/Models/employees/email_model.dart';
import 'package:datahubai/Models/employees/nationality_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/employees/address_model.dart';
import '../../Models/employees/contact_and_relatives_model.dart';
import '../../Models/employees/employees_model.dart';
import '../../Models/employees/phone_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import 'main_screen_contro.dart';
import 'websocket_controller.dart';

class EmployeesController extends GetxController {
  Rx<TextEditingController> search = TextEditingController().obs;
  TextEditingController employeeName = TextEditingController();
  TextEditingController employeeNameFilter = TextEditingController();
  RxString employeeNameFilterId = RxString('');
  TextEditingController genderFilter = TextEditingController();
  // TextEditingController employeeNumber = TextEditingController();
  TextEditingController employeeGender = TextEditingController();
  TextEditingController employeeDateOfBirth = TextEditingController();
  TextEditingController employeePlaceOfBirth = TextEditingController();
  TextEditingController personType = TextEditingController();
  TextEditingController employeeCountryOfBirth = TextEditingController();
  TextEditingController employeeNationality = TextEditingController();
  TextEditingController employeeMaritalStatus = TextEditingController();
  TextEditingController employeeEmail = TextEditingController();
  TextEditingController employeePhoneNumber = TextEditingController();
  TextEditingController employeeEmergencyPhoneNumber = TextEditingController();
  TextEditingController employeeEmergencyName = TextEditingController();
  TextEditingController employeeAddress = TextEditingController();
  TextEditingController jobTitle = TextEditingController();
  TextEditingController jobLocation = TextEditingController();
  RxString jobLocationId = RxString('');
  RxString jobTitleId = RxString('');
  TextEditingController hireDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  TextEditingController employeeStatus = TextEditingController();
  TextEditingController jobEmployer = TextEditingController();
  TextEditingController jobDepartment = TextEditingController();
  TextEditingController reportingManager = TextEditingController();
  RxString reportingManagerId = RxString('');
  RxString jobDepartmentId = RxString('');
  RxString jobEmployerId = RxString('');
  RxList<EmployeeAddressModel> addressesList = RxList<EmployeeAddressModel>([]);
  RxList<PhoneModel> phonesList = RxList<PhoneModel>([]);
  RxList<EmailModel> emailsList = RxList<EmailModel>([]);
  RxList<NationalityModel> nationalityList = RxList<NationalityModel>([]);
  TextEditingController country = TextEditingController();
  TextEditingController line = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController nationality = TextEditingController();
  TextEditingController phoneType = TextEditingController();
  TextEditingController emailType = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController emailAddress = TextEditingController();
  RxString nationalityId = RxString('');
  RxString phoneTypeId = RxString('');
  RxString emailTypeId = RxString('');
  TextEditingController nationalityStartDate = TextEditingController();
  TextEditingController nationalityEndDate = TextEditingController();
  RxString countryId = RxString('');
  RxString cityId = RxString('');
  RxString employeeNamtionalityId = RxString('');
  RxString employeeMaritalStatusId = RxString('');
  RxString employeeStatusId = RxString('');
  RxString employeeGenderId = RxString('');
  RxString employeeCountryOfBirthId = RxString('');
  RxString query = RxString('');
  RxBool isScreenLoding = RxBool(false);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  RxBool addingNewContactAndRelativesValue = RxBool(false);
  RxBool addingNewEmployeeAddressValue = RxBool(false);
  RxBool addingNewEmployeePhoneValue = RxBool(false);
  RxBool addingNewEmployeeEmailValue = RxBool(false);
  RxBool addingNewEmployeeNationalityValue = RxBool(false);
  String backendUrl = backendTestURI;
  RxList<EmployeesModel> allEmployees = RxList<EmployeesModel>([]);
  WebSocketService ws = Get.find<WebSocketService>();
  Uint8List? imageBytes;
  RxInt initStatusPickersValue = RxInt(1);
  RxString employeeImage = RxString('');
  RxString currentEmployeeId = RxString('');
  // =================== Contacts And Relatives Section ===================
  RxList<ContactsAndRelativesModel> contactsAndRelativesList =
      RxList<ContactsAndRelativesModel>([]);
  TextEditingController contactAndRelativeFullName = TextEditingController();
  TextEditingController contactAndRelativeRelationship =
      TextEditingController();
  RxString contactAndRelativeRelationshipId = RxString('');
  TextEditingController contactAndRelativePhoneNumber = TextEditingController();
  TextEditingController contactAndRelativeGender = TextEditingController();
  RxString contactAndRelativeGenderId = RxString('');
  TextEditingController contactAndRelativeDateOfBirth = TextEditingController();
  TextEditingController contactAndRelativeNationality = TextEditingController();
  RxString contactAndRelativeNationalityId = RxString('');
  TextEditingController contactAndRelativeEmailAddress =
      TextEditingController();
  TextEditingController contactAndRelativeNotes = TextEditingController();
  RxBool isThisContactAnEmergencyConact = RxBool(false);

  List<Widget> contactsTabs = const [
    Tab(text: 'Address'),
    Tab(text: 'Nationality'),
    Tab(text: 'Phones'),
    Tab(text: 'Emails'),
    Tab(text: 'Others'),
  ];

  @override
  void onInit() async {
    connectWebSocket();
    getAllEmployees();
    super.onInit();
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  Future<Map<String, dynamic>> getNationalities() async {
    return await helper.getAllListValues('NATIONALITIES');
  }

  Future<Map<String, dynamic>> getMaritalStatus() async {
    return await helper.getAllListValues('MARITAL_STATUS');
  }

  Future<Map<String, dynamic>> getEmployeeStatus() async {
    return await helper.getAllListValues('EMPLOYEE_STATUS');
  }

  Future<Map<String, dynamic>> getGenders() async {
    return await helper.getAllListValues('GENDER');
  }

  Future<Map<String, dynamic>> getRELATIONSHIPS() async {
    return await helper.getAllListValues('RELATIONSHIPS');
  }

  Future<Map<String, dynamic>> getCountries() async {
    return await helper.getCountries();
  }

  Future<Map<String, dynamic>> getPhoneTypes() async {
    return await helper.getAllListValues('CONTACT_TYPES');
  }

  Future<Map<String, dynamic>> getTypeOfSocial() async {
    return await helper.getAllListValues('SOCIAL_MEDIA');
  }

  Future<Map<String, dynamic>> getCitiesByCountryID(String countryID) async {
    return await helper.getCitiesValues(countryID);
  }

  Future<Map<String, dynamic>> getallJobEmployers() async {
    return await helper.getAllListValues('EMPLOYERS');
  }

  Future<Map<String, dynamic>> getAllJobDepartments() async {
    return await helper.getAllListValues('DEPARTMENTS');
  }

  Future<Map<String, dynamic>> getallJobTitle() async {
    return await helper.getAllListValues('JOBS');
  }

  Future<Map<String, dynamic>> getallJobLocations() async {
    return await helper.getAllListValues('LOCATIONS');
  }

  void connectWebSocket() {
    ws.events.listen((message) {
      switch (message["type"]) {
        case "employee_added":
          final newCounter = EmployeesModel.fromJson(message["data"]);
          allEmployees.insert(0, newCounter);
          break;

        case "employee_updated":
          final updated = EmployeesModel.fromJson(message["data"]);
          final index = allEmployees.indexWhere((m) => m.id == updated.id);
          if (index != -1) {
            allEmployees[index] = updated;
          }
          break;

        case "employee_deleted":
          final deletedId = message["data"]["_id"];
          allEmployees.removeWhere((m) => m.id == deletedId);
          break;
      }
    });
  }

  Future<void> getAllEmployees() async {
    try {
      isScreenLoding.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/employees/get_all_employees');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List employees = decoded['employees'];
        allEmployees.assignAll(
          employees.map((employee) => EmployeesModel.fromJson(employee)),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllEmployees();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      isScreenLoding.value = false;
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  Future<Map<String, dynamic>> getEmployeeDetails(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/employees/get_employee_details_dor_editing/$id',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        Map<String, dynamic> details = decoded['details'];
        return details;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllEmployees();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  Future<void> addNewEmployee() async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Map<String, String> data = {
        "full_name": employeeName.text,
        "country_of_birth": employeeCountryOfBirthId.value,
        "place_of_birth": employeePlaceOfBirth.text,
        "date_of_birth": convertDateToIson(employeeDateOfBirth.text).toString(),
        "gender": employeeGenderId.value,
        "martial_status": employeeMaritalStatusId.value,
        "person_type": personType.text,
        "status": employeeStatusId.value,
        "employer": jobEmployerId.value,
        "department": jobDepartmentId.value,
        "job_title": jobTitleId.value,
        "location": jobLocationId.value,
        "hire_date": convertDateToIson(hireDate.text).toString(),
        "end_date": convertDateToIson(endDate.text).toString(),
        "reporting_manager": reportingManagerId.value,
      };
      if (currentEmployeeId.value.isEmpty) {
        Uri creatingURL = Uri.parse('$backendUrl/employees/create_employee');
        final creatingREQUEST = http.MultipartRequest('POST', creatingURL);
        creatingREQUEST.headers['Authorization'] = 'Bearer $accessToken';
        creatingREQUEST.fields.addAll(data);
        if (imageBytes != null) {
          creatingREQUEST.files.add(
            http.MultipartFile.fromBytes(
              'person_image',
              imageBytes!,
              filename: "person_image${employeeName.text}.png",
            ),
          );
        }
        final response = await creatingREQUEST.send();
        if (response.statusCode == 200) {
          imageBytes = null;
          final responseData = await response.stream.bytesToString();
          final decoded = jsonDecode(responseData);
          final employeeID = decoded["employee_id"];
          currentEmployeeId.value = employeeID ?? '';
        } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
          final refreshed = await helper.refreshAccessToken(refreshToken);
          if (refreshed == RefreshResult.success) {
            await addNewEmployee();
          } else if (refreshed == RefreshResult.invalidToken) {
            logout();
          }
        } else if (response.statusCode == 401) {
          logout();
        }
      } else {
        Uri updatingURL = Uri.parse(
          '$backendUrl/employees/update_employee/${currentEmployeeId.value}',
        );
        final updatingREQUEST = http.MultipartRequest('PATCH', updatingURL);
        updatingREQUEST.headers['Authorization'] = 'Bearer $accessToken';
        updatingREQUEST.fields.addAll(data);
        if (imageBytes != null) {
          updatingREQUEST.files.add(
            http.MultipartFile.fromBytes(
              'person_image',
              imageBytes!,
              filename: "person_image${employeeName.text}.png",
            ),
          );
        }
        final response = await updatingREQUEST.send();
        if (response.statusCode == 200) {
          imageBytes = null;
        } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
          final refreshed = await helper.refreshAccessToken(refreshToken);
          if (refreshed == RefreshResult.success) {
            await addNewEmployee();
          } else if (refreshed == RefreshResult.invalidToken) {
            logout();
          }
        } else if (response.statusCode == 401) {
          logout();
        }
      }

      addingNewValue.value = false;
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  Future<void> deleteEmployee(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/employees/delete_employee/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteEmployee(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      Get.back();
    } catch (e) {
      //
    }
  }

  void clearValues(bool isEmployee) {
    employeeName.clear();
    employeeCountryOfBirth.clear();
    employeeCountryOfBirthId.value = '';
    employeePlaceOfBirth.clear();
    employeeDateOfBirth.clear();
    employeeGender.clear();
    employeeGenderId.value = '';
    employeeMaritalStatus.clear();
    employeeMaritalStatusId.value = '';
    personType.text = isEmployee ? 'Employee' : 'Applicant';
    employeeStatus.clear();
    employeeStatusId.value = '';
    jobEmployer.clear();
    jobEmployerId.value = '';
    jobDepartment.clear();
    jobDepartmentId.value = '';
    jobTitle.clear();
    jobTitleId.value = '';
    jobLocation.clear();
    jobLocationId.value = '';
    hireDate.clear();
    endDate.clear();
    reportingManager.clear();
    reportingManagerId.value = '';
    addressesList.clear();
    nationalityList.clear();
    phonesList.clear();
    emailsList.clear();
  }

  Future<void> loadValues(String selectedEmployeeId) async {
    final data = await getEmployeeDetails(selectedEmployeeId);
    final employee = EmployeesModel.fromJson(data);
    currentEmployeeId.value = employee.id ?? '';
    employeeName.text = employee.fullName ?? '';
    employeeCountryOfBirth.text = employee.countryOfBirthName ?? '';
    employeeCountryOfBirthId.value = employee.countryOfBirth ?? '';
    employeePlaceOfBirth.text = employee.placeOfBirth ?? '';
    employeeDateOfBirth.text = textToDate(employee.dateOfBirth);
    employeeGender.text = employee.genderName ?? '';
    employeeGenderId.value = employee.gender ?? '';
    employeeMaritalStatus.text = employee.martialStatusName ?? '';
    employeeMaritalStatusId.value = employee.martialStatus ?? '';
    personType.text = employee.personType ?? '';
    employeeStatus.text = employee.statusName ?? '';
    employeeStatusId.value = employee.status ?? '';
    jobEmployer.text = employee.employerName ?? '';
    jobEmployerId.value = employee.employer ?? '';
    jobDepartment.text = employee.departmentName ?? '';
    jobDepartmentId.value = employee.department ?? '';
    jobTitle.text = employee.jobTitleName ?? '';
    jobTitleId.value = employee.jobTitle ?? '';
    jobLocation.text = employee.locationName ?? '';
    jobLocationId.value = employee.location ?? '';
    hireDate.text = textToDate(employee.hireDate);
    endDate.text = textToDate(employee.endDate);
    reportingManager.text = employee.reportingManagerName ?? '';
    reportingManagerId.value = employee.reportingManager ?? '';
    addressesList.assignAll(employee.addressesList ?? []);
    nationalityList.assignAll(employee.nationalitiesList ?? []);
    phonesList.assignAll(employee.phoneList ?? []);
    emailsList.assignAll(employee.emailList ?? []);
  }

  // ======================== address section ========================
  Future<void> addNewAddress() async {
    try {
      if (currentEmployeeId.value.isEmpty) {
        alertMessage(context: Get.context!, content: "Save doc first please");
        return;
      }
      addingNewEmployeeAddressValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/employees/add_employee_address/${currentEmployeeId.value}',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "line": line.text,
          "country": countryId.value,
          "city": cityId.value,
        }),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        EmployeeAddressModel newAddress = EmployeeAddressModel.fromJson(
          decoded['new_address'],
        );
        addressesList.insert(0, newAddress);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewAddress();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      addingNewEmployeeAddressValue.value = false;
      Get.back();
    } catch (e) {
      addingNewEmployeeAddressValue.value = false;
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  Future<void> updateAddress(String id) async {
    try {
      if (currentEmployeeId.value.isEmpty) {
        alertMessage(context: Get.context!, content: "Save doc first please");
        return;
      }
      addingNewEmployeeAddressValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/employees/update_employee_address/$id');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "line": line.text,
          "country": countryId.value,
          "city": cityId.value,
        }),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        EmployeeAddressModel newAddress = EmployeeAddressModel.fromJson(
          decoded['update_address'],
        );
        int index = addressesList.indexWhere((add) => add.id == id);
        if (index != -1) {
          addressesList[index] = newAddress;
          addressesList.refresh();
        }
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await updateAddress(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      addingNewEmployeeAddressValue.value = false;
      Get.back();
    } catch (e) {
      addingNewEmployeeAddressValue.value = false;
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  Future<void> deleteAddress(String id) async {
    try {
      if (currentEmployeeId.value.isEmpty) {
        alertMessage(context: Get.context!, content: "Save doc first please");
        return;
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/employees/delete_employee_address/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        addressesList.removeWhere((add) => add.id == id);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteAddress(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
    } catch (e) {
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  // ======================== nationality section ========================
  Future<void> addNewNationality() async {
    try {
      if (currentEmployeeId.value.isEmpty) {
        alertMessage(context: Get.context!, content: "Save doc first please");
        return;
      }
      addingNewEmployeeNationalityValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/employees/add_employee_nationality/${currentEmployeeId.value}',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "nationality": nationalityId.value,
          "start_date": nationalityStartDate.text.isNotEmpty
              ? convertDateToIson(nationalityStartDate.text)
              : null,
          "end_date": nationalityEndDate.text.isNotEmpty
              ? convertDateToIson(nationalityEndDate.text)
              : null,
        }),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        NationalityModel newNationality = NationalityModel.fromJson(
          decoded['new_nationality'],
        );
        nationalityList.insert(0, newNationality);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewNationality();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      addingNewEmployeeNationalityValue.value = false;
      Get.back();
    } catch (e) {
      addingNewEmployeeNationalityValue.value = false;
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  Future<void> updateNationality(String id) async {
    try {
      if (currentEmployeeId.value.isEmpty) {
        alertMessage(context: Get.context!, content: "Save doc first please");
        return;
      }
      addingNewEmployeeNationalityValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/employees/edit_employee_nationality/$id',
      );
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "nationality": nationalityId.value,
          "start_date": nationalityStartDate.text.isNotEmpty
              ? convertDateToIson(nationalityStartDate.text)
              : null,
          "end_date": nationalityEndDate.text.isNotEmpty
              ? convertDateToIson(nationalityEndDate.text)
              : null,
        }),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        NationalityModel updatedNationality = NationalityModel.fromJson(
          decoded['updated_nationality'],
        );
        int index = nationalityList.indexWhere((nat) => nat.id == id);
        if (index != -1) {
          nationalityList[index] = updatedNationality;
          nationalityList.refresh();
        }
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await updateNationality(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      addingNewEmployeeNationalityValue.value = false;
      Get.back();
    } catch (e) {
      addingNewEmployeeNationalityValue.value = false;
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  Future<void> deleteNationality(String id) async {
    try {
      if (currentEmployeeId.value.isEmpty) {
        alertMessage(context: Get.context!, content: "Save doc first please");
        return;
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/employees/delete_employee_nationality/$id',
      );
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        nationalityList.removeWhere((add) => add.id == id);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteNationality(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
    } catch (e) {
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  // ======================== phone section ========================
  Future<void> addNewPhone() async {
    try {
      if (currentEmployeeId.value.isEmpty) {
        alertMessage(context: Get.context!, content: "Save doc first please");
        return;
      }
      addingNewEmployeePhoneValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/employees/add_employee_phone/${currentEmployeeId.value}',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "type": phoneTypeId.value,
          "phone": phoneNumber.text,
        }),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        PhoneModel newPhone = PhoneModel.fromJson(decoded['new_phone']);
        phonesList.insert(0, newPhone);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewPhone();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      addingNewEmployeePhoneValue.value = false;
      Get.back();
    } catch (e) {
      addingNewEmployeePhoneValue.value = false;
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  Future<void> updatePhone(String id) async {
    try {
      if (currentEmployeeId.value.isEmpty) {
        alertMessage(context: Get.context!, content: "Save doc first please");
        return;
      }
      addingNewEmployeePhoneValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/employees/edit_employee_phone/$id');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "type": phoneTypeId.value,
          "phone": phoneNumber.text,
        }),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        PhoneModel updatedPhone = PhoneModel.fromJson(decoded['updated_phone']);
        int index = phonesList.indexWhere((ph) => ph.id == id);
        if (index != -1) {
          phonesList[index] = updatedPhone;
          phonesList.refresh();
        }
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await updatePhone(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      addingNewEmployeePhoneValue.value = false;
      Get.back();
    } catch (e) {
      addingNewEmployeePhoneValue.value = false;
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  Future<void> deletePhone(String id) async {
    try {
      if (currentEmployeeId.value.isEmpty) {
        alertMessage(context: Get.context!, content: "Save doc first please");
        return;
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/employees/delete_employee_phone/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        phonesList.removeWhere((ph) => ph.id == id);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deletePhone(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
    } catch (e) {
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  // ======================== email section ========================
  Future<void> addNewEmail() async {
    try {
      if (currentEmployeeId.value.isEmpty) {
        alertMessage(context: Get.context!, content: "Save doc first please");
        return;
      }
      addingNewEmployeeEmailValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/employees/add_employee_email/${currentEmployeeId.value}',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "type": emailTypeId.value,
          "email": emailAddress.text,
        }),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        EmailModel newEmail = EmailModel.fromJson(decoded['new_email']);
        emailsList.insert(0, newEmail);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewEmail();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      addingNewEmployeeEmailValue.value = false;
      Get.back();
    } catch (e) {
      addingNewEmployeeEmailValue.value = false;
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  Future<void> updateEmail(String id) async {
    try {
      if (currentEmployeeId.value.isEmpty) {
        alertMessage(context: Get.context!, content: "Save doc first please");
        return;
      }
      addingNewEmployeeEmailValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/employees/edit_employee_email/$id');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "type": emailTypeId.value,
          "phone": emailAddress.text,
        }),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        EmailModel updatedEmail = EmailModel.fromJson(decoded['updated_phone']);
        int index = emailsList.indexWhere((ph) => ph.id == id);
        if (index != -1) {
          emailsList[index] = updatedEmail;
          emailsList.refresh();
        }
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await updateEmail(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      addingNewEmployeeEmailValue.value = false;
      Get.back();
    } catch (e) {
      addingNewEmployeeEmailValue.value = false;
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  Future<void> deleteEmail(String id) async {
    try {
      if (currentEmployeeId.value.isEmpty) {
        alertMessage(context: Get.context!, content: "Save doc first please");
        return;
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/employees/delete_employee_email/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        emailsList.removeWhere((em) => em.id == id);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteEmail(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
    } catch (e) {
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  Future<void> pickImage() async {
    try {
      // Use file_picker to pick an image file
      final result = await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        imageBytes = file.bytes;
        update();
      }
    } catch (e) {
      ///
    }
  }

  // ======================== contacts and relatives section ========================
  Future<void> getContactAndRelative() async {
    try {
      if (currentEmployeeId.value.isEmpty) {
        alertMessage(context: Get.context!, content: "Save doc first please");
        return;
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/employees/get_employee_contact_and_relative/${currentEmployeeId.value}',
      );
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List newContact = decoded['new_contact'];
        contactsAndRelativesList.assignAll(
          newContact
              .map((item) => ContactsAndRelativesModel.fromJson(item))
              .toList(),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getContactAndRelative();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      Get.back();
    } catch (e) {
      // print(e);
    }
  }

  Future<void> addNewContactAndRelative() async {
    try {
      if (currentEmployeeId.value.isEmpty) {
        alertMessage(context: Get.context!, content: "Save doc first please");
        return;
      }
      addingNewContactAndRelativesValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/employees/add_new_employee_contact_and_relative/${currentEmployeeId.value}',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "full_name": contactAndRelativeFullName.text,
          "relationship": contactAndRelativeRelationshipId.value,
          "gender": contactAndRelativeGenderId.value,
          "nationality": contactAndRelativeNationalityId.value,
          "phone_number": contactAndRelativePhoneNumber.text,
          "date_of_birth": convertDateToIson(
            contactAndRelativeDateOfBirth.text,
          ),
          "email_address": contactAndRelativeEmailAddress.text,
          "note": contactAndRelativeNotes.text,
          "is_emergency": isThisContactAnEmergencyConact.value,
        }),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        ContactsAndRelativesModel newContact =
            ContactsAndRelativesModel.fromJson(decoded['new_contact']);
        contactsAndRelativesList.insert(0, newContact);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewContactAndRelative();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      addingNewContactAndRelativesValue.value = false;
      Get.back();
    } catch (e) {
      addingNewContactAndRelativesValue.value = false;
    }
  }
}
