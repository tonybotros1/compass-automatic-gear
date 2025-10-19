import 'dart:convert';
import 'package:datahubai/Controllers/Main%20screen%20controllers/main_screen_contro.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/job tasks/job_tasks_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import 'websocket_controller.dart';

class JobTasksController extends GetxController {
  TextEditingController nameEN = TextEditingController();
  TextEditingController nameAR = TextEditingController();
  TextEditingController points = TextEditingController();
  TextEditingController category = TextEditingController();
  Rx<TextEditingController> search = TextEditingController().obs;
  RxString query = RxString('');
  RxBool isScreenLoding = RxBool(false);
  final RxList<JobTasksModel> allTasks = RxList<JobTasksModel>([]);
  final RxList<JobTasksModel> filteredTasks = RxList<JobTasksModel>([]);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  WebSocketService ws = Get.find<WebSocketService>();
  String backendUrl = backendTestURI;

  @override
  void onInit() async {
    connectWebSocket();
    getAllTasks();
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
        case "job_task_added":
          final newCounter = JobTasksModel.fromJson(message["data"]);
          allTasks.add(newCounter);
          break;

        case "job_task_updated":
          final updated = JobTasksModel.fromJson(message["data"]);
          final index = allTasks.indexWhere((m) => m.id == updated.id);
          if (index != -1) {
            allTasks[index] = updated;
          }
          break;

        case "job_task_deleted":
          final deletedId = message["data"]["_id"];
          allTasks.removeWhere((m) => m.id == deletedId);
          break;
      }
    });
  }

  Future<void> getAllTasks() async {
    try {
      isScreenLoding.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/job_tasks/get_all_job_tasks');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List tasks = decoded['job_tasks'];
        allTasks.assignAll(
          tasks.map((branch) => JobTasksModel.fromJson(branch)),
        );
        isScreenLoding.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllTasks();
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

  Future<void> addNewTask() async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/job_tasks/add_new_job_task');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'name_en': nameEN.text,
          'name_ar': nameAR.text,
          'points': double.tryParse(points.text) ?? 0,
          'category': category.text,
        }),
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewTask();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  Future<void> editTask(String id) async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/job_tasks/update_job_task/$id');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'name_en': nameEN.text,
          'name_ar': nameAR.text,
          'points': double.tryParse(points.text) ?? 0,
          'category': category.text,
        }),
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await editTask(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/job_tasks/delete_job_task/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteTask(id);
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
 

  // this function is to filter the search results for web
  void filterTasks() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredTasks.clear();
    } else {
      filteredTasks.assignAll(
        allTasks.where((task) {
          return task.nameEN.toString().toLowerCase().contains(query) ||
              task.nameAR.toString().contains(query) ||
              task.points.toString().contains(query) ||
              task.category.toString().contains(query) ||
              textToDate(
                task.createdAt,
              ).toString().toLowerCase().contains(query);
        }).toList(),
      );
    }
  }
}
