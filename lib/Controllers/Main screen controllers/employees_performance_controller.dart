import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../consts.dart';
import 'main_screen_contro.dart';

class EmployeesPerformanceController extends GetxController {
  TextEditingController year = TextEditingController();
  TextEditingController month = TextEditingController();
  TextEditingController day = TextEditingController();
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxMap allYears = RxMap({});
  RxMap allMonths = RxMap({});
  RxMap allDays = RxMap({});

  // RxBool isYearSelected = RxBool(false);
  // RxBool isMonthSelected = RxBool(false);
  // RxBool isDaySelected = RxBool(false);
  RxBool isTodaySelected = RxBool(false);
  RxBool isThisMonthSelected = RxBool(false);
  RxBool isThisYearSelected = RxBool(false);

  double dropDownWidth = 150;
  RxBool isScreenLoadingForTimesheets = RxBool(false);
  RxBool isScreenLoadingForEmployeeTasks = RxBool(false);
  RxString companyId = RxString('');
  final RxList<DocumentSnapshot> allTimeSheets = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> allTechnician = RxList<DocumentSnapshot>([]);
  final RxMap<String, int> employeePointsMap = <String, int>{}.obs;
  RxMap pointsAndNames = {}.obs;
  RxMap cars = {}.obs;
  RxMap allBrands = RxMap({});

  @override
  void onInit() async {
    await getCompanyId();
    getYears();
    getCarBrands();
    getAllTechnicians();
    getMonths();
    super.onInit();
  }

  getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  getCompanyId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId.value = prefs.getString('companyId')!;
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

  getSheetTasksAndPoints(List<DocumentSnapshot<Object?>> employeeSheets) async {
    try {
      // isScreenLoadingForEmployeeTasks.value = true;
      List tasksIDs = employeeSheets
          .map((sheet) {
            return sheet['task_id'];
          })
          .toSet()
          .toList();
      // Fetch all task documents concurrently
      final tasksCollection =
          FirebaseFirestore.instance.collection('all_job_tasks');
      final List<DocumentSnapshot> taskDocs = await Future.wait(
        tasksIDs.map((id) => tasksCollection.doc(id).get()),
      );

      pointsAndNames.value = {
        for (var element in taskDocs)
          if (element.exists)
            element.id: {
              'name': '${element.get('name_en')} ${element.get('name_ar')}',
              'points': element.get('points') ?? 0,
            }
      };
      // isScreenLoadingForEmployeeTasks.value = false;
    } catch (e) {
      // isScreenLoadingForEmployeeTasks.value = false;

      return {};
    }
  }

  getSheetsCar(List<DocumentSnapshot<Object?>> employeeSheets) async {
    final jobIds = employeeSheets
        .map((sheet) => sheet['job_id'])
        .toSet()
        .where((id) => id != null)
        .toList();

    final jobsCollection = FirebaseFirestore.instance.collection('job_cards');

    final List<DocumentSnapshot<Map<String, dynamic>>> jobDocs =
        await Future.wait(
      jobIds.map((id) => jobsCollection.doc(id).get()),
    );

    for (final job in jobDocs) {
      final data = job.data();
      if (data != null) {
        cars[job.id] = {
          'brand': getdataName(data['car_brand'], allBrands),
          'model': await getModelName(data['car_brand'], data['car_model'])
        };
        // brandsId.add(data['car_brand']?.toString() ?? '');
      }
    }
  }

  Future<String> getModelName(String brandId, String modelId) async {
    try {
      var cities = await FirebaseFirestore.instance
          .collection('all_brands')
          .doc(brandId)
          .collection('values')
          .doc(modelId)
          .get();

      if (cities.exists) {
        return cities.data()!['name'];
      } else {
        return '';
      }
    } catch (e) {
      return ''; // Return empty string on error
    }
  }

  Future<void> loadAllEmployeePoints() async {
    final futures = allTechnician.map((tech) async {
      final id = tech.id;
      final points = await getEmployeePoints(id);
      return MapEntry(id, points);
    });

    final results = await Future.wait(futures);
    final pointMap = Map<String, int>.fromEntries(results);

    employeePointsMap.assignAll(pointMap);
  }

  int getEmployeeMins(String id) {
    // Using const for an immutable zero duration
    const Duration initialValue = Duration.zero;

    return allTimeSheets
        // Filter for the relevant timesheets
        .where(
            (sheet) => sheet['employee_id'] == id && sheet['end_date'] != null)
        // Flatten the list of lists of 'active_periods' into a single iterable
        .expand((sheet) => sheet['active_periods'] as List<dynamic>)
        // Convert each period map into a Duration
        .map((period) {
          final DateTime from = (period['from'] as Timestamp).toDate();
          final DateTime to = (period['to'] as Timestamp).toDate();
          return to.difference(from);
        })
        // Sum all durations together
        .fold(initialValue, (total, duration) => total + duration)
        .inMinutes;
  }

  int getSheetMins(Map<String, dynamic> sheet) {
    final List<dynamic> activePeriods = sheet['active_periods'] ?? [];

    final totalDuration = activePeriods.fold<Duration>(
      Duration.zero,
      (sum1, period) {
        final from = (period['from'] as Timestamp).toDate();
        final to = (period['to'] as Timestamp).toDate();
        return sum1 + to.difference(from);
      },
    );

    return totalDuration.inMinutes;
  }

  List<DocumentSnapshot<Object?>> getEmployeeSheets(id) {
    return allTimeSheets
        .where(
            (sheet) => sheet['employee_id'] == id && sheet['end_date'] != null)
        .toList();
  }

