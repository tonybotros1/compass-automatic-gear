import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Models/list_of_values/list_model.dart';
import '../../Models/list_of_values/value_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import 'main_screen_contro.dart';
import 'websocket_controller.dart';

class ListOfValuesController extends GetxController {
  late TextEditingController listName = TextEditingController();
  late TextEditingController code = TextEditingController();
  late TextEditingController masteredByForList = TextEditingController();
  late TextEditingController valueName = TextEditingController();
  late TextEditingController masteredBy = TextEditingController();
  RxString queryForLists = RxString('');
  Rx<TextEditingController> searchForLists = TextEditingController().obs;
  RxString queryForValues = RxString('');
  Rx<TextEditingController> searchForValues = TextEditingController().obs;
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool isScreenLoding = RxBool(false);
  final GlobalKey<FormState> formKeyForAddingNewList = GlobalKey<FormState>();
  final RxList<ValueModel> allValues = RxList<ValueModel>([]);
  final RxMap<String, dynamic> filteredLists = <String, dynamic>{}.obs;
  final RxList<ValueModel> filteredValues = RxList<ValueModel>([]);
  RxBool addingNewListProcess = RxBool(false);
  RxBool editingListProcess = RxBool(false);
  RxBool loadingValues = RxBool(false);
  RxBool addingNewListValue = RxBool(false);
  RxString listIDToWorkWithNewValue = RxString('');
  RxMap<String, dynamic> listMap = RxMap<String, dynamic>({});
  RxMap valueMap = RxMap({});
  RxString masteredByIdForList = RxString('');
  RxString masteredByIdForValues = RxString('');
  WebSocketService ws = Get.find<WebSocketService>();
  String backendUrl = backendTestURI;

