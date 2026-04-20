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
import '../../Models/employees/employee_account_banks_model.dart';
import '../../Models/employees/employee_leaves_model.dart';
import '../../Models/employees/employees_model.dart';
import '../../Models/employees/payroll_elements_model.dart';
import '../../Models/employees/phone_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import 'main_screen_contro.dart';
import 'websocket_controller.dart';

class EmployeesController extends GetxController {
  Rx<TextEditingController> search = TextEditingController().obs;
  Rx<TextEditingController> contactsAndRelativesSearch =
      TextEditingController().obs;
  Rx<TextEditingController> leavesSearch = TextEditingController().obs;
  final leavesSearchQuery = ''.obs;
  TextEditingController employeeName = TextEditingController();
  TextEditingController employeeNameFilter = TextEditingController();
  TextEditingController employerFilter = TextEditingController();
  TextEditingController departmentFilter = TextEditingController();
  TextEditingController jobTitleFilter = TextEditingController();
  TextEditingController locationFilter = TextEditingController();
  RxString locationIdFilter = RxString('');
  RxString jobTitleIdFilter = RxString('');
  RxString departmentIdFilter = RxString('');
  RxString employerIdFilter = RxString('');
  RxString employeeNameFilterId = RxString('');
  TextEditingController genderFilter = TextEditingController();
  // TextEditingController employeeNumber = TextEditingController();
  TextEditingController employeeGender = TextEditingController();
  TextEditingController employeeDateOfBirth = TextEditingController();
  TextEditingController employeePlaceOfBirth = TextEditingController();
  RxString personType = RxString('');
  TextEditingController employeeCountryOfBirth = TextEditingController();
  TextEditingController employeeNationality = TextEditingController();
  TextEditingController employeeMaritalStatus = TextEditingController();
  TextEditingController employeeLegislation = TextEditingController();
  RxString employeeLegislationId = RxString('');
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
  RxString employeeStatus = RxString('');
  TextEditingController jobEmployer = TextEditingController();
  TextEditingController jobDepartment = TextEditingController();
  TextEditingController reportingManager = TextEditingController();
  TextEditingController payroll = TextEditingController();
  RxString payrollId = RxString('');
  RxString reportingManagerId = RxString('');
  RxString jobDepartmentId = RxString('');
  RxString jobEmployerId = RxString('');
  RxList<EmployeeAddressModel> addressesList = RxList<EmployeeAddressModel>([]);
  RxList<PhoneModel> phonesList = RxList<PhoneModel>([]);
  RxList<EmployeePayrollElementsModel> payrollElementsList =
      RxList<EmployeePayrollElementsModel>([]);
  RxList<EmailModel> emailsList = RxList<EmailModel>([]);
  RxList<EmployeeAccountBanksModel> bankAccountsList =
      RxList<EmployeeAccountBanksModel>([]);
  RxList<NationalityModel> nationalityList = RxList<NationalityModel>([]);
  TextEditingController country = TextEditingController();
  TextEditingController employeePayrollElementName = TextEditingController();
  TextEditingController employeePayrollElementvalue = TextEditingController();
  TextEditingController employeePayrollElementStartDate =
      TextEditingController();
  TextEditingController employeePayrollElementEndDate = TextEditingController();
  TextEditingController employeePayrollElementNote = TextEditingController();
  RxString employeePayrollElementNameId = RxString('');
  TextEditingController line = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController nationality = TextEditingController();
  TextEditingController phoneType = TextEditingController();
  TextEditingController emailType = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController emailAddress = TextEditingController();
  TextEditingController employeeBankName = TextEditingController();
  RxString employeeBankNameId = RxString('');
  TextEditingController employeeAccountNumber = TextEditingController();
  TextEditingController employeeIBAN = TextEditingController();
  TextEditingController employeeSWIFTCode = TextEditingController();
  RxString nationalityId = RxString('');
  RxString phoneTypeId = RxString('');
  RxString emailTypeId = RxString('');
  TextEditingController nationalityStartDate = TextEditingController();
  TextEditingController nationalityEndDate = TextEditingController();
  RxString countryId = RxString('');
  RxString cityId = RxString('');
  RxString employeeNamtionalityId = RxString('');
  RxString employeeMaritalStatusId = RxString('');
  RxString employeeGenderId = RxString('');
  RxString employeeCountryOfBirthId = RxString('');
  RxString query = RxString('');
  RxString contactsAndRelativesQuery = RxString('');
  RxBool isScreenLoding = RxBool(false);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  RxBool addingNewContactAndRelativesValue = RxBool(false);
  RxBool addingNewLeaveValue = RxBool(false);
  RxBool addingNewEmployeeAddressValue = RxBool(false);
  RxBool addingNewEmployeeLeaveValue = RxBool(false);
  RxBool addingNewEmployeePhoneValue = RxBool(false);
  RxBool addingNewEmployeeEmailValue = RxBool(false);
  RxBool addingNewEmployeeBankAccount = RxBool(false);
  RxBool addingNewEmployeeNationalityValue = RxBool(false);
  String backendUrl = backendTestURI;
  RxList<EmployeesModel> allEmployees = RxList<EmployeesModel>([]);
  WebSocketService ws = Get.find<WebSocketService>();
  Uint8List? imageBytes;
  RxInt initStatusPickersValue = RxInt(1);
  RxInt initTypePickersValue = RxInt(1);
  RxString employeeImage = RxString('');
  RxString currentEmployeeId = RxString('');
  // =================== Contacts And Relatives Section ===================
  RxList<ContactsAndRelativesModel> contactsAndRelativesList =
      RxList<ContactsAndRelativesModel>([]);
  RxList<ContactsAndRelativesModel> filteredContactsAndRelativesList =
      RxList<ContactsAndRelativesModel>([]);
  TextEditingController contactAndRelativeFullName = TextEditingController();
  RxList<EmployeeLeavesModel> leavesList = RxList<EmployeeLeavesModel>([]);
  RxList<EmployeeLeavesModel> filteredLeavesList = RxList<EmployeeLeavesModel>(
    [],
  );
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
  TextEditingController typeFilter = TextEditingController();

