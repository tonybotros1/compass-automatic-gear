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
  RxList<LegislationModel> allLegislations = RxList<LegislationModel>([]);
  String backendUrl = backendTestURI;
  WebSocketService ws = Get.find<WebSocketService>();

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

        // case "branch_status_updated":
        //   final branchId = message["data"]['_id'];
        //   final branchStatus = message["data"]['status'];
        //   final index = allBranches.indexWhere((m) => m.id == branchId);
        //   if (index != -1) {
        //     allBranches[index].status = branchStatus;
        //     allBranches.refresh();
        //   }
        //   break;

        // case "branch_updated":
        //   final updated = BranchesModel.fromJson(message["data"]);
        //   final index = allBranches.indexWhere((m) => m.id == updated.id);
        //   if (index != -1) {
        //     allBranches[index] = updated;
        //   }
        //   break;

        // case "branch_deleted":
        //   final deletedId = message["data"]["_id"];
        //   allBranches.removeWhere((m) => m.id == deletedId);
        //   break;
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
        body: jsonEncode({"name": name.text}),
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
}
