import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/job cards dashboard/account_summary_model.dart';
import '../../Models/job cards dashboard/cashflow_summary_model.dart';
import '../../Models/job cards dashboard/customer_aging_model.dart';
import '../../Models/job cards dashboard/daily_jobs_summary_model.dart';
import '../../Models/job cards dashboard/daily_new_jobs_summary_model.dart';
import '../../Models/job cards dashboard/post_dated_cheques_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import '../Main screen controllers/job_card_controller.dart';

class JobCardsDashboardController extends GetxController {
  Rx<TextEditingController> monthlyDateController = TextEditingController().obs;
  Rx<TextEditingController> dialyCashflowDateController =
      TextEditingController().obs;
  Rx<TextEditingController> dailyDateController = TextEditingController().obs;
  RxList<JobsDailySummary> jobDailySummary = RxList<JobsDailySummary>([]);
  RxList<CashflowSummaryModel> cashflowDialySummaryList =
      RxList<CashflowSummaryModel>([]);
  RxList<JobsDailySummary> jobMonthlySummary = RxList<JobsDailySummary>([]);
  RxList<JobsDailySummary> jobSalesmanSummary = RxList<JobsDailySummary>([]);
  RxList<PostDatedChequesModel> postDatedChequesList =
      RxList<PostDatedChequesModel>([]);
  RxList<CustomerAgingModel> customerAgingSummary = RxList<CustomerAgingModel>(
    [],
  );
  RxList<NewJobsDailySummary> newJobDailySummary = RxList<NewJobsDailySummary>(
    [],
  );
  RxList<AccountSummary> accountSummaryList = RxList<AccountSummary>([]);
  String backendUrl = backendTestURI;
  Rx<TextEditingController> dailyDate = TextEditingController().obs;
  final jonCardController = Get.put(JobCardController());
  RxString jobDatesType = RxString('day');
  RxBool isScreenLoadingForJobCards = RxBool(false);
  RxBool isScreenLoadingForJobDialyNewSummary = RxBool(false);
  RxBool isScreenLoadingForAccountSummary = RxBool(false);
  RxBool isScreenLoadingForCustomerAging = RxBool(false);
  RxBool isScreenLoadingForPostDatedCheques = RxBool(false);
  // customers aging totals
  RxDouble customerAgingTotalOutstanding = RxDouble(0.0);
  RxDouble customerAging0To90 = RxDouble(0.0);
  RxDouble customerAging91To180 = RxDouble(0.0);
  RxDouble customerAging181To360 = RxDouble(0.0);
  RxDouble customerAgingMoreThan360 = RxDouble(0.0);
  RxDouble accountSummaryTotalAmount = RxDouble(0.0);
  // cashflow totals
  RxDouble cashflowTotalNet = RxDouble(0.0);
  RxDouble cashflowTotalCR = RxDouble(0.0);
  RxDouble cashflowTotalDR = RxDouble(0.0);
  RxDouble cashflowTotalTransIn = RxDouble(0.0);
  RxDouble cashflowTotalTransOut = RxDouble(0.0);
  // post dated cheques
  RxDouble posteDatedChequesReceived = RxDouble(0.0);
  RxDouble posteDatedChequesPaid = RxDouble(0.0);

  RxBool showRefreshButtonForCustomerAging = RxBool(true);

