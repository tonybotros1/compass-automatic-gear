import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:datahubai/Controllers/Main%20screen%20controllers/car_brands_controller.dart';
import 'package:datahubai/Controllers/Main%20screen%20controllers/list_of_values_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../consts.dart';
import '../Main screen controllers/main_screen_contro.dart';
import 'package:uuid/uuid.dart';

class CarTradingController extends GetxController {
  Rx<TextEditingController> date = TextEditingController().obs;
  Rx<TextEditingController> mileage = TextEditingController().obs;
  Rx<TextEditingController> colorIn = TextEditingController().obs;
  Rx<TextEditingController> colorOut = TextEditingController().obs;
  Rx<TextEditingController> carSpecification = TextEditingController().obs;
  Rx<TextEditingController> carBrand = TextEditingController().obs;
  Rx<TextEditingController> carModel = TextEditingController().obs;
  Rx<TextEditingController> engineSize = TextEditingController().obs;
  Rx<TextEditingController> boughtFrom = TextEditingController().obs;
  Rx<TextEditingController> year = TextEditingController().obs;
  Rx<TextEditingController> soldTo = TextEditingController().obs;
  TextEditingController pay = TextEditingController();
  TextEditingController receive = TextEditingController();
  Rx<TextEditingController> comments = TextEditingController().obs;
  TextEditingController note = TextEditingController();
  TextEditingController item = TextEditingController();
  TextEditingController name = TextEditingController();
  Rx<TextEditingController> itemDate = TextEditingController().obs;
  RxString query = RxString('');
  RxString queryForItems = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  Rx<TextEditingController> searchForItems = TextEditingController().obs;
  Rx<TextEditingController> searchForCapitals = TextEditingController().obs;
  Rx<TextEditingController> searchForOutstanding = TextEditingController().obs;
  Rx<TextEditingController> searchForGeneralexpenses =
      TextEditingController().obs;
  RxBool isScreenLoding = RxBool(true);
  RxBool isCapitalLoading = RxBool(false);
  RxBool isOutstandinglLoading = RxBool(false);
  RxBool isgeneralExpenseslLoading = RxBool(false);
  final RxList<DocumentSnapshot> allTrades = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> allCapitals = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> allOutstanding = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> allGeneralExpenses =
      RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredTrades = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredGeneralExpenses =
      RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredOutstanding =
      RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredCapitals =
      RxList<DocumentSnapshot>([]);
  RxBool isValuesLoading = RxBool(false);
  RxString colorInId = RxString('');
  RxString colorOutId = RxString('');
  RxString carSpecificationId = RxString('');
  RxString carModelId = RxString('');
  RxString carBrandId = RxString('');
  RxString engineSizeId = RxString('');
  RxString boughtFromId = RxString('');
  RxString yearId = RxString('');
  RxString soldToId = RxString('');
  RxString itemId = RxString('');
  RxString nameId = RxString('');
  RxString status = RxString('');
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  RxBool addingCapitalNewValue = RxBool(false);
  RxString companyId = RxString('');
  RxMap allColors = RxMap({});
  RxMap allCarSpecifications = RxMap({});
  RxMap allBrands = RxMap({});
  RxMap allModels = RxMap({});
  RxMap allEngineSizes = RxMap({});
  RxMap allBuyersAndSellers = RxMap({});
  RxMap allYears = RxMap({});
  RxMap allNames = RxMap({});
  RxMap allItems = RxMap({});
  RxList<Map<String, dynamic>> addedItems = RxList([]);
  RxList<Map> filteredAddedItems = RxList([]);
  ListOfValuesController listOfValuesController =
      Get.put(ListOfValuesController());
  RxString carSpecificationsListId = RxString('');
  RxString carSpecificationsListMasteredById = RxString('');
  RxString colorsListId = RxString('');
  RxString colorsListMasterdById = RxString('');
  RxString yearListId = RxString('');
  RxString namesListId = RxString('');
  RxString yearListMasterdById = RxString('');
  RxString namesListMasterdById = RxString('');
  RxString engineSizeListId = RxString('');
  RxString buyersAndSellersListId = RxString('');
  RxString engineSizeListMasterdById = RxString('');
  RxString buyersAndSellersMasterdById = RxString('');
  RxString newItemListMasteredByID = RxString('');
  RxString newItemListID = RxString('');
  CarBrandsController carBrandsController = Get.put(CarBrandsController());
  RxString currentTradId = RxString('');
  RxDouble totalPays = RxDouble(0.0);
  RxDouble totalReceives = RxDouble(0.0);
  RxDouble totalNETs = RxDouble(0.0);
  RxDouble totalPaysForAllTrades = RxDouble(0.0);
  RxDouble totalReceivesForAllTrades = RxDouble(0.0);
  RxDouble totalNETsForAllTrades = RxDouble(0.0);
  // final ScrollController scrollController = ScrollController();
  final Uuid _uuid = Uuid();
  final Map<String, Future<String>> _paidFutureCache = {};
  final Map<String, Future<String>> _receivedFutureCache = {};
  final Map<String, Future<String>> _netsFutureCache = {};
  var buttonLoadingStates = <String, bool>{}.obs;
  final RxnString selectedTradeId = RxnString('');
  RxInt pagesPerPage = RxInt(17);

