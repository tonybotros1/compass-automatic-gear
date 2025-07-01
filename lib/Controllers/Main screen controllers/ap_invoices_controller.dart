import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../consts.dart';

class ApInvoicesController extends GetxController {
  TextEditingController miscType = TextEditingController();
  RxString miscTypeFilterId = RxString('');
  TextEditingController miscTypeFilter = TextEditingController();
  RxString status = RxString('');
  TextEditingController referenceNumber = TextEditingController();
  TextEditingController referenceNumberFilter = TextEditingController();
  TextEditingController transactionDate = TextEditingController();
  TextEditingController vendor = TextEditingController();
  Rx<TextEditingController> vendorFilter = TextEditingController().obs;
  Rx<TextEditingController> statusFilter = TextEditingController().obs;
  TextEditingController note = TextEditingController();
  TextEditingController searchForJobCards = TextEditingController();
  TextEditingController jobNumber = TextEditingController();
  TextEditingController vendorForInvoice = TextEditingController();
  TextEditingController invoiceDate = TextEditingController();
  TextEditingController invoiceNumber = TextEditingController();
  TextEditingController vat = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController transactionType = TextEditingController();
  TextEditingController invoiceNote = TextEditingController();
  Rx<TextEditingController> fromDate = TextEditingController().obs;
  Rx<TextEditingController> toDate = TextEditingController().obs;
  RxBool isYearSelected = RxBool(false);
  RxBool isMonthSelected = RxBool(false);
  RxBool isDaySelected = RxBool(false);
  RxBool isTodaySelected = RxBool(false);
  RxBool isAllSelected = RxBool(false);
  RxBool isThisMonthSelected = RxBool(false);
  RxBool isThisYearSelected = RxBool(false);
  RxString query = RxString('');
  final ScrollController scrollControllerFotTable1 = ScrollController();
  var buttonLoadingStates = <String, bool>{}.obs;

  RxBool isScreenLoding = RxBool(false);
  final RxList<DocumentSnapshot> allApInvoices = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> allInvoices = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> allJobCards = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredJobCards =
      RxList<DocumentSnapshot>([]);
  RxBool addingNewinvoiceItemsValue = RxBool(false);
  RxString miscTypeId = RxString('');
  RxString vendorId = RxString('');
  RxString vendorForInvoiceId = RxString('');
  RxString transactionTypeId = RxString('');
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool loadingInvoices = RxBool(false);
  RxMap allMiscTypes = RxMap({});
  RxMap allBrands = RxMap({});
  RxMap allStatus = RxMap({
    '1': {'name': 'New'},
    '2': {'name': 'Posted'},
    '3': {'name': 'Cancelled'}
  });
  RxMap allTransactionsTypes = RxMap({});
  RxString companyId = RxString('');
  RxMap allVendors = RxMap({});
  RxMap allCustomers = RxMap({});
  RxBool loadingJobCards = RxBool(false);
  // RxBool loadingInvoiceItems = RxBool(false);
  RxBool addingNewValue = RxBool(false);
  RxBool apInvoiceAdded = RxBool(false);
  RxBool canAddInvoice = RxBool(false);
  RxString currentApInvoiceId = RxString('');
  DateFormat format = DateFormat("dd-MM-yyyy");
  RxBool postingapInvoice = RxBool(false);
  RxBool cancellingapInvoice = RxBool(false);

  @override
  void onInit() async {
    await getCompanyId();
    getMiscTypes();
    // getAllVendors();
    getAllEntities();
    getCarBrands();
    getTransactionTypes();
    super.onInit();
  }

