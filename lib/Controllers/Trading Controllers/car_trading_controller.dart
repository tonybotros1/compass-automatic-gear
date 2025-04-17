import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:datahubai/Controllers/Main%20screen%20controllers/car_brands_controller.dart';
import 'package:datahubai/Controllers/Main%20screen%20controllers/list_of_values_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  TextEditingController itemDate = TextEditingController();
  RxString query = RxString('');
  RxString queryForItems = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  Rx<TextEditingController> searchForItems = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(true);
  final RxList<DocumentSnapshot> allTrades = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredTrades = RxList<DocumentSnapshot>([]);

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
  CarBrandsController carBrandsController = Get.put(CarBrandsController());
  RxString currentTradId = RxString('');
  RxDouble totalPays = RxDouble(0.0);
  RxDouble totalReceives = RxDouble(0.0);
  RxDouble totalNETs = RxDouble(0.0);
  // final ScrollController scrollController = ScrollController();
  final Uuid _uuid = Uuid();

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
    searchForItems.value.addListener(() {
      filterItems();
    });
    super.onInit();
  }

  // Future<List<Map<String, String>>> parseExcelFromPicker() async {
  //   try {
  //     final result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ['xls', 'xlsx'],
  //       withData: true,
  //     );

  //     if (result == null || result.files.single.bytes == null) {
  //       throw Exception('No file selected or file data is null');
  //     }

  //     final Uint8List bytes = result.files.single.bytes!;
  //     final excel = Excel.decodeBytes(bytes);

  //     final List<Map<String, String>> data = [];

  //     for (final table in excel.tables.keys) {
  //       final sheet = excel.tables[table];

  //       for (var row in sheet!.rows.skip(1)) {
  //         final brand = row[0]?.value?.toString();
  //         final model = row[1]?.value?.toString();

  //         if (brand != null && model != null) {
  //           data.add({'brand': brand, 'model': model});
  //         }
  //       }
  //     }
  //     return data;
  //   } catch (e) {
  //     print(e);
  //     return [];
  //   }
  // }

  // Future<void> uploadCarBrandsAndModels(
  //     List<Map<String, dynamic>> carData) async {
  //   final carBrandsCollection =
  //       FirebaseFirestore.instance.collection('all_brands');

  //   // Fetch existing brands from Firestore and map them by name
  //   final existingBrandsSnapshot = await carBrandsCollection.get();
  //   final Map<String, String> existingBrandIds = {
  //     for (var doc in existingBrandsSnapshot.docs) doc.data()['name']: doc.id
  //   };

  //   // Group models under each brand
  //   final Map<String, Set<String>> brandModelsMap = {};
  //   for (var item in carData) {
  //     final brand = item['brand'];
  //     final model = item['model'];
  //     if (brand == null || model == null) continue;

  //     brandModelsMap.putIfAbsent(brand, () => {}).add(model);
  //   }

  //   // Upload brands and models
  //   for (var entry in brandModelsMap.entries) {
  //     final brand = entry.key;
  //     final models = entry.value;

  //     String brandId;

  //     // Use existing brand or create a new one
  //     if (existingBrandIds.containsKey(brand)) {
  //       brandId = existingBrandIds[brand]!;
  //     } else {
  //       final newBrandDoc = await carBrandsCollection.add({
  //         'added_date': DateTime.now().toIso8601String(),
  //         'logo': '',
  //         'name': brand,
  //         'status': true,
  //       });
  //       brandId = newBrandDoc.id;
  //       print('Added new brand: $brand');
  //     }

  //     // Fetch existing models for this brand to avoid duplicates
  //     final existingModelsSnapshot =
  //         await carBrandsCollection.doc(brandId).collection('values').get();

  //     final existingModelNames = existingModelsSnapshot.docs
  //         .map((doc) => doc.data()['name'] as String)
  //         .toSet();

  //     // Add new models only
  //     for (var model in models) {
  //       if (!existingModelNames.contains(model)) {
  //         await carBrandsCollection.doc(brandId).collection('values').add({
  //           'added_date': DateTime.now().toIso8601String(),
  //           'name': model,
  //           'status': true,
  //         });
  //         print('Added model: $model to brand: $brand');
  //       }
  //     }
  //   }
  // }

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

  clearValues() {
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
    date.value.text = data['date'];
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
  }

  void addNewItem() {
    final String uniqueId = _uuid.v4();

    addedItems.add({
      'id': uniqueId,
      'date': textToDate(DateTime.now()),
      'item': itemId.value,
      'item_name': item.text,
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
      var currentTrade =
          await FirebaseFirestore.instance.collection('all_trades').add({
        'date': date.value.text,
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
        'status': 'New'
      });
      status.value = 'New';
      currentTradId.value = currentTrade.id;
      addingNewValue.value = false;
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  editTrade(tradeId) {
    try {
      FirebaseFirestore.instance.collection('all_trades').doc(tradeId).update({
        'date': date.value.text,
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
    } catch (e) {
      //
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
          .snapshots()
          .listen((trade) {
        allTrades.assignAll(List<DocumentSnapshot>.from(trade.docs));
        isScreenLoding.value = false;
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

  // this function is to filter the search results for web
  void filterItems() {
    queryForItems.value = searchForItems.value.text.toLowerCase();
    if (queryForItems.value.isEmpty) {
      filteredAddedItems.clear();
    } else {
      filteredAddedItems.assignAll(
        addedItems.where((item) {
          return item['date'].toString().toLowerCase().contains(query) ||
              getdataName(item['item'], allItems)
                  .toString()
                  .toLowerCase()
                  .contains(query) ||
              item['pay'].toString().toLowerCase().contains(query) ||
              item['comment'].toString().toLowerCase().contains(query) ||
              item['receive'].toString().toLowerCase().contains(query);
        }).toList(),
      );
    }

  }
}
