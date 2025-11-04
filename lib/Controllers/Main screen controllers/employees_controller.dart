import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/employees/employees_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import 'main_screen_contro.dart';
import 'websocket_controller.dart';

class EmployeesController extends GetxController {
  TextEditingController employeeName = TextEditingController();
  TextEditingController employeeNumber = TextEditingController();
  TextEditingController employeeGender = TextEditingController();
  TextEditingController employeeDateOfBirth = TextEditingController();
  TextEditingController employeeNationality = TextEditingController();
  TextEditingController employeeMaritalStatus = TextEditingController();
  TextEditingController employeeNationalIdOrPassportNumber =
      TextEditingController();
  TextEditingController employeeEmail = TextEditingController();
  TextEditingController employeePhoneNumber = TextEditingController();
  TextEditingController employeeEmergencyPhoneNumber = TextEditingController();
  TextEditingController employeeEmergencyName = TextEditingController();
  TextEditingController employeeAddress = TextEditingController();
  TextEditingController jobTitle = TextEditingController();
  TextEditingController hireDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  TextEditingController jobDescription = TextEditingController();
  TextEditingController employeeStatus = TextEditingController();

  RxString employeeNamtionalityId = RxString('');
  RxString employeeMaritalStatusId = RxString('');
  RxString employeeStatusId = RxString('');
  RxString employeeStatusForBar = RxString('');
  RxString employeeGenderId = RxString('');
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(false);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  RxBool isTimeSheetsSelected = RxBool(false);
  RxBool isJobCardsSelected = RxBool(false);
  RxBool isReceivingSelected = RxBool(false);
  RxBool isIssueingSelected = RxBool(false);
  RxList<String> department = RxList<String>([]);
  String backendUrl = backendTestURI;
  RxList<EmployeesModel> allEmployees = RxList<EmployeesModel>([]);
  RxList<EmployeesModel> filteredEmployees = RxList<EmployeesModel>([]);
  WebSocketService ws = Get.find<WebSocketService>();

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
          "national_id_or_passport_number":
              employeeNationalIdOrPassportNumber.text,
          "email": employeeEmail.text,
          "phone": employeePhoneNumber.text,
          "address": employeeAddress.text,
          "emergency_contact_name": employeeEmergencyName.text,
          "emergency_contact_number": employeeEmergencyPhoneNumber.text,
          "job_title": jobTitle.text,
          "hire_date": convertDateToIson(hireDate.text),
          "end_date": convertDateToIson(endDate.text),
          "job_description": jobDescription.text,
          "status": employeeStatusId.value,
          "department": department,
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
          "national_id_or_passport_number":
              employeeNationalIdOrPassportNumber.text,
          "email": employeeEmail.text,
          "phone": employeePhoneNumber.text,
          "address": employeeAddress.text,
          "emergency_contact_name": employeeEmergencyName.text,
          "emergency_contact_number": employeeEmergencyPhoneNumber.text,
          "job_title": jobTitle.text,
          "hire_date": convertDateToIson(hireDate.text),
          "end_date": convertDateToIson(endDate.text),
          "job_description": jobDescription.text,
          "status": employeeStatusId.value,
          "department": department,
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


  void selectDepartment(String dep, bool value) {
    if (dep == "Time Sheets") {
      isTimeSheetsSelected.value = value;
      if (value) {
        department.add("Time Sheets");
      } else {
        department.remove("Time Sheets");
      }
    } else if (dep == "Job Cards") {
      isJobCardsSelected.value = value;
      if (value) {
        department.add("Job Cards");
      } else {
        department.remove("Job Cards");
      }
    } else if (dep == "Receiving") {
      isReceivingSelected.value = value;
      if (value) {
        department.add("Receiving");
      } else {
        department.remove("Receiving");
      }
    } else if (dep == "Issueing") {
      isIssueingSelected.value = value;
      if (value) {
        department.add("Issueing");
      } else {
        department.remove("Issueing");
      }
    }
  }

  void clearValues() {
    employeeName.clear();
    employeeNumber.clear();
    employeeGender.clear();
    employeeDateOfBirth.clear();
    employeeNationality.clear();
    employeeMaritalStatus.clear();
    employeeNationalIdOrPassportNumber.clear();
    employeeEmail.clear();
    employeePhoneNumber.clear();
    employeeEmergencyPhoneNumber.clear();
    employeeEmergencyName.clear();
    employeeAddress.clear();
    jobTitle.clear();
    hireDate.clear();
    endDate.clear();
    jobDescription.clear();
    employeeStatus.clear();
    department.clear();
    employeeNamtionalityId.value = '';
    employeeMaritalStatusId.value = '';
    employeeStatusId.value = '';
    employeeGenderId.value = '';
    isTimeSheetsSelected.value = false;
    isJobCardsSelected.value = false;
    isReceivingSelected.value = false;
    isIssueingSelected.value = false;
    employeeStatusForBar.value = '';
  }

  void loadValues(EmployeesModel data) {
    employeeStatusForBar.value = data.statusType ?? '';
    employeeName.text = data.name ?? '';
    employeeNumber.text = data.employeeNumber ?? '';
    employeeGender.text = data.genderType ?? '';
    employeeDateOfBirth.text = textToDate(data.dateOfBirth);
    employeeNationality.text = data.nationalityName ?? '';
    employeeMaritalStatus.text = data.martialStatusType ?? '';
    employeeNationalIdOrPassportNumber.text =
        data.nationalIdOrPassportNumber ?? '';
    employeeEmail.text = data.email ?? '';
    employeePhoneNumber.text = data.phone ?? '';
    employeeEmergencyPhoneNumber.text = data.emergencyContactNumber ?? '';
    employeeEmergencyName.text = data.emergencyContactName ?? '';
    employeeAddress.text = data.address ?? '';
    jobTitle.text = data.jobTitle ?? '';
    hireDate.text = textToDate(data.hireDate);
    endDate.text = textToDate(data.endDate);
    jobDescription.text = data.jobDescription ?? '';
    employeeStatus.text = data.statusType ?? '';
    department.assignAll(data.department ?? []);
    if (department.contains("Time Sheets")) {
      isTimeSheetsSelected.value = true;
    } else {
      isTimeSheetsSelected.value = false;
    }
    if (department.contains("Job Cards")) {
      isJobCardsSelected.value = true;
    } else {
      isJobCardsSelected.value = false;
    }
    if (department.contains("Receiving")) {
      isReceivingSelected.value = true;
    } else {
      isReceivingSelected.value = false;
    }
    if (department.contains("Issueing")) {
      isIssueingSelected.value = true;
    } else {
      isIssueingSelected.value = false;
    }
    employeeNamtionalityId.value = data.nationality ?? '';
    employeeMaritalStatusId.value = data.martialStatus ?? '';
    employeeStatusId.value = data.status ?? '';
    employeeGenderId.value = data.gender ?? '';
  }

  // this function is to filter the search results for web
  void filterEmployees() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredEmployees.clear();
    } else {
      filteredEmployees.assignAll(
        allEmployees.where((employee) {
          return employee.name.toString().toLowerCase().contains(query) ||
              employee.employeeNumber.toString().toLowerCase().contains(
                query,
              ) ||
              employee.jobTitle.toString().toLowerCase().contains(query) ||
              employee.statusType.toString().toLowerCase().contains(query) ||
              textToDate(
                employee.hireDate,
              ).toString().toLowerCase().contains(query) ||
              textToDate(
                employee.endDate,
              ).toString().toLowerCase().contains(query);
        }).toList(),
      );
    }
  }
}
