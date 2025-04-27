import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TradingDashboardController extends GetxController {
  Rx<TextEditingController> year = TextEditingController().obs;
  TextEditingController month = TextEditingController();
  TextEditingController day = TextEditingController();
  Rx<TextEditingController> carModel = TextEditingController().obs;
  Rx<TextEditingController> carBrand = TextEditingController().obs;
  RxString carBrandId = RxString('');
  RxString carModelId = RxString('');
  final RxList<DocumentSnapshot> allTrades = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> allCapitals = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> allOutstanding = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> allGeneralExpenses =
      RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredTrades = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredCapitals =
      RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredOutstanding =
      RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredGeneralExpenses =
      RxList<DocumentSnapshot>([]);
  RxMap allYears = RxMap({});
  RxMap allMonths = RxMap({});
  RxMap allDays = RxMap({});
  RxBool isScreenLoding = RxBool(true);
  RxString companyId = RxString('');
  RxInt numberOfCars = RxInt(0);
  RxInt numberOfCapitalsDocs = RxInt(0);
  RxInt numberOfOutstandingDocs = RxInt(0);
  RxInt numberOfGeneralExpensesDocs = RxInt(0);
  RxDouble totalPaysForAllTrades = RxDouble(0.0);
  RxDouble totalReceivesForAllTrades = RxDouble(0.0);
  RxDouble totalNETsForAllTrades = RxDouble(0.0);
  RxDouble totalPaysForAllCapitals = RxDouble(0.0);
  RxDouble totalReceivesForAllCapitals = RxDouble(0.0);
  RxDouble totalNETsForAllCapitals = RxDouble(0.0);
  RxDouble totalPaysForAllOutstanding = RxDouble(0.0);
  RxDouble totalReceivesForAllOutstanding = RxDouble(0.0);
  RxDouble totalNETsForAllOutstanding = RxDouble(0.0);
  RxDouble totalPaysForAllGeneralExpenses = RxDouble(0.0);
  RxDouble totalReceivesForAllGeneralExpenses = RxDouble(0.0);
  RxDouble totalNETsForAllGeneralExpenses = RxDouble(0.0);
  RxInt pagesPerPage = RxInt(7);
  DateFormat format = DateFormat('yyyy-MM-dd');
  DateFormat itemformat = DateFormat('dd-MM-yyyy');
  RxInt touchedIndex = 0.obs;
  RxInt newPercentage = RxInt(0);
  RxInt soldPercentage = RxInt(0);
  RxList<double> revenue = RxList<double>.filled(12, 0.0);
  RxList<double> expenses = RxList<double>.filled(12, 0.0);
  RxList<double> net = RxList<double>.filled(12, 0.0);
  RxList<double> carsNumber = RxList<double>.filled(12, 0.0);
  // List<double> revenue = List<double>.filled(12, 0.0);
  // List<double> expenses = List<double>.filled(12, 0.0);
  // List<double> net = List<double>.filled(12, 0.0);
  RxBool isNewStatusSelected = RxBool(false);
  RxBool isSoldStatusSelected = RxBool(false);
  // RxBool isAllSelected = RxBool(true);
  RxBool isTodaySelected = RxBool(false);
  RxBool isThisMonthSelected = RxBool(false);
  RxBool isThisYearSelected = RxBool(false);
  RxMap allItems = RxMap({});
  RxMap allBrands = RxMap({});
  RxMap allModels = RxMap({});
  RxBool isYearSelected = RxBool(false);
  RxBool isMonthSelected = RxBool(false);
  RxBool isDaySelected = RxBool(false);
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  void onInit() async {
    await getCompanyId();
    await getCarBrands();
    getAllTrades();
    getAllCapitals();
    getAllOutstanding();
    getAllGeneralExpenses();
    getYears();
    getMonths();
    getItems();
    super.onInit();
  }

  getCompanyId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId.value = prefs.getString('companyId')!;
  }

  filterByCurrentDate(String dateType) {
    var currentDate = DateTime.now();
    if (dateType == 'today') {
      day.text = currentDate.day.toString();
      month.text = _monthNumberToName(currentDate.month);
      year.value.text = currentDate.year.toString();
      allDays.assignAll(getDaysInMonth(month.text));
    } else if (dateType == 'month') {
      day.clear();
      month.text = _monthNumberToName(currentDate.month);
      year.value.text = currentDate.year.toString();
      allDays.assignAll(getDaysInMonth(month.text));
    } else if (dateType == 'year') {
      day.clear();
      month.clear();
      year.value.text = currentDate.year.toString();
      // calculateMonthlyTotals(int.parse(year.value.text));
      allDays.clear();
    } else {
      isNewStatusSelected.value = false;
      isSoldStatusSelected.value = false;
      day.clear();
      month.clear();
      year.value.clear();
      allDays.clear();
      isYearSelected.value = true;
      isMonthSelected.value = false;
      isDaySelected.value = false;
      revenue.assignAll(List.filled(12, 0.0));
      expenses.assignAll(List.filled(12, 0.0));
      net.assignAll(List.filled(12, 0.0));
      carsNumber.assignAll(List.filled(12, 0.0));
    }
    filterTradesByDate();
  }

  // this function is to get years
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
        .orderBy('name')
        .snapshots()
        .listen((year) {
      allYears.value = {for (var doc in year.docs) doc.id: doc.data()};
    });
  }

  getCarBrands() {
    try {
      FirebaseFirestore.instance
          .collection('all_brands')
          .snapshots()
          .listen((brands) {
        allBrands.value = {for (var doc in brands.docs) doc.id: doc.data()};
      });
    } catch (e) {
      //
    }
  }

  getModelsByCarBrand(brandId) {
    try {
      FirebaseFirestore.instance
          .collection('all_brands')
          .doc(brandId)
          .collection('values')
          .snapshots()
          .listen((models) {
        allModels.value = {for (var doc in models.docs) doc.id: doc.data()};
      });
    } catch (e) {
      //
    }
  }

  // this function is to get items
  getItems() async {
    var typeDoc = await FirebaseFirestore.instance
        .collection('all_lists')
        .where('code', isEqualTo: 'ITEMS')
        .get();

    var typeId = typeDoc.docs.first.id;
    FirebaseFirestore.instance
        .collection('all_lists')
        .doc(typeId)
        .collection('values')
        .where('available', isEqualTo: true)
        .orderBy('added_date')
        .snapshots()
        .listen((item) {
      allItems.value = {for (var doc in item.docs) doc.id: doc.data()};
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

  Map getDaysInMonth(String monthName) {
    // Map of lowercase month names to their respective numeric values.
    const monthMap = {
      'january': 1,
      'february': 2,
      'march': 3,
      'april': 4,
      'may': 5,
      'june': 6,
      'july': 7,
      'august': 8,
      'september': 9,
      'october': 10,
      'november': 11,
      'december': 12,
    };

    final key = monthName.toLowerCase();
    if (!monthMap.containsKey(key)) {
      throw ArgumentError('Invalid month name: $monthName');
    }

    final month = monthMap[key]!;
    final year = DateTime.now().year;

    // DateTime(year, month + 1, 0) is the “zero‑th” day of the next month,
    // which resolves to the last day of [month].
    final lastDay = DateTime(year, month + 1, 0).day;
    return {
      for (var day = 1; day <= lastDay; day++)
        day.toString(): {'name': day.toString()},
    };
  }

  getAllTrades() {
    try {
      FirebaseFirestore.instance
          .collection('all_trades')
          .where('company_id', isEqualTo: companyId.value)
          .orderBy('date', descending: true)
          .snapshots()
          .listen((trade) {
        allTrades.assignAll(List<DocumentSnapshot>.from(trade.docs));
        filteredTrades.assignAll(allTrades);
        calculateTotalsForAllTrades();
        numberOfCars.value = allTrades.length;
        isScreenLoding.value = false;
      });
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  getAllCapitals() {
    try {
      FirebaseFirestore.instance
          .collection('all_capitals')
          .where('company_id', isEqualTo: companyId.value)
          .orderBy('date', descending: true)
          .snapshots()
          .listen((trade) {
        allCapitals.assignAll(List<DocumentSnapshot>.from(trade.docs));
        filteredCapitals.assignAll(allCapitals);
        numberOfCapitalsDocs.value = allCapitals.length;
        calculateTotalsForCapitals();
      });
    } catch (e) {
      //
    }
  }

  getAllOutstanding() {
    try {
      FirebaseFirestore.instance
          .collection('all_outstanding')
          .where('company_id', isEqualTo: companyId.value)
          .orderBy('date', descending: true)
          .snapshots()
          .listen((trade) {
        allOutstanding.assignAll(List<DocumentSnapshot>.from(trade.docs));
        filteredOutstanding.assignAll(allOutstanding);
        numberOfOutstandingDocs.value = allOutstanding.length;
        calculateTotalsForOutstanding();
      });
    } catch (e) {
      //
    }
  }

  getAllGeneralExpenses() {
    try {
      FirebaseFirestore.instance
          .collection('all_general_expenses')
          .where('company_id', isEqualTo: companyId.value)
          .orderBy('date', descending: true)
          .snapshots()
          .listen((trade) {
        allGeneralExpenses.assignAll(List<DocumentSnapshot>.from(trade.docs));
        filteredGeneralExpenses.assignAll(allGeneralExpenses);
        numberOfGeneralExpensesDocs.value = allGeneralExpenses.length;
        calculateTotalsForGeneralExpenses();
      });
    } catch (e) {
      //
    }
  }

  String getdataName(String id, Map allData, {title = 'name'}) {
    try {
      final data = allData.entries.firstWhere(
        (data) => data.key == id,
      );
      return data.value[title];
    } catch (e) {
      return '';
    }
  }

  Future<String> getCarModelName(brandId, modelId) async {
    try {
      var name = await FirebaseFunctions.instance
          .httpsCallable('get_model_name')
          .call({"brandId": brandId, "modelId": modelId});
      return name.data;
    } catch (e) {
      return '';
    }
  }

  Future<String> getCarBrandName(brandId) async {
    try {
      var name = await FirebaseFunctions.instance
          .httpsCallable('get_brand_name')
          .call(brandId);
      return name.data;
    } catch (e) {
      return '';
    }
  }

  Future<String> getSellDate(tradeId) async {
    try {
      var name = await FirebaseFunctions.instance
          .httpsCallable('get_sell_date')
          .call(tradeId);
      return name.data;
    } catch (e) {
      return '';
    }
  }

  Future<String> getBuyDate(tradeId) async {
    try {
      var name = await FirebaseFunctions.instance
          .httpsCallable('get_buy_date')
          .call(tradeId);
      return name.data;
    } catch (e) {
      return '';
    }
  }

  Future<String> gettradePaid(tradeId) async {
    try {
      var paid = await FirebaseFunctions.instance
          .httpsCallable('get_trade_total_paid')
          .call(tradeId);
      return paid.data.toString();
    } catch (e) {
      return '';
    }
  }

  Future<String> gettradeReceived(tradeId) async {
    try {
      var rec = await FirebaseFunctions.instance
          .httpsCallable('get_trade_total_received')
          .call(tradeId);
      return rec.data.toString();
    } catch (e) {
      return '';
    }
  }

  Future<String> gettradeNETs(tradeId) async {
    try {
      var net = await FirebaseFunctions.instance
          .httpsCallable('get_trade_total_NETs')
          .call(tradeId);
      return net.data.toString();
    } catch (e) {
      return '';
    }
  }

  Future<String> getItemName(titemId) async {
    try {
      var net = await FirebaseFunctions.instance
          .httpsCallable('get_item_name')
          .call(titemId);
      return net.data.toString();
    } catch (e) {
      return '';
    }
  }

  void calculateTotalsForAllTrades() {
    totalNETsForAllTrades.value = 0.0;
    totalPaysForAllTrades.value = 0.0;
    totalReceivesForAllTrades.value = 0.0;

    for (var trade in filteredTrades) {
      final data = trade.data() as Map<String, dynamic>;
      final itemsList = data['items'] as List<dynamic>?;

      if (itemsList != null) {
        for (var item in itemsList) {
          final pay = double.tryParse(item['pay'] ?? 0);
          final receive = double.tryParse(item['receive'] ?? 0);

          totalPaysForAllTrades.value += pay!;
          totalReceivesForAllTrades.value += receive!;
          totalNETsForAllTrades.value += (receive - pay);
        }
      }
    }
  }

  void calculateTotalsForCapitals() {
    totalNETsForAllCapitals.value = 0.0;
    totalPaysForAllCapitals.value = 0.0;
    totalReceivesForAllCapitals.value = 0.0;

    for (var trade in filteredCapitals) {
      final data = trade.data() as Map<String, dynamic>;

      final pay = double.tryParse(data['pay'] ?? 0);
      final receive = double.tryParse(data['receive'] ?? 0);

      totalPaysForAllCapitals.value += pay!;
      totalReceivesForAllCapitals.value += receive!;
      totalNETsForAllCapitals.value += (receive - pay);
    }
  }

  void calculateTotalsForOutstanding() {
    totalNETsForAllOutstanding.value = 0.0;
    totalPaysForAllOutstanding.value = 0.0;
    totalReceivesForAllOutstanding.value = 0.0;

    for (var trade in filteredOutstanding) {
      final data = trade.data() as Map<String, dynamic>;

      final pay = double.tryParse(data['pay'] ?? 0);
      final receive = double.tryParse(data['receive'] ?? 0);

      totalPaysForAllOutstanding.value += pay!;
      totalReceivesForAllOutstanding.value += receive!;
      totalNETsForAllOutstanding.value += (receive - pay);
    }
  }

  void calculateTotalsForGeneralExpenses() {
    totalNETsForAllGeneralExpenses.value = 0.0;
    totalPaysForAllGeneralExpenses.value = 0.0;
    totalReceivesForAllGeneralExpenses.value = 0.0;

    for (var trade in filteredGeneralExpenses) {
      final data = trade.data() as Map<String, dynamic>;

      final pay = double.tryParse(data['pay'] ?? 0);
      final receive = double.tryParse(data['receive'] ?? 0);

      totalPaysForAllGeneralExpenses.value += pay!;
      totalReceivesForAllGeneralExpenses.value += receive!;
      totalNETsForAllGeneralExpenses.value += (receive - pay);
    }
  }

  filterTradesForChart() {
    try {
      final DateTime now = DateTime.now();

      int? selectedYear =
          year.value.text.isNotEmpty ? int.tryParse(year.value.text) : null;
      int? selectedMonth = month.value.text.isNotEmpty
          ? _monthNameToNumber(month.value.text)
          : null;
      int? selectedDay =
          day.value.text.isNotEmpty ? int.tryParse(day.value.text) : null;

      // 2. If partial date provided, default missing parts to 'now'
      if (selectedDay != null) {
        selectedMonth ??= now.month;
        selectedYear ??= now.year;
      } else if (selectedMonth != null) {
        selectedYear ??= now.year;
      }
      final String mode =
          (selectedYear != null && selectedMonth != null && selectedDay != null)
              ? 'day'
              : (selectedYear != null && selectedMonth != null)
                  ? 'month'
                  : (selectedYear != null)
                      ? 'year'
                      : 'all';

      switch (mode) {
        case 'year':
          revenue.assignAll(List.filled(12, 0.0));
          expenses.assignAll(List.filled(12, 0.0));
          net.assignAll(List.filled(12, 0.0));
          carsNumber.assignAll(List.filled(12, 0.0));
          break;
        case 'month':
          final daysInMonth =
              DateTime(selectedYear!, selectedMonth! + 1, 0).day;
          revenue.assignAll(List.filled(daysInMonth, 0.0));
          expenses.assignAll(List.filled(daysInMonth, 0.0));
          net.assignAll(List.filled(daysInMonth, 0.0));
          carsNumber.assignAll(List.filled(daysInMonth, 0.0));
          break;
        case 'day':
          revenue.assignAll(List.filled(1, 0.0));
          expenses.assignAll(List.filled(1, 0.0));
          net.assignAll(List.filled(1, 0.0));
          carsNumber.assignAll(List.filled(1, 0.0));
          break;
        default:
          revenue.assignAll(List.filled(12, 0.0));
          expenses.assignAll(List.filled(12, 0.0));
          net.assignAll(List.filled(12, 0.0));
          carsNumber.assignAll(List.filled(12, 0.0));
      }
      final String dateType = isSoldStatusSelected.value ? 'SELL' : 'BUY';

      for (var trade in filteredTrades) {
        DateTime? parsed;

        var pay = 0.0;
        var receive = 0.0;
        final items = trade['items'] as List<dynamic>?;
        if (items == null || items.isEmpty) continue;
        for (var item in items) {
          try {
            if (getdataName(item['item'], allItems) == dateType) {
              parsed = itemformat.parse(item['date']);
            }
          } catch (_) {
            continue;
          }
          pay += double.tryParse(item['pay']) ?? 0;
          receive += double.tryParse(item['receive']) ?? 0;
        }
        int idx;
        switch (mode) {
          case 'year':
            idx = parsed!.month - 1;
            break;
          case 'month':
            idx = parsed!.day - 1;
            break;
          case 'day':
            idx = 0;
            break;
          default:
            idx = -1;
        }
        revenue[idx] += receive; // sum of all receives
        expenses[idx] += pay; // sum of all pays
        net[idx] += (receive - pay); // net = receive minus pay
        carsNumber[idx] += 1;
        // if (idx >= 0 && idx < revenue.length) {
        //   revenue[idx] += receive; // sum of all receives
        //   expenses[idx] += pay; // sum of all pays
        //   net[idx] += (receive - pay); // net = receive minus pay
        // }
      }
    } catch (e) {
      // print(e);
    }
  }

  void filterTradesByDate() {
    final int? selectedYear =
        year.value.text.isNotEmpty ? int.tryParse(year.value.text) : null;
    final int? selectedMonth = month.value.text.isNotEmpty
        ? _monthNameToNumber(month.value.text)
        : null;
    final int? selectedDay =
        day.value.text.isNotEmpty ? int.tryParse(day.value.text) : null;

    final String? selectedBrand =
        carBrandId.value != '' ? carBrandId.value : null;
    final String? selectedModel =
        carModelId.value != '' ? carModelId.value : null;

    // 1️⃣ New: read “new status” toggle
    final bool isNewSelected = isNewStatusSelected.value;

    final String dateType = isSoldStatusSelected.value ? 'SELL' : 'BUY';

    final List<Map<String, dynamic>> temp = [];

    for (var trade in allTrades) {
      // 2️⃣ New: if we only want “new” trades, skip all others
      if (isNewSelected) {
        final String? status = trade['status'] as String?;
        if (status?.toLowerCase() != 'new') continue;
      }

      final String? tradeBrand = trade['car_brand'] as String?;
      final String? tradeModel = trade['car_model'] as String?;
      if (selectedBrand != null && tradeBrand != selectedBrand) continue;
      if (selectedModel != null && tradeModel != selectedModel) continue;
      final items = trade['items'] as List<dynamic>?;
      if (items == null || items.isEmpty) continue;

      DateTime? latestForThisTrade;

      for (var item in items) {
        if (getdataName(item['item'], allItems) != dateType) continue;

        DateTime parsed;
        try {
          parsed = itemformat.parse(item['date']);
        } catch (_) {
          continue;
        }

        if (selectedYear != null && parsed.year != selectedYear) continue;
        if (selectedMonth != null && parsed.month != selectedMonth) continue;
        if (selectedDay != null && parsed.day != selectedDay) continue;

        if (latestForThisTrade == null || parsed.isAfter(latestForThisTrade)) {
          latestForThisTrade = parsed;
        }
      }

      if (latestForThisTrade != null) {
        temp.add({
          'trade': trade,
          'date': latestForThisTrade,
        });
      }
    }

    if (selectedYear == null && selectedMonth == null && selectedDay == null) {
      temp.sort(
        (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime),
      );
    }

    filteredTrades.value =
        temp.map((e) => e['trade'] as DocumentSnapshot<Object?>).toList();

    calculateTotalsForAllTrades();
    filterTradesForChart();
    numberOfCars.value = filteredTrades.length;
  }

  // void filterTradesByDate() {
  //   final int? selectedYear =
  //       year.value.text.isNotEmpty ? int.tryParse(year.value.text) : null;
  //   final int? selectedMonth = month.value.text.isNotEmpty
  //       ? _monthNameToNumber(month.value.text)
  //       : null;
  //   final int? selectedDay =
  //       day.value.text.isNotEmpty ? int.tryParse(day.value.text) : null;

  //   final String? selectedBrand =
  //       carBrandId.value != '' ? carBrandId.value : null;
  //   final String? selectedModel =
  //       carModelId.value != '' ? carModelId.value : null;

  //   final String dateType = isSoldStatusSelected.value ? 'SELL' : 'BUY';

  //   final List<Map<String, dynamic>> temp = [];

  //   for (var trade in allTrades) {
  //     final String? tradeBrand = trade['car_brand'] as String?;
  //     final String? tradeModel = trade['car_model'] as String?;
  //     if (selectedBrand != null && tradeBrand != selectedBrand) continue;
  //     if (selectedModel != null && tradeModel != selectedModel) continue;
  //     final items = trade['items'] as List<dynamic>?;
  //     if (items == null || items.isEmpty) continue;

  //     DateTime? latestForThisTrade;

  //     for (var item in items) {
  //       if (getdataName(item['item'], allItems) != dateType) continue;

  //       DateTime parsed;
  //       try {
  //         parsed = itemformat.parse(item['date']);
  //       } catch (_) {
  //         continue;
  //       }

  //       if (selectedYear != null && parsed.year != selectedYear) continue;
  //       if (selectedMonth != null && parsed.month != selectedMonth) continue;
  //       if (selectedDay != null && parsed.day != selectedDay) continue;

  //       if (latestForThisTrade == null || parsed.isAfter(latestForThisTrade)) {
  //         latestForThisTrade = parsed;
  //       }
  //     }

  //     if (latestForThisTrade != null) {
  //       temp.add({
  //         'trade': trade,
  //         'date': latestForThisTrade,
  //       });
  //     }
  //   }

  //   if (selectedYear == null && selectedMonth == null && selectedDay == null) {
  //     temp.sort(
  //       (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime),
  //     );
  //   }

  //   filteredTrades.value =
  //       temp.map((e) => e['trade'] as DocumentSnapshot<Object?>).toList();

  //   calculateTotalsForAllTrades();
  //   filterTradesForChart();
  //   numberOfCars.value = filteredTrades.length;
  // }

  int? _monthNameToNumber(String monthName) {
    const monthMap = {
      'january': 1,
      'february': 2,
      'march': 3,
      'april': 4,
      'may': 5,
      'june': 6,
      'july': 7,
      'august': 8,
      'september': 9,
      'october': 10,
      'november': 11,
      'december': 12,
    };

    return monthMap[monthName.toLowerCase()];
  }

  String _monthNumberToName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[month - 1];
  }
}