  // =================== Leaves Section ===================
  TextEditingController employeeLeaveType = TextEditingController();
  RxString employeeLeaveTypeId = RxString('');
  RxString employeeLeaveTypeTypeToCheckForHowToCalculateTheHolidays = RxString(
    '',
  );
  RxString employeeLeaveStatus = RxString('');
  TextEditingController employeeLeaveStartTime = TextEditingController();
  TextEditingController employeeLeaveEndTime = TextEditingController();
  TextEditingController employeeLeaveNumberOfDays = TextEditingController();
  TextEditingController employeeLeaveNote = TextEditingController();
  RxBool employeeLeavePayInAdvance = RxBool(false);

  List<Widget> contactsTabs = const [
    Tab(text: 'Address'),
    Tab(text: 'Nationality'),
    Tab(text: 'Phones'),
    Tab(text: 'Social Contacts'),
    Tab(text: 'Bank Accounts'),
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

  Future<Map<String, dynamic>> getAllLegislations() async {
    return await helper.getAllLegislations();
  }

  Future<Map<String, dynamic>> getAllPayrollElements() async {
    return await helper.getAllPayrollElements();
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

  Future<Map<String, dynamic>> getEmployeeWorkingDays(
    String employeeId,
    Map body,
  ) async {
    return await helper.getEmployeeWorkingDays(employeeId, body);
  }

  Future<Map<String, dynamic>> getAllLeaveTypes() async {
    return await helper.getAllLeaveTypes();
  }

  Future<Map<String, dynamic>> getPhoneTypes() async {
    return await helper.getAllListValues('CONTACT_TYPES');
  }

  Future<Map<String, dynamic>> getAkkBanksNames() async {
    return await helper.getAllListValues('BANKS');
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

  Future<Map<String, dynamic>> getAllPayrolls() async {
    return await helper.getPayrolls();
  }

  Future getCurrentEmployeeLeaveStatus(String id) async {
    return await helper.getEmployeeLeaveStatus(id);
  }

  void onChooseForTypePicker(int i) {
    switch (i) {
      case 1:
        initTypePickersValue.value = 1;
        typeFilter.clear();
        filterSearch();
        break;
      case 2:
        initTypePickersValue.value = 2;
        typeFilter.text = 'EMPLOYEE';
        filterSearch();
        break;
      case 3:
        initTypePickersValue.value = 3;
        typeFilter.text = 'APPLICANT';
        filterSearch();
        break;
      case 4:
        initTypePickersValue.value = 3;
        typeFilter.text = 'EX EMPLOYEE';
        filterSearch();
        break;

      default:
    }
  }

  // this function is to get all list values by code for drop down menu
  Future<Map<String, dynamic>> getAllReporingManagers(
    String employeeId,
    String employerId,
  ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendUrl/employees/get_all_reporting_managers');
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "employer_id": employerId,
          "current_employee_id": employeeId,
        }),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List<dynamic> jsonData = decoded["result"];
        Map<String, dynamic> map = {for (var rep in jsonData) rep['_id']: rep};
        return map;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await getAllReporingManagers(employeeId, employerId);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
        return {};
      } else if (response.statusCode == 401) {
        logout();
        return {};
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
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

  Future<void> onSelectLeaveEndDate() async {
    Map workingDays = await getEmployeeWorkingDays(currentEmployeeId.value, {
      "start_date": convertDateToIson(employeeLeaveStartTime.text),
      "end_date": convertDateToIson(employeeLeaveEndTime.text),
      "leave_type":
          employeeLeaveTypeTypeToCheckForHowToCalculateTheHolidays.value,
    });
    employeeLeaveNumberOfDays.text = workingDays.containsKey('working_days')
        ? workingDays['working_days'].toString()
        : '';

    if (employeeLeaveNumberOfDays.text.isEmpty) {
      employeeLeaveEndTime.clear();
    }
  }

  void filterSearch() async {
    Map<String, dynamic> body = {};
    if (employeeNameFilter.text.isNotEmpty) {
      body["name"] = employeeNameFilter.text;
    }
    if (employerIdFilter.value.isNotEmpty) {
      body["employer"] = employerIdFilter.value;
    }
    if (departmentIdFilter.value.isNotEmpty) {
      body["department"] = departmentIdFilter.value;
    }
    if (jobTitleIdFilter.value.isNotEmpty) {
      body["job_title"] = jobTitleIdFilter.value;
    }
    if (locationIdFilter.value.isNotEmpty) {
      body["location"] = locationIdFilter.value;
    }
    if (typeFilter.text.isNotEmpty) {
      body["type"] = typeFilter.text;
    }
    if (body.isNotEmpty) {
      await searchEngine(body);
    } else {
      await searchEngine({"all": true});
    }
  }

  Future<void> searchEngine(Map<String, dynamic> body) async {
    try {
      isScreenLoding.value = true;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/employees/search_engine_for_employees');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
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
          await searchEngine(body);
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
        "legislation": employeeLegislationId.value,
        "martial_status": employeeMaritalStatusId.value,
        "person_type": personType.value,
        "status": employeeStatus.value,
        "payroll": payrollId.value,
        "employer": jobEmployerId.value,
        "department": jobDepartmentId.value,
        "job_title": jobTitleId.value,
        "location": jobLocationId.value,
        "hire_date": hireDate.text.isNotEmpty
            ? convertDateToIson(hireDate.text).toString()
            : "",
        "end_date": endDate.text.isNotEmpty
            ? convertDateToIson(endDate.text).toString()
            : "",
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
    payroll.clear();
    payrollId.value = '';
    currentEmployeeId.value = '';
    payrollElementsList.clear();
    employeeImage.value = '';
    bankAccountsList.clear();
    employeeName.clear();
    employeeCountryOfBirth.clear();
    employeeCountryOfBirthId.value = '';
    employeePlaceOfBirth.clear();
    employeeDateOfBirth.clear();
    employeeGender.clear();
    employeeGenderId.value = '';
    employeeMaritalStatus.clear();
    employeeMaritalStatusId.value = '';
    personType.value = isEmployee == true ? 'Employee' : 'Applicant';
    employeeStatus.value = '';
    jobEmployer.clear();
    jobEmployerId.value = '';
    employeeLegislationId.value = '';
    employeeLegislation.clear();
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
    payroll.text = employee.payrollName ?? '';
    payrollId.value = employee.payroll ?? '';
    employeeImage.value = employee.personImageUrl ?? '';
    currentEmployeeId.value = employee.id ?? '';
    employeeName.text = employee.fullName ?? '';
    employeeLegislationId.value = employee.legislation ?? '';
    employeeLegislation.text = employee.legislationName ?? '';
    employeeCountryOfBirth.text = employee.countryOfBirthName ?? '';
    employeeCountryOfBirthId.value = employee.countryOfBirth ?? '';
    employeePlaceOfBirth.text = employee.placeOfBirth ?? '';
    employeeDateOfBirth.text = textToDate(employee.dateOfBirth);
    employeeGender.text = employee.genderName ?? '';
    employeeGenderId.value = employee.gender ?? '';
    employeeMaritalStatus.text = employee.martialStatusName ?? '';
    employeeMaritalStatusId.value = employee.martialStatus ?? '';
    personType.value = employee.personType ?? '';
    employeeStatus.value = employee.status ?? '';
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
    payrollElementsList.assignAll(employee.payrollsList ?? []);
    bankAccountsList.assignAll(employee.bankAccountsList ?? []);
  }

  // ======================== leaves section ========================

  Future<void> getAllEmployeeLeave() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/employees/get_all_employee_leaves/${currentEmployeeId.value}',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List leaves = decoded['all_leaves'];

        leavesList.assignAll(
          leaves.map((l) => EmployeeLeavesModel.fromJson(l)),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllEmployeeLeave();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
    } catch (e) {
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  Future<void> addNewEmployeeLeave() async {
    try {
      addingNewEmployeeLeaveValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/employees/add_new_employee_leave/${currentEmployeeId.value}',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "leave_type": employeeLeaveTypeId.value,
          "start_date": employeeLeaveStartTime.text.isNotEmpty
              ? convertDateToIson(employeeLeaveStartTime.text)
              : null,
          "end_date": employeeLeaveEndTime.text.isNotEmpty
              ? convertDateToIson(employeeLeaveEndTime.text)
              : null,
          "number_of_days": employeeLeaveNumberOfDays.text.isNotEmpty
              ? int.tryParse(employeeLeaveNumberOfDays.text)
              : 0,
          "note": employeeLeaveNote.text,
          "pay_in_advance": employeeLeavePayInAdvance.value,
        }),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        EmployeeLeavesModel newLeave = EmployeeLeavesModel.fromJson(
          decoded['new_leave'],
        );
        leavesList.insert(0, newLeave);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewEmployeeLeave();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      addingNewEmployeeLeaveValue.value = false;
      Get.back();
    } catch (e) {
      addingNewEmployeeLeaveValue.value = false;
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  Future<void> updateEmployeeLeave(String id) async {
    try {
      String leaveStatus = await getCurrentEmployeeLeaveStatus(id);
      if ((leaveStatus != 'New')) {
        alertMessage(
          context: Get.context!,
          content: 'Only new jobs can be edit',
        );
        return;
      }
      addingNewEmployeeLeaveValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/employees/update_employee_leave/$id');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "leave_type": employeeLeaveTypeId.value,
          "start_date": employeeLeaveStartTime.text.isNotEmpty
              ? convertDateToIson(employeeLeaveStartTime.text)
              : null,
          "status": employeeLeaveStatus.value,
          "end_date": employeeLeaveEndTime.text.isNotEmpty
              ? convertDateToIson(employeeLeaveEndTime.text)
              : null,
          "number_of_days": employeeLeaveNumberOfDays.text.isNotEmpty
              ? int.tryParse(employeeLeaveNumberOfDays.text)
              : 0,
          "note": employeeLeaveNote.text,
          "pay_in_advance": employeeLeavePayInAdvance.value,
        }),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        EmployeeLeavesModel updatedLeave = EmployeeLeavesModel.fromJson(
          decoded['update_leave'],
        );
        int index = leavesList.indexWhere((i) => i.id == id);
        if (index != -1) {
          leavesList[index] = updatedLeave;
        }
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await updateEmployeeLeave(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      addingNewEmployeeLeaveValue.value = false;
      Get.back();
    } catch (e) {
      addingNewEmployeeLeaveValue.value = false;
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  Future<void> deleteEmployeeLeave(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/employees/delete_employee_leave/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        leavesList.removeWhere((add) => add.id == id);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteEmployeeLeave(id);
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

  void filterEmployeeLeaves([String? value]) {
    final query = (value ?? leavesSearch.value.text).trim().toLowerCase();
    leavesSearchQuery.value = query;
    if (query.isEmpty) {
      filteredLeavesList.clear();
      return;
    } else {
      filteredLeavesList.assignAll(
        leavesList.where((leave) {
          return (leave.leaveTypeName ?? '').toLowerCase().contains(query) ||
              (leave.status ?? '').toLowerCase().contains(query) ||
              textToDate(leave.startDate).toLowerCase().contains(query) ||
              textToDate(leave.endDate).toLowerCase().contains(query) ||
              (leave.numberOdDays?.toString() ?? '').contains(query) ||
              (leave.note ?? '').toLowerCase().contains(query);
        }).toList(),
      );
    }
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
      }
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

  // ============================ bank accounts section =============================
  Future<void> addNewEmployeeBankAccount() async {
    try {
      if (currentEmployeeId.value.isEmpty) {
        alertMessage(context: Get.context!, content: "Save doc first please");
        return;
      }
      addingNewEmployeeBankAccount.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/employees/add_employee_bank_account/${currentEmployeeId.value}',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "bank_name": employeeBankNameId.value,
          "account_number": employeeAccountNumber.text,
          "iban": employeeIBAN.text,
          "swift_code": employeeSWIFTCode.text,
        }),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        EmployeeAccountBanksModel newBankAccount =
            EmployeeAccountBanksModel.fromJson(decoded['new_bank_account']);
        bankAccountsList.insert(0, newBankAccount);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewEmployeeBankAccount();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      addingNewEmployeeBankAccount.value = false;
      Get.back();
    } catch (e) {
      addingNewEmployeeBankAccount.value = false;
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  Future<void> updateEmployeeBankAccount(String id) async {
    try {
      if (currentEmployeeId.value.isEmpty) {
        alertMessage(context: Get.context!, content: "Save doc first please");
        return;
      }
      addingNewEmployeeBankAccount.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/employees/edit_employee_bank_account/$id',
      );
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "bank_name": employeeBankNameId.value,
          "account_number": employeeAccountNumber.text,
          "iban": employeeIBAN.text,
          "swift_code": employeeSWIFTCode.text,
        }),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        EmployeeAccountBanksModel updatedBankAccount =
            EmployeeAccountBanksModel.fromJson(decoded['updated_bank_account']);
        int index = bankAccountsList.indexWhere((i) => i.id == id);
        if (index != -1) {
          bankAccountsList[index] = updatedBankAccount;
        }
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await updateEmployeeBankAccount(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      addingNewEmployeeBankAccount.value = false;
      Get.back();
    } catch (e) {
      addingNewEmployeeBankAccount.value = false;
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  Future<void> deleteBankAccount(String id) async {
    try {
      if (currentEmployeeId.value.isEmpty) {
        alertMessage(context: Get.context!, content: "Save doc first please");
        return;
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/employees/delete_employee_bank_account/$id',
      );
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        bankAccountsList.removeWhere((em) => em.id == id);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteBankAccount(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
    } catch (e) {
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
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
        List contacts = decoded['contact'];
        contactsAndRelativesList.assignAll(
          contacts
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

  Future<void> updateContactAndRelative(String id) async {
    try {
      if (currentEmployeeId.value.isEmpty) {
        alertMessage(context: Get.context!, content: "employee does not exist");
        return;
      }
      addingNewContactAndRelativesValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/employees/update_employee_contact_and_relative/$id',
      );
      final response = await http.patch(
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
          "date_of_birth": contactAndRelativeDateOfBirth.text.isNotEmpty
              ? convertDateToIson(contactAndRelativeDateOfBirth.text)
              : null,
          "email_address": contactAndRelativeEmailAddress.text,
          "note": contactAndRelativeNotes.text,
          "is_emergency": isThisContactAnEmergencyConact.value,
        }),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        ContactsAndRelativesModel updatedContact =
            ContactsAndRelativesModel.fromJson(decoded['updated_contact']);
        int index = contactsAndRelativesList.indexWhere(
          (contact) => contact.id == id,
        );
        if (index != -1) {
          contactsAndRelativesList[index] = updatedContact;
        }
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await updateContactAndRelative(id);
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

  Future<void> deleteContactAndRelative(String id) async {
    try {
      if (currentEmployeeId.value.isEmpty) {
        alertMessage(context: Get.context!, content: "contact does not exist");
        return;
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/employees/delete_employee_contact_and_relative/$id',
      );
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        contactsAndRelativesList.removeWhere((contact) => contact.id == id);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteContactAndRelative(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
    } catch (e) {
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  void filterContactsAndRelatives() {
    contactsAndRelativesQuery.value = contactsAndRelativesSearch.value.text
        .toLowerCase();
    if (contactsAndRelativesQuery.value.isEmpty) {
      filteredContactsAndRelativesList.clear();
    } else {
      filteredContactsAndRelativesList.assignAll(
        contactsAndRelativesList.where((contact) {
          return contact.fullName.toString().toLowerCase().contains(
                contactsAndRelativesQuery,
              ) ||
              contact.relationshipName.toString().toLowerCase().contains(
                contactsAndRelativesQuery,
              ) ||
              contact.phoneNumber.toString().toLowerCase().contains(
                contactsAndRelativesQuery,
              ) ||
              contact.genderName.toString().toLowerCase().contains(
                contactsAndRelativesQuery,
              ) ||
              contact.nationalityName.toString().toLowerCase().contains(
                contactsAndRelativesQuery,
              ) ||
              contact.emailAddress.toString().toLowerCase().contains(
                contactsAndRelativesQuery,
              ) ||
              // (contact.isEmergency.toString().toLowerCase() == 'true'
              //         ? 'emergency'
              //         : '-')
              //     .contains(query) ||
              textToDate(
                contact.dateOfBirth,
              ).toString().toLowerCase().contains(contactsAndRelativesQuery);
        }).toList(),
      );
    }
  }

  // ======================== Payroll section ========================
  Future<void> addNewEmployeePayroll() async {
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
        '$backendUrl/employees/add_new_employee_payroll/${currentEmployeeId.value}',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": employeePayrollElementNameId.value,
          "value": employeePayrollElementvalue.text.isNotEmpty
              ? double.tryParse(employeePayrollElementvalue.text)
              : 0,
          "start_date": employeePayrollElementStartDate.text.isNotEmpty
              ? convertDateToIson(employeePayrollElementStartDate.text)
              : null,
          "end_date": employeePayrollElementEndDate.text.isNotEmpty
              ? convertDateToIson(employeePayrollElementEndDate.text)
              : null,
          "notes": employeePayrollElementNote.text,
        }),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        EmployeePayrollElementsModel newPayroll =
            EmployeePayrollElementsModel.fromJson(decoded['new_payroll']);
        payrollElementsList.insert(0, newPayroll);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewEmployeePayroll();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      addingNewContactAndRelativesValue.value = false;
      Get.back();
    } catch (e) {
      addingNewContactAndRelativesValue.value = false;
    }
  }

  Future<void> updateEmployeePayroll(String id) async {
    try {
      if (currentEmployeeId.value.isEmpty) {
        alertMessage(context: Get.context!, content: "Save doc first please");
        return;
      }
      addingNewContactAndRelativesValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/employees/update_employee_payroll/$id');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": employeePayrollElementNameId.value,
          "value": employeePayrollElementvalue.text.isNotEmpty
              ? double.tryParse(employeePayrollElementvalue.text)
              : 0,
          "start_date": employeePayrollElementStartDate.text.isNotEmpty
              ? convertDateToIson(employeePayrollElementStartDate.text)
              : null,
          "end_date": employeePayrollElementEndDate.text.isNotEmpty
              ? convertDateToIson(employeePayrollElementEndDate.text)
              : null,
          "notes": employeePayrollElementNote.text,
        }),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        EmployeePayrollElementsModel updatedPayroll =
            EmployeePayrollElementsModel.fromJson(decoded['updated_payroll']);
        int index = payrollElementsList.indexWhere((i) => i.id == id);
        if (index != -1) {
          payrollElementsList[index] = updatedPayroll;
          payrollElementsList.refresh();
        }
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await updateEmployeePayroll(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      addingNewContactAndRelativesValue.value = false;
      Get.back();
    } catch (e) {
      addingNewContactAndRelativesValue.value = false;
    }
  }

  Future<void> deleteEmployeePayroll(String id) async {
    try {
      if (currentEmployeeId.value.isEmpty) {
        alertMessage(context: Get.context!, content: "contact does not exist");
        return;
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/employees/delete_employee_payroll/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        payrollElementsList.removeWhere((contact) => contact.id == id);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteEmployeePayroll(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
    } catch (e) {
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }
}
