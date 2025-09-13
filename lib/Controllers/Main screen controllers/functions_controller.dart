import 'dart:convert';
import 'package:datahubai/Models/menus_functions_roles/screens_model.dart';
import 'package:datahubai/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../consts.dart';
import 'main_screen_contro.dart';
import 'websocket_controller.dart';

class FunctionsController extends GetxController {
  late TextEditingController screenName = TextEditingController();
  late TextEditingController route = TextEditingController();
  late TextEditingController description = TextEditingController();
  // final RxList<DocumentSnapshot> allScreens = RxList<DocumentSnapshot>([]);
  final RxList<FunctionsModel> allScreens = RxList<FunctionsModel>([]);
  // final RxList<DocumentSnapshot> filteredScreens = RxList<DocumentSnapshot>([]);
  final RxList<FunctionsModel> filteredScreens = RxList<FunctionsModel>([]);
  RxBool isScreenLoding = RxBool(false);
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool addingNewScreenProcess = RxBool(false);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  String backendUrl = backendTestURI;
  Helpers helper = Helpers();
  WebSocketService ws = Get.find<WebSocketService>();

  @override
  void onInit() {
    connectWebSocket();
    getScreens();
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
        case "screen_created":
          final newBrand = FunctionsModel.fromJson(message["data"]);
          allScreens.add(newBrand);
          break;

        case "screen_updated":
          final updated = FunctionsModel.fromJson(message["data"]);
          final index = allScreens.indexWhere((s) => s.id == updated.id);
          if (index != -1) {
            allScreens[index] = updated;
          }
          break;

        case "screen_deleted":
          final deletedId = message["data"]["_id"];
          allScreens.removeWhere((s) => s.id == deletedId);
          break;
      }
    });
  }

  Future<void> getScreens() async {
    try {
      isScreenLoding.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendTestURI/functions/get_screens');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List screens = decoded["screens"];
        allScreens.assignAll(
          screens.map((screen) => FunctionsModel.fromJson(screen)),
        );
        isScreenLoding.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getScreens();
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

  Future<void> addNewScreen() async {
    try {
      addingNewScreenProcess.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendTestURI/functions/add_screen');
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          "name": screenName.text,
          "route_name": route.text,
          "description": description.text,
        }),
      );
      if (response.statusCode == 200) {
        addingNewScreenProcess.value = false;
        Get.back();
        showSnackBar('Done', 'Screen added successfully');
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewScreen();
        } else if (refreshed == RefreshResult.invalidToken) {
          addingNewScreenProcess.value = false;
          logout();
        }
      } else if (response.statusCode == 401) {
        addingNewScreenProcess.value = false;
        logout();
      } else {
        Get.back();
        addingNewScreenProcess.value = false;
        showSnackBar('Alert', 'Something went wrong please try again');
      }
    } catch (e) {
      addingNewScreenProcess.value = false;
      Get.back();
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  Future<void> deleteScreen(String screenId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendUrl/functions/delete_screen/$screenId');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        Get.back();
        showSnackBar('Done', 'Screen deleted successfully');
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteScreen(screenId);
        } else if (refreshed == RefreshResult.invalidToken) {
          Get.back();
          logout();
        }
      } else if (response.statusCode == 401) {
        Get.back();
        logout();
      } else {
        Get.back();
        showSnackBar('Alert', 'Something went wrong please try again');
      }
    } catch (e) {
      Get.back();
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  Future<void> editScreen(String screenId) async {
    try {
      addingNewScreenProcess.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendUrl/functions/edit_screen/$screenId');
      final response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          "name": screenName.text,
          "screen_route": route.text,
          "description": description.text,
        }),
      );
      if (response.statusCode == 200) {
        addingNewScreenProcess.value = false;
        Get.back();
        showSnackBar('Done', 'Screen updated successfully');
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await editScreen(screenId);
        } else if (refreshed == RefreshResult.invalidToken) {
          addingNewScreenProcess.value = false;
          logout();
        }
      } else if (response.statusCode == 401) {
        addingNewScreenProcess.value = false;
        logout();
      } else {
        addingNewScreenProcess.value = false;
        Get.back();
        showSnackBar('Alert', 'Something went wrong please try again');
      }
    } catch (e) {
      addingNewScreenProcess.value = false;
      Get.back();
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allScreens.sort((screen1, screen2) {
        final String value1 = screen1.name;
        final String value2 = screen2.name;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allScreens.sort((screen1, screen2) {
        final String value1 = screen1.routeName;
        final String value2 = screen2.routeName;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allScreens.sort((screen1, screen2) {
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
  void filterScreens() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredScreens.clear();
    } else {
      filteredScreens.assignAll(
        allScreens.where((screen) {
          return screen.name.toString().toLowerCase().contains(query);
        }).toList(),
      );
    }
  }
}