  int getEmployeeTasks(id) {
    return allTimeSheets.where((sheet) {
      return sheet['employee_id'] == id && sheet['end_date'] != null;
    }).length;
  }

  Future<int> getEmployeePoints(String employeeId) async {
    final taskIds = allTimeSheets
        .where((sheet) =>
            sheet['employee_id'] == employeeId && sheet['end_date'] != null)
        .map((sheet) => sheet['task_id'] as String)
        .toList();

    if (taskIds.isEmpty) {
      return 0;
    }

    final uniqueTaskIds = taskIds.toSet().toList();
    final pointsMap = <String, int>{};
    const batchSize = 30;

    for (int i = 0; i < uniqueTaskIds.length; i += batchSize) {
      final batch = uniqueTaskIds.sublist(
          i,
          (i + batchSize > uniqueTaskIds.length)
              ? uniqueTaskIds.length
              : i + batchSize);

      final querySnapshot = await FirebaseFirestore.instance
          .collection('all_job_tasks')
          .where(FieldPath.documentId, whereIn: batch)
          .get();

      for (final doc in querySnapshot.docs) {
        // Safely get the points value, casting from num.
        final points = doc.data()['points'];
        if (points != null) {
          pointsMap[doc.id] = int.tryParse(points) ?? 0;
        }
      }
    }

    // 3. Sum the points for every completed task using the local map.
    return taskIds.fold<int>(0, (sum1, id) => sum1 + (pointsMap[id] ?? 0));
  }

  getYears() async {
    var typeDoc = await FirebaseFirestore.instance
        .collection('all_lists')
        .where('code', isEqualTo: 'YEARS')
        .get();

    var typeId = typeDoc.docs.first.id;
    FirebaseFirestore.instance
        .collection('all_lists')
        .doc(typeId)
        .collection('values')
        .where('available', isEqualTo: true)
        .orderBy('name', descending: true)
        .snapshots()
        .listen((year) {
      allYears.value = {for (var doc in year.docs) doc.id: doc.data()};
    });
  }

  // this function is to get years
  getMonths() async {
    var typeDoc = await FirebaseFirestore.instance
        .collection('all_lists')
        .where('code', isEqualTo: 'MONTHS')
        .get();

    var typeId = typeDoc.docs.first.id;
    FirebaseFirestore.instance
        .collection('all_lists')
        .doc(typeId)
        .collection('values')
        .where('available', isEqualTo: true)
        .orderBy('added_date')
        .snapshots()
        .listen((year) {
      allMonths.value = {for (var doc in year.docs) doc.id: doc.data()};
    });
  }

  getAllTechnicians() {
    try {
      isScreenLoadingForTimesheets.value = true;
      FirebaseFirestore.instance
          .collection('all_technicians')
          .where('company_id', isEqualTo: companyId.value)
          .orderBy('name', descending: false)
          .snapshots()
          .listen((tech) {
        allTechnician.assignAll(List<DocumentSnapshot>.from(tech.docs));
        isScreenLoadingForTimesheets.value = false;
      });
    } catch (e) {
      isScreenLoadingForTimesheets.value = false;
    }
  }

  void filterTimeSheets({String? preset}) {
    try {
      DateTime now = DateTime.now();
      DateTime? start;
      DateTime? end;

      if (preset != null) {
        switch (preset) {
          case 'today':
            start = DateTime(now.year, now.month, now.day);
            end = start.add(Duration(days: 1));
            year.text = start.year.toString();
            month.text = monthNumberToName(start.month);
            allDays.assignAll(getDaysInMonth(month.text));
            day.text = start.day.toString();
            break;
          case 'thisMonth':
            start = DateTime(now.year, now.month, 1);
            end = DateTime(now.year, now.month + 1, 1);
            year.text = start.year.toString();
            month.text = monthNumberToName(start.month);
            day.clear();
            break;
          case 'thisYear':
            start = DateTime(now.year, 1, 1);
            end = DateTime(now.year + 1, 1, 1);
            year.text = start.year.toString();
            day.clear();
            month.clear();

            break;
          case 'all':
          default:
            start = null;
            end = null;
        }
      } else {
        // استخدم الكنترولرز
        String? yearStr = year.text.trim();
        String? monthStr = month.text.trim();
        String? dayStr = day.text.trim();

        int? yearVal = int.tryParse(yearStr);
        int? monthVal = monthNameToNumber(monthStr);
        int? dayVal = int.tryParse(dayStr);

        if (yearVal != null && monthVal != null && dayVal != null) {
          start = DateTime(yearVal, monthVal, dayVal);
          end = start.add(Duration(days: 1));
        } else if (yearVal != null && monthVal != null) {
          start = DateTime(yearVal, monthVal, 1);
          end = DateTime(yearVal, monthVal + 1, 1);
        } else if (yearVal != null) {
          start = DateTime(yearVal, 1, 1);
          end = DateTime(yearVal + 1, 1, 1);
        }
      }

      Query query = FirebaseFirestore.instance
          .collection('time_sheets')
          .where('company_id', isEqualTo: companyId.value);

      if (start != null && end != null) {
        query = query
            .where('end_date',
                isGreaterThanOrEqualTo: Timestamp.fromDate(start))
            .where('end_date', isLessThan: Timestamp.fromDate(end));
      }

      query = query.where('end_date', isNull: false).orderBy('end_date');

      query.snapshots().listen((snapshot) {
        allTimeSheets.assignAll(List<DocumentSnapshot>.from(snapshot.docs));
        loadAllEmployeePoints();
      });
    } catch (e) {
      //
    }
  }
}
