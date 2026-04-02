import 'dart:convert';
import 'dart:typed_data';

import 'package:datahubai/Models/employees/email_model.dart';
import 'package:datahubai/Models/employees/nationality_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../Models/employees/employees_model.dart';
import '../../Models/employees/phone_model.dart';
import '../../Models/entity information/entity_information_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import 'main_screen_contro.dart';
import 'websocket_controller.dart';

class EmployeesController extends GetxController {
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
  RxList<EntityAddress> addressesList = RxList<EntityAddress>([]);
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
  RxString employeeStatusForBar = RxString('');
  RxString employeeGenderId = RxString('');
  RxString employeeCountryOfBirthId = RxString('');
  RxString query = RxString('');
  RxBool isScreenLoding = RxBool(false);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  RxBool isTimeSheetsSelected = RxBool(false);
  RxBool isReceivingSelected = RxBool(false);
  RxBool isIssueingSelected = RxBool(false);
  String backendUrl = backendTestURI;
  RxList<EmployeesModel> allEmployees = RxList<EmployeesModel>([]);
  RxList<EmployeesModel> filteredEmployees = RxList<EmployeesModel>([]);
  WebSocketService ws = Get.find<WebSocketService>();
  final Uuid _uuid = const Uuid();
  Uint8List? imageBytes;
  RxInt initStatusPickersValue = RxInt(1);
  RxString employeeImage = RxString('');

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
    // getAllEmployees();
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
          allEmployees.add(newCounter);
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
        isScreenLoding.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllEmployees();
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
    }
  }

  Future<void> addNewEmployee() async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/employees/create_employee');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": employeeName.text,
          "gender": employeeGenderId.value,
          "nationality": employeeNamtionalityId.value,
          "date_of_birth": convertDateToIson(employeeDateOfBirth.text),
          "martial_status": employeeMaritalStatusId.value,

          "email": employeeEmail.text,
          "phone": employeePhoneNumber.text,
          "address": employeeAddress.text,
          "emergency_contact_name": employeeEmergencyName.text,
          "emergency_contact_number": employeeEmergencyPhoneNumber.text,
          "job_title": jobTitle.text,
          "hire_date": convertDateToIson(hireDate.text),
          "end_date": convertDateToIson(endDate.text),
          "status": employeeStatusId.value,
        }),
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewEmployee();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  Future<void> updateEmployee(String id) async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/employees/update_employee/$id');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": employeeName.text,
          "gender": employeeGenderId.value,
          "nationality": employeeNamtionalityId.value,
          "date_of_birth": convertDateToIson(employeeDateOfBirth.text),
          "martial_status": employeeMaritalStatusId.value,

          "email": employeeEmail.text,
          "phone": employeePhoneNumber.text,
          "address": employeeAddress.text,
          "emergency_contact_name": employeeEmergencyName.text,
          "emergency_contact_number": employeeEmergencyPhoneNumber.text,
          "job_title": jobTitle.text,
          "hire_date": convertDateToIson(hireDate.text),
          "end_date": convertDateToIson(endDate.text),
          "status": employeeStatusId.value,
        }),
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await updateEmployee(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      addingNewValue.value = false;
      Get.back();
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

  void clearValues() {
    employeeName.clear();
    // employeeNumber.clear();

    employeeGender.clear();
    employeeDateOfBirth.clear();
    employeeNationality.clear();
    employeeMaritalStatus.clear();
    employeeEmail.clear();
    employeePhoneNumber.clear();
    employeeEmergencyPhoneNumber.clear();
    employeeEmergencyName.clear();
    employeeAddress.clear();
    jobTitle.clear();
    hireDate.clear();
    endDate.clear();
    employeeStatus.clear();
    employeeNamtionalityId.value = '';
    employeeMaritalStatusId.value = '';
    employeeStatusId.value = '';
    employeeGenderId.value = '';
    isTimeSheetsSelected.value = false;
    isReceivingSelected.value = false;
    isIssueingSelected.value = false;
    employeeStatusForBar.value = '';
  }

  void loadValues(EmployeesModel data) {
    employeeStatusForBar.value = data.statusType ?? '';
    employeeName.text = data.name ?? '';
    // employeeNumber.text = data.employeeNumber ?? '';
    employeeGender.text = data.genderType ?? '';
    employeeDateOfBirth.text = textToDate(data.dateOfBirth);
    employeeNationality.text = data.nationalityName ?? '';
    employeeMaritalStatus.text = data.martialStatusType ?? '';
    employeeEmail.text = data.email ?? '';
    employeePhoneNumber.text = data.phone ?? '';
    employeeEmergencyPhoneNumber.text = data.emergencyContactNumber ?? '';
    employeeEmergencyName.text = data.emergencyContactName ?? '';
    employeeAddress.text = data.address ?? '';
    jobTitle.text = data.jobTitle ?? '';
    hireDate.text = textToDate(data.hireDate);
    endDate.text = textToDate(data.endDate);
    employeeStatus.text = data.statusType ?? '';

    employeeNamtionalityId.value = data.nationality ?? '';
    employeeMaritalStatusId.value = data.martialStatus ?? '';
    employeeStatusId.value = data.status ?? '';
    employeeGenderId.value = data.gender ?? '';
  }

  // ======================== address section ========================
  void addNewAddress() {
    final String uniqueId = _uuid.v4();

    addressesList.add(
      EntityAddress(
        id: uniqueId,
        line: line.text,
        country: country.text,
        countryId: countryId.value,
        city: city.text,
        cityId: cityId.value,
      ),
    );
    Get.back();
  }

  void updateAddress(String id) {
    int index = addressesList.indexWhere((add) => add.id == id);
    if (index != -1) {
      addressesList[index] = EntityAddress(
        id: addressesList[index].id,
        line: line.text,
        country: country.text,
        countryId: countryId.value,
        city: city.text,
        cityId: cityId.value,
      );
    }
    addressesList.refresh();
    Get.back();
  }

  void deleteAddress(String id) {
    addressesList.removeWhere((add) => add.id == id);
  }

  // ======================== nationality section ========================
  void addNewNationality() {
    final String uniqueId = _uuid.v4();

    nationalityList.add(
      NationalityModel(
        id: uniqueId,
        nationality: nationality.text,
        nationalityId: nationalityId.value,
        startDate: nationalityStartDate.text,
        endDate: nationalityEndDate.text,
      ),
    );
    Get.back();
  }

  void updateNationality(String id) {
    int index = nationalityList.indexWhere((nat) => nat.id == id);
    if (index != -1) {
      nationalityList[index] = NationalityModel(
        id: nationalityList[index].id,
        nationality: nationality.text,
        nationalityId: nationalityId.value,
        startDate: nationalityStartDate.text,
        endDate: nationalityEndDate.text,
      );
    }
    nationalityList.refresh();
    Get.back();
  }

  void deleteNationality(String id) {
    nationalityList.removeWhere((nat) => nat.id == id);
  }

  // ======================== phone section ========================
  void addNewPhone() {
    final String uniqueId = _uuid.v4();

    phonesList.add(
      PhoneModel(
        id: uniqueId,
        phone: phoneNumber.text,
        typeId: phoneTypeId.value,
        type: phoneType.text,
      ),
    );
    Get.back();
  }

  void updatePhone(String id) {
    int index = phonesList.indexWhere((nat) => nat.id == id);
    if (index != -1) {
      phonesList[index] = PhoneModel(
        id: phonesList[index].id,
        phone: phoneNumber.text,
        typeId: phoneTypeId.value,
        type: phoneType.text,
      );
    }
    phonesList.refresh();
    Get.back();
  }

  void deletePhone(String id) {
    phonesList.removeWhere((nat) => nat.id == id);
  }

  // ======================== email section ========================
  void addNewEmail() {
    final String uniqueId = _uuid.v4();

    emailsList.add(
      EmailModel(
        id: uniqueId,
        email: emailAddress.text,
        typeId: emailTypeId.value,
        type: emailType.text,
      ),
    );
    Get.back();
  }

  void updateEmail(String id) {
    int index = emailsList.indexWhere((nat) => nat.id == id);
    if (index != -1) {
      emailsList[index] = EmailModel(
        id: emailsList[index].id,
        email: emailAddress.text,
        typeId: emailTypeId.value,
        type: emailType.text,
      );
    }
    emailsList.refresh();
    Get.back();
  }

  void deleteEmail(String id) {
    emailsList.removeWhere((nat) => nat.id == id);
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
}