  @override
  void onInit() {
    connectWebSocket();
    getLists();

    super.onInit();
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  void connectWebSocket() {
    ws.events.listen((message) {
      switch (message["type"]) {
        case "list_added":
          final newList = ListModel.fromJson(message["data"]);
          listMap[newList.id] = newList.toJson();
          break;

        case "list_updated":
          final updated = ListModel.fromJson(message["data"]);
          if (listMap.containsKey(updated.id)) {
            listMap[updated.id] = updated.toJson();
          }
          break;

        case "list_deleted":
          final deletedId = message["data"]["_id"];
          listMap.remove(deletedId);
          break;

        case "list_value_added":
          final newModel = ValueModel.fromJson(message["data"]);
          allValues.add(newModel);
          break;

        case "list_value_updated":
          final updated = ValueModel.fromJson(message["data"]);
          final index = allValues.indexWhere((m) => m.id == updated.id);
          if (index != -1) {
            allValues[index] = updated;
          }
          break;

        case "list_value_deleted":
          final deletedId = message["data"]["_id"];
          allValues.removeWhere((m) => m.id == deletedId);
          break;
      }
    });
  }

  // ===================================== Lists Section =============================================

  Future<void> getLists() async {
    try {
      isScreenLoding.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendUrl/list_of_values/get_all_lists');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List<dynamic> jsonDate = decoded["all_lists"];
        listMap.value = {for (var menu in jsonDate) menu['_id']: menu};

        isScreenLoding.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getLists();
        } else if (refreshed == RefreshResult.invalidToken) {
          isScreenLoding.value = false;
          logout();
        }
      } else if (response.statusCode == 401) {
        isScreenLoding.value = false;
        logout();
      } else {
        isScreenLoding.value = false;
      }
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  // this function is to add new list
  Future<void> addNewList() async {
    try {
      addingNewListProcess.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendUrl/list_of_values/add_new_list');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": listName.text,
          "code": code.text,
          "mastered_by": masteredByIdForList.value,
        }),
      );
      if (response.statusCode == 200) {
        addingNewListProcess.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewList();
        } else if (refreshed == RefreshResult.invalidToken) {
          addingNewListProcess.value = false;
          logout();
        }
      } else if (response.statusCode == 401) {
        addingNewListProcess.value = false;
        logout();
      } else {
        addingNewListProcess.value = false;
      }

      Get.back();
    } catch (e) {
      addingNewListProcess.value = false;
    }
  }

  Future<void> editList(String listId) async {
    try {
      editingListProcess.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendUrl/list_of_values/update_list/$listId');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": listName.text,
          "code": code.text,
          "mastered_by": masteredByIdForList.value,
        }),
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewList();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      editingListProcess.value = false;
      Get.back();
    } catch (e) {
      editingListProcess.value = true;
    }
  }

  // thisfunction is to delete a list
  Future<void> deleteList(String listId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendUrl/list_of_values/remove_list/$listId');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteList(listId);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }

      Get.back();
    } catch (e) {
      Get.back();
    }
  }

  // ===================================== Values Section =============================================

  Future<void> getListValues(String listId, String masteredBy) async {
    try {
      loadingValues.value = true;
      valueMap.clear();
      allValues.clear();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendUrl/list_of_values/get_list_values/$listId?mastered_by_list_id=$masteredBy',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List<dynamic> listValues = decoded["list_values"];
        List<dynamic> masterValues = decoded["master_values"];
        allValues.assignAll(
          listValues.map((country) => ValueModel.fromJson(country)).toList(),
        );
        valueMap.value = {for (var v in masterValues) v['_id']: v};
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getListValues(listId, masteredBy);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      loadingValues.value = false;
    } catch (e) {
      loadingValues.value = false;
    }
  }

  Future<void> addNewValue(String listId) async {
    try {
      addingNewListValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendUrl/list_of_values/add_new_value/$listId');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": valueName.text,
          "mastered_by_id": masteredByIdForValues.value,
        }),
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewValue(listId);
        } else if (refreshed == RefreshResult.invalidToken) {
          Get.back();
          logout();
        }
      } else if (response.statusCode == 401) {
        Get.back();
        logout();
      }
      addingNewListValue.value = false;
      Get.back();
    } catch (e) {
      addingNewListValue.value = false;
      Get.back();
    }
  }

  // this function is to delete a value from list
  Future<void> deleteValue(String valueId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendUrl/list_of_values/delete_value/$valueId');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteValue(valueId);
        } else if (refreshed == RefreshResult.invalidToken) {
          Get.back();
          logout();
        }
      } else if (response.statusCode == 401) {
        Get.back();
        logout();
      }
      Get.back();
    } catch (e) {
      Get.back();
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  Future<void> editValue(String valueId) async {
    try {
      addingNewListValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/list_of_values/update_value/$valueId');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": valueName.text,
          "mastered_by_id": masteredByIdForValues.value,
        }),
      );
      if (response.statusCode == 200) {
        addingNewListValue.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteValue(valueId);
        } else if (refreshed == RefreshResult.invalidToken) {
          Get.back();
          logout();
        }
      } else if (response.statusCode == 401) {
        Get.back();
        logout();
      }
      addingNewListValue.value = false;
      Get.back();
    } catch (e) {
      addingNewListValue.value = false;
      // Get.back();
    }
  }

  // this function is to sort data in table
  void onSortForLists(int columnIndex, bool ascending) {
    final entries = listMap.entries.toList();

    if (columnIndex == 0) {
      entries.sort((screen1, screen2) {
        final String? value1 = screen1.value['code'];
        final String? value2 = screen2.value['code'];
        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      entries.sort((screen1, screen2) {
        final String? value1 = screen1.value['name'];
        final String? value2 = screen2.value['name'];

        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      entries.sort((screen1, screen2) {
        final String? value1 = screen1.value['createdAt'] as String?;
        final String? value2 = screen2.value['createdAt'] as String?;
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
    if (columnIndex == 0) {
      allValues.sort((screen1, screen2) {
        final String value1 = screen1.name;
        final String value2 = screen2.name;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allValues.sort((screen1, screen2) {
        final String value1 = screen1.masteredBy;
        final String value2 = screen2.masteredBy;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allValues.sort((screen1, screen2) {
        final String value1 = screen1.createdAt.toString();
        final String value2 = screen2.createdAt.toString();

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

  void filterLists() {
    final query = searchForLists.value.text.toLowerCase();
    filteredLists.clear();

    if (query.isEmpty) return;

    filteredLists.assignAll(
      Map.fromEntries(
        listMap.entries.where((entry) {
          final name = entry.value['name']?.toString().toLowerCase() ?? '';
          final code = entry.value['code']?.toString().toLowerCase() ?? '';
          return name.contains(query) || code.contains(query);
        }),
      ),
    );
  }

  // this function is to filter the search results for web
  void filterValues() {
    queryForValues.value = searchForValues.value.text.toLowerCase();
    if (queryForValues.value.isEmpty) {
      filteredValues.clear();
    } else {
      filteredValues.assignAll(
        allValues.where((value) {
          return value.name.toString().toLowerCase().contains(queryForValues) ||
              value.masteredBy.toString().toLowerCase().contains(
                queryForValues,
              );
        }).toList(),
      );
    }
  }
}
