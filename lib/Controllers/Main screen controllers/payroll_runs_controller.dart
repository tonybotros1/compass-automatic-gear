import 'dart:convert';

import 'package:datahubai/Models/payroll%20runs/payroll_runs_details_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/payroll runs/payroll_runs_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import 'main_screen_contro.dart';

class PayrollRunsController extends GetxController {
  final GlobalKey<FormState> payrollRunFormKey = GlobalKey<FormState>();
  RxBool isScreenLoding = RxBool(false);
  RxList<PayrollRunsModel> allPayrollRuns = RxList<PayrollRunsModel>([]);
  RxBool addingNewValue = RxBool(false);
  RxBool rollingBack = RxBool(false);
  TextEditingController payrollName = TextEditingController();
  TextEditingController periodName = TextEditingController();
  TextEditingController employeeName = TextEditingController();
  TextEditingController elementName = TextEditingController();
  RxString payrollNameId = RxString('');
  RxString periodNameId = RxString('');
  RxString employeeId = RxString('');
  RxString elementId = RxString('');
  RxList<PayrollRunsEmployeeModel> payrollRunsEmployeeList =
      RxList<PayrollRunsEmployeeModel>();
  RxList<PayrollRunsEmployeeModel> filteredPayrollRunsEmployeeList =
      RxList<PayrollRunsEmployeeModel>();

  RxList<PayrollRunsEmployeeElementsModel> payrollRunsEmployeeElementsList =
      RxList<PayrollRunsEmployeeElementsModel>();
  RxList<PayrollRunsEmployeeElementsModel>
  filteredPayrollRunsEmployeeElementsList =
      RxList<PayrollRunsEmployeeElementsModel>();
  RxList<PayrollRunsEmployeeElementsModel>
  payrollRunsEmployeeElementsInformationList =
      RxList<PayrollRunsEmployeeElementsModel>();

  RxString emploeeQuery = RxString('');
  Rx<TextEditingController> employeeSearch = TextEditingController().obs;

  RxString elementQuery = RxString('');
  Rx<TextEditingController> elementSearch = TextEditingController().obs;

  @override
  void onClose() {
    payrollName.dispose();
    periodName.dispose();
    employeeName.dispose();
    elementName.dispose();
    employeeSearch.value.dispose();
    elementSearch.value.dispose();
    super.onClose();
  }

  bool _validatePayrollRun() {
    if (!(payrollRunFormKey.currentState?.validate() ?? false)) return false;
    if (payrollNameId.value.trim().isEmpty) {
      alertMessage(context: Get.context!, content: 'Please select payroll');
      return false;
    }
    if (periodNameId.value.trim().isEmpty) {
      alertMessage(context: Get.context!, content: 'Please select period');
      return false;
    }
    return true;
  }

  void clearPayrollRunValues() {
    payrollRunFormKey.currentState?.reset();
    payrollName.clear();
    periodName.clear();
    employeeName.clear();
    elementName.clear();
    payrollNameId.value = '';
    periodNameId.value = '';
    employeeId.value = '';
    elementId.value = '';
  }

  void clearPayrollDependentValues() {
    periodName.clear();
    employeeName.clear();
    periodNameId.value = '';
    employeeId.value = '';
  }

  void clearElementSelection() {
    elementName.clear();
    elementId.value = '';
  }

  void clearPayrollRunDetails() {
    employeeSearch.value.clear();
    elementSearch.value.clear();
    emploeeQuery.value = '';
    elementQuery.value = '';
    payrollRunsEmployeeList.clear();
    filteredPayrollRunsEmployeeList.clear();
    payrollRunsEmployeeElementsList.clear();
    filteredPayrollRunsEmployeeElementsList.clear();
    payrollRunsEmployeeElementsInformationList.clear();
  }

  void selectPayrollRunEmployee(PayrollRunsEmployeeModel employee) {
    elementSearch.value.clear();
    elementQuery.value = '';
    filteredPayrollRunsEmployeeElementsList.clear();
    payrollRunsEmployeeElementsList.assignAll(
      employee.runEmployeeDetails ?? [],
    );
    payrollRunsEmployeeElementsInformationList.assignAll(
      employee.runEmployeeInformation ?? [],
    );
  }

  Future<Map<String, dynamic>> getAllPayrlls() async {
    return await helper.getPayrolls();
  }

  Future<Map<String, dynamic>> getAllPayrollElements() async {
    return await helper.getAllPayrollElements();
  }

