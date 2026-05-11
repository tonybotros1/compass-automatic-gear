import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/leave types/leave_types_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import 'main_screen_contro.dart';
import 'websocket_controller.dart';

class LeaveTypesController extends GetxController {
  final GlobalKey<FormState> leaveTypeFormKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController nameFilter = TextEditingController();
  TextEditingController code = TextEditingController();
  TextEditingController codeFilter = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController typeFilter = TextEditingController();
  TextEditingController basedElement = TextEditingController();
  TextEditingController basedElementFilter = TextEditingController();
  RxString basedElementId = RxString('');
  RxString basedElementFilterId = RxString('');
  RxBool isCalendarDaysSelected = RxBool(false);
  String backendUrl = backendTestURI;
  RxInt initTypePickersValue = RxInt(1);
  RxBool isScreenLoding = RxBool(false);
  RxBool addingNewValue = RxBool(false);
  RxList<LeaveTypesModel> allLeaveTypes = RxList<LeaveTypesModel>([]);
  WebSocketService ws = Get.find<WebSocketService>();
  StreamSubscription? _leaveTypeEventsSubscription;

  @override
  void onInit() {
    connectWebSocket();
    filterSearch();
    super.onInit();
  }

  @override
  void onClose() {
    _leaveTypeEventsSubscription?.cancel();
    name.dispose();
    nameFilter.dispose();
    code.dispose();
    codeFilter.dispose();
    type.dispose();
    typeFilter.dispose();
    basedElement.dispose();
    basedElementFilter.dispose();
    super.onClose();
  }

  Future<Map<String, dynamic>> getAllPayrollElements() async {
    return await helper.getAllPayrollElements();
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  void connectWebSocket() {
    _leaveTypeEventsSubscription?.cancel();
    _leaveTypeEventsSubscription = ws.events.listen((message) {
      try {
        switch (message["type"]) {
          case "leave_type_added":
            final newLeaveType = LeaveTypesModel.fromJson(message["data"]);
            _upsertLeaveType(newLeaveType);
            break;

          case "leave_type_updated":
            final updated = LeaveTypesModel.fromJson(message["data"]);
            _upsertLeaveType(updated);
            break;

          case "leave_type_deleted":
            final deletedId = message["data"]["_id"];
            allLeaveTypes.removeWhere((m) => m.id == deletedId);
            break;
        }
      } catch (e) {
        //
      }
    });
  }

  void _upsertLeaveType(LeaveTypesModel leaveType) {
    final id = leaveType.id;
    if (id == null || id.isEmpty) return;
    final index = allLeaveTypes.indexWhere((m) => m.id == id);
    if (index == -1) {
      allLeaveTypes.insert(0, leaveType);
    } else {
      allLeaveTypes[index] = leaveType;
    }
  }

  Map<String, dynamic> _jsonObject(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (e) {
      //
    }
    return {};
  }

  LeaveTypesModel _currentLeaveType({String? id}) {
    return LeaveTypesModel(
      id: id,
      name: name.text,
      code: code.text,
      type: isCalendarDaysSelected.isTrue ? 'Calendar Days' : 'Working Days',
      basedElement: basedElement.text,
      basedElementId: basedElementId.value,
    );
  }

  bool _validateLeaveType() {
    if (!(leaveTypeFormKey.currentState?.validate() ?? false)) return false;
    if (name.text.trim().isEmpty) {
      alertMessage(context: Get.context!, content: 'Please enter leave name');
      return false;
    }
    if (code.text.trim().isEmpty) {
      alertMessage(context: Get.context!, content: 'Please enter leave code');
      return false;
    }
    if (basedElementId.value.trim().isEmpty) {
      alertMessage(
        context: Get.context!,
        content: 'Please select based element',
      );
      return false;
    }
    return true;
  }

  void clearValues() {
    leaveTypeFormKey.currentState?.reset();
    name.clear();
    code.clear();
    type.clear();
    basedElement.clear();
    basedElementId.value = '';
    isCalendarDaysSelected.value = false;
  }

  void selectCalenderOrWorkingDays(String type, bool value) {
    isCalendarDaysSelected.value = value;
  }

  void onChooseForTypePicker(int i) {
    switch (i) {
      case 1:
        initTypePickersValue.value = 1;
        typeFilter.clear();
        filterSearch();
        break;
      case 2:
        initTypePickersValue.value = 2;
        typeFilter.text = 'Calendar Days';
        filterSearch();
        break;
      case 3:
        initTypePickersValue.value = 3;
        typeFilter.text = 'Working Days';
        filterSearch();
        break;

      default:
    }
  }

  Future<void> addNewLeaveType() async {
    try {
      if (!_validateLeaveType()) return;

      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/leave_types/add_new_leave_type');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name.text,
          "code": code.text,
          "type": isCalendarDaysSelected.isTrue
              ? 'Calendar Days'
              : 'Working Days',
          "based_element": basedElementId.value,
        }),
      );
      if (response.statusCode == 200) {
        final decoded = _jsonObject(response.body);
        final addedId =
            decoded['added_leave_type_id']?.toString() ??
            decoded['added_type_id']?.toString() ??
            decoded['_id']?.toString();
        if (addedId != null && addedId.isNotEmpty) {
          _upsertLeaveType(_currentLeaveType(id: addedId));
        }
        await filterSearch();
        addingNewValue.value = false;
        Get.back();
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewLeaveType();
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
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  Future<void> editLeaveType(String id) async {
    try {
      if (id.isEmpty) return;
      if (!_validateLeaveType()) return;

      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/leave_types/update_leave_type/$id');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name.text,
          "code": code.text,
          "type": isCalendarDaysSelected.isTrue
              ? 'Calendar Days'
              : 'Working Days',
          "based_element": basedElementId.value,
        }),
      );
      if (response.statusCode == 200) {
        _upsertLeaveType(_currentLeaveType(id: id));
        await filterSearch();
        addingNewValue.value = false;
        Get.back();
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await editLeaveType(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      addingNewValue.value = false;
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  Future<bool> deleteLeaveType(String typeId) async {
    try {
      if (typeId.isEmpty) return false;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/leave_types/delete_leave_type/$typeId');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        allLeaveTypes.removeWhere((m) => m.id == typeId);
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await deleteLeaveType(typeId);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> filterSearch() async {
    Map<String, dynamic> body = {};
    if (nameFilter.text.isNotEmpty) {
      body["name"] = nameFilter.text;
    }
    if (codeFilter.text.isNotEmpty) {
      body["code"] = codeFilter.text;
    }
    if (typeFilter.text.isNotEmpty) {
      body["type"] = typeFilter.text;
    }
    if (basedElementFilterId.value.isNotEmpty) {
      body["based_element"] = basedElementFilterId.value;
    }

    if (body.isNotEmpty) {
      return await searchEngine(body);
    } else {
      return await searchEngine({"all": true});
    }
  }

  Future<void> searchEngine(Map<String, dynamic> body) async {
    try {
      isScreenLoding.value = true;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/leave_types/search_engine_for_leave_types',
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
        final decoded = _jsonObject(response.body);
        List docs = decoded['leave_types'] ?? [];
        allLeaveTypes.assignAll(
          docs.whereType<Map<String, dynamic>>().map(
            (doc) => LeaveTypesModel.fromJson(doc),
          ),
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
    codeFilter.clear();
    typeFilter.clear();
    basedElementFilter.clear();
    basedElementFilterId.value = '';
    initTypePickersValue.value = 1;
    filterSearch();
  }
}
