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

class IncomeTaxBracketController {
  TextEditingController fromAmount = TextEditingController();
  TextEditingController toAmount = TextEditingController();
  TextEditingController percentage = TextEditingController();

  IncomeTaxBracketController({IncomeTaxBracketModel? bracket}) {
    if (bracket != null) {
      fromAmount.text = (bracket.fromAmount ?? 0).toString();
      toAmount.text = bracket.toAmount == null
          ? ''
          : bracket.toAmount.toString();
      percentage.text = (bracket.percentage ?? 0).toString();
    }
  }

  void dispose() {
    fromAmount.dispose();
    toAmount.dispose();
    percentage.dispose();
  }
}

class SocialSecurityCeilingController {
  final TextEditingController employeePercentage = TextEditingController();
  final TextEditingController employerPercentage = TextEditingController();
  final TextEditingController ceiling = TextEditingController();
  final TextEditingController startDate = TextEditingController();
  final TextEditingController endDate = TextEditingController();

  SocialSecurityCeilingController({
    SocialSecurityCeilingModel? line,
    double? initialEmployeePercentage,
    double? initialEmployerPercentage,
    double? initialCeiling,
    DateTime? initialStartDate,
    DateTime? initialEndDate,
  }) {
    final employeeValue = line?.employeePercentage ?? initialEmployeePercentage;
    final employerValue = line?.employerPercentage ?? initialEmployerPercentage;
    final ceilingValue = line?.ceiling ?? initialCeiling;
    employeePercentage.text = employeeValue == null
        ? ''
        : employeeValue.toString();
    employerPercentage.text = employerValue == null
        ? ''
        : employerValue.toString();
    ceiling.text = ceilingValue == null ? '' : ceilingValue.toString();
    final startValue = line?.startDate ?? initialStartDate;
    final endValue = line?.endDate ?? initialEndDate;
    startDate.text = startValue == null ? '' : textToDate(startValue);
    endDate.text = endValue == null ? '' : textToDate(endValue);
  }

