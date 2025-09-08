import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datahubai/Controllers/Main%20screen%20controllers/main_screen_contro.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../consts.dart';

class JobTasksController extends GetxController {
  TextEditingController nameEN = TextEditingController();
  TextEditingController nameAR = TextEditingController();
  TextEditingController points = TextEditingController();
  TextEditingController category = TextEditingController();
  Rx<TextEditingController> search = TextEditingController().obs;
  RxString query = RxString('');
  RxBool isScreenLoding = RxBool(true);
  final RxList<DocumentSnapshot> allTasks = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredTasks = RxList<DocumentSnapshot>([]);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxString companyId = RxString('');
  RxBool addingNewValue = RxBool(false);

  @override
  void onInit() async {
    await getCompanyId();
    getAllTasks();
    search.value.addListener(() {
      filterTasks();
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

  void getAllTasks() {
    try {
      FirebaseFirestore.instance
          .collection('all_job_tasks')
          .where('company_id', isEqualTo: companyId.value)
          .snapshots()
          .listen((tech) {
        allTasks.assignAll(List<DocumentSnapshot>.from(tech.docs));
        isScreenLoding.value = false;
      });
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  Future<void> addNewTask() async {
    try {
      addingNewValue.value = true;
      await FirebaseFirestore.instance.collection('all_job_tasks').add({
        'name_en': nameEN.text,
        'name_ar': nameAR.text,
        'points': points.text,
        'category': category.text,
        'added_date': DateTime.now().toString(),
        'company_id': companyId.value,
      });
      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  Future<void> editTask(String id) async {
    try {
      addingNewValue.value = true;
      await FirebaseFirestore.instance
          .collection('all_job_tasks')
          .doc(id)
          .update({
        'name_en': nameEN.text,
        'name_ar': nameAR.text,
        'points': points.text,
        'category': category.text,
      });
      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('all_job_tasks')
          .doc(id)
          .delete();
      Get.back();
    } catch (e) {
//
    }
  }

  // this function is to filter the search results for web
  void filterTasks() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredTasks.clear();
    } else {
      filteredTasks.assignAll(
        allTasks.where((task) {
          return task['name_en'].toString().toLowerCase().contains(query) ||
              task['name_ar'].toString().contains(query) ||
              task['points'].toString().contains(query) ||
              task['category'].toString().contains(query) ||
              textToDate(task['added_date'])
                  .toString()
                  .toLowerCase()
                  .contains(query);
        }).toList(),
      );
    }
  }
}
