import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../Models/ar receipts and ap payments/ap_invoices_model.dart';
import '../../Models/job cards/job_card_model.dart';
import '../../consts.dart';
import '../../helpers.dart';

class ApInvoicesController extends GetxController {
  TextEditingController invoiceType = TextEditingController();
  RxString invoiceTypeFilterId = RxString('');
  TextEditingController invoiceTypeFilter = TextEditingController();
  RxString status = RxString('');
  TextEditingController referenceNumber = TextEditingController();
  TextEditingController referenceNumberFilter = TextEditingController();
  TextEditingController transactionDate = TextEditingController();
  TextEditingController vendor = TextEditingController();
  Rx<TextEditingController> vendorFilter = TextEditingController().obs;
  Rx<TextEditingController> statusFilter = TextEditingController().obs;
  TextEditingController description = TextEditingController();
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
  final RxList<ApInvoicesItem> allInvoices = RxList<ApInvoicesItem>([]);
  final RxList<JobCardModel> allJobCards = RxList<JobCardModel>([]);
  final RxList<JobCardModel> filteredJobCards = RxList<JobCardModel>([]);
  // RxBool addingNewinvoiceItemsValue = RxBool(false);
  RxString invoiceTypeId = RxString('');
  RxString vendorId = RxString('');
  RxString vendorForInvoiceId = RxString('');
  RxString transactionTypeId = RxString('');
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool loadingInvoices = RxBool(false);
  RxMap allInvoiceTypes = RxMap({});

  RxBool loadingJobCards = RxBool(false);
  // RxBool loadingInvoiceItems = RxBool(false);
  RxBool addingNewValue = RxBool(false);
  RxBool apInvoiceAdded = RxBool(false);
  RxBool canAddInvoice = RxBool(false);
  RxString currentApInvoiceId = RxString('');
  DateFormat format = DateFormat("dd-MM-yyyy");
  RxBool postingapInvoice = RxBool(false);
  RxBool cancellingapInvoice = RxBool(false);
  RxBool deletingapInvoice = RxBool(false);

  // for the new invoice item
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();
  final FocusNode focusNode5 = FocusNode();
  final FocusNode focusNode6 = FocusNode();
  final FocusNode focusNode7 = FocusNode();
  final FocusNode focusNode8 = FocusNode();

  // for the payment header
  final FocusNode focusNodePayementHeader1 = FocusNode();
  final FocusNode focusNodePayementHeader2 = FocusNode();
  final FocusNode focusNodePayementHeader3 = FocusNode();
  final FocusNode focusNodePayementHeader4 = FocusNode();

  String backendUrl = backendTestURI;
  final Uuid _uuid = const Uuid();

  @override
  void onInit() async {
    super.onInit();
  }

  Future<Map<String, dynamic>> getAllVendors() async {
    return await helper.getVendors();
  }

  Future<Map<String, dynamic>> getInvoiceTypes() async {
    return await helper.getAllListValues('MISC_TYPE');
  }

  Future<Map<String, dynamic>> getTransactionTypes() async {
    return await helper.getAllAPPaymentTypes();
  }

  Future<void> getAllJobCards() async {
    try {
      loadingJobCards.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/job_cards/get_all_job_cards');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List jobs = decoded['all_jobs'];
        allJobCards.assignAll(jobs.map((job) => JobCardModel.fromJson(job)));
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllJobCards();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
    } catch (e) {
      loadingJobCards.value = false;
    } finally {
      loadingJobCards.value = false;
    }
  }

  // =======================================================================================================================

  Future<void> loadValues(String typeId, typeData) async {
    invoiceNumber.text = typeData['invoice_number'] ?? '';
    invoiceDate.text = textToDate(typeData['invoice_date'] ?? '');
    getAllInvoices(typeId);
    invoiceType.text = getdataName(
      typeData['invoice_type'] ?? '',
      allInvoiceTypes,
    );
    invoiceTypeId.value = typeData['invoice_type'] ?? '';
    referenceNumber.text = typeData['reference_number'] ?? '';
    transactionDate.text = textToDate(typeData['transaction_date']);
    // vendor.text = getdataName(. // need to be fixed
    //   typeData['vendor'] ?? '',
    //   allVendors,
    //   title: 'entity_name',
    // );
    vendorId.value = typeData['vendor'] ?? '';
    description.text = typeData['description'] ?? '';

    status.value = typeData['status'] ?? '';
    canAddInvoice.value = true;
  }

