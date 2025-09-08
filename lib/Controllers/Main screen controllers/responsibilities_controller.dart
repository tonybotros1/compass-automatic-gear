import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../Models/menus_functions_roles/menus_model.dart';
import '../../Models/menus_functions_roles/roles_model.dart';
import '../../consts.dart';
import 'main_screen_contro.dart';
import 'package:http/http.dart' as http;

class ResponsibilitiesController extends GetxController {
  final RxMap<String, dynamic> allResponsibilities = RxMap<String, dynamic>({});
  final RxMap<String, dynamic> filteredResponsibilities =
      RxMap<String, dynamic>({});
  RxBool addingNewResponsibilityProcess = RxBool(false);
  TextEditingController responsibilityName = TextEditingController();
  TextEditingController menuName = TextEditingController();
  RxString menuIDFromList = RxString('');
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoading = RxBool(false);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxMap<String, bool> updatingStatus = RxMap<String, bool>({});
  RxMap<String, dynamic> allMenus = RxMap<String, dynamic>({});
  RxList selectedRow = RxList([]);
  WebSocketChannel? channel;
  String backendUrl = backendTestURI;
  @override
  void onInit() {
    connectWebSocket();
    getMenus();
    getResponsibilities();
    super.onInit();
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  // function to manage loading button
  void setButtonLoading(String menuId, bool isLoading) {
    updatingStatus[menuId] = isLoading;
    updatingStatus.refresh(); // Notify listeners
  }

  void connectWebSocket() {
    channel = WebSocketChannel.connect(Uri.parse(webSocketURL));

    channel!.stream.listen((event) {
      final message = jsonDecode(event);

      switch (message["type"]) {
        case "role_created":
          final newMenu = RoleModel.fromJson(message["data"]);
          allResponsibilities[newMenu.id] = newMenu.toJson();
          break;

        case "role_updated":
          final updated = RoleModel.fromJson(message["data"]);
          if (allResponsibilities.containsKey(updated.id)) {
            allResponsibilities[updated.id] = updated.toJson();
          }
          break;

        case "role_deleted":
          final deletedId = message["data"]["_id"];
          allResponsibilities.remove(deletedId);
      }
    });
  }

  Future<void> getMenus() async {
    try {
      var url = Uri.parse('$backendUrl/menus/get_menus');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<MenuModel> menuList = (decoded["menus"] as List)
            .map((json) => MenuModel.fromJson(json))
            .toList();
        allMenus.value = {for (var menu in menuList) menu.id: menu.toJson()};
      }
    } catch (e) {
      //
    }
  }