  TextStyle dataRowTextStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: Colors.grey[700],
  );

  TextStyle headerRowTextStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.bold,
    color: Colors.grey[700],
  );

  TextStyle headeTextStyle = const TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  @override
  void onInit() {
    dailyDateController.value.text = textToDate(DateTime.now());
    dialyCashflowDateController.value.text = textToDate(DateTime.now());
    monthlyDateController.value.text = DateFormat(
      'MM-yyyy',
    ).format(DateTime.now());
    getJobsDailySummary(dailyDateController.value.text, 'day');
    getJobsDailySummary(monthlyDateController.value.text, 'month');
    getSalesmanSummary();
    getCustomersAging();
    getNewJobsDailySummary();
    getAccountSummary();
    getCashflowDialySummary(dialyCashflowDateController.value.text);
    getPostDatedCheques();
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

  void calculateCustomerAgingTotals() {
    customerAgingTotalOutstanding.value = 0.0;
    customerAging0To90.value = 0.0;
    customerAging91To180.value = 0.0;
    customerAging181To360.value = 0.0;
    customerAgingMoreThan360.value = 0.0;
    for (var element in customerAgingSummary) {
      customerAgingTotalOutstanding.value += element.totalOutstanding ?? 0;
      customerAging0To90.value += element.i0To90Days ?? 0;
      customerAging91To180.value += element.i91To180Days ?? 0;
      customerAging181To360.value += element.d181To360Days ?? 0;
      customerAgingMoreThan360.value += element.moreThan360Days ?? 0;
    }
  }

  void calculatePostedDatedChequesTotals() {
    posteDatedChequesReceived.value = 0.0;
    posteDatedChequesPaid.value = 0.0;
    for (var element in postDatedChequesList) {
      posteDatedChequesReceived.value += element.received ?? 0;
      posteDatedChequesPaid.value += element.paid ?? 0;
    }
  }

  void calculateCashflowTotals() {
    cashflowTotalCR.value = 0.0;
    cashflowTotalDR.value = 0.0;
    cashflowTotalNet.value = 0.0;
    cashflowTotalTransIn.value = 0.0;
    cashflowTotalTransOut.value = 0.0;
    for (var element in cashflowDialySummaryList) {
      cashflowTotalCR.value += element.totalReceived ?? 0;
      cashflowTotalDR.value += element.totalPaid ?? 0;
      cashflowTotalNet.value += element.net ?? 0;
      cashflowTotalTransIn.value += element.totalTransIn ?? 0;
      cashflowTotalTransOut.value += element.totalTransOut ?? 0;
    }
  }

  void calculateAccountSummaryTotals() {
    accountSummaryTotalAmount.value = 0.0;

    for (var element in accountSummaryList) {
      accountSummaryTotalAmount.value += element.amount ?? 0;
    }
  }

  MonthRange monthToIsoRange(String monthYear) {
    final parts = monthYear.split('-');
    // if (parts.length != 2) {
    //   throw FormatException('Expected "MM-YYYY", got "$monthYear"');
    // }

    final month = int.parse(parts[0]);
    final year = int.parse(parts[1]);

    final from = DateTime.utc(year, month, 1);
    // Day 0 of next month = last day of current month
    final to = DateTime.utc(year, month + 1, 0);

    return MonthRange(from.toIso8601String(), to.toIso8601String());
  }

  void onSelectForDate(String dateType) {
    if (dateType == 'day') {
      getJobsDailySummary(dailyDateController.value.text, dateType);
    } else {
      getJobsDailySummary(monthlyDateController.value.text, dateType);
    }
  }

  void filterSearch(String dateType, String status) async {
    isScreenLoadingForJobCards.value = true;
    Map<String, dynamic> body = {};

    if (dailyDateController.value.text.isNotEmpty) {
      if (dateType == 'day') {
        onSelectForDate(dateType);
        body['from_date'] = convertDateToIson(dailyDateController.value.text);
        body['to_date'] = convertDateToIson(dailyDateController.value.text);
      } else {
        getJobsDailySummary(monthlyDateController.value.text, dateType);
        getSalesmanSummary();
        // MonthRange monthlyDate = monthToIsoRange(
        //   monthlyDateController.value.text,
        // );
        // body['from_date'] = monthlyDate.fromIso;
        // body['to_date'] = monthlyDate.toIso;
      }
    }
    if (status.toLowerCase() == 'new') {
      body['status'] = 'New';
    }
    if (status.toLowerCase() == 'posted') {
      body['status'] = 'Posted';
    }
    if (body.isNotEmpty) {
      await jonCardController.searchEngine(body);
    }
    isScreenLoadingForJobCards.value = false;
  }

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

  Future<Map<String, dynamic>> getCashflowDate() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/job_cards_dashboard/get_cashflow_dates');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        Map<String, dynamic> dates = decoded['cashflow_dates'];
        return dates;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await getCashflowDate();
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

  Future<Map<String, dynamic>> getCustomersAging() async {
    try {
      isScreenLoadingForCustomerAging.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/job_cards_dashboard/get_customer_aging_summary',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List customersAging = decoded['customers_aging'];
        customerAgingSummary.assignAll(
          customersAging.map((cus) => CustomerAgingModel.fromJson(cus)),
        );
        calculateCustomerAgingTotals();
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await getCustomersAging();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      isScreenLoadingForCustomerAging.value = false;
      return {};
    } catch (e) {
      isScreenLoadingForCustomerAging.value = false;
      return {};
    }
  }

  Future<Map<String, dynamic>> getPostDatedCheques() async {
    try {
      isScreenLoadingForPostDatedCheques.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/job_cards_dashboard/get_post_dated_cheques',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List postDated = decoded['summary'];
        postDatedChequesList.assignAll(
          postDated.map((cus) => PostDatedChequesModel.fromJson(cus)),
        );
        calculatePostedDatedChequesTotals();
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await getPostDatedCheques();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      isScreenLoadingForPostDatedCheques.value = false;
      return {};
    } catch (e) {
      isScreenLoadingForPostDatedCheques.value = false;
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

  Future<void> getCashflowDialySummary(String date) async {
    String fromDate;
    String toDate;
    try {
      if (date != '') {
        final parsed = DateFormat('dd-MM-yyyy').parseStrict(date);
        fromDate = parsed.toIso8601String().split('T').first;
        toDate = parsed
            .add(const Duration(days: 1))
            .toIso8601String()
            .split('T')
            .first;
      } else {
        alertMessage(context: Get.context!, content: 'please enter valid date');
        return;
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/job_cards_dashboard/get_cashflow_summary',
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
        List daily = decoded['summary'];
        cashflowDialySummaryList.assignAll(
          daily.map((d) => CashflowSummaryModel.fromJson(d)),
        );
        calculateCashflowTotals();
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getCashflowDialySummary(date);
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

  Future<void> getSalesmanSummary() async {
    String fromDate;
    String toDate;
    try {
      MonthRange monthlyDate = monthToIsoRange(
        monthlyDateController.value.text,
      );
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
          await getSalesmanSummary();
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
    try {
      isScreenLoadingForJobDialyNewSummary.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/job_cards_dashboard/get_new_job_cards_daily_summary',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
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
      isScreenLoadingForJobDialyNewSummary.value = false;
    } catch (e) {
      isScreenLoadingForJobDialyNewSummary.value = false;
    }
  }

  Future<void> getAccountSummary() async {
    try {
      isScreenLoadingForAccountSummary.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/job_cards_dashboard/get_account_transfers',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List daily = decoded['accounts_summary'];
        accountSummaryList.assignAll(
          daily.map((d) => AccountSummary.fromJson(d)),
        );
        calculateAccountSummaryTotals();
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAccountSummary();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      isScreenLoadingForAccountSummary.value = false;
    } catch (e) {
      isScreenLoadingForAccountSummary.value = false;
    }
  }
}

class MonthRange {
  final String fromIso;
  final String toIso;
  const MonthRange(this.fromIso, this.toIso);
}
