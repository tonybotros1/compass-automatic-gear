import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Models/salesman/salesman_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import 'main_screen_contro.dart';
import 'websocket_controller.dart';

class SalesManController extends GetxController {
  TextEditingController name = TextEditingController();
  TextEditingController target = TextEditingController();
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(false);
  final RxList<SalesmanModel> allSalesMan = RxList<SalesmanModel>([]);
  final RxList<SalesmanModel> filteredSalesMan = RxList<SalesmanModel>([]);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  WebSocketService ws = Get.find<WebSocketService>();
  String backendUrl = backendTestURI;

  @override
  void onInit() {
    connectWebSocket();
    getSalesMan();
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
        case "salesman_added":
          final newCounter = SalesmanModel.fromJson(message["data"]);
          allSalesMan.add(newCounter);
          break;

        case "salesman_updated":
          final updated = SalesmanModel.fromJson(message["data"]);
          final index = allSalesMan.indexWhere((m) => m.id == updated.id);
          if (index != -1) {
            allSalesMan[index] = updated;
          }
          break;

        case "salesman_deleted":
          final deletedId = message["data"]["_id"];
          allSalesMan.removeWhere((m) => m.id == deletedId);
          break;
      }
    });
  }

  Future<void> getSalesMan() async {
    try {
      isScreenLoding.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/salesman/get_all_salesman');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List salesman = decoded["salesman"];
        allSalesMan.assignAll(
          salesman.map((man) => SalesmanModel.fromJson(man)),
        );
        isScreenLoding.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getSalesMan();
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

  Future<void> addNewSaleMan() async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/salesman/add_new_salesman');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name.text,
          "target": double.tryParse(target.text) ?? 0,
        }),
      );
      if (response.statusCode == 200) {
        addingNewValue.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewSaleMan();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        addingNewValue.value = false;
        logout();
      } else {
        addingNewValue.value = false;
      }
      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  Future<void> deleteSaleman(String salemanId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/salesman/delete_salesman/$salemanId');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewSaleMan();
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

  Future<void> editSaleMan(String id) async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/salesman/update_salesman/$id');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name.text,
          "target": double.tryParse(target.text) ?? 0,
        }),
      );
      if (response.statusCode == 200) {
        addingNewValue.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await editSaleMan(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        addingNewValue.value = false;
        logout();
      } else {
        addingNewValue.value = false;
      }
      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allSalesMan.sort((screen1, screen2) {
        final String? value1 = screen1.name;
        final String? value2 = screen2.name;

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allSalesMan.sort((screen1, screen2) {
        final String value1 = screen1.target.toString();
        final String value2 = screen2.target.toString();

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allSalesMan.sort((screen1, screen2) {
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
  void filterSalesMan() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredSalesMan.clear();
    } else {
      filteredSalesMan.assignAll(
        allSalesMan.where((saleman) {
          return saleman.name.toString().toLowerCase().contains(query) ||
              saleman.target.toString().toLowerCase().contains(query) ||
              saleman.createdAt.toString().toLowerCase().contains(query);
        }).toList(),
      );
    }
  }
}
