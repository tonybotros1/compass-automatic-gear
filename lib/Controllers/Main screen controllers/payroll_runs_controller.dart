import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/payroll runs/payroll_runs_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import 'main_screen_contro.dart';

class PayrollRunsController extends GetxController {
  RxBool isScreenLoding = RxBool(false);
  RxList<PayrollRunsModel> allPayrollRuns = RxList<PayrollRunsModel>([]);
  RxBool addingNewValue = RxBool(false);
  TextEditingController payrollName = TextEditingController();
  TextEditingController periodName = TextEditingController();
  TextEditingController employeeName = TextEditingController();
  TextEditingController elementName = TextEditingController();
  RxString payrollNameId = RxString('');
  RxString periodNameId = RxString('');
  RxString employeeId = RxString('');
  RxString elementId = RxString('');

  Future<Map<String, dynamic>> getAllPayrlls() async {
    return await helper.getPayrolls();
  }

  Future<Map<String, dynamic>> getAllPayrollElements() async {
    return await helper.getAllPayrollElements();
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  Future<Map<String, dynamic>> getPayrollPeriods() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendTestURI/payroll_runs/get_payroll_periods_for_lov/${payrollNameId.value}',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        List<dynamic> jsonData = decode['all_periods'];
        Map<String, dynamic> map = {
          for (var model in jsonData) model['_id']: model,
        };
        return map;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await getPayrollPeriods();
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

  Future<Map<String, dynamic>> getAllEmployeesForSelectedPayroll() async {
    try {
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

  Future<void> payrollRun() async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendTestURI/payroll_runs/run_payroll');
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

  // Future<Map<String, dynamic>> getAllElementsForSelectedEmployee() async {
  //   try {
  //     final SharedPreferences prefs = await SharedPreferences.getInstance();
  //     var accessToken = '${prefs.getString('accessToken')}';
  //     final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
  //     var url = Uri.parse(
  //       '$backendTestURI/payroll_runs/get_elements_for_selected_employee/${employeeId.value}',
  //     );
  //     final response = await http.get(
  //       url,
  //       headers: {'Authorization': 'Bearer $accessToken'},
  //     );
  //     if (response.statusCode == 200) {
  //       final decode = jsonDecode(response.body);
  //       List<dynamic> jsonData = decode['all_elements'];
  //       Map<String, dynamic> map = {
  //         for (var model in jsonData) model['_id']: model,
  //       };
  //       return map;
  //     } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
  //       final refreshed = await helper.refreshAccessToken(refreshToken);
  //       if (refreshed == RefreshResult.success) {
  //         return await getAllElementsForSelectedEmployee();
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
}