  Future<Map<String, dynamic>> getPayrollPeriods() async {
    if (payrollNameId.value.isEmpty) return {};
    return await helper.getPayrollPeriods(payrollNameId.value);
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  // Future<Map<String, dynamic>> getPayrollPeriods() async {
  //   try {
  //     final SharedPreferences prefs = await SharedPreferences.getInstance();
  //     var accessToken = '${prefs.getString('accessToken')}';
  //     final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
  //     var url = Uri.parse(
  //       '$backendTestURI/payroll_runs/get_payroll_periods_for_lov/${payrollNameId.value}',
  //     );
  //     final response = await http.get(
  //       url,
  //       headers: {'Authorization': 'Bearer $accessToken'},
  //     );
  //     if (response.statusCode == 200) {
  //       final decode = jsonDecode(response.body);
  //       List<dynamic> jsonData = decode['all_periods'];
  //       Map<String, dynamic> map = {
  //         for (var model in jsonData) model['_id']: model,
  //       };
  //       return map;
  //     } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
  //       final refreshed = await helper.refreshAccessToken(refreshToken);
  //       if (refreshed == RefreshResult.success) {
  //         return await getPayrollPeriods();
  //       } else if (refreshed == RefreshResult.invalidToken) {
  //         logout();
  //       }
  //       return {};
  //     } else if (response.statusCode == 401) {
  //       logout();
  //       return {};
  //     } else {
  //       return {};
  //     }
  //   } catch (e) {
  //     return {};
  //   }
  // }

  Future<Map<String, dynamic>> getAllEmployeesForSelectedPayroll() async {
    try {
      if (payrollNameId.value.isEmpty) return {};

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendTestURI/payroll_runs/get_all_employees_for_payroll_runs_lov/${payrollNameId.value}',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        List<dynamic> jsonData = decode['all_employees'];
        Map<String, dynamic> map = {
          for (var model in jsonData) model['_id']: model,
        };
        return map;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await getAllEmployeesForSelectedPayroll();
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

  Future<void> getAllPayrollRuns() async {
    try {
      isScreenLoding.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendTestURI/payroll_runs/get_all_payroll_runs');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List branches = decoded['payroll_runs'];
        allPayrollRuns.assignAll(
          branches.map((run) => PayrollRunsModel.fromJson(run)),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllPayrollRuns();
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

  Future<bool> getPayrollRunsDetails(String id) async {
    try {
      if (id.isEmpty) return false;

      isScreenLoding.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendTestURI/payroll_runs/get_payroll_runs_details/$id',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        PayrollRunDetailsModel details = PayrollRunDetailsModel.fromJson(
          decoded['payroll_runs_details'],
        );
        payrollRunsEmployeeList.assignAll(details.employeesDetails ?? []);
        isScreenLoding.value = false;
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await getPayrollRunsDetails(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      isScreenLoding.value = false;
      return false;
    } catch (e) {
      isScreenLoding.value = false;
      return false;
    }
  }

  Future<void> payrollRun() async {
    try {
      if (!_validatePayrollRun()) return;

      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendTestURI/payroll_runs/payroll_run');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "payroll_id": payrollNameId.value,
          "period_id": periodNameId.value,
          "employee_id": employeeId.value,
          "element_id": elementId.value,
        }),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        PayrollRunsModel addedRun = PayrollRunsModel.fromJson(
          decoded['added_run'],
        );
        allPayrollRuns.insert(0, addedRun);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await payrollRun();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      // Get.back();
      addingNewValue.value = false;
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  Future<bool> payrollRollback(String runId) async {
    try {
      if (runId.isEmpty) return false;

      rollingBack.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendTestURI/payroll_runs/rollback_payroll_run/$runId',
      );
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        allPayrollRuns.removeWhere((i) => i.id == runId);
        rollingBack.value = false;
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await payrollRollback(runId);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      rollingBack.value = false;
      return false;
    } catch (e) {
      alertMessage(
        context: Get.context!,
        content: "Coud not rollback please try again later",
      );
      rollingBack.value = false;
      return false;
    }
  }

  void filterPayrollEmployees() {
    emploeeQuery.value = employeeSearch.value.text.toLowerCase();
    if (emploeeQuery.value.isEmpty) {
      filteredPayrollRunsEmployeeList.clear();
    } else {
      filteredPayrollRunsEmployeeList.assignAll(
        payrollRunsEmployeeList.where((employee) {
          return employee.employeeName.toString().toLowerCase().contains(
            emploeeQuery.value,
          );
        }).toList(),
      );
    }
  }

  void filterPayrollEmployeesElements() {
    elementQuery.value = elementSearch.value.text.toLowerCase();
    if (elementQuery.value.isEmpty) {
      filteredPayrollRunsEmployeeElementsList.clear();
    } else {
      filteredPayrollRunsEmployeeElementsList.assignAll(
        payrollRunsEmployeeElementsList.where((employee) {
          return employee.elementName.toString().toLowerCase().contains(
            elementQuery.value,
          );
        }).toList(),
      );
    }
  }
}
