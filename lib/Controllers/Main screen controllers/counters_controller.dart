import 'dart:convert';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Models/counters/counters_model.dart';
import '../../helpers.dart';
import 'main_screen_contro.dart';
import 'websocket_controller.dart';

class CountersController extends GetxController {
  TextEditingController code = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController prefix = TextEditingController();
  TextEditingController value = TextEditingController();
  TextEditingController separator = TextEditingController();
  TextEditingController length = TextEditingController();
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(false);
  final RxList<CountersModel> allCounters = RxList<CountersModel>([]);
  final RxList<CountersModel> filteredCounters = RxList<CountersModel>([]);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  String backendUrl = backendTestURI;
  WebSocketService ws = Get.find<WebSocketService>();

  @override
  void onInit() async {
    connectWebSocket();
    getAllCounters();
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
        case "counter_added":
          final newCounter = CountersModel.fromJson(message["data"]);
          allCounters.add(newCounter);
          break;

        case "counter_updated":
          final updated = CountersModel.fromJson(message["data"]);
          final index = allCounters.indexWhere((m) => m.id == updated.id);
          if (index != -1) {
            allCounters[index] = updated;
          }
          break;

        case "counter_deleted":
          final deletedId = message["data"]["_id"];
          allCounters.removeWhere((m) => m.id == deletedId);
          break;
      }
    });
  }

  Future<void> getAllCounters() async {
    try {
      isScreenLoding.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/counters/get_all_counters');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List<dynamic> counters = decoded["counters"];
        allCounters.assignAll(
          counters.map((counter) => CountersModel.fromJson(counter)).toList(),
        );
        isScreenLoding.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllCounters();
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

  Future<void> addNewCounter() async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/counters/add_new_counter');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "code": code.text,
          "description": description.text,
          "prefix": prefix.text,
          "value": int.tryParse(value.text) ?? 0,
          "length": int.tryParse(length.text) ?? 0,
          "separator": separator.text,
        }),
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewCounter();
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
    }
  }

  Future<void> deleteCounter(String counterId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/counters/remove_counter/$counterId');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteCounter(counterId);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      Get.back();
    } catch (e) {
      Get.back();
    }
  }

  Future<void> editCounter(String counterId) async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/counters/update_counter/$counterId');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "code": code.text,
          "description": description.text,
          "prefix": prefix.text,
          "value": int.tryParse(value.text) ?? 0,
          "length": int.tryParse(length.text) ?? 0,
          "separator": separator.text,
        }),
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await editCounter(counterId);
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
    }
  }

  // this functions is to change the counter status from active / inactive
  Future<void> changeCounterStatus(String counterId, bool status) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/counters/change_counter_status/$counterId',
      );
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode(status),
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await changeCounterStatus(counterId, status);
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

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allCounters.sort((counter1, counter2) {
        final String value1 = counter1.code;
        final String value2 = counter2.code;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allCounters.sort((counter1, counter2) {
        final String value1 = counter1.description;
        final String value2 = counter2.description;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allCounters.sort((counter1, counter2) {
        final String value1 = counter1.prefix;
        final String value2 = counter2.prefix;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 3) {
      allCounters.sort((counter1, counter2) {
        final String value1 = counter1.value.toString();
        final String value2 = counter2.value.toString();

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 4) {
      allCounters.sort((counter1, counter2) {
        final String value1 = counter1.createdAt.toString();
        final String value2 = counter2.createdAt.toString();

        return compareString(ascending, value1, value2);
      });
    }
    sortColumnIndex.value = columnIndex;
    isAscending.value = ascending;
  }

  int compareString(bool ascending, String value1, String value2) {
    int comparison = value1.compareTo(value2);
    return ascending ? comparison : -comparison; // Reverse if descending
  }

  // // this functions is to change the counter status from active / inactive
  // Future<void> changeCounterStatus(String counterId, bool status) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('counters')
  //         .doc(counterId)
  //         .update({'status': status});
  //   } catch (e) {
  //     //
  //   }
  // }

  // this function is to filter the search results for web
  void filterCounters() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredCounters.clear();
    } else {
      filteredCounters.assignAll(
        allCounters.where((saleman) {
          return saleman.code.toString().toLowerCase().contains(query) ||
              saleman.description.toString().toLowerCase().contains(query) ||
              saleman.prefix.toString().toLowerCase().contains(query) ||
              saleman.value.toString().toLowerCase().contains(query) ||
              textToDate(
                saleman.createdAt,
              ).toString().toLowerCase().contains(query);
        }).toList(),
      );
    }
  }
}