  // this functions is to get the Responsibilities in system and its details
  Future<void> getResponsibilities() async {
    try {
      isScreenLoading.value = true;
      var url = Uri.parse('$backendUrl/responsibilities/get_all_roles');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<RoleModel> roleList = (decoded["roles"] as List)
            .map((json) => RoleModel.fromJson(json))
            .toList();
        allResponsibilities.value = {
          for (var role in roleList) role.id: role.toJson(),
        };
        isScreenLoading.value = false;
      }
    } catch (e) {
      isScreenLoading.value = false;
    }
  }

  Future<void> updateRoleStatus(String roleId, bool status) async {
    try {
      updatingStatus[roleId] = true;
      var url = Uri.parse(
        '$backendUrl/responsibilities/update_role_status/$roleId',
      );
      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": status}),
      );
      if (response.statusCode != 200) {
        updatingStatus[roleId] = false;

        showSnackBar('Alert', 'Ststus did not change');
      } else {
        updatingStatus[roleId] = false;
      }
    } catch (e) {
      updatingStatus[roleId] = false;

      showSnackBar('Alert', 'Ststus did not change');
    }
  }

  Future<void> addNewResponsibility() async {
    try {
      addingNewResponsibilityProcess.value = true;
      var url = Uri.parse('$backendUrl/responsibilities/add_new_role');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "role_name": responsibilityName.text,
          "menu_id": menuIDFromList.value,
        }),
      );
      if (response.statusCode == 200) {
        addingNewResponsibilityProcess.value = false;
        Get.back();
        showSnackBar('Done', 'Responsibility added successfully');
      } else {
        addingNewResponsibilityProcess.value = false;
        Get.back();
        showSnackBar('Alert', 'Something went wrong please try again');
      }
    } catch (e) {
      addingNewResponsibilityProcess.value = false;
      Get.back();
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  Future<void> updateResponsibility(String roleID) async {
    try {
      addingNewResponsibilityProcess.value = true;
      var url = Uri.parse('$backendUrl/responsibilities/update_role/$roleID');
      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "role_name": responsibilityName.text,
          "menu_id": menuIDFromList.value,
        }),
      );
      if (response.statusCode == 200) {
        addingNewResponsibilityProcess.value = false;
        Get.back();
        showSnackBar('Done', 'Responsibility updated successfully');
      } else {
        addingNewResponsibilityProcess.value = false;
        Get.back();
        showSnackBar('Alert', 'Something went wrong please try again');
      }
      Get.back();
    } catch (e) {
      addingNewResponsibilityProcess.value = false;
      Get.back();
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  Future<void> deleteResponsibility(String resID) async {
    try {
      var url = Uri.parse('$backendUrl/responsibilities/delete_role/$resID');
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        Get.back();
      } else {
        Get.back();
        showSnackBar('Alert', 'Can\'t delete role');
      }
    } catch (e) {
      showSnackBar('Alert', 'Can\'t delete role');
    }
  }

  // ===========================================================================

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    // Convert allMenus map to a list of entries for sorting
    final entries = allResponsibilities.entries.toList();

    if (columnIndex == 0) {
      // Sort by 'name' field
      entries.sort((entry1, entry2) {
        final String? value1 = entry1.value['role_name'] as String?;
        final String? value2 = entry2.value['role_name'] as String?;

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      // Sort by 'added_date' field
      entries.sort((entry1, entry2) {
        final String? value1 = entry1.value['createdAt'] as String?;
        final String? value2 = entry2.value['createdAt'] as String?;

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    }

    // Re-construct the sorted map
    allResponsibilities
      ..clear()
      ..addEntries(entries);

    // Update sorting state
    sortColumnIndex.value = columnIndex;
    isAscending.value = ascending;
  }

  int compareString(bool ascending, String value1, String value2) {
    int comparison = value1.compareTo(value2);
    return ascending ? comparison : -comparison; // Reverse if descending
  }

  // Future<void> deleteResponsibility(String resID) async {
  //   try {
  //     final firestore = FirebaseFirestore.instance;

  //     var users = await FirebaseFirestore.instance
  //         .collection('sys-users')
  //         .where('roles', arrayContains: resID)
  //         .get();

  //     WriteBatch batch = firestore.batch();

  //     for (var doc in users.docs) {
  //       batch.update(doc.reference, {
  //         'roles': FieldValue.arrayRemove([resID]),
  //       });
  //     }
  //     await batch.commit();
  //     await firestore.collection('sys-roles').doc(resID).delete();
  //     Get.back();
  //     // await getResponsibilities();
  //   } catch (e) {
  //     //
  //   }
  // }

  // void addNewResponsibility() {
  //   try {
  //     if (menuIDFromList.isEmpty) {
  //       showSnackBar('Can not complete', 'please try again later');
  //     } else {
  //       FirebaseFirestore.instance.collection('sys-roles').add({
  //         'role_name': responsibilityName.text,
  //         'menuID': menuIDFromList.value,
  //         'added_date': DateTime.now().toString(),
  //         'is_shown_for_users': true,
  //       });
  //       Get.back();
  //     }
  //   } catch (e) {
  //     //
  //   }
  // }

  // this function is to filter the search results for web
  void filterResponsibilities() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredResponsibilities.clear();
    } else {
      filteredResponsibilities.assignAll(
        Map.fromEntries(
          allResponsibilities.entries
              .where(
                (entry) =>
                    entry.value['role_name'].toString().toLowerCase().contains(
                      query.value,
                    ) ||
                    entry.value['menu_name'].toString().toLowerCase().contains(
                      query.value,
                    ) ||
                    entry.value['menu_code'].toString().toLowerCase().contains(
                      query.value,
                    ),
              )
              .map(
                (entry) =>
                    MapEntry(entry.key, entry.value as Map<String, dynamic>),
              ),
        ),
      );
    }
  }
}
