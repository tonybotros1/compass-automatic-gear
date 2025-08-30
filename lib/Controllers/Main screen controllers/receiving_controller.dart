import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/receiving_items_model.dart';
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
  RxString status = RxString(''); // change to empty
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
  // final RxList<QueryDocumentSnapshot<Map<String, dynamic>>> allItems =
  //     RxList<QueryDocumentSnapshot<Map<String, dynamic>>>([]);
  RxList<ItemModel> allItems = RxList<ItemModel>();

  RxBool canAddItems = RxBool(false); // change to false
  RxBool addingNewItemsValue = RxBool(false);
  RxBool addingNewValue = RxBool(false);
  RxBool receivingDocAdded = RxBool(false);
  RxBool postingReceivingDoc = RxBool(false);
  RxBool deletingReceivingDoc = RxBool(false);
  RxBool cancellingReceivingDoc = RxBool(false);
  TextEditingController searchForInventeryItems = TextEditingController();
  RxBool loadingInventeryItems = RxBool(false);
  final RxList<DocumentSnapshot> allInventeryItems = RxList<DocumentSnapshot>(
    [],
  );
  final RxList<DocumentSnapshot> filteredInventeryItems =
      RxList<DocumentSnapshot>([]);
  RxString selectedInventeryItemID = RxString('');
  RxString query = RxString('');
  RxDouble itemsTotal = RxDouble(0.0);
  RxDouble finalItemsTotal = RxDouble(0.0);
  RxDouble finalItemsVAT = RxDouble(0.0);
  RxDouble finalItemsNet = RxDouble(0.0);

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

  clearValues() {
    canAddItems.value = false;
    receivingNumber.value.clear();
    date.value.text = textToDate(DateTime.now());
    branch.value.clear();
    branchId.value = '';
    referenceNumber.value.clear();
    vendor.value.clear();
    vendorId.value = '';
    note.value.clear();
    curreentReceivingId.value = '';
    currency.value.clear();
    currencyId.value = '';
    rate.value.clear();
    approvedBy.value.clear();
    orderedBy.value.clear();
    purchasedBy.value.clear();
    approvedById.value = '';
    orderedById.value = '';
    purchasedById.value = '';
    shipping.value.clear();
    handling.value.clear();
    other.value.clear();
    amount.value.clear();
    allItems.clear();
    status.value = '';
    receivingDocAdded.value = false;
  }

  loadValues(Map<String, dynamic> data, String id) {
    getAllItems(id);

    canAddItems.value = true;
    status.value = data['status'];
    receivingNumber.value.text = data['number'];
    date.value.text = textToDate(data['date']);
    branch.value.text = getdataName(data['branch'], allBranches);
    branchId.value = data['branch'];
    referenceNumber.value.text = data['reference_number'];
    vendor.value.text = getdataName(
      data['vendor'],
      allVendors,
      title: 'entity_name',
    );
    vendorId.value = data['vendor'];
    note.value.text = data['note'];
    currencyId.value = data['currency'];
    currency.value.text = data['currency'] != ''
        ? getdataName(
            getdataName(data['currency'], allCurrencies, title: 'country_id'),
            allCountries,
            title: 'currency_code',
          )
        : '';
    rate.value.text = data['rate'].toString();
    approvedBy.value.text = getdataName(data['approved_by'], allApprovedBy);
    orderedBy.value.text = getdataName(data['ordered_by'], allOrderedBy);
    purchasedBy.value.text = getdataName(data['purchased_by'], allPurchasedBy);
    approvedById.value = data['approved_by'];
    orderedById.value = data['ordered_by'];
    purchasedById.value = data['purchased_by'];
    shipping.value.text = data['shipping'].toString();
    handling.value.text = data['handling'].toString();
    other.value.text = data['other'].toString();
    amount.value.text = data['amount'].toString();
  }

  getAllInventeryItems() async {
    try {
      loadingInventeryItems.value = true;
      allInventeryItems.clear();
      var items = await FirebaseFirestore.instance
          .collection('inventery_items')
          .where('company_id', isEqualTo: companyId.value)
          .get();
      for (var item in items.docs) {
        allInventeryItems.add(item);
      }
      loadingInventeryItems.value = false;
    } catch (e) {
      loadingInventeryItems.value = false;
    }
  }

  Future<String> getInventeryItemsCode({required String id}) async {
    try {
      var data = await FirebaseFirestore.instance
          .collection('inventery_items')
          .doc(id)
          .get();
      return data.data()?['code'] ?? '';
    } catch (e) {
      return '';
    }
  }

  Future<String> getInventeryItemsName({required String id}) async {
    try {
      var data = await FirebaseFirestore.instance
          .collection('inventery_items')
          .doc(id)
          .get();
      return data.data()?['name'] ?? '';
    } catch (e) {
      return '';
    }
  }

  // this function is to filter the search results for inventery items
  void filterInventeryItems() {
    query.value = searchForInventeryItems.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredInventeryItems.clear();
    } else {
      filteredInventeryItems.assignAll(
        allInventeryItems.where((item) {
          return item['code'].toString().toLowerCase().contains(query) ||
              item['name'].toString().toLowerCase().contains(query) ||
              item['min_quantity'].toString().toLowerCase().contains(query);
        }).toList(),
      );
    }
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
    selectedInventeryItemID.value = '';
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

  Future<void> addNewReceivingDoc() async {
    try {
      // Prevent editing if status is not allowed
      if (status.value != 'New' && status.value.isNotEmpty) {
        showSnackBar('Alert', 'Only new docs can be edited');
        return;
      }

      showSnackBar('Adding', 'Please Wait');
      addingNewValue.value = true;

      // Base data
      final Map<String, dynamic> newData = {
        'company_id': companyId.value,
        'branch': branchId.value,
        'reference_number': referenceNumber.value.text.trim(),
        'vendor': vendorId.value,
        'note': note.value.text.trim(),
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

      // Handle date parsing safely
      final rawDate = date.value.text.trim();
      if (rawDate.isNotEmpty) {
        try {
          newData['date'] = Timestamp.fromDate(format.parseStrict(rawDate));
        } catch (e) {
          showSnackBar('Alert', 'Please enter a valid date');
          addingNewValue.value = false;
          return; // Stop execution if date is invalid
        }
      }

      // If creating a new doc
      if (receivingDocAdded.isFalse) {
        if (receivingNumber.value.text.isEmpty) {
          await getCurrentReceivingCounterNumber();
        }

        newData['number'] = receivingNumber.value.text;
        newData['status'] = 'New';
        newData['added_date'] = DateTime.now().toIso8601String();

        final newDocRef = await FirebaseFirestore.instance
            .collection('receiving')
            .add(newData);

        receivingDocAdded.value = true;
        curreentReceivingId.value = newDocRef.id;

        await getAllItems(newDocRef.id);

        showSnackBar('Done', 'Doc. Added Successfully');
        status.value = 'New';
      }
      // If updating existing doc
      else {
        newData.remove('status'); // Don't overwrite status
        await FirebaseFirestore.instance
            .collection('receiving')
            .doc(curreentReceivingId.value)
            .update(newData);

        showSnackBar('Done', 'Updated Successfully');
      }

      canAddItems.value = true;
    } catch (e) {
      canAddItems.value = false;
      showSnackBar('Alert', 'Something went wrong: $e');
    } finally {
      addingNewValue.value = false; // Ensure loading flag is reset
    }
  }

  editReceivingDoc(id) async {
    try {
      if (status.value != 'New' && status.value != '') {
        showSnackBar('Alert', 'Only new docs can be edited');
        return;
      }
      showSnackBar('Editing', 'Please Wait');
      addingNewValue.value = true;

      Map<String, dynamic> newData = {
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

      await FirebaseFirestore.instance
          .collection('receiving')
          .doc(id)
          .update(newData);
      showSnackBar('Done', 'Updated Successfully');
      addingNewValue.value = false;
    } catch (e) {
      addingNewValue.value = false;
      showSnackBar('Alert', 'Something Went Wrong');
    }
  }

  deleteReceivingDoc(id, context) {
    try {
      if (status.value == 'New' || status.value == '') {
        deletingReceivingDoc.value = true;

        alertDialog(
          context: context,
          content: "This will be deleted permanently",
          onPressed: () {
            FirebaseFirestore.instance.collection('receiving').doc(id).delete();
            Get.close(2);
            deletingReceivingDoc.value = false;
          },
        );
      } else {
        showSnackBar('Can Not Delete', 'Only New Docs Can be Deleted');
      }
    } catch (e) {
      deletingReceivingDoc.value = false;
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

      await FirebaseFirestore.instance.collection('receiving').doc(id).update({
        // 'number': receivingNumber.value.text,
        'status': 'Posted',
      });

      status.value = 'Posted';
      postingReceivingDoc.value = false;
      showSnackBar('Done', 'Status is Posted Now');
    } catch (e) {
      postingReceivingDoc.value = false;
    }
  }

  editCancelForReceiving(id) async {
    try {
      if (status.value.isEmpty) {
        showSnackBar('Alert', 'Please save doc first');
        return;
      }

      if (status.value == 'Cancelled') {
        showSnackBar('Alert', 'Doc is already cancelled');
        return;
      }
      cancellingReceivingDoc.value = true;

      await FirebaseFirestore.instance.collection('receiving').doc(id).update({
        // 'number': receivingNumber.value.text,
        'status': 'Cancelled',
      });

      status.value = 'Cancelled';
      cancellingReceivingDoc.value = false;
      showSnackBar('Done', 'Status is Cancelled Now');
    } catch (e) {
      cancellingReceivingDoc.value = false;
    }
  }

  // getAllItems(id) {
  //   try {
  //     loadingItems.value = true;
  //     FirebaseFirestore.instance
  //         .collection('receiving')
  //         .doc(id)
  //         .collection('items')
  //         .snapshots()
  //         .listen((QuerySnapshot<Map<String, dynamic>> items) {
  //           allItems.assignAll(
  //             items.docs.cast<QueryDocumentSnapshot<Map<String, dynamic>>>(),
  //           );

  //           loadingItems.value = false;
  //           calculateAllItemsTotal(allItems);
  //         });
  //   } catch (e) {
  //     loadingItems.value = false;
  //   }
  // }

  getAllItems(id) {
    try {
      loadingItems.value = true;
      FirebaseFirestore.instance
          .collection('receiving')
          .doc(id)
          .collection('items')
          .snapshots()
          .listen((QuerySnapshot<Map<String, dynamic>> items) {
            // Map the documents to your ItemModel before assigning
            final mappedItems = items.docs
                .map((doc) => ItemModel.fromFirestore(doc))
                .toList();
            allItems.assignAll(mappedItems);
            calculateAllItemsTotal(allItems);
            loadingItems.value = false;
          });
    } catch (e) {
      loadingItems.value = false;
      // Consider logging the error for debugging.
    }
  }

  calculateAllItemsTotal(List<ItemModel> items) {
    // reset
    itemsTotal.value = 0.0;
    finalItemsTotal.value = 0.0;
    finalItemsVAT.value = 0.0;
    finalItemsNet.value = 0.0;

    double toDouble(dynamic v) => v is double
        ? v
        : v is int
        ? v.toDouble()
        : double.tryParse(v?.toString() ?? '') ?? 0.0;
    int toInt(dynamic v) => v is int
        ? v
        : v is double
        ? v.toInt()
        : int.tryParse(v?.toString() ?? '') ?? 0;

    for (var item in items) {
      final double orgPrice = toDouble(item.originalPrice);
      final double discountVal = toDouble(item.discount);
      final int qty = toInt(item.quantity);
      itemsTotal.value += (orgPrice - discountVal) * qty;
    }

    final double amountVal = double.tryParse(amount.value.text) ?? 0.0;
    final double handlingVal = double.tryParse(handling.value.text) ?? 0.0;
    final double otherVal = double.tryParse(other.value.text) ?? 0.0;
    final double shippingVal = double.tryParse(shipping.value.text) ?? 0.0;
    final double rateVal = double.tryParse(rate.value.text) ?? 1.0;

    final double totalForAll = itemsTotal.value;
    final double extraCosts = handlingVal + shippingVal + otherVal;

    for (var item in items) {
      final double orgPrice = toDouble(item.originalPrice);
      final double discountVal = toDouble(item.discount);
      final int qty = toInt(item.quantity);
      final double vatRaw = toDouble(item.vat);

      final double unitBase = orgPrice - discountVal;

      final double addCostPerUnit = totalForAll > 0
          ? (unitBase / totalForAll) * extraCosts
          : 0.0;

      final double addDiscPerUnit = totalForAll > 0
          ? (unitBase / totalForAll) * amountVal
          : 0.0;

      final double localPricePerUnit =
          (unitBase + addCostPerUnit - addDiscPerUnit) * rateVal;

      final double lineTotal = localPricePerUnit * qty;

      // final double vatAmount = lineTotal * (vatRaw / 100.0);

      finalItemsTotal.value += lineTotal;
      finalItemsVAT.value += vatRaw;
      finalItemsNet.value += lineTotal + vatRaw;
    }
    return {
      'total': finalItemsTotal.value,
      'vat': finalItemsVAT.value,
      'net': finalItemsNet.value,
    };
  }

  Future<Map<String, double>> calculateTotalsForTable(String docId) async {
    try {
      var data = await FirebaseFirestore.instance
          .collection('receiving')
          .doc(docId)
          .collection('items')
          .get();
      // Map the documents to your ItemModel before assigning
      final mappedItems = data.docs
          .map((doc) => ItemModel.fromFirestore(doc))
          .toList();
      Map<String, double> calulated = calculateAllItemsTotal(mappedItems);
      return calulated;
    } catch (e) {
      return {};
    }
  }

  addNewItem(String id) async {
    try {
      addingNewItemsValue.value = true;
      await FirebaseFirestore.instance
          .collection('receiving')
          .doc(id)
          .collection('items')
          .add({
            'company_id': companyId.value,
            'added_date': DateTime.now().toString(),
            'code': selectedInventeryItemID.value,
            'quantity': int.tryParse(quantity.value.text) ?? 1,
            'orginal_price': double.tryParse(orginalPrice.value.text) ?? 0,
            'discount': double.tryParse(discount.value.text) ?? 0,
            'vat': double.tryParse(vat.value.text) ?? 0,
            'collection_parent': 'receiving',
            
          });
      addingNewItemsValue.value = false;
      Get.back();
    } catch (e) {
      addingNewItemsValue.value = false;
    }
  }

  editItem(String docId, String itemId) async {
    try {
      addingNewItemsValue.value = true;
      await FirebaseFirestore.instance
          .collection('receiving')
          .doc(docId)
          .collection('items')
          .doc(itemId)
          .update({
            'code': selectedInventeryItemID.value,
            'quantity': int.tryParse(quantity.value.text) ?? 1,
            'orginal_price': double.tryParse(orginalPrice.value.text) ?? 0,
            'discount': double.tryParse(discount.value.text) ?? 0,
            'vat': double.tryParse(vat.value.text) ?? 0,
          });
      addingNewItemsValue.value = false;
      Get.back();
    } catch (e) {
      addingNewItemsValue.value = false;
    }
  }

  deleteItem(String docId, String itemId) async {
    try {
      await FirebaseFirestore.instance
          .collection('receiving')
          .doc(docId)
          .collection('items')
          .doc(itemId)
          .delete();
      Get.back();
    } catch (e) {
      //
    }
  }

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
        receivingNumber.value.text =
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

  void searchEngine() {
    isScreenLoding.value = true;

    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('receiving')
        .where('company_id', isEqualTo: companyId.value);

    if (!isAllSelected.value) {
      if (isTodaySelected.value) {
        final now = DateTime.now();
        final startOfDay = DateTime(now.year, now.month, now.day);
        final endOfDay = startOfDay.add(const Duration(days: 1));
        fromDate.value.text = textToDate(startOfDay);
        toDate.value.text = textToDate(endOfDay);
        query = query
            .where(
              'date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
            )
            .where('date', isLessThan: Timestamp.fromDate(endOfDay));
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
              'date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth),
            )
            .where('date', isLessThan: Timestamp.fromDate(endOfMonth));
      } else if (isThisYearSelected.value) {
        final now = DateTime.now();
        final startOfYear = DateTime(now.year, 1, 1);
        final endOfYear = DateTime(now.year + 1, 1, 1);
        fromDate.value.text = textToDate(startOfYear);
        toDate.value.text = textToDate(endOfYear);
        query = query
            .where(
              'date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfYear),
            )
            .where('date', isLessThan: Timestamp.fromDate(endOfYear));
      } else {
        if (fromDate.value.text.trim().isNotEmpty) {
          try {
            final dtFrom = format.parseStrict(fromDate.value.text.trim());
            query = query.where(
              'date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(dtFrom),
            );
          } catch (_) {}
        }
        if (toDate.value.text.trim().isNotEmpty) {
          try {
            final dtTo = format
                .parseStrict(toDate.value.text.trim())
                .add(const Duration(days: 1));
            query = query.where('date', isLessThan: Timestamp.fromDate(dtTo));
          } catch (_) {}
        }
      }
    }

    // Listen to changes in real-time
    query.snapshots().listen((snapshot) {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> fetchedData =
          snapshot.docs;

      // Apply client-side filters
      final filteredReceivingDocs = fetchedData.where((doc) {
        final data = doc.data();

        if (receivingNumberFilter.value.text.trim().isNotEmpty &&
            data['number'] != receivingNumberFilter.value.text.trim()) {
          return false;
        }
        if (statusFilter.value.text.trim().isNotEmpty &&
            data['status'] != statusFilter.value.text.trim()) {
          return false;
        }
        if (vendorNameIdFilter.value.isNotEmpty &&
            data['vendor'] != vendorNameIdFilter.value) {
          return false;
        }
        if (referenceNumberFilter.value.text.trim().isNotEmpty &&
            data['reference_number'] !=
                referenceNumberFilter.value.text.trim()) {
          return false;
        }
        return true;
      }).toList();

      // Update UI instantly
      allReceivingDocs.assignAll(filteredReceivingDocs);
      numberOfReceivingDocs.value = allReceivingDocs.length;
      isScreenLoding.value = false;
    });
  }

  removeFilters() {
    isAllSelected.value = false;
    isTodaySelected.value = false;
    isThisMonthSelected.value = false;
    isThisYearSelected.value = false;
  }

  clearAllFilters() {
    statusFilter.value.clear();
    allReceivingDocs.clear();
    numberOfReceivingDocs.value = 0;
    allReceivingTotals.value = 0;
    allReceivingVATS.value = 0;
    allReceivingNET.value = 0;
    isAllSelected.value = false;
    isTodaySelected.value = false;
    isThisMonthSelected.value = false;
    isThisYearSelected.value = false;
    receivingNumberFilter.value.clear();
    referenceNumberFilter.value.clear();
    vendorNameIdFilter = RxString('');
    vendorNameIdFilterName.value = TextEditingController();
    fromDate.value.clear();
    toDate.value.clear();
    isScreenLoding.value = false;
  }
}
