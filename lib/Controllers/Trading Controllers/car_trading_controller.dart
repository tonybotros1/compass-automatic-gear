import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../consts.dart';
import '../Main screen controllers/main_screen_contro.dart';

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
  Rx<TextEditingController> pay = TextEditingController().obs;
  Rx<TextEditingController> receive = TextEditingController().obs;
  Rx<TextEditingController> comments = TextEditingController().obs;
  TextEditingController note = TextEditingController();
  TextEditingController item = TextEditingController();
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(true);
  final RxList<DocumentSnapshot> allTrades = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredTrades = RxList<DocumentSnapshot>([]);
  final GlobalKey<FormState> formKeyForAddingNewItemvalue = GlobalKey<FormState>();

  RxString colorInId = RxString('');
  RxString colorOutId = RxString('');
  RxString carSpecificationId = RxString('');
  RxString carModelId = RxString('');
  RxString carBrandId = RxString('');
  RxString engineSizeId = RxString('');
  RxString yearId = RxString('');
  RxString itemId = RxString('');
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
  RxList<Map> addedItems = RxList([]);

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
    super.onInit();
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

  addNewItem() {
    addedItems.add({
      'date': textToDate(DateTime.now()),
      'item': itemId.value,
      'item_name': item.text,
      'pay': pay.value.text,
      'receive': receive.value.text,
      'comment': comments.value.text
    });
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
}
