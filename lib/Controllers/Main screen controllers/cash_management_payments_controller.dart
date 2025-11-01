import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:datahubai/Controllers/Main%20screen%20controllers/cahs_management_base_controller.dart';
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
  final RxList<DocumentSnapshot> allPayements = RxList<DocumentSnapshot>([]);
  RxString vendorNameId = RxString('');
  RxBool postingPayment = RxBool(false);
  RxBool cancellingPayment = RxBool(false);
  RxMap allVendors = RxMap({});
  RxBool isPaymentAdded = RxBool(false);
  RxString currentPaymentID = RxString('');
  RxInt numberOfPayments = RxInt(0);
  RxDouble totalPaymentPaid = RxDouble(0.0);
  String backendUrl = backendTestURI;

  @override
  void onInit() async {
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
        'status': status.value,
        'vendor': vendorNameId.value.isEmpty ? null : vendorNameId.value,
        'note': note.text,
        'payment_type': paymentTypeId.value.isEmpty
            ? null
            : paymentTypeId.value,
        'cheque_number': chequeNumber.text,
        'account': accountId.value,
        'currency': currency.text,
        'rate': double.tryParse(rate.text) ?? 1,
        'invoices': selectedAvailableReceipts
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
          // ARReceiptsModel newReceipt = ARReceiptsModel.fromJson(
          //   decoded['receipt'],
          // );
          // paymentCounter.value.text = newReceipt.receiptNumber ?? '';
          // currentPaymentID.value = newReceipt.id ?? '';
          // status.value = newReceipt.status ?? '';
          // selectedAvailablePayments.assignAll(newReceipt.invoicesDetails ?? []);
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
        if (isReceiptModified.isTrue || isReceiptInvoicesModified.isTrue) {
          http.Response? responseForEditingPayment;
          http.Response? responseForEditingPaymentInvoices;

          showSnackBar('Updating', 'Please Wait');
          if (isReceiptModified.isTrue) {
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

  // Future<void> addNewPayment() async {
  //   try {
  //     addingNewValue.value = true;

  //     Map<String, dynamic> apInvoicesMap = {};
  //     List<String> apInvoicesIds = [];

  //     for (final payment in selectedAvailablePayments) {
  //       //   final String? apInvoiceId = payment['ap_invoice_id'];
  //       //   final dynamic amount = payment['payment_amount'];

  //       //   if (apInvoiceId != null && amount != null) {
  //       //     apInvoicesMap[apInvoiceId] = amount;
  //       //     apInvoicesIds.add(apInvoiceId);
  //       //   }
  //     }

  //     var newData = {
  //       'payment_number': paymentCounter.value.text,
  //       // 'payment_date': paymentDate.value.text,
  //       'vendor': vendorNameId.value,
  //       'note': note.text,
  //       'payment_type': paymentTypeId.value,
  //       'cheque_number': chequeNumber.text,
  //       // 'cheque_date': chequeDate.text,
  //       'ap_invoices': apInvoicesMap,
  //       'ap_invoices_ids': apInvoicesIds,
  //       'account': accountId.value,
  //       'currency': currency.text,
  //       'rate': rate.text,
  //     };

  //     final rawDate = paymentDate.value.text.trim();
  //     final rawDate2 = chequeDate.value.text.trim();

  //     if (rawDate.isNotEmpty) {
  //       try {
  //         newData['payment_date'] = Timestamp.fromDate(
  //           format.parseStrict(rawDate),
  //         );
  //       } catch (e) {
  //         showSnackBar('Alert', 'Please Enter Valid Date');
  //         return;
  //       }
  //     }

  //     if (rawDate2.isNotEmpty) {
  //       try {
  //         newData['cheque_date'] = Timestamp.fromDate(
  //           format.parseStrict(rawDate2),
  //         );
  //       } catch (e) {
  //         showSnackBar('Alert', 'Please Enter Valid Date');
  //         return;
  //       }
  //     }

  //     if (isPaymentAdded.isFalse) {
  //       newData['status'] = 'New';
  //       // newData['company_id'] = companyId.value;
  //       var currentPayment = await FirebaseFirestore.instance
  //           .collection('all_payments')
  //           .add(newData);
  //       status.value = 'New';
  //       currentPaymentID.value = currentPayment.id;
  //       addingNewValue.value = false;
  //       isPaymentAdded.value = true;
  //       showSnackBar('Done', 'Added Successfully');
  //     } else {
  //       await FirebaseFirestore.instance
  //           .collection('all_payments')
  //           .doc(currentPaymentID.value)
  //           .update(newData);
  //       addingNewValue.value = false;
  //       showSnackBar('Done', 'Updated Successfully');
  //     }
  //     update();
  //   } catch (e) {
  //     addingNewValue.value = false;
  //     isPaymentAdded.value = false;
  //     showSnackBar('Failed', 'Please try again');
  //     // Handle any errors here
  //   }
  // }

  void addSelectedPayments() {
    // Build a set of existing jobIds for O(1) lookup instead of O(n) search
    final existingapInvoiceIds = selectedAvailablePayments
        .map((r) => r.apInvoiceId)
        .toSet();

    // Filter once for selected receipts
    for (final payment in availablePayments.where(
      (r) => r.isSelected == true,
    )) {
      if (existingapInvoiceIds.contains(payment.apInvoiceId)) {
        // Find the existing receipt just once
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

  Future<void> loadValuesForPayments(Map data) async {
    status.value = data['status'] ?? '';
    isPaymentAdded.value = true;
    availablePayments.clear();
    selectedAvailablePayments.clear();

    // await getCurrentVendorInvoices(data['ap_invoices_ids']);
    if (data['vendor'] != '') {
      // calculateAmountForSelectedPayments();
      // getVendorOutstanding(data['vendor']);

      vendorName.text = getdataName(
        data['vendor'],
        allVendors,
        title: 'entity_name',
      );
      vendorNameId.value = data['vendor'] ?? '';
    }
    paymentCounter.value.text = data['payment_number'] ?? '';
    paymentDate.value.text = textToDate(data['payment_date']);

    note.text = data['note'] ?? '';
    // paymentType.text = getdataName(data['payment_type'], allReceiptTypes); // need to be fixed
    paymentType.text == 'Cheque'
        ? isChequeSelected.value = true
        : isChequeSelected.value = false;
    paymentTypeId.value = data['payment_type'] ?? '';
    chequeNumber.text = data['cheque_number'] ?? '';
    chequeDate.text = textToDate(data['cheque_date']);

    // account.text = getdataName( // need to be fixed
    //   data['account'],
    //   allAccounts,
    //   title: 'account_number',
    // );
    accountId.value = data['account'];
    currency.text = data['currency'] ?? '';
    rate.text = data['rate'] ?? '';
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
    bankName.clear();
    chequeDate.clear();
    isChequeSelected.value = false;
    paymentTypeId.value = '';
    vendorNameId.value = '';
    availablePayments.clear();
    selectedAvailablePayments.clear();
    isAllPaymentsSelected.value = false;
    calculatedAmountForAllSelectedPayments.value = 0.0;
    currentPaymentID.value = '';
    status.value = '';
  }

  Future<double> calculateTotalPaymentsForAPInvoices(String apId) async {
    try {
      double total = 0.0;
      var payments = await FirebaseFirestore.instance
          .collection('all_payments')
          .where('ap_invoices_ids', arrayContains: apId)
          .get();

      for (var pay in payments.docs) {
        Map apInvoices = pay['ap_invoices'] ?? {};
        total += double.parse(apInvoices[apId] ?? '0.0');
      }
      return total;
    } catch (e) {
      return 0.0;
    }
  }

  Future<double> getPaymentPaidAmount(String receiptId) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'get_payment_paid_amount',
      );

      final HttpsCallableResult result = await callable.call(receiptId);

      // ✅ Extract the total from the map correctly
      final data = result.data;
      return double.tryParse(data['total_paid_amount'].toString()) ?? 0.0;
    } catch (e) {
      return 0.0;
    } finally {
      loadingInvoices.value = false;
    }
  }

  Future<void> editPayment(String id) async {
    try {
      addingNewValue.value = true;

      Map<String, dynamic> apInvoiceMap = {};
      List<String> apInvoiceIds = [];

      for (final payment in selectedAvailablePayments) {
        //   final String? apInvoiceId = payment['ap_invoice_id'];
        //   final dynamic amount = payment['payment_amount'];

        //   if (apInvoiceId != null && amount != null) {
        //     apInvoiceMap[apInvoiceId] = amount;
        //     apInvoiceIds.add(apInvoiceId);
        //   }
      }

      var newData = {
        'vendor': vendorNameId.value,
        'note': note.text,
        'payment_type': paymentTypeId.value,
        'cheque_number': chequeNumber.text,
        'ap_invoices': apInvoiceMap,
        'ap_invoices_ids': apInvoiceIds,
        'account': accountId.value,
        'rate': rate.text,
      };
      final rawDate = paymentDate.value.text.trim();
      final rawDate2 = chequeDate.value.text.trim();

      if (rawDate.isNotEmpty) {
        try {
          newData['payment_date'] = Timestamp.fromDate(
            format.parseStrict(rawDate),
          );
        } catch (e) {
          showSnackBar('Alert', 'Please Enter Valid Date');
          return;
        }
      }

      if (rawDate2.isNotEmpty) {
        try {
          newData['cheque_date'] = Timestamp.fromDate(
            format.parseStrict(rawDate2),
          );
        } catch (e) {
          showSnackBar('Alert', 'Please Enter Valid Date');
          return;
        }
      }

      await FirebaseFirestore.instance
          .collection('all_payments')
          .doc(id)
          .update(newData);
      addingNewValue.value = false;
      showSnackBar('Done', 'Updated Successfully');
    } catch (e) {
      addingNewValue.value = false;
      showSnackBar('Alert', 'Something Went Wrong');
    }
  }

  Future<void> deletePayment(String id) async {
    try {
      Get.close(2);
      await FirebaseFirestore.instance
          .collection('all_payments')
          .doc(id)
          .delete();
    } catch (e) {
      showSnackBar('Alert', 'Something Went Wrong');
    }
  }

  Future<void> postPayment(String paymentID) async {
    try {
      if (isPaymentAdded.isFalse) {
        showSnackBar('Alert', 'Please Save Payment First');
        return;
      }

      if (status.value == 'Posted') {
        showSnackBar('Alert', 'Payment is Already Posted');
        return;
      }
      // await getCurrentPaymentCounterNumber();
      // paymentDate.value.text = textToDate(DateTime.now().toString());

      FirebaseFirestore.instance
          .collection('all_payments')
          .doc(paymentID)
          .update({
            'status': 'Posted',
            // 'receipt_date': receiptDate.value.text,
            'payment_number': paymentCounter.value.text,
          });
      status.value = 'Posted';
      showSnackBar('Done', 'Payment Posted');
      update();
    } catch (e) {
      showSnackBar('Something Went Wrong', 'Please try again');
    }
  }

  Future<void> cancelPayment(String paymentID) async {
    try {
      if (isPaymentAdded.isFalse) {
        showSnackBar('Alert', 'Please Save Payment First');
        return;
      }

      if (status.value == 'Cancelled') {
        showSnackBar('Alert', 'Payment is Already Cancelled');
        return;
      }

      FirebaseFirestore.instance
          .collection('all_payments')
          .doc(paymentID)
          .update({'status': 'Cancelled'});
      status.value = 'Cancelled';
      showSnackBar('Done', 'Payment Cancelled');
      update();
    } catch (e) {
      showSnackBar('Something Went Wrong', 'Please try again');
    }
  }

  Future<void> calculateMoneyForAllPayments() async {
    try {
      totalPaymentPaid.value = 0.0;

      for (var payment in allPayements) {
        var data = payment.data() as Map<String, dynamic>?;
        Map apInvoices = data?['ap_invoices'];
        for (var value in apInvoices.values) {
          totalPaymentPaid.value += double.tryParse(value) ?? 0.0;
        }
      }
    } catch (e) {
      // print(e);
    }
  }

  Future<void> searchEngineForPayments() async {
    isScreenLodingForPayments.value = true;

    Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection(
      'all_payments',
    );
    // .where('company_id', isEqualTo: companyId.value);

    if (isAllSelected.value) {
    } else if (isTodaySelected.value) {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      fromDate.value.text = textToDate(startOfDay);
      toDate.value.text = textToDate(endOfDay);
      query = query
          .where(
            'payment_date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
          )
          .where('payment_date', isLessThan: Timestamp.fromDate(endOfDay));
    } else if (isThisMonthSelected.value) {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = (now.month < 12)
          ? DateTime(now.year, now.month + 1, 1)
          : DateTime(now.year + 1, 1, 1);
      fromDate.value.text = textToDate(startOfMonth);
      toDate.value.text = textToDate(endOfMonth);
      query = query
          .where(
            'payment_date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth),
          )
          .where('payment_date', isLessThan: Timestamp.fromDate(endOfMonth));
    } else if (isThisYearSelected.value) {
      final now = DateTime.now();
      final startOfYear = DateTime(now.year, 1, 1);
      final endOfYear = DateTime(now.year + 1, 1, 1);
      fromDate.value.text = textToDate(startOfYear);
      toDate.value.text = textToDate(endOfYear);
      query = query
          .where(
            'payment_date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfYear),
          )
          .where('payment_date', isLessThan: Timestamp.fromDate(endOfYear));
    } else {
      if (fromDate.value.text.trim().isNotEmpty) {
        try {
          final dtFrom = format.parseStrict(fromDate.value.text.trim());
          query = query.where(
            'payment_date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(dtFrom),
          );
        } catch (_) {}
      }
      if (toDate.value.text.trim().isNotEmpty) {
        try {
          final dtTo = format
              .parseStrict(toDate.value.text.trim())
              .add(const Duration(days: 1));
          query = query.where(
            'payment_date',
            isLessThan: Timestamp.fromDate(dtTo),
          );
        } catch (_) {}
      }
    }

    final snapshot = await query.get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> fetchedReceipts =
        snapshot.docs;

    List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredReceipts =
        fetchedReceipts.where((doc) {
          final data = doc.data();

          if (receiptCounterFilter.value.text.trim().isNotEmpty &&
              data['payment_number'] !=
                  receiptCounterFilter.value.text.trim()) {
            return false;
          }
          if (receiptTypeFilterId.value.isNotEmpty &&
              data['payment_type'] != receiptTypeFilterId.value) {
            return false;
          }
          if (customerNameFilterId.value.isNotEmpty &&
              data['vendor'] != customerNameFilterId.value) {
            return false;
          }
          if (statusFilter.value.text.isNotEmpty &&
              data['status'] != statusFilter.value.text) {
            return false;
          }
          if (accountFilterId.value.isNotEmpty &&
              data['account'] != accountFilterId.value) {
            return false;
          }
          if (chequeNumberFilter.value.text.isNotEmpty &&
              data['cheque_number'] != chequeNumberFilter.value.text) {
            return false;
          }

          return true;
        }).toList();

    allPayements.assignAll(filteredReceipts);
    numberOfPayments.value = allPayements.length;
    calculateMoneyForAllPayments();
    isScreenLodingForPayments.value = false;
  }

  void clearAllFilters() {
    statusFilter.value.clear();
    allPayements.clear();
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
  }
}
