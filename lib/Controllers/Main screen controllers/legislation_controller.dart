import 'dart:async';
import 'dart:convert';

import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/legislations model/legislation_model.dart';
import '../../helpers.dart';
import 'main_screen_contro.dart';
import 'websocket_controller.dart';

class LegislationController extends GetxController {
  final GlobalKey<FormState> legislationFormKey = GlobalKey<FormState>();
  RxBool isScreenLoding = RxBool(false);
  RxBool addingNewValue = RxBool(false);
  TextEditingController name = TextEditingController();
  TextEditingController nameFilter = TextEditingController();
  RxList<LegislationModel> allLegislations = RxList<LegislationModel>([]);
  String backendUrl = backendTestURI;
  WebSocketService ws = Get.find<WebSocketService>();
  StreamSubscription? _legislationEventsSubscription;

  // sick leave:
  TextEditingController numberOfPaidDays = TextEditingController();
  TextEditingController numberOfHalfPaidDays = TextEditingController();
  TextEditingController numberOfUnPaidDays = TextEditingController();

  // maternity / paternity leave:
  TextEditingController meternityNumberOfPaidDays = TextEditingController();
  TextEditingController paternityNumberOfPaidDays = TextEditingController();

  // compassionate leave:
  TextEditingController compassionateLeaveNumberOfPaidDays =
      TextEditingController();

  // overtime:
  TextEditingController numberOfWorkingHoursForOvertimeNormal =
      TextEditingController();
  TextEditingController numberOfWorkingHoursForOvertimeHolidays =
      TextEditingController();

  // social security
  TextEditingController socialSecurityEmployee = TextEditingController();
  TextEditingController socialSecurityEmployer = TextEditingController();
  TextEditingController socialSecurityCeiling = TextEditingController();

  // gratiuty accrual
  TextEditingController gratuityFirst5Years = TextEditingController();
  TextEditingController gratuityAfter5Years = TextEditingController();

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
  void onInit() {
    super.onInit();
    connectWebSocket();
    filterSearch();
  }

