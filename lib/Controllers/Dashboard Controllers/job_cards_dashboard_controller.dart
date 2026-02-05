import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/job cards dashboard/daily_jobs_summary_model.dart';
import '../../Models/job cards dashboard/daily_new_jobs_summary_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import '../Main screen controllers/job_card_controller.dart';

class JobCardsDashboardController extends GetxController {
  Rx<TextEditingController> date = TextEditingController().obs;
  RxList<JobsDailySummary> jobDailySummary = RxList<JobsDailySummary>([]);
  RxList<JobsDailySummary> jobMonthlySummary = RxList<JobsDailySummary>([]);
  RxList<JobsDailySummary> jobSalesmanSummary = RxList<JobsDailySummary>([]);
  RxList<NewJobsDailySummary> newJobDailySummary = RxList<NewJobsDailySummary>(
    [],
  );
  String backendUrl = backendTestURI;
  Rx<TextEditingController> dailyDate = TextEditingController().obs;
  final jonCardController = Get.put(JobCardController());
  RxString jobDatesType = RxString('day');
  RxBool isPostedSelected = RxBool(false);
  RxBool isNewSelected = RxBool(false);
  RxBool isNotApprovedSelected = RxBool(false);
  RxBool isReadySelected = RxBool(false);
  RxBool isApprovedSelected = RxBool(false);
  RxBool isReturnedSelected = RxBool(false);
  RxBool isScreenLoading = RxBool(false);

  @override
  void onInit() {
    getNewJobsDailySummary();

    super.onInit();
  }

  @override
  void onClose() {
    dailyDate.value.dispose();
    jobDailySummary.clear();
    newJobDailySummary.clear();

    if (Get.isRegistered<JobCardController>()) {
      Get.delete<JobCardController>();
    }

    super.onClose();
  }

  void onClickForTabPage(int i) {
    switch (i) {
      case 0:
        jobDatesType.value = 'day';
        date.value = TextEditingController();
        break;
      case 1:
        jobDatesType.value = 'month';
        date.value = TextEditingController();
        break;
      default:
        jobDatesType.value = 'month';
        break;
    }
  }

  MonthRange monthToIsoRange(String monthYear) {
    final parts = monthYear.split('-');
    if (parts.length != 2) {
      throw FormatException('Expected "MM-YYYY", got "$monthYear"');
    }

    final month = int.parse(parts[0]);
    final year = int.parse(parts[1]);

    final from = DateTime.utc(year, month, 1);
    // Day 0 of next month = last day of current month
    final to = DateTime.utc(year, month + 1, 0);

    return MonthRange(from.toIso8601String(), to.toIso8601String());
  }

  void onSelectForDate(String dateType) {
    getJobsDailySummary(date.value.text, dateType);
  }

  void filterSearch(String dateType) async {
    isScreenLoading.value = true;
    Map<String, dynamic> body = {};

    if (date.value.text.isNotEmpty) {
      if (dateType == 'day') {
        onSelectForDate(dateType);
        body['from_date'] = convertDateToIson(date.value.text);
        body['to_date'] = convertDateToIson(date.value.text);
      } else {
        getJobsDailySummary(date.value.text, dateType);
        getSalesmanSummary(date.value.text);
        MonthRange monthlyDate = monthToIsoRange(date.value.text);
        body['from_date'] = monthlyDate.fromIso;
        body['to_date'] = monthlyDate.toIso;
      }
    }
    if (isNewSelected.isTrue) {
      body['status'] = 'New';
    }
    if (isPostedSelected.isTrue) {
      body['status'] = 'Posted';
    }
    // if (isNotApprovedSelected.isTrue) {
    //   body['status'] = 'not approved';
    // }
    // if (isApprovedSelected.isTrue) {
    //   body['status'] = 'Approved';
    // }
    // if (isReadySelected.isTrue) {
    //   body['status'] = 'Ready';
    // }
    // if (isReturnedSelected.isTrue) {
    //   body['label'] = 'Returned';
    // }
    if (body.isNotEmpty) {
      await jonCardController.searchEngine(body);
    }
    isScreenLoading.value = false;
  }

