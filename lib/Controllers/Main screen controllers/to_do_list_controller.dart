import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/to do list/to_do_list_description_model.dart';
import '../../Models/to do list/to_do_list_model.dart';
import '../../Services/notification_sound_service.dart';
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
  NotificationSoundService notificationSound =
      Get.find<NotificationSoundService>();
  StreamSubscription<Map<String, dynamic>>? _wsSub;
  MainScreenController mainScreenController = Get.find<MainScreenController>();
  RxString userId = RxString('');
  RxString companyId = RxString('');
  Rx<Uint8List?> fileBytes = Rx<Uint8List?>(null);
  RxString fileType = RxString('');
  RxString fileName = RxString('');
  RxString editingTaskId = RxString('');

  @override
  void onInit() async {
    await getUserId();
    initSocket(userId.value);

    await getCompanyDetails();
    statusFilter.text = 'Open';
    filterSearch();
    super.onInit();
  }

  @override
  void onClose() {
    _wsSub?.cancel();
    numberFilter.dispose();
    number.dispose();
    dateFilter.dispose();
    date.dispose();
    dueDateFilter.dispose();
    dueDate.dispose();
    createdByFilter.dispose();
    createdBy.dispose();
    assignedToFilter.dispose();
    assignedTo.dispose();
    statusFilter.dispose();
    status.dispose();
    description.dispose();
    fromDate.value.dispose();
    toDate.value.dispose();
    textFieldFocusNode.dispose();
    descriptionNote.value.dispose();
    scrollControllerForNotes.dispose();
    super.onClose();
  }

  Future<Map<String, dynamic>> getSysUsersForLOV() async {
    return await helper.getSysUsersForLOV();
  }

  String _responseErrorMessage(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      final detail = decoded['detail'];
      if (detail is String && detail.trim().isNotEmpty) return detail;
    } catch (_) {
      //
    }
    return 'Something went wrong please try again';
  }

  String? _isoDateOrAlert(TextEditingController controller, String label) {
    final value = controller.text.trim();
    if (value.isEmpty) {
      showSnackBar('Alert', '$label is required');
      return null;
    }

    final isoDate = convertDateToIson(value);
    if (isoDate == null) {
      showSnackBar('Alert', '$label is invalid');
      return null;
    }
    return isoDate;
  }

  void _upsertTask(ToDoListModel task) {
    final index = allToDoLists.indexWhere((item) => item.id == task.id);
    if (index == -1) {
      allToDoLists.add(task);
    } else {
      allToDoLists[index] = task;
    }
    allToDoLists.refresh();
  }

  void _upsertNote(ToDoListDescriptionModel note) {
    final noteId = note.id ?? '';
    final index = noteId.isEmpty
        ? -1
        : allDescriptionNotes.indexWhere((item) => item.id == noteId);
    if (index == -1) {
      allDescriptionNotes.add(note);
    } else {
      allDescriptionNotes[index] = note;
    }
    allDescriptionNotes.refresh();
  }

  ToDoListModel? _taskFromResponseBody(String body) {
    final decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic>) return null;

    final taskPayload = decoded['task'];
    if (taskPayload is Map<String, dynamic>) {
      return ToDoListModel.fromJson(taskPayload);
    }
    if (taskPayload is Map) {
      return ToDoListModel.fromJson(Map<String, dynamic>.from(taskPayload));
    }
    return ToDoListModel.fromJson(decoded);
  }

  void _showTaskNotification(String title, String body) {
    notificationSound.playTaskNotification();
    showSnackBar(title, body);
  }

  bool canEditTask(ToDoListModel task) {
    final currentUserId = (companyDetails['current_user_id'] ?? userId.value)
        .toString();
    return companyDetails['is_admin'] == true ||
        (task.createdById ?? '') == currentUserId;
  }

  void prepareNewTask() {
    editingTaskId.value = '';
    number.clear();
    date.text = textToDate(DateTime.now());
    dueDate.text = textToDate(DateTime.now());
    createdBy.text = (companyDetails['current_user_name'] ?? '').toString();
    createdById.value = (companyDetails['current_user_id'] ?? userId.value)
        .toString();
    assignedTo.clear();
    assignedToId.value = '';
    status.text = 'Open';
    description.clear();
  }

  void prepareEditTask(ToDoListModel task) {
    editingTaskId.value = task.id ?? '';
    number.text = task.number ?? '';
    date.text = textToDate(task.date);
    dueDate.text = textToDate(task.dueDate);
    createdBy.text = task.createdBy ?? '';
    createdById.value = task.createdById ?? '';
    assignedTo.text = task.assignedTo ?? '';
    assignedToId.value = task.assignedToId ?? '';
    status.text = task.status ?? '';
    description.clear();
  }

  Future<void> getCompanyDetails() async {
    companyDetails.assignAll(await helper.getCurrentCompanyDetails());
  }

  Future<void> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    userId.value = (prefs.getString('userId') ?? '').trim();
    companyId.value = (prefs.getString('companyId') ?? '').trim();
  }

  void initSocket(String socketUserId) {
    final normalizedUserId = socketUserId.trim();
    final normalizedCompanyId = companyId.trim();
    if (normalizedUserId.isNotEmpty && normalizedCompanyId.isNotEmpty) {
      ws.connect(normalizedUserId, normalizedCompanyId);
    }

    _wsSub?.cancel();
    _wsSub = ws.events.listen((message) async {
      switch (message["type"]) {
        case "chat_message":
          final taskId = (message["task_id"] ?? "").toString();
          final payload = message["data"];
          final fromUserId = (message["from_user_id"] ?? '').toString();
          if (taskId == currentTaskId.value) {
            if (payload is Map<String, dynamic>) {
              final newNote = ToDoListDescriptionModel.fromJson(payload);
              _upsertNote(newNote);
              await markTaskAsRead(taskId);
            } else if (payload is Map) {
              final newNote = ToDoListDescriptionModel.fromJson(
                Map<String, dynamic>.from(payload),
              );
              _upsertNote(newNote);
              await markTaskAsRead(taskId);
            }
          } else if (fromUserId.isNotEmpty && fromUserId != userId.value) {
            _showTaskNotification('To Do List', 'New message on a task');
          }
          break;

        case 'new_task_created':
          final payload = message["data"];
          final createdBy = (message["created_by"] ?? '').toString();
          if (payload is Map<String, dynamic>) {
            final newTask = ToDoListModel.fromJson(payload);
            _upsertTask(newTask);
          } else if (payload is Map) {
            final newTask = ToDoListModel.fromJson(
              Map<String, dynamic>.from(payload),
            );
            _upsertTask(newTask);
          }
          if (createdBy.isNotEmpty && createdBy != userId.value) {
            _showTaskNotification('To Do List', 'New task assigned to you');
          }
          break;

        case 'task_updated':
          final payload = message["data"];
          final updatedBy = (message["updated_by"] ?? '').toString();
          if (payload is Map<String, dynamic>) {
            _upsertTask(ToDoListModel.fromJson(payload));
          } else if (payload is Map) {
            _upsertTask(
              ToDoListModel.fromJson(Map<String, dynamic>.from(payload)),
            );
          }
          if (updatedBy.isNotEmpty && updatedBy != userId.value) {
            _showTaskNotification('To Do List', 'A task was updated');
          }
          break;

        case 'task_deleted':
          final payload = message["data"];
          final deletedBy = (message["deleted_by"] ?? '').toString();
          final taskId = payload is Map
              ? (payload['_id'] ?? '').toString()
              : '';
          allToDoLists.removeWhere((task) => task.id == taskId);
          if (currentTaskId.value == taskId) {
            currentTaskId.value = '';
            allDescriptionNotes.clear();
            selectedRowIndex.value = -1;
          }
          if (deletedBy.isNotEmpty && deletedBy != userId.value) {
            _showTaskNotification('To Do List', 'A task was deleted');
          }
          break;

        case 'task_note_deleted':
          final taskId = (message["task_id"] ?? '').toString();
          final noteId = (message["note_id"] ?? '').toString();
          final deletedBy = (message["deleted_by"] ?? '').toString();
          if (taskId == currentTaskId.value) {
            allDescriptionNotes.removeWhere((note) => note.id == noteId);
          }
          if (deletedBy.isNotEmpty && deletedBy != userId.value) {
            _showTaskNotification('To Do List', 'A task note was deleted');
          }
          break;

        // case "new_task_description_note_added":
        //   print('yes added');
        //   print(message["data"]);
        //   final newNote = ToDoListDescriptionModel.fromJson(message["data"]);
        //   allDescriptionNotes.add(newNote);
        //   break;

        case "task_status_updated":
          final payload = message["data"];
          if (payload is Map<String, dynamic>) {
            final taskId = payload['_id']?.toString() ?? '';
            final taskStatus = payload['status']?.toString();
            final index = allToDoLists.indexWhere((m) => m.id == taskId);
            if (index != -1) {
              allToDoLists[index].status = taskStatus;
              allToDoLists.refresh();
            }
          } else if (payload is Map) {
            final normalized = Map<String, dynamic>.from(payload);
            final taskId = normalized['_id']?.toString() ?? '';
            final taskStatus = normalized['status']?.toString();
            final index = allToDoLists.indexWhere((m) => m.id == taskId);
            if (index != -1) {
              allToDoLists[index].status = taskStatus;
              allToDoLists.refresh();
            }
          }
          final updatedBy = (message["updated_by"] ?? '').toString();
          if (updatedBy.isNotEmpty && updatedBy != userId.value) {
            _showTaskNotification('To Do List', 'Task status changed');
          }
          break;
      }
    });
  }

  Future<void> markTaskAsRead(String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';
    if (accessToken.isEmpty || taskId.trim().isEmpty) return;

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
          int.tryParse((body['unread_total'] ?? 0).toString()) ?? 0;
    }
  }

  Color giveColorToDateForToDoTask(dynamic dateInput) {
    if (dateInput == null) return Colors.black;

    // Convert input to DateTime if it's not already
    DateTime? date;
    if (dateInput is DateTime) {
      date = dateInput;
    } else if (dateInput is String) {
      try {
        date = DateTime.parse(dateInput);
      } catch (e) {
        return Colors.black; // invalid string format
      }
    } else {
      return Colors.black; // unsupported type
    }

    // Normalize dates to remove time component
    final today = DateTime.now();
    final todayDateOnly = DateTime(today.year, today.month, today.day);
    final inputDateOnly = DateTime(date.year, date.month, date.day);

    final diffDays = inputDateOnly.difference(todayDateOnly).inDays;

    if (diffDays < 0) {
      return Colors.red;
    } else if (diffDays == 0) {
      return Colors.green;
    } else if (diffDays <= 15) {
      return Colors.orange;
    } else {
      return Colors.black;
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
        companyDetails['is_admin'] == true;
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
    if (addingNewValue.value) return;

    final taskDate = _isoDateOrAlert(date, 'Date');
    if (taskDate == null) return;
    final taskDueDate = _isoDateOrAlert(dueDate, 'Due date');
    if (taskDueDate == null) return;
    if (createdById.value.trim().isEmpty) {
      showSnackBar('Alert', 'Created By is required');
      return;
    }
    if (assignedToId.value.trim().isEmpty) {
      showSnackBar('Alert', 'Assigned To is required');
      return;
    }
    if (description.text.trim().isEmpty) {
      showSnackBar('Alert', 'Description is required');
      return;
    }

    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      final refreshToken = await secureStorage.read(key: "refreshToken") ?? '';
      Uri url = Uri.parse('$backendUrl/to_do_list/add_new_task');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "date": taskDate,
          "due_date": taskDueDate,
          "created_by": createdById.value,
          "assigned_to": assignedToId.value,
          "description": description.text.trim(),
        }),
      );
      if (response.statusCode == 200) {
        final newTask = _taskFromResponseBody(response.body);
        if (newTask != null) _upsertTask(newTask);
        Get.back();
        return;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          addingNewValue.value = false;
          await addNewTask();
          return;
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
          return;
        }
      } else if (response.statusCode == 401) {
        logout();
        return;
      } else {
        showSnackBar('Alert', _responseErrorMessage(response));
      }
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
    } finally {
      addingNewValue.value = false;
    }
  }

  Future<bool> addNewTaskDescriptionNote(
    String toDoListId,
    Map<String, dynamic> note,
  ) async {
    if (addingNewDescriptionNotProcess.value) return false;
    if (currentTaskId.value.isEmpty || toDoListId.trim().isEmpty) {
      showSnackBar('Alert', 'Select task first');
      return false;
    }

    final noteType = (note['note_type'] ?? '').toString();
    if (noteType == 'text') {
      final message = (note['note'] ?? '').toString().trim();
      if (message.isEmpty) {
        showSnackBar('Alert', 'Message is required');
        return false;
      }
      note['note'] = message;
    } else {
      final mediaNote = note['media_note'];
      final selectedFileName = (note['file_name'] ?? '').toString().trim();
      if (selectedFileName.isEmpty || mediaNote is! List<int>) {
        showSnackBar('Alert', 'Please select a valid file');
        return false;
      }
    }

    try {
      addingNewDescriptionNotProcess.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      final refreshToken = await secureStorage.read(key: "refreshToken") ?? '';
      Uri url = Uri.parse(
        '$backendUrl/to_do_list/add_new_task_description_note/$toDoListId',
      );
      final request = http.MultipartRequest('POST', url);
      request.headers.addAll({'Authorization': 'Bearer $accessToken'});
      if (noteType == 'text') {
        request.fields['note'] = note['note'];
        request.fields['note_type'] = noteType;
      } else {
        request.fields['file_name'] = note['file_name'];
        request.fields['note_type'] = noteType;
        request.files.add(
          http.MultipartFile.fromBytes(
            'media_note',
            note['media_note'],
            filename: note['file_name'],
          ),
        );
      }
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final notePayload = decoded is Map<String, dynamic>
            ? decoded['data']
            : null;
        if (notePayload is Map<String, dynamic>) {
          _upsertNote(ToDoListDescriptionModel.fromJson(notePayload));
        } else if (notePayload is Map) {
          _upsertNote(
            ToDoListDescriptionModel.fromJson(
              Map<String, dynamic>.from(notePayload),
            ),
          );
        }
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          addingNewDescriptionNotProcess.value = false;
          return await addNewTaskDescriptionNote(toDoListId, note);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
          return false;
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        showSnackBar('Alert', _responseErrorMessage(response));
      }
      return false;
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
      return false;
    } finally {
      addingNewDescriptionNotProcess.value = false;
    }
  }

  Future<void> getTaskDescriptions(String taskId) async {
    try {
      isDescriptionNotesLoading.value = true;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      final refreshToken = await secureStorage.read(key: "refreshToken") ?? '';
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
      } else {
        showSnackBar('Alert', _responseErrorMessage(response));
      }

      isDescriptionNotesLoading.value = false;
    } catch (e) {
      showSnackBar('Alert', 'Could not load task notes');
      isDescriptionNotesLoading.value = false;
    }
  }

  Future<bool> updateTaskStatus(String id, String status) async {
    if (id.trim().isEmpty) {
      showSnackBar('Alert', 'Please select valid task');
      return false;
    }
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      final refreshToken = await secureStorage.read(key: "refreshToken") ?? '';
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
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          final taskId = (decoded['_id'] ?? id).toString();
          final nextStatus = (decoded['status'] ?? status).toString();
          final index = allToDoLists.indexWhere((task) => task.id == taskId);
          if (index != -1) {
            allToDoLists[index].status = nextStatus;
            allToDoLists.refresh();
          }
        }
        return true;
      } else if (response.statusCode == 400) {
        showSnackBar('Alert', _responseErrorMessage(response));
        return false;
      } else if (response.statusCode == 404) {
        showSnackBar('Alert', 'Task not found');
        return false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await updateTaskStatus(id, status);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
          return false;
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        showSnackBar('Alert', _responseErrorMessage(response));
      }
      return false;
    } catch (e) {
      showSnackBar('Alert', 'Could not update task status');
      return false;
    }
  }

  Future<void> updateTaskDetails(String id) async {
    if (addingNewValue.value) return;
    if (id.trim().isEmpty) {
      showSnackBar('Alert', 'Please select valid task');
      return;
    }

    final taskDate = _isoDateOrAlert(date, 'Date');
    if (taskDate == null) return;
    final taskDueDate = _isoDateOrAlert(dueDate, 'Due date');
    if (taskDueDate == null) return;
    if (createdById.value.trim().isEmpty) {
      showSnackBar('Alert', 'Created By is required');
      return;
    }
    if (assignedToId.value.trim().isEmpty) {
      showSnackBar('Alert', 'Assigned To is required');
      return;
    }

    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      final refreshToken = await secureStorage.read(key: "refreshToken") ?? '';
      final url = Uri.parse('$backendUrl/to_do_list/update_task/$id');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "date": taskDate,
          "due_date": taskDueDate,
          "created_by": createdById.value,
          "assigned_to": assignedToId.value,
          "description": description.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final updatedTask = _taskFromResponseBody(response.body);
        if (updatedTask != null) _upsertTask(updatedTask);
        Get.back();
        return;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          addingNewValue.value = false;
          await updateTaskDetails(id);
          return;
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
          return;
        }
      } else if (response.statusCode == 401) {
        logout();
        return;
      } else {
        showSnackBar('Alert', _responseErrorMessage(response));
      }
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
    } finally {
      addingNewValue.value = false;
    }
  }

  Future<bool> deleteTask(String id) async {
    if (id.trim().isEmpty) {
      showSnackBar('Alert', 'Please select valid task');
      return false;
    }

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      final refreshToken = await secureStorage.read(key: "refreshToken") ?? '';
      final url = Uri.parse('$backendUrl/to_do_list/delete_task/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        allToDoLists.removeWhere((task) => task.id == id);
        if (currentTaskId.value == id) {
          currentTaskId.value = '';
          allDescriptionNotes.clear();
          selectedRowIndex.value = -1;
        }
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await deleteTask(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
          return false;
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        showSnackBar('Alert', _responseErrorMessage(response));
      }
      return false;
    } catch (e) {
      showSnackBar('Alert', 'Could not delete task');
      return false;
    }
  }

  Future<bool> deleteTaskDescriptionNote(String noteId) async {
    if (noteId.trim().isEmpty) {
      showSnackBar('Alert', 'Please select valid note');
      return false;
    }

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      final refreshToken = await secureStorage.read(key: "refreshToken") ?? '';
      final url = Uri.parse(
        '$backendUrl/to_do_list/delete_task_description_note/$noteId',
      );
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        allDescriptionNotes.removeWhere((note) => note.id == noteId);
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await deleteTaskDescriptionNote(noteId);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
          return false;
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        showSnackBar('Alert', _responseErrorMessage(response));
      }
      return false;
    } catch (e) {
      showSnackBar('Alert', 'Could not delete note');
      return false;
    }
  }

  void filterSearch() async {
    Map<String, dynamic> body = {};
    if (numberFilter.text.isNotEmpty) {
      body["number"] = numberFilter.text;
    }
    if (dateFilter.text.isNotEmpty) {
      final isoDate = convertDateToIson(dateFilter.text);
      if (isoDate == null) {
        showSnackBar('Alert', 'Date is invalid');
        return;
      }
      body["date"] = isoDate;
    }
    if (dueDateFilter.text.isNotEmpty) {
      final isoDueDate = convertDateToIson(dueDateFilter.text);
      if (isoDueDate == null) {
        showSnackBar('Alert', 'Due date is invalid');
        return;
      }
      body["due_date"] = isoDueDate;
    }
    if (createdByFilterId.value.isNotEmpty) {
      body["created_by"] = createdByFilterId.value;
    }
    if (assignedToFilterId.value.isNotEmpty) {
      body["assigned_to"] = assignedToFilterId.value;
    }
    if (statusFilter.text.isNotEmpty) {
      body["status"] = statusFilter.text;
    }
    if (fromDate.value.text.isNotEmpty) {
      final isoFromDate = convertDateToIson(fromDate.value.text);
      if (isoFromDate == null) {
        showSnackBar('Alert', 'From date is invalid');
        return;
      }
      body["from_date"] = isoFromDate;
    }
    if (toDate.value.text.isNotEmpty) {
      final isoToDate = convertDateToIson(toDate.value.text);
      if (isoToDate == null) {
        showSnackBar('Alert', 'To date is invalid');
        return;
      }
      body["to_date"] = isoToDate;
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
      selectedRowIndex.value = -1;
      allDescriptionNotes.clear();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      final refreshToken = await secureStorage.read(key: "refreshToken") ?? '';
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
      } else {
        showSnackBar('Alert', _responseErrorMessage(response));
      }

      isScreenLoding.value = false;
    } catch (e) {
      showSnackBar('Alert', 'Could not load tasks');
      isScreenLoding.value = false;
    }
  }

  void clearAllFilters() {
    numberFilter.clear();
    dateFilter.clear();
    dueDateFilter.clear();
    createdByFilter.clear();
    assignedToFilter.clear();
    statusFilter.clear();
    createdByFilterId.value = '';
    assignedToFilterId.value = '';
    fromDate.value.clear();
    toDate.value.clear();
    initDatePickerValue.value = 1;
    initStatusPickersValue.value = 1;
    searchEngine({"all": true});
  }
}