  Future<void> editApInvoice(String id) async {
    try {
      if (status.value == 'Posted' || status.value == 'Cancelled') {
        showSnackBar('Alert', 'Can\'t Edit For Posted / Cancelled AP Invoices');
        return;
      }
      addingNewValue.value = true;
      Map<String, dynamic> newData = {
        'invoice_type': invoiceTypeId.value,
        'vendor': vendorId.value,
        'description': description.text,
        'invoice_number': invoiceNumber.text,
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
      }

      final rawDate2 = invoiceDate.value.text.trim();
      if (rawDate2.isNotEmpty) {
        try {
          newData['invoice_date'] = Timestamp.fromDate(
            format.parseStrict(rawDate2),
          );
        } catch (e) {
          showSnackBar('Alert', 'Please Enter Valid Date');
          return;
        }
      }

      await FirebaseFirestore.instance
          .collection('ap_invoices')
          .doc(id)
          .update(newData);
      showSnackBar('Done', 'Updated Successfully');
      addingNewValue.value = false;
    } catch (e) {
      addingNewValue.value = false;
      showSnackBar('Alert', 'Something Went Wrong');
    }
  }

  Future<void> deleteApInvoice(String id) async {
    try {
      deletingapInvoice.value = true;
      await FirebaseFirestore.instance
          .collection('ap_invoices')
          .doc(id)
          .delete();
      deletingapInvoice.value = false;
    } catch (e) {
      deletingapInvoice.value = false;
    }
  }

  // Future<void> deleteInvoiceItem(String id, String itemId) async {
  //   // try {
  //   //   Get.back();
  //   //   await FirebaseFirestore.instance
  //   //       .collection('ap_invoices')
  //   //       .doc(id)
  //   //       .collection('invoices')
  //   //       .doc(itemId)
  //   //       .delete();

  //   //   double allamounts = 0.0;
  //   //   double allVats = 0.0;
  //   //   for (var invoice in allInvoices) {
  //   //     allamounts +=
  //   //         double.tryParse(invoice.data()['amount'].toString()) ?? 0.0;
  //   //     allVats += double.tryParse(invoice.data()['vat'].toString()) ?? 0.0;
  //   //   }
  //   //   await FirebaseFirestore.instance.collection('ap_invoices').doc(id).update(
  //   //     {'total_amount': allamounts, 'total_vat_amount': allVats},
  //   //   );
  //   // } catch (e) {
  //   //   //
  //   // }
  // }