  // void showDatePicker(BuildContext context) {
  //   showCupertinoModalPopup(
  //     context: context,
  //     builder: (_) => Container(
  //       height: 250,
  //       color: Colors.white,
  //       child: Column(
  //         children: [
  //           SizedBox(
  //             height: 180,
  //             child: CupertinoDatePicker(
  //               mode: CupertinoDatePickerMode.date,
  //               initialDateTime: DateTime.now(),
  //               onDateTimeChanged: (val) {
  //                 print(val);
  //               },
  //             ),
  //           ),
  //           // Close the modal
  //           CupertinoButton(
  //             child: const Text('OK'),
  //             onPressed: () => Navigator.of(context).pop(),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Future<Map<String, dynamic>> getJobsDate(String type) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/job_cards_dashboard/get_jobs_dates/$type',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        Map<String, dynamic> dates = decoded['dates'];
        return dates;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await getJobsDate(type);
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

  Future<void> getJobsDailySummary(String date, String dateType) async {
    String fromDate;
    String toDate;
    try {
      if (dateType == 'day') {
        if (date != '') {
          final parsed = DateFormat('dd-MM-yyyy').parseStrict(date);
          fromDate = parsed.toIso8601String().split('T').first;
          toDate = parsed
              .add(const Duration(days: 1))
              .toIso8601String()
              .split('T')
              .first;
        } else {
          alertMessage(
            context: Get.context!,
            content: 'Please enter valid date 2',
          );
          return;
        }
        if (fromDate == '' || toDate == '') {
          alertMessage(
            context: Get.context!,
            content: 'Please enter valid date 3',
          );
          return;
        }
      } else {
        MonthRange monthlyDate = monthToIsoRange(date);
        fromDate = monthlyDate.fromIso;
        toDate = monthlyDate.toIso;
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/job_cards_dashboard/get_job_cards_daily_summary',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({'from_date': fromDate, 'to_date': toDate}),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List daily = decoded['daily_summary'];
        if (dateType == 'day') {
          jobDailySummary.assignAll(
            daily.map((d) => JobsDailySummary.fromJson(d)),
          );
        } else {
          jobMonthlySummary.assignAll(
            daily.map((d) => JobsDailySummary.fromJson(d)),
          );
        }
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getJobsDailySummary(date, dateType);
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

  Future<void> getSalesmanSummary(String date) async {
    String fromDate;
    String toDate;
    try {
      MonthRange monthlyDate = monthToIsoRange(date);
      fromDate = monthlyDate.fromIso;
      toDate = monthlyDate.toIso;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/job_cards_dashboard/get_salesman_summary',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({'from_date': fromDate, 'to_date': toDate}),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List daily = decoded['salesman_summary'];

        jobSalesmanSummary.assignAll(
          daily.map((d) => JobsDailySummary.fromJson(d)),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getSalesmanSummary(date);
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

  Map<String, String> getFromDateToDate(String date) {
    final parsed = DateFormat('dd-MM-yyyy').parseStrict(date);
    String fromDate = parsed.toIso8601String().split('T').first;
    String toDate = parsed
        .add(const Duration(days: 1))
        .toIso8601String()
        .split('T')
        .first;
    return {'from_date': fromDate, 'to_date': toDate};
  }

  Future<void> getNewJobsDailySummary() async {
    // String fromDate;
    // String toDate;
    try {
      // if (date != '') {
      //   final parsed = DateFormat('dd-MM-yyyy').parseStrict(date);
      //   fromDate = parsed.toIso8601String().split('T').first;
      //   toDate = parsed
      //       .add(const Duration(days: 1))
      //       .toIso8601String()
      //       .split('T')
      //       .first;
      // } else {
      //   alertMessage(
      //     context: Get.context!,
      //     content: 'Please enter valid date 2',
      //   );
      //   return;
      // }
      // if (fromDate == '' || toDate == '') {
      //   alertMessage(
      //     context: Get.context!,
      //     content: 'Please enter valid date 3',
      //   );
      //   return;
      // }

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/job_cards_dashboard/get_new_job_cards_daily_summary',
      );
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          // "Content-Type": "application/json",
        },
        // body: jsonEncode({'from_date': fromDate, 'to_date': toDate}),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List daily = decoded['new_daily_summary'];
        newJobDailySummary.assignAll(
          daily.map((d) => NewJobsDailySummary.fromJson(d)),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getNewJobsDailySummary();
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
}

class MonthRange {
  final String fromIso;
  final String toIso;
  const MonthRange(this.fromIso, this.toIso);
}