  @override
  void onClose() {
    _legislationEventsSubscription?.cancel();
    name.dispose();
    nameFilter.dispose();
    numberOfPaidDays.dispose();
    numberOfHalfPaidDays.dispose();
    numberOfUnPaidDays.dispose();
    meternityNumberOfPaidDays.dispose();
    paternityNumberOfPaidDays.dispose();
    compassionateLeaveNumberOfPaidDays.dispose();
    numberOfWorkingHoursForOvertimeNormal.dispose();
    numberOfWorkingHoursForOvertimeHolidays.dispose();
    socialSecurityEmployee.dispose();
    socialSecurityEmployer.dispose();
    socialSecurityCeiling.dispose();
    gratuityFirst5Years.dispose();
    gratuityAfter5Years.dispose();
    super.onClose();
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  void connectWebSocket() {
    _legislationEventsSubscription?.cancel();
    _legislationEventsSubscription = ws.events.listen((message) {
      try {
        switch (message["type"]) {
          case "leg_added":
            final newDoc = LegislationModel.fromJson(message["data"]);
            _upsertLegislation(newDoc);
            break;

          case "leg_updated":
            final updated = LegislationModel.fromJson(message["data"]);
            _upsertLegislation(updated);
            break;

          case "leg_deleted":
            final deletedId = message["data"]["_id"]?.toString();
            allLegislations.removeWhere((m) => m.id == deletedId);
            break;
        }
      } catch (e) {
        //
      }
    });
  }

  void _upsertLegislation(LegislationModel legislation) {
    final id = legislation.id;
    if (id == null || id.isEmpty) return;
    final index = allLegislations.indexWhere((m) => m.id == id);
    if (index == -1) {
      allLegislations.insert(0, legislation);
    } else {
      allLegislations[index] = legislation;
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

  void _showError(String content) {
    final context = Get.context;
    if (context == null) return;
    alertMessage(context: context, content: content);
  }

  String _zeroIfEmpty(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? '0' : value;
  }

  int _intValue(TextEditingController controller) {
    final value = controller.text.trim();
    if (value.isEmpty) return 0;
    return int.tryParse(value) ?? double.tryParse(value)?.toInt() ?? 0;
  }

  double _doubleValue(TextEditingController controller) {
    final value = controller.text.trim();
    if (value.isEmpty) return 0;
    return double.tryParse(value) ?? 0;
  }

  bool _validateLegislation() {
    if (!(legislationFormKey.currentState?.validate() ?? false)) return false;
    if (name.text.trim().isEmpty) {
      _showError('Please enter legislation name');
      return false;
    }
    return true;
  }

  Map<String, dynamic> _legislationBody() {
    return {
      "name": name.text.trim(),
      "weekend": selectedDays.toList(),
      "number_of_paid_days_for_sick_leave": _zeroIfEmpty(numberOfPaidDays),
      "number_of_half_paid_days_for_sick_leave": _zeroIfEmpty(
        numberOfHalfPaidDays,
      ),
      "number_of_unpaid_days_for_sick_leave": _zeroIfEmpty(numberOfUnPaidDays),
      "number_of_paid_days_for_maternity_leave": _zeroIfEmpty(
        meternityNumberOfPaidDays,
      ),
      "number_of_paid_days_for_compassionate_leave": _zeroIfEmpty(
        compassionateLeaveNumberOfPaidDays,
      ),
      "number_of_paid_days_for_paternity_leave": _zeroIfEmpty(
        paternityNumberOfPaidDays,
      ),
      "number_of_working_hours_for_overtime_normal": _zeroIfEmpty(
        numberOfWorkingHoursForOvertimeNormal,
      ),
      "number_of_working_hours_for_overtime_holidays": _zeroIfEmpty(
        numberOfWorkingHoursForOvertimeHolidays,
      ),
      "social_security_employee_percentage": _zeroIfEmpty(
        socialSecurityEmployee,
      ),
      "social_security_employer_percentage": _zeroIfEmpty(
        socialSecurityEmployer,
      ),
      "social_security_ceiling": _zeroIfEmpty(socialSecurityCeiling),
      "gratuity_first_5_years": _zeroIfEmpty(gratuityFirst5Years),
      "gratuity_after_5_years": _zeroIfEmpty(gratuityAfter5Years),
    };
  }

  LegislationModel _currentLegislation({String? id}) {
    return LegislationModel(
      id: id,
      name: name.text.trim(),
      weekend: selectedDays.toList(),
      numberOfPaidDaysForSickLEave: _intValue(numberOfPaidDays),
      numberOfHalfPaidDaysForSickLEave: _intValue(numberOfHalfPaidDays),
      numberOfUnpaidDaysForSickLEave: _intValue(numberOfUnPaidDays),
      numberOfHalfPaidDaysForMaternityLEave: _intValue(
        meternityNumberOfPaidDays,
      ),
      numberOfHalfPaidDaysForPaternityLEave: _intValue(
        paternityNumberOfPaidDays,
      ),
      numberOfHalfPaidDaysForCompassionateLEave: _intValue(
        compassionateLeaveNumberOfPaidDays,
      ),
      numberOfWorkingHoursForOvertimeNormal: _doubleValue(
        numberOfWorkingHoursForOvertimeNormal,
      ),
      numberOfWorkingHoursForOvertimeHolidays: _doubleValue(
        numberOfWorkingHoursForOvertimeHolidays,
      ),
      socialSecurityEmployee: _doubleValue(socialSecurityEmployee),
      socialSecurityEmployer: _doubleValue(socialSecurityEmployer),
      socialSecurityCeiling: _doubleValue(socialSecurityCeiling),
      gratuityFirst5Years: _intValue(gratuityFirst5Years),
      gratuityAfter5Years: _intValue(gratuityAfter5Years),
    );
  }

  Future<void> addNewLegislation() async {
    try {
      if (addingNewValue.value) return;
      if (!_validateLegislation()) return;

      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      final refreshToken = await secureStorage.read(key: "refreshToken") ?? '';
      Uri url = Uri.parse('$backendUrl/legislation/add_new_legislation');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode(_legislationBody()),
      );
      if (response.statusCode == 200) {
        final decoded = _jsonObject(response.body);
        final addedId =
            decoded['added_legislation_id']?.toString() ??
            decoded['added_id']?.toString() ??
            decoded['_id']?.toString();
        if (addedId != null && addedId.isNotEmpty) {
          _upsertLegislation(_currentLegislation(id: addedId));
        }
        await filterSearch();
        addingNewValue.value = false;
        Get.back();
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          addingNewValue.value = false;
          return await addNewLegislation();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        _showError('Could not save legislation. Please try again.');
      }
      addingNewValue.value = false;
    } catch (e) {
      addingNewValue.value = false;
      _showError('Something went wrong please try again');
    }
  }

  Future<void> updateLegislation(String id) async {
    try {
      if (addingNewValue.value) return;
      if (id.isEmpty) return;
      if (!_validateLegislation()) return;

      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      final refreshToken = await secureStorage.read(key: "refreshToken") ?? '';
      Uri url = Uri.parse('$backendUrl/legislation/update_legislation/$id');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode(_legislationBody()),
      );
      if (response.statusCode == 200) {
        _upsertLegislation(_currentLegislation(id: id));
        await filterSearch();
        addingNewValue.value = false;
        Get.back();
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          addingNewValue.value = false;
          return await updateLegislation(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        _showError('Could not update legislation. Please try again.');
      }
      addingNewValue.value = false;
    } catch (e) {
      addingNewValue.value = false;
      _showError('Something went wrong please try again');
    }
  }

  Future<bool> deletedLegislation(String id) async {
    try {
      if (id.isEmpty) return false;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      final refreshToken = await secureStorage.read(key: "refreshToken") ?? '';
      Uri url = Uri.parse('$backendUrl/legislation/delete_legislation/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        allLegislations.removeWhere((m) => m.id == id);
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await deletedLegislation(id);
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
      final accessToken = prefs.getString('accessToken') ?? '';
      final refreshToken = await secureStorage.read(key: "refreshToken") ?? '';
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
        final decoded = _jsonObject(response.body);
        List docs = decoded['legislations_elements'] ?? [];
        allLegislations.assignAll(
          docs.whereType<Map>().map(
            (job) => LegislationModel.fromJson(Map<String, dynamic>.from(job)),
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
    filterSearch();
  }

  void loadValues(LegislationModel data) {
    name.text = data.name ?? '';
    numberOfPaidDays.text = (data.numberOfPaidDaysForSickLEave ?? 0).toString();
    numberOfHalfPaidDays.text = (data.numberOfHalfPaidDaysForSickLEave ?? 0)
        .toString();
    numberOfUnPaidDays.text = (data.numberOfUnpaidDaysForSickLEave ?? 0)
        .toString();
    meternityNumberOfPaidDays.text =
        (data.numberOfHalfPaidDaysForMaternityLEave ?? 0).toString();
    paternityNumberOfPaidDays.text =
        (data.numberOfHalfPaidDaysForPaternityLEave ?? 0).toString();
    compassionateLeaveNumberOfPaidDays.text =
        (data.numberOfHalfPaidDaysForCompassionateLEave ?? 0).toString();
    numberOfWorkingHoursForOvertimeNormal.text =
        (data.numberOfWorkingHoursForOvertimeNormal ?? 0).toString();
    numberOfWorkingHoursForOvertimeHolidays.text =
        (data.numberOfWorkingHoursForOvertimeHolidays ?? 0).toString();
    socialSecurityEmployee.text = (data.socialSecurityEmployee ?? 0).toString();
    socialSecurityEmployer.text = (data.socialSecurityEmployer ?? 0).toString();
    socialSecurityCeiling.text = (data.socialSecurityCeiling ?? 0).toString();
    gratuityFirst5Years.text = (data.gratuityFirst5Years ?? 0).toString();
    gratuityAfter5Years.text = (data.gratuityAfter5Years ?? 0).toString();
    selectedDays.assignAll(data.weekend ?? []);
  }

  void clearValues() {
    legislationFormKey.currentState?.reset();
    name.clear();
    selectedDays.clear();
    numberOfPaidDays.clear();
    numberOfHalfPaidDays.clear();
    numberOfUnPaidDays.clear();
    meternityNumberOfPaidDays.clear();
    compassionateLeaveNumberOfPaidDays.clear();
    paternityNumberOfPaidDays.clear();
    numberOfWorkingHoursForOvertimeHolidays.clear();
    numberOfWorkingHoursForOvertimeNormal.clear();
    socialSecurityEmployee.clear();
    socialSecurityEmployer.clear();
    socialSecurityCeiling.clear();
    gratuityAfter5Years.clear();
    gratuityFirst5Years.clear();
  }
}
