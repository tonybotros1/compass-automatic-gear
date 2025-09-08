import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../consts.dart';
import 'main_screen_contro.dart';

class TechnicianController extends GetxController {
  TextEditingController name = TextEditingController();
  TextEditingController job = TextEditingController();
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(true);
  final RxList<DocumentSnapshot> allTechnician = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredTechnicians =
      RxList<DocumentSnapshot>([]);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  RxString companyId = RxString('');

  @override
  void onInit() async {
    await getCompanyId();
    getAllTechnicians();
    search.value.addListener(() {
      filterTechnicians();
    });
    super.onInit();
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  Future<void> getCompanyId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId.value = prefs.getString('companyId')!;
  }

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allTechnician.sort((counter1, counter2) {
        final String? value1 = counter1.get('name');
        final String? value2 = counter2.get('name');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allTechnician.sort((counter1, counter2) {
        final String? value1 = counter1.get('job');
        final String? value2 = counter2.get('job');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allTechnician.sort((counter1, counter2) {
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

  void getAllTechnicians() {
    try {
      FirebaseFirestore.instance
          .collection('all_technicians')
          .where('company_id', isEqualTo: companyId.value)
          .snapshots()
          .listen((tech) {
        allTechnician.assignAll(List<DocumentSnapshot>.from(tech.docs));
        isScreenLoding.value = false;
      });
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  Future<void> addNewTechnicians() async {
    try {
      addingNewValue.value = true;
      await FirebaseFirestore.instance.collection('all_technicians').add({
        'name': name.text,
        'job': job.text,
        'added_date': DateTime.now().toString(),
        'company_id': companyId.value,
      });
      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  Future<void> deleteTechnician(String techId) async {
    try {
      Get.back();
      await FirebaseFirestore.instance
          .collection('all_technicians')
          .doc(techId)
          .delete();
    } catch (e) {
      //
    }
  }

  Future<void> editTechnician(String techId) async {
    try {
      Get.back();
      await FirebaseFirestore.instance
          .collection('all_technicians')
          .doc(techId)
          .update({
        'name': name.text,
        'job': job.text,
      });
    } catch (e) {
      //
    }
  }

  // this function is to filter the search results for web
  void filterTechnicians() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredTechnicians.clear();
    } else {
      filteredTechnicians.assignAll(
        allTechnician.where((saleman) {
          return saleman['name'].toString().toLowerCase().contains(query) ||
              saleman['job'].toString().toLowerCase().contains(query) ||
              textToDate(saleman['added_date'])
                  .toString()
                  .toLowerCase()
                  .contains(query);
        }).toList(),
      );
    }
  }
}
