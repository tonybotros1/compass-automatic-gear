import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datahubai/Models/converters/converter_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Models/issuing/base_model_for_issing_items.dart';
import '../../Models/job cards/job_card_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import 'main_screen_contro.dart';

class IssueItemsController extends GetxController {
  Rx<TextEditingController> date = TextEditingController().obs;
  Rx<TextEditingController> branch = TextEditingController().obs;
  RxString issueType = RxString('');
  // Rx<TextEditingController> issueType = TextEditingController().obs;
  RxString branchId = RxString('');
  RxString issueTypeId = RxString('');
  RxString receivedById = RxString('');

  Rx<TextEditingController> receivedBy = TextEditingController().obs;
  Rx<TextEditingController> issueNumberFilter = TextEditingController().obs;
  Rx<TextEditingController> jobConverterFilter = TextEditingController().obs;
  Rx<TextEditingController> receivedByFilter = TextEditingController().obs;
  Rx<TextEditingController> statusFilter = TextEditingController().obs;
  RxString jobConverterIdFilter = RxString('');
  RxString receivedByIdFilter = RxString('');
  RxString status = RxString(''); // change to empty
  Rx<TextEditingController> fromDate = TextEditingController().obs;
  Rx<TextEditingController> toDate = TextEditingController().obs;
  RxBool isTodaySelected = RxBool(false);
  RxBool isAllSelected = RxBool(false);
  RxBool isThisMonthSelected = RxBool(false);
  RxBool isThisYearSelected = RxBool(false);
  RxBool isYearSelected = RxBool(false);
  RxBool isMonthSelected = RxBool(false);
  RxBool isDaySelected = RxBool(false);
  RxInt numberOfIssuesgDocs = RxInt(0);
  RxDouble allIssuesVATS = RxDouble(0.0);
  RxDouble allIssuesTotals = RxDouble(0.0);
  RxDouble allIssuesNET = RxDouble(0.0);
  RxBool isScreenLoding = RxBool(false);
  final RxList<QueryDocumentSnapshot<Map<String, dynamic>>> allIssuesDocs =
      RxList<QueryDocumentSnapshot<Map<String, dynamic>>>([]);
  final ScrollController scrollControllerFotTable1 = ScrollController();
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  RxBool postingReceivingDoc = RxBool(false);
  RxBool deletingReceivingDoc = RxBool(false);
  RxBool cancellingReceivingDoc = RxBool(false);
  RxMap alljobConverters = RxMap({});
  RxMap allReceivedBy = RxMap({});
  RxMap allBranches = RxMap({});
  RxMap allIssueTypes = RxMap({});
  RxMap allBrands = RxMap({});
  // RxMap allTechs = RxMap({});
  RxMap allCustomers = RxMap({});

  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();
  final FocusNode focusNode5 = FocusNode();
  // RxString companyId = RxString('slowXdVvhLdsVQItgO3n');
  RxBool loadingJobCards = RxBool(false);
  RxBool loadingConverters = RxBool(false);
  final RxList<BaseModelForIssuingItems> allInventeryItems =
      RxList<BaseModelForIssuingItems>([]);
  final RxList<BaseModelForIssuingItems> filteredInventeryItems =
      RxList<BaseModelForIssuingItems>([]);
  final RxList<BaseModelForIssuingItems> selectedInventeryItems =
      RxList<BaseModelForIssuingItems>([]);
  final RxList<BaseModelForIssuingItems> selectedConvertersDetails =
      RxList<BaseModelForIssuingItems>([]);
  final RxList<BaseModelForIssuingItems> allConvertersDetails =
      RxList<BaseModelForIssuingItems>([]);
  final RxList<BaseModelForIssuingItems> filteredConvertersDetails =
      RxList<BaseModelForIssuingItems>([]);
  RxList<JobCardModel> allJobCards = RxList<JobCardModel>([]);
  final RxList<JobCardModel> filteredJobCards = RxList<JobCardModel>([]);
  TextEditingController searchForJobCards = TextEditingController();
  TextEditingController searchForConverters = TextEditingController();
  RxString jobQuery = RxString('');
  RxString converterQuery = RxString('');
  RxString converterDetailsQuery = RxString('');
  RxString inventoryQuery = RxString('');
  TextEditingController jobDetails = TextEditingController();
  final RxList<ConverterModel> allConverters = RxList<ConverterModel>([]);
  final RxList<ConverterModel> filteredConverters = RxList<ConverterModel>([]);
  final RxList<QueryDocumentSnapshot<Map<String, dynamic>>> allConvertersTable =
      RxList([]);
  RxBool loadingItemsTable = RxBool(false);
  TextEditingController searchForInventoryItems = TextEditingController();
  TextEditingController searchForConvertersDetails = TextEditingController();
  String backendUrl = backendTestURI;
  RxString currentIssuingId = RxString('');
  var editingIndex = (-1).obs;

