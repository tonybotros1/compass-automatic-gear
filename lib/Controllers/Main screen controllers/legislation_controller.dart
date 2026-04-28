import 'dart:convert';

import 'package:datahubai/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/legislations model/legislation_model.dart';
import '../../helpers.dart';
import 'main_screen_contro.dart';
import 'websocket_controller.dart';

class LegislationController extends GetxController {
  RxBool isScreenLoding = RxBool(false);
  RxBool addingNewValue = RxBool(false);
  TextEditingController name = TextEditingController();
  TextEditingController nameFilter = TextEditingController();
  RxList<LegislationModel> allLegislations = RxList<LegislationModel>([]);
  String backendUrl = backendTestURI;
  WebSocketService ws = Get.find<WebSocketService>();

  // sick leave:
  TextEditingController numberOfPaidDays = TextEditingController();
  TextEditingController numberOfHalfPaidDays = TextEditingController();
  TextEditingController numberOfUnPaidDays = TextEditingController();

  // maternity leave:
  TextEditingController meternityNumberOfPaidDays = TextEditingController();

  // compassionate leave:
  TextEditingController compassionateLeaveNumberOfPaidDays =
      TextEditingController();
  final List<String> weekDays = const [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  RxList<String> selectedDays = RxList([]);

  @override
  void onInit() async {
    connectWebSocket();
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
        case "leg_added":
          final newDoc = LegislationModel.fromJson(message["data"]);
          allLegislations.add(newDoc);
          break;

        case "leg_updated":
          final updated = LegislationModel.fromJson(message["data"]);
          final index = allLegislations.indexWhere((m) => m.id == updated.id);
          if (index != -1) {
            allLegislations[index] = updated;
          }
          break;

        case "leg_deleted":
          final deletedId = message["data"]["_id"];
          allLegislations.removeWhere((m) => m.id == deletedId);
          break;
      }
    });
  }

  Future<void> addNewLegislation() async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/legislation/add_new_legislation');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name.text,
          "weekend": selectedDays,
          "number_of_paid_days_for_sick_leave": numberOfPaidDays.text.isNotEmpty
              ? numberOfPaidDays.text
              : "0",
          "number_of_half_paid_days_for_sick_leave":
              numberOfHalfPaidDays.text.isNotEmpty
              ? numberOfHalfPaidDays.text
              : "0",
          "number_of_unpaid_days_for_sick_leave":
              numberOfUnPaidDays.text.isNotEmpty
              ? numberOfUnPaidDays.text
              : "0",
          "number_of_paid_days_for_maternity_leave":
              meternityNumberOfPaidDays.text.isNotEmpty
              ? meternityNumberOfPaidDays.text
              : "0",
          "number_of_paid_days_for_compassionate_leave":
              compassionateLeaveNumberOfPaidDays.text.isNotEmpty
              ? compassionateLeaveNumberOfPaidDays.text
              : "0",
        }),
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewLegislation();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  Future<void> updateLegislation(String id) async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/legislation/update_legislation/$id');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name.text,
          "weekend": selectedDays,
          "number_of_paid_days_for_sick_leave": numberOfPaidDays.text.isNotEmpty
              ? numberOfPaidDays.text.trim()
              : "0",
          "number_of_half_paid_days_for_sick_leave":
              numberOfHalfPaidDays.text.isNotEmpty
              ? numberOfHalfPaidDays.text.trim()
              : "0",
          "number_of_unpaid_days_for_sick_leave":
              numberOfUnPaidDays.text.isNotEmpty
              ? numberOfUnPaidDays.text.trim()
              : "0",
          "number_of_paid_days_for_maternity_leave":
              meternityNumberOfPaidDays.text.isNotEmpty
              ? meternityNumberOfPaidDays.text
              : "0",
          "number_of_paid_days_for_compassionate_leave":
              compassionateLeaveNumberOfPaidDays.text.isNotEmpty
              ? compassionateLeaveNumberOfPaidDays.text
              : "0",
        }),
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await updateLegislation(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  Future<void> deletedLegislation(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/legislation/delete_legislation/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deletedLegislation(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      Get.back();
    } catch (e) {
      //
    }
  }

  void filterSearch() async {
    Map<String, dynamic> body = {};
    if (nameFilter.text.isNotEmpty) {
      body["name"] = nameFilter.text;
    }

    if (body.isNotEmpty) {
      await searchEngine(body);
    } else {
      await searchEngine({"all": true});
    }
  }

  Future<void> searchEngine(Map<String, dynamic> body) async {
    try {
      isScreenLoding.value = true;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/legislation/search_engine_for_legislations',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List docs = decoded['legislations_elements'];
        allLegislations.assignAll(
          docs.map((job) => LegislationModel.fromJson(job)),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await searchEngine(body);
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

  void clearAllFilters() {
    nameFilter.clear();
  }
}