  getCompanyId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId.value = prefs.getString('companyId')!;
  }

  loadValues(typeId, typeData) async {
    await getAllInvoices(typeId);
    miscType.text = getdataName(typeData['misc_type'], allMiscTypes);
    miscTypeId.value = typeData['misc_type'] ?? '';
    referenceNumber.text = typeData['reference_number'] ?? '';
    transactionDate.text = textToDate(typeData['transaction_date']);
    vendor.text =
        getdataName(typeData['beneficiary'], allVendors, title: 'entity_name');
    vendorId.value = typeData['beneficiary'] ?? '';
    note.text = typeData['note'] ?? '';

    status.value = typeData['status'] ?? '';
    canAddInvoice.value = true;
  }

  editApInvoice(id) async {
    try {
      if (status.value == 'Posted' || status.value == 'Cancelled') {
        showSnackBar('Alert', 'Can\'t Edit For Posted / Cancelled AP Invoices');
        return;
      }
      addingNewValue.value = true;
      Map<String, dynamic> newData = {
        'misc_type': miscTypeId.value,
        'beneficiary': vendorId.value,
        'note': note.text,
      };

      final rawDate = transactionDate.value.text.trim();
      if (rawDate.isNotEmpty) {
        try {
          newData['transaction_date'] = Timestamp.fromDate(
            format.parseStrict(rawDate),
          );
        } catch (e) {
          showSnackBar('Alert', 'Please Enter Valid Date');
          return;
        }

        await FirebaseFirestore.instance
            .collection('ap_invoices')
            .doc(id)
            .update(newData);
        showSnackBar('Done', 'Updated Successfully');
        addingNewValue.value = false;
      }
    } catch (e) {
      addingNewValue.value = false;
      showSnackBar('Alert', 'Something Went Wrong');
    }
  }

  deleteInvoiceItem(String id, String itemId) {
    try {
      Get.back();
      FirebaseFirestore.instance
          .collection('ap_invoices')
          .doc(id)
          .collection('invoices')
          .doc(itemId)
          .delete();
    } catch (e) {
      //
    }
  }

  addNewApInvoice() async {
    try {
      showSnackBar('Adding', 'Please Wait');
      addingNewValue.value = true;
      Map<String, dynamic> newData = {
        'misc_type': miscTypeId.value,
        'beneficiary': vendorId.value,
        'note': note.text,
        'company_id': companyId.value
      };

      final rawDate = transactionDate.value.text.trim();
      if (rawDate.isNotEmpty) {
        try {
          newData['transaction_date'] = Timestamp.fromDate(
            format.parseStrict(rawDate),
          );
        } catch (e) {
          showSnackBar('Alert', 'Please Enter Valid Date');
          return;
          // إذا حابب تعرض للمستخدم خطأ في التنسيق
          // print('Invalid quotation_date format: $e');
        }
      }

      if (referenceNumber.text.isEmpty) {
        status.value = 'New';

        newData['status'] = 'New';
        await getCurrentApInvoicesNumber();
        newData['reference_number'] = referenceNumber.text;
      }

      if (apInvoiceAdded.isFalse) {
        newData['added_date'] = DateTime.now().toString();
        var newJob = await FirebaseFirestore.instance
            .collection('ap_invoices')
            .add(newData);
        apInvoiceAdded.value = true;
        currentApInvoiceId.value = newJob.id;
        getAllInvoices(newJob.id);
        showSnackBar('Done', 'Added Successfully');
      } else {
        newData.remove('added_date');
        await FirebaseFirestore.instance
            .collection('ap_invoices')
            .doc(currentApInvoiceId.value)
            .update(newData);
        showSnackBar('Done', 'Updated Successfully');
      }
      canAddInvoice.value = true;
      addingNewValue.value = false;

      // FirebaseFirestore.instance.collection('ap_invoices').add(newData);
    } catch (e) {
      addingNewValue.value = false;
      showSnackBar('Alert', 'Something Went Wrong');
    }
  }

  editPostForApInvoices(id) async {
    try {
      postingapInvoice.value = true;
      await FirebaseFirestore.instance
          .collection('ap_invoices')
          .doc(id)
          .update({'status': 'Posted'});
      status.value = 'Posted';
      postingapInvoice.value = false;
      showSnackBar('Done', 'AP Invoice is Posted');
    } catch (e) {
      postingapInvoice.value = false;
      showSnackBar('Alert', 'Something Went Wrong');
    }
  }

  editCancelForApInvoices(id) async {
    try {
      cancellingapInvoice.value = true;
      await FirebaseFirestore.instance
          .collection('ap_invoices')
          .doc(id)
          .update({'status': 'Cancelled'});
      status.value = 'Cancelled';
      cancellingapInvoice.value = false;
      showSnackBar('Done', 'AP Invoice is Cancelled');
    } catch (e) {
      cancellingapInvoice.value = false;
      showSnackBar('Alert', 'Something Went Wrong');
    }
  }

  getAllInvoices(jobId) {
    try {
      loadingInvoices.value = true;
      FirebaseFirestore.instance
          .collection('ap_invoices')
          .doc(jobId)
          .collection('invoices')
          .orderBy('job_number')
          .snapshots()
          .listen((QuerySnapshot<Map<String, dynamic>> items) {
        allInvoices.assignAll(items.docs);
        loadingInvoices.value = false;
      });
    } catch (e) {
      loadingInvoices.value = false;
    }
  }

  addNewInvoiceItem(id) async {
    try {
      addingNewinvoiceItemsValue.value = true;

      Map<String, dynamic> newData = {
        'company_id': companyId.value,
        'added_date': DateTime.now(),
        'transaction_type': transactionTypeId.value,
        'amount': amount.text,
        'vat': vat.text,
        'invoice_number': invoiceNumber.text,
        'vendor': vendorForInvoiceId.value,
        'job_number': jobNumber.text,
        'note': invoiceNote.text,
        'report_reference': '',
      };

      final rawDate = invoiceDate.value.text.trim();
      if (rawDate.isNotEmpty) {
        try {
          newData['invoice_date'] = Timestamp.fromDate(
            format.parseStrict(rawDate),
          );
        } catch (e) {
          showSnackBar('Alert', 'Please Enter Valid Date');
          return;
          // إذا حابب تعرض للمستخدم خطأ في التنسيق
          // print('Invalid quotation_date format: $e');
        }
      }

      await FirebaseFirestore.instance
          .collection('ap_invoices')
          .doc(id)
          .collection('invoices')
          .add(newData);

      addingNewinvoiceItemsValue.value = false;
      Get.back();
    } catch (e) {
      print(e);
      addingNewinvoiceItemsValue.value = false;
      showSnackBar('Alert', 'Something Went Wrong Please Try Again');
    }
  }

  Future<void> getCurrentApInvoicesNumber() async {
    try {
      var apnId = '';
      var updateApInvoices = '';
      var apnDoc = await FirebaseFirestore.instance
          .collection('counters')
          .where('code', isEqualTo: 'APIN')
          .where('company_id', isEqualTo: companyId.value)
          .get();

      if (apnDoc.docs.isEmpty) {
        // Define constants for the new counter values
        const prefix = 'AI';
        const separator = '-';
        const initialValue = 1;

        var newCounter =
            await FirebaseFirestore.instance.collection('counters').add({
          'code': 'APIN',
          'description': 'AP Invoices Number',
          'prefix': prefix,
          'value': initialValue,
          'length': 0,
          'separator': separator,
          'added_date': DateTime.now().toString(),
          'company_id': companyId.value,
          'status': true,
        });
        apnId = newCounter.id;
        // Set the counter text with prefix and separator
        referenceNumber.text = '$prefix$separator$initialValue';
        updateApInvoices = initialValue.toString();
      } else {
        var firstDoc = apnDoc.docs.first;
        apnId = firstDoc.id;
        var currentValue = firstDoc.data()['value'] ?? 0;
        // Use the existing prefix and separator from the document
        referenceNumber.text =
            '${firstDoc.data()['prefix']}${firstDoc.data()['separator']}${(currentValue + 1).toString().padLeft(firstDoc.data()['length'], '0')}';
        updateApInvoices = (currentValue + 1).toString();
      }

      await FirebaseFirestore.instance
          .collection('counters')
          .doc(apnId)
          .update({
        'value': int.parse(updateApInvoices),
      });
    } catch (e) {
      // Optionally handle errors here
      // print("Error in getCurrentJobCardCounterNumber: $e");
    }
  }

  getAllJobCards() async {
    try {
      loadingJobCards.value = true;
      var job = await FirebaseFirestore.instance
          .collection('job_cards')
          .where('company_id', isEqualTo: companyId.value)
          .get();
      allJobCards.assignAll(job.docs);
    } catch (e) {
      loadingJobCards.value = false;
    } finally {
      loadingJobCards.value = false;
    }
  }

