import 'dart:async';
import 'dart:convert';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/job tasks/job_tasks_model.dart';
import '../../Models/time sheets/approved_jobs_model.dart';
import '../../Models/time sheets/time_sheets_model.dart';
import '../../helpers.dart';
import 'websocket_controller.dart';

class TimeSheetsController extends GetxController {
  final RxMap<String, Duration> sheetDurations = <String, Duration>{}.obs;
  Timer? _timer;
  RxString selectedEmployeeName = RxString('');
  RxString selectedEmployeeId = RxString('');
  RxString selectedJob = RxString('');
  RxString selectedJobId = RxString('');
  RxString selectedTask = RxString('');
  RxString selectedTaskId = RxString('');
  RxBool isScreenLodingForTechnicians = RxBool(false);
  RxBool isScreenLodingForJobs = RxBool(false);
  RxBool isScreenLodingForJobTasks = RxBool(false);
  RxBool isScreenLoadingForTimesheets = RxBool(false);
  RxMap allBrands = RxMap({});
  RxMap allColors = RxMap({});
  RxBool startSheet = RxBool(false);
  final RxMap<String, dynamic> allTechnician = RxMap<String, dynamic>({});
  final RxList<JobTasksModel> allTasks = RxList<JobTasksModel>([]);
  final RxList<JobTasksModel> filteredTasks = RxList<JobTasksModel>([]);
  final RxList<TimeSheetsModel> allTimeSheets = RxList<TimeSheetsModel>([]);
  final RxList<ApprovedJobsModel> allJobCards = <ApprovedJobsModel>[].obs;
  final Map<String, Map<String, String>> modelCache = {};
  final Map<String, String> colorCache = {};
  String backendUrl = backendTestURI;
  WebSocketService ws = Get.find<WebSocketService>();
  RxBool pausingAllOpenTimeSheets = RxBool(false);

