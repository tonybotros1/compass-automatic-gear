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
  final GlobalKey<FormState> payrollFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> periodFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> monthlyPeriodsFormKey = GlobalKey<FormState>();

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
  RxBool generatingMonthlyPeriods = RxBool(false);
  RxString currentPayrollId = RxString('');
  RxBool isActiveSelected = RxBool(true);

  TextEditingController yearStartDate = TextEditingController();

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

  @override
  void onClose() {
    name.dispose();
    notes.dispose();
    paymentType.dispose();
    periodName.dispose();
    periodStartDate.dispose();
    periodEndDate.dispose();
    yearStartDate.dispose();
    super.onClose();
  }

  void clearPayrollValues() {
    payrollFormKey.currentState?.reset();
    currentPayrollId.value = '';
    name.clear();
    notes.clear();
    paymentType.clear();
    paymentTypeId.value = '';
    allPeriodDetails.clear();
    clearPeriodValues();
    clearMonthlyPeriodValues();
  }

  void clearPeriodValues() {
    periodFormKey.currentState?.reset();
    periodName.clear();
    periodStartDate.clear();
    periodEndDate.clear();
    isActiveSelected.value = true;
  }

  void clearMonthlyPeriodValues() {
    monthlyPeriodsFormKey.currentState?.reset();
    yearStartDate.clear();
  }

  DateTime? _dateFromController(TextEditingController controller) {
    final isoDate = convertDateToIson(controller.text);
    return isoDate == null ? null : DateTime.tryParse(isoDate);
  }

  bool _validatePayroll() {
    if (!(payrollFormKey.currentState?.validate() ?? false)) return false;
    if (name.text.trim().isEmpty) {
      alertMessage(context: Get.context!, content: 'Please enter payroll name');
      return false;
    }
    if (paymentTypeId.value.trim().isEmpty) {
      alertMessage(
        context: Get.context!,
        content: 'Please select payment type',
      );
      return false;
    }
    return true;
  }

  bool _validatePeriod() {
    if (currentPayrollId.value.isEmpty) {
      alertMessage(context: Get.context!, content: 'Please save payroll first');
      return false;
    }
    if (!(periodFormKey.currentState?.validate() ?? false)) return false;
    if (periodName.text.trim().isEmpty) {
      alertMessage(context: Get.context!, content: 'Please enter period name');
      return false;
    }

    final startDate = _dateFromController(periodStartDate);
    if (startDate == null) {
      alertMessage(
        context: Get.context!,
        content: 'Please enter valid start date',
      );
      return false;
    }

    final endDate = _dateFromController(periodEndDate);
    if (endDate == null) {
      alertMessage(
        context: Get.context!,
        content: 'Please enter valid end date',
      );
      return false;
    }

    if (endDate.isBefore(startDate)) {
      alertMessage(
        context: Get.context!,
        content: 'End date cannot be before start date',
      );
      return false;
    }

    return true;
  }

  bool _validateMonthlyPeriods() {
    if (currentPayrollId.value.isEmpty) {
      alertMessage(context: Get.context!, content: 'Please save payroll first');
      return false;
    }
    if (!(monthlyPeriodsFormKey.currentState?.validate() ?? false)) {
      return false;
    }
    if (_dateFromController(yearStartDate) == null) {
      alertMessage(
        context: Get.context!,
        content: 'Please enter valid year start date',
      );
      return false;
    }
    return true;
  }

  void _upsertPayroll(PayrollModel payroll) {
    final payrollId = payroll.id;
    if (payrollId == null || payrollId.isEmpty) return;
    final index = allPayrolls.indexWhere((i) => i.id == payrollId);
    if (index == -1) {
      allPayrolls.insert(0, payroll);
    } else {
      allPayrolls[index] = payroll;
    }
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
        List payrolls = decoded['all_payrolls'] ?? [];
        allPayrolls.assignAll(
          payrolls.whereType<Map<String, dynamic>>().map(
            (branch) => PayrollModel.fromJson(branch),
          ),
        );
        isScreenLoding.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllPayrolls();
        } else if (refreshed == RefreshResult.invalidToken) {
          isScreenLoding.value = false;
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

  Future<bool> getCurrentPayrollDetails(String id) async {
    try {
      if (id.isEmpty) return false;

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
          Map<String, dynamic>.from(decoded['payroll_details'] ?? {}),
        );
        name.text = payroll.name ?? '';
        notes.text = payroll.notes ?? '';
        paymentType.text = payroll.paymentType ?? '';
        paymentTypeId.value = payroll.paymentTypeId ?? '';
        allPeriodDetails.assignAll(payroll.allParollDetails ?? []);
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await getCurrentPayrollDetails(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        isScreenLoding.value = false;
        logout();
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> addNewPayroll() async {
    try {
      if (!_validatePayroll()) return;

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
            Map<String, dynamic>.from(decoded['added_details'] ?? {}),
          );
          currentPayrollId.value = addedPayroll.id ?? '';
          _upsertPayroll(addedPayroll);
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
            Map<String, dynamic>.from(decoded['updated_data'] ?? {}),
          );
          _upsertPayroll(updatedPayroll);
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

  Future<bool> deletePayroll(String payrollId) async {
    try {
      if (payrollId.isEmpty) return false;

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
        if (currentPayrollId.value == payrollId) {
          clearPayrollValues();
        }
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await deletePayroll(payrollId);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> addNewPayrollPeriod() async {
    try {
      if (!_validatePeriod()) return;

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
        final added = Map<String, dynamic>.from(decoded['added_period'] ?? {});
        allPeriodDetails.add(PeriodDetailsModel.fromJson(added));
        Get.back();
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
    } catch (e) {
      addingNewPeriodValue.value = false;
    }
  }

  Future<void> updatePayrollPeriod(String periodId) async {
    try {
      if (periodId.isEmpty) return;
      if (!_validatePeriod()) return;

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
        PeriodDetailsModel updated = PeriodDetailsModel.fromJson(
          Map<String, dynamic>.from(decoded['updated_period'] ?? {}),
        );
        int index = allPeriodDetails.indexWhere((i) => i.id == periodId);
        if (index != -1) {
          allPeriodDetails[index] = updated;
        }
        Get.back();
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
    } catch (e) {
      addingNewPeriodValue.value = false;
    }
  }

  Future<bool> deletePayrollPeriod(String periodId) async {
    try {
      if (periodId.isEmpty) return false;

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
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await deletePayrollPeriod(periodId);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> generateMonthlyPeriods() async {
    try {
      if (!_validateMonthlyPeriods()) return;

      generatingMonthlyPeriods.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/payroll/generate_monthly_periods/${currentPayrollId.value}',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "year_start_date": convertDateToIson(yearStartDate.text),
        }),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List addedPeriods = decoded['periods'] ?? [];
        allPeriodDetails.assignAll(
          addedPeriods.whereType<Map<String, dynamic>>().map(
            (p) => PeriodDetailsModel.fromJson(p),
          ),
        );
        Get.back();
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await generateMonthlyPeriods();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      generatingMonthlyPeriods.value = false;
    } catch (e) {
      generatingMonthlyPeriods.value = false;
    }
  }
}
