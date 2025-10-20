import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datahubai/consts.dart';
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
  final RxList<TimeSheetsModel> allTimeSheets = RxList<TimeSheetsModel>([]);
  final RxList<ApprovedJobsModel> allJobCards = <ApprovedJobsModel>[].obs;
  final Map<String, Map<String, String>> modelCache = {};
  final Map<String, String> colorCache = {};
  String backendUrl = backendTestURI;
  WebSocketService ws = Get.find<WebSocketService>();

  @override
  void onInit() async {
    connectWebSocket();
    startRealTimeTimer();
    // getAllTimeSheets();

    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void connectWebSocket() {
    ws.events.listen(
      (message) {
        try {
          if (message["type"] == "timesheet_update") {
            final payload = jsonDecode(message["payload"]);
            final opType = payload["operationType"];
            final doc = payload["fullDocument"];

            // Convert to your TimeSheetsModel
            final timeSheet = TimeSheetsModel.fromJson(doc);

            if (opType == "insert") {
              allTimeSheets.add(timeSheet);
            } else if (opType == "update" || opType == "replace") {
              final i = allTimeSheets.indexWhere((e) => e.id == timeSheet.id);
              if (i != -1) {
                allTimeSheets[i] = timeSheet;
              } else {
                // If not found, treat as new
                allTimeSheets.add(timeSheet);
              }
            } else if (opType == "delete") {
              final id = payload["documentKey"]["_id"]["\$oid"];
              allTimeSheets.removeWhere((e) => e.id == id);
            }
          }
        } catch (e) {
          // print("❌ WebSocket parse error: $e");
        }
      },
      onError: (err) {
        // print("❌ WebSocket error: $err");
      },
      onDone: () async {
        // print("🔌 WebSocket disconnected, retrying in 5s...");
        await Future.delayed(const Duration(seconds: 5));
        connectWebSocket(); // Auto-reconnect
      },
    );
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
  });
}


  Future getAllTechnicians() async {
    isScreenLodingForTechnicians.value = true;
    allTechnician.assignAll(await helper.getAllTechnicians());
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

  // ============================================================================================================
  bool hasActiveTask(String employeeId) {
    final hasActiveJob = allTimeSheets.any((doc) {
      if (doc.employeeId != employeeId) return false;

      final List<ActivePeriods> periods = doc.activePeriods ?? [];
      return periods.isNotEmpty && periods.last.to == null;
    });

    if (hasActiveJob) {
      // Show warning (you can use your custom snackbar/dialog here)
      showSnackBar('Alert', 'This employee is already working on another job!');
      return true;
    }
    return false;
  }

  // void startRealTimeTimer() {
  //   _timer = Timer.periodic(const Duration(seconds: 1), (_) {
  //     for (var doc in allTimeSheets) {
  //       final String sheetId = doc.id;
  //       final periods = doc['active_periods'] as List<dynamic>;

  //       Duration total = const Duration();

  //       // Check if job is paused (i.e. last period is closed)
  //       bool isPaused = periods.isNotEmpty && periods.last['to'] != null;

  //       for (var period in periods) {
  //         final from = (period['from'] as Timestamp).toDate();
  //         final toRaw = period['to'];
  //         // إذا الفترة مغلقة نحسبها
  //         if (toRaw != null) {
  //           final to = (toRaw as Timestamp).toDate();
  //           total += to.difference(from);
  //         } else if (!isPaused) {
  //           // إذا شغالة حاليا، نحسب الوقت حتى الآن
  //           total += DateTime.now().difference(from);
  //         }
  //       }

  //       sheetDurations[sheetId] = total;
  //     }
  //   });
  // }

  Future<void> startFunction() async {
    try {
      startSheet.value = true;
      final now = Timestamp.now();
      await FirebaseFirestore.instance
          .collection('time_sheets')
          .add({
            // 'company_id': companyId.value,
            'job_id': selectedJobId.value,
            'employee_id': selectedEmployeeId.value,
            'task_id': selectedTaskId.value,
            'start_date': now,
            'end_date': null,
            'active_periods': [
              {'from': now, 'to': null},
            ],
          })
          .then((_) {
            selectedEmployeeId.value = '';
            selectedEmployeeName.value = '';
            selectedJob.value = '';
            selectedJobId.value = '';
            selectedTask.value = '';
            selectedTask.value = '';
            startSheet.value = false;
          });
    } catch (e) {
      startSheet.value = false;
    }
  }

  Future<void> pauseFunction(DocumentSnapshot doc) async {
    final sheetId = doc.id;
    final List<dynamic> currentPeriods = List.from(doc['active_periods']);

    // إذا في فترة مفتوحة سكّرها
    if (currentPeriods.isNotEmpty && currentPeriods.last['to'] == null) {
      currentPeriods[currentPeriods.length - 1]['to'] = Timestamp.fromDate(
        DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('time_sheets')
          .doc(sheetId)
          .update({'active_periods': currentPeriods});
    }
  }

  Future<void> continueFunction(DocumentSnapshot doc) async {
    final sheetId = doc.id;
    final List<dynamic> currentPeriods = List.from(doc['active_periods']);

    final lastPeriod = currentPeriods.isNotEmpty ? currentPeriods.last : null;
    if (lastPeriod != null && lastPeriod['to'] == null) {
      return;
    }

    final newPeriod = {'from': Timestamp.fromDate(DateTime.now()), 'to': null};

    currentPeriods.add(newPeriod);

    await FirebaseFirestore.instance
        .collection('time_sheets')
        .doc(sheetId)
        .update({'active_periods': currentPeriods});
  }

  Future<void> finishFunction(DocumentSnapshot doc) async {
    final sheetId = doc.id;
    final List<dynamic> currentPeriods = List.from(doc['active_periods']);

    if (currentPeriods.isNotEmpty && currentPeriods.last['to'] == null) {
      currentPeriods[currentPeriods.length - 1]['to'] = Timestamp.fromDate(
        DateTime.now(),
      );
    }

    await FirebaseFirestore.instance
        .collection('time_sheets')
        .doc(sheetId)
        .update({
          'active_periods': currentPeriods,
          'end_date': Timestamp.fromDate(DateTime.now()),
        });
  }

  Future<void> pauseAllFunction(List<DocumentSnapshot> allDocs) async {
    final batch = FirebaseFirestore.instance.batch();

    for (var doc in allDocs) {
      final docRef = doc.reference;
      final List<dynamic> periods = List.from(doc['active_periods']);

      // Check if there's an open period
      if (periods.isNotEmpty && periods.last['to'] == null) {
        periods[periods.length - 1]['to'] = Timestamp.fromDate(DateTime.now());

        batch.update(docRef, {'active_periods': periods});
      }
    }

    await batch.commit();
  }

  void getAllTimeSheets() {
    try {
      // isScreenLoadingForTimesheets.value = true;
      // FirebaseFirestore.instance
      //     .collection('time_sheets')
      //     .where('company_id', isEqualTo: companyId.value)
      //     .where('end_date', isNull: true)
      //     .orderBy('start_date')
      //     .snapshots()
      //     .listen((tech) {
      //   allTimeSheets.assignAll(List<DocumentSnapshot>.from(tech.docs));
      //   isScreenLoadingForTimesheets.value = false;
      // });
    } catch (e) {
      isScreenLoadingForTimesheets.value = false;
    }
  }
}
