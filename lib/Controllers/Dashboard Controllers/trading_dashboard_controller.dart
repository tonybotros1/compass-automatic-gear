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
  final RxList<DocumentSnapshot> allTrades = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredTrades = RxList<DocumentSnapshot>([]);
  RxMap allYears = RxMap({});
  RxMap allMonths = RxMap({});
  RxMap allDays = RxMap({});
  RxBool isScreenLoding = RxBool(true);
  RxString companyId = RxString('');
  RxInt numberOfCars = RxInt(0);
  RxDouble totalPaysForAllTrades = RxDouble(0.0);
  RxDouble totalReceivesForAllTrades = RxDouble(0.0);
  RxDouble totalNETsForAllTrades = RxDouble(0.0);
  RxInt pagesPerPage = RxInt(7);
  DateFormat format = DateFormat('yyyy-dd-MM');

  @override
  void onInit() async {
    await getCompanyId();
    getAllTrades();
    getYears();
    getMonths();
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
      allDays.clear();
    } else {
      day.clear();
      month.clear();
      year.value.clear();
      allDays.clear();
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
          .orderBy('added_date', descending: true)
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

  void calculateTotalsForAllTrades() {
    totalNETsForAllTrades.value = 0.0;
    totalPaysForAllTrades.value = 0.0;
    totalReceivesForAllTrades.value = 0.0;

    // // Use filteredTrades only if any filter is applied
    // final bool isFiltering = year.value.text.isNotEmpty ||
    //     month.text.isNotEmpty ||
    //     day.text.isNotEmpty;
    // final List<DocumentSnapshot> sourceList =
    //     isFiltering ? filteredTrades : allTrades;

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

  void filterTradesByDate() async {
    final int? selectedYear =
        year.value.text.isNotEmpty ? int.tryParse(year.value.text) : null;
    final int? selectedMonth =
        month.text.isNotEmpty ? _monthNameToNumber(month.text) : null;
    final int? selectedDay =
        day.text.isNotEmpty ? int.tryParse(day.text) : null;

    filteredTrades.assignAll(allTrades.where((doc) {
      final String? tradeDate = doc['date'];
      if (tradeDate == null || tradeDate.trim().isEmpty) return false;

      try {
        final DateTime date = format.parse(tradeDate);
        final bool matchesYear =
            selectedYear == null || date.year == selectedYear;
        final bool matchesMonth =
            selectedMonth == null || date.month == selectedMonth;
        final bool matchesDay = selectedDay == null || date.day == selectedDay;

        return matchesYear && matchesMonth && matchesDay;
      } catch (e) {
        return false;
      }
    }).toList());

    calculateTotalsForAllTrades();
    numberOfCars.value = filteredTrades.length;
  }

  filterTradesByStatus(String status) {
    filteredTrades.assignAll(allTrades.where((doc) {
      final String? tradeStatus = doc['status'];
      if (tradeStatus == null || tradeStatus.trim().isEmpty) return false;

      try {
        final bool matchesStatus = tradeStatus == '' || status == tradeStatus;

        return matchesStatus;
      } catch (e) {
        return false;
      }
    }).toList());

    calculateTotalsForAllTrades();
    numberOfCars.value = filteredTrades.length;
  }

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
