import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/payroll/payroll_model.dart';
import '../../Models/payroll/period_details_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import 'main_screen_contro.dart';

class PayrollController extends GetxController {
  // header
  TextEditingController name = TextEditingController();
  TextEditingController notes = TextEditingController();
  TextEditingController paymentType = TextEditingController();
  RxString paymentTypeId = RxString('');

  // details
  TextEditingController periodName = TextEditingController();
  TextEditingController periodStartDate = TextEditingController();
  TextEditingController periodEndDate = TextEditingController();

  RxBool isScreenLoding = RxBool(false);
  RxList<PayrollModel> allPayrolls = RxList<PayrollModel>([]);
  RxList<PeriodDetailsModel> allPeriodDetails = RxList<PeriodDetailsModel>([]);
  String backendUrl = backendTestURI;
  RxBool addingNewValue = RxBool(false);
  RxBool addingNewPeriodValue = RxBool(false);
  RxString currentPayrollId = RxString('');
  RxBool isActiveSelected = RxBool(true);

  RxMap periodTypes = RxMap({
    '1': {'name': 'Monthly'},
    '2': {'name': 'Weekly'},
    '3': {'name': 'Daily'},
  });

  @override
  void onInit() async {
    getAllPayrolls();
    super.onInit();
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  void selecetActiveInactive(String type, bool value) {
    isActiveSelected.value = value;
  }

  Future<Map<String, dynamic>> getPaymentTypes() async {
    return await helper.getAllAPPaymentTypes();
  }

  Future<void> getAllPayrolls() async {
    try {
      isScreenLoding.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/payroll/get_all_payrolls');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List payrolls = decoded['all_payrolls'];
        allPayrolls.assignAll(
          payrolls.map((branch) => PayrollModel.fromJson(branch)),
        );
        isScreenLoding.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllPayrolls();
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

  Future<void> getCurrentPayrollDetails(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/payroll/get_current_payroll_details/$id',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        PayrollModel payroll = PayrollModel.fromJson(
          decoded['payroll_details'],
        );
        name.text = payroll.name ?? '';
        notes.text = payroll.notes ?? '';
        paymentType.text = payroll.paymentType ?? '';
        paymentTypeId.value = payroll.paymentTypeId ?? '';
        allPeriodDetails.assignAll(payroll.allParollDetails ?? []);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllPayrolls();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        isScreenLoding.value = false;
        logout();
      }
    } catch (e) {
      // print(e);
    }
  }

  Future<void> addNewPayroll() async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      if (currentPayrollId.value.isEmpty) {
        Uri url = Uri.parse('$backendUrl/payroll/create_new_payroll');
        final response = await http.post(
          url,
          headers: {
            'Authorization': 'Bearer $accessToken',
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "name": name.text,
            "notes": notes.text,
            "payment_type": paymentTypeId.value,
          }),
        );
        if (response.statusCode == 200) {
          final decoded = jsonDecode(response.body);
          PayrollModel addedPayroll = PayrollModel.fromJson(
            decoded['added_details'],
          );
          currentPayrollId.value = addedPayroll.id ?? '';
          allPayrolls.insert(0, addedPayroll);
        } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
          final refreshed = await helper.refreshAccessToken(refreshToken);
          if (refreshed == RefreshResult.success) {
            await addNewPayroll();
          } else if (refreshed == RefreshResult.invalidToken) {
            logout();
          }
        } else if (response.statusCode == 401) {
          logout();
        }
      } else {
        Uri url = Uri.parse(
          '$backendUrl/payroll/update_payroll/${currentPayrollId.value}',
        );
        final response = await http.patch(
          url,
          headers: {
            'Authorization': 'Bearer $accessToken',
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "name": name.text,
            "notes": notes.text,
            "payment_type": paymentTypeId.value,
          }),
        );
        if (response.statusCode == 200) {
          final decoded = jsonDecode(response.body);
          PayrollModel updatedPayroll = PayrollModel.fromJson(
            decoded['updated_data'],
          );
          int index = allPayrolls.indexWhere(
            (i) => i.id == currentPayrollId.value,
          );

          allPayrolls[index] = updatedPayroll;
        } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
          final refreshed = await helper.refreshAccessToken(refreshToken);
          if (refreshed == RefreshResult.success) {
            await addNewPayroll();
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
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  Future<void> deletePayroll(String payrollId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/payroll/delete_payroll/$payrollId');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        allPayrolls.removeWhere((i) => i.id == payrollId);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deletePayroll(payrollId);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      Get.close(2);
    } catch (e) {
      //
    }
  }

  Future<void> addNewPayrollPeriod() async {
    try {
      addingNewPeriodValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/payroll/add_new_period/${currentPayrollId.value}',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "period_name": periodName.text,
          "start_date": periodStartDate.text.isNotEmpty
              ? convertDateToIson(periodStartDate.text)
              : null,
          "end_date": periodEndDate.text.isNotEmpty
              ? convertDateToIson(periodEndDate.text)
              : null,
          "status": isActiveSelected.value ? 'Active' : 'Inactive',
        }),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        Map added = decoded['added_period'];
        allPeriodDetails.add(
          PeriodDetailsModel(
            id: added['_id'],
            period: added['period_name'],
            startDate: added['start_date'] != null
                ? DateTime.tryParse(added['start_date'])
                : null,
            endDate: added['end_date'] != null
                ? DateTime.tryParse(added['end_date'])
                : null,
            status: added['status'],
          ),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewPayrollPeriod();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      addingNewPeriodValue.value = false;
      Get.back();
    } catch (e) {
      addingNewPeriodValue.value = false;
    }
  }

  Future<void> updatePayrollPeriod(String periodId) async {
    try {
      addingNewPeriodValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/payroll/update_period/$periodId');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "period_name": periodName.text,
          "start_date": periodStartDate.text.isNotEmpty
              ? convertDateToIson(periodStartDate.text)
              : null,
          "end_date": periodEndDate.text.isNotEmpty
              ? convertDateToIson(periodEndDate.text)
              : null,
          "status": isActiveSelected.value ? 'Active' : 'Inactive',
        }),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        Map added = decoded['updated_period'];
        PeriodDetailsModel updated = PeriodDetailsModel(
          id: added['_id'],
          period: added['period_name'],
          startDate: added['start_date'] != null
              ? DateTime.tryParse(added['start_date'])
              : null,
          endDate: added['end_date'] != null
              ? DateTime.tryParse(added['end_date'])
              : null,
          status: added['status'],
        );
        int index = allPeriodDetails.indexWhere((i) => i.id == periodId);
        if (index != -1) {
          allPeriodDetails[index] = updated;
        }
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await updatePayrollPeriod(periodId);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      addingNewPeriodValue.value = false;
      Get.back();
    } catch (e) {
      addingNewPeriodValue.value = false;
    }
  }

  Future<void> deletePayrollPeriod(String periodId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/payroll/delete_period/$periodId');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        allPeriodDetails.removeWhere((i) => i.id == periodId);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deletePayrollPeriod(periodId);
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
}
