import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/payroll elements/based_elements_model.dart';
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
  TextEditingController functionName = TextEditingController();
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
  RxBool indirect = RxBool(false);
  String backendUrl = backendTestURI;
  WebSocketService ws = Get.find<WebSocketService>();
  RxList<PayrollElementsModel> allPayrollElements =
      RxList<PayrollElementsModel>([]);
  RxString currentPayrollElementId = RxString('');
  RxInt initTypePickersValue = RxInt(1);

  // based elements section
  RxBool addingNewBasedElementValue = RxBool(false);
  RxList<BasedElementsModel> basedElementsList = RxList<BasedElementsModel>([]);
  TextEditingController basedElementName = TextEditingController();
  RxString basedElementNameId = RxString('');
  TextEditingController basedElementType = TextEditingController();

  RxMap allBasedElementTypes = RxMap({
    '1': {'name': 'Add'},
    '2': {'name': 'Subtract'},
  });

  RxMap elementTypes = RxMap({
    '1': {'name': 'Earning'},
    '2': {'name': 'Deduction'},
    '3': {'name': 'Information'},
  });

  RxMap functions = RxMap({
    '1': {'name': 'PY_INPUT_VALUE_FF'},
    '2': {'name': 'PY_ANNUAL_LEAVE_FF'},
    '3': {'name': 'PY_UNPAID_LEAVE_FF'},
    '4': {'name': 'PY_SICK_LEAVE_FF'},
    '5': {'name': 'PY_MATERNITY_LEAVE_FF'},
    '6': {'name': 'PY_COMPASSIONATE_LEAVE_FF'},
  });

  List<Widget> contactsTabs = const [Tab(text: 'Based Elements')];

  @override
  void onInit() async {
    connectWebSocket();
    super.onInit();
  }

  Future<Map<String, dynamic>> getAllPayrollElements(String elementId) async {
    return await helper.getAllPayrollElementsForPayrollElements(elementId);
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

  void onChooseForTypePicker(int i) {
    switch (i) {
      case 1:
        initTypePickersValue.value = 1;
        elementTypeFilter.clear();
        filterSearch();
        break;
      case 2:
        initTypePickersValue.value = 2;
        elementTypeFilter.text = 'Earning';
        filterSearch();
        break;
      case 3:
        initTypePickersValue.value = 3;
        elementTypeFilter.text = 'Deduction';
        filterSearch();
        break;
      case 4:
        initTypePickersValue.value = 3;
        elementTypeFilter.text = 'Information';
        filterSearch();
        break;

      default:
    }
  }

  Future<PayrollElementsModel> getPayrollElementDetails(
    String payrollElementId,
  ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/payroll_elements/get_payroll_element_details/$payrollElementId',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        PayrollElementsModel details = PayrollElementsModel.fromJson(
          decoded['details'],
        );
        return details;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getPayrollElementDetails(payrollElementId);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      return PayrollElementsModel();
    } catch (e) {
      return PayrollElementsModel();
    }
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
        "function": functionName.text,
        "is_allow_override": allowOverride.value,
        "is_recurring": recurring.value,
        "is_entry_value": entryValue.value,
        "is_standard_link": standardLink.value,
        "is_indirect": indirect.value,
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

  Future<void> addNewBasedElements() async {
    try {
      addingNewBasedElementValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/payroll_elements/add_new_based_element/${currentPayrollElementId.value}',
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
      Uri url = Uri.parse(
        '$backendUrl/payroll_elements/update_based_element/$id',
      );
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

  Future<void> deleteBasedElement(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/payroll_elements/delete_based_element/$id',
      );
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
    elementKey.clear();
    elementName.clear();
    elementType.clear();
    elementPriority.clear();
    elementComment.clear();
    indirect.value = false;
    currentPayrollElementId.value = '';
    allowOverride.value = false;
    recurring.value = false;
    entryValue.value = false;
    standardLink.value = false;
    functionName.clear();
  }

  void clearSearchValues() {
    elementKeyFilter.clear();
    elementNameFilter.clear();
    elementTypeFilter.clear();
    elementPriorityFilter.clear();
  }

  Future<void> loadValues(String payrollElementId) async {
    PayrollElementsModel details = await getPayrollElementDetails(
      payrollElementId,
    );
    currentPayrollElementId.value = details.id ?? '';
    functionName.text = details.function ?? '';
    elementKey.text = details.key ?? '';
    elementName.text = details.name ?? '';
    elementPriority.text = details.priority ?? '';
    elementComment.text = details.comments ?? '';
    elementType.text = details.type ?? '';
    allowOverride.value = details.isAllowOverride ?? false;
    recurring.value = details.isRecurring ?? false;
    entryValue.value = details.isEntryValue ?? false;
    standardLink.value = details.isStandardLink ?? false;
    indirect.value = details.isIndirect ?? false;
    basedElementsList.assignAll(details.elementDetails ?? []);
  }
}
