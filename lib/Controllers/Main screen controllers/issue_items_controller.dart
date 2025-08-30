import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/receiving_items_model_for_table.dart';
import '../../consts.dart';
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
  RxString status = RxString('New'); // change to empty
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
  RxMap allTechs = RxMap({});
  RxMap allCustomers = RxMap({});

  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();
  final FocusNode focusNode5 = FocusNode();
  RxString companyId = RxString('');
  RxBool loadingJobCards = RxBool(false);
  final RxList<DocumentSnapshot> allInventeryItems = RxList<DocumentSnapshot>(
    [],
  );
  final RxList<DocumentSnapshot> filteredInventeryItems =
      RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> allJobCards = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredJobCards = RxList<DocumentSnapshot>(
    [],
  );
  TextEditingController searchForJobCards = TextEditingController();
  RxString query = RxString('');
  TextEditingController jobDetails = TextEditingController();
  final RxList<QueryDocumentSnapshot<Map<String, dynamic>>> allItems =
      RxList<QueryDocumentSnapshot<Map<String, dynamic>>>([]);
  final RxList<QueryDocumentSnapshot<Map<String, dynamic>>> allConverters =
      RxList<QueryDocumentSnapshot<Map<String, dynamic>>>([]);
  RxBool loadingItems = RxBool(false);
  RxBool loadingItemsTable = RxBool(false);
  RxBool loadingConverters = RxBool(false);
  RxBool canAddItemsAndConverter = RxBool(true); // change to false
  TextEditingController searchForItems = TextEditingController();

  @override
  void onInit() async {
    await getCompanyId();
    getAllBranches();
    getIssueTypes();
    getCarBrands();
    getAllEntities();
    getAllTechs();
    super.onInit();
  }

  getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  getCompanyId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId.value = prefs.getString('companyId')!;
  }

  getAllBranches() {
    try {
      FirebaseFirestore.instance
          .collection('branches')
          .where('company_id', isEqualTo: companyId.value)
          .orderBy('name')
          .snapshots()
          .listen((branches) {
            allBranches.value = {
              for (var doc in branches.docs) doc.id: doc.data(),
            };
          });
    } catch (e) {
      //
    }
  }

  getIssueTypes() async {
    var typeDoc = await FirebaseFirestore.instance
        .collection('all_lists')
        .where('code', isEqualTo: 'ISSUE_TYPES')
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
          allIssueTypes.value = {
            for (var doc in colors.docs) doc.id: doc.data(),
          };
        });
  }

  selectedJobOrConverter(String selected) {
    if (selected != '') {
      if (selected == 'Job Card') {
        getAllJobCards();
      }
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

  searchEngineForJobCards() {
    query.value = searchForJobCards.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredJobCards.clear();
    } else {
      filteredJobCards.assignAll(
        allJobCards.where((job) {
          return job['job_number'].toString().toLowerCase().contains(query) ||
              getdataName(
                job['car_brand'],
                allBrands,
              ).toString().toLowerCase().contains(query) ||
              job['plate_number'].toString().toLowerCase().contains(query) ||
              job['vehicle_identification_number']
                  .toString()
                  .toLowerCase()
                  .contains(query) ||
              getdataName(
                job['customer'],
                allCustomers,
                title: 'entity_name',
              ).toString().toLowerCase().contains(query);
        }).toList(),
      );
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

  getAllTechs() {
    try {
      FirebaseFirestore.instance
          .collection('all_technicians')
          .where('company_id', isEqualTo: companyId.value)
          .orderBy('name')
          .snapshots()
          .listen((teck) {
            allTechs.value = {for (var doc in teck.docs) doc.id: doc.data()};
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
            Map<String, dynamic> customersMap = {};

            for (var doc in entitiesSnapshot.docs) {
              var data = doc.data();

              // Safety check: entity_code must be a list
              if (data['entity_code'] is List) {
                List entityCodes = data['entity_code'];

                // If 'Customer' is in the list
                if (entityCodes.contains('Customer')) {
                  customersMap[doc.id] = data;
                }
              }
            }

            // Assign to your observable maps
            allCustomers.value = customersMap;
          });
    } catch (e) {
      // print('Error fetching entities: $e');
    }
  }

  getAllInventeryItems() async {
    try {
      loadingItemsTable.value = true;
      allInventeryItems.clear();
      var items = await FirebaseFirestore.instance
          .collection('inventery_items')
          .where('company_id', isEqualTo: companyId.value)
          .get();
      for (var item in items.docs) {
        allInventeryItems.add(item);
      }
      loadingItemsTable.value = false;
    } catch (e) {
      loadingItemsTable.value = false;
    }
  }

  Future<void> getItemDetails(String itemId) async {
    try {
      final futures = [
        FirebaseFirestore.instance
            .collectionGroup('items')
            .where('collection_parent', isEqualTo: 'receiving')
            .where('company_id', isEqualTo: companyId.value)
            .where('code', isEqualTo: itemId)
            .get(),
        FirebaseFirestore.instance
            .collectionGroup('items')
            .where('collection_parent', isEqualTo: 'issue_items')
            .where('company_id', isEqualTo: companyId.value)
            .where('code', isEqualTo: itemId)
            .get(),
      ];

      final results = await Future.wait(futures);

      int receivingQty = 0;
      double originalPrice = 0.0;
      double localPrice = 0.0;
      double discount = 0.0;
      int quantity = 1;
      double total = 0.0;
      double vat = 0.0;
      double totalForAllItems = 0.0;
      DateTime? lastDate;
      DocumentSnapshot<Map<String, dynamic>>? lastDoc;

      for (var doc in results[0].docs) {
        final data = doc.data();
        receivingQty += (data['quantity'] ?? 0) as int;

        final dateStr = data['added_date'];
        if (dateStr != null) {
          final currentDate = DateTime.parse(dateStr);
          if (lastDate == null || currentDate.isAfter(lastDate)) {
            lastDate = currentDate;
            originalPrice = (data['orginal_price'] ?? 0).toDouble();
            discount = (data['discount'] ?? 0).toDouble();
            vat = (data['vat'] ?? 0).toDouble();
            quantity = (data['quantity'] ?? 0).toInt();
            lastDoc = doc;
          }
        }
      }

      int issueQty = 0;
      for (var doc in results[1].docs) {
        issueQty += (doc['quantity'] ?? 0) as int;
      }

      final balance = receivingQty - issueQty;

      // 🔹 جلب معلومات من parent receiving doc
      if (lastDoc != null) {
        final parentDocRef = lastDoc.reference.parent.parent;
        if (parentDocRef != null) {
          final parentSnapshot = await parentDocRef.get();
          final itemsSnapshot = await parentDocRef.collection('items').get();
          for (var item in itemsSnapshot.docs) {
            final double orgPrice = item['orginal_price'];
            final double discountVal = item['discount'];
            final int qty = item['quantity'];
            totalForAllItems += (orgPrice - discountVal) * qty;
          }
          Map data = parentSnapshot.data() as Map<String, dynamic>;
          ReceivingItemsModel model = ReceivingItemsModel(
            amount: data['amount'],
            handling: data['handling'],
            other: data['other'],
            shipping: data['shipping'],
            quantity: quantity,
            orginalPrice: originalPrice,
            discount: discount,
            vat: vat,
            rate: data['rate'],
            totalForAllItems: totalForAllItems,
          );
          localPrice = model.localPrice;
          total = model.total;
        }
      }

      print("quantity: $balance");
      print("Last Price: $localPrice");
      print("total: $total");
      print("Last Date: $lastDate");
    } catch (e) {
      // print("Error: $e");
    }
  }
}