  @override
  void onInit() async {
    connectWebSocket();
    startRealTimeTimer();
    getAllTimeSheets();
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void connectWebSocket() {
    ws.events.listen((message) {
      switch (message["type"]) {
        case "time_sheets_start_function":
          final newCounter = TimeSheetsModel.fromJson(message["data"]);
          allTimeSheets.add(newCounter);
          break;

        case "time_sheets_pause_function":
          String updatedId = message["data"]['_id'];
          int index = allTimeSheets.indexWhere((m) => m.id == updatedId);
          if (index != -1) {
            List<ActivePeriods> period =
                allTimeSheets[index].activePeriods ?? [];
            period.last.to = DateTime.now();
            allTimeSheets.refresh();
          }
          break;

        case "time_sheets_continue_function":
          String updatedId = message["data"]["_id"];
          int index = allTimeSheets.indexWhere((m) => m.id == updatedId);
          if (index != -1) {
            List<ActivePeriods> period =
                allTimeSheets[index].activePeriods ?? [];
            period.add(ActivePeriods(from: DateTime.now(), to: null));
            allTimeSheets.refresh();
          }
          break;
        case "time_sheets_finish_function":
          String updatedId = message["data"]["_id"];
          allTimeSheets.removeWhere((m) => m.id == updatedId);
          allTimeSheets.refresh();

          break;
      }
    });
  }

  void filterJobTasks(String? category) {
    if (category == null) {
      filteredTasks.clear();
    }
    filteredTasks.assignAll(
      allTasks.where(
        (task) => task.category?.toString().trim() == category?.trim(),
      ),
    );
    filteredTasks.refresh();
    allTasks.refresh();
  }

  void onChooseForLabelPicker(int index) {
    if (index == 1) {
      filterJobTasks(null);
    } else {
      filterJobTasks((index - 1).toString());
    }
  }

  Map<int, Widget> buildSegmentedButtons(List list) {
    final Map<int, Widget> map = {1: const Text('ALL')};

    for (int i = 1; i <= list.length; i++) {
      map[i + 1] = Text('$i ');
    }
    return map;
  }

  void startRealTimeTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      for (final sheet in allTimeSheets) {
        final periods = sheet.activePeriods;
        if (periods == null || periods.isEmpty) {
          sheetDurations[sheet.id ?? ''] = Duration.zero;
          continue;
        }

        Duration total = Duration.zero;

        for (final period in periods) {
          final from = period.from;
          if (from == null) continue;

          final to = period.to ?? DateTime.now();
          total += to.difference(from);
        }

        sheetDurations[sheet.id ?? ''] = total;
      }
      allTimeSheets.refresh();
    });
  }

  Future<void> getAllTimeSheets() async {
    try {
      isScreenLoadingForTimesheets.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/time_sheets/get_all_time_sheets');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List sheets = decoded['time_sheets'];
        allTimeSheets.assignAll(
          sheets.map((sheet) => TimeSheetsModel.fromJson(sheet)),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllTimeSheets();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      isScreenLoadingForTimesheets.value = false;
    } catch (e) {
      isScreenLoadingForTimesheets.value = false;
    }
  }

  Future getAllTechnicians() async {
    isScreenLodingForTechnicians.value = true;
    allTechnician.assignAll(
      await helper.getAllEmployeesByDepartment('Time Sheets'),
    );
    isScreenLodingForTechnicians.value = false;
  }

  Future<void> getApprovedJobs() async {
    try {
      isScreenLodingForJobs.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/time_sheets/get_approval_jobs');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List approvedJobs = decoded['approved_jobs'];
        allJobCards.assignAll(
          approvedJobs.map((item) => ApprovedJobsModel.fromJson(item)),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getApprovedJobs();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      isScreenLodingForJobs.value = false;
    } catch (e) {
      isScreenLodingForJobs.value = false;
    }
  }

  Future<void> gettAllJobTasks() async {
    try {
      isScreenLodingForJobTasks.value = true;

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
        allTasks.assignAll(tasks.map((task) => JobTasksModel.fromJson(task)));
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await gettAllJobTasks();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      isScreenLodingForJobTasks.value = false;
    } catch (e) {
      isScreenLodingForJobTasks.value = false;
    }
  }

  Future<void> startFunction() async {
    try {
      startSheet.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/time_sheets/start_function');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "job_id": selectedJobId.value,
          "employee_id": selectedEmployeeId.value,
          "task_id": selectedTaskId.value,
        }),
      );
      if (response.statusCode == 200) {
        selectedEmployeeId.value = '';
        selectedEmployeeName.value = '';
        selectedJob.value = '';
        selectedJobId.value = '';
        selectedTask.value = '';
        selectedTask.value = '';
        startSheet.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await startFunction();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      startSheet.value = false;
    } catch (e) {
      startSheet.value = false;
    }
  }

  Future<void> pauseFunction(String? id) async {
    try {
      if (id == null || id == '') {
        return;
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/time_sheets/pause_function/$id');
      final response = await http.patch(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await pauseFunction(id);
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

  Future<void> continueFunction(String? id) async {
    try {
      if (id == null || id == '') {
        return;
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/time_sheets/continue_function/$id');
      final response = await http.patch(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await continueFunction(id);
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

  Future<void> finishFunction(String? id) async {
    try {
      if (id == null || id == '') {
        return;
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/time_sheets/finish_function/$id');
      final response = await http.patch(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await finishFunction(id);
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

  Future<void> pauseAllFunction() async {
    try {
      pausingAllOpenTimeSheets.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/time_sheets/pause_all_function');
      final response = await http.patch(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        await getAllTimeSheets();
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await pauseAllFunction();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      pausingAllOpenTimeSheets.value = false;
    } catch (e) {
      pausingAllOpenTimeSheets.value = false;
    }
  }

  // ============================================================================================================
  bool hasActiveTask(String employeeId) {
    final hasActiveJob = allTimeSheets.any((doc) {
      if (doc.employeeId != employeeId) return false;

      final List<ActivePeriods> periods = doc.activePeriods ?? [];
      return periods.isNotEmpty && periods.last.to == null;
    });

    if (hasActiveJob) {
      // Show warning (you can use your custom snackbar/dialog here)
      alertMessage(
        context: Get.context!,
        content: 'This employee is already working on another job!',
      );
      return true;
    }
    return false;
  }
}