  @override
  void onInit() async {
    await getCompanyId();
    getBuyersAndSellers();
    getColors();
    getCarSpecifications();
    await getCarBrands();
    getEngineSizes();
     getNamesOfPeople();
    await getYears();
    getItems();
    getAllTrades();

    search.value.addListener(() {
      filterTrades();
    });
    searchForItems.value.addListener(() {
      filterItems();
    });
    searchForCapitals.value.addListener(() {
      filterCapitalsOrOutstandingOrGeneralExpenses(
          searchForCapitals, allCapitals, filteredCapitals, false);
    });
    searchForOutstanding.value.addListener(() {
      filterCapitalsOrOutstandingOrGeneralExpenses(
          searchForOutstanding, allOutstanding, filteredOutstanding, false);
    });
    searchForGeneralexpenses.value.addListener(() {
      filterCapitalsOrOutstandingOrGeneralExpenses(searchForGeneralexpenses,
          allGeneralExpenses, filteredGeneralExpenses, true);
    });
    super.onInit();
  }

  changeRowsPerPage(rows) {
    pagesPerPage.value = rows;
  }

  // function to manage loading button
  void setButtonLoading(String menuId, bool isLoading) {
    buttonLoadingStates[menuId] = isLoading;
    buttonLoadingStates.refresh(); // Notify listeners
  }

  Future<String> gettradePaidCached(String tradeId,
      {bool forceRefresh = false}) {
    if (forceRefresh) {
      _paidFutureCache.remove(tradeId);
    }
    return _paidFutureCache.putIfAbsent(
      tradeId,
      () => gettradePaid(tradeId),
    );
  }

  Future<String> gettradeReceivedCached(String tradeId,
      {bool forceRefresh = false}) {
    if (forceRefresh) {
      _receivedFutureCache.remove(tradeId);
    }
    return _receivedFutureCache.putIfAbsent(
      tradeId,
      () => gettradeReceived(tradeId),
    );
  }

  Future<String> gettradeNETsCached(String tradeId,
      {bool forceRefresh = false}) {
    if (forceRefresh) {
      _netsFutureCache.remove(tradeId);
    }
    return _netsFutureCache.putIfAbsent(
      tradeId,
      () => gettradeNETs(tradeId),
    );
  }

  Future<void> initTotalsCache() async {
    for (final doc in allTrades) {
      gettradePaidCached(doc.id);
      gettradeReceivedCached(doc.id);
      gettradeNETsCached(doc.id);
    }
  }

