import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_screen_contro.dart';

class ListOfValuesController extends GetxController {
  late TextEditingController listName = TextEditingController();
  late TextEditingController code = TextEditingController();
  late TextEditingController masteredByForList = TextEditingController();
  late TextEditingController valueName = TextEditingController();
  late TextEditingController restrictedBy = TextEditingController();
  RxString queryForLists = RxString('');
  Rx<TextEditingController> searchForLists = TextEditingController().obs;
  RxString queryForValues = RxString('');
  Rx<TextEditingController> searchForValues = TextEditingController().obs;
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool isScreenLoding = RxBool(true);
  final GlobalKey<FormState> formKeyForAddingNewList = GlobalKey<FormState>();
  final RxList<DocumentSnapshot> allLists = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> allValues = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredLists = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredValues = RxList<DocumentSnapshot>([]);
  RxBool addingNewListProcess = RxBool(false);
  RxBool editingListProcess = RxBool(false);
  RxBool deletingListProcess = RxBool(false);
  RxBool loadingValues = RxBool(false);
  RxBool addingNewListValue = RxBool(false);
  RxString listIDToWorkWithNewValue = RxString('');
  RxString userEmail = RxString('');
  RxMap listMap = RxMap({});
  RxMap valueMap = RxMap({});
  RxString masteredByIdForList = RxString('');
  RxString masteredByIdForValues = RxString('');

  @override
  void onInit() {
    getUserEmail().then((_) {
      getLists();
    });
    searchForLists.value.addListener(() {
      filterLists();
    });
    searchForValues.value.addListener(() {
      filterValues();
    });
    super.onInit();
  }

  getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  getUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userEmail.value = prefs.getString('userEmail')!;
  }

  // this function is to sort data in table
  void onSortForLists(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allLists.sort((screen1, screen2) {
        final String? value1 = screen1.get('code');
        final String? value2 = screen2.get('code');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allLists.sort((screen1, screen2) {
        final String? value1 = screen1.get('list_name');
        final String? value2 = screen2.get('list_name');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allLists.sort((screen1, screen2) {
        final String? value1 = screen1.get('added_date');
        final String? value2 = screen2.get('added_date');

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

  void onSortForValues(int columnIndex, bool ascending) {
    // if (columnIndex == 0) {
    //   allValues.sort((screen1, screen2) {
    //     final String? value1 = screen1.get('code');
    //     final String? value2 = screen2.get('code');

    //     // Handle nulls: put nulls at the end
    //     if (value1 == null && value2 == null) return 0;
    //     if (value1 == null) return 1;
    //     if (value2 == null) return -1;

    //     return compareString(ascending, value1, value2);
    //   });
    // }

    if (columnIndex == 0) {
      allValues.sort((screen1, screen2) {
        final String? value1 = screen1.get('name');
        final String? value2 = screen2.get('name');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allValues.sort((screen1, screen2) {
        final String? value1 = screen1.get('restricted_by');
        final String? value2 = screen2.get('restricted_by');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allValues.sort((screen1, screen2) {
        final String? value1 = screen1.get('added_date');
        final String? value2 = screen2.get('added_date');

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

  // this function is to filter the search results for web
  void filterLists() {
    queryForLists.value = searchForLists.value.text.toLowerCase();
    if (queryForLists.value.isEmpty) {
      filteredLists.clear();
    } else {
      filteredLists.assignAll(
        allLists.where((list) {
          return list['list_name']
                  .toString()
                  .toLowerCase()
                  .contains(queryForLists) ||
              list['code'].toString().toLowerCase().contains(queryForLists);
        }).toList(),
      );
    }
  }

  // this function is to filter the search results for web
  void filterValues() {
    queryForValues.value = searchForValues.value.text.toLowerCase();
    if (queryForValues.value.isEmpty) {
      filteredValues.clear();
    } else {
      filteredValues.assignAll(
        allValues.where((value) {
          return value['name']
                  .toString()
                  .toLowerCase()
                  .contains(queryForValues) ||
              getValueNameById(value['restricted_by'])
                  .toString()
                  .toLowerCase()
                  .contains(queryForValues);
        }).toList(),
      );
    }
  }

  getLists() {
    try {
      var lists = FirebaseFirestore.instance.collection('all_lists');

      if (userEmail.value == 'datahubai@gmail.com') {
        lists.snapshots().listen((lists) {
          listMap.clear();
          listMap.value = {for (var doc in lists.docs) doc.id: doc.data()};

          allLists.assignAll(List<DocumentSnapshot>.from(lists.docs));
          isScreenLoding.value = false;
        });
      } else {
        lists.where('is_public', isEqualTo: true).snapshots().listen((lists) {
          listMap.clear();
          listMap.value = {for (var doc in lists.docs) doc.id: doc.data()};
          allLists.assignAll(List<DocumentSnapshot>.from(lists.docs));
          isScreenLoding.value = false;
        });
      }
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  String getListNameById(String? listId) {
    if (listId == null) return '';

    final entry = listMap[listId];
    return entry != null && entry.containsKey('list_name')
        ? entry['list_name'] as String
        : '';
  }

  String getValueNameById(listId) {
    if (listId == null) return '';
    final entry = valueMap[listId];
    return entry != null && entry.containsKey('name') ? entry['name'] : '';
  }

  // String? getValueNameById(listId) {
  //   if (listId == null) return '';
  //   return valueMap.entries
  //       .firstWhere(
  //         (entry) => entry.key == listId,
  //         orElse: () =>
  //             const MapEntry('', ''), // Handle the case where no entry is found
  //       )
  //       .value;
  // }

  getListValues(listId, masterBtId) {
    try {
      loadingValues.value = true;

      if (userEmail.value == 'datahubai@gmail.com') {
        FirebaseFirestore.instance
            .collection('all_lists')
            .doc(listId)
            .collection('values')
            .orderBy('name', descending: false)
            .snapshots()
            .listen((values) {
          allValues.assignAll(List<DocumentSnapshot>.from(values.docs));
        });
        FirebaseFirestore.instance
            .collection('all_lists')
            .doc(masterBtId)
            .collection('values')
            .snapshots()
            .listen((values) {
          valueMap.clear();
          valueMap.value = {for (var doc in values.docs) doc.id: doc.data()};
          loadingValues.value = false;
          // for (var value in values.docs) {
          //   valueMap[value.id] = value.data()['name'];
          // }
        });
      } else {
        FirebaseFirestore.instance
            .collection('all_lists')
            .doc(listId)
            .collection('values')
            .where('available', isEqualTo: true)
            .snapshots()
            .listen((values) {
          allValues.assignAll(List<DocumentSnapshot>.from(values.docs));
          loadingValues.value = false;
        });
      }
    } catch (e) {
      loadingValues.value = false;
    }
  }

// this function is to add new value to the selected list
  addNewValue(listId) async {
    try {
      addingNewListValue.value = true;
      await FirebaseFirestore.instance
          .collection('all_lists')
          .doc(listId)
          .collection('values')
          .add({
        'name': valueName.text,
        'available': true,
        'restricted_by': masteredByIdForValues.value,
        'added_date': DateTime.now().toString(),
      });

      addingNewListValue.value = false;
      Get.back();
    } catch (e) {
      addingNewListValue.value = false;
    }
  }

// this function is to delete a value from list
  deleteValue(listId, valueId) async {
    try {
      await FirebaseFirestore.instance
          .collection('all_lists')
          .doc(listId)
          .collection('values')
          .doc(valueId)
          .delete();
      Get.back();
    } catch (e) {
//
    }
  }

  editValue(listId, valueId) async {
    try {
      await FirebaseFirestore.instance
          .collection('all_lists')
          .doc(listId)
          .collection('values')
          .doc(valueId)
          .update({
        'name': valueName.text,
        'restricted_by': masteredByIdForValues.value,
      });

      Get.back();
    } catch (e) {
      print(e);
    }
  }

  editHideOrUnhide(listId, valueId, bool status) async {
    try {
      await FirebaseFirestore.instance
          .collection('all_lists')
          .doc(listId)
          .collection('values')
          .doc(valueId)
          .update({
        'available': status,
      });
    } catch (e) {
//
    }
  }

  editPublicOrPrivate(listId, bool status) async {
    try {
      await FirebaseFirestore.instance
          .collection('all_lists')
          .doc(listId)
          .update({
        'is_public': status,
      });
    } catch (e) {
//
    }
  }

// this function is to add new list
  addNewList() async {
    try {
      addingNewListProcess.value = true;
      await FirebaseFirestore.instance.collection('all_lists').add({
        'list_name': listName.text,
        'code': code.text,
        'added_date': DateTime.now().toString(),
        'is_public': true,
        'mastered_by': masteredByIdForList.value,
      });
      addingNewListProcess.value = false;
      Get.back();
    } catch (e) {
      addingNewListProcess.value = false;
    }
  }

// thisfunction is to delete a list
  deleteList(listId) async {
    try {
      deletingListProcess.value = true;
      await FirebaseFirestore.instance
          .collection('all_lists')
          .doc(listId)
          .delete();
      deletingListProcess.value = false;

      Get.back();
    } catch (e) {
      deletingListProcess.value = false;
    }
  }

  editList(listId) async {
    try {
      editingListProcess.value = true;
      await FirebaseFirestore.instance
          .collection('all_lists')
          .doc(listId)
          .update({
        'list_name': listName.text,
        'code': code.text,
        'mastered_by': masteredByIdForList.value,
      });
      editingListProcess.value = false;
      Get.back();
    } catch (e) {
      editingListProcess.value = true;
    }
  }
}
