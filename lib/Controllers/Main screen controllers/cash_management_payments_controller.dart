import 'dart:convert';
import 'package:datahubai/Controllers/Main%20screen%20controllers/cahs_management_base_controller.dart';
import 'package:datahubai/Models/ar%20receipts%20and%20ap%20payments/ap_payments_model.dart';
import 'package:datahubai/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/ar receipts and ap payments/vendor_payments_model.dart';
import '../../consts.dart';

class CashManagementPaymentsController extends CashManagementBaseController {
  Rx<TextEditingController> paymentDate = TextEditingController().obs;
  Rx<TextEditingController> paymentCounter = TextEditingController().obs;
  TextEditingController vendorName = TextEditingController();
  RxBool isScreenLodingForPayments = RxBool(false);
  final RxList<APPaymentModel> allPayements = RxList<APPaymentModel>([]);
  RxString vendorNameId = RxString('');
  RxMap allVendors = RxMap({});
  RxBool isPaymentAdded = RxBool(false);
  RxString currentPaymentID = RxString('');
  RxInt numberOfPayments = RxInt(0);
  RxDouble totalPaymentPaid = RxDouble(0.0);
  String backendUrl = backendTestURI;
  Rx<TextEditingController> paymentTypeFilter = TextEditingController().obs;
  Rx<TextEditingController> vendorNameFilter = TextEditingController().obs;
  RxString paymentTypeFilterId = RxString('');
  RxString vendorNameFilterId = RxString('');
  Rx<TextEditingController> paymentCounterFilter = TextEditingController().obs;

  @override
  void onInit() async {
    searchEngineForPayments({"today": true});
    super.onInit();
  }

  Future<Map<String, dynamic>> getAllVendors() async {
    return await helper.getVendors();
  }

  Future<double> calculateVendorOutstanding(String vendorid) async {
    return await helper.getVendorOutstanding(vendorid);
  }

  Future getCurrentAPPaymentStatus(String id) async {
    return await helper.getAPPaymentStatus(id);
  }

