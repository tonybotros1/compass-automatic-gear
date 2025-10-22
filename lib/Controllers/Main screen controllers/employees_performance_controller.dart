import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/employee performance/employee_performance.dart';
import '../../consts.dart';
import '../../helpers.dart';
import 'main_screen_contro.dart';

class EmployeesPerformanceController extends GetxController {
  TextEditingController year = TextEditingController();
  TextEditingController month = TextEditingController();
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);

  RxBool isThisMonthSelected = RxBool(false);
  RxBool isThisYearSelected = RxBool(false);

  double dropDownWidth = 150;
  RxBool isScreenLoadingForTimesheets = RxBool(false);
  RxBool isScreenLoadingForEmployeeTasks = RxBool(false);
  final RxMap<String, int> employeePointsMap = <String, int>{}.obs;
  RxList<EmployeePerformanceModel> filteredPerformances =
      RxList<EmployeePerformanceModel>([]);
  RxList<CompletedSheetsInfos> filteredPerformancesInfos =
      RxList<CompletedSheetsInfos>([]);
  RxMap pointsAndNames = {}.obs;
  RxMap cars = {}.obs;
  RxMap allBrands = RxMap({});
  RxDouble totalsForJobs = RxDouble(0.0);
  String backendUrl = backendTestURI;

  @override
  void onInit() async {
    searchEngine({'this_month': true});
    super.onInit();
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  Future<Map<String, dynamic>> getAllYears() async {
    return await helper.getAllListValues('YEARS');
  }

  Future<Map<String, dynamic>> getAllMonths() async {
    return await helper.getAllListValues('MONTHS');
  }

  void filterSearch() {
    Map<String, dynamic> body = {};
    if (year.text.isNotEmpty) {
      body['year'] = year.text;
    }
    if (month.text.isNotEmpty && year.text.isEmpty) {
      body['year'] = DateTime.now().year;
      body['month'] = monthNameToNumber(month.text);
    } else {
      body['month'] = monthNameToNumber(month.text);
    }
    if (isThisMonthSelected.isTrue) {
      body['this_month'] = true;
    }
    if (isThisYearSelected.isTrue) {
      body['this_year'] = true;
    }
    searchEngine(body);
  }

  Future<void> searchEngine(Map body) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/employees_performance/search_engine');
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
        List performances = decoded['filtered_time_sheets'];
        filteredPerformances.assignAll(
          performances.map((per) => EmployeePerformanceModel.fromJson(per)),
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
    } catch (e) {
      //
    }
  }
  // =============================================================================================================================
}