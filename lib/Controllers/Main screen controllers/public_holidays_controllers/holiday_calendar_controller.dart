import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Models/public_holidays_models/holiday_entry.dart';
import '../../../consts.dart';
import '../../../helpers.dart';

class HolidayCalendarController extends GetxController {
  String backendUrl = backendTestURI;
  final RxInt selectedYear = DateTime.now().year.obs;
  final RxMap<String, HolidayEntry> holidays = <String, HolidayEntry>{}.obs;
  final Map<int, List<List<DateTime?>>> _monthGridCache =
      <int, List<List<DateTime?>>>{};
  late final TextEditingController yearController;

  static const List<String> monthLabels = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const List<String> weekdayShortLabels = <String>[
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  static const List<String> weekdayLongLabels = <String>[
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void onInit() async {
    yearController = TextEditingController(text: selectedYear.value.toString());
    getAllHolidays();
    super.onInit();
  }

  @override
  onClose() async {
    yearController.dispose();
    super.onInit();
  }

  Future<Map<String, dynamic>> getAllYears() async {
    return await helper.getAllListValues('YEARS');
  }

  List<DateTime?> buildMonthGrid(int month) {
    final int year = selectedYear.value;
    final List<List<DateTime?>> yearGrids = _monthGridCache.putIfAbsent(
      year,
      () => List<List<DateTime?>>.generate(
        monthLabels.length,
        (int index) => _createMonthGrid(year, index + 1),
        growable: false,
      ),
    );
    return yearGrids[month - 1];
  }

  List<List<DateTime?>> monthGridsForSelectedYear() {
    final int year = selectedYear.value;
    return _monthGridCache.putIfAbsent(
      year,
      () => List<List<DateTime?>>.generate(
        monthLabels.length,
        (int index) => _createMonthGrid(year, index + 1),
        growable: false,
      ),
    );
  }

  String monthLabel(int month) {
    return monthLabels[month - 1];
  }

  String formattedDate(DateTime date) {
    return '${weekdayLongLabels[date.weekday - 1]}, '
        '${monthLabel(date.month)} ${date.day}, ${date.year}';
  }

  HolidayEntry? holidayFor(DateTime date) {
    return holidays[dateKey(date)];
  }

  int get selectedYearHolidayCount {
    final int year = selectedYear.value;
    return holidays.values.where((HolidayEntry entry) {
      return entry.date?.year == year;
    }).length;
  }

  void changeYear(int year) {
    if (selectedYear.value == year) {
      return;
    }
    selectedYear.value = year;
  }

  void saveHoliday({required DateTime date, required String name}) async {
    final DateTime normalizedDate = _normalize(date);
    String? id = '';

    if (holidays.containsKey(dateKey(normalizedDate))) {
      HolidayEntry? updatedHoliday = holidays[dateKey(normalizedDate)];
      id = updatedHoliday?.id;
      if (id != null) {
        updateHoliday(id: id, date: date, name: name);
      }
    } else {
      HolidayEntry? addedHoliday = await addNewHoliday(date: date, name: name);
      id = addedHoliday?.id;
    }
    holidays[dateKey(normalizedDate)] = HolidayEntry(
      date: normalizedDate,
      name: name,
      id: id,
    );
  }

  void removeHoliday(DateTime date) {
    HolidayEntry? removedHoliday = holidays[dateKey(date)];
    holidays.remove(dateKey(date));
    final id = removedHoliday?.id;
    if (id != null) {
      deleteHoliday(id);
    }
  }

  String dateKey(DateTime date) {
    return _keyFor(_normalize(date));
  }

  List<DateTime?> _createMonthGrid(int year, int month) {
    final DateTime firstDay = DateTime(year, month, 1);
    final int totalDays = DateUtils.getDaysInMonth(year, month);
    final int leadingSlots = firstDay.weekday - DateTime.monday;
    final int trailingSlots = (7 - ((leadingSlots + totalDays) % 7)) % 7;

    return <DateTime?>[
      ...List<DateTime?>.filled(leadingSlots, null),
      ...List<DateTime?>.generate(
        totalDays,
        (int index) => DateTime(year, month, index + 1),
      ),
      ...List<DateTime?>.filled(trailingSlots, null),
    ];
  }

  DateTime _normalize(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  String _keyFor(DateTime date) {
    final String year = date.year.toString().padLeft(4, '0');
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  // ==========================================================================

  Future<void> getAllHolidays() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/public_holidays/get_all_holidays');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List holi = decoded['holidays'];
        for (var element in holi) {
          HolidayEntry ho = HolidayEntry.fromJson(element);
          holidays[_keyFor(ho.date ?? DateTime.now())] = ho;
        }
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllHolidays();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      Get.back();
    } catch (e) {
      //
    }
  }

  Future<HolidayEntry?> addNewHoliday({
    required DateTime date,
    required String name,
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/public_holidays/add_new_holiday');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name,
          "date": convertDateToIson(textToDate(date)),
        }),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        HolidayEntry addedHoliday = HolidayEntry.fromJson(
          decoded['added_holiday'],
        );
        return addedHoliday;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewHoliday(date: date, name: name);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateHoliday({
    required String id,
    required DateTime date,
    required String name,
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/public_holidays/update_holiday/$id');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name,
          "date": convertDateToIson(textToDate(date)),
        }),
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await updateHoliday(id: id, date: date, name: name);
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

  Future<void> deleteHoliday(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/public_holidays/delete_holiday/$id');
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteHoliday(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      Get.back();
    } catch (e) {
      //
    }
  }
}
