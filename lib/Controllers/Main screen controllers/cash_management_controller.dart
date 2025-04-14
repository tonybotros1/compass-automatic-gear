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
  TextEditingController customerName = TextEditingController();
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

  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  final GlobalKey<FormState> formKeyForAddingNewvalue = GlobalKey<FormState>();
  RxBool addingNewValue = RxBool(false);
  RxBool postingReceipts = RxBool(false);
  RxBool isChequeSelected = RxBool(false);
  RxString receiptTypeId = RxString('');
  RxString customerNameId = RxString('');
  RxString accountId = RxString('');
  RxString bankId = RxString('');
  RxString status = RxString('');
  RxList availableReceipts = RxList([]);
  RxList selectedAvailableReceipts = RxList([]);
  RxBool isAllJobReceiptsSelected = RxBool(false);
  RxBool loadingInvoices = RxBool(false);
  RxDouble calculatedAmountForAllSelectedReceipts = RxDouble(0.0);
  RxDouble calculatedOutstandingForAllSelectedReceipts = RxDouble(0.0);
  RxString companyId = RxString('');
  RxMap allReceiptTypes = RxMap({});
  RxMap allCustomers = RxMap({});
  RxMap allAccounts = RxMap({});
  RxMap allBanks = RxMap({});
  RxBool isReceiptAdded = RxBool(false);
  RxString currentReceiptID = RxString('');
  @override
  void onInit() async {
    await getCompanyId();
    getAllCashes();
    getAllCustomers();
    getAllAccounts();
    getReceiptsTypes();
    getBanks();
    // callEchoTestFunction();
    search.value.addListener(() {
      // filterCities();
    });
    super.onInit();
  }

  getCompanyId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId.value = prefs.getString('companyId')!;
  }

  clearValues() {
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

  // this function is to select single receipt
  void selectJobReceipt(int i, bool value) {
    availableReceipts[i]['is_selected'] = value;
    update();
  }

// this function is to select all receipts
  void selectAllJobReceipts(bool value) {
    for (var element in availableReceipts) {
      element['is_selected'] = value;
    }
    isAllJobReceiptsSelected.value = value;
    update();
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
    selectedAvailableReceipts.clear();

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

  removeSelectedReceipt(int i) {
    final removed = selectedAvailableReceipts[i];

    // Find the matching receipt in availableReceipts
    final indexInAvailable = availableReceipts.indexWhere(
      (receipt) => receipt['invoice_number'] == removed['invoice_number'],
    );

    // Set is_selected to false if found
    if (indexInAvailable != -1) {
      availableReceipts[indexInAvailable]['is_selected'] = false;
    }

    selectedAvailableReceipts.removeAt(i);
    calculateAmountForSelectedReceipts();
    update();
  }

  getAllCashes() {
    try {
      // FirebaseFirestore.instance
      //     .collection('all_countries')
      //     .snapshots()
      //     .listen((countries) {
      //   allCountries.assignAll(List<DocumentSnapshot>.from(countries.docs));
      //   isScreenLoding.value = false;
      // });
      isScreenLoding.value = false;
    } catch (e) {
      isScreenLoding.value = false;
    }
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

  getAllCustomers() {
    try {
      FirebaseFirestore.instance
          .collection('entity_informations')
          .where('entity_code', arrayContains: 'Customer')
          .snapshots()
          .listen((customers) {
        allCustomers.value = {
          for (var doc in customers.docs) doc.id: doc.data()
        };
      });
    } catch (e) {
      //
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
      print(availableReceipts);
    } on FirebaseFunctionsException catch (e) {
      // Catch and log errors from the Firebase function.
      showSnackBar('Alert', 'Error: ${e.message}');
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
    } finally {
      loadingInvoices.value = false;
    }
  }

  addNewReceipts() async {
    try {
      addingNewValue.value = true;

      // Map<String, dynamic> jobsMap = {};
      // List<String> jobIds = [];

      // for (final receipt in selectedAvailableReceipts) {
      //   final String? jobId = receipt['job_id'];
      //   final dynamic amount = receipt['receipt_amount'];

      //   if (jobId != null && amount != null) {
      //     jobsMap[jobId] = amount;
      //     jobIds.add(jobId);
      //   }
      // }

      var currentReceipt =
          await FirebaseFirestore.instance.collection('all_receipts').add({
        'receipt_number': receiptCounter.value.text,
        'receipt_date': receiptDate.value.text,
        'customer': customerNameId.value,
        'note': note.text,
        'receipt_type': receiptTypeId.value,
        'cheque_number': chequeNumber.text,
        'bank_name': bankName.text,
        'cheque_date': chequeDate.text,
        'jobs': {},
        'job_ids': [],
        'account': accountId.value,
        'currency': currency.text,
        'rate': rate.text,
        'status': 'New',
      });
      currentReceiptID.value = currentReceipt.id;
      status.value = 'New';
      addingNewValue.value = false;
      isReceiptAdded.value = true;
    } catch (e) {
      addingNewValue.value = false;
      isReceiptAdded.value = false;
      showSnackBar('Failed', 'Please try again');
      // Handle any errors here
    }
  }

  postReceipt(receiptID) async {
    try {
      await getCurrentReceiptCounterNumber();
      receiptDate.value.text = textToDate(DateTime.now().toString());
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
      FirebaseFirestore.instance
          .collection('all_receipts')
          .doc(receiptID)
          .update({
        'status': 'Posted',
        'jobs': jobsMap,
        'job_ids': jobIds,
        'receipt_date': receiptDate.value.text
      });
      status.value = 'Posted';
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
