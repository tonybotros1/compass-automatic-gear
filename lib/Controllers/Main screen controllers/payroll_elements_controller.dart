import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/payroll elements/payroll_elements_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import 'main_screen_contro.dart';
import 'websocket_controller.dart';

class PayrollElementsController extends GetxController {
  RxBool isScreenLoding = RxBool(false);
  RxBool addingNewValue = RxBool(false);
  TextEditingController elementName = TextEditingController();
  TextEditingController elementNameFilter = TextEditingController();
  TextEditingController elementType = TextEditingController();
  TextEditingController elementTypeFilter = TextEditingController();
  TextEditingController elementPriority = TextEditingController();
  TextEditingController elementPriorityFilter = TextEditingController();
  TextEditingController elementComment = TextEditingController();
  TextEditingController elementCommentFilter = TextEditingController();
  TextEditingController elementKey = TextEditingController();
  TextEditingController elementKeyFilter = TextEditingController();
  RxBool allowOverride = RxBool(false);
  RxBool recurring = RxBool(false);
  RxBool entryValue = RxBool(false);
  RxBool standardLink = RxBool(false);
  String backendUrl = backendTestURI;
  WebSocketService ws = Get.find<WebSocketService>();
  RxList<PayrollElementsModel> allPayrollElements =
      RxList<PayrollElementsModel>([]);
  RxString currentPayrollElementId = RxString('');
  RxInt initTypePickersValue = RxInt(1);

  RxMap elementTypes = RxMap({
    '1': {'name': 'Earning'},
    '2': {'name': 'Deduction'},
    '3': {'name': 'Information'},
  });

  @override
  void onInit() async {
    connectWebSocket();
    super.onInit();
  }

  void connectWebSocket() {
    ws.events.listen((message) {
      try {
        switch (message["type"]) {
          case "payroll_element_added":
            final newDoc = PayrollElementsModel.fromJson(message["data"]);
            allPayrollElements.add(newDoc);
            break;

          case "payroll_element_updated":
            final updated = PayrollElementsModel.fromJson(message["data"]);
            final index = allPayrollElements.indexWhere(
              (m) => m.id == updated.id,
            );
            if (index != -1) {
              allPayrollElements[index] = updated;
            }
            break;

          case "payroll_element_deleted":
            final deletedId = message["data"]["_id"];
            allPayrollElements.removeWhere((m) => m.id == deletedId);
            break;
        }
      } catch (e) {
        // print(e);
      }
    });
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  Future<void> addNewPayrollElement() async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Map data = {
        "key": elementKey.text,
        "name": elementName.text,
        "type": elementType.text,
        "priority": elementPriority.text,
        "comments": elementComment.text,
        "is_allow_override": allowOverride.value,
        "is_recurring": recurring.value,
        "is_entry_value": entryValue.value,
        "is_standard_link": standardLink.value,
      };
      if (currentPayrollElementId.value.isEmpty) {
        Uri addingurl = Uri.parse(
          '$backendUrl/payroll_elements/add_new_payroll_element',
        );

        final response = await http.post(
          addingurl,
          headers: {
            'Authorization': 'Bearer $accessToken',
            "Content-Type": "application/json",
          },
          body: jsonEncode(data),
        );
        if (response.statusCode == 200) {
        } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
          final refreshed = await helper.refreshAccessToken(refreshToken);
          if (refreshed == RefreshResult.success) {
            await addNewPayrollElement();
          } else if (refreshed == RefreshResult.invalidToken) {
            logout();
          }
        } else if (response.statusCode == 401) {
          logout();
        }
      } else {
        Uri updatingurl = Uri.parse(
          '$backendUrl/payroll_elements/update_payroll_element/${currentPayrollElementId.value}',
        );

        final response = await http.patch(
          updatingurl,
          headers: {
            'Authorization': 'Bearer $accessToken',
            "Content-Type": "application/json",
          },
          body: jsonEncode(data),
        );
        if (response.statusCode == 200) {
        } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
          final refreshed = await helper.refreshAccessToken(refreshToken);
          if (refreshed == RefreshResult.success) {
            await addNewPayrollElement();
          } else if (refreshed == RefreshResult.invalidToken) {
            logout();
          }
        } else if (response.statusCode == 401) {
          logout();
        }
      }

      addingNewValue.value = false;
    } catch (e) {
      addingNewValue.value = false;
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  Future<void> deletePayrollElement(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/payroll_elements/delete_payroll_element/$id',
      );
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deletePayrollElement(id);
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
    if (elementKeyFilter.text.isNotEmpty) {
      body["key"] = elementKeyFilter.text;
    }
    if (elementNameFilter.text.isNotEmpty) {
      body["name"] = elementNameFilter.text;
    }
    if (elementPriorityFilter.text.isNotEmpty) {
      body["priority"] = elementPriorityFilter.text;
    }
    if (elementTypeFilter.text.isNotEmpty) {
      body["type"] = elementTypeFilter.text;
    }
    if (elementCommentFilter.text.isNotEmpty) {
      body["comments"] = elementCommentFilter.text;
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
        '$backendUrl/payroll_elements/search_engine_for_payroll_elements',
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
        List docs = decoded['payroll_elements'];
        allPayrollElements.assignAll(
          docs.map((job) => PayrollElementsModel.fromJson(job)),
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

  void clearValues() {
    elementKey.clear();
    elementName.clear();
    elementType.clear();
    elementPriority.clear();
    allowOverride.value = false;
    recurring.value = false;
    entryValue.value = false;
    standardLink.value = false;
  }

   void clearSearchValues() {
    elementKeyFilter.clear();
    elementNameFilter.clear();
    elementTypeFilter.clear();
    elementPriorityFilter.clear();
   
  }

  void loadValues(PayrollElementsModel data) {
    currentPayrollElementId.value = data.id ?? '';
    elementKey.text = data.key ?? '';
    elementName.text = data.name ?? '';
    elementPriority.text = data.priority ?? '';
    elementComment.text = data.comments ?? '';
    elementType.text = data.type ?? '';
    allowOverride.value = data.allowOverride ?? false;
    recurring.value = data.recurring ?? false;
    entryValue.value = data.entryValue ?? false;
    standardLink.value = data.standardLink ?? false;
  }
}
