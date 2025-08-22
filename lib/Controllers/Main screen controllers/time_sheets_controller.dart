import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datahubai/consts.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimeSheetsController extends GetxController {
  final RxMap<String, Duration> sheetDurations = <String, Duration>{}.obs;
  Timer? _timer;
  RxString selectedEmployeeName = RxString('');
  RxString selectedEmployeeId = RxString('');
  RxString selectedJob = RxString('');
  RxString selectedJobId = RxString('');
  RxString selectedTask = RxString('');
  RxString selectedTaskId = RxString('');
  RxString companyId = RxString('');
  RxBool isScreenLoding = RxBool(false);
  RxBool isScreenLodingForJobs = RxBool(false);
  RxBool isScreenLodingForJobTasks = RxBool(false);
  RxBool isScreenLoadingForTimesheets = RxBool(false);
  RxMap allBrands = RxMap({});
  RxMap allColors = RxMap({});
  RxBool startSheet = RxBool(false);
  final RxList<DocumentSnapshot> allTechnician = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> allTasks = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> allTimeSheets = RxList<DocumentSnapshot>([]);
  // final RxList<QueryDocumentSnapshot<Map<String, dynamic>>> allJobCards =
  //     RxList<QueryDocumentSnapshot<Map<String, dynamic>>>([]);
  final RxList<Map<String, dynamic>> allJobCards = <Map<String, dynamic>>[].obs;

  final Map<String, Map<String, String>> modelCache = {};
  final Map<String, String> colorCache = {};

  @override
  void onInit() async {
    await getCompanyId();
    getCarBrands();
    await getColors();
    getAllTechnicians();
    getApprovedJobs();
    getAllJobTasks();
    getAllTimeSheets();
    _startRealTimeTimer();

    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  getCompanyId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId.value = prefs.getString('companyId')!;
  }

  bool hasActiveTask(employeeId) {
    final hasActiveJob = allTimeSheets.any((doc) {
      if (doc['employee_id'] != employeeId) return false;

      final List<dynamic> periods = doc['active_periods'];
      return periods.isNotEmpty && periods.last['to'] == null;
    });

    if (hasActiveJob) {
      // Show warning (you can use your custom snackbar/dialog here)
      showSnackBar('Alert', 'This employee is already working on another job!');
      return true;
    }
    return false;
  }

  void _startRealTimeTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      for (var doc in allTimeSheets) {
        final String sheetId = doc.id;
        final periods = doc['active_periods'] as List<dynamic>;

        Duration total = const Duration();

        // Check if job is paused (i.e. last period is closed)
        bool isPaused = periods.isNotEmpty && periods.last['to'] != null;

        for (var period in periods) {
          final from = (period['from'] as Timestamp).toDate();
          final toRaw = period['to'];
          // إذا الفترة مغلقة نحسبها
          if (toRaw != null) {
            final to = (toRaw as Timestamp).toDate();
            total += to.difference(from);
          } else if (!isPaused) {
            // إذا شغالة حاليا، نحسب الوقت حتى الآن
            total += DateTime.now().difference(from);
          }
        }

        sheetDurations[sheetId] = total;
      }
    });
  }

  

  Map<String, String> getjobInfosById(String id) {
    try {
      Map<String, dynamic> job =
          allJobCards.firstWhere((doc) => doc['id'] == id);

      return {
        'brand': job['car_brand'],
        'model': job['car_model'],
        'plate_number': job['plate_number'],
        'color': job['color'],
        'logo': job['car_brand_logo']
      };
    } catch (e) {
      return {};
    }
  }

  startFunction() async {
    try {
      startSheet.value = true;
      final now = Timestamp.now();
      await FirebaseFirestore.instance.collection('time_sheets').add({
        'company_id': companyId.value,
        'job_id': selectedJobId.value,
        'employee_id': selectedEmployeeId.value,
        'task_id': selectedTaskId.value,
        'start_date': now,
        'end_date': null,
        'active_periods': [
          {
            'from': now,
            'to': null,
          }
        ]
      }).then((_) {
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
      currentPeriods[currentPeriods.length - 1]['to'] =
          Timestamp.fromDate(DateTime.now());

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

    final newPeriod = {
      'from': Timestamp.fromDate(DateTime.now()),
      'to': null,
    };

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
      currentPeriods[currentPeriods.length - 1]['to'] =
          Timestamp.fromDate(DateTime.now());
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

        batch.update(docRef, {
          'active_periods': periods,
        });
      }
    }

    await batch.commit();
  }

  getAllTimeSheets() {
    try {
      isScreenLoadingForTimesheets.value = true;
      FirebaseFirestore.instance
          .collection('time_sheets')
          .where('company_id', isEqualTo: companyId.value)
          .where('end_date', isNull: true)
          .orderBy('start_date')
          .snapshots()
          .listen((tech) {
        allTimeSheets.assignAll(List<DocumentSnapshot>.from(tech.docs));
        isScreenLoadingForTimesheets.value = false;
      });
    } catch (e) {
      isScreenLoadingForTimesheets.value = false;
    }
  }

  getAllTechnicians() {
    try {
      isScreenLoding.value = true;
      FirebaseFirestore.instance
          .collection('all_technicians')
          .where('company_id', isEqualTo: companyId.value)
          .orderBy('name', descending: false)
          .snapshots()
          .listen((tech) {
        allTechnician.assignAll(List<DocumentSnapshot>.from(tech.docs));
        isScreenLoding.value = false;
      });
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  getAllJobTasks() {
    try {
      isScreenLodingForJobTasks.value = true;
      FirebaseFirestore.instance
          .collection('all_job_tasks')
          .where('company_id', isEqualTo: companyId.value)
          .orderBy('name_en', descending: false)
          .snapshots()
          .listen((tech) {
        allTasks.assignAll(List<DocumentSnapshot>.from(tech.docs));
        isScreenLodingForJobTasks.value = false;
      });
    } catch (e) {
      isScreenLodingForJobTasks.value = false;
    }
  }

  // getApprovedJobs() {
  //   try {
  //     isScreenLodingForJobs.value = true;
  //     FirebaseFirestore.instance
  //         .collection('job_cards')
  //         .where('company_id', isEqualTo: companyId.value)
  //         .where('job_status_2', isEqualTo: 'Approved')
  //         .orderBy('job_number')
  //         .snapshots()
  //         .listen((jobs) {
  //       allJobCards.assignAll(jobs.docs);
  //       isScreenLodingForJobs.value = false;
  //     });
  //   } catch (e) {
  //     isScreenLodingForJobs.value = false;
  //   }
  // }

  void getApprovedJobs() {
    isScreenLodingForJobs.value = true;

    FirebaseFirestore.instance
        .collection('job_cards')
        .where('company_id', isEqualTo: companyId.value)
        .where('job_status_2', isEqualTo: 'Approved')
        .orderBy('job_number')
        .snapshots()
        .listen((snapshot) async {
      List<Map<String, dynamic>> enrichedJobs = [];

      for (var doc in snapshot.docs) {
        final job = doc.data();
        job['id'] = doc.id;

        // جلب الأسماء المرتبطة بشكل متزامن
        final brandName = getdataName(job['car_brand'], allBrands);
        final modelName =
            await getCarModelNameCached(job['car_brand'], job['car_model']);
        final colorName = getdataName(job['color'], allColors);

        job['car_brand'] = brandName;
        job['car_model'] = modelName;
        job['color'] = colorName;

        enrichedJobs.add(job);
      }

      allJobCards.assignAll(enrichedJobs);
      isScreenLodingForJobs.value = false;
    }, onError: (e) {
      isScreenLodingForJobs.value = false;
      // print('🔥 Error listening to jobs: $e');
    });
  }

  getCarBrands() {
    try {
      FirebaseFirestore.instance
          .collection('all_brands')
          .orderBy('name')
          .snapshots()
          .listen((brands) {
        allBrands.value = {for (var doc in brands.docs) doc.id: doc.data()};
      });
    } catch (e) {
      //
    }
  }

  Future<String> getCarModelNameCached(String brandId, String modelId) async {
    if (modelCache[brandId]?.containsKey(modelId) ?? false) {
      return modelCache[brandId]![modelId]!;
    }
    final doc = await FirebaseFirestore.instance
        .collection('all_brands')
        .doc(brandId)
        .collection('values')
        .doc(modelId)
        .get();
    final name = doc.data()?['name'] ?? '';
    modelCache[brandId] = modelCache[brandId] ?? {};
    modelCache[brandId]![modelId] = name;
    return name;
  }

// this function is to get colors
  getColors() async {
    var typeDoc = await FirebaseFirestore.instance
        .collection('all_lists')
        .where('code', isEqualTo: 'COLORS')
        .get();

    var typeId = typeDoc.docs.first.id;

    FirebaseFirestore.instance
        .collection('all_lists')
        .doc(typeId)
        .collection('values')
        .where('available', isEqualTo: true)
        .orderBy('name')
        .snapshots()
        .listen((colors) {
      allColors.value = {for (var doc in colors.docs) doc.id: doc.data()};
    });
  }
}
