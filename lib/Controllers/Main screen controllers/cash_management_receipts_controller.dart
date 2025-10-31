import 'dart:convert';
import 'package:datahubai/Controllers/Main%20screen%20controllers/cahs_management_base_controller.dart';
import 'package:datahubai/Models/ar%20receipts%20and%20ap%20payments/ar_receipts_model.dart';
import 'package:datahubai/Models/ar%20receipts%20and%20ap%20payments/customer_invoices_model.dart';
import 'package:datahubai/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../consts.dart';

class CashManagementReceiptsController extends CashManagementBaseController {
  Rx<TextEditingController> receiptDate = TextEditingController().obs;
  Rx<TextEditingController> receiptCounter = TextEditingController().obs;
  TextEditingController customerName = TextEditingController();
  RxBool isScreenLodingForReceipts = RxBool(false);
  final RxList<ARReceiptsModel> allReceipts = RxList<ARReceiptsModel>([]);
  RxString customerNameId = RxString('');
  RxInt numberOfReceipts = RxInt(0);
  RxDouble totalReceiptsReceived = RxDouble(0.0);
  String backendUrl = backendTestURI;
  RxBool isInvoicesModified = RxBool(false);
  RxString currentReceiptID = RxString('');

  @override
  void onInit() async {
    searchEngineForReceipts({'today': true});
    super.onInit();
  }

  Future<Map<String, dynamic>> getAllCustomers() async {
    return await helper.getCustomers();
  }

  Future<double> calculateCustomerOutstanding(String customerId) async {
    return await helper.getCustomerOutstanding(customerId);
  }

  Future getCurrentARReceiptStatus(String id) async {
    return await helper.getARREceiptStatus(id);
  }

