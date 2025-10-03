import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/system variables/system_variables_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import 'main_screen_contro.dart';
import 'websocket_controller.dart';

class SystemVariablesController extends GetxController {
  TextEditingController code = TextEditingController();
  TextEditingController value = TextEditingController();
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(false);
  final RxList<SystemVariablesModel> allVariables =
      RxList<SystemVariablesModel>([]);
  final RxList<SystemVariablesModel> filteredVariables =
      RxList<SystemVariablesModel>([]);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  String backendUrl = backendTestURI;
  WebSocketService ws = Get.find<WebSocketService>();

  @override
  void onInit() {
    connectWebSocket();
    getVariables();
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
        case "variable_added":
          final newCounter = SystemVariablesModel.fromJson(message["data"]);
          allVariables.add(newCounter);
          break;

        case "variable_updated":
          final updated = SystemVariablesModel.fromJson(message["data"]);
          final index = allVariables.indexWhere((m) => m.id == updated.id);
          if (index != -1) {
            allVariables[index] = updated;
          }
          break;

        case "variable_deleted":
          final deletedId = message["data"]["_id"];
          allVariables.removeWhere((m) => m.id == deletedId);
          break;
      }
    });
  }

  Future<void> getVariables() async {
    try {
      isScreenLoding.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/system_variables/get_all_sys_variables');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List variables = decoded["results"];
        allVariables.assignAll(
          variables.map((variable) => SystemVariablesModel.fromJson(variable)),
        );
        isScreenLoding.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getVariables();
        } else if (refreshed == RefreshResult.invalidToken) {
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

  Future<void> addNewVariable() async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/system_variables/add_new_variable');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({"code": code.text, "value": value.text}),
      );
      if (response.statusCode == 200) {
        addingNewValue.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewVariable();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
      Get.back();
    }
  }

  Future<void> updateVariable(String id) async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/system_variables/update_variable/$id');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({"code": code.text, "value": value.text}),
      );
      if (response.statusCode == 200) {
        addingNewValue.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await updateVariable(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
      Get.back();
    }
  }

  Future<void> deleteVariable(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/system_variables/delete_variable/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteVariable(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      Get.back();
    } catch (e) {
      //
    }
  }

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allVariables.sort((screen1, screen2) {
        final String? value1 = screen1.code;
        final String? value2 = screen2.code;

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allVariables.sort((screen1, screen2) {
        final String? value1 = screen1.value;
        final String? value2 = screen2.value;

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allVariables.sort((screen1, screen2) {
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

  // this function is to filter the search results for web
  void filterVariables() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredVariables.clear();
    } else {
      filteredVariables.assignAll(
        allVariables.where((variable) {
          return variable.code.toString().toLowerCase().contains(query) ||
              variable.value.toString().toLowerCase().contains(query);
        }).toList(),
      );
    }
  }
}
