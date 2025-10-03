import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import 'main_screen_contro.dart';

class CashManagementController extends GetxController {
  Rx<TextEditingController> receiptDate = TextEditingController().obs;
  Rx<TextEditingController> paymentDate = TextEditingController().obs;
  Rx<TextEditingController> receiptCounter = TextEditingController().obs;
  Rx<TextEditingController> paymentCounter = TextEditingController().obs;
  TextEditingController receiptType = TextEditingController();
  TextEditingController paymentType = TextEditingController();
  TextEditingController customerName = TextEditingController();
  TextEditingController vendorName = TextEditingController();
  TextEditingController note = TextEditingController();
  TextEditingController outstanding = TextEditingController();
  TextEditingController chequeNumber = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController chequeDate = TextEditingController();
  TextEditingController account = TextEditingController();
  TextEditingController currency = TextEditingController();
  TextEditingController rate = TextEditingController();
  RxBool isScreenLodingForReceipts = RxBool(false);
  RxBool isScreenLodingForPayments = RxBool(false);
  final RxList<DocumentSnapshot> allReceipts = RxList<DocumentSnapshot>([]);
  // final RxList<DocumentSnapshot> filteredCashsManagements =
  //     RxList<DocumentSnapshot>([]);

  final RxList<DocumentSnapshot> allPayements = RxList<DocumentSnapshot>([]);

  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  RxBool postingReceipts = RxBool(false);
  RxBool cancellingReceipts = RxBool(false);
  RxBool isChequeSelected = RxBool(false);
  RxString receiptTypeId = RxString('');
  RxString paymentTypeId = RxString('');
  RxString customerNameId = RxString('');
  RxString vendorNameId = RxString('');
  RxString accountId = RxString('');
  RxString bankId = RxString('');
  RxString status = RxString('');
  RxString paymentStatus = RxString('');
  RxList availableReceipts = RxList([]);
  RxList availablePayments = RxList([]);
  RxList selectedAvailableReceipts = RxList([]);
  RxList selectedAvailablePayments = RxList([]);
  RxBool isAllJobReceiptsSelected = RxBool(false);
  RxBool isAllPaymentsSelected = RxBool(false);
  RxBool loadingInvoices = RxBool(false);
  RxDouble calculatedAmountForAllSelectedReceipts = RxDouble(0.0);
  RxDouble calculatedAmountForAllSelectedPayments = RxDouble(0.0);
  // RxDouble calculatedOutstandingForAllSelectedReceipts = RxDouble(0.0);
  RxString companyId = RxString('');
  RxMap allReceiptTypes = RxMap({});
  RxMap allCustomers = RxMap({});
  RxMap allVendors = RxMap({});
  RxMap allAccounts = RxMap({});
  RxMap allBanks = RxMap({});
  RxBool isReceiptAdded = RxBool(false);
  RxBool isPaymentAdded = RxBool(false);
  RxString currentReceiptID = RxString('');
  RxString currentPaymentID = RxString('');
  var editingIndex = (-1).obs;
  final ScrollController scrollController = ScrollController();
  final ScrollController scrollController2 = ScrollController();
  var buttonLoadingStates = <String, bool>{}.obs;
  // Filters
  Rx<TextEditingController> receiptCounterFilter = TextEditingController().obs;
  Rx<TextEditingController> chequeNumberFilter = TextEditingController().obs;
  Rx<TextEditingController> customerNameFilter = TextEditingController().obs;
  RxString customerNameFilterId = RxString('');
  Rx<TextEditingController> receiptTypeFilter = TextEditingController().obs;
  RxString receiptTypeFilterId = RxString('');
  Rx<TextEditingController> accountFilter = TextEditingController().obs;
  RxString accountFilterId = RxString('');
  Rx<TextEditingController> bankNameFilter = TextEditingController().obs;
  RxString bankNameFilterId = RxString('');
  Rx<TextEditingController> statusFilter = TextEditingController().obs;
  Rx<TextEditingController> fromDate = TextEditingController().obs;
  Rx<TextEditingController> toDate = TextEditingController().obs;
  RxBool isYearSelected = RxBool(false);
  RxBool isMonthSelected = RxBool(false);
  RxBool isDaySelected = RxBool(false);
  RxBool isTodaySelected = RxBool(false);
  RxBool isAllSelected = RxBool(false);
  RxBool isThisMonthSelected = RxBool(false);
  RxBool isThisYearSelected = RxBool(false);
  RxInt numberOfReceipts = RxInt(0);
  RxInt numberOfPayments = RxInt(0);
  RxDouble totalReceiptsReceived = RxDouble(0.0);
  RxDouble totalPaymentPaid = RxDouble(0.0);
  @override
  void onInit() async {
    super.onInit();
    await getCompanyId();
    getAllEntities();
    getAllAccounts();
    getBanks();
    await getReceiptsTypes();
  }

  // function to manage loading button
  void setButtonLoading(String menuId, bool isLoading) {
    buttonLoadingStates[menuId] = isLoading;
    buttonLoadingStates.refresh(); // Notify listeners
  }

  /// Call this to enter edit mode on a row
  void startEditing(int idx) {
    editingIndex.value = idx;
  }

  /// Call this when editing is done (Enter pressed)
  void finishEditingForReceipts(String newValue, int idx) {
    // Update the data source
    selectedAvailableReceipts[idx]['receipt_amount'] = newValue;
    selectedAvailableReceipts[idx]['outstanding_amount'] = (double.parse(
                selectedAvailableReceipts[idx]['invoice_amount'] ?? '0.0') -
            double.parse(newValue))
        .toString();
    // Exit edit mode
    calculateAmountForSelectedReceipts();
    editingIndex.value = -1;
  }

  void finishEditingForPayments(String newValue, int idx) {
    // Update the data source
    selectedAvailablePayments[idx]['payment_amount'] = newValue;
    selectedAvailablePayments[idx]['outstanding_amount'] = (double.parse(
                selectedAvailablePayments[idx]['invoice_amount'] ?? '0.0') -
            double.parse(newValue))
        .toString();
    // Exit edit mode
    // calculateAmountForSelectedReceipts();
    editingIndex.value = -1;
  }

