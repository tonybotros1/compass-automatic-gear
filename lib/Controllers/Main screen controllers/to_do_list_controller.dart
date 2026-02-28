import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/to do list/to_do_list_description_model.dart';
import '../../Models/to do list/to_do_list_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import 'main_screen_contro.dart';
import 'websocket_controller.dart';

class ToDoListController extends GetxController {
  RxBool isScreenLoding = RxBool(false);
  final RxList<ToDoListModel> allToDoLists = RxList<ToDoListModel>([]);
  TextEditingController numberFilter = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController dateFilter = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController dueDateFilter = TextEditingController();
  TextEditingController dueDate = TextEditingController();
  TextEditingController createdByFilter = TextEditingController();
  TextEditingController createdBy = TextEditingController();
  RxString createdByFilterId = RxString('');
  RxString createdById = RxString('');
  TextEditingController assignedToFilter = TextEditingController();
  TextEditingController assignedTo = TextEditingController();
  RxString assignedToFilterId = RxString('');
  RxString assignedToId = RxString('');
  TextEditingController statusFilter = TextEditingController();
  TextEditingController status = TextEditingController();
  TextEditingController description = TextEditingController();
  Rx<TextEditingController> fromDate = TextEditingController().obs;
  Rx<TextEditingController> toDate = TextEditingController().obs;
  RxInt initDatePickerValue = RxInt(1);
  RxInt initStatusPickersValue = RxInt(2);
  RxBool addingNewValue = RxBool(false);
  RxMap companyDetails = RxMap({});

  FocusNode textFieldFocusNode = FocusNode();
  Rx<TextEditingController> descriptionNote = TextEditingController().obs;
  RxString noteMessage = RxString('');
  RxBool addingNewDescriptionNotProcess = RxBool(false);
  final ScrollController scrollControllerForNotes = ScrollController();
  RxBool isDescriptionNotesLoading = RxBool(false);
  final RxList<ToDoListDescriptionModel> allDescriptionNotes =
      RxList<ToDoListDescriptionModel>([]);
  RxString currentTaskId = RxString('');
  String backendUrl = backendTestURI;
  final selectedRowIndex = (-1).obs;
  WebSocketService ws = Get.find<WebSocketService>();
  StreamSubscription<Map<String, dynamic>>? _wsSub;
  MainScreenController mainScreenController = Get.find<MainScreenController>();
  @override
  void onInit() async {
    getUserId();
    await getCompanyDetails();
    statusFilter.text = 'Open';
    filterSearch();
    super.onInit();
  }

  @override
  void onClose() {
    _wsSub?.cancel();
    super.onClose();
  }

  Future<Map<String, dynamic>> getSysUsersForLOV() async {
    return await helper.getSysUsersForLOV();
  }

  Future<void> getCompanyDetails() async {
    companyDetails.assignAll(await helper.getCurrentCompanyDetails());
  }