  Future<void> getCustomerInvoices(String customerId) async {
    try {
      loadingInvoices.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/ar_receipts/get_all_customer_invoices/$customerId',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List invoices = decoded['invoices'];
        availableReceipts.assignAll(
          invoices.map((inv) => CustomerInvoicesModel.fromJson(inv)),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getCustomerInvoices(customerId);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      loadingInvoices.value = false;
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
      loadingInvoices.value = false;
    }
  }

  Future<void> addNewReceipts() async {
    try {
      if (currentReceiptID.isNotEmpty) {
        Map currentReceiptStatus = await getCurrentARReceiptStatus(
          currentReceiptID.value,
        );
        String status1 = currentReceiptStatus['status'];
        if (status1 != 'New' && status1 != '') {
          showSnackBar('Alert', 'Only new jobs can be edited');
          return;
        }
      }
      addingNewValue.value = true;
      Map<String, dynamic> newData = {
        'status': status.value,
        'customer': customerNameId.value.isEmpty ? null : customerNameId.value,
        'note': note.text,
        'receipt_type': receiptTypeId.value.isEmpty
            ? null
            : receiptTypeId.value,
        'cheque_number': chequeNumber.text,
        'bank_name': bankId.value.isEmpty ? null : bankId.value,
        'invoices': selectedAvailableReceipts
            .where((inv) => inv.isDeleted != true)
            .map((inv) => inv.toJson())
            .toList(),
        'account': accountId.value.isEmpty ? null : accountId.value,
        'currency': currency.text,
        'rate': double.tryParse(rate.text) ?? 1,
      };
      final rawDate = receiptDate.value.text.trim();
      final rawDate2 = chequeDate.value.text.trim();

      if (rawDate.isNotEmpty) {
        try {
          newData['receipt_date'] = convertDateToIson(rawDate);
        } catch (e) {
          showSnackBar('Alert', 'Please Enter Valid Receipt Date');
          return;
        }
      }

      if (rawDate2.isNotEmpty) {
        try {
          newData['cheque_date'] = convertDateToIson(rawDate2);
        } catch (e) {
          showSnackBar('Alert', 'Please Enter Valid Cheque Date');
          return;
        }
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';

      if (currentReceiptID.isEmpty) {
        showSnackBar('Adding', 'Please Wait');
        newData['status'] = 'New';

        Uri url = Uri.parse('$backendUrl/ar_receipts/add_new_receipt');
        final response = await http.post(
          url,
          headers: {
            'Authorization': 'Bearer $accessToken',
            "Content-Type": "application/json",
          },
          body: jsonEncode(newData),
        );
        if (response.statusCode == 200) {
          final decoded = jsonDecode(response.body);
          ARReceiptsModel newReceipt = ARReceiptsModel.fromJson(
            decoded['receipt'],
          );
          receiptCounter.value.text = newReceipt.receiptNumber ?? '';
          currentReceiptID.value = newReceipt.id ?? '';
          status.value = newReceipt.status ?? '';
          selectedAvailableReceipts.assignAll(newReceipt.invoicesDetails ?? []);
          isReceiptModified.value = false;
          for (var element in selectedAvailableReceipts) {
            element.isAdded = null;
            element.isDeleted = null;
            element.isModified = null;
          }
          isReceiptInvoicesModified.value = false;
          showSnackBar('Done', 'Added Successfully');
        } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
          final refreshed = await helper.refreshAccessToken(refreshToken);
          if (refreshed == RefreshResult.success) {
            await addNewReceipts();
          } else if (refreshed == RefreshResult.invalidToken) {
            logout();
          }
        } else if (response.statusCode == 401) {
          logout();
        }
      } else {
        if (isReceiptModified.isTrue || isReceiptInvoicesModified.isTrue) {
          http.Response? responseForEditingReceipt;
          http.Response? responseForEditingReceiptInvoices;

          showSnackBar('Updating', 'Please Wait');
          if (isReceiptModified.isTrue) {
            Uri updatingJobUrl = Uri.parse(
              '$backendUrl/ar_receipts/update_ar_receipt/${currentReceiptID.value}',
            );
            Map<String, dynamic> newDataToUpdate = newData;

            newDataToUpdate.remove('invoices');

            responseForEditingReceipt = await http.patch(
              updatingJobUrl,
              headers: {
                'Authorization': 'Bearer $accessToken',
                "Content-Type": "application/json",
              },
              body: jsonEncode(newDataToUpdate),
            );
            if (responseForEditingReceipt.statusCode == 200) {
              isReceiptModified.value = false;
            } else if (responseForEditingReceipt.statusCode == 401 &&
                refreshToken.isNotEmpty) {
              final refreshed = await helper.refreshAccessToken(refreshToken);
              if (refreshed == RefreshResult.success) {
                await addNewReceipts();
              } else if (refreshed == RefreshResult.invalidToken) {
                logout();
              }
            } else if (responseForEditingReceipt.statusCode == 401) {
              logout();
            }
          }
          if (isReceiptInvoicesModified.isTrue) {
            Uri updatingJobInvoicesUrl = Uri.parse(
              '$backendUrl/ar_receipts/update_receipt_invoices',
            );
            responseForEditingReceiptInvoices = await http.patch(
              updatingJobInvoicesUrl,
              headers: {
                'Authorization': 'Bearer $accessToken',
                "Content-Type": "application/json",
              },
              body: jsonEncode(
                selectedAvailableReceipts
                    .where(
                      (item) =>
                          (item.isModified == true ||
                          item.isAdded == true ||
                          (item.isDeleted == true)),
                    )
                    .map((item) => item.toJson())
                    .toList(),
              ),
            );
            if (responseForEditingReceiptInvoices.statusCode == 200) {
              final decoded = jsonDecode(
                responseForEditingReceiptInvoices.body,
              );
              List updatedItems = decoded['updated_items'];
              List deletedItems = decoded['deleted_items'];
              if (deletedItems.isNotEmpty) {
                for (var id in deletedItems) {
                  selectedAvailableReceipts.removeWhere(
                    (item) => item.id == id,
                  );
                }
              }
              if (updatedItems.isNotEmpty) {
                for (var item in updatedItems) {
                  var jobId = item['job_id'];
                  var id = item['_id'];
                  final localIndex = selectedAvailableReceipts.indexWhere(
                    (item) => item.jobId == jobId,
                  );

                  if (localIndex != -1) {
                    selectedAvailableReceipts[localIndex].id = id;
                    selectedAvailableReceipts[localIndex].isAdded = false;
                    selectedAvailableReceipts[localIndex].isModified = false;
                    selectedAvailableReceipts[localIndex].isDeleted = false;
                  }
                }
              }
              isReceiptInvoicesModified.value = false;
            } else if (responseForEditingReceiptInvoices.statusCode == 401 &&
                refreshToken.isNotEmpty) {
              final refreshed = await helper.refreshAccessToken(refreshToken);
              if (refreshed == RefreshResult.success) {
                await addNewReceipts();
              } else if (refreshed == RefreshResult.invalidToken) {
                logout();
              }
            } else if (responseForEditingReceiptInvoices.statusCode == 401) {
              logout();
            }
          }
          if ((responseForEditingReceiptInvoices?.statusCode == 200) ||
              (responseForEditingReceipt?.statusCode == 200)) {
            showSnackBar('Done', 'Updated Successfully');
          }
        }
      }

      addingNewValue.value = false;
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
      addingNewValue.value = false;
    }
  }

  Future<void> deleteReceipt(String id) async {
    try {
     
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/ar_receipts/delete_receipt/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        String deletedJobId = decoded['receipt_id'];
        allReceipts.removeWhere((job) => job.id == deletedJobId);
        numberOfReceipts.value -= 1;
        Get.close(2);
        showSnackBar('Success', 'Job card deleted successfully');
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        final decoded =
            jsonDecode(response.body) ?? 'Failed to delete job card';
        String error = decoded['detail'];
        showSnackBar('Alert', error);
      } else if (response.statusCode == 403) {
        final decoded = jsonDecode(response.body);
        String error = decoded['detail'] ?? 'Only New Job Cards Allowed';
        showSnackBar('Alert', error);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteReceipt(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 500) {
        final decoded = jsonDecode(response.body);
        final error =
            decoded['detail'] ?? 'Server error while deleting job card';
        showSnackBar('Server Error', error);
      } else if (response.statusCode == 401) {
        logout();
      }
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  void filterSearch() async {
    Map<String, dynamic> body = {};
    if (receiptCounterFilter.value.text.isNotEmpty) {
      body["receipt_number"] = receiptCounterFilter.value.text;
    }
    if (receiptTypeFilterId.value.isNotEmpty) {
      body["receipt_type"] = receiptTypeFilterId.value;
    }
    if (customerNameFilterId.value.isNotEmpty) {
      body["customer_name"] = customerNameFilterId.value;
    }
    if (accountFilterId.value.isNotEmpty) {
      body["account"] = accountFilterId.value;
    }
    if (bankNameFilterId.value.isNotEmpty) {
      body["bank_name"] = bankNameFilterId.value;
    }
    if (chequeNumberFilter.value.text.isNotEmpty) {
      body["cheque_number"] = chequeNumberFilter.value.text;
    }
    if (statusFilter.value.text.isNotEmpty) {
      body["status"] = statusFilter.value.text;
    }
    if (isTodaySelected.isTrue) {
      body["today"] = true;
    }
    if (isThisMonthSelected.isTrue) {
      body["this_month"] = true;
    }
    if (isThisYearSelected.isTrue) {
      body["this_year"] = true;
    }
    if (fromDate.value.text.isNotEmpty) {
      body["from_date"] = convertDateToIson(fromDate.value.text);
    }
    if (toDate.value.text.isNotEmpty) {
      body["to_date"] = convertDateToIson(toDate.value.text);
    }
    if (body.isNotEmpty) {
      await searchEngineForReceipts(body);
    } else {
      await searchEngineForReceipts({"all": true});
    }
  }

  Future<void> searchEngineForReceipts(Map<String, dynamic> body) async {
    try {
      isScreenLodingForReceipts.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/ar_receipts/search_engine_for_ar_receipts',
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
        List recs = decoded['receipts'];
        Map grandTotals = decoded['grand_totals'];
        totalReceiptsReceived.value = grandTotals['grand_received'];
        allReceipts.assignAll(recs.map((rec) => ARReceiptsModel.fromJson(rec)));
        numberOfReceipts.value = allReceipts.length;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await searchEngineForReceipts(body);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }

      isScreenLodingForReceipts.value = false;
    } catch (e) {
      isScreenLodingForReceipts.value = false;
    }
  }

  void addSelectedReceipts() {
    // Build a set of existing jobIds for O(1) lookup instead of O(n) search
    final existingJobIds = selectedAvailableReceipts
        .map((r) => r.jobId)
        .toSet();

    // Filter once for selected receipts
    for (final receipt in availableReceipts.where(
      (r) => r.isSelected == true,
    )) {
      if (existingJobIds.contains(receipt.jobId)) {
        // Find the existing receipt just once
        final idx = selectedAvailableReceipts.indexWhere(
          (i) => i.jobId == receipt.jobId,
        );

        if (idx != -1) {
          final existing = selectedAvailableReceipts[idx];
          existing
            ..receiptId = currentReceiptID.value
            ..isDeleted = false
            ..isAdded = true
            ..isSelected = true;
        }

        receipt
          ..receiptId = currentReceiptID.value
          ..isDeleted = false
          ..isAdded = true
          ..isSelected = true;
      } else {
        receipt
          ..receiptId = currentReceiptID.value
          ..isAdded = true
          ..isSelected = true
          ..isDeleted = false;

        selectedAvailableReceipts.add(receipt);
        existingJobIds.add(receipt.jobId); // keep the set up to date
      }
    }

    isReceiptInvoicesModified.value = true;
    selectedAvailableReceipts.refresh();
    availableReceipts.refresh();
    Get.back();
  }

  // =======================================================================================================================
  Future<void> loadValuesForReceipts(ARReceiptsModel data) async {
    currentReceiptID.value = data.id ?? '';
    isReceiptModified.value = false;
    isReceiptInvoicesModified.value = false;
    status.value = data.status ?? '';
    availableReceipts.clear();
    selectedAvailableReceipts.assignAll(data.invoicesDetails ?? []);
    receiptCounter.value.text = data.receiptNumber ?? '';
    receiptDate.value.text = textToDate(data.receiptDate);
    customerName.text = data.customerName ?? '';
    customerNameId.value = data.customer ?? '';
    final customerId = data.customer;
    if (customerId != null) {
      outstanding.value = formatter.formatEditUpdate(
        outstanding.value,
        TextEditingValue(
          text: await calculateCustomerOutstanding(customerId).then((value) {
            return value.toString();
          }),
        ),
      );
    }
    note.text = data.note ?? '';
    receiptType.text = data.receiptTypeName ?? '';
    receiptType.text == 'Cheque'
        ? isChequeSelected.value = true
        : isChequeSelected.value = false;
    receiptTypeId.value = data.receiptType ?? '';
    chequeNumber.text = data.chequeNumber ?? '';
    bankName.text = data.bankName ?? '';
    bankId.value = data.bankNameId ?? '';
    chequeDate.text = textToDate(data.chequeDate);

    account.text = data.accountNumber ?? '';
    accountId.value = data.account ?? '';
    currency.text = data.currency ?? '';
    rate.text = data.rate.toString();
    calculateAmountForSelectedReceipts();
  }

  void clearValues() {
    currency.clear();
    rate.clear();
    account.clear();
    accountId.value = '';
    outstanding.clear();
    receiptDate.value.text = textToDate(DateTime.now().toString());
    receiptCounter.value.clear();
    receiptType.clear();
    customerName.clear();
    note.clear();
    chequeNumber.clear();
    bankName.clear();
    chequeDate.clear();
    isChequeSelected.value = false;
    receiptTypeId.value = '';
    customerNameId.value = '';
    availableReceipts.clear();
    selectedAvailableReceipts.clear();
    calculatedAmountForAllSelectedReceipts.value = 0.0;
    currentReceiptID.value = '';
    status.value = '';
  }

  void clearAllFilters() {
    statusFilter.value.clear();
    isAllSelected.value = false;
    isTodaySelected.value = false;
    isThisMonthSelected.value = false;
    isThisYearSelected.value = false;
    receiptCounterFilter.value = TextEditingController();
    chequeNumberFilter.value.clear();
    customerNameFilter.value.clear();
    customerNameFilterId = RxString('');
    receiptTypeFilterId = RxString('');
    accountFilterId = RxString('');
    receiptTypeFilter.value.clear();
    accountFilter.value.clear();
    bankNameFilter.value.clear();
    bankNameFilterId = RxString('');
    fromDate.value.clear();
    toDate.value.clear();
    isScreenLodingForReceipts.value = false;
  }
}
