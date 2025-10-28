import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:datahubai/Controllers/Main%20screen%20controllers/cahs_management_base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  RxDouble calculatedAmountForAllSelectedPayments = RxDouble(0.0);
  RxMap allVendors = RxMap({});
  RxBool isPaymentAdded = RxBool(false);
  RxString currentPaymentID = RxString('');
  RxInt numberOfPayments = RxInt(0);
  RxDouble totalPaymentPaid = RxDouble(0.0);

  @override
  void onInit() async {
    super.onInit();
  }

 

  Future<void> loadValuesForPayments(Map data) async {
    status.value = data['status'] ?? '';
    isPaymentAdded.value = true;
    availablePayments.clear();
    selectedAvailablePayments.clear();

    await getCurrentVendorInvoices(data['ap_invoices_ids']);
    if (data['vendor'] != '') {
      calculateAmountForSelectedPayments();
      getVendorOutstanding(data['vendor']);

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

  Future<void> getCurrentPaymentCounterNumber() async {
    try {
      var pnId = '';
      var updatepn = '';
      var pnDoc = await FirebaseFirestore.instance
          .collection('counters')
          .where('code', isEqualTo: 'PN')
          // .where('company_id', isEqualTo: companyId.value)
          .get();

      if (pnDoc.docs.isEmpty) {
        // Define constants for new counter values
        const prefix = 'PN';
        const separator = '-';
        const initialValue = 1;

        var newCounter = await FirebaseFirestore.instance
            .collection('counters')
            .add({
              'code': 'PN',
              'description': 'Payment Number',
              'prefix': prefix,
              'value': initialValue,
              'length': 0,
              'separator': separator,
              'added_date': DateTime.now().toString(),
              // 'company_id': companyId.value,
              'status': true,
            });
        pnId = newCounter.id;
        // Set the counter text with prefix and separator
        paymentCounter.value.text = '$prefix$separator$initialValue';
        updatepn = initialValue.toString();
      } else {
        var firstDoc = pnDoc.docs.first;
        pnId = firstDoc.id;
        var currentValue = firstDoc.data()['value'] ?? 0;
        paymentCounter.value.text =
            '${firstDoc.data()['prefix']}${firstDoc.data()['separator']}${(currentValue + 1).toString().padLeft(firstDoc.data()['length'], '0')}';
        updatepn = (currentValue + 1).toString();
      }

      await FirebaseFirestore.instance.collection('counters').doc(pnId).update({
        'value': int.parse(updatepn),
      });
    } catch (e) {
      //
    }
  }

 
 

  void calculateAmountForSelectedPayments() {
    calculatedAmountForAllSelectedPayments.value = 0.0;
    for (var element in selectedAvailablePayments) {
      calculatedAmountForAllSelectedPayments.value += double.tryParse(
        element['payment_amount'] ?? 0,
      )!;
    }
  }

  void addSelectedPayments() {
    // selectedAvailablePayments.clear();

    for (var element in availablePayments) {
      if (element['is_selected'] == true) {
        selectedAvailablePayments.add(element);
      }
    }

    calculateAmountForSelectedPayments();
    update();
    Get.back();
  }

  

  void getAllEntities() {
    try {
      FirebaseFirestore.instance
          .collection('entity_informations')
          // .where('company_id', isEqualTo: companyId.value)
          .orderBy('entity_name')
          .snapshots()
          .listen((entitiesSnapshot) {
            // Temporary maps to hold filtered entities
            Map<String, dynamic> vendorsMap = {};
            Map<String, dynamic> customersMap = {};

            for (var doc in entitiesSnapshot.docs) {
              var data = doc.data();

              // Safety check: entity_code must be a list
              if (data['entity_code'] is List) {
                List entityCodes = data['entity_code'];

                // If 'Vendor' is in the list
                if (entityCodes.contains('Vendor')) {
                  vendorsMap[doc.id] = data;
                }

                // If 'Customer' is in the list
                if (entityCodes.contains('Customer')) {
                  customersMap[doc.id] = data;
                }
              }
            }

            // Assign to your observable maps
            allVendors.value = vendorsMap;
          });
    } catch (e) {
      // print('Error fetching entities: $e');
    }
  }

  Future<void> getVendorInvoices(String vendorId) async {
    try {
      loadingInvoices.value = true;
      availablePayments.clear();

      // === QUERY 1: Get all posted invoices for the vendor ===
      final apInvoicesQuery = await FirebaseFirestore.instance
          .collection('ap_invoices')
          // .where('company_id', isEqualTo: companyId.value)
          .where('vendor', isEqualTo: vendorId)
          .where('status', isEqualTo: 'Posted')
          .get();

      // Filter out invoices that are already selected locally
      final selectedIds = selectedAvailablePayments
          .map((e) => e['ap_invoice_id'])
          .toSet();
      final unselectedInvoiceDocs = apInvoicesQuery.docs.where((doc) {
        return !selectedIds.contains(doc.id);
      }).toList();

      if (unselectedInvoiceDocs.isEmpty) {
        loadingInvoices.value = false;
        // Optional: Recalculate outstanding based on already selected items if needed
        outstanding.text = '0.0';
        return;
      }

      final List<String> invoiceIdsToFetchPayments = unselectedInvoiceDocs
          .map((doc) => doc.id)
          .toList();

      // === QUERY 2 (Chunked): Get all payments for the needed invoices ===
      final Map<String, double> paymentsByInvoiceId = {};
      const chunkSize = 30; // Firestore's limit for 'array-contains-any'
      List<Future<QuerySnapshot<Map<String, dynamic>>>> paymentFutures = [];

      for (var i = 0; i < invoiceIdsToFetchPayments.length; i += chunkSize) {
        final chunk = invoiceIdsToFetchPayments.sublist(
          i,
          min(i + chunkSize, invoiceIdsToFetchPayments.length),
        );
        paymentFutures.add(
          FirebaseFirestore.instance
              .collection('all_payments')
              .where('ap_invoices_ids', arrayContainsAny: chunk)
              .get(),
        );
      }

      // Execute all payment queries concurrently and process results
      final paymentSnapshots = await Future.wait(paymentFutures);
      for (final snapshot in paymentSnapshots) {
        for (final paymentDoc in snapshot.docs) {
          final Map<String, dynamic> apInvoicesMap =
              paymentDoc.data()['ap_invoices'] ?? {};
          apInvoicesMap.forEach((invoiceId, paymentAmount) {
            final double amount =
                double.tryParse(paymentAmount.toString()) ?? 0.0;
            paymentsByInvoiceId[invoiceId] =
                (paymentsByInvoiceId[invoiceId] ?? 0.0) + amount;
          });
        }
      }

      // === PROCESS IN MEMORY: Now build the final list with all data present ===
      double totalOutstanding = 0.0;
      for (final apInvoice in unselectedInvoiceDocs) {
        final apInvoiceData = apInvoice.data();
        final double invoiceAmount =
            double.tryParse(apInvoiceData['total_amount'].toString()) ?? 0.0;

        // Get the pre-fetched payment amount from our map
        final double paymentAmount = paymentsByInvoiceId[apInvoice.id] ?? 0.0;
        final double outstanding = invoiceAmount - paymentAmount;

        if (outstanding > 0) {
          totalOutstanding += outstanding;
          final vendorName = getdataName(
            apInvoiceData['vendor'] ?? '',
            allVendors,
            title: 'entity_name',
          );
          final date = textToDate(apInvoiceData['invoice_date'] ?? '');
          final note =
              'Invoice Number: ${apInvoiceData['invoice_number'] ?? ''}, Invoice Date: $date, Vendor: $vendorName';

          availablePayments.add({
            'is_selected': false,
            'ap_invoice_id': apInvoice.id,
            'invoice_number': apInvoiceData['invoice_number'] ?? '',
            'reference_number': apInvoiceData['reference_number'] ?? '',
            'invoice_date': date,
            'invoice_amount': invoiceAmount.toString(),
            'payment_amount': outstanding.toString(),
            'outstanding_amount': outstanding.toString(),
            'notes': note,
          });
        }
      }

      outstanding.text = totalOutstanding.toString();
    } catch (e) {
      // print('Error getting vendor invoices: $e');
      // Handle error state appropriately
    } finally {
      loadingInvoices.value = false;
    }
  }

  Future<void> getCurrentVendorInvoices(List apIDs) async {
    try {
      // If you have a loading state for this specific function, manage it.
      // Otherwise, you might want to combine it with a global loading state.
      // loadingInvoices.value = true;
      selectedAvailablePayments
          .clear(); // Clear previous selections before populating

      if (apIDs.isEmpty) {
        // loadingInvoices.value = false;
        return;
      }

      // === QUERY 1 (Chunked): Get all selected invoices by their IDs ===
      final List<Future<QuerySnapshot<Map<String, dynamic>>>> invoiceFutures =
          [];
      const chunkSize = 10; // Firestore's limit for 'in' query

      for (var i = 0; i < apIDs.length; i += chunkSize) {
        final chunk = apIDs.sublist(i, min(i + chunkSize, apIDs.length));
        invoiceFutures.add(
          FirebaseFirestore.instance
              .collection('ap_invoices')
              .where(FieldPath.documentId, whereIn: chunk)
              .get(),
        );
      }

      final List<QueryDocumentSnapshot<Map<String, dynamic>>> allInvoiceDocs =
          [];
      final invoiceSnapshots = await Future.wait(invoiceFutures);
      for (final snapshot in invoiceSnapshots) {
        allInvoiceDocs.addAll(snapshot.docs);
      }

      if (allInvoiceDocs.isEmpty) {
        // loadingInvoices.value = false;
        return;
      }

      final List<String> invoiceIdsToFetchPayments = allInvoiceDocs
          .map((doc) => doc.id)
          .toList();

      // === QUERY 2 (Chunked): Get all payments for the selected invoices ===
      // This part is similar to your getVendorInvoices function for consistency.
      final Map<String, double> paymentsByInvoiceId = {};
      List<Future<QuerySnapshot<Map<String, dynamic>>>> paymentFutures = [];
      const paymentChunkSize = 30; // Firestore's limit for 'array-contains-any'

      for (
        var i = 0;
        i < invoiceIdsToFetchPayments.length;
        i += paymentChunkSize
      ) {
        final chunk = invoiceIdsToFetchPayments.sublist(
          i,
          min(i + paymentChunkSize, invoiceIdsToFetchPayments.length),
        );
        paymentFutures.add(
          FirebaseFirestore.instance
              .collection('all_payments')
              .where('ap_invoices_ids', arrayContainsAny: chunk)
              .get(),
        );
      }

      final paymentSnapshots = await Future.wait(paymentFutures);
      for (final snapshot in paymentSnapshots) {
        for (final paymentDoc in snapshot.docs) {
          final Map<String, dynamic> apInvoicesMap =
              paymentDoc.data()['ap_invoices'] ?? {};
          apInvoicesMap.forEach((invoiceId, paymentAmount) {
            final double amount =
                double.tryParse(paymentAmount.toString()) ?? 0.0;
            paymentsByInvoiceId[invoiceId] =
                (paymentsByInvoiceId[invoiceId] ?? 0.0) + amount;
          });
        }
      }

      // === PROCESS IN MEMORY: Build the final list with all data present ===
      for (final apInvoice in allInvoiceDocs) {
        final apInvoiceData = apInvoice.data();
        final double invoiceAmount =
            double.tryParse(apInvoiceData['total_amount'].toString()) ?? 0.0;

        // Get the pre-fetched payment amount from our map
        final double paymentAmount = paymentsByInvoiceId[apInvoice.id] ?? 0.0;
        final double outstanding = invoiceAmount - paymentAmount;

        final vendorId = apInvoiceData['vendor'] ?? '';
        final vendorName = getdataName(
          vendorId,
          allVendors,
          title: 'entity_name',
        );
        final date = textToDate(apInvoiceData['invoice_date'] ?? '');

        final String note =
            'Invoice Number: ${apInvoiceData['invoice_number'] ?? ''}, Invoice Date: $date, Vendor: $vendorName';

        selectedAvailablePayments.add({
          'is_selected': true,
          'ap_invoice_id': apInvoice.id,
          'invoice_number': apInvoiceData['invoice_number'] ?? '',
          'reference_number': apInvoiceData['reference_number'] ?? '',
          'invoice_date': date,
          'invoice_amount': invoiceAmount.toString(),
          'payment_amount': paymentAmount.toString(),
          'outstanding_amount': outstanding.toString(),
          'notes': note,
        });
      }

      // If you have a total outstanding for selected items, calculate it here.
      // double totalSelectedOutstanding = selectedAvailablePayments.fold(0.0, (sum, item) => sum + (double.tryParse(item['outstanding_amount'].toString()) ?? 0.0));
      // outstanding.text = totalSelectedOutstanding.toString();
    } catch (e) {
      // print('Error getting current vendor invoices: $e');
      // Handle error state appropriately
    } finally {
      // loadingInvoices.value = false;
    }
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

  Future<void> getVendorOutstanding(String vendorId) async {
    try {
      // === QUERY 1: Get all relevant invoices (same as before) ===
      final apInvoicesQuery = await FirebaseFirestore.instance
          .collection('ap_invoices')
          // .where('company_id', isEqualTo: companyId.value)
          .where('vendor', isEqualTo: vendorId)
          .where('status', isEqualTo: 'Posted')
          .get();

      if (apInvoicesQuery.docs.isEmpty) {
        outstanding.text = '0.0';
        return;
      }

      final List<String> invoiceIds = apInvoicesQuery.docs
          .map((doc) => doc.id)
          .toList();

      // === NEW: PROCESS PAYMENTS IN CHUNKS ===
      final Map<String, double> paymentsByInvoiceId = {};
      const chunkSize = 30; // Firestore's limit for 'array-contains-any'

      // Create a list of futures, one for each chunk of invoices
      List<Future<QuerySnapshot<Map<String, dynamic>>>> paymentFutures = [];

      for (var i = 0; i < invoiceIds.length; i += chunkSize) {
        // Get a sublist for the current chunk
        final chunk = invoiceIds.sublist(
          i,
          min(i + chunkSize, invoiceIds.length),
        );

        // Add the query for this chunk to our list of futures
        paymentFutures.add(
          FirebaseFirestore.instance
              .collection('all_payments')
              .where('ap_invoices_ids', arrayContainsAny: chunk)
              .get(),
        );
      }

      // === Execute all payment queries concurrently ===
      final List<QuerySnapshot<Map<String, dynamic>>> paymentSnapshots =
          await Future.wait(paymentFutures);

      // === Process the results from all queries in memory ===
      for (final snapshot in paymentSnapshots) {
        // Loop through results from each chunk
        for (final paymentDoc in snapshot.docs) {
          // Loop through payments in the result
          final paymentData = paymentDoc.data();
          final Map<String, dynamic> apInvoicesMap =
              paymentData['ap_invoices'] ?? {};

          apInvoicesMap.forEach((invoiceId, paymentAmount) {
            final double amount =
                double.tryParse(paymentAmount.toString()) ?? 0.0;
            paymentsByInvoiceId[invoiceId] =
                (paymentsByInvoiceId[invoiceId] ?? 0.0) + amount;
          });
        }
      }

      // === CALCULATE FINAL TOTAL (same as before) ===
      double totalOutstanding = 0.0;
      for (final apInvoiceDoc in apInvoicesQuery.docs) {
        final apInvoiceData = apInvoiceDoc.data();
        final double totalAmount =
            double.tryParse(apInvoiceData['total_amount'].toString()) ?? 0.0;
        final double totalPaid = paymentsByInvoiceId[apInvoiceDoc.id] ?? 0.0;

        totalOutstanding += (totalAmount - totalPaid);
      }

      outstanding.text = totalOutstanding.toString();
    } catch (e) {
      // outstanding.text = 'Error';
      // print('Error calculating outstanding: $e');
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

  Future<void> addNewPayment() async {
    try {
      addingNewValue.value = true;

      Map<String, dynamic> apInvoicesMap = {};
      List<String> apInvoicesIds = [];

      for (final payment in selectedAvailablePayments) {
        final String? apInvoiceId = payment['ap_invoice_id'];
        final dynamic amount = payment['payment_amount'];

        if (apInvoiceId != null && amount != null) {
          apInvoicesMap[apInvoiceId] = amount;
          apInvoicesIds.add(apInvoiceId);
        }
      }

      var newData = {
        'payment_number': paymentCounter.value.text,
        // 'payment_date': paymentDate.value.text,
        'vendor': vendorNameId.value,
        'note': note.text,
        'payment_type': paymentTypeId.value,
        'cheque_number': chequeNumber.text,
        // 'cheque_date': chequeDate.text,
        'ap_invoices': apInvoicesMap,
        'ap_invoices_ids': apInvoicesIds,
        'account': accountId.value,
        'currency': currency.text,
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

      if (isPaymentAdded.isFalse) {
        newData['status'] = 'New';
        // newData['company_id'] = companyId.value;
        var currentPayment = await FirebaseFirestore.instance
            .collection('all_payments')
            .add(newData);
        status.value = 'New';
        currentPaymentID.value = currentPayment.id;
        addingNewValue.value = false;
        isPaymentAdded.value = true;
        showSnackBar('Done', 'Added Successfully');
      } else {
        await FirebaseFirestore.instance
            .collection('all_payments')
            .doc(currentPaymentID.value)
            .update(newData);
        addingNewValue.value = false;
        showSnackBar('Done', 'Updated Successfully');
      }
      update();
    } catch (e) {
      addingNewValue.value = false;
      isPaymentAdded.value = false;
      showSnackBar('Failed', 'Please try again');
      // Handle any errors here
    }
  }

  Future<void> editPayment(String id) async {
    try {
      addingNewValue.value = true;

      Map<String, dynamic> apInvoiceMap = {};
      List<String> apInvoiceIds = [];

      for (final payment in selectedAvailablePayments) {
        final String? apInvoiceId = payment['ap_invoice_id'];
        final dynamic amount = payment['payment_amount'];

        if (apInvoiceId != null && amount != null) {
          apInvoiceMap[apInvoiceId] = amount;
          apInvoiceIds.add(apInvoiceId);
        }
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
      await getCurrentPaymentCounterNumber();
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
