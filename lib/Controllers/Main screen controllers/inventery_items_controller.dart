import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_screen_contro.dart';

class InventeryItemsController extends GetxController {
  TextEditingController code = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController minQuantity = TextEditingController();
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(false);
  final RxList<DocumentSnapshot> allItems = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredItems = RxList<DocumentSnapshot>([]);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  RxString companyId = RxString('');

  @override
  void onInit() async {
    await getCompanyId();
    getAllItems();
    search.value.addListener(() {
      filterItems();
    });
    super.onInit();
  }

  Future<void> getCompanyId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId.value = prefs.getString('companyId')!;
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  void addNewItem() {
    try {
      addingNewValue.value = true;
      FirebaseFirestore.instance.collection('inventery_items').add({
        'company_id': companyId.value,
        'name': name.text,
        'code': code.text,
        'min_quantity': int.tryParse(minQuantity.text) ?? 0,
        'added_date': DateTime.now().toString(),
      });
      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  void editItem(String id) {
    try {
      addingNewValue.value = true;

      FirebaseFirestore.instance.collection('inventery_items').doc(id).update({
        'name': name.text,
        'code': code.text,
        'min_quantity': int.tryParse(minQuantity.text) ?? 0,
      });
      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  void getAllItems() {
    try {
      isScreenLoding.value = true;
      FirebaseFirestore.instance
          .collection('inventery_items')
          .where('company_id', isEqualTo: companyId.value)
          .snapshots()
          .listen((currencies) {
            allItems.assignAll(List<DocumentSnapshot>.from(currencies.docs));
            isScreenLoding.value = false;
          });
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  Future<void> deleteItem(String id) async {
    Get.back();
    await FirebaseFirestore.instance
        .collection('inventery_items')
        .doc(id)
        .delete();
  }

  // this function is to filter the search results for web
  void filterItems() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredItems.clear();
    } else {
      filteredItems.assignAll(
        allItems.where((currency) {
          return currency['code'].toString().toLowerCase().contains(query) ||
              currency['name'].toString().toLowerCase().contains(query) ||
              currency['min_quantity'].toString().toLowerCase().contains(query);
        }).toList(),
      );
    }
  }
}