// this function is to get colors
  getMiscTypes() async {
    var typeDoc = await FirebaseFirestore.instance
        .collection('all_lists')
        .where('code', isEqualTo: 'MISC_TYPE')
        .get();

    var typeId = typeDoc.docs.first.id;

    FirebaseFirestore.instance
        .collection('all_lists')
        .doc(typeId)
        .collection('values')
        .where('available', isEqualTo: true)
        .orderBy('name')
        .snapshots()
        .listen((colors) {
      allMiscTypes.value = {for (var doc in colors.docs) doc.id: doc.data()};
    });
  }

  getAllVendors() {
    try {
      FirebaseFirestore.instance
          .collection('entity_informations')
          .where('company_id', isEqualTo: companyId.value)
          .where('entity_code', arrayContains: 'Vendor')
          .orderBy('entity_name')
          .snapshots()
          .listen((customers) {
        allVendors.value = {for (var doc in customers.docs) doc.id: doc.data()};
      });
    } catch (e) {
      //
    }
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

  getCarBrands() {
    try {
      FirebaseFirestore.instance
          .collection('all_brands')
          .orderBy('name')
          .snapshots()
          .listen((brands) {
        allBrands.value = {for (var doc in brands.docs) doc.id: doc.data()};
      });
    } catch (e) {
      //
    }
  }

  getTransactionTypes() {
    try {
      FirebaseFirestore.instance
          .collection('ap_payment_types')
          .orderBy('type')
          .snapshots()
          .listen((types) {
        allTransactionsTypes.value = {
          for (var doc in types.docs) doc.id: doc.data()
        };
      });
    } catch (e) {
      //
    }
  }

  searchEngineForJobCards() {
    query.value = searchForJobCards.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredJobCards.clear();
    } else {
      filteredJobCards.assignAll(
        allJobCards.where((job) {
          return job['job_number'].toString().toLowerCase().contains(query) ||
              getdataName(job['car_brand'], allBrands)
                  .toString()
                  .toLowerCase()
                  .contains(query) ||
              job['plate_number'].toString().toLowerCase().contains(query) ||
              job['vehicle_identification_number']
                  .toString()
                  .toLowerCase()
                  .contains(query) ||
              getdataName(job['customer'], allCustomers, title: 'entity_name')
                  .toString()
                  .toLowerCase()
                  .contains(query);
        }).toList(),
      );
    }
  }

  Future<void> searchEngine() async {
    isScreenLoding.value = true;
    final collection = FirebaseFirestore.instance
        .collection('ap_invoices')
        .where('company_id', isEqualTo: companyId.value);
    Query<Map<String, dynamic>> query = collection;

    // 1) زر "All" يجلب كل البيانات فورًا
    if (isAllSelected.value) {
      // لا نضيف أي where، نجلب كل الوثائق
      final snapshot = await query.get();
      allApInvoices.assignAll(snapshot.docs);
      // calculateMoneyForAllJobs();
      // numberOfJobs.value = allJobCards.length;

      isScreenLoding.value = false;
      return;
    }

    // 2) زر "Today"
    if (isTodaySelected.value) {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay =
          startOfDay.add(Duration(days: 1)).subtract(Duration(milliseconds: 1));
      fromDate.value.text = textToDate(startOfDay);
      toDate.value.text = textToDate(endOfDay);
      query = query
          .where('transaction_date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('transaction_date',
              isLessThanOrEqualTo: Timestamp.fromDate(endOfDay));
    }

    // 3) زر "This Month"
    else if (isThisMonthSelected.value) {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final startOfNextMonth = (now.month < 12)
          ? DateTime(now.year, now.month + 1, 1)
          : DateTime(now.year + 1, 1, 1);
      final endOfMonth = startOfNextMonth.subtract(Duration(milliseconds: 1));
      fromDate.value.text = textToDate(startOfMonth);
      toDate.value.text = textToDate(endOfMonth);
      query = query
          .where('transaction_date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where('transaction_date',
              isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth));
    }

    // 4) زر "This Year"
    else if (isThisYearSelected.value) {
      final now = DateTime.now();
      final startOfYear = DateTime(now.year, 1, 1);
      final startOfNextYear = DateTime(now.year + 1, 1, 1);
      final endOfYear = startOfNextYear.subtract(Duration(milliseconds: 1));
      fromDate.value.text = textToDate(startOfYear);
      toDate.value.text = textToDate(endOfYear);
      query = query
          .where('transaction_date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfYear))
          .where('transaction_date',
              isLessThanOrEqualTo: Timestamp.fromDate(endOfYear));
    }

    // 5) إذا لم يُختر أي من الأزرار الخاصة بالفترة، نطبق فلتر التواريخ اليدوي
    else {
      if (fromDate.value.text.trim().isNotEmpty) {
        try {
          final dtFrom = format.parseStrict(fromDate.value.text.trim());
          query = query.where(
            'transaction_date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(dtFrom),
          );
        } catch (_) {}
      }
      if (toDate.value.text.trim().isNotEmpty) {
        try {
          final dtTo = format.parseStrict(toDate.value.text.trim());
          query = query.where(
            'transaction_date',
            isLessThanOrEqualTo: Timestamp.fromDate(dtTo),
          );
        } catch (_) {}
      }
    }

    // 6) باقي الفلاتر العامة
    if (referenceNumberFilter.value.text.trim().isNotEmpty) {
      query = query.where(
        'reference_number',
        isEqualTo: referenceNumberFilter.value.text.trim(),
      );
    }
    if (vendorFilter.value.text.isNotEmpty) {
      query = query.where('beneficiary', isEqualTo: vendorFilter.value.text);
    }
    if (miscTypeFilterId.value.isNotEmpty) {
      query = query.where('misc_type', isEqualTo: miscTypeFilterId.value);
    }

    if (statusFilter.value.text.isNotEmpty) {
      query = query.where('status', isEqualTo: statusFilter.value.text);
    }

    // 7) تنفيذ الاستعلام وجلب النتائج
    final snapshot = await query.get();
    allApInvoices.assignAll(snapshot.docs);
    // numberOfJobs.value = allJobCards.length;
    // calculateMoneyForAllJobs();
    isScreenLoding.value = false;
  }

  removeFilters() {
    isAllSelected.value = false;
    isTodaySelected.value = false;
    isThisMonthSelected.value = false;
    isThisYearSelected.value = false;
  }

  clearAllFilters() {
    allApInvoices.clear();
    // numberOfJobs.value = 0;
    // allJobsTotals.value = 0;
    // allJobsVATS.value = 0;
    // allJobsNET.value = 0;
    statusFilter.value.clear();
    isAllSelected.value = false;
    isTodaySelected.value = false;
    isThisMonthSelected.value = false;
    isThisYearSelected.value = false;
    referenceNumberFilter.clear();
    miscTypeFilterId.value = '';
    miscTypeFilter.clear();
    vendorFilter.value = TextEditingController();

    fromDate.value.clear();
    toDate.value.clear();
    isScreenLoding.value = false;
    update();
  }
}
