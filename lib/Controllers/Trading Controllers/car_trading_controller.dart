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
  Rx<TextEditingController> year = TextEditingController().obs;
  TextEditingController pay = TextEditingController();
  TextEditingController receive = TextEditingController();
  Rx<TextEditingController> comments = TextEditingController().obs;
  TextEditingController note = TextEditingController();
  TextEditingController item = TextEditingController();
  Rx<TextEditingController> itemDate = TextEditingController().obs;
  RxString query = RxString('');
  RxString queryForItems = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  Rx<TextEditingController> searchForItems = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(true);
  final RxList<DocumentSnapshot> allTrades = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredTrades = RxList<DocumentSnapshot>([]);
  RxBool isValuesLoading = RxBool(false);
  RxString colorInId = RxString('');
  RxString colorOutId = RxString('');
  RxString carSpecificationId = RxString('');
  RxString carModelId = RxString('');
  RxString carBrandId = RxString('');
  RxString engineSizeId = RxString('');
  RxString yearId = RxString('');
  RxString itemId = RxString('');
  RxString status = RxString('');
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  RxString companyId = RxString('');
  RxMap allColors = RxMap({});
  RxMap allCarSpecifications = RxMap({});
  RxMap allBrands = RxMap({});
  RxMap allModels = RxMap({});
  RxMap allEngineSizes = RxMap({});
  RxMap allYears = RxMap({});
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
  RxString yearListMasterdById = RxString('');
  RxString engineSizeListId = RxString('');
  RxString engineSizeListMasterdById = RxString('');
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
  final RxnString selectedTradeId = RxnString();
  RxInt pagesPerPage = RxInt(5);

  @override
  void onInit() async {
    await getCompanyId();
    getAllTrades();
    getColors();
    getCarSpecifications();
    getCarBrands();
    getEngineSizes();
    getYears();
    getItems();
    search.value.addListener(() {
      filterTrades();
    });
    searchForItems.value.addListener(() {
      filterItems();
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
        isScreenLoding.value = false;
        initTradeSearchIndex();
        initTotalsCache();
        calculateTotalsForAllTrades();
      });
    } catch (e) {
      isScreenLoding.value = false;
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
          final receiveStr = item['receive']?.toString().toLowerCase() ?? '';
          final commentStr = item['comment']?.toString().toLowerCase() ?? '';

          return dateStr.contains(query) ||
              itemName.contains(query) ||
              payStr.contains(query) ||
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

  // void filterTrades() {
  //   final query = search.value.text.trim().toLowerCase();
  //   if (query.isEmpty) {
  //     filteredTrades.clear();
  //   } else {
  //     filteredTrades.assignAll(
  //       allTrades.where((trade) {
  //         final year = getdataName(trade['year'], allYears).toLowerCase();
  //         final colorIN =
  //             getdataName(trade['color_in'], allColors).toLowerCase();
  //         final colorOUT =
  //             getdataName(trade['color_out'], allColors).toLowerCase();
  //         final engineSize =
  //             getdataName(trade['engine_size'], allEngineSizes).toLowerCase();
  //         final specification =
  //             getdataName(trade['specification'], allCarSpecifications)
  //                 .toLowerCase();
  //         final status = trade['status']?.toString().toLowerCase() ?? '';
  //         final mileage = trade['mileage']?.toString().toLowerCase() ?? '';
  //         final brand =
  //             getdataName(trade['car_brand'], allBrands).toLowerCase();
  //         final model = getCarModelName(trade['car_brand'], trade['car_model'])
  //             .toString()
  //             .toLowerCase();

  //         return year.contains(query) ||
  //             specification.contains(query) ||
  //             status.contains(query) ||
  //             engineSize.contains(query) ||
  //             mileage.contains(query) ||
  //             brand.contains(query) ||
  //             model.contains(query) ||
  //             colorIN.contains(query) ||
  //             colorOUT.contains(query);
  //       }).toList(),
  //     );
  //   }
  // }
}