  void getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userId = prefs.getString('userId');
    initSocket(userId ?? '');
  }

  void initSocket(String userId) {
    ws.connect(userId);
    _wsSub?.cancel();
    _wsSub = ws.events.listen((message) async {
      switch (message["type"]) {
        case "chat_message":
          final taskId = (message["task_id"] ?? "").toString();
          if (taskId == currentTaskId.value) {
            final newNote = ToDoListDescriptionModel.fromJson(message["data"]);
            allDescriptionNotes.add(newNote);
            allDescriptionNotes.refresh();
            await markTaskAsRead(taskId);
          }
          break;

        case 'new_task_created':
          final newTask = ToDoListModel.fromJson(message["data"]);
          allToDoLists.add(newTask);
          break;

        case "chat_unread":
          mainScreenController.unreadChatCount.value =
              (message["unread_total"] ?? 0) as int;
          break;

        case "new_task_description_note_added":
          final newNote = ToDoListDescriptionModel.fromJson(message["data"]);
          allDescriptionNotes.add(newNote);
          break;

        case "task_status_updated":
          final taskId = message["data"]['_id'];
          final taskStatus = message["data"]['status'];
          final index = allToDoLists.indexWhere((m) => m.id == taskId);
          if (index != -1) {
            allToDoLists[index].status = taskStatus;
            allToDoLists.refresh();
          }
          break;
      }
    });
  }

  Future<void> markTaskAsRead(String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = '${prefs.getString('accessToken')}';

    final url = Uri.parse('$backendUrl/to_do_list/tasks/$taskId/read');
    final res = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      mainScreenController.unreadChatCount.value =
          (body['unread_total'] ?? 0) as int;
    }
  }

  // void connectWebSocket() {
  //   ws.events.listen((message) {
  //     switch (message["type"]) {
  //       case "new_task_description_note_added":
  //         final newNote = ToDoListDescriptionModel.fromJson(message["data"]);
  //         allDescriptionNotes.add(newNote);
  //         break;

  //       case "task_status_updated":
  //         final taskId = message["data"]['_id'];
  //         final taskStatus = message["data"]['status'];
  //         final index = allToDoLists.indexWhere((m) => m.id == taskId);
  //         if (index != -1) {
  //           allToDoLists[index].status = taskStatus;
  //           allToDoLists.refresh();
  //         }
  //         break;

  //       // case "branch_updated":
  //       //   final updated = BranchesModel.fromJson(message["data"]);
  //       //   final index = allBranches.indexWhere((m) => m.id == updated.id);
  //       //   if (index != -1) {
  //       //     allBranches[index] = updated;
  //       //   }
  //       //   break;

  //       // case "branch_deleted":
  //       //   final deletedId = message["data"]["_id"];
  //       //   allBranches.removeWhere((m) => m.id == deletedId);
  //       //   break;
  //     }
  //   });
  // }

  String getScreenName() {
    return mainScreenController.selectedScreenName.value;
  }

  void selectRow(int index) {
    selectedRowIndex.value = index;
    // update();
  }

  bool whoCanEdit() {
    return companyDetails['current_user_id'] == createdById.value ||
        companyDetails['is_admin'];
  }

  void onChooseForDatePicker(int i) {
    switch (i) {
      case 1:
        initDatePickerValue.value = 1;
        fromDate.value.clear();
        toDate.value.clear();
        break;
      case 2:
        initDatePickerValue.value = 2;
        setTodayRange(fromDate: fromDate.value, toDate: toDate.value);
        filterSearch();
        break;
      case 3:
        initDatePickerValue.value = 3;
        setThisMonthRange(fromDate: fromDate.value, toDate: toDate.value);
        filterSearch();
        break;
      case 4:
        initDatePickerValue.value = 4;
        setThisYearRange(fromDate: fromDate.value, toDate: toDate.value);
        filterSearch();
        break;
      default:
    }
  }

  void onChooseForStatusPicker(int i) {
    switch (i) {
      case 1:
        initStatusPickersValue.value = 1;
        statusFilter.clear();
        filterSearch();
        break;
      case 2:
        initStatusPickersValue.value = 2;
        statusFilter.text = 'Open';
        filterSearch();
        break;
      case 3:
        initStatusPickersValue.value = 3;
        statusFilter.text = 'Closed';
        filterSearch();
        break;
      case 4:
        initStatusPickersValue.value = 4;
        statusFilter.text = 'Cancelled';
        filterSearch();
        break;
      default:
    }
  }

  Future<void> addNewTask() async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/to_do_list/add_new_task');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "date": convertDateToIson(date.text),
          "due_date": convertDateToIson(dueDate.text),
          "created_by": createdById.value,
          "assigned_to": assignedToId.value,
          "status": status.text,
          "description": description.text.trim(),
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

  Future<void> addNewTaskDescriptionNote() async {
    try {
      if (currentTaskId.value.isEmpty) {
        alertMessage(context: Get.context!, content: 'Select task first');
        return;
      }
      addingNewDescriptionNotProcess.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/to_do_list/add_new_task_description_note',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "to_do_list_id": currentTaskId.value,
          "type": 'text',
          "description": noteMessage.value.trim(),
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
      addingNewDescriptionNotProcess.value = false;
    } catch (e) {
      addingNewDescriptionNotProcess.value = false;
    }
  }

  Future<void> getTaskDescriptions(String taskId) async {
    try {
      isDescriptionNotesLoading.value = true;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/to_do_list/get_task_descriptions/$taskId',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List jobs = decoded['descriptions'];
        allDescriptionNotes.assignAll(
          jobs.map((task) => ToDoListDescriptionModel.fromJson(task)),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getTaskDescriptions(taskId);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }

      isDescriptionNotesLoading.value = false;
    } catch (e) {
      isDescriptionNotesLoading.value = false;
    }
  }

  Future<void> updateTaskStatus(String id, String status) async {
    try {
      if (currentTaskId.value.isEmpty) {
        alertMessage(context: Get.context!, content: 'Select task first');
        return;
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/to_do_list/update_task_status/$id');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({"status": status}),
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 400) {
        alertMessage(
          context: Get.context!,
          content: "Please select valid task",
        );
        return;
      } else if (response.statusCode == 404) {
        alertMessage(context: Get.context!, content: "Task not found");
        return;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await updateTaskStatus(id, status);
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

  void filterSearch() async {
    Map<String, dynamic> body = {};
    if (numberFilter.text.isNotEmpty) {
      body["number"] = numberFilter.text;
    }
    if (dateFilter.text.isNotEmpty) {
      body["date"] = dateFilter.text;
    }
    if (dueDateFilter.text.isNotEmpty) {
      body["due_date"] = dueDateFilter.text;
    }
    if (createdByFilter.text.isNotEmpty) {
      body["created_by"] = createdByFilter.text;
    }
    if (assignedToFilter.text.isNotEmpty) {
      body["assigned_to"] = assignedToFilter.text;
    }
    if (statusFilter.text.isNotEmpty) {
      body["status"] = statusFilter.value.text;
    }
    if (fromDate.value.text.isNotEmpty) {
      body["from_date"] = convertDateToIson(fromDate.value.text);
    }
    if (toDate.value.text.isNotEmpty) {
      body["to_date"] = convertDateToIson(toDate.value.text);
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
      currentTaskId.value = '';
      allDescriptionNotes.clear();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/to_do_list/search_engine_for_to_do_list',
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
        List jobs = decoded['tasks'];
        allToDoLists.assignAll(
          jobs.map((task) => ToDoListModel.fromJson(task)),
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
    numberFilter.clear();
    dateFilter.clear();
    dueDateFilter.clear();
    createdByFilter.clear();
    assignedToFilter.clear();
    createdByFilterId.value = '';
    assignedToFilterId.value = '';
    fromDate.value.clear();
    toDate.value.clear();
    initDatePickerValue.value = 1;
    initStatusPickersValue.value = 1;
  }
}
