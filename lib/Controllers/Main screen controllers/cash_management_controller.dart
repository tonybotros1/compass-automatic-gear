import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_screen_contro.dart';

class CashManagementController extends GetxController {
  Rx<TextEditingController> receiptDate = TextEditingController().obs;
  Rx<TextEditingController> receiptCounter = TextEditingController().obs;
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
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(true);
  final RxList<DocumentSnapshot> allCashsManagements =
      RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredCashsManagements =
      RxList<DocumentSnapshot>([]);

  final RxList<DocumentSnapshot> allMiscPayement = RxList<DocumentSnapshot>([]);

  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  RxBool postingReceipts = RxBool(false);
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
  RxDouble calculatedOutstandingForAllSelectedReceipts = RxDouble(0.0);
  RxString companyId = RxString('');
  RxMap allReceiptTypes = RxMap({});
  RxMap allCustomers = RxMap({});
  RxMap allVendors = RxMap({});
  RxMap allAccounts = RxMap({});
  RxMap allBanks = RxMap({});
  RxBool isReceiptAdded = RxBool(false);
  RxString currentReceiptID = RxString('');
  var editingIndex = (-1).obs;
  final ScrollController scrollController = ScrollController();
  final ScrollController scrollController2 = ScrollController();
  var buttonLoadingStates = <String, bool>{}.obs;

  @override
  void onInit() async {
    await getCompanyId();
    getAllEntities();
    getAllAccounts();
    getBanks();
    await getReceiptsTypes();
    getAllReceipts();
    // callEchoTestFunction();
    search.value.addListener(() {
      // filterCities();
    });
    super.onInit();
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

  getCompanyId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId.value = prefs.getString('companyId')!;
  }

