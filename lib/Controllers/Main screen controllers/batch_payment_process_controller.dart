import 'dart:convert';

import 'package:datahubai/Models/batch_payment_process/batch_payment_process_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/batch_payment_process/batch_payment_process_items_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import 'main_screen_contro.dart';

class BatchPaymentProcessController extends GetxController {
  TextEditingController batchNumberFilter = TextEditingController();
  TextEditingController batchNoteFilter = TextEditingController();
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController statusFilter = TextEditingController();
  RxInt initDatePickerValue = RxInt(1);
  RxInt initStatusPickersValue = RxInt(1);
  RxBool isScreenLoding = RxBool(false);
  RxInt numberOfBatches = RxInt(0);
  RxString status = RxString('');
  RxList<BatchPaymentProcessModel> batchesList =
      RxList<BatchPaymentProcessModel>([]);
  RxList<BatchPaymentProcessItemsModel> items =
      RxList<BatchPaymentProcessItemsModel>([]);
  RxBool addingNewValue = RxBool(false);
  TextEditingController paymentType = TextEditingController();
  RxString paymentTypeId = RxString('');
  RxBool isChequeSelected = RxBool(false);
  TextEditingController chequeDate = TextEditingController();
  TextEditingController batchDate = TextEditingController();
  TextEditingController chequeNumber = TextEditingController();
  TextEditingController batchNumber = TextEditingController();
  TextEditingController note = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController account = TextEditingController();
  RxString accountId = RxString('');
  TextEditingController currency = TextEditingController();
  TextEditingController rate = TextEditingController();
  TextEditingController transactionType = TextEditingController();
  RxString transactionTypeId = RxString('');
  TextEditingController receivedNumber = TextEditingController();
  String backendUrl = backendTestURI;
  RxString receivedNumberId = RxString('');
  TextEditingController amount = TextEditingController();
  TextEditingController invoiceNumber = TextEditingController();
  TextEditingController invoiceDate = TextEditingController();
  TextEditingController vat = TextEditingController();
  TextEditingController invoiceNote = TextEditingController();
  TextEditingController jobNumber = TextEditingController();
  TextEditingController jobNumberId = TextEditingController();
  TextEditingController searchForJobCards = TextEditingController();
  TextEditingController vendor = TextEditingController();
  RxString vendorId = RxString('');

  Future<Map<String, dynamic>> getReceiptsAndPaymentsTypes() async {
    return await helper.getAllListValues('RECEIPT_TYPES');
  }

  Future<Map<String, dynamic>> getAllAccounts() async {
    return await helper.getAllBanksAndOthers();
  }

  Future<Map<String, dynamic>> getTransactionTypes() async {
    return await helper.getAllAPPaymentTypes();
  }

  Future<Map<String, dynamic>> getAllVendors() async {
    return await helper.getVendors();
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  void onChooseForDatePicker(int i) {
    switch (i) {
      case 1:
        initDatePickerValue.value = 1;
        fromDate.clear();
        toDate.clear();
        filterSearch();
        break;
      case 2:
        initDatePickerValue.value = 2;
        setTodayRange(fromDate: fromDate, toDate: toDate);
        filterSearch();
        break;
      case 3:
        initDatePickerValue.value = 3;
        setThisMonthRange(fromDate: fromDate, toDate: toDate);
        filterSearch();
        break;
      case 4:
        initDatePickerValue.value = 4;
        setThisYearRange(fromDate: fromDate, toDate: toDate);
        filterSearch();
        break;
      default:
    }
  }

  void onChooseForStatusPicker(int i) {
    switch (i) {
      case 1:
        initStatusPickersValue.value = 1;
        statusFilter.clear();
        filterSearch();
        break;
      case 2:
        initStatusPickersValue.value = 2;
        statusFilter.text = 'New';
        filterSearch();
        break;
      case 3:
        initStatusPickersValue.value = 3;
        statusFilter.text = 'Posted';
        filterSearch();
        break;
      default:
    }
  }

  void filterSearch() {}

  Future<Map<String, dynamic>> getReceivedNumbersList() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendUrl/ap_invoices/get_received_number_list');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        List<dynamic> jsonData = decode['received'];
        Map<String, dynamic> map = {
          for (var model in jsonData) model['_id']: model,
        };
        return map;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await getReceivedNumbersList();
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

  void clearItemValues() {
    transactionType.clear();
    transactionTypeId.value = '';
    receivedNumber.clear();
    receivedNumberId.value = '';
    vendor.clear();
    vendorId.value = '';
    amount.clear();
    vat.clear();
    invoiceNumber.clear();
    invoiceDate.text = textToDate(DateTime.now());
    jobNumber.clear();
    jobNumberId.clear();
  }

  void clearAllFilters() {
    initStatusPickersValue.value = 1;
    initDatePickerValue.value = 1;
    statusFilter.clear();
    fromDate.clear();
    toDate.clear();
    isScreenLoding.value = false;
    batchNumberFilter.clear();
    batchNoteFilter.clear();
  }
}
