import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/payroll/payroll_model.dart';
import '../../Models/payroll/period_Details_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import 'main_screen_contro.dart';

class PayrollController extends GetxController {
  TextEditingController name = TextEditingController();
  TextEditingController periodType = TextEditingController();
  TextEditingController firstPeriodStartDate = TextEditingController();
  TextEditingController numberOfYears = TextEditingController();
  TextEditingController notes = TextEditingController();
  RxBool isScreenLoding = RxBool(false);
  RxInt initTypePickersValue = RxInt(1);
  RxList<PayrollModel> allPayrolls = RxList<PayrollModel>([]);
  RxList<PeriodDetailsModel> allPeriodDetails = RxList<PeriodDetailsModel>([]);
  String backendUrl = backendTestURI;
  RxBool addingNewValue = RxBool(false);

  RxMap periodTypes = RxMap({
    '1': {'name': 'Yearly'},
    '2': {'name': 'Monthly'},
    '3': {'name': 'Weekly'},
  });

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  Future<void> addNewPayroll() async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/payroll/create_new_payroll');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name.text,
          "period_type": periodType.text,
          "first_period_start_date": firstPeriodStartDate.text.isNotEmpty
              ? convertDateToIson(firstPeriodStartDate.text)
              : null,
          "number_of_years": int.tryParse(numberOfYears.text) ?? 1,
          "notes": notes.text,
        }),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List periods = decoded['periods_created'];
        allPeriodDetails.assignAll(
          periods.map((per) => PeriodDetailsModel.fromJson(per)),
        );
        addingNewValue.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewPayroll();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        addingNewValue.value = false;
      }
    } catch (e) {
      print(e);
      addingNewValue.value = false;
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }
}