  loadValues(Map data) async {
    status.value = data['status'] ?? '';
    isReceiptAdded.value = true;
    availableReceipts.clear();
    if (data['customer'] != '') {
      await getCurrentCustomerInvoices(data['customer'], data['job_ids']);
      calculateAmountForSelectedReceipts();
      calculateOutstandingForSelectedReceipts();
      // await getCustomerInvoices(data['customer']);
      // List jobIDs = data['job_ids'];
      // for (var i = 0; i < availableReceipts.length; i++) {
      //   if (jobIDs.contains(availableReceipts[i]['job_id'])) {
      //     selectJobReceipt(i, true);
      //   }
      // }
      // addSelectedReceipts();
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

  clearValues() {
    currency.clear();
    rate.clear();
    account.clear();
    accountId.value = '';
    outstanding.clear();
    isReceiptAdded.value = false;
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
    isAllJobReceiptsSelected.value = false;
    calculatedAmountForAllSelectedReceipts.value = 0.0;
    calculatedOutstandingForAllSelectedReceipts.value = 0.0;
    currentReceiptID.value = '';
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

  getScreenName() {
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

  calculateAmountForSelectedReceipts() {
    calculatedAmountForAllSelectedReceipts.value = 0.0;
    for (var element in selectedAvailableReceipts) {
      calculatedAmountForAllSelectedReceipts.value +=
          double.tryParse(element['receipt_amount'] ?? 0)!;
    }
  }

  calculateOutstandingForSelectedReceipts() {
    calculatedOutstandingForAllSelectedReceipts.value = 0.0;
    for (var element in selectedAvailableReceipts) {
      calculatedOutstandingForAllSelectedReceipts.value +=
          double.tryParse(element['outstanding_amount'] ?? 0)!;
    }
  }

// this functions is to add the selected receipts to the table in the new receipts screen
  addSelectedReceipts() {
    // selectedAvailableReceipts.clear();

    for (var element in availableReceipts) {
      if (element['is_selected'] == true) {
        selectedAvailableReceipts.add(element);
      }
    }

    calculateAmountForSelectedReceipts();
    calculateOutstandingForSelectedReceipts();
    update();
    Get.back();
  }

  addSelectedPayments() {
    // selectedAvailableReceipts.clear();

    for (var element in availablePayments) {
      if (element['is_selected'] == true) {
        selectedAvailablePayments.add(element);
      }
    }

    // calculateAmountForSelectedReceipts();
    // calculateOutstandingForSelectedReceipts();
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

  void removeSelectedPayment(String invoiceNumber) {
    // 1) Un‐select it in the main list
    final availIdx = availablePayments.indexWhere(
      (r) => r['invoice_number'] == invoiceNumber,
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
        .removeWhere((r) => r['invoice_number'] == invoiceNumber);

    // 3) Recalculate totals, etc.
    // calculateAmountForSelectedReceipts();
  }

  // this function is to get colors
  getReceiptsTypes() async {
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

  getAllEntities() {
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

  getAllAccounts() {
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

  getVendorInvoices(String vendorId) async {
    try {
      loadingInvoices.value = true;
      availablePayments.clear();
      List result = [];
      var apInvoices = await FirebaseFirestore.instance
          .collection('ap_invoices')
          .where('company_id', isEqualTo: companyId.value)
          .where('vendor', isEqualTo: vendorId)
          .where('status', isEqualTo: 'Posted')
          .get();

      for (var apInvoice in apInvoices.docs) {
        var apInvoiceId = apInvoice.id;
        var apInvoiceData = apInvoice.data();
        double invoiceAmount = await calculateSumOfAmounts(apInvoiceId) ?? 0.0;
        double paymentAmount =
            await calculateTotalPaymentsForAPInvoices(apInvoiceId) ?? 0.0;

        double outstanding = invoiceAmount - paymentAmount;
        if (outstanding > 0) {
          var vendorId = apInvoiceData['vendor'] ?? '';
          var vendorData = await FirebaseFirestore.instance
              .collection('entity_informations')
              .doc(vendorId)
              .get();
          var vendorName = vendorData.data()?['entity_name'] ?? '';
          var date = textToDate(apInvoiceData['invoice_date'] ?? '');

          String note =
              'Invoice Number: ${apInvoiceData['invoice_number'] ?? ''}, Invoice Date: $date, Vendor: $vendorName';

          result.add({
            'is_selected': false,
            'ap_invoice_id': apInvoiceId,
            'invoice_number': apInvoiceData['invoice_number'] ?? '',
            'invoice_date': date,
            'invoice_amount': invoiceAmount.toString(),
            'payment_amount': outstanding.toString(),
            'outstanding_amount': outstanding.toString(),
            'notes': note
          });
        }
      }
      availablePayments.assignAll(result);
      loadingInvoices.value = false;
    } catch (e) {
      loadingInvoices.value = false;
    }
  }

  calculateSumOfAmounts(apId) async {
    try {
      double totalAmounts = 0.0;
      var items = await FirebaseFirestore.instance
          .collection('ap_invoices')
          .doc(apId)
          .collection('invoices')
          .get();
      for (var item in items.docs) {
        var itemData = item.data();
        totalAmounts += double.parse(itemData['amount'] ?? '0');
      }
      return totalAmounts;
    } catch (e) {
      return 0.0;
    }
  }

  calculateTotalPaymentsForAPInvoices(apId) async {
    try {
      double total = 0.0;
      var payments = await FirebaseFirestore.instance
          .collection('all_payments')
          .where('ap_invoice_ids', arrayContains: apId)
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

  getAllReceipts() {
    try {
      FirebaseFirestore.instance
          .collection('all_receipts')
          .where('company_id', isEqualTo: companyId.value)
          .orderBy('receipt_number', descending: true)
          .snapshots()
          .listen((QuerySnapshot<Map<String, dynamic>> receipts) {
        allCashsManagements.assignAll(receipts.docs);
        isScreenLoding.value = false;
      });
      isScreenLoding.value = false;
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  addNewReceipts() async {
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
        'receipt_date': receiptDate.value.text,
        'customer': customerNameId.value,
        'note': note.text,
        'receipt_type': receiptTypeId.value,
        'cheque_number': chequeNumber.text,
        'bank_name': bankId.value,
        'cheque_date': chequeDate.text,
        'jobs': jobsMap,
        'job_ids': jobIds,
        'account': accountId.value,
        'currency': currency.text,
        'rate': rate.text,
      };

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

  addNewPayment() async {
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
        'receipt_date': receiptDate.value.text,
        'customer': customerNameId.value,
        'note': note.text,
        'receipt_type': receiptTypeId.value,
        'cheque_number': chequeNumber.text,
        'bank_name': bankId.value,
        'cheque_date': chequeDate.text,
        'jobs': jobsMap,
        'job_ids': jobIds,
        'account': accountId.value,
        'currency': currency.text,
        'rate': rate.text,
      };

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

  editReceipt(id) async {
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
        'receipt_date': receiptDate.value.text,
        'customer': customerNameId.value,
        'note': note.text,
        'receipt_type': receiptTypeId.value,
        'cheque_number': chequeNumber.text,
        'bank_name': bankId.value,
        'cheque_date': chequeDate.text,
        'jobs': jobsMap,
        'job_ids': jobIds,
        'account': accountId.value,
        'rate': rate.text,
      };

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

  deleteReceipt(id) async {
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

  postReceipt(receiptID) async {
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
      receiptDate.value.text = textToDate(DateTime.now().toString());

      FirebaseFirestore.instance
          .collection('all_receipts')
          .doc(receiptID)
          .update({
        'status': 'Posted',
        'receipt_date': receiptDate.value.text,
        'receipt_number': receiptCounter.value.text
      });
      status.value = 'Posted';
      showSnackBar('Done', 'Receipt Posted');
      update();
    } catch (e) {
      showSnackBar('Something Went Wrong', 'Please try again');
    }
  }

  getCurrencyName(countryId) async {
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

  getCurrencyRate(currencyId) async {
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

  calculateCustomerOutstanding(customerId) async {
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
  getBanks() async {
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
}
