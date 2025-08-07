import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'list_of_values_controller.dart';
import 'main_screen_contro.dart';

class ReceivingController extends GetxController {
  Rx<TextEditingController> receivingNumber = TextEditingController().obs;
  Rx<TextEditingController> referenceNumber = TextEditingController().obs;
  Rx<TextEditingController> date = TextEditingController().obs;
  Rx<TextEditingController> branch = TextEditingController().obs;
  Rx<TextEditingController> vendor = TextEditingController().obs;
  Rx<TextEditingController> note = TextEditingController().obs;
  Rx<TextEditingController> currency = TextEditingController().obs;
  Rx<TextEditingController> rate = TextEditingController().obs;
  Rx<TextEditingController> approvedBy = TextEditingController().obs;
  Rx<TextEditingController> orderedBy = TextEditingController().obs;
  Rx<TextEditingController> purchasedBy = TextEditingController().obs;
  Rx<TextEditingController> shipping = TextEditingController().obs;
  Rx<TextEditingController> handling = TextEditingController().obs;
  Rx<TextEditingController> other = TextEditingController().obs;
  Rx<TextEditingController> amount = TextEditingController().obs;
  RxString branchId = RxString('');
  RxString vendorId = RxString('');
  RxString currencyId = RxString('');
  RxString approvedById = RxString('');
  RxString orderedById = RxString('');
  RxString purchasedById = RxString('');
  ListOfValuesController listOfValuesController = Get.put(
    ListOfValuesController(),
  );
  RxString status = RxString('');
  Rx<TextEditingController> receivingNumberFilter = TextEditingController().obs;
  Rx<TextEditingController> referenceNumberFilter = TextEditingController().obs;
  Rx<TextEditingController> vendorNameIdFilterName =
      TextEditingController().obs;
  Rx<TextEditingController> statusFilter = TextEditingController().obs;
  RxString vendorNameIdFilter = RxString('');
  RxMap allVendors = RxMap({});
  Rx<TextEditingController> fromDate = TextEditingController().obs;
  Rx<TextEditingController> toDate = TextEditingController().obs;
  final ScrollController scrollControllerFotTable1 = ScrollController();
  RxBool isTodaySelected = RxBool(false);
  RxBool isAllSelected = RxBool(false);
  RxBool isThisMonthSelected = RxBool(false);
  RxBool isThisYearSelected = RxBool(false);
  RxBool isYearSelected = RxBool(false);
  RxBool isMonthSelected = RxBool(false);
  RxBool isDaySelected = RxBool(false);
  RxInt numberOfReceivingDocs = RxInt(0);
  RxDouble allReceivingVATS = RxDouble(0.0);
  RxDouble allReceivingTotals = RxDouble(0.0);
  RxDouble allReceivingNET = RxDouble(0.0);
  RxBool isScreenLoding = RxBool(false);
  final RxList<QueryDocumentSnapshot<Map<String, dynamic>>> allReceivingDocs =
      RxList<QueryDocumentSnapshot<Map<String, dynamic>>>([]);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxString curreentReceivingId = RxString('');
  RxMap allBranches = RxMap({});
  RxMap allCountries = RxMap({});
  RxMap allCurrencies = RxMap({});
  RxMap allApprovedBy = RxMap({});
  RxMap allOrderedBy = RxMap({});
  RxMap allPurchasedBy = RxMap({});

  RxString companyId = RxString('');
  RxString approvedByListId = RxString('');
  RxString orderedByListId = RxString('');
  RxString purchasedByListId = RxString('');
  RxString approvedByMasterId = RxString('');
  RxString orderedByMasterId = RxString('');
  RxString purchasedByMasterId = RxString('');

  RxBool loadingItems = RxBool(false);
final RxList<QueryDocumentSnapshot<Map<String, dynamic>>> allItems =
      RxList<QueryDocumentSnapshot<Map<String, dynamic>>>([]);
  @override
  void onInit() async {
    await getCompanyId();
    getAllBranches();
    getAllVendors();
    getCountries();
    getCurrencies();
    getApprovedBy();
    getOrderedBy();
    getPurchasedBy();
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

  getAllCurrencies() {
    try {
      FirebaseFirestore.instance
          .collection('currencies')
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

  getAllVendors() {
    try {
      FirebaseFirestore.instance
          .collection('entity_informations')
          .where('company_id', isEqualTo: companyId.value)
          .where('entity_code', arrayContains: 'Vendor')
          .orderBy('entity_name')
          .snapshots()
          .listen((customers) {
            allVendors.value = {
              for (var doc in customers.docs) doc.id: doc.data(),
            };
          });
    } catch (e) {
      //
    }
  }

  getCountries() {
    try {
      FirebaseFirestore.instance
          .collection('all_countries')
          .orderBy('name')
          .snapshots()
          .listen((countries) {
            allCountries.value = {
              for (var doc in countries.docs) doc.id: doc.data(),
            };
          });
    } catch (e) {
      //
    }
  }

  getCurrencies() {
    FirebaseFirestore.instance
        .collection('currencies')
        .where('company_id', isEqualTo: companyId.value)
        .snapshots()
        .listen((branches) {
          allCurrencies.value = {
            for (var doc in branches.docs) doc.id: doc.data(),
          };
        });
  }

  getApprovedBy() async {
    var typeDoc = await FirebaseFirestore.instance
        .collection('all_lists')
        .where('code', isEqualTo: 'APPROVED_BY')
        .get();

    var typeId = typeDoc.docs.first.id;
    approvedByListId.value = typeId;
    approvedByMasterId.value = typeDoc.docs.first.data()['mastered_by'];
    FirebaseFirestore.instance
        .collection('all_lists')
        .doc(typeId)
        .collection('values')
        .where('available', isEqualTo: true)
        .orderBy('name')
        .snapshots()
        .listen((colors) {
          allApprovedBy.value = {
            for (var doc in colors.docs) doc.id: doc.data(),
          };
        });
  }

  getOrderedBy() async {
    var typeDoc = await FirebaseFirestore.instance
        .collection('all_lists')
        .where('code', isEqualTo: 'ORDERED_BY')
        .get();

    var typeId = typeDoc.docs.first.id;
    orderedByListId.value = typeId;
    orderedByMasterId.value = typeDoc.docs.first.data()['mastered_by'];
    FirebaseFirestore.instance
        .collection('all_lists')
        .doc(typeId)
        .collection('values')
        .where('available', isEqualTo: true)
        .orderBy('name')
        .snapshots()
        .listen((colors) {
          allOrderedBy.value = {
            for (var doc in colors.docs) doc.id: doc.data(),
          };
        });
  }

  getPurchasedBy() async {
    var typeDoc = await FirebaseFirestore.instance
        .collection('all_lists')
        .where('code', isEqualTo: 'PURCHASED_BY')
        .get();

    var typeId = typeDoc.docs.first.id;
    purchasedByListId.value = typeId;
    purchasedByMasterId.value = typeDoc.docs.first.data()['mastered_by'];
    FirebaseFirestore.instance
        .collection('all_lists')
        .doc(typeId)
        .collection('values')
        .where('available', isEqualTo: true)
        .orderBy('name')
        .snapshots()
        .listen((colors) {
          allPurchasedBy.value = {
            for (var doc in colors.docs) doc.id: doc.data(),
          };
        });
  }
}