  void dispose() {
    employeePercentage.dispose();
    employerPercentage.dispose();
    ceiling.dispose();
    startDate.dispose();
    endDate.dispose();
  }
}

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
  TextEditingController socialSecurityCeilingStartDate =
      TextEditingController();
  TextEditingController socialSecurityCeilingEndDate = TextEditingController();

  RxList<SocialSecurityCeilingController> socialSecurityCeilings =
      RxList<SocialSecurityCeilingController>([]);
  // gratiuty accrual
  TextEditingController gratuityFirst5Years = TextEditingController();
  TextEditingController gratuityAfter5Years = TextEditingController();

  // service tax
  TextEditingController serviceTax = TextEditingController();

  // income tax
  TextEditingController incomeTaxPercentage = TextEditingController();
  TextEditingController incomeTaxCeiling = TextEditingController();

  RxList<IncomeTaxBracketController> incomeTaxBrackets =
      RxList<IncomeTaxBracketController>([]);

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
    socialSecurityCeilingStartDate.dispose();
    socialSecurityCeilingEndDate.dispose();
    for (final line in socialSecurityCeilings) {
      line.dispose();
    }
    gratuityFirst5Years.dispose();
    gratuityAfter5Years.dispose();
    serviceTax.dispose();
    incomeTaxPercentage.dispose();
    incomeTaxCeiling.dispose();
    for (final bracket in incomeTaxBrackets) {
      bracket.dispose();
    }
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

  String? _nullIfEmpty(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
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

  DateTime? _dateValue(TextEditingController controller) {
    final value = convertDateToIson(controller.text.trim());
    return value == null ? null : DateTime.tryParse(value);
  }

  bool _validateLegislation() {
    if (!(legislationFormKey.currentState?.validate() ?? false)) return false;
    if (name.text.trim().isEmpty) {
      _showError('Please enter legislation name');
      return false;
    }
    if (socialSecurityCeilings.isEmpty) {
      _showError('Add at least one social security ceiling line');
      return false;
    }
    for (var index = 0; index < socialSecurityCeilings.length; index++) {
      final line = socialSecurityCeilings[index];
      final startDate = _dateValue(line.startDate);
      final endDate = _dateValue(line.endDate);
      if (line.employeePercentage.text.trim().isEmpty) {
        _showError('Ceiling line ${index + 1} needs an employee percentage');
        return false;
      }
      if (line.employerPercentage.text.trim().isEmpty) {
        _showError('Ceiling line ${index + 1} needs an employer percentage');
        return false;
      }
      if (_doubleValue(line.ceiling) <= 0) {
        _showError('Ceiling line ${index + 1} must be greater than zero');
        return false;
      }
      if (startDate == null) {
        _showError('Ceiling line ${index + 1} needs a start date');
        return false;
      }
      if (endDate != null && endDate.isBefore(startDate)) {
        _showError(
          'Ceiling line ${index + 1} end date cannot be before its start date',
        );
        return false;
      }
    }
    return true;
  }

  List<Map<String, dynamic>> _incomeTaxBracketsBody() {
    return incomeTaxBrackets
        .where(
          (bracket) =>
              bracket.fromAmount.text.trim().isNotEmpty ||
              bracket.toAmount.text.trim().isNotEmpty ||
              bracket.percentage.text.trim().isNotEmpty,
        )
        .map(
          (bracket) => {
            "from_amount": _zeroIfEmpty(bracket.fromAmount),
            "to_amount": _nullIfEmpty(bracket.toAmount),
            "percentage": _zeroIfEmpty(bracket.percentage),
          },
        )
        .toList();
  }

  List<IncomeTaxBracketModel> _currentIncomeTaxBrackets() {
    return incomeTaxBrackets
        .where(
          (bracket) =>
              bracket.fromAmount.text.trim().isNotEmpty ||
              bracket.toAmount.text.trim().isNotEmpty ||
              bracket.percentage.text.trim().isNotEmpty,
        )
        .map(
          (bracket) => IncomeTaxBracketModel(
            fromAmount: _doubleValue(bracket.fromAmount),
            toAmount: bracket.toAmount.text.trim().isEmpty
                ? null
                : _doubleValue(bracket.toAmount),
            percentage: _doubleValue(bracket.percentage),
          ),
        )
        .toList();
  }

  List<Map<String, dynamic>> _socialSecurityCeilingsBody() {
    return socialSecurityCeilings
        .map(
          (line) => {
            'employee_percentage': _doubleValue(line.employeePercentage),
            'employer_percentage': _doubleValue(line.employerPercentage),
            'ceiling': _doubleValue(line.ceiling),
            'start_date': convertDateToIson(line.startDate.text),
            'end_date': convertDateToIson(line.endDate.text),
          },
        )
        .toList();
  }

  List<SocialSecurityCeilingModel> _currentSocialSecurityCeilings() {
    return socialSecurityCeilings
        .map(
          (line) => SocialSecurityCeilingModel(
            employeePercentage: _doubleValue(line.employeePercentage),
            employerPercentage: _doubleValue(line.employerPercentage),
            ceiling: _doubleValue(line.ceiling),
            startDate: _dateValue(line.startDate),
            endDate: _dateValue(line.endDate),
          ),
        )
        .toList();
  }

  SocialSecurityCeilingController? get _firstSocialSecurityCeiling {
    return socialSecurityCeilings.isEmpty ? null : socialSecurityCeilings.first;
  }

  Map<String, dynamic> _legislationBody() {
    final firstCeiling = _firstSocialSecurityCeiling;
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
      "social_security_employee_percentage": firstCeiling == null
          ? _zeroIfEmpty(socialSecurityEmployee)
          : _zeroIfEmpty(firstCeiling.employeePercentage),
      "social_security_employer_percentage": firstCeiling == null
          ? _zeroIfEmpty(socialSecurityEmployer)
          : _zeroIfEmpty(firstCeiling.employerPercentage),
      "social_security_ceiling": firstCeiling == null
          ? _zeroIfEmpty(socialSecurityCeiling)
          : _zeroIfEmpty(firstCeiling.ceiling),
      "social_security_ceiling_start_date": convertDateToIson(
        firstCeiling?.startDate.text ?? socialSecurityCeilingStartDate.text,
      ),
      "social_security_ceiling_end_date": convertDateToIson(
        firstCeiling?.endDate.text ?? socialSecurityCeilingEndDate.text,
      ),
      "social_security_ceilings": _socialSecurityCeilingsBody(),
      "service_tax_percentage": _zeroIfEmpty(serviceTax),
      "income_tax_percentage": _zeroIfEmpty(incomeTaxPercentage),
      "income_tax_ceiling": _zeroIfEmpty(incomeTaxCeiling),
      "income_tax_brackets": _incomeTaxBracketsBody(),
      "gratuity_first_5_years": _zeroIfEmpty(gratuityFirst5Years),
      "gratuity_after_5_years": _zeroIfEmpty(gratuityAfter5Years),
    };
  }

  LegislationModel _currentLegislation({String? id}) {
    final firstCeiling = _firstSocialSecurityCeiling;
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
      socialSecurityEmployee: firstCeiling == null
          ? _doubleValue(socialSecurityEmployee)
          : _doubleValue(firstCeiling.employeePercentage),
      socialSecurityEmployer: firstCeiling == null
          ? _doubleValue(socialSecurityEmployer)
          : _doubleValue(firstCeiling.employerPercentage),
      socialSecurityCeilingStartDate: firstCeiling == null
          ? _dateValue(socialSecurityCeilingStartDate)
          : _dateValue(firstCeiling.startDate),
      socialSecurityCeilingEndDate: firstCeiling == null
          ? _dateValue(socialSecurityCeilingEndDate)
          : _dateValue(firstCeiling.endDate),
      socialSecurityCeiling: firstCeiling == null
          ? _doubleValue(socialSecurityCeiling)
          : _doubleValue(firstCeiling.ceiling),
      socialSecurityCeilings: _currentSocialSecurityCeilings(),
      serviceTaxPercentage: _doubleValue(serviceTax),
      incomeTaxPercentage: _doubleValue(incomeTaxPercentage),
      incomeTaxCeiling: _doubleValue(incomeTaxCeiling),
      incomeTaxBrackets: _currentIncomeTaxBrackets(),
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

  void addIncomeTaxBracket({IncomeTaxBracketModel? bracket}) {
    incomeTaxBrackets.add(IncomeTaxBracketController(bracket: bracket));
  }

  void removeIncomeTaxBracket(int index) {
    if (index < 0 || index >= incomeTaxBrackets.length) return;
    final bracket = incomeTaxBrackets.removeAt(index);
    bracket.dispose();
    if (incomeTaxBrackets.isEmpty) {
      addIncomeTaxBracket();
    }
  }

  void _clearIncomeTaxBrackets() {
    for (final bracket in incomeTaxBrackets) {
      bracket.dispose();
    }
    incomeTaxBrackets.clear();
  }

  void addSocialSecurityCeiling({
    SocialSecurityCeilingModel? line,
    double? initialEmployeePercentage,
    double? initialEmployerPercentage,
    double? initialCeiling,
    DateTime? initialStartDate,
    DateTime? initialEndDate,
  }) {
    socialSecurityCeilings.add(
      SocialSecurityCeilingController(
        line: line,
        initialEmployeePercentage: initialEmployeePercentage,
        initialEmployerPercentage: initialEmployerPercentage,
        initialCeiling: initialCeiling,
        initialStartDate: initialStartDate,
        initialEndDate: initialEndDate,
      ),
    );
  }

  void removeSocialSecurityCeiling(int index) {
    if (index < 0 || index >= socialSecurityCeilings.length) return;
    final line = socialSecurityCeilings.removeAt(index);
    line.dispose();
    if (socialSecurityCeilings.isEmpty) {
      addSocialSecurityCeiling();
    }
  }

  void _clearSocialSecurityCeilings() {
    for (final line in socialSecurityCeilings) {
      line.dispose();
    }
    socialSecurityCeilings.clear();
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
    socialSecurityCeilingStartDate.text =
        data.socialSecurityCeilingStartDate == null
        ? ''
        : textToDate(data.socialSecurityCeilingStartDate);
    socialSecurityCeilingEndDate.text =
        data.socialSecurityCeilingEndDate == null
        ? ''
        : textToDate(data.socialSecurityCeilingEndDate);
    _clearSocialSecurityCeilings();
    final savedCeilings = data.socialSecurityCeilings ?? [];
    if (savedCeilings.isNotEmpty) {
      for (final line in savedCeilings) {
        addSocialSecurityCeiling(
          line: line,
          initialEmployeePercentage: data.socialSecurityEmployee,
          initialEmployerPercentage: data.socialSecurityEmployer,
        );
      }
    } else {
      addSocialSecurityCeiling(
        initialEmployeePercentage: data.socialSecurityEmployee,
        initialEmployerPercentage: data.socialSecurityEmployer,
        initialCeiling: data.socialSecurityCeiling,
        initialStartDate: data.socialSecurityCeilingStartDate,
        initialEndDate: data.socialSecurityCeilingEndDate,
      );
    }
    serviceTax.text = (data.serviceTaxPercentage ?? 0).toString();
    incomeTaxPercentage.text = (data.incomeTaxPercentage ?? 0).toString();
    incomeTaxCeiling.text = (data.incomeTaxCeiling ?? 0).toString();
    _clearIncomeTaxBrackets();
    for (final bracket in data.incomeTaxBrackets ?? <IncomeTaxBracketModel>[]) {
      addIncomeTaxBracket(bracket: bracket);
    }
    if (incomeTaxBrackets.isEmpty) {
      addIncomeTaxBracket();
    }
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
    socialSecurityCeilingStartDate.clear();
    socialSecurityCeilingEndDate.clear();
    gratuityAfter5Years.clear();
    gratuityFirst5Years.clear();
    serviceTax.clear();
    incomeTaxPercentage.clear();
    incomeTaxCeiling.clear();
    _clearIncomeTaxBrackets();
    addIncomeTaxBracket();
    _clearSocialSecurityCeilings();
    addSocialSecurityCeiling();
  }
}
