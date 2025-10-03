import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/users/users_model.dart';
import '../../consts.dart';
import 'main_screen_contro.dart';
import 'package:http/http.dart' as http;
import 'websocket_controller.dart';
import '../../helpers.dart';

class UsersController extends GetxController {
  late TextEditingController email = TextEditingController();
  late TextEditingController name = TextEditingController();
  late TextEditingController pass = TextEditingController();
  final FocusNode focusNode = FocusNode();
  RxBool obscureText = RxBool(true);
  RxBool sigupgInProcess = RxBool(false);
  var selectedDate = DateTime.now().obs;
  RxString theDate = RxString('');
  List<String> areaName = [];
  RxMap selectedRoles = RxMap({});
  RxBool isScreenLoding = RxBool(false);
  final RxList<UsersModel> allUsers = RxList<UsersModel>([]);
  final RxList<UsersModel> filteredUsers = RxList<UsersModel>([]);
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  WebSocketService ws = Get.find<WebSocketService>();
  String backendUrl = backendTestURI;
  RxBool isLoading = RxBool(false);

  @override
  void onInit() {
    connectWebSocket();
    getRoles();
    getAllUsers();
    super.onInit();
  }

  @override
  void onClose() {
    Get.delete<UsersController>();
    super.onClose();
  }

  void connectWebSocket() {
    ws.events.listen((message) {
      switch (message["type"]) {
        case "user_added":
          final newCounter = UsersModel.fromJson(message["data"]);
          allUsers.add(newCounter);
          break;

        case "user_status_updated":
          final branchId = message["data"]['_id'];
          final branchStatus = message["data"]['status'];
          final index = allUsers.indexWhere((m) => m.id == branchId);
          if (index != -1) {
            allUsers[index].status = branchStatus;
            allUsers.refresh();
          }
          break;

        case "user_updated":
          final updated = UsersModel.fromJson(message["data"]);
          final index = allUsers.indexWhere((m) => m.id == updated.id);
          if (index != -1) {
            allUsers[index] = updated;
          }
          break;

        case "user_deleted":
          final deletedId = message["data"]["_id"];
          allUsers.removeWhere((m) => m.id == deletedId);
          break;
      }
    });
  }

  Future<void> getAllUsers() async {
    try {
      isScreenLoding.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/users/get_all_users');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List users = decoded['users'];
        allUsers.assignAll(users.map((user) => UsersModel.fromJson(user)));
        isScreenLoding.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllUsers();
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

  Future<void> register() async {
    try {
      if (name.text.isEmpty ||
          email.text.isEmpty ||
          pass.text.isEmpty ||
          selectedRoles.isEmpty) {
        showSnackBar('Note', 'Please fill all fields');
        return;
      }
      sigupgInProcess.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/users/add_new_user');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "user_name": name.text,
          "email": email.text.toLowerCase(),
          "password": pass.text,
          "roles": selectedRoles.entries
              .where((entry) => entry.value[1] == true)
              .map((entry) => entry.value[0])
              .toList(),
          "expiry_date": selectedDate.value.toIso8601String(),
        }),
      );
      final decoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Get.back();
        showSnackBar('Done', decoded['message']);
      } else if (response.statusCode == 400) {
        showSnackBar('Alert', decoded['detail']);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await register();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }

      sigupgInProcess.value = false;
    } catch (e) {
      sigupgInProcess.value = false;
      showSnackBar('warning', e.toString());
    }
  }

  // this function is to delete user from the DB
  Future<void> deleteUser(String userID) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/users/remove_user/$userID');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      final decoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Get.back();
        showSnackBar('Done', decoded['message']);
      } else if (response.statusCode == 404) {
        showSnackBar('Alert', decoded['detail']);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteUser(userID);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
    } catch (e) {
      Get.back();
    }
  }

  Future<void> updateUserDetails(String userID) async {
    try {
      if (name.text.isEmpty || email.text.isEmpty || selectedRoles.isEmpty) {
        showSnackBar('Note', 'Please fill all fields');
        return;
      }
      sigupgInProcess.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/users/update_user/$userID');
      Map updatedData = {
        "user_name": name.text,
        "roles": selectedRoles.entries
            .where((entry) => entry.value[1] == true)
            .map((entry) => entry.value[0])
            .toList(),
        "expiry_date": selectedDate.value.toIso8601String(),
      };
      if (pass.text.isNotEmpty) {
        updatedData['password'] = pass.text;
      }

      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updatedData),
      );
      final decoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Get.back();
        showSnackBar('Done', decoded['message']);
      } else if (response.statusCode == 400) {
        showSnackBar('Alert', decoded['detail']);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await updateUserDetails(userID);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }

      sigupgInProcess.value = false;
    } catch (e) {
      sigupgInProcess.value = false;
    }
  }

  Future<void> changeUserStatus(String userId, bool status) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/users/change_user_status/$userId');
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
          await changeUserStatus(userId, status);
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

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allUsers.sort((user1, user2) {
        final String value1 = user1.userName;
        final String value2 = user2.userName;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allUsers.sort((user1, user2) {
        final String value1 = user1.email;
        final String value2 = user2.email;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allUsers.sort((user1, user2) {
        final String value1 = user1.createdAt.toString();
        final String value2 = user2.createdAt.toString();

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 3) {
      allUsers.sort((user1, user2) {
        final String value1 = user1.expiryDate.toString();
        final String value2 = user2.expiryDate.toString();

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
  void filterCards() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredUsers.clear();
    } else {
      filteredUsers.assignAll(
        allUsers.where((user) {
          return user.email.toString().toLowerCase().contains(query) ||
              user.userName.toString().toLowerCase().contains(query);
        }).toList(),
      );
    }
  }

  // // this functions is to change the user status from active / inactive
  // Future<void> changeUserStatus(String userId, bool status) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('sys-users')
  //         .doc(userId)
  //         .update({'status': status});
  //   } catch (e) {
  //     //
  //   }
  // }

  // Function to format the date
  String formatDate(DateTime date) {
    final formatter = DateFormat('yyyy-MM-dd');
    theDate.value = formatter.format(date);
    return formatter.format(date);
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  Future<void> selectDateContext(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate.value) {
      selectDate(picked);
    }
  }

  void changeObscureTextValue() {
    if (obscureText.value == true) {
      obscureText.value = false;
    } else {
      obscureText.value = true;
    }
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  Future<void> getRoles() async {
    try {
      isLoading.value = true;
      RxMap rolesMap = RxMap(await helper.getAllRoles());
      Map<String, List<dynamic>> tempSelectedRoles = {};
      for (var role in rolesMap.values) {
        tempSelectedRoles[role['role_name']] = [role["_id"], false];
      }
      selectedRoles.assignAll(tempSelectedRoles);
    } catch (e) {
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }
}
