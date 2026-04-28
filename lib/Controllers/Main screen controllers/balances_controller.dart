import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/balances models/balances_model.dart';
import '../../Models/payroll elements/based_elements_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import 'main_screen_contro.dart';
import 'websocket_controller.dart';

class BalancesController extends GetxController {
  TextEditingController balanceNameFilter = TextEditingController();
  TextEditingController balanceTypeFilter = TextEditingController();
  TextEditingController balanceName = TextEditingController();
  TextEditingController balanceType = TextEditingController();
  TextEditingController balanceDescription = TextEditingController();
  RxBool showOnPayroll = RxBool(false);
  RxBool showOnLeave = RxBool(false);
  RxBool showOnAssignment = RxBool(false);
  RxBool isScreenLoding = RxBool(false);
  RxList<BalancesModel> allBalances = RxList<BalancesModel>();
  RxBool addingNewValue = RxBool(false);
  List<Widget> contactsTabs = const [Tab(text: 'Based Elements')];
  RxList<BasedElementsModel> basedElementsList = RxList<BasedElementsModel>([]);
  WebSocketService ws = Get.find<WebSocketService>();
  RxString currentBalanceId = RxString('');
  String backendUrl = backendTestURI;
  RxBool addingNewBasedElementValue = RxBool(false);
  TextEditingController basedElementName = TextEditingController();
  RxString basedElementNameId = RxString('');
  TextEditingController basedElementType = TextEditingController();

  RxMap balanceTypes = RxMap({
    '1': {'name': 'Value'},
    '2': {'name': 'Number'},
  });

  RxMap allBasedElementTypes = RxMap({
    '1': {'name': 'Add'},
    '2': {'name': 'Subtract'},
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
          case "hr_balance_added":
            final newDoc = BalancesModel.fromJson(message["data"]);
            allBalances.add(newDoc);
            break;

          case "hr_balance_updated":
            final updated = BalancesModel.fromJson(message["data"]);
            final index = allBalances.indexWhere((m) => m.id == updated.id);
            if (index != -1) {
              allBalances[index] = updated;
            }
            break;

          case "hr_balance_deleted":
            final deletedId = message["data"]["_id"];
            allBalances.removeWhere((m) => m.id == deletedId);
            break;
        }
      } catch (e) {
        // print(e);
      }
    });
  }

  Future<Map<String, dynamic>> getAllPayrollElements(String elementId) async {
    return await helper.getAllPayrollElementsForPayrollElements(elementId);
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  Future<BalancesModel> getBalanceDetails(String payrollElementId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/balance/get_balance_details/$payrollElementId',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        BalancesModel details = BalancesModel.fromJson(decoded['details']);
        return details;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getBalanceDetails(payrollElementId);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      return BalancesModel();
    } catch (e) {
      return BalancesModel();
    }
  }

  Future<void> addNewBalance() async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Map data = {
        "name": balanceName.text,
        "type": balanceType.text,
        "description": balanceDescription.text,
        "show_on_payroll": showOnPayroll.value,
        "show_on_assignment": showOnAssignment.value,
        "show_on_leave": showOnLeave.value,
      };
      if (currentBalanceId.value.isEmpty) {
        Uri addingurl = Uri.parse('$backendUrl/balance/add_new_balance');

        final response = await http.post(
          addingurl,
          headers: {
            'Authorization': 'Bearer $accessToken',
            "Content-Type": "application/json",
          },
          body: jsonEncode(data),
        );
        if (response.statusCode == 200) {
          final decoded = jsonDecode(response.body);
          currentBalanceId.value = decoded['added_balance_id'];
        } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
          final refreshed = await helper.refreshAccessToken(refreshToken);
          if (refreshed == RefreshResult.success) {
            await addNewBalance();
          } else if (refreshed == RefreshResult.invalidToken) {
            logout();
          }
        } else if (response.statusCode == 401) {
          logout();
        }
      } else {
        Uri updatingurl = Uri.parse(
          '$backendUrl/balance/update_balance/${currentBalanceId.value}',
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
            await addNewBalance();
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

  Future<void> deleteBalance(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/balance/delete_balance/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteBalance(id);
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

    if (balanceNameFilter.text.isNotEmpty) {
      body["name"] = balanceNameFilter.text;
    }

    if (balanceTypeFilter.text.isNotEmpty) {
      body["type"] = balanceTypeFilter.text;
    }
    print(body);

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
      Uri url = Uri.parse('$backendUrl/balance/search_engine_for_balance');
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
        List docs = decoded['balances'];
        allBalances.assignAll(docs.map((job) => BalancesModel.fromJson(job)));
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

  Future<void> addNewBasedElements() async {
    try {
      addingNewBasedElementValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/balance/add_new_based_element/${currentBalanceId.value}',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": basedElementNameId.value,
          "type": basedElementType.text,
        }),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        String addedID = decoded["added_based_element_id"];
        basedElementsList.add(
          BasedElementsModel(
            elementNameValue: basedElementName.text,
            elementName: basedElementNameId.value,
            type: basedElementType.text,
            id: addedID,
          ),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewBasedElements();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      addingNewBasedElementValue.value = false;
      Get.back();
    } catch (e) {
      addingNewBasedElementValue.value = false;
    }
  }

  Future<void> updateBasedElements(String id) async {
    try {
      addingNewBasedElementValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/balance/update_based_element/$id');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": basedElementNameId.value,
          "type": basedElementType.text,
        }),
      );
      if (response.statusCode == 200) {
        BasedElementsModel updatedElement = BasedElementsModel(
          elementNameValue: basedElementName.text,
          elementName: basedElementNameId.value,
          type: basedElementType.text,
          id: id,
        );
        int index = basedElementsList.indexWhere((i) => i.id == id);
        basedElementsList[index] = updatedElement;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await updateBasedElements(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      addingNewBasedElementValue.value = false;
      Get.back();
    } catch (e) {
      addingNewBasedElementValue.value = false;
    }
  }

  Future<void> deleteBasedElement(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/balance/delete_based_element/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        basedElementsList.removeWhere((i) => i.id == id);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteBasedElement(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
    } catch (e) {
      //
    }
  }

  void clearValues() {
    currentBalanceId.value = '';
    balanceName.clear();
    balanceType.clear();
    balanceDescription.clear();
    showOnAssignment.value = false;
    showOnLeave.value = false;
    showOnPayroll.value = false;
    basedElementsList.clear();
  }

  void clearSearchValues() {
    balanceNameFilter.clear();
    balanceTypeFilter.clear();
  }

  Future<void> loadValues(String balanceId) async {
    BalancesModel details = await getBalanceDetails(balanceId);
    currentBalanceId.value = details.id ?? '';
    balanceName.text = details.name ?? '';
    balanceType.text = details.type ?? '';
    balanceDescription.text = details.description ?? '';
    showOnAssignment.value = details.showInAssignment ?? false;
    showOnLeave.value = details.showInLeave ?? false;
    showOnPayroll.value = details.showInPayroll ?? false;
    basedElementsList.assignAll(details.elementDetails ?? []);
  }
}
