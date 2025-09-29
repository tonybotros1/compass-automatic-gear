import 'dart:convert';
import 'package:datahubai/Controllers/Main%20screen%20controllers/main_screen_contro.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/ap payment types/ap_payment_types_model.dart';
import '../../helpers.dart';
import 'websocket_controller.dart';

class ApPaymentTypeController extends GetxController {
  TextEditingController type = TextEditingController();
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(false);
  final RxList<APPaymentTypesModel> allApPaymentTypes =
      RxList<APPaymentTypesModel>([]);
  final RxList<APPaymentTypesModel> filteredApPaymentTypes =
      RxList<APPaymentTypesModel>([]);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxString companyId = RxString('');
  RxBool addingNewValue = RxBool(false);
  WebSocketService ws = Get.find<WebSocketService>();
  String backendUrl = backendTestURI;

  @override
  void onInit() async {
    connectWebSocket();
    getAllApPayementTypes();
    super.onInit();
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  // void tojson() async {
  //   Map jsonMap = {};
  //   var types = await FirebaseFirestore.instance
  //       .collection('ap_payment_types')
  //       .get();
  //   for (var type in types.docs) {
  //     jsonMap[type.id] = type['type'];
  //     print(type.id);
  //   }
  //   String jsonString = jsonEncode(jsonMap);
  //   final blob = html.Blob([jsonString]);
  //   final url = html.Url.createObjectUrlFromBlob(blob);
  //   final anchor = html.AnchorElement(href: url)
  //     ..setAttribute("download", "brands.json")
  //     ..click();
  //   html.Url.revokeObjectUrl(url);
  //   print("✅ brands.json downloaded!");
  // }

  void connectWebSocket() {
    ws.events.listen((message) {
      switch (message["type"]) {
        case "ap_payment_type_added":
          final newCounter = APPaymentTypesModel.fromJson(message["data"]);
          allApPaymentTypes.add(newCounter);
          break;

        case "ap_payment_type_updated":
          final updated = APPaymentTypesModel.fromJson(message["data"]);
          final index = allApPaymentTypes.indexWhere((m) => m.id == updated.id);
          if (index != -1) {
            allApPaymentTypes[index] = updated;
          }
          break;

        case "ap_payment_type_deleted":
          final deletedId = message["data"]["_id"];
          allApPaymentTypes.removeWhere((m) => m.id == deletedId);
          break;
      }
    });
  }

  Future<void> getAllApPayementTypes() async {
    try {
      isScreenLoding.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/ap_payment_types/get_all_ap_payment_types',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List types = decoded['types'];
        allApPaymentTypes.assignAll(
          types.map((type) => APPaymentTypesModel.fromJson(type)),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllApPayementTypes();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      isScreenLoding.value = false;
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  Future<void> addNewType() async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/ap_payment_types/add_new_ap_payment_type',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({'type': type.text}),
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewType();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  Future<void> updateType(String id) async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/ap_payment_types/update_new_ap_payment_type/$id',
      );
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({'type': type.text}),
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await updateType(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  Future<void> deleteType(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/ap_payment_types/delete_ap_payment_type/$id',
      );
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await updateType(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      Get.back();
    } catch (e) {
      showSnackBar('Alert', 'Something Went Wrong Please Try Again Later');
    }
  }

  // this function is to filter the search results for web
  void filterTypes() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredApPaymentTypes.clear();
    } else {
      filteredApPaymentTypes.assignAll(
        allApPaymentTypes.where((type) {
          return type.type.toString().toLowerCase().contains(query) ||
              textToDate(
                type.createdAt,
              ).toString().toLowerCase().contains(query);
        }).toList(),
      );
    }
  }
}