  @override
  void onInit() async {
    //
    super.onInit();
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  Future<Map<String, dynamic>> getBranches() async {
    return await helper.getBrunches();
  }

  Future<Map<String, dynamic>> getIssueTypes() async {
    return await helper.getAllListValues('ISSUE_TYPES');
  }

  Future<Map<String, dynamic>> getEmployeesByDepartment() async {
    return await helper.getAllEmployeesByDepartment('Issueing');
  }

  Future getCurrentIssuingStatus(String id) async {
    return await helper.getIssuingStatus(id);
  }

  Future<void> getAllJobCards() async {
    loadingJobCards.value = true;
    allJobCards.assignAll(await helper.getAllJobCards());
    loadingJobCards.value = false;
  }

  Future<void> getAllConverters() async {
    try {
      loadingConverters.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/converters/get_all_converter');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List converters = decoded['converters'];
        allConverters.assignAll(
          converters.map((conv) => ConverterModel.fromJson(conv)),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllConverters();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      loadingConverters.value = false;
    } catch (e) {
      loadingConverters.value = false;
    }
  }

  Future<void> getAllInventeryItems() async {
    try {
      if (currentIssuingId.isNotEmpty) {
        Map jobStatus = await getCurrentIssuingStatus(currentIssuingId.value);
        String status1 = jobStatus['status'];
        if (status1 != 'New' && status1 != '') {
          showSnackBar('Alert', 'Only new jobs can be edited');
          return;
        }
      }
      loadingItemsTable.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/issue_items/get_items_details_section');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List items = decoded['items_details'];
        print(items);
        allInventeryItems.assignAll(
          items.map(
            (item) => BaseModelForIssuingItems.fromJsonForInventoryItems(item),
          ),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllInventeryItems();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      loadingItemsTable.value = false;
    } catch (e) {
      loadingItemsTable.value = false;
    }
  }

  void addSelectedInventoryItems() {
    // Build a set of existing jobIds for O(1) lookup instead of O(n) search
    final existingInventoryIds = selectedInventeryItems
        .map((r) => r.id)
        .toSet();

    // Filter once for selected receipts
    for (final item in allInventeryItems.where((r) => r.isSelected == true)) {
      if (existingInventoryIds.contains(item.id)) {
        // Find the existing receipt just once
        final idx = selectedInventeryItems.indexWhere((i) => i.id == item.id);

        if (idx != -1) {
          final existing = selectedInventeryItems[idx];
          existing
            ..issueId = currentIssuingId.value
            ..isDeleted = false
            ..isAdded = true
            ..isSelected = true
            ..finalQuantity = 0;
        }

        item
          ..issueId = currentIssuingId.value
          ..isDeleted = false
          ..isAdded = true
          ..isSelected = true
          ..finalQuantity = 0;
      } else {
        item
          ..issueId = currentIssuingId.value
          ..isAdded = true
          ..isSelected = true
          ..isDeleted = false
          ..finalQuantity = 0;

        selectedInventeryItems.add(item);
        existingInventoryIds.add(item.id);
      }
    }

    selectedInventeryItems.refresh();
    allInventeryItems.refresh();
    Get.back();
  }

  void addSelectedConvertersDetails() {
    final existingConvertersIds = selectedConvertersDetails
        .map((r) => r.id)
        .toSet();

    for (final item in allConvertersDetails.where(
      (r) => r.isSelected == true,
    )) {
      if (existingConvertersIds.contains(item.id)) {
        final idx = selectedConvertersDetails.indexWhere(
          (i) => i.id == item.id,
        );

        if (idx != -1) {
          final existing = selectedConvertersDetails[idx];
          existing
            ..issueId = currentIssuingId.value
            ..isDeleted = false
            ..isAdded = true
            ..isSelected = true
            ..finalQuantity = 0;
        }

        item
          ..issueId = currentIssuingId.value
          ..isDeleted = false
          ..isAdded = true
          ..isSelected = true
          ..finalQuantity = 0;
      } else {
        item
          ..issueId = currentIssuingId.value
          ..isAdded = true
          ..isSelected = true
          ..isDeleted = false
          ..finalQuantity = 0;

        selectedConvertersDetails.add(item);
        existingConvertersIds.add(item.id);
      }
    }

    selectedConvertersDetails.refresh();
    allConvertersDetails.refresh();
    Get.back();
  }

  void removeSelectedInventoryItems(String id) {
    if (status.value != 'New' && status.value != '') {
      showSnackBar('Alert', 'Only new issuing allowed');
      return;
    }

    final availIdx = allInventeryItems.indexWhere((r) => r.id == id);
    if (availIdx != -1) {
      final r = allInventeryItems[availIdx];
      r
        ..isSelected = false
        ..isModified = true
        ..isDeleted = true;
    }

    final selIdx = selectedInventeryItems.indexWhere((s) => s.id == id);
    if (selIdx != -1) {
      final r = selectedInventeryItems[selIdx];
      r
        ..isDeleted = true
        ..isModified = true
        ..isSelected = false;
    }

    // 3) Trigger recalculations and reactive updates
    // calculateAmountForSelectedReceipts();
    allInventeryItems.refresh();
    selectedInventeryItems.refresh();
    Get.back();
  }

  
  void removeSelectedConvertersDetails(String id) {
    if (status.value != 'New' && status.value != '') {
      showSnackBar('Alert', 'Only new issuing allowed');
      return;
    }

    final availIdx = allConvertersDetails.indexWhere((r) => r.id == id);
    if (availIdx != -1) {
      final r = allConvertersDetails[availIdx];
      r
        ..isSelected = false
        ..isModified = true
        ..isDeleted = true;
    }

    final selIdx = selectedConvertersDetails.indexWhere((s) => s.id == id);
    if (selIdx != -1) {
      final r = selectedConvertersDetails[selIdx];
      r
        ..isDeleted = true
        ..isModified = true
        ..isSelected = false;
    }
    allConvertersDetails.refresh();
    selectedConvertersDetails.refresh();
    Get.back();
  }

  void finishEditingForInventoryItems(String newValue, int idx) {
    selectedInventeryItems[idx].finalQuantity = int.tryParse(newValue) ?? 0;
    selectedInventeryItems[idx].total =
        selectedInventeryItems[idx].finalQuantity! *
        selectedInventeryItems[idx].lastPrice!;
    // calculateAmountForSelectedPayments();
    selectedInventeryItems[idx].isModified = true;
    // isPaymentInvoicesModified.value = true;
    editingIndex.value = -1;
  }

  void finishEditingForConverters(String newValue, int idx) {
    // // Update the data source
    // selectedInventeryItems[idx].finalQuantity = int.tryParse(newValue) ?? 0;
    // selectedInventeryItems[idx].total =
    //     selectedInventeryItems[idx].finalQuantity! *
    //     selectedInventeryItems[idx].lastPrice!;
    // // Exit edit mode
    // // calculateAmountForSelectedPayments();
    // selectedInventeryItems[idx].isModified = true;
    // // isPaymentInvoicesModified.value = true;
    // editingIndex.value = -1;
  }

  void startEditing(int idx) {
    editingIndex.value = idx;
  }

  // ======================================================================================================================

  void selectedJobOrConverter(String selected) {
    if (selected != '') {
      if (selected == 'Job Card') {
        getAllJobCards();
      } else {
        getAllConverters();
      }
    }
  }

  void searchEngineForJobCards() {
    jobQuery.value = searchForJobCards.value.text.toLowerCase();
    if (jobQuery.value.isEmpty) {
      filteredJobCards.clear();
    } else {
      filteredJobCards.assignAll(
        allJobCards.where((job) {
          return job.jobNumber.toString().toLowerCase().contains(jobQuery) ||
              job.carBrandName.toString().toLowerCase().contains(jobQuery) ||
              job.carModelName.toString().toLowerCase().contains(jobQuery) ||
              job.customerName.toString().toLowerCase().contains(jobQuery) ||
              job.plateNumber.toString().toLowerCase().contains(jobQuery) ||
              job.vehicleIdentificationNumber.toString().toLowerCase().contains(
                jobQuery,
              );
        }).toList(),
      );
    }
  }

  void searchEngineForConverters() {
    converterQuery.value = searchForConverters.value.text.toLowerCase();
    if (converterQuery.value.isEmpty) {
      filteredConverters.clear();
    } else {
      filteredConverters.assignAll(
        allConverters.where((converter) {
          return converter.converterNumber.toString().toLowerCase().contains(
                converterQuery,
              ) ||
              converter.name.toString().toLowerCase().contains(
                converterQuery,
              ) ||
              converter.description.toString().toLowerCase().contains(
                converterQuery,
              );
        }).toList(),
      );
    }
  }

  void searchEngineForInverntoryItems() {
    inventoryQuery.value = searchForInventoryItems.value.text.toLowerCase();
    if (inventoryQuery.value.isEmpty) {
      filteredInventeryItems.clear();
    } else {
      filteredInventeryItems.assignAll(
        allInventeryItems.where((item) {
          return item.name.toString().toLowerCase().contains(inventoryQuery) ||
              item.code.toString().toLowerCase().contains(inventoryQuery);
        }).toList(),
      );
    }
  }

  void searchEngineForConvertersDetails() {
    converterDetailsQuery.value = searchForConvertersDetails.value.text
        .toLowerCase();
    if (converterDetailsQuery.value.isEmpty) {
      filteredConvertersDetails.clear();
    } else {
      filteredConvertersDetails.assignAll(
        allConvertersDetails.where((item) {
          return item.name.toString().toLowerCase().contains(inventoryQuery) ||
              item.number.toString().toLowerCase().contains(inventoryQuery);
        }).toList(),
      );
    }
  }

  // Future<void> getAllInventeryItems() async {
  //   try {
  //     loadingItemsTable.value = true;
  //     allInventeryItems.clear();
  //     var items = await FirebaseFirestore.instance
  //         .collection('inventery_items')
  //         // .where('company_id', isEqualTo: companyId.value)
  //         .get();
  //     for (var item in items.docs) {
  //       allInventeryItems.add(item);
  //     }
  //     loadingItemsTable.value = false;
  //   } catch (e) {
  //     loadingItemsTable.value = false;
  //   }
  // }

  // Future<void> getItemDetails(String itemId) async {
  //   try {
  //     final futures = [
  //       FirebaseFirestore.instance
  //           .collectionGroup('items')
  //           .where('collection_parent', isEqualTo: 'receiving')
  //           // .where('company_id', isEqualTo: companyId.value)
  //           .where('code', isEqualTo: itemId)
  //           .get(),
  //       FirebaseFirestore.instance
  //           .collectionGroup('items')
  //           .where('collection_parent', isEqualTo: 'issue_items')
  //           // .where('company_id', isEqualTo: companyId.value)
  //           .where('code', isEqualTo: itemId)
  //           .get(),
  //     ];

  //     final results = await Future.wait(futures);

  //     int receivingQty = 0;
  //     double originalPrice = 0.0;
  //     double localPrice = 0.0;
  //     double discount = 0.0;
  //     int quantity = 1;
  //     double total = 0.0;
  //     double vat = 0.0;
  //     double totalForAllItems = 0.0;
  //     DateTime? lastDate;
  //     DocumentSnapshot<Map<String, dynamic>>? lastDoc;

  //     for (var doc in results[0].docs) {
  //       final data = doc.data();
  //       receivingQty += (data['quantity'] ?? 0) as int;

  //       final dateStr = data['added_date'];
  //       if (dateStr != null) {
  //         final currentDate = DateTime.parse(dateStr);
  //         if (lastDate == null || currentDate.isAfter(lastDate)) {
  //           lastDate = currentDate;
  //           originalPrice = (data['orginal_price'] ?? 0).toDouble();
  //           discount = (data['discount'] ?? 0).toDouble();
  //           vat = (data['vat'] ?? 0).toDouble();
  //           quantity = (data['quantity'] ?? 0).toInt();
  //           lastDoc = doc;
  //         }
  //       }
  //     }

  //     int issueQty = 0;
  //     for (var doc in results[1].docs) {
  //       issueQty += (doc['quantity'] ?? 0) as int;
  //     }

  //     final balance = receivingQty - issueQty;

  //     // 🔹 جلب معلومات من parent receiving doc
  //     if (lastDoc != null) {
  //       final parentDocRef = lastDoc.reference.parent.parent;
  //       if (parentDocRef != null) {
  //         final parentSnapshot = await parentDocRef.get();
  //         final itemsSnapshot = await parentDocRef.collection('items').get();
  //         for (var item in itemsSnapshot.docs) {
  //           final double orgPrice = item['orginal_price'];
  //           final double discountVal = item['discount'];
  //           final int qty = item['quantity'];
  //           totalForAllItems += (orgPrice - discountVal) * qty;
  //         }
  //         Map data = parentSnapshot.data() as Map<String, dynamic>;
  //         ReceivingItemsModel model = ReceivingItemsModel(
  //           amount: data['amount'],
  //           handling: data['handling'],
  //           other: data['other'],
  //           shipping: data['shipping'],
  //           quantity: quantity,
  //           orginalPrice: originalPrice,
  //           discount: discount,
  //           vat: vat,
  //           rate: data['rate'],
  //           totalForAllItems: totalForAllItems,
  //         );
  //         localPrice = model.localPrice;
  //         total = model.total;
  //       }
  //     }

  //     // print("quantity: $balance");
  //     // print("Last Price: $localPrice");
  //     // print("total: $total");
  //     // print("Last Date: $lastDate");
  //   } catch (e) {
  //     // print("Error: $e");
  //   }
  // }
}