  Future<void> getCompanyId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId.value = prefs.getString('companyId')!;
  }

  Future<void> loadValuesForReceipts(Map data) async {
    status.value = data['status'] ?? '';
    isReceiptAdded.value = true;
    availableReceipts.clear();
    if (data['customer'] != '') {
      await getCurrentCustomerInvoices(data['customer'], data['job_ids']);
      calculateAmountForSelectedReceipts();
      // calculateOutstandingForSelectedReceipts();
    }
    receiptCounter.value.text = data['receipt_number'] ?? '';
    receiptDate.value.text = textToDate(data['receipt_date']);
    customerName.text =
        getdataName(data['customer'], allCustomers, title: 'entity_name');
    customerNameId.value = data['customer'] ?? '';
    outstanding.text = await calculateCustomerOutstanding(data['customer']);
    note.text = data['note'] ?? '';
    receiptType.text = getdataName(data['receipt_type'], allReceiptTypes);
    receiptType.text == 'Cheque'
        ? isChequeSelected.value = true
        : isChequeSelected.value = false;
    receiptTypeId.value = data['receipt_type'] ?? '';
    chequeNumber.text = data['cheque_number'] ?? '';
    bankName.text = getdataName(data['bank_name'], allBanks);
    bankId.value = data['bank_name'];
    chequeDate.text = textToDate(data['cheque_date']);
    account.text =
        getdataName(data['account'], allAccounts, title: 'account_number');
    accountId.value = data['account'];
    currency.text = data['currency'] ?? '';
    rate.text = data['rate'] ?? '';
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

      vendorName.text =
          getdataName(data['vendor'], allVendors, title: 'entity_name');
      vendorNameId.value = data['vendor'] ?? '';
    }
    paymentCounter.value.text = data['payment_number'] ?? '';
    paymentDate.value.text = textToDate(data['payment_date']);

    note.text = data['note'] ?? '';
    paymentType.text = getdataName(data['payment_type'], allReceiptTypes);
    paymentType.text == 'Cheque'
        ? isChequeSelected.value = true
        : isChequeSelected.value = false;
    paymentTypeId.value = data['payment_type'] ?? '';
    chequeNumber.text = data['cheque_number'] ?? '';
    chequeDate.text = textToDate(data['cheque_date']);
    account.text =
        getdataName(data['account'], allAccounts, title: 'account_number');
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
    isReceiptAdded.value = false;
    isPaymentAdded.value = false;
    receiptDate.value.text = textToDate(DateTime.now().toString());
    paymentDate.value.text = textToDate(DateTime.now().toString());
    receiptCounter.value.clear();
    paymentCounter.value.clear();
    receiptType.clear();
    paymentType.clear();
    customerName.clear();
    vendorName.clear();
    note.clear();
    chequeNumber.clear();
    bankName.clear();
    chequeDate.clear();
    isChequeSelected.value = false;
    receiptTypeId.value = '';
    paymentTypeId.value = '';
    customerNameId.value = '';
    vendorNameId.value = '';
    availableReceipts.clear();
    availablePayments.clear();
    selectedAvailableReceipts.clear();
    selectedAvailablePayments.clear();
    isAllJobReceiptsSelected.value = false;
    isAllPaymentsSelected.value = false;
    calculatedAmountForAllSelectedReceipts.value = 0.0;
    calculatedAmountForAllSelectedPayments.value = 0.0;
    currentReceiptID.value = '';
    currentPaymentID.value = '';
    status.value = '';
  }

  Future<void> selectDateContext(
      BuildContext context, TextEditingController date) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      date.text = textToDate(picked.toString());
    }
  }

  Future<void> getCurrentReceiptCounterNumber() async {
    try {
      var rnId = '';
      var updatern = '';
      var rnDoc = await FirebaseFirestore.instance
          .collection('counters')
          .where('code', isEqualTo: 'RN')
          .where('company_id', isEqualTo: companyId.value)
          .get();

      if (rnDoc.docs.isEmpty) {
        // Define constants for new counter values
        const prefix = 'RN';
        const separator = '-';
        const initialValue = 1;

        var newCounter =
            await FirebaseFirestore.instance.collection('counters').add({
          'code': 'RN',
          'description': 'Receipt Number',
          'prefix': prefix,
          'value': initialValue,
          'length': 0,
          'separator': separator,
          'added_date': DateTime.now().toString(),
          'company_id': companyId.value,
          'status': true,
        });
        rnId = newCounter.id;
        // Set the counter text with prefix and separator
        receiptCounter.value.text = '$prefix$separator$initialValue';
        updatern = initialValue.toString();
      } else {
        var firstDoc = rnDoc.docs.first;
        rnId = firstDoc.id;
        var currentValue = firstDoc.data()['value'] ?? 0;
        receiptCounter.value.text =
            '${firstDoc.data()['prefix']}${firstDoc.data()['separator']}${(currentValue + 1).toString().padLeft(firstDoc.data()['length'], '0')}';
        updatern = (currentValue + 1).toString();
      }

      await FirebaseFirestore.instance.collection('counters').doc(rnId).update({
        'value': int.parse(updatern),
      });
    } catch (e) {
      //
    }
  }

  Future<void> getCurrentPaymentCounterNumber() async {
    try {
      var pnId = '';
      var updatepn = '';
      var pnDoc = await FirebaseFirestore.instance
          .collection('counters')
          .where('code', isEqualTo: 'PN')
          .where('company_id', isEqualTo: companyId.value)
          .get();

      if (pnDoc.docs.isEmpty) {
        // Define constants for new counter values
        const prefix = 'PN';
        const separator = '-';
        const initialValue = 1;

        var newCounter =
            await FirebaseFirestore.instance.collection('counters').add({
          'code': 'PN',
          'description': 'Payment Number',
          'prefix': prefix,
          'value': initialValue,
          'length': 0,
          'separator': separator,
          'added_date': DateTime.now().toString(),
          'company_id': companyId.value,
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

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  // // this function is to select single receipt
  void selectJobReceipt(int index, bool isSelected) {
    // rebuild a new Map object
    final updated = {
      ...availableReceipts[index],
      'is_selected': isSelected,
    };

    // reassign into the RxList — that triggers the update
    availableReceipts[index] = updated;
  }

  void selectPayment(int index, bool isSelected) {
    // rebuild a new Map object
    final updated = {
      ...availablePayments[index],
      'is_selected': isSelected,
    };

    // reassign into the RxList — that triggers the update
    availablePayments[index] = updated;
  }

// this function is to select all receipts
  void selectAllJobReceipts(bool select) {
    isAllJobReceiptsSelected.value = select;

    final newList =
        availableReceipts.map((r) => {...r, 'is_selected': select}).toList();
    availableReceipts.assignAll(newList);
  }

  void selectAllPayments(bool select) {
    isAllPaymentsSelected.value = select;

    final newList =
        availablePayments.map((r) => {...r, 'is_selected': select}).toList();
    availablePayments.assignAll(newList);
  }

  void calculateAmountForSelectedReceipts() {
    calculatedAmountForAllSelectedReceipts.value = 0.0;
    for (var element in selectedAvailableReceipts) {
      calculatedAmountForAllSelectedReceipts.value +=
          double.tryParse(element['receipt_amount'] ?? 0)!;
    }
  }

  void calculateAmountForSelectedPayments() {
    calculatedAmountForAllSelectedPayments.value = 0.0;
    for (var element in selectedAvailablePayments) {
      calculatedAmountForAllSelectedPayments.value +=
          double.tryParse(element['payment_amount'] ?? 0)!;
    }
  }

  // calculateOutstandingForSelectedReceipts() {
  //   calculatedOutstandingForAllSelectedReceipts.value = 0.0;
  //   for (var element in selectedAvailableReceipts) {
  //     calculatedOutstandingForAllSelectedReceipts.value +=
  //         double.tryParse(element['outstanding_amount'] ?? 0)!;
  //   }
  // }

// this functions is to add the selected receipts to the table in the new receipts screen
  void addSelectedReceipts() {
    // selectedAvailableReceipts.clear();
    for (var element in availableReceipts) {
      if (element['is_selected'] == true) {
        selectedAvailableReceipts.add(element);
      }
    }

    calculateAmountForSelectedReceipts();
    // calculateOutstandingForSelectedReceipts();
    update();
    Get.back();
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

  void removeSelectedReceipt(String invoiceNumber) {
    // 1) Un‐select it in the main list
    final availIdx = availableReceipts.indexWhere(
      (r) => r['invoice_number'] == invoiceNumber,
    );
    if (availIdx != -1) {
      final updated = {
        ...availableReceipts[availIdx],
        'is_selected': false,
      };
      availableReceipts[availIdx] = updated;
    }

    // 2) Remove from the selected list
    selectedAvailableReceipts
        .removeWhere((r) => r['invoice_number'] == invoiceNumber);

    // 3) Recalculate totals, etc.
    calculateAmountForSelectedReceipts();
  }

  void removeSelectedPayment(String number) {
    // 1) Un‐select it in the main list
    final availIdx = availablePayments.indexWhere(
      (r) => r['reference_number'] == number,
    );
    if (availIdx != -1) {
      final updated = {
        ...availablePayments[availIdx],
        'is_selected': false,
      };
      availablePayments[availIdx] = updated;
    }

    // 2) Remove from the selected list
    selectedAvailablePayments
        .removeWhere((r) => r['reference_number'] == number);

    // 3) Recalculate totals, etc.
    // calculateAmountForSelectedReceipts();
  }

  // this function is to get colors
  Future<void> getReceiptsTypes() async {
    var typeDoc = await FirebaseFirestore.instance
        .collection('all_lists')
        .where('code', isEqualTo: 'RECEIPT_TYPES')
        .get();

    var typeId = typeDoc.docs.first.id;

    FirebaseFirestore.instance
        .collection('all_lists')
        .doc(typeId)
        .collection('values')
        .where('available', isEqualTo: true)
        .snapshots()
        .listen((types) {
      allReceiptTypes.value = {for (var doc in types.docs) doc.id: doc.data()};
    });
  }

  void getAllEntities() {
    try {
      FirebaseFirestore.instance
          .collection('entity_informations')
          .where('company_id', isEqualTo: companyId.value)
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
        allCustomers.value = customersMap;
      });
    } catch (e) {
      // print('Error fetching entities: $e');
    }
  }

  void getAllAccounts() {
    try {
      FirebaseFirestore.instance
          .collection('all_banks')
          .where('company_id', isEqualTo: companyId.value)
          .snapshots()
          .listen((banks) {
        allAccounts.value = {for (var doc in banks.docs) doc.id: doc.data()};
      });
    } catch (e) {
      //
    }
  }

  Future<void> getCurrentCustomerInvoices(
      String customerId, List jobIds) async {
    // loadingInvoices.value = true;
    try {
      // Create an instance of the callable function.
      final HttpsCallable callable = FirebaseFunctions.instance
          .httpsCallable('get_current_customer_invoices');

      // Call the function with the required parameter.
      final HttpsCallableResult result =
          await callable.call({'customer_id': customerId, 'job_ids': jobIds});

      // The callable function returns a Map; extract the invoices list.
      final data = result.data;
      if (data is Map<String, dynamic> && data.containsKey('invoices')) {
        final List<dynamic> invoices = data['invoices'];
        selectedAvailableReceipts.assignAll(invoices);
      }
    } on FirebaseFunctionsException catch (e) {
      // Catch and log errors from the Firebase function.
      showSnackBar('Alert', 'Error: ${e.message}');
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
    } finally {
      // loadingInvoices.value = false;
    }
  }

  Future<void> getCustomerInvoices(String customerId) async {
    loadingInvoices.value = true;
    availableReceipts.clear();

    try {
      // Create an instance of the callable function.
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('get_customer_invoices');

      // Call the function with the required parameter.
      final HttpsCallableResult result = await callable.call(customerId);

      // The callable function returns a Map; extract the invoices list.
      final data = result.data;
      if (data is Map<String, dynamic> && data.containsKey('invoices')) {
        final List<dynamic> invoices = data['invoices'];
        availableReceipts.assignAll(invoices);
      }
    } on FirebaseFunctionsException catch (e) {
      // Catch and log errors from the Firebase function.
      showSnackBar('Alert', 'Error: ${e.message}');
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
    } finally {
      loadingInvoices.value = false;
    }
  }

// ============================================================================================== //
  // getVendorInvoices(String vendorId) async {
  //   try {
  //     loadingInvoices.value = true;
  //     availablePayments.clear();
  //     double totalOutstanding = 0.0;
  //     // List result = [];
  //     var apInvoices = await FirebaseFirestore.instance
  //         .collection('ap_invoices')
  //         .where('company_id', isEqualTo: companyId.value)
  //         .where('vendor', isEqualTo: vendorId)
  //         .where('status', isEqualTo: 'Posted')
  //         .get();

  //     final selectedIds =
  //         selectedAvailablePayments.map((e) => e['ap_invoice_id']).toSet();
  //     for (var apInvoice in apInvoices.docs) {
  //       var apInvoiceId = apInvoice.id;
  //       var apInvoiceData = apInvoice.data();
  //       if (selectedIds.contains(apInvoiceId)) {
  //         continue;
  //       }

  //       double invoiceAmount =
  //           double.tryParse(apInvoiceData['total_amount'].toString()) ?? 0.0;
  //       double paymentAmount =
  //           await calculateTotalPaymentsForAPInvoices(apInvoiceId);

  //       double outstanding = invoiceAmount - paymentAmount;
  //       if (outstanding > 0) {
  //         totalOutstanding += outstanding;
  //         var vendorId = apInvoiceData['vendor'] ?? '';

  //         var vendorName =
  //             getdataName(vendorId, allVendors, title: 'entity_name');
  //         var date = textToDate(apInvoiceData['invoice_date'] ?? '');

  //         String note =
  //             'Invoice Number: ${apInvoiceData['invoice_number'] ?? ''}, Invoice Date: $date, Vendor: $vendorName';

  //         availablePayments.add({
  //           'is_selected': false,
  //           'ap_invoice_id': apInvoiceId,
  //           'invoice_number': apInvoiceData['invoice_number'] ?? '',
  //           'reference_number': apInvoiceData['reference_number'] ?? '',
  //           'invoice_date': date,
  //           'invoice_amount': invoiceAmount.toString(),
  //           'payment_amount': outstanding.toString(),
  //           'outstanding_amount': outstanding.toString(),
  //           'notes': note
  //         });
  //       }
  //     }
  //     loadingInvoices.value = false;
  //     outstanding.text = totalOutstanding.toString();
  //     // return totalOutstanding;
  //   } catch (e) {
  //     loadingInvoices.value = false;
  //   }
  // }

  Future<void> getVendorInvoices(String vendorId) async {
    try {
      loadingInvoices.value = true;
      availablePayments.clear();

      // === QUERY 1: Get all posted invoices for the vendor ===
      final apInvoicesQuery = await FirebaseFirestore.instance
          .collection('ap_invoices')
          .where('company_id', isEqualTo: companyId.value)
          .where('vendor', isEqualTo: vendorId)
          .where('status', isEqualTo: 'Posted')
          .get();

      // Filter out invoices that are already selected locally
      final selectedIds =
          selectedAvailablePayments.map((e) => e['ap_invoice_id']).toSet();
      final unselectedInvoiceDocs = apInvoicesQuery.docs.where((doc) {
        return !selectedIds.contains(doc.id);
      }).toList();

      if (unselectedInvoiceDocs.isEmpty) {
        loadingInvoices.value = false;
        // Optional: Recalculate outstanding based on already selected items if needed
        outstanding.text = '0.0';
        return;
      }

      final List<String> invoiceIdsToFetchPayments =
          unselectedInvoiceDocs.map((doc) => doc.id).toList();

      // === QUERY 2 (Chunked): Get all payments for the needed invoices ===
      final Map<String, double> paymentsByInvoiceId = {};
      const chunkSize = 30; // Firestore's limit for 'array-contains-any'
      List<Future<QuerySnapshot<Map<String, dynamic>>>> paymentFutures = [];

      for (var i = 0; i < invoiceIdsToFetchPayments.length; i += chunkSize) {
        final chunk = invoiceIdsToFetchPayments.sublist(
            i, min(i + chunkSize, invoiceIdsToFetchPayments.length));
        paymentFutures.add(FirebaseFirestore.instance
            .collection('all_payments')
            .where('ap_invoices_ids', arrayContainsAny: chunk)
            .get());
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
              apInvoiceData['vendor'] ?? '', allVendors,
              title: 'entity_name');
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
            'notes': note
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

  // getCurrentVendorInvoices(List apIDs) async {
  //   try {
  //     for (var id in apIDs) {
  //       var apInvoice = await FirebaseFirestore.instance
  //           .collection('ap_invoices')
  //           .doc(id)
  //           .get();

  //       var apInvoiceId = apInvoice.id;
  //       var apInvoiceData = apInvoice.data() as Map<String, dynamic>;
  //       double invoiceAmount =
  //           double.tryParse(apInvoiceData['total_amount'].toString()) ?? 0.0;
  //       double paymentAmount =
  //           await calculateTotalPaymentsForAPInvoices(apInvoiceId);

  //       double outstanding = invoiceAmount - paymentAmount;
  //       var vendorId = apInvoiceData['vendor'] ?? '';

  //       var vendorName =
  //           getdataName(vendorId, allVendors, title: 'entity_name');
  //       var date = textToDate(apInvoiceData['invoice_date'] ?? '');

  //       String note =
  //           'Invoice Number: ${apInvoiceData['invoice_number'] ?? ''}, Invoice Date: $date, Vendor: $vendorName';

  //       selectedAvailablePayments.add({
  //         'is_selected': true,
  //         'ap_invoice_id': apInvoiceId,
  //         'invoice_number': apInvoiceData['invoice_number'] ?? '',
  //         'reference_number': apInvoiceData['reference_number'] ?? '',
  //         'invoice_date': date,
  //         'invoice_amount': invoiceAmount.toString(),
  //         'payment_amount': paymentAmount.toString(),
  //         'outstanding_amount': outstanding.toString(),
  //         'notes': note
  //       });
  //     }
  //   } catch (e) {
  //     // print(e);
  //   }
  // }

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
        invoiceFutures.add(FirebaseFirestore.instance
            .collection('ap_invoices')
            .where(FieldPath.documentId, whereIn: chunk)
            .get());
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

      final List<String> invoiceIdsToFetchPayments =
          allInvoiceDocs.map((doc) => doc.id).toList();

      // === QUERY 2 (Chunked): Get all payments for the selected invoices ===
      // This part is similar to your getVendorInvoices function for consistency.
      final Map<String, double> paymentsByInvoiceId = {};
      List<Future<QuerySnapshot<Map<String, dynamic>>>> paymentFutures = [];
      const paymentChunkSize = 30; // Firestore's limit for 'array-contains-any'

      for (var i = 0;
          i < invoiceIdsToFetchPayments.length;
          i += paymentChunkSize) {
        final chunk = invoiceIdsToFetchPayments.sublist(
            i, min(i + paymentChunkSize, invoiceIdsToFetchPayments.length));
        paymentFutures.add(FirebaseFirestore.instance
            .collection('all_payments')
            .where('ap_invoices_ids', arrayContainsAny: chunk)
            .get());
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
        final vendorName =
            getdataName(vendorId, allVendors, title: 'entity_name');
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
          'notes': note
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

  // Future<double> calculateSumOfAmounts(DocumentSnapshot apInvoice) async {
  //   try {
  //     double totalAmounts = 0.0;
  //     var items = await apInvoice.reference.collection('invoices').get();
  //     for (var item in items.docs) {
  //       var itemData = item.data();
  //       totalAmounts += double.tryParse(itemData['amount'] ?? '0') ?? 0.0;
  //     }
  //     return totalAmounts;
  //   } catch (e) {
  //     return 0.0;
  //   }
  // }

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

  // getVendorOutstanding(vendorId) async {
  //   try {
  //     double totalOutstanding = 0.0;
  //     double amount = 0.0;
  //     double currentOutstanding = 0.0;
  //     var apInvoices = await FirebaseFirestore.instance
  //         .collection('ap_invoices')
  //         .where('company_id', isEqualTo: companyId.value)
  //         .where('vendor', isEqualTo: vendorId)
  //         .where('status', isEqualTo: 'Posted')
  //         .get();

  //     for (var apInvoice in apInvoices.docs) {
  //       var apInvoiceData = apInvoice.data();
  //       amount =
  //           double.tryParse(apInvoiceData['total_amount'].toString()) ?? 0.0;
  //       double paymentAmount =
  //           await calculateTotalPaymentsForAPInvoices(apInvoice.id);
  //       currentOutstanding = amount - paymentAmount;
  //       totalOutstanding += currentOutstanding;
  //     }

  //     outstanding.text = totalOutstanding.toString();
  //   } catch (e) {
  //     //
  //   }
  // }

// Assume companyId is accessible
// final companyId = ...;

  Future<void> getVendorOutstanding(String vendorId) async {
    try {
      // === QUERY 1: Get all relevant invoices (same as before) ===
      final apInvoicesQuery = await FirebaseFirestore.instance
          .collection('ap_invoices')
          .where('company_id', isEqualTo: companyId.value)
          .where('vendor', isEqualTo: vendorId)
          .where('status', isEqualTo: 'Posted')
          .get();

      if (apInvoicesQuery.docs.isEmpty) {
        outstanding.text = '0.0';
        return;
      }

      final List<String> invoiceIds =
          apInvoicesQuery.docs.map((doc) => doc.id).toList();

      // === NEW: PROCESS PAYMENTS IN CHUNKS ===
      final Map<String, double> paymentsByInvoiceId = {};
      const chunkSize = 30; // Firestore's limit for 'array-contains-any'

      // Create a list of futures, one for each chunk of invoices
      List<Future<QuerySnapshot<Map<String, dynamic>>>> paymentFutures = [];

      for (var i = 0; i < invoiceIds.length; i += chunkSize) {
        // Get a sublist for the current chunk
        final chunk =
            invoiceIds.sublist(i, min(i + chunkSize, invoiceIds.length));

        // Add the query for this chunk to our list of futures
        paymentFutures.add(FirebaseFirestore.instance
            .collection('all_payments')
            .where('ap_invoices_ids', arrayContainsAny: chunk)
            .get());
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

// ============================================================================================== //

  Future<double> getReceiptReceivedAmount(String receiptId) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance
          .httpsCallable('get_receipt_received_amount');

      final HttpsCallableResult result = await callable.call(receiptId);

      // ✅ Extract the total from the map correctly
      final data = result.data;
      return double.tryParse(data['total_received_amount'].toString()) ?? 0.0;
    } catch (e) {
      return 0.0;
    } finally {
      loadingInvoices.value = false;
    }
  }

  Future<double> getPaymentPaidAmount(String receiptId) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('get_payment_paid_amount');

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

  Future<void> addNewReceipts() async {
    try {
      addingNewValue.value = true;

      Map<String, dynamic> jobsMap = {};
      List<String> jobIds = [];

      for (final receipt in selectedAvailableReceipts) {
        final String? jobId = receipt['job_id'];
        final dynamic amount = receipt['receipt_amount'];

        if (jobId != null && amount != null) {
          jobsMap[jobId] = amount;
          jobIds.add(jobId);
        }
      }

      var newData = {
        'receipt_number': receiptCounter.value.text,
        // 'receipt_date': receiptDate.value.text,
        'customer': customerNameId.value,
        'note': note.text,
        'receipt_type': receiptTypeId.value,
        'cheque_number': chequeNumber.text,
        'bank_name': bankId.value,
        // 'cheque_date': chequeDate.text,
        'jobs': jobsMap,
        'job_ids': jobIds,
        'account': accountId.value,
        'currency': currency.text,
        'rate': rate.text,
      };

      final rawDate = receiptDate.value.text.trim();
      final rawDate2 = chequeDate.value.text.trim();

      if (rawDate.isNotEmpty) {
        try {
          newData['receipt_date'] = Timestamp.fromDate(
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

      if (isReceiptAdded.isFalse) {
        newData['status'] = 'New';
        newData['company_id'] = companyId.value;
        var currentReceipt = await FirebaseFirestore.instance
            .collection('all_receipts')
            .add(newData);
        status.value = 'New';
        currentReceiptID.value = currentReceipt.id;
        addingNewValue.value = false;
        isReceiptAdded.value = true;
        showSnackBar('Done', 'Added Successfully');
      } else {
        await FirebaseFirestore.instance
            .collection('all_receipts')
            .doc(currentReceiptID.value)
            .update(newData);
        addingNewValue.value = false;
        showSnackBar('Done', 'Updated Successfully');
      }
      update();
    } catch (e) {
      addingNewValue.value = false;
      isReceiptAdded.value = false;
      showSnackBar('Failed', 'Please try again');
      // Handle any errors here
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
        newData['company_id'] = companyId.value;
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

  Future<void> editReceipt(String id) async {
    try {
      addingNewValue.value = true;

      Map<String, dynamic> jobsMap = {};
      List<String> jobIds = [];

      for (final receipt in selectedAvailableReceipts) {
        final String? jobId = receipt['job_id'];
        final dynamic amount = receipt['receipt_amount'];

        if (jobId != null && amount != null) {
          jobsMap[jobId] = amount;
          jobIds.add(jobId);
        }
      }

      var newData = {
        // 'receipt_date': receiptDate.value.text,
        'customer': customerNameId.value,
        'note': note.text,
        'receipt_type': receiptTypeId.value,
        'cheque_number': chequeNumber.text,
        'bank_name': bankId.value,
        // 'cheque_date': chequeDate.text,
        'jobs': jobsMap,
        'job_ids': jobIds,
        'account': accountId.value,
        'rate': rate.text,
      };
      final rawDate = receiptDate.value.text.trim();
      final rawDate2 = chequeDate.value.text.trim();

      if (rawDate.isNotEmpty) {
        try {
          newData['receipt_date'] = Timestamp.fromDate(
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
          .collection('all_receipts')
          .doc(id)
          .update(newData);
      addingNewValue.value = false;
      showSnackBar('Done', 'Updated Successfully');
    } catch (e) {
      addingNewValue.value = false;
      showSnackBar('Alert', 'Something Went Wrong');
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

  Future<void> deleteReceipt(String id) async {
    try {
      Get.close(2);
      await FirebaseFirestore.instance
          .collection('all_receipts')
          .doc(id)
          .delete();
    } catch (e) {
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

  Future<void> postReceipt(String receiptID) async {
    try {
      if (isReceiptAdded.isFalse) {
        showSnackBar('Alert', 'Please Save Receipt First');
        return;
      }

      if (status.value == 'Posted') {
        showSnackBar('Alert', 'Receipt is Already Posted');
        return;
      }
      await getCurrentReceiptCounterNumber();
      // receiptDate.value.text = textToDate(DateTime.now().toString());

      FirebaseFirestore.instance
          .collection('all_receipts')
          .doc(receiptID)
          .update({
        'status': 'Posted',
        // 'receipt_date': receiptDate.value.text,
        'receipt_number': receiptCounter.value.text
      });
      status.value = 'Posted';
      showSnackBar('Done', 'Receipt Posted');
      update();
    } catch (e) {
      showSnackBar('Something Went Wrong', 'Please try again');
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
        'payment_number': receiptCounter.value.text
      });
      status.value = 'Posted';
      showSnackBar('Done', 'Payment Posted');
      update();
    } catch (e) {
      showSnackBar('Something Went Wrong', 'Please try again');
    }
  }

  Future<void> cancelReceipt(String receiptID) async {
    try {
      if (isReceiptAdded.isFalse) {
        showSnackBar('Alert', 'Please Save Receipt First');
        return;
      }

      if (status.value == 'Cancelled') {
        showSnackBar('Alert', 'Receipt is Already Cancelled');
        return;
      }

      FirebaseFirestore.instance
          .collection('all_receipts')
          .doc(receiptID)
          .update({
        'status': 'Cancelled',
      });
      status.value = 'Cancelled';
      showSnackBar('Done', 'Receipt Cancelled');
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
          .update({
        'status': 'Cancelled',
      });
      status.value = 'Cancelled';
      showSnackBar('Done', 'Payment Cancelled');
      update();
    } catch (e) {
      showSnackBar('Something Went Wrong', 'Please try again');
    }
  }

  Future<String> getCurrencyName(String countryId) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('get_currency_name');

      // Call the function with the required parameter.
      final HttpsCallableResult result = await callable.call(countryId);
      final data = result.data;
      if (data != null) {
        return data;
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  Future<String> getCurrencyRate(String currencyId) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('get_currency_rate');

      final HttpsCallableResult result = await callable.call(currencyId);
      final data = result.data;
      if (data != null) {
        return data.toString();
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  Future<String> calculateCustomerOutstanding(String customerId) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance
          .httpsCallable('calculate_customer_outstanding');

      final HttpsCallableResult result = await callable.call(customerId);
      final data = result.data;
      if (data != null) {
        return data.toString();
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  // this function is to get nabks
  Future<void> getBanks() async {
    var typeDoc = await FirebaseFirestore.instance
        .collection('all_lists')
        .where('code', isEqualTo: 'BANKS')
        .get();

    var typeId = typeDoc.docs.first.id;

    FirebaseFirestore.instance
        .collection('all_lists')
        .doc(typeId)
        .collection('values')
        .where('available', isEqualTo: true)
        .snapshots()
        .listen((colors) {
      allBanks.value = {for (var doc in colors.docs) doc.id: doc.data()};
    });
  }

  Future<void> calculateMoneyForAllReceipts() async {
    try {
      totalReceiptsReceived.value = 0.0;

      for (var receipt in allReceipts) {
        var data = receipt.data() as Map<String, dynamic>?;
        Map jobs = data?['jobs'];
        for (var value in jobs.values) {
          totalReceiptsReceived.value += double.tryParse(value) ?? 0.0;
        }
      }
    } catch (e) {
      // print(e);
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

  // Future<void> searchEngineForReceipts() async {
  //   isScreenLodingForReceipts.value = true;
  //   final collection = FirebaseFirestore.instance
  //       .collection('all_receipts')
  //       .where('company_id', isEqualTo: companyId.value);
  //   Query<Map<String, dynamic>> query = collection;

  //   if (isAllSelected.value) {
  //     final snapshot = await query.get();
  //     allReceipts.assignAll(snapshot.docs);
  //     calculateMoneyForAllReceipts();
  //     numberOfReceipts.value = allReceipts.length;

  //     isScreenLodingForReceipts.value = false;
  //     return;
  //   }

  //   // 2) زر "Today"
  //   if (isTodaySelected.value) {
  //     final now = DateTime.now();
  //     final startOfDay = DateTime(now.year, now.month, now.day);
  //     final endOfDay =
  //         startOfDay.add(Duration(days: 1)).subtract(Duration(milliseconds: 1));
  //     fromDate.value.text = textToDate(startOfDay);
  //     toDate.value.text = textToDate(endOfDay);
  //     query = query
  //         .where('receipt_date',
  //             isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
  //         .where('receipt_date',
  //             isLessThanOrEqualTo: Timestamp.fromDate(endOfDay));
  //   }

  //   // 3) زر "This Month"
  //   else if (isThisMonthSelected.value) {
  //     final now = DateTime.now();
  //     final startOfMonth = DateTime(now.year, now.month, 1);
  //     final startOfNextMonth = (now.month < 12)
  //         ? DateTime(now.year, now.month + 1, 1)
  //         : DateTime(now.year + 1, 1, 1);
  //     final endOfMonth = startOfNextMonth.subtract(Duration(milliseconds: 1));
  //     fromDate.value.text = textToDate(startOfMonth);
  //     toDate.value.text = textToDate(endOfMonth);
  //     query = query
  //         .where('receipt_date',
  //             isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
  //         .where('receipt_date',
  //             isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth));
  //   }

  //   // 4) زر "This Year"
  //   else if (isThisYearSelected.value) {
  //     final now = DateTime.now();
  //     final startOfYear = DateTime(now.year, 1, 1);
  //     final startOfNextYear = DateTime(now.year + 1, 1, 1);
  //     final endOfYear = startOfNextYear.subtract(Duration(milliseconds: 1));
  //     fromDate.value.text = textToDate(startOfYear);
  //     toDate.value.text = textToDate(endOfYear);
  //     query = query
  //         .where('receipt_date',
  //             isGreaterThanOrEqualTo: Timestamp.fromDate(startOfYear))
  //         .where('receipt_date',
  //             isLessThanOrEqualTo: Timestamp.fromDate(endOfYear));
  //   }

  //   // 5) إذا لم يُختر أي من الأزرار الخاصة بالفترة، نطبق فلتر التواريخ اليدوي
  //   else {
  //     if (fromDate.value.text.trim().isNotEmpty) {
  //       try {
  //         final dtFrom = format.parseStrict(fromDate.value.text.trim());
  //         query = query.where(
  //           'receipt_date',
  //           isGreaterThanOrEqualTo: Timestamp.fromDate(dtFrom),
  //         );
  //       } catch (_) {}
  //     }
  //     if (toDate.value.text.trim().isNotEmpty) {
  //       try {
  //         final dtTo = format.parseStrict(toDate.value.text.trim());
  //         query = query.where(
  //           'receipt_date',
  //           isLessThanOrEqualTo: Timestamp.fromDate(dtTo),
  //         );
  //       } catch (_) {}
  //     }
  //   }

  //   // 6) باقي الفلاتر العامة
  //   if (receiptCounterFilter.value.text.trim().isNotEmpty) {
  //     query = query.where(
  //       'receipt_number',
  //       isEqualTo: receiptCounterFilter.value.text.trim(),
  //     );
  //   }
  //   if (receiptTypeFilterId.value.isNotEmpty) {
  //     query = query.where('receipt_type', isEqualTo: receiptTypeFilterId.value);
  //   }
  //   if (customerNameFilterId.value.isNotEmpty) {
  //     query = query.where('customer', isEqualTo: customerNameFilterId.value);
  //   }

  //   if (statusFilter.value.text.isNotEmpty) {
  //     query = query.where('status', isEqualTo: statusFilter.value.text);
  //   }

  //   if (accountFilterId.value.isNotEmpty) {
  //     query = query.where('account', isEqualTo: accountFilterId.value);
  //   }

  //   if (bankNameFilterId.value.isNotEmpty) {
  //     query = query.where('bank_name', isEqualTo: bankNameFilterId.value);
  //   }

  //   if (chequeNumberFilter.value.text.isNotEmpty) {
  //     query = query.where('cheque_number',
  //         isEqualTo: chequeNumberFilter.value.text);
  //   }

  //   // 7) تنفيذ الاستعلام وجلب النتائج
  //   final snapshot = await query.get();
  //   allReceipts.assignAll(snapshot.docs);
  //   numberOfReceipts.value = allReceipts.length;
  //   calculateMoneyForAllReceipts();
  //   isScreenLodingForReceipts.value = false;
  // }

  Future<void> searchEngineForReceipts() async {
    isScreenLodingForReceipts.value = true;

    // Start with the base query for the company.
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('all_receipts')
        .where('company_id', isEqualTo: companyId.value);

    // 1. APPLY DATE FILTERS TO THE FIRESTORE QUERY
    // This is the only part of the filtering that will be done server-side.
    // This approach requires only ONE composite index: (company_id, receipt_date).

    if (isAllSelected.value) {
      // No date filter needed if "All" is selected.
    } else if (isTodaySelected.value) {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      fromDate.value.text = textToDate(startOfDay);
      toDate.value.text = textToDate(endOfDay);
      query = query
          .where('receipt_date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('receipt_date', isLessThan: Timestamp.fromDate(endOfDay));
    } else if (isThisMonthSelected.value) {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = (now.month < 12)
          ? DateTime(now.year, now.month + 1, 1)
          : DateTime(now.year + 1, 1, 1);
      fromDate.value.text = textToDate(startOfMonth);
      toDate.value.text = textToDate(endOfMonth);
      query = query
          .where('receipt_date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where('receipt_date', isLessThan: Timestamp.fromDate(endOfMonth));
    } else if (isThisYearSelected.value) {
      final now = DateTime.now();
      final startOfYear = DateTime(now.year, 1, 1);
      final endOfYear = DateTime(now.year + 1, 1, 1);
      fromDate.value.text = textToDate(startOfYear);
      toDate.value.text = textToDate(endOfYear);
      query = query
          .where('receipt_date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfYear))
          .where('receipt_date', isLessThan: Timestamp.fromDate(endOfYear));
    } else {
      // Manual date range
      if (fromDate.value.text.trim().isNotEmpty) {
        try {
          final dtFrom = format.parseStrict(fromDate.value.text.trim());
          query = query.where('receipt_date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(dtFrom));
        } catch (_) {
          // Handle parsing error if necessary
        }
      }
      if (toDate.value.text.trim().isNotEmpty) {
        try {
          // Add 1 day to the 'to' date to make the range inclusive.
          final dtTo = format
              .parseStrict(toDate.value.text.trim())
              .add(const Duration(days: 1));
          query =
              query.where('receipt_date', isLessThan: Timestamp.fromDate(dtTo));
        } catch (_) {
          // Handle parsing error if necessary
        }
      }
    }

    // 2. EXECUTE THE FIRESTORE QUERY
    // Fetch all documents matching the company and date range.
    final snapshot = await query.get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> fetchedReceipts =
        snapshot.docs;

    // 3. APPLY ALL OTHER FILTERS ON THE CLIENT-SIDE
    // Now, filter the 'fetchedReceipts' list in memory.
    List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredReceipts =
        fetchedReceipts.where((doc) {
      final data = doc.data();

      // Receipt Number Filter
      if (receiptCounterFilter.value.text.trim().isNotEmpty &&
          data['receipt_number'] != receiptCounterFilter.value.text.trim()) {
        return false;
      }
      // Receipt Type Filter
      if (receiptTypeFilterId.value.isNotEmpty &&
          data['receipt_type'] != receiptTypeFilterId.value) {
        return false;
      }
      // Customer Filter
      if (customerNameFilterId.value.isNotEmpty &&
          data['customer'] != customerNameFilterId.value) {
        return false;
      }
      // Status Filter
      if (statusFilter.value.text.isNotEmpty &&
          data['status'] != statusFilter.value.text) {
        return false;
      }
      // Account Filter
      if (accountFilterId.value.isNotEmpty &&
          data['account'] != accountFilterId.value) {
        return false;
      }
      // Bank Name Filter
      if (bankNameFilterId.value.isNotEmpty &&
          data['bank_name'] != bankNameFilterId.value) {
        return false;
      }
      // Cheque Number Filter
      if (chequeNumberFilter.value.text.isNotEmpty &&
          data['cheque_number'] != chequeNumberFilter.value.text) {
        return false;
      }

      // If the document passed all filters, keep it.
      return true;
    }).toList();

    // 4. UPDATE THE UI
    allReceipts.assignAll(filteredReceipts);
    numberOfReceipts.value = allReceipts.length;
    calculateMoneyForAllReceipts(); // Make sure this function iterates over the final 'allReceipts' list
    isScreenLodingForReceipts.value = false;
  }

  Future<void> searchEngineForPayments() async {
    isScreenLodingForPayments.value = true;

    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('all_payments')
        .where('company_id', isEqualTo: companyId.value);

    if (isAllSelected.value) {
    } else if (isTodaySelected.value) {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      fromDate.value.text = textToDate(startOfDay);
      toDate.value.text = textToDate(endOfDay);
      query = query
          .where('payment_date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
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
          .where('payment_date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where('payment_date', isLessThan: Timestamp.fromDate(endOfMonth));
    } else if (isThisYearSelected.value) {
      final now = DateTime.now();
      final startOfYear = DateTime(now.year, 1, 1);
      final endOfYear = DateTime(now.year + 1, 1, 1);
      fromDate.value.text = textToDate(startOfYear);
      toDate.value.text = textToDate(endOfYear);
      query = query
          .where('payment_date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfYear))
          .where('payment_date', isLessThan: Timestamp.fromDate(endOfYear));
    } else {
      if (fromDate.value.text.trim().isNotEmpty) {
        try {
          final dtFrom = format.parseStrict(fromDate.value.text.trim());
          query = query.where('payment_date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(dtFrom));
        } catch (_) {}
      }
      if (toDate.value.text.trim().isNotEmpty) {
        try {
          final dtTo = format
              .parseStrict(toDate.value.text.trim())
              .add(const Duration(days: 1));
          query =
              query.where('payment_date', isLessThan: Timestamp.fromDate(dtTo));
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
          data['payment_number'] != receiptCounterFilter.value.text.trim()) {
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

  void removeFilters() {
    isAllSelected.value = false;
    isTodaySelected.value = false;
    isThisMonthSelected.value = false;
    isThisYearSelected.value = false;
  }

  void clearAllFilters() {
    statusFilter.value.clear();
    allReceipts.clear();
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
    isScreenLodingForReceipts.value = false;
  }
}
