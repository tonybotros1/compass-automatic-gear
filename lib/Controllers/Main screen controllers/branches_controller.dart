import 'dart:convert';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/branches/branches_model.dart';
import '../../helpers.dart';
import 'websocket_controller.dart';
import 'main_screen_contro.dart';
import 'package:http/http.dart' as http;

class BranchesController extends GetxController {
  TextEditingController code = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController line = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController city = TextEditingController();
  RxString countryId = RxString('');
  RxString cityId = RxString('');
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(false);
  final RxList<BranchesModel> allBranches = RxList<BranchesModel>([]);
  final RxList<BranchesModel> filteredBranches = RxList<BranchesModel>([]);
  RxMap allCountries = RxMap({});
  RxMap allCities = RxMap({});
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  String backendUrl = backendTestURI;
  WebSocketService ws = Get.find<WebSocketService>();

  @override
  void onInit() async {
    connectWebSocket();
    getAllBranches();
    getCountries();
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
        case "branch_added":
          final newCounter = BranchesModel.fromJson(message["data"]);
          allBranches.add(newCounter);
          break;

        case "branch_status_updated":
          final branchId = message["data"]['_id'];
          final branchStatus = message["data"]['status'];
          final index = allBranches.indexWhere((m) => m.id == branchId);
          if (index != -1) {
            allBranches[index].status = branchStatus;
            allBranches.refresh();
          }
          break;

        case "branch_updated":
          final updated = BranchesModel.fromJson(message["data"]);
          final index = allBranches.indexWhere((m) => m.id == updated.id);
          if (index != -1) {
            allBranches[index] = updated;
          }
          break;

        case "branch_deleted":
          final deletedId = message["data"]["_id"];
          allBranches.removeWhere((m) => m.id == deletedId);
          break;
      }
    });
  }

  Future<void> getAllBranches() async {
    try {
      isScreenLoding.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/branches/get_all_branches');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List branches = decoded['branches'];
        allBranches.assignAll(
          branches.map((branch) => BranchesModel.fromJson(branch)),
        );
        isScreenLoding.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllBranches();
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

  Future<void> addNewBranch() async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/branches/add_new_branch');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name.text,
          "code": code.text,
          "line": line.text,
          "country_id": countryId.value,
          "city_id": cityId.value,
        }),
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewBranch();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        isScreenLoding.value = false;
        logout();
      } else {
        isScreenLoding.value = false;
      }
      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  Future<void> editBranch(String branchId) async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/branches/update_branch/$branchId');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name.text,
          "code": code.text,
          "line": line.text,
          "country_id": countryId.value,
          "city_id": cityId.value,
        }),
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await editBranch(branchId);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        isScreenLoding.value = false;
        logout();
      } else {
        isScreenLoding.value = false;
      }
      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
      Get.back();
    }
  }

  // this functions is to change the counter status from active / inactive
  Future<void> changeBranchStatus(String branchId, bool status) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/branches/change_branch_status/$branchId',
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
          await changeBranchStatus(branchId, status);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
    } catch (e) {
      //
    }
  }

  Future<void> deleteBranch(String branchId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/branches/delete_branch/$branchId');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteBranch(branchId);
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

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allBranches.sort((counter1, counter2) {
        final String value1 = counter1.code;
        final String value2 = counter2.code;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allBranches.sort((counter1, counter2) {
        final String value1 = counter1.name;
        final String value2 = counter2.name;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allBranches.sort((counter1, counter2) {
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

  Future<void> getCountries() async {
    try {
      allCountries.assignAll(await helper.getCountries());
    } catch (e) {
      //
    }
  }

  void getCitiesByCountryID(String countryID) async {
    try {
      allCities.assignAll(await helper.getCitiesValues(countryID));
    } catch (e) {
      //
    }
  }

  // this function is to filter the search results for web
  void filterBranches() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredBranches.clear();
    } else {
      filteredBranches.assignAll(
        allBranches.where((saleman) {
          return saleman.code.toString().toLowerCase().contains(query) ||
              saleman.name.toString().toLowerCase().contains(query) ||
              textToDate(
                saleman.createdAt,
              ).toString().toLowerCase().contains(query);
        }).toList(),
      );
    }
  }
}