  void refreshTradePaid(String tradeId) {
    gettradePaidCached(tradeId, forceRefresh: true);
    gettradeReceivedCached(tradeId, forceRefresh: true);
    gettradeNETsCached(tradeId, forceRefresh: true);
    allTrades.refresh();
    filteredTrades.refresh();
  }

  String getCachedCarModelName(String brandId, String modelId) {
    return _modelCache[modelId] ?? '';
  }

  getCompanyId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId.value = prefs.getString('companyId')!;
  }

  getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
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
    update();
  }

  calculateTotals() {
    totalNETs.value = 0.0;
    totalPays.value = 0.0;
    totalReceives.value = 0.0;
    for (var item in addedItems) {
      totalPays.value += double.tryParse(item['pay'])!;
      totalReceives.value += double.tryParse(item['receive'])!;
    }
    totalNETs.value = totalReceives.value - totalPays.value;
  }

  calculateTotalsForCapitals(RxList<DocumentSnapshot<Object?>> map) {
    totalNETs.value = 0.0;
    totalPays.value = 0.0;
    totalReceives.value = 0.0;
    for (var element in map) {
      var data = element.data() as Map;
      totalPays.value += double.tryParse(data['pay'] ?? 0)!;
      totalReceives.value += double.tryParse(data['receive'])!;
    }
    totalNETs.value = totalReceives.value - totalPays.value;
  }

  void calculateTotalsForAllTrades() {
    totalNETsForAllTrades.value = 0.0;
    totalPaysForAllTrades.value = 0.0;
    totalReceivesForAllTrades.value = 0.0;

    var newList = filteredTrades.isEmpty ? allTrades : filteredTrades;

    for (var trade in newList) {
      final data = trade.data() as Map<String, dynamic>;
      final itemsList = data['items'] as List<dynamic>?;

      if (itemsList != null) {
        for (var item in itemsList) {
          final pay = double.tryParse(item['pay'] ?? 0);
          final receive = double.tryParse(item['receive'] ?? 0);

          totalPaysForAllTrades.value += pay!;
          totalReceivesForAllTrades.value += receive!;
          totalNETsForAllTrades.value += (receive - pay);
        }
      }
    }
  }

  clearValues() {
    boughtFrom.value.clear();
    boughtFromId.value = '';
    soldTo.value.clear();
    soldToId.value = '';
    totalPays.value = 0.0;
    totalNETs.value = 0.0;
    totalReceives.value = 0.0;
    query.value = '';
    queryForItems.value = '';
    search.value.clear();
    searchForItems.value.clear();
    allModels.clear();
    date.value.text = textToDate(DateTime.now());
    mileage.value.text = '0';
    colorIn.value.clear();
    colorInId.value = '';
    colorOut.value.clear();
    colorOutId.value = '';
    carBrand.value.clear();
    carBrandId.value = '';
    carModel.value.clear();
    carModelId.value = '';
    carSpecification.value.clear();
    carSpecificationId.value = '';
    engineSize.value.clear();
    engineSizeId.value = '';
    year.value.clear();
    yearId.value = '';
    note.clear();
    addedItems.clear();
    status.value = '';
    currentTradId.value = '';
  }

  loadValues(Map data) async {
    if (data['bought_from'] != null) {
      boughtFrom.value.text =
          getdataName(data['bought_from'], allBuyersAndSellers);
      boughtFromId.value = data['bought_from'];
    }
    if (data['sold_to'] != null) {
      soldTo.value.text = getdataName(data['sold_to'], allBuyersAndSellers);
      soldToId.value = data['sold_to'];
    }
    isValuesLoading.value = true;
    date.value.text = textToDate(data['date']);
    mileage.value.text = data['mileage'];
    colorIn.value.text = getdataName(data['color_in'], allColors);
    colorInId.value = data['color_in'];
    colorOut.value.text = getdataName(data['color_out'], allColors);
    colorOutId.value = data['color_out'];
    carBrand.value.text = getdataName(data['car_brand'], allBrands);
    carBrandId.value = data['car_brand'];
    carSpecification.value.text =
        getdataName(data['specification'], allCarSpecifications);
    carSpecificationId.value = data['specification'];
    engineSize.value.text = getdataName(data['engine_size'], allEngineSizes);
    engineSizeId.value = data['engine_size'];
    year.value.text = getdataName(data['year'], allYears);
    yearId.value = data['year'];
    note.text = data['note'];
    addedItems.assignAll((data['items'] as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList());

    status.value = data['status'];
    carModel.value.text =
        await getCarModelName(data['car_brand'], data['car_model']);
    carModelId.value = data['car_model'];
    getModelsByCarBrand(data['car_brand']);
    calculateTotals();
    isValuesLoading.value = false;
  }

  void addNewItem() {
    final String uniqueId = _uuid.v4();

    addedItems.add({
      'id': uniqueId,
      'date': itemDate.value.text,
      'item': itemId.value,
      'pay': pay.value.text,
      'receive': receive.value.text,
      'comment': comments.value.text,
    });

    calculateTotals();
    Get.back();
  }

  addNewTrade() async {
    try {
      addingNewValue.value = true;
      DateFormat format = DateFormat('dd-MM-yyyy');
      DateTime parsedDate = format.parse(date.value.text);
      var currentTrade = FirebaseFirestore.instance.collection('all_trades');

      if (currentTradId.value == '') {
        var addedTrade = await currentTrade.add({
          'bought_from': boughtFromId.value,
          'sold_to': soldToId.value,
          'date': parsedDate.toString(),
          'car_brand': carBrandId.value,
          'car_model': carModelId.value,
          'mileage': mileage.value.text,
          'specification': carSpecificationId.value,
          'engine_size': engineSizeId.value,
          'color_in': colorInId.value,
          'color_out': colorOutId.value,
          'year': yearId.value,
          'note': note.text,
          'items': addedItems,
          'company_id': companyId.value,
          'status': 'New',
          'added_date': DateTime.now()
        });
        status.value = 'New';
        currentTradId.value = addedTrade.id;
        addingNewValue.value = false;
        showSnackBar('Success', 'Addedd Successfully');
      } else {
        await currentTrade.doc(currentTradId.value).update({
          'bought_from': boughtFromId.value,
          'sold_to': soldToId.value,
          'date': parsedDate.toString(),
          'car_brand': carBrandId.value,
          'car_model': carModelId.value,
          'mileage': mileage.value.text,
          'specification': carSpecificationId.value,
          'engine_size': engineSizeId.value,
          'color_in': colorInId.value,
          'color_out': colorOutId.value,
          'year': yearId.value,
          'note': note.text,
          'items': addedItems,
        });
        addingNewValue.value = false;
        refreshTradePaid(currentTradId.value);
        showSnackBar('Success', 'Updated Successfully');
      }
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  editTrade(tradeId) async {
    addingNewValue.value = true;
    try {
      DateFormat format = DateFormat('dd-MM-yyyy');
      DateTime parsedDate = format.parse(date.value.text);
      await FirebaseFirestore.instance
          .collection('all_trades')
          .doc(tradeId)
          .update({
        'bought_from': boughtFromId.value,
        'sold_to': soldToId.value,
        'date': parsedDate.toString(),
        'car_brand': carBrandId.value,
        'car_model': carModelId.value,
        'mileage': mileage.value.text,
        'specification': carSpecificationId.value,
        'engine_size': engineSizeId.value,
        'color_in': colorInId.value,
        'color_out': colorOutId.value,
        'year': yearId.value,
        'note': note.text,
        'items': addedItems,
      });
      refreshTradePaid(tradeId);
      showSnackBar('Success', 'Updated Successfully');
      addingNewValue.value = false;
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  deleteTrade(tradeId) {
    try {
      Get.back();
      Get.back();
      FirebaseFirestore.instance.collection('all_trades').doc(tradeId).delete();
    } catch (e) {
      //
    }
  }

  changeStatus(String tradeId, String status) {
    try {
      FirebaseFirestore.instance
          .collection('all_trades')
          .doc(tradeId)
          .update({'status': status});
    } catch (e) {
      showSnackBar('Something went wrong', 'Please try again');
    }
  }

  getAllTrades() {
    try {
      FirebaseFirestore.instance
          .collection('all_trades')
          .where('company_id', isEqualTo: companyId.value)
          .orderBy('date', descending: true)
          .snapshots()
          .listen((trade) {
        allTrades.assignAll(List<DocumentSnapshot>.from(trade.docs));
        initTradeSearchIndex();
        initTotalsCache();
        calculateTotalsForAllTrades();
        isScreenLoding.value = false;
      });
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  getAllCapitals() {
    try {
      isCapitalLoading.value = true;
      FirebaseFirestore.instance
          .collection('all_capitals')
          .where('company_id', isEqualTo: companyId.value)
          .orderBy('date', descending: true)
          .snapshots()
          .listen((capitals) {
        allCapitals.assignAll(List<DocumentSnapshot>.from(capitals.docs));

        calculateTotalsForCapitals(allCapitals);
        isCapitalLoading.value = false;
      });
    } catch (e) {
      isCapitalLoading.value = false;
    }
  }

  getAllOutstanding() {
    try {
      isOutstandinglLoading.value = true;
      FirebaseFirestore.instance
          .collection('all_outstanding')
          .where('company_id', isEqualTo: companyId.value)
          .orderBy('date', descending: true)
          .snapshots()
          .listen((outstanding) {
        allOutstanding.assignAll(List<DocumentSnapshot>.from(outstanding.docs));

        calculateTotalsForCapitals(allOutstanding);
        isOutstandinglLoading.value = false;
      });
    } catch (e) {
      isOutstandinglLoading.value = false;
    }
  }

  getAllGeneralExpenses() {
    try {
      isgeneralExpenseslLoading.value = true;
      FirebaseFirestore.instance
          .collection('all_general_expenses')
          .where('company_id', isEqualTo: companyId.value)
          .orderBy('date', descending: true)
          .snapshots()
          .listen((outstanding) {
        allGeneralExpenses
            .assignAll(List<DocumentSnapshot>.from(outstanding.docs));

        calculateTotalsForCapitals(allGeneralExpenses);
        isgeneralExpenseslLoading.value = false;
      });
    } catch (e) {
      isgeneralExpenseslLoading.value = false;
    }
  }

  addNewCapitalsOrOutstandingOrGeneralExpenses(
      String collection, bool isGeneral) async {
    try {
      addingNewValue.value = true;
      var data = {
        'company_id': companyId.value,
        'date': itemDate.value.text,
        'pay': pay.text,
        'receive': receive.text,
        'comment': comments.value.text,
      };
      if (isGeneral == true) {
        data['item'] = itemId.value;
      } else {
        data['name'] = nameId.value;
      }
      await FirebaseFirestore.instance.collection(collection).add(data);
      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  updateCapitalsOrOutstandingOrGeneralExpenses(
      String collection, String id, bool isGeneral) async {
    try {
      Get.back();
      var data = {
        'date': itemDate.value.text,
        'pay': pay.text,
        'receive': receive.text,
        'comment': comments.value.text,
      };
      if (isGeneral == true) {
        data['item'] = itemId.value;
      } else {
        data['name'] = nameId.value;
      }
      addingNewValue.value = true;
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(id)
          .update(data);
      addingNewValue.value = false;
    } catch (e) {
      addingNewValue.value = false;
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  deleteCapitalOrOutstandingOrGeneralExpenses(String collection, String id) {
    try {
      FirebaseFirestore.instance.collection(collection).doc(id).delete();
      Get.back();
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  // this function is to get colors
  getColors() async {
    var typeDoc = await FirebaseFirestore.instance
        .collection('all_lists')
        .where('code', isEqualTo: 'COLORS')
        .get();

    var typeId = typeDoc.docs.first.id;
    colorsListId.value = typeId;
    colorsListMasterdById.value = typeDoc.docs.first.data()['mastered_by'];
    FirebaseFirestore.instance
        .collection('all_lists')
        .doc(typeId)
        .collection('values')
        .where('available', isEqualTo: true)
        .snapshots()
        .listen((colors) {
      allColors.value = {for (var doc in colors.docs) doc.id: doc.data()};
    });
  }

  // this function is to get Car Specifications
  getCarSpecifications() async {
    var typeDoc = await FirebaseFirestore.instance
        .collection('all_lists')
        .where('code', isEqualTo: 'CAR_SPECIFICATIONS')
        .get();

    var typeId = typeDoc.docs.first.id;
    carSpecificationsListId.value = typeId;
    carSpecificationsListMasteredById.value =
        typeDoc.docs.first.data()['mastered_by'];
    FirebaseFirestore.instance
        .collection('all_lists')
        .doc(typeId)
        .collection('values')
        .where('available', isEqualTo: true)
        .snapshots()
        .listen((car) {
      allCarSpecifications.value = {
        for (var doc in car.docs) doc.id: doc.data()
      };
    });
  }

  // this function is to get engine sizes
  getEngineSizes() async {
    var typeDoc = await FirebaseFirestore.instance
        .collection('all_lists')
        .where('code', isEqualTo: 'ENGINE_TYPES')
        .get();

    var typeId = typeDoc.docs.first.id;
    engineSizeListId.value = typeId;
    engineSizeListMasterdById.value = typeDoc.docs.first.data()['mastered_by'];
    FirebaseFirestore.instance
        .collection('all_lists')
        .doc(typeId)
        .collection('values')
        .where('available', isEqualTo: true)
        .snapshots()
        .listen((engine) {
      allEngineSizes.value = {for (var doc in engine.docs) doc.id: doc.data()};
    });
  }

  // this function is to get years
  getYears() async {
    var typeDoc = await FirebaseFirestore.instance
        .collection('all_lists')
        .where('code', isEqualTo: 'YEARS')
        .get();

    var typeId = typeDoc.docs.first.id;
    yearListId.value = typeId;
    yearListMasterdById.value = typeDoc.docs.first.data()['mastered_by'];
    FirebaseFirestore.instance
        .collection('all_lists')
        .doc(typeId)
        .collection('values')
        .where('available', isEqualTo: true)
        .orderBy('added_date')
        .snapshots()
        .listen((year) {
      allYears.value = {for (var doc in year.docs) doc.id: doc.data()};
    });
  }

  // this function is to get years
  getBuyersAndSellers() async {
    var typeDoc = await FirebaseFirestore.instance
        .collection('all_lists')
        .where('code', isEqualTo: 'BUYERS_AND_SELLERS')
        .get();

    var typeId = typeDoc.docs.first.id;
    buyersAndSellersListId.value = typeId;
    buyersAndSellersMasterdById.value =
        typeDoc.docs.first.data()['mastered_by'];
    FirebaseFirestore.instance
        .collection('all_lists')
        .doc(typeId)
        .collection('values')
        .where('available', isEqualTo: true)
        .orderBy('added_date')
        .snapshots()
        .listen((year) {
      allBuyersAndSellers.value = {
        for (var doc in year.docs) doc.id: doc.data()
      };
    });
  }

  // this function is to get names of people
  getNamesOfPeople() async {
    var typeDoc = await FirebaseFirestore.instance
        .collection('all_lists')
        .where('code', isEqualTo: 'NAMES_OF_PEOPLE')
        .get();

    var typeId = typeDoc.docs.first.id;
    namesListId.value = typeId;
    namesListMasterdById.value = typeDoc.docs.first.data()['mastered_by'];
    FirebaseFirestore.instance
        .collection('all_lists')
        .doc(typeId)
        .collection('values')
        .where('available', isEqualTo: true)
        .orderBy('added_date')
        .snapshots()
        .listen((year) {
      allNames.value = {for (var doc in year.docs) doc.id: doc.data()};
    });
  }

  // this function is to get items
  getItems() async {
    var typeDoc = await FirebaseFirestore.instance
        .collection('all_lists')
        .where('code', isEqualTo: 'ITEMS')
        .get();

    var typeId = typeDoc.docs.first.id;
    newItemListID.value = typeId;
    newItemListMasteredByID.value = typeDoc.docs.first.data()['mastered_by'];
    FirebaseFirestore.instance
        .collection('all_lists')
        .doc(typeId)
        .collection('values')
        .where('available', isEqualTo: true)
        .orderBy('added_date')
        .snapshots()
        .listen((item) {
      allItems.value = {for (var doc in item.docs) doc.id: doc.data()};
    });
  }

  getCarBrands() {
    try {
      FirebaseFirestore.instance
          .collection('all_brands')
          .snapshots()
          .listen((brands) {
        allBrands.value = {for (var doc in brands.docs) doc.id: doc.data()};
      });
    } catch (e) {
      //
    }
  }

  getModelsByCarBrand(brandId) {
    try {
      FirebaseFirestore.instance
          .collection('all_brands')
          .doc(brandId)
          .collection('values')
          .snapshots()
          .listen((models) {
        allModels.value = {for (var doc in models.docs) doc.id: doc.data()};
      });
    } catch (e) {
      //
    }
  }

  String getdataName(String id, Map allData, {title = 'name'}) {
    try {
      final data = allData.entries.firstWhere(
        (data) => data.key == id,
      );
      return data.value[title];
    } catch (e) {
      return '';
    }
  }

  Future<String> getCarModelName(brandId, modelId) async {
    try {
      var name = await FirebaseFunctions.instance
          .httpsCallable('get_model_name')
          .call({"brandId": brandId, "modelId": modelId});
      return name.data;
    } catch (e) {
      return '';
    }
  }

  Future<String> gettradePaid(tradeId) async {
    try {
      var paid = await FirebaseFunctions.instance
          .httpsCallable('get_trade_total_paid')
          .call(tradeId);
      return paid.data.toString();
    } catch (e) {
      return '';
    }
  }

  Future<String> gettradeReceived(tradeId) async {
    try {
      var rec = await FirebaseFunctions.instance
          .httpsCallable('get_trade_total_received')
          .call(tradeId);
      return rec.data.toString();
    } catch (e) {
      return '';
    }
  }

  Future<String> gettradeNETs(tradeId) async {
    try {
      var net = await FirebaseFunctions.instance
          .httpsCallable('get_trade_total_NETs')
          .call(tradeId);
      return net.data.toString();
    } catch (e) {
      return '';
    }
  }

  void filterItems() {
    final query = searchForItems.value.text.trim().toLowerCase();
    if (query.isEmpty) {
      filteredAddedItems.clear();
    } else {
      filteredAddedItems.assignAll(
        addedItems.where((item) {
          final dateStr = item['date']?.toString().toLowerCase() ?? '';
          final itemName =
              getdataName(item['item'], allItems).toString().toLowerCase();
          final payStr = item['pay']?.toString().toLowerCase() ?? '';
          final nameStr = item['name']?.toString().toLowerCase() ?? '';
          final receiveStr = item['receive']?.toString().toLowerCase() ?? '';
          final commentStr = item['comment']?.toString().toLowerCase() ?? '';

          return dateStr.contains(query) ||
              itemName.contains(query) ||
              payStr.contains(query) ||
              nameStr.contains(query) ||
              commentStr.contains(query) ||
              receiveStr.contains(query);
        }).toList(),
      );
    }
  }

  final Map<String, String> _modelCache = {};
  final Map<String, String> _searchStrings = {};

  Future<void> initTradeSearchIndex() async {
    for (var doc in allTrades) {
      final brandId = doc.get('car_brand');
      final modelId = doc.get('car_model');
      if (!_modelCache.containsKey(modelId)) {
        _modelCache[modelId] = await getCarModelName(brandId, modelId);
      }
    }

    for (var doc in allTrades) {
      final data = doc.data()! as Map<String, dynamic>;
      final parts = <String>[
        getdataName(data['year'], allYears),
        getdataName(data['color_in'], allColors),
        getdataName(data['color_out'], allColors),
        getdataName(data['engine_size'], allEngineSizes),
        getdataName(data['specification'], allCarSpecifications),
        data['status']?.toString() ?? '',
        data['mileage']?.toString() ?? '',
        getdataName(data['car_brand'], allBrands),
        _modelCache[data['car_model']] ?? '',
      ];
      _searchStrings[doc.id] = parts.join(' ').toLowerCase();
    }

    filteredTrades.assignAll(allTrades);
  }

  void filterTrades() {
    final q = search.value.text.trim().toLowerCase();

    if (q.isEmpty) {
      filteredTrades.assignAll(allTrades);
      calculateTotalsForAllTrades();
    } else {
      filteredTrades.assignAll(
        allTrades.where((doc) {
          final s = _searchStrings[doc.id] ?? '';
          return s.contains(q);
        }).toList(),
      );
      calculateTotalsForAllTrades();
    }
  }

  // this function is to filter the search results for web
  void filterCapitalsOrOutstandingOrGeneralExpenses(
      Rx<TextEditingController> mapQuery,
      RxList<DocumentSnapshot<Object?>> allMap,
      RxList<DocumentSnapshot<Object?>> filteredMap,
      bool isGeneral) {
    query.value = mapQuery.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredMap.clear();
      calculateTotalsForCapitals(allMap);
    } else {
      filteredMap.assignAll(
        allMap.where((cap) {
          return cap['pay'].toString().toLowerCase().contains(query) ||
              cap['receive'].toString().toLowerCase().contains(query) ||
              cap['comment'].toString().toLowerCase().contains(query) ||
              getdataName(isGeneral == false ? cap['name'] : cap['item'],
                      isGeneral == false ? allNames : allItems)
                  .toString()
                  .toLowerCase()
                  .contains(query) ||
              textToDate(cap['date']).toLowerCase().contains(query);
        }).toList(),
      );
      calculateTotalsForCapitals(filteredMap);
    }
  }

  //  // this function is to filter the search results for web
  // void filterOutstanding() {
  //   query.value = searchForOutstanding.value.text.toLowerCase();
  //   if (query.value.isEmpty) {
  //     filteredCapitals.clear();
  //   } else {
  //     filteredCapitals.assignAll(
  //       allCapitals.where((cap) {
  //         return cap['pay'].toString().toLowerCase().contains(query) ||
  //             cap['receive'].toString().toLowerCase().contains(query) ||
  //             cap['comment'].toString().toLowerCase().contains(query) ||
  //             getdataName(cap['name'], allNames)
  //                 .toString()
  //                 .toLowerCase()
  //                 .contains(query) ||
  //             textToDate(cap['date']).toLowerCase().contains(query);
  //       }).toList(),
  //     );
  //   }
  // }

  //  // this function is to filter the search results for web
  // void filterCapitals() {
  //   query.value = searchForCapitals.value.text.toLowerCase();
  //   if (query.value.isEmpty) {
  //     filteredCapitals.clear();
  //   } else {
  //     filteredCapitals.assignAll(
  //       allCapitals.where((cap) {
  //         return cap['pay'].toString().toLowerCase().contains(query) ||
  //             cap['receive'].toString().toLowerCase().contains(query) ||
  //             cap['comment'].toString().toLowerCase().contains(query) ||
  //             getdataName(cap['name'], allNames)
  //                 .toString()
  //                 .toLowerCase()
  //                 .contains(query) ||
  //             textToDate(cap['date']).toLowerCase().contains(query);
  //       }).toList(),
  //     );
  //   }
  // }
}