  Future<void> getVendorInvoices(String vendorId) async {
    try {
      loadingInvoices.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/ap_payments/get_all_vendor_invoices/$vendorId',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List invoices = decoded['invoices'];
        availablePayments.assignAll(
          invoices.map((inv) => VendorPaymentsModel.fromJson(inv)),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getVendorInvoices(vendorId);
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

  Future<void> addNewPayment() async {
    try {
      if (currentPaymentID.isNotEmpty) {
        Map currentPaymentStatus = await getCurrentAPPaymentStatus(
          currentPaymentID.value,
        );
        String status1 = currentPaymentStatus['status'];
        if (status1 != 'New' && status1 != '') {
          showSnackBar('Alert', 'Only new payments can be edited');
          return;
        }
      }
      addingNewValue.value = true;
      var newData = {
        'payment_number': paymentCounter.value.text,
        'status': paymentStatus.value,
        'vendor': vendorNameId.value.isEmpty ? null : vendorNameId.value,
        'note': note.text,
        'payment_type': paymentTypeId.value.isEmpty
            ? null
            : paymentTypeId.value,
        'cheque_number': chequeNumber.text,
        'account': accountId.value,
        'currency': currency.text,
        'rate': double.tryParse(rate.text) ?? 1,
        'invoices': selectedAvailablePayments
            .where((inv) => inv.isDeleted != true)
            .map((inv) => inv.toJson())
            .toList(),
      };
      final rawDate = paymentDate.value.text.trim();
      final rawDate2 = chequeDate.value.text.trim();

      if (rawDate.isNotEmpty) {
        try {
          newData['payment_date'] = convertDateToIson(rawDate);
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

      if (currentPaymentID.isEmpty) {
        showSnackBar('Adding', 'Please Wait');
        newData['status'] = 'New';

        Uri url = Uri.parse('$backendUrl/ap_payments/add_new_payment');
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
          APPaymentModel newPayment = APPaymentModel.fromJson(
            decoded['payment'],
          );
          paymentCounter.value.text = newPayment.paymentNumber ?? '';
          currentPaymentID.value = newPayment.id ?? '';
          paymentStatus.value = newPayment.status ?? '';
          selectedAvailablePayments.assignAll(newPayment.invoicesDetails ?? []);
          isPaymentModified.value = false;
          for (var element in selectedAvailablePayments) {
            element.isAdded = null;
            element.isDeleted = null;
            element.isModified = null;
          }
          isPaymentInvoicesModified.value = false;
          showSnackBar('Done', 'Added Successfully');
        } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
          final refreshed = await helper.refreshAccessToken(refreshToken);
          if (refreshed == RefreshResult.success) {
            await addNewPayment();
          } else if (refreshed == RefreshResult.invalidToken) {
            logout();
          }
        } else if (response.statusCode == 401) {
          logout();
        }
      } else {
        if (isPaymentModified.isTrue || isPaymentInvoicesModified.isTrue) {
          http.Response? responseForEditingPayment;
          http.Response? responseForEditingPaymentInvoices;

          showSnackBar('Updating', 'Please Wait');
          if (isPaymentModified.isTrue) {
            Uri updatingJobUrl = Uri.parse(
              '$backendUrl/ap_payments/update_ap_payment/${currentPaymentID.value}',
            );
            Map<String, dynamic> newDataToUpdate = newData;

            newDataToUpdate.remove('invoices');

            responseForEditingPayment = await http.patch(
              updatingJobUrl,
              headers: {
                'Authorization': 'Bearer $accessToken',
                "Content-Type": "application/json",
              },
              body: jsonEncode(newDataToUpdate),
            );
            if (responseForEditingPayment.statusCode == 200) {
              isPaymentModified.value = false;
            } else if (responseForEditingPayment.statusCode == 401 &&
                refreshToken.isNotEmpty) {
              final refreshed = await helper.refreshAccessToken(refreshToken);
              if (refreshed == RefreshResult.success) {
                await addNewPayment();
              } else if (refreshed == RefreshResult.invalidToken) {
                logout();
              }
            } else if (responseForEditingPayment.statusCode == 401) {
              logout();
            }
          }
          if (isPaymentInvoicesModified.isTrue) {
            Uri updatingPaymentInvoicesUrl = Uri.parse(
              '$backendUrl/ap_payment/update_payment_invoices',
            );
            responseForEditingPaymentInvoices = await http.patch(
              updatingPaymentInvoicesUrl,
              headers: {
                'Authorization': 'Bearer $accessToken',
                "Content-Type": "application/json",
              },
              body: jsonEncode(
                selectedAvailablePayments
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
            if (responseForEditingPaymentInvoices.statusCode == 200) {
              final decoded = jsonDecode(
                responseForEditingPaymentInvoices.body,
              );
              List updatedItems = decoded['updated_items'];
              List deletedItems = decoded['deleted_items'];
              if (deletedItems.isNotEmpty) {
                for (var id in deletedItems) {
                  selectedAvailablePayments.removeWhere(
                    (item) => item.id == id,
                  );
                }
              }
              if (updatedItems.isNotEmpty) {
                for (var item in updatedItems) {
                  var jobId = item['ap_invoice_id'];
                  var id = item['_id'];
                  final localIndex = selectedAvailablePayments.indexWhere(
                    (item) => item.jobId == jobId,
                  );

                  if (localIndex != -1) {
                    selectedAvailablePayments[localIndex].id = id;
                    selectedAvailablePayments[localIndex].isAdded = false;
                    selectedAvailablePayments[localIndex].isModified = false;
                    selectedAvailablePayments[localIndex].isDeleted = false;
                  }
                }
              }
              isPaymentInvoicesModified.value = false;
            } else if (responseForEditingPaymentInvoices.statusCode == 401 &&
                refreshToken.isNotEmpty) {
              final refreshed = await helper.refreshAccessToken(refreshToken);
              if (refreshed == RefreshResult.success) {
                await addNewPayment();
              } else if (refreshed == RefreshResult.invalidToken) {
                logout();
              }
            } else if (responseForEditingPaymentInvoices.statusCode == 401) {
              logout();
            }
          }
          if ((responseForEditingPaymentInvoices?.statusCode == 200) ||
              (responseForEditingPayment?.statusCode == 200)) {
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

  
  Future<void> deletePayment(String id) async {
    try {
     
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/ap_payments/delete_payment/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        String deletedpaymentId = decoded['payment_id'];
        allPayements.removeWhere((job) => job.id == deletedpaymentId);
        numberOfPayments.value -= 1;
        Get.close(2);
        showSnackBar('Success', 'Payment deleted successfully');
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        final decoded =
            jsonDecode(response.body) ?? 'Failed to delete payment';
        String error = decoded['detail'];
        showSnackBar('Alert', error);
      } else if (response.statusCode == 403) {
        final decoded = jsonDecode(response.body);
        String error = decoded['detail'] ?? 'Only New Payments Allowed';
        showSnackBar('Alert', error);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deletePayment(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 500) {
        final decoded = jsonDecode(response.body);
        final error =
            decoded['detail'] ?? 'Server error while deleting payment';
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
    if (paymentCounterFilter.value.text.isNotEmpty) {
      body["payment_number"] = paymentCounterFilter.value.text;
    }
    if (paymentTypeFilterId.value.isNotEmpty) {
      body["payment_type"] = paymentTypeFilterId.value;
    }
    if (vendorNameFilterId.value.isNotEmpty) {
      body["vendor_name"] = vendorNameFilterId.value;
    }
    if (accountFilterId.value.isNotEmpty) {
      body["account"] = accountFilterId.value;
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
      await searchEngineForPayments(body);
    } else {
      await searchEngineForPayments({"all": true});
    }
  }

  Future<void> searchEngineForPayments(Map<String, dynamic> body) async {
    try {
      isScreenLodingForPayments.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/ap_payments/search_engine_for_ap_payments',
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
        List recs = decoded['payments'];
        Map grandTotals = decoded['grand_totals'];
        totalPaymentPaid.value = grandTotals['grand_given'];
        allPayements.assignAll(recs.map((rec) => APPaymentModel.fromJson(rec)));
        numberOfPayments.value = allPayements.length;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await searchEngineForPayments(body);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }

      isScreenLodingForPayments.value = false;
    } catch (e) {
      isScreenLodingForPayments.value = false;
    }
  }

  void addSelectedPayments() {
    final existingapInvoiceIds = selectedAvailablePayments
        .map((r) => r.apInvoiceId)
        .toSet();

    for (final payment in availablePayments.where(
      (r) => r.isSelected == true,
    )) {
      if (existingapInvoiceIds.contains(payment.apInvoiceId)) {
        final idx = selectedAvailablePayments.indexWhere(
          (i) => i.apInvoiceId == payment.apInvoiceId,
        );

        if (idx != -1) {
          final existing = selectedAvailablePayments[idx];
          existing
            ..paymentId = currentPaymentID.value
            ..isDeleted = false
            ..isAdded = true
            ..isSelected = true;
        }

        payment
          ..paymentId = currentPaymentID.value
          ..isDeleted = false
          ..isAdded = true
          ..isSelected = true;
      } else {
        payment
          ..paymentId = currentPaymentID.value
          ..isAdded = true
          ..isSelected = true
          ..isDeleted = false;

        selectedAvailablePayments.add(payment);
        existingapInvoiceIds.add(
          payment.apInvoiceId,
        ); // keep the set up to date
      }
    }

    isPaymentModified.value = true;
    selectedAvailablePayments.refresh();
    availablePayments.refresh();
    Get.back();
  }
  // =======================================================================================================================

  Future<void> loadValuesForPayments(APPaymentModel data) async {
    paymentStatus.value = data.status ?? '';
    isPaymentAdded.value = true;
    availablePayments.clear();
    selectedAvailablePayments.clear();
    isPaymentModified.value = false;
    isPaymentInvoicesModified.value = false;
    selectedAvailablePayments.assignAll(data.invoicesDetails ?? []);
    currentPaymentID.value = data.id ?? '';

    calculateAmountForSelectedPayments();
    if (data.vendor != '' && data.vendor != null) {
      outstanding.value = formatter.formatEditUpdate(
        outstanding.value,
        TextEditingValue(
          text: await calculateVendorOutstanding(data.vendor ?? '').then((
            value,
          ) {
            return value.toString();
          }),
        ),
      );
    } else {
      outstanding.text = "0.0";
    }
    vendorName.text = data.vendorName ?? '';
    vendorNameId.value = data.vendor ?? '';

    paymentCounter.value.text = data.paymentNumber ?? '';
    paymentDate.value.text = textToDate(data.paymentDate);

    note.text = data.note ?? '';
    paymentType.text = data.paymentTypeName ?? '';
    paymentType.text == 'Cheque'
        ? isChequeSelected.value = true
        : isChequeSelected.value = false;
    paymentTypeId.value = data.paymentType ?? '';
    chequeNumber.text = data.chequeNumber ?? '';
    chequeDate.text = textToDate(data.chequeDate);

    account.text = data.accountNumber ?? '';
    accountId.value = data.account ?? '';
    currency.text = data.currency ?? '';
    rate.text = data.rate.toString();
  }

  void clearValues() {
    currency.clear();
    rate.clear();
    account.clear();
    accountId.value = '';
    outstanding.clear();
    isPaymentAdded.value = false;
    paymentDate.value.text = textToDate(DateTime.now().toString());
    paymentCounter.value.clear();
    paymentType.clear();
    vendorName.clear();
    note.clear();
    chequeNumber.clear();
    chequeDate.clear();
    isChequeSelected.value = false;
    paymentTypeId.value = '';
    vendorNameId.value = '';
    availablePayments.clear();
    selectedAvailablePayments.clear();
    isAllPaymentsSelected.value = false;
    calculatedAmountForAllSelectedPayments.value = 0.0;
    currentPaymentID.value = '';
    paymentStatus.value = '';
  }

  void clearAllFilters() {
    statusFilter.value.clear();
    isAllSelected.value = false;
    isTodaySelected.value = false;
    isThisMonthSelected.value = false;
    isThisYearSelected.value = false;
    paymentCounterFilter.value = TextEditingController();
    chequeNumberFilter.value.clear();
    vendorNameFilter.value.clear();
    vendorNameFilterId = RxString('');
    paymentTypeFilterId = RxString('');
    accountFilterId = RxString('');
    paymentTypeFilter.value.clear();
    accountFilter.value.clear();
    bankNameFilter.value.clear();
    bankNameFilterId = RxString('');
    fromDate.value.clear();
    toDate.value.clear();
  }
}
