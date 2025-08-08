import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../consts.dart';
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
  Rx<TextEditingController> itemCode = TextEditingController().obs;
  Rx<TextEditingController> itemName = TextEditingController().obs;
  Rx<TextEditingController> quantity = TextEditingController().obs;
  Rx<TextEditingController> addCost = TextEditingController().obs;
  Rx<TextEditingController> orginalPrice = TextEditingController().obs;
  Rx<TextEditingController> addDisc = TextEditingController().obs;
  Rx<TextEditingController> discount = TextEditingController().obs;
  Rx<TextEditingController> localPrice = TextEditingController().obs;
  Rx<TextEditingController> vat = TextEditingController().obs;
  Rx<TextEditingController> total = TextEditingController().obs;
  Rx<TextEditingController> net = TextEditingController().obs;
  RxString branchId = RxString('');
  RxString vendorId = RxString('');
  RxString currencyId = RxString('');
  RxString approvedById = RxString('');
  RxString orderedById = RxString('');
  RxString purchasedById = RxString('');
  ListOfValuesController listOfValuesController = Get.put(
    ListOfValuesController(),
  );
  RxString status = RxString('New'); // change to empty
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

  RxBool canAddItems = RxBool(true); // change to false
  RxBool addingNewItemsValue = RxBool(false);
  RxBool addingNewValue = RxBool(false);
  RxBool receivingDocAdded = RxBool(false);
  RxBool postingReceivingDoc = RxBool(false);

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

  clearItemsValues() {
    itemCode.value.clear();
    itemName.value.clear();
    quantity.value.text = '1';
    addCost.value.text = '0';
    orginalPrice.value.text = '0';
    addDisc.value.text = '0';
    discount.value.text = '0';
    localPrice.value.text = '0';
    vat.value.text = '0';
    total.value.text = '0';
    net.value.text = '0';
  }

  // calculationForItemsValues() {
  //   total.value.text =
  //       ((int.tryParse(quantity.value.text) ?? 1) *
  //                   (int.tryParse(orginalPrice.value.text) ?? 0) -
  //               (int.tryParse(discount.value.text) ?? 0))
  //           .toString();

  //   net.value.text =
  //       ((int.tryParse(vat.value.text) ?? 0) +
  //               (int.tryParse(total.value.text) ?? 0))
  //           .toString();
  // }

  addNewReceivingDoc() async {
    try {
      showSnackBar('Adding', 'Please Wait');
      addingNewValue.value = true;

      Map<String, dynamic> newData = {
        'company_id': companyId.value,
        // 'date'
        'number': '',
        'status': 'New',
        'branch': branchId.value,
        'reference_number': referenceNumber.value.text,
        'vendor': vendorId.value,
        'note': note.value.text,
        'currency': currencyId.value,
        'rate': double.tryParse(rate.value.text) ?? 1,
        'approved_by': approvedById.value,
        'ordered_by': orderedById.value,
        'purchased_by': purchasedById.value,
        'shipping': double.tryParse(shipping.value.text) ?? 0,
        'handling': double.tryParse(handling.value.text) ?? 0,
        'other': double.tryParse(other.value.text) ?? 0,
        'amount': double.tryParse(amount.value.text) ?? 0,
      };

      final rawDate = date.value.text.trim();
      if (rawDate.isNotEmpty) {
        try {
          newData['date'] = Timestamp.fromDate(format.parseStrict(rawDate));
        } catch (e) {
          showSnackBar('Alert', 'Please enter valid date');
        }
      }

      if (receivingDocAdded.isFalse) {
        newData['added_date'] = DateTime.now().toString();
        var newJob = await FirebaseFirestore.instance
            .collection('receiving')
            .add(newData);
        receivingDocAdded.value = true;
        curreentReceivingId.value = newJob.id;
        getAllItems(newJob.id);
        showSnackBar('Done', 'Job Added Successfully');
      } else {
        newData.remove('added_date');
        await FirebaseFirestore.instance
            .collection('receiving')
            .doc(curreentReceivingId.value)
            .update(newData);
        showSnackBar('Done', 'Updated Successfully');
      }
      canAddItems.value = true;
      addingNewValue.value = false;
    } catch (e) {
      canAddItems.value = false;
      addingNewValue.value = false;
      showSnackBar('Alert', 'Something Went Wrong');
    }
  }

  editPostForReceiving(id) async {
    try {
      if (status.value.isEmpty) {
        showSnackBar('Alert', 'Please save doc first');
        return;
      }
      postingReceivingDoc.value = true;
      if (status.value == 'Posted') {
        showSnackBar('Alert', 'Doc is already posted');
        return;
      }
      if (status.value == 'Cancelled') {
        showSnackBar('Alert', 'Doc is cancelled');
        return;
      }

      await getCurrentReceivingCounterNumber();
      await FirebaseFirestore.instance.collection('receiving').doc(id).update({
        'number': receivingNumber.value.text,
        'status': 'Posted',
      });

      status.value = 'Posted';
      postingReceivingDoc.value = false;
      showSnackBar('Done', 'Status is Posted Now');
    } catch (e) {
      postingReceivingDoc.value = false;
    }
  }

  getAllItems(id) {
    try {
      loadingItems.value = true;
      FirebaseFirestore.instance
          .collection('receiving')
          .doc(id)
          .collection('items')
          .snapshots()
          .listen((QuerySnapshot<Map<String, dynamic>> items) {
            allItems.assignAll(items.docs);
            loadingItems.value = false;
          });
    } catch (e) {
      loadingItems.value = false;
    }
  }

  // addNewItem(String id) async {
  //   try {
  //     addingNewItemsValue.value = true;
  //     await FirebaseFirestore.instance
  //         .collection('receiving')
  //         .doc(id)
  //         .collection('items')
  //         .add({
  //       'company_id': companyId.value,
  //       'added_date': DateTime.now().toString(),
  //       'item_code': item
  //     });
  //     addingNewinvoiceItemsValue.value = false;
  //     Get.back();
  //     double allNets = 0.0;
  //     double allVats = 0.0;
  //     double alltotals = 0.0;
  //     for (var invoice in allInvoiceItems) {
  //       allNets += double.tryParse(invoice.data()['net'].toString()) ?? 0.0;
  //       allVats += double.tryParse(invoice.data()['vat'].toString()) ?? 0.0;
  //       alltotals += double.tryParse(invoice.data()['total'].toString()) ?? 0.0;
  //     }
  //     await FirebaseFirestore.instance
  //         .collection('job_cards')
  //         .doc(id)
  //         .update({
  //       'total_net_amount': allNets,
  //       'total_vat_amount': allVats,
  //       'totals_amount': alltotals
  //     });
  //   } catch (e) {
  //     addingNewinvoiceItemsValue.value = false;
  //   }
  // }

  // this function is to generate a new receiving number
  Future<void> getCurrentReceivingCounterNumber() async {
    try {
      var rnId = '';
      var updateReceiveDoc = '';
      var rnDoc = await FirebaseFirestore.instance
          .collection('counters')
          .where('code', isEqualTo: 'RN')
          .where('company_id', isEqualTo: companyId.value)
          .get();

      if (rnDoc.docs.isEmpty) {
        // Define constants for the new counter values
        const prefix = 'R';
        const separator = '-';
        const initialValue = 1;

        var newCounter = await FirebaseFirestore.instance
            .collection('counters')
            .add({
              'code': 'RN',
              'description': 'Receiving Number',
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
        receivingNumber.value.text = '$prefix$separator$initialValue';
        updateReceiveDoc = initialValue.toString();
      } else {
        var firstDoc = rnDoc.docs.first;
        rnId = firstDoc.id;
        var currentValue = firstDoc.data()['value'] ?? 0;
        // Use the existing prefix and separator from the document
        referenceNumber.value.text =
            '${firstDoc.data()['prefix']}${firstDoc.data()['separator']}${(currentValue + 1).toString().padLeft(firstDoc.data()['length'], '0')}';
        updateReceiveDoc = (currentValue + 1).toString();
      }

      await FirebaseFirestore.instance.collection('counters').doc(rnId).update({
        'value': int.parse(updateReceiveDoc),
      });
    } catch (e) {
      // Optionally handle errors here
      // print("Error in getCurrentJobCardCounterNumber: $e");
    }
  }
}
