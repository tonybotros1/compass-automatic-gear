import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../consts.dart';

class InvoiceItemsController extends GetxController {
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(true);
  final RxList<DocumentSnapshot> allInvoiceItems = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredInvoiceItems =
      RxList<DocumentSnapshot>([]);
  final GlobalKey<FormState> formKeyForAddingNewvalue = GlobalKey<FormState>();
  RxString companyId = RxString('');
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);

  @override
  void onInit() {
    getCompanyId();
    getAllInvoiceItems();
    search.value.addListener(() {
      filterCurrencies();
    });
    super.onInit();
  }

  @override
  void onClose() {
    search.value.removeListener(filterCurrencies);
    name.dispose();
    description.dispose();
    price.dispose();
    search.value.dispose();
    super.onClose();
  }

  getCompanyId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId.value = prefs.getString('companyId')!;
  }

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allInvoiceItems.sort((counter1, counter2) {
        final String? value1 = counter1.get('name');
        final String? value2 = counter2.get('name');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allInvoiceItems.sort((counter1, counter2) {
        final String? value1 = counter1.get('description');
        final String? value2 = counter2.get('description');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allInvoiceItems.sort((counter1, counter2) {
        final String? value1 = counter1.get('price');
        final String? value2 = counter2.get('price');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 3) {
      allInvoiceItems.sort((counter1, counter2) {
        final String? value1 = counter1.get('added_date');
        final String? value2 = counter2.get('added_date');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    }
    sortColumnIndex.value = columnIndex;
    isAscending.value = ascending;
  }

  int compareString(bool ascending, String value1, String value2) {
    int comparison = value1.compareTo(value2);
    return ascending ? comparison : -comparison; // Reverse if descending
  }

  getAllInvoiceItems() {
    try {
      FirebaseFirestore.instance
          .collection('invoice_items')
          .snapshots()
          .listen((items) {
        allInvoiceItems.assignAll(List<DocumentSnapshot>.from(items.docs));
        isScreenLoding.value = false;
      });
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  addNewInvoiceItem() async {
    try {
      addingNewValue.value = true;
      await FirebaseFirestore.instance.collection('invoice_items').add({
        'name': name.text,
        'description': description.text,
        'price': double.parse(price.text),
        'added_date': DateTime.now().toString(),
        'company_id': companyId.value,
      });
      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  editInvoiceItem(itemId) async {
    try {
      Get.back();
      await FirebaseFirestore.instance
          .collection('invoice_items')
          .doc(itemId)
          .update({
        'name': name.text,
        'description': description.text,
        'price': double.parse(price.text),
      });
    } catch (e) {
      //
    }
  }

  deleteInvoiceItem(itemId) {
    try {
      Get.back();
      FirebaseFirestore.instance
          .collection('invoice_items')
          .doc(itemId)
          .delete();
    } catch (e) {
      //
    }
  }

  // this function is to filter the search results for web
  void filterCurrencies() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredInvoiceItems.clear();
    } else {
      filteredInvoiceItems.assignAll(
        allInvoiceItems.where((saleman) {
          return saleman['description']
                  .toString()
                  .toLowerCase()
                  .contains(query) ||
              saleman['name'].toString().toLowerCase().contains(query) ||
              saleman['price'].toString().toLowerCase().contains(query) ||
              textToDate(saleman['added_date'])
                  .toString()
                  .toLowerCase()
                  .contains(query);
        }).toList(),
      );
    }
  }
}
