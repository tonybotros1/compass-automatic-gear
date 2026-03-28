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
  RxBool postingBatch = RxBool(false);
  RxInt numberOfBatches = RxInt(0);
  RxString currentBatchStatus = RxString('');
  RxList<BatchPaymentProcessModel> batchesList =
      RxList<BatchPaymentProcessModel>([]);
  RxList<BatchPaymentProcessItemsModel> items =
      RxList<BatchPaymentProcessItemsModel>([]);
  RxBool addingNewValue = RxBool(false);
  RxBool addingNewItemValue = RxBool(false);
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
  RxString currentBatchId = RxString('');

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

  Future getBatchStatus(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendTestURI/batch_payment_process/get_batch_status/$id',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final status = decoded['data'];
        return status;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await getBatchStatus(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  Future<void> addNewBatch() async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';

      Map<String, dynamic> body = {
        "batch_date": batchDate.text.isNotEmpty
            ? convertDateToIson(batchDate.text)
            : null,
        "note": note.text,
        "payment_type": paymentTypeId.value,
        "cheque_number": chequeNumber.text,
        "cheque_date": chequeDate.text.isNotEmpty
            ? convertDateToIson(chequeDate.text)
            : null,
        "account": accountId.value,
        "currency": currency.text,
        "rate": rate.text.isEmpty ? '0' : rate.text,
      };
      if (currentBatchId.value.isEmpty) {
        var url = Uri.parse(
          '$backendUrl/batch_payment_process/add_new_batch_payment_process',
        );
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
          currentBatchId.value = decoded['_id'];
          batchNumber.text = decoded['batch_number'];
          currentBatchStatus.value = decoded['status'];
          BatchPaymentProcessModel newBatch = BatchPaymentProcessModel(
            id: decoded['_id'],
            batchDate: DateTime.tryParse(batchDate.text),
            batchNumber: decoded['batch_number'],
            note: note.text,
            status: decoded['status'],
          );
          batchesList.insert(0, newBatch);
        } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
          final refreshed = await helper.refreshAccessToken(refreshToken);
          if (refreshed == RefreshResult.success) {
            await addNewBatch();
          } else if (refreshed == RefreshResult.invalidToken) {
            logout();
          }
        } else if (response.statusCode == 401) {
          logout();
        } else {}
      } else {
        body['status'] = currentBatchStatus.value;
        var updateURL = Uri.parse(
          '$backendUrl/batch_payment_process/update_batch_payment_process/${currentBatchId.value}',
        );
        final updateResponse = await http.patch(
          updateURL,
          headers: {
            'Authorization': 'Bearer $accessToken',
            "Content-Type": "application/json",
          },
          body: jsonEncode(body),
        );
        if (updateResponse.statusCode == 200) {
          final decoded = jsonDecode(updateResponse.body);
          currentBatchId.value = decoded['_id'];
          batchNumber.text = decoded['batch_number'];
          currentBatchStatus.value = decoded['status'];
          int index = batchesList.indexWhere(
            (b) => b.id == currentBatchId.value,
          );
          BatchPaymentProcessModel updatedBatch = BatchPaymentProcessModel(
            id: currentBatchId.value,
            batchDate: DateTime.tryParse(batchDate.text),
            batchNumber: batchNumber.text,
            note: note.text,
            status: currentBatchStatus.value,
          );
          batchesList[index] = updatedBatch;
          batchesList.refresh();
        } else if (updateResponse.statusCode == 401 &&
            refreshToken.isNotEmpty) {
          final refreshed = await helper.refreshAccessToken(refreshToken);
          if (refreshed == RefreshResult.success) {
            await addNewBatch();
          } else if (refreshed == RefreshResult.invalidToken) {
            logout();
          }
        } else if (updateResponse.statusCode == 401) {
          logout();
        } else {}
      }

      addingNewValue.value = false;
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  Future<void> addNewItem() async {
    try {
      addingNewItemValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendUrl/batch_payment_process/add_batch_item/${currentBatchId.value}',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "transaction_type": transactionTypeId.value,
          "received_number": receivedNumberId.value,
          "vendor": vendorId.value,
          "amount": amount.text.isEmpty ? 0 : double.tryParse(amount.text),
          "vat": vat.text.isEmpty ? 0 : double.tryParse(vat.text),
          "invoice_number": invoiceNumber.text,
          "invoice_date": invoiceDate.text.isNotEmpty
              ? convertDateToIson(invoiceDate.text)
              : null,
          "job_number_id": jobNumberId.text.isNotEmpty
              ? jobNumberId.text
              : null,
          "note": invoiceNote.text,
        }),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        String itemId = decoded['_id'];
        BatchPaymentProcessItemsModel newBatchItem =
            BatchPaymentProcessItemsModel(
              id: itemId,
              transactionType: transactionTypeId.value,
              transactionTypeName: transactionType.text,
              note: invoiceNote.text,
              invoiceNumber: invoiceNumber.text,
              invoiceDate: DateTime.tryParse(
                convertDateToIson(invoiceDate.text).toString(),
              ),
              amount: double.tryParse(amount.text),
              vat: double.tryParse(vat.text),
              jobNumber: jobNumber.text,
              jobNumberId: jobNumberId.text,
              receivingNumber: receivedNumber.text,
              receivingNumberId: receivedNumberId.value,
              vendor: vendorId.value,
              vendorName: vendor.text,
            );
        items.insert(0, newBatchItem);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewItem();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      addingNewItemValue.value = false;
    } catch (e) {
      addingNewItemValue.value = false;
    }
  }

  Future<void> updateItem(String itemId) async {
    try {
      Map status = await getBatchStatus(currentBatchId.value);
      String status1 = status['status'];
      if ((status1 == 'Posted')) {
        alertMessage(
          context: Get.context!,
          content: 'Can\'t edit items for posted batches',
        );
        return;
      }
      addingNewItemValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendUrl/batch_payment_process/update_batch_item/$itemId',
      );
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "transaction_type": transactionTypeId.value,
          "received_number": receivedNumberId.value,
          "vendor": vendorId.value,
          "amount": amount.text.isEmpty ? 0 : double.tryParse(amount.text),
          "vat": vat.text.isEmpty ? 0 : double.tryParse(vat.text),
          "invoice_number": invoiceNumber.text,
          "invoice_date": invoiceDate.text.isNotEmpty
              ? convertDateToIson(invoiceDate.text)
              : null,
          "job_number_id": jobNumberId.text.isNotEmpty
              ? jobNumberId.text
              : null,
          "note": invoiceNote.text,
        }),
      );
      if (response.statusCode == 200) {
        BatchPaymentProcessItemsModel updatedBatchItem =
            BatchPaymentProcessItemsModel(
              id: itemId,
              transactionType: transactionTypeId.value,
              transactionTypeName: transactionType.text,
              note: invoiceNote.text,
              invoiceNumber: invoiceNumber.text,
              invoiceDate: DateTime.tryParse(
                convertDateToIson(invoiceDate.text).toString(),
              ),
              amount: double.tryParse(amount.text),
              vat: double.tryParse(vat.text),
              jobNumber: jobNumber.text,
              jobNumberId: jobNumberId.text,
              receivingNumber: receivedNumber.text,
              receivingNumberId: receivedNumberId.value,
              vendor: vendorId.value,
              vendorName: vendor.text,
            );
        int index = items.indexWhere((item) => item.id == itemId);
        items[index] = updatedBatchItem;
        items.refresh();
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewItem();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      addingNewItemValue.value = false;
    } catch (e) {
      addingNewItemValue.value = false;
    }
  }

  Future<void> deleteItem(String itemId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      final refreshToken = await secureStorage.read(key: "refreshToken") ?? '';

      final url = Uri.parse(
        '$backendUrl/batch_payment_process/delete_batch_item/$itemId',
      );

      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      switch (response.statusCode) {
        case 200:
          final decoded = jsonDecode(response.body);
          final removedItem = decoded['_id'];

          items.removeWhere((i) => i.id == removedItem);
          Get.back();
          break;

        case 204:
          items.removeWhere((i) => i.id == itemId);
          Get.back();
          break;

        case 401:
          if (refreshToken.isNotEmpty) {
            final refreshed = await helper.refreshAccessToken(refreshToken);

            if (refreshed == RefreshResult.success) {
              await deleteItem(itemId);
            } else {
              logout();
            }
          } else {
            logout();
          }
          break;

        case 404:
          Get.back();
          alertMessage(context: Get.context!, content: "Item not found");
          break;

        case 500:
          Get.back();
          alertMessage(context: Get.context!, content: "Server error");
          break;

        default:
          Get.back();
          alertMessage(context: Get.context!, content: "Unexpected error");
          break;
      }
    } catch (e) {
      Get.back();
      alertMessage(context: Get.context!, content: "Exception in deleteItem");
    }
  }

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

  Future<Map<String, dynamic>> getBatchPaymentPtocessDetails(
    String batchId,
  ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendUrl/batch_payment_process/get_batch_payment_process_details/$batchId',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        Map<String, dynamic> jsonData = decode['batch_details'];
        return jsonData;
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

  void filterSearch() async {
    Map<String, dynamic> body = {};
    if (batchNumberFilter.text.isNotEmpty) {
      body["batch_number"] = batchNumberFilter.text;
    }
    if (batchNoteFilter.text.isNotEmpty) {
      body["note"] = batchNoteFilter.text;
    }
    if (statusFilter.text.isNotEmpty) {
      body["status"] = statusFilter.text;
    }

    if (fromDate.value.text.isNotEmpty) {
      body["from_date"] = convertDateToIson(fromDate.value.text);
    }
    if (toDate.value.text.isNotEmpty) {
      body["to_date"] = convertDateToIson(toDate.value.text);
    }
    if (body.isNotEmpty) {
      await searchEngineForBatches(body);
    } else {
      await searchEngineForBatches({"all": true});
    }
  }

  Future<Map<String, dynamic>> searchEngineForJobCard() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/job_cards/search_engine_for_job_card_in_ap_invoices_screen',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({}),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List invs = decoded['job_cards'];
        return {for (var inv in invs) inv['_id']: inv};
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await searchEngineForJobCard();
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

  Future<void> searchEngineForBatches(Map<String, dynamic> body) async {
    try {
      isScreenLoding.value = true;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/batch_payment_process/search_engine_for_batch_payment_process',
      );
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
        List batches = decoded['batches'];
        // Map grandTotals = decoded['grand_totals'];

        batchesList.assignAll(
          batches.map((batch) => BatchPaymentProcessModel.fromJson(batch)),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await searchEngineForBatches(body);
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

  Future<void> postBatch(String batchId) async {
    try {
      Map status = await getBatchStatus(batchId);
      String status1 = status['status'];
      if ((status1 == 'Posted')) {
        alertMessage(context: Get.context!, content: 'Batch is already posted');
        return;
      }
      postingBatch.value = true;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/batch_payment_process/post_batch/$batchId',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        final decodeed = jsonDecode(response.body);
        String bStatus = decodeed['status'];
        currentBatchStatus.value = bStatus;

        int index = batchesList.indexWhere((item) => item.id == batchId);
        batchesList[index].status = currentBatchStatus.value;
        batchesList.refresh();
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await postBatch(batchId);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      postingBatch.value = false;
    } catch (e) {
      postingBatch.value = false;
    }
  }

  void clearValues() {
    currentBatchId.value = '';
    batchNumber.clear();
    batchDate.text = textToDate(DateTime.now());
    note.clear();
    paymentType.clear();
    paymentTypeId.value = '';
    chequeNumber.clear();
    chequeDate.clear();
    account.clear();
    accountId.value = '';
    currency.clear();
    rate.clear();
    currentBatchStatus.value = '';
    items.clear();
  }

  Future<void> loadValues(String batchId) async {
    final data = await getBatchPaymentPtocessDetails(batchId);
    final batch = BatchPaymentProcessModel.fromJson(data);
    currentBatchId.value = batch.id ?? '';
    batchNumber.text = batch.batchNumber ?? '';
    currentBatchStatus.value = batch.status ?? '';
    batchDate.text = textToDate(batch.batchDate);
    note.text = batch.note ?? '';
    paymentType.text = batch.paymentTypeName ?? '';
    if (paymentType.text.toLowerCase() == 'cheque') {
      isChequeSelected.value = true;
    }
    paymentTypeId.value = batch.paymentType ?? '';
    chequeNumber.text = batch.chequeNumber ?? '';
    chequeDate.text = textToDate(batch.chequeDate);
    account.text = batch.accountName ?? '';
    accountId.value = batch.account ?? '';
    currency.text = batch.currency ?? '';
    rate.text = (batch.rate ?? 1).toString();
    items.assignAll(batch.itemsDetails ?? []);
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
    invoiceNote.clear();
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