  Future<void> addNewApInvoice() async {
    try {
      showSnackBar('Adding', 'Please Wait');
      addingNewValue.value = true;
      Map<String, dynamic> newData = {
        'invoice_type': invoiceTypeId.value,
        'vendor': vendorId.value,
        'description': description.text,
        // 'company_id': companyId.value,
        'invoice_number': invoiceNumber.text,
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

      final rawDate2 = invoiceDate.value.text.trim();
      if (rawDate2.isNotEmpty) {
        try {
          newData['invoice_date'] = Timestamp.fromDate(
            format.parseStrict(rawDate2),
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

  Future<void> editPostForApInvoices(String id) async {
    try {
      postingapInvoice.value = true;
      await FirebaseFirestore.instance.collection('ap_invoices').doc(id).update(
        {'status': 'Posted'},
      );
      status.value = 'Posted';
      postingapInvoice.value = false;
      showSnackBar('Done', 'AP Invoice is Posted');
    } catch (e) {
      postingapInvoice.value = false;
      showSnackBar('Alert', 'Something Went Wrong');
    }
  }

  Future<void> editCancelForApInvoices(String id) async {
    try {
      cancellingapInvoice.value = true;
      await FirebaseFirestore.instance.collection('ap_invoices').doc(id).update(
        {'status': 'Cancelled'},
      );
      status.value = 'Cancelled';
      cancellingapInvoice.value = false;
      showSnackBar('Done', 'AP Invoice is Cancelled');
    } catch (e) {
      cancellingapInvoice.value = false;
      showSnackBar('Alert', 'Something Went Wrong');
    }
  }

  void getAllInvoices(String jobId) {
    // try {
    //   loadingInvoices.value = true;
    //   FirebaseFirestore.instance
    //       .collection('ap_invoices')
    //       .doc(jobId)
    //       .collection('invoices')
    //       .orderBy('job_number')
    //       .snapshots()
    //       .listen((QuerySnapshot<Map<String, dynamic>> items) {
    //         allInvoices.assignAll(items.docs);
    //         loadingInvoices.value = false;
    //       });
    // } catch (e) {
    //   loadingInvoices.value = false;
    // }
  }

  void addNewInvoiceItem() {
    final String uniqueId = _uuid.v4();

    allInvoices.add(
      ApInvoicesItem(
        uuid: uniqueId,
        amount: double.tryParse(amount.text) ?? 0,
        jobNumber: jobNumber.text,
        note: invoiceNote.text,
        transactionType: transactionTypeId.value,
        vat: double.tryParse(vat.text) ?? 0,
        apInvoiceId: currentApInvoiceId.value,
        transactionTypeName: transactionType.text,
        isAdded: true,
      ),
    );
    Get.back();
  }

  void editInvoiceItem(String id) {
    int index = allInvoices.indexWhere(
      (item) => (item.id == id || item.uuid == id),
    );
    if (index != -1) {
      final oldItem = allInvoices[index];
      allInvoices[index] = ApInvoicesItem(
        id: oldItem.id,
        uuid: oldItem.uuid,
        amount: double.tryParse(amount.text) ?? 0,
        jobNumber: jobNumber.text,
        note: invoiceNote.text,
        transactionType: transactionTypeId.value,
        vat: double.tryParse(vat.text) ?? 0,
        apInvoiceId: currentApInvoiceId.value,
        transactionTypeName: transactionType.text,
        isModified: true,
      );
      allInvoices.refresh();
    }
    Get.back();
  }

  void deleteInvoiceItem(String id) {
    int index = allInvoices.indexWhere(
      (item) => (item.id == id || item.uuid == id),
    );
    allInvoices[index].isDeleted = true;
    allInvoices.refresh();
    // isJobInvoicesModified.value = true;
    Get.back();
  }

  // Future<void> addNewInvoiceItem(String id) async {
  //   try {
  //     // addingNewinvoiceItemsValue.value = true;

  //     Map<String, dynamic> newData = {
  //       // 'company_id': companyId.value,
  //       'added_date': DateTime.now(),
  //       'transaction_type': transactionTypeId.value,
  //       'amount': amount.text,
  //       'vat': vat.text,
  //       'job_number': jobNumber.text,
  //       'note': invoiceNote.text,
  //       'report_reference': '',
  //     };

  //     await FirebaseFirestore.instance
  //         .collection('ap_invoices')
  //         .doc(id)
  //         .collection('invoices')
  //         .add(newData);

  //     // addingNewinvoiceItemsValue.value = false;
  //     Get.back();

  //     double allamounts = 0.0;
  //     double allVats = 0.0;
  //     // for (var invoice in allInvoices) {
  //     //   allamounts +=
  //     //       double.tryParse(invoice.data()['amount'].toString()) ?? 0.0;
  //     //   allVats += double.tryParse(invoice.data()['vat'].toString()) ?? 0.0;
  //     // }
  //     await FirebaseFirestore.instance.collection('ap_invoices').doc(id).update(
  //       {'total_amount': allamounts, 'total_vat_amount': allVats},
  //     );
  //   } catch (e) {
  //     // addingNewinvoiceItemsValue.value = false;
  //     showSnackBar('Alert', 'Something Went Wrong Please Try Again');
  //   }
  // }

  // Future<void> editInvoiceItem(String id, String itemId) async {
  //   try {
  //     Get.back();
  //     await FirebaseFirestore.instance
  //         .collection('ap_invoices')
  //         .doc(id)
  //         .collection('invoices')
  //         .doc(itemId)
  //         .update({
  //           'transaction_type': transactionTypeId.value,
  //           'amount': amount.text,
  //           'vat': vat.text,
  //           'job_number': jobNumber.text,
  //           'note': invoiceNote.text,
  //           'report_reference': '',
  //         });

  //     double allamounts = 0.0;
  //     double allVats = 0.0;
  //     // for (var invoice in allInvoices) {
  //     //   allamounts +=
  //     //       double.tryParse(invoice.data()['amount'].toString()) ?? 0.0;
  //     //   allVats += double.tryParse(invoice.data()['vat'].toString()) ?? 0.0;
  //     // }
  //     await FirebaseFirestore.instance.collection('ap_invoices').doc(id).update(
  //       {'total_amount': allamounts, 'total_vat_amount': allVats},
  //     );
  //   } catch (e) {
  //     //
  //   }
  // }

  Future<void> getCurrentApInvoicesNumber() async {
    try {
      var apnId = '';
      var updateApInvoices = '';
      var apnDoc = await FirebaseFirestore.instance
          .collection('counters')
          .where('code', isEqualTo: 'APIN')
          // .where('company_id', isEqualTo: companyId.value)
          .get();

      if (apnDoc.docs.isEmpty) {
        // Define constants for the new counter values
        const prefix = 'AI';
        const separator = '-';
        const initialValue = 1;

        var newCounter = await FirebaseFirestore.instance
            .collection('counters')
            .add({
              'code': 'APIN',
              'description': 'AP Invoices Number',
              'prefix': prefix,
              'value': initialValue,
              'length': 0,
              'separator': separator,
              'added_date': DateTime.now().toString(),
              // 'company_id': companyId.value,
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

      await FirebaseFirestore.instance.collection('counters').doc(apnId).update(
        {'value': int.parse(updateApInvoices)},
      );
    } catch (e) {
      // Optionally handle errors here
      // print("Error in getCurrentJobCardCounterNumber: $e");
    }
  }

  void searchEngineForJobCards() {
    query.value = searchForJobCards.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredJobCards.clear();
    } else {
      filteredJobCards.assignAll(
        allJobCards.where((job) {
          return job.jobNumber.toString().toLowerCase().contains(query) ||
              job.carBrandName.toString().toLowerCase().contains(query) ||
              job.carModelName.toString().toLowerCase().contains(query) ||
              job.plateNumber.toString().toLowerCase().contains(query) ||
              job.vehicleIdentificationNumber.toString().toLowerCase().contains(
                query,
              ) ||
              job.customerName.toString().toLowerCase().contains(query);
        }).toList(),
      );
    }
  }

  Future<void> searchEngine() async {
    isScreenLoding.value = true;
    final collection = FirebaseFirestore.instance.collection('ap_invoices');
    // .where('company_id', isEqualTo: companyId.value);
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
      final endOfDay = startOfDay
          .add(const Duration(days: 1))
          .subtract(const Duration(milliseconds: 1));
      fromDate.value.text = textToDate(startOfDay);
      toDate.value.text = textToDate(endOfDay);
      query = query
          .where(
            'transaction_date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
          )
          .where(
            'transaction_date',
            isLessThanOrEqualTo: Timestamp.fromDate(endOfDay),
          );
    }
    // 3) زر "This Month"
    else if (isThisMonthSelected.value) {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final startOfNextMonth = (now.month < 12)
          ? DateTime(now.year, now.month + 1, 1)
          : DateTime(now.year + 1, 1, 1);
      final endOfMonth = startOfNextMonth.subtract(
        const Duration(milliseconds: 1),
      );
      fromDate.value.text = textToDate(startOfMonth);
      toDate.value.text = textToDate(endOfMonth);
      query = query
          .where(
            'transaction_date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth),
          )
          .where(
            'transaction_date',
            isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth),
          );
    }
    // 4) زر "This Year"
    else if (isThisYearSelected.value) {
      final now = DateTime.now();
      final startOfYear = DateTime(now.year, 1, 1);
      final startOfNextYear = DateTime(now.year + 1, 1, 1);
      final endOfYear = startOfNextYear.subtract(
        const Duration(milliseconds: 1),
      );
      fromDate.value.text = textToDate(startOfYear);
      toDate.value.text = textToDate(endOfYear);
      query = query
          .where(
            'transaction_date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfYear),
          )
          .where(
            'transaction_date',
            isLessThanOrEqualTo: Timestamp.fromDate(endOfYear),
          );
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
      query = query.where('vendor', isEqualTo: vendorFilter.value.text);
    }
    if (invoiceTypeFilterId.value.isNotEmpty) {
      query = query.where('invoice_type', isEqualTo: invoiceTypeFilterId.value);
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

  void removeFilters() {
    isAllSelected.value = false;
    isTodaySelected.value = false;
    isThisMonthSelected.value = false;
    isThisYearSelected.value = false;
  }

  void clearAllFilters() {
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
    invoiceTypeFilterId.value = '';
    invoiceTypeFilter.clear();
    vendorFilter.value = TextEditingController();

    fromDate.value.clear();
    toDate.value.clear();
    isScreenLoding.value = false;
    update();
  }
}
