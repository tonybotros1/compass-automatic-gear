import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/technicians/technicians_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import 'main_screen_contro.dart';
import 'websocket_controller.dart';

class TechnicianController extends GetxController {
  TextEditingController name = TextEditingController();
  TextEditingController job = TextEditingController();
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(false);
  final RxList<TechnicianModel> allTechnician = RxList<TechnicianModel>([]);
  final RxList<TechnicianModel> filteredTechnicians = RxList<TechnicianModel>(
    [],
  );
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  RxString companyId = RxString('');
  WebSocketService ws = Get.find<WebSocketService>();
  String backendUrl = backendTestURI;

  @override
  void onInit() async {
    connectWebSocket();
    getAllTechnicians();
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
        case "tech_added":
          final newCounter = TechnicianModel.fromJson(message["data"]);
          allTechnician.add(newCounter);
          break;

        case "tech_updated":
          final updated = TechnicianModel.fromJson(message["data"]);
          final index = allTechnician.indexWhere((m) => m.id == updated.id);
          if (index != -1) {
            allTechnician[index] = updated;
          }
          break;

        case "tech_deleted":
          final deletedId = message["data"]["_id"];
          allTechnician.removeWhere((m) => m.id == deletedId);
          break;
      }
    });
  }

  Future<void> getAllTechnicians() async {
    try {
      isScreenLoding.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/technicians/get_all_technicians');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List techs = decoded['technicians'];
        allTechnician.assignAll(
          techs.map((tech) => TechnicianModel.fromJson(tech)),
        );
        isScreenLoding.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllTechnicians();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        isScreenLoding.value = false;
        logout();
      } else {
        isScreenLoding.value = false;
      }
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  Future<void> addNewTechnicians() async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/technicians/add_new_technician');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({"name": name.text, "job": job.text}),
      );
      if (response.statusCode == 200) {
        addingNewValue.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewTechnicians();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        addingNewValue.value = false;
      }
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  Future<void> updateTechnicians(String id) async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/technicians/update_technician/$id');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({"name": name.text, "job": job.text}),
      );
      if (response.statusCode == 200) {
        addingNewValue.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await updateTechnicians(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        addingNewValue.value = false;
      }
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  Future<void> deleteTechnician(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/technicians/delete_technicians/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteTechnician(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      Get.back();
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  // ============================================================================================
  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allTechnician.sort((counter1, counter2) {
        final String? value1 = counter1.name;
        final String? value2 = counter2.name;

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allTechnician.sort((counter1, counter2) {
        final String? value1 = counter1.job;
        final String? value2 = counter2.job;

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allTechnician.sort((counter1, counter2) {
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

  // this function is to filter the search results for web
  void filterTechnicians() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredTechnicians.clear();
    } else {
      filteredTechnicians.assignAll(
        allTechnician.where((saleman) {
          return saleman.name.toString().toLowerCase().contains(query) ||
              saleman.job.toString().toLowerCase().contains(query) ||
              textToDate(
                saleman.createdAt,
              ).toString().toLowerCase().contains(query);
        }).toList(),
      );
    }
  }
}
