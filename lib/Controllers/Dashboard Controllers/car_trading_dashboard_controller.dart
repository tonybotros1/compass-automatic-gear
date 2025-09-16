import 'dart:convert';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/car trading/capitals_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import '../Main screen controllers/websocket_controller.dart';

class CarTradingDashboardController extends GetxController {
  Rx<TextEditingController> searchForCapitals = TextEditingController().obs;
  Rx<TextEditingController> yearFilter = TextEditingController().obs;
  TextEditingController monthFilter = TextEditingController();
  TextEditingController dayFilter = TextEditingController();
  Rx<TextEditingController> carModelFilter = TextEditingController().obs;
  Rx<TextEditingController> carBrandFilter = TextEditingController().obs;
  RxString carBrandFilterId = RxString('');
  RxString carModelFilterId = RxString('');
  final RxList<DocumentSnapshot> allTrades = RxList<DocumentSnapshot>([]);
  final RxList<CapitalsModel> allCapitals = RxList<CapitalsModel>([]);
  final RxList<DocumentSnapshot> allOutstanding = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> allGeneralExpenses = RxList<DocumentSnapshot>(
    [],
  );
  final RxList<DocumentSnapshot> filteredTrades = RxList<DocumentSnapshot>([]);
  final RxList<CapitalsModel> filteredCapitals = RxList<CapitalsModel>([]);
  final RxList<DocumentSnapshot> filteredOutstanding = RxList<DocumentSnapshot>(
    [],
  );
  final RxList<DocumentSnapshot> filteredGeneralExpenses =
      RxList<DocumentSnapshot>([]);
  RxMap allYears = RxMap({});
  RxMap allMonths = RxMap({});
  RxMap allDays = RxMap({});
  RxBool isScreenLoding = RxBool(false);
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
  RxDouble totalNETsForAll = RxDouble(0.0);
  RxDouble totalNetProfit = RxDouble(0.0);
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
  RxBool isNewStatusSelected = RxBool(false);
  RxBool isSoldStatusSelected = RxBool(false);
  RxBool isTodaySelected = RxBool(false);
  RxBool isThisMonthSelected = RxBool(false);
  RxBool isThisYearSelected = RxBool(false);
  // RxMap allItems = RxMap({});
  RxMap allBrands = RxMap({});
  RxMap allModels = RxMap({});
  RxBool isYearSelected = RxBool(false);
  RxBool isMonthSelected = RxBool(false);
  RxBool isDaySelected = RxBool(false);
  RxString status = RxString('');
  RxString currentTradId = RxString('');
  RxString colorOutId = RxString('');
  RxBool addingNewValue = RxBool(false);
  Rx<TextEditingController> searchForItems = TextEditingController().obs;
  Rx<TextEditingController> date = TextEditingController().obs;
  Rx<TextEditingController> mileage = TextEditingController().obs;
  Rx<TextEditingController> colorOut = TextEditingController().obs;
  RxMap allColors = RxMap({});
  RxMap allCarSpecifications = RxMap({});
  RxMap allEngineSizes = RxMap({});
  RxMap allBuyersAndSellers = RxMap({});
  Rx<TextEditingController> colorIn = TextEditingController().obs;
  Rx<TextEditingController> carSpecification = TextEditingController().obs;
  Rx<TextEditingController> carBrand = TextEditingController().obs;
  Rx<TextEditingController> carModel = TextEditingController().obs;
  Rx<TextEditingController> engineSize = TextEditingController().obs;
  Rx<TextEditingController> boughtFrom = TextEditingController().obs;
  Rx<TextEditingController> year = TextEditingController().obs;
  Rx<TextEditingController> soldTo = TextEditingController().obs;
  TextEditingController pay = TextEditingController();
  TextEditingController receive = TextEditingController();
  Rx<TextEditingController> comments = TextEditingController().obs;
  TextEditingController note = TextEditingController();
  TextEditingController item = TextEditingController();
  TextEditingController name = TextEditingController();
  Rx<TextEditingController> itemDate = TextEditingController().obs;
  RxString query = RxString('');
  RxString queryForItems = RxString('');
  RxBool isValuesLoading = RxBool(false);
  RxString colorInId = RxString('');
  RxString carSpecificationId = RxString('');
  RxString carModelId = RxString('');
  RxString carBrandId = RxString('');
  RxString engineSizeId = RxString('');
  RxString boughtFromId = RxString('');
  RxString yearId = RxString('');
  RxString soldToId = RxString('');
  RxString itemId = RxString('');
  RxString nameId = RxString('');
  RxList<Map<String, dynamic>> addedItems = RxList([]);
  RxDouble totalPays = RxDouble(0.0);
  RxDouble totalReceives = RxDouble(0.0);
  RxDouble totalNETs = RxDouble(0.0);
  RxList<Map> filteredAddedItems = RxList([]);
  RxMap allItems = RxMap({});
  RxMap allNames = RxMap({});
  RxBool isCapitalLoading = RxBool(false);
  String backendUrl = backendTestURI;
  WebSocketService ws = Get.find<WebSocketService>();
  final focusNode = FocusNode();
  RxBool gettingCapitalsSummary = RxBool(false);

  @override
  void onInit() async {
    connectWebSocket();
    getCapitalsSummary();
    getCarBrands();
    // getAllTrades();
    // getAllCapitals();
    // getAllOutstanding();
    // getAllGeneralExpenses();
    getYears();
    getMonths();
    getColors();
    getEngineTypes();
    getCarSpecefications();
    getBuyersAndSellers();
    getNamesOfPeople();
    // getItems();
    everAll(
      [
        totalNETsForAllTrades,
        totalNETsForAllCapitals,
        totalNETsForAllGeneralExpenses,
        totalNETsForAllOutstanding,
      ],
      (values) {
        calculateTotalsForAllAndNetProfit();
      },
    );
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        normalizeDate(itemDate.value.text, itemDate.value);
      }
    });
    super.onInit();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void connectWebSocket() {
    ws.events.listen((message) {
      switch (message["type"]) {
        case "capital_created":
          final newCapital = CapitalsModel.fromJson(message["data"]);
          allCapitals.add(newCapital);
          break;

        case "capital_updated":
          final updated = CapitalsModel.fromJson(message["data"]);
          final totals = message['totals'];
          final index = allCapitals.indexWhere((b) => b.id == updated.id);
          if (index != -1) {
            allCapitals[index] = updated;
            totalPays.value = totals['pay'];
            totalReceives.value = totals['receive'];
            totalNETs.value = totals['net'];
          }
          break;

        case "capital_deleted":
          final deletedId = message["data"]["_id"];
          allCapitals.removeWhere((b) => b.id == deletedId);
          break;

        // case "model_created":
        //   final newModel = Model.fromJson(message["data"]);
        //   allModels.add(newModel);
        //   break;

        // case "model_updated":
        //   final updated = Model.fromJson(message["data"]);
        //   final index = allModels.indexWhere((m) => m.id == updated.id);
        //   if (index != -1) {
        //     allModels[index] = updated;
        //   }
        //   break;

        // case "model_deleted":
        //   final deletedId = message["data"]["_id"];
        //   allModels.removeWhere((m) => m.id == deletedId);
        //   break;
      }
    });
  }

  Future<void> getYears() async {
    allYears.assignAll(await helper.getAllListValues('YEARS'));
  }

  Future<void> getColors() async {
    allColors.assignAll(await helper.getAllListValues('COLORS'));
  }

  Future<void> getCarSpecefications() async {
    allCarSpecifications.assignAll(
      await helper.getAllListValues('CAR_SPECIFICATIONS'),
    );
  }

  Future<void> getEngineTypes() async {
    allEngineSizes.assignAll(await helper.getAllListValues('ENGINE_TYPES'));
  }

  Future<void> getMonths() async {
    allMonths.assignAll(await helper.getAllListValues('MONTHS'));
  }

  Future<void> getBuyersAndSellers() async {
    allBuyersAndSellers.assignAll(
      await helper.getAllListValues('BUYERS_AND_SELLERS'),
    );
  }

  Future<void> getNamesOfPeople() async {
    allNames.assignAll(await helper.getAllListValues('NAMES_OF_PEOPLE'));
  }

  Future<void> getCarBrands() async {
    allBrands.assignAll(await helper.getCarBrands());
  }

  Future<void> getModelsByCarBrand(String brandId) async {
    allModels.assignAll(await helper.getModelsValues(brandId));
  }

  Future<void> getCapitalsSummary() async {
    try {
      allCapitals.clear();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/car_trading/get_capitals_summary');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        Map totals = decoded["summary"];
        totalPaysForAllCapitals.value = totals['total_pay'];
        totalReceivesForAllCapitals.value = totals['total_receive'];
        totalNETsForAllCapitals.value = totals['total_net'];
        numberOfCapitalsDocs.value = totals['count'];
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllCapitals();
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

  Future<void> getAllCapitals() async {
    try {
      isCapitalLoading.value = true;
      allCapitals.clear();
      totalPays.value = 0;
      totalReceives.value = 0;
      totalNETs.value = 0;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/car_trading/get_all_capitals');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List capitals = decoded['capitals'];
        Map totals = decoded["totals"];
        totalPays.value = totals['total_pay'];
        totalReceives.value = totals['total_receive'];
        totalNETs.value = totals['total_net'];
        allCapitals.assignAll(capitals.map((c) => CapitalsModel.fromJson(c)));
        isCapitalLoading.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllCapitals();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        isCapitalLoading.value = false;
        logout();
      } else {
        isCapitalLoading.value = false;
      }
    } catch (e) {
      isCapitalLoading.value = false;
    }
  }

  void addNewCapitalOrOutstandingOrGeneralExpenses(String type) async {
    switch (type) {
      case 'capital':
        await addNewCapital();
        break;
      // case '':
      default:
    }
  }

  void deleteCapitalOrOutstandingOrGeneralExpenses(
    String type,
    String id,
  ) async {
    switch (type) {
      case 'capital':
        await deleteCapital(id);
        break;
      // case '':
      default:
    }
  }

  void updateCapitalOrOutstandingOrGeneralExpenses(
    String type,
    String id,
  ) async {
    switch (type) {
      case 'capital':
        await updateCapital(id);
        break;
      // case '':
      default:
    }
  }

  Future<void> addNewCapital() async {
    try {
      if (itemDate.value.text.isEmpty) {
        showSnackBar('Alert', 'Please add valid Date');
        return;
      }
      final inputFormat = DateFormat("dd-MM-yyyy");
      final parsedDate = inputFormat.parse(itemDate.value.text);
      final isoDate = parsedDate.toIso8601String();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/car_trading/add_new_capital');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "date": isoDate,
          "name": nameId.value,
          "pay": double.tryParse(pay.text) ?? 0.0,
          "receive": double.tryParse(receive.text) ?? 0.0,
          "comment": comments.value.text,
        }),
      );
      if (response.statusCode == 200) {
        totalPays.value += double.tryParse(pay.text) ?? 0.0;
        totalReceives.value += double.tryParse(receive.text) ?? 0.0;
        totalNETs.value = totalReceives.value - totalPays.value;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewCapital();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      Get.back();
    } catch (e) {
      Get.back();
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  Future<void> deleteCapital(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/car_trading/delete_capital/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteCapital(id);
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

  Future<void> updateCapital(String id) async {
    try {
      if (itemDate.value.text.isEmpty) {
        showSnackBar('Alert', 'Please add valid Date');
        return;
      }
      final inputFormat = DateFormat("dd-MM-yyyy");
      final parsedDate = inputFormat.parse(itemDate.value.text);
      final isoDate = parsedDate.toIso8601String();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/car_trading/update_capital/$id');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "date": isoDate,
          "name": nameId.value,
          "pay": double.tryParse(pay.text) ?? 0.0,
          "receive": double.tryParse(receive.text) ?? 0.0,
          "comment": comments.value.text,
        }),
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewCapital();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      Get.back();
    } catch (e) {
      Get.back();
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  // =======================================================================================================

  void filterByCurrentDate(String dateType) {
    // var currentDate = DateTime.now();
    // if (dateType == 'today') {
    //   day.text = currentDate.day.toString();
    //   month.text = monthNumberToName(currentDate.month);
    //   year.value.text = currentDate.year.toString();
    //   allDays.assignAll(getDaysInMonth(month.text));
    // } else if (dateType == 'month') {
    //   day.clear();
    //   month.text = monthNumberToName(currentDate.month);
    //   year.value.text = currentDate.year.toString();
    //   allDays.assignAll(getDaysInMonth(month.text));
    // } else if (dateType == 'year') {
    //   day.clear();
    //   month.clear();
    //   year.value.text = currentDate.year.toString();
    //   // calculateMonthlyTotals(int.parse(year.value.text));
    //   allDays.clear();
    // } else {
    //   isNewStatusSelected.value = false;
    //   isSoldStatusSelected.value = false;
    //   day.clear();
    //   month.clear();
    //   year.value.clear();
    //   allDays.clear();
    //   isYearSelected.value = true;
    //   isMonthSelected.value = false;
    //   isDaySelected.value = false;
    //   revenue.assignAll(List.filled(12, 0.0));
    //   expenses.assignAll(List.filled(12, 0.0));
    //   net.assignAll(List.filled(12, 0.0));
    //   carsNumber.assignAll(List.filled(12, 0.0));
    // }
    // filterTradesByDate();
  }

  // // this function is to get items
  // Future<void> getItems() async {
  //   var typeDoc = await FirebaseFirestore.instance
  //       .collection('all_lists')
  //       .where('code', isEqualTo: 'ITEMS')
  //       .get();

  //   var typeId = typeDoc.docs.first.id;
  //   FirebaseFirestore.instance
  //       .collection('all_lists')
  //       .doc(typeId)
  //       .collection('values')
  //       .where('available', isEqualTo: true)
  //       .orderBy('added_date')
  //       .snapshots()
  //       .listen((item) {
  //         allItems.value = {for (var doc in item.docs) doc.id: doc.data()};
  //       });
  // }

  void getAllTrades() {
    try {
      isScreenLoding.value = true;
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

  void getAllOutstanding() {
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

  void getAllGeneralExpenses() {
    try {
      FirebaseFirestore.instance
          .collection('all_general_expenses')
          .where('company_id', isEqualTo: companyId.value)
          .orderBy('date', descending: true)
          .snapshots()
          .listen((trade) {
            allGeneralExpenses.assignAll(
              List<DocumentSnapshot>.from(trade.docs),
            );
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
      final data = allData.entries.firstWhere((data) => data.key == id);
      return data.value[title];
    } catch (e) {
      return '';
    }
  }

  Future<String> getCarModelName(String brandId, String modelId) async {
    try {
      var name = await FirebaseFunctions.instance
          .httpsCallable('get_model_name')
          .call({"brandId": brandId, "modelId": modelId});
      return name.data;
    } catch (e) {
      return '';
    }
  }

  Future<String> getSellDate(String tradeId) async {
    try {
      var name = await FirebaseFunctions.instance
          .httpsCallable('get_sell_date')
          .call(tradeId);
      return name.data;
    } catch (e) {
      return '';
    }
  }

  Future<String> getBuyDate(String tradeId) async {
    try {
      var name = await FirebaseFunctions.instance
          .httpsCallable('get_buy_date')
          .call(tradeId);
      return name.data;
    } catch (e) {
      return '';
    }
  }

  Future<String> gettradePaid(String tradeId) async {
    try {
      var paid = await FirebaseFunctions.instance
          .httpsCallable('get_trade_total_paid')
          .call(tradeId);
      return paid.data.toString();
    } catch (e) {
      return '';
    }
  }

  Future<String> gettradeReceived(String tradeId) async {
    try {
      var rec = await FirebaseFunctions.instance
          .httpsCallable('get_trade_total_received')
          .call(tradeId);
      return rec.data.toString();
    } catch (e) {
      return '';
    }
  }

  Future<String> gettradeNETs(String tradeId) async {
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

    for (var trade in filteredTrades) {
      final data = trade.data() as Map<String, dynamic>;
      final itemsList = data['items'] as List<dynamic>? ?? [];

      if (itemsList.isNotEmpty) {
        for (var item in itemsList) {
          final pay = double.tryParse(item['pay'] ?? 0) ?? 0.0;
          final receive = double.tryParse(item['receive'] ?? 0) ?? 0.0;

          totalPaysForAllTrades.value += pay;
          totalReceivesForAllTrades.value += receive;
          totalNETsForAllTrades.value += (receive - pay);
        }
      }
    }
  }

  void calculateTotalsForAllAndNetProfit() {
    totalNETsForAll.value =
        totalNETsForAllCapitals.value +
        totalNETsForAllGeneralExpenses.value +
        totalNETsForAllOutstanding.value +
        totalNETsForAllTrades.value;

    totalNetProfit.value =
        totalNETsForAllTrades.value + totalNETsForAllGeneralExpenses.value;
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

  void filterTradesForChart() {
    try {
      // final DateTime now = DateTime.now();

      // int? selectedYear = year.value.text.isNotEmpty
      //     ? int.tryParse(year.value.text)
      //     : null;
      // int? selectedMonth = month.value.text.isNotEmpty
      //     ? monthNameToNumber(month.value.text)
      //     : null;
      // int? selectedDay = day.value.text.isNotEmpty
      //     ? int.tryParse(day.value.text)
      //     : null;

      // // 2. If partial date provided, default missing parts to 'now'
      // if (selectedDay != null) {
      //   selectedMonth ??= now.month;
      //   selectedYear ??= now.year;
      // } else if (selectedMonth != null) {
      //   selectedYear ??= now.year;
      // }
      // final String mode =
      //     (selectedYear != null && selectedMonth != null && selectedDay != null)
      //     ? 'day'
      //     : (selectedYear != null && selectedMonth != null)
      //     ? 'month'
      //     : (selectedYear != null)
      //     ? 'year'
      //     : 'all';

      // switch (mode) {
      //   case 'year':
      //     revenue.assignAll(List.filled(12, 0.0));
      //     expenses.assignAll(List.filled(12, 0.0));
      //     net.assignAll(List.filled(12, 0.0));
      //     carsNumber.assignAll(List.filled(12, 0.0));
      //     break;
      //   case 'month':
      //     final daysInMonth = DateTime(
      //       selectedYear!,
      //       selectedMonth! + 1,
      //       0,
      //     ).day;
      //     revenue.assignAll(List.filled(daysInMonth, 0.0));
      //     expenses.assignAll(List.filled(daysInMonth, 0.0));
      //     net.assignAll(List.filled(daysInMonth, 0.0));
      //     carsNumber.assignAll(List.filled(daysInMonth, 0.0));
      //     break;
      //   case 'day':
      //     revenue.assignAll(List.filled(1, 0.0));
      //     expenses.assignAll(List.filled(1, 0.0));
      //     net.assignAll(List.filled(1, 0.0));
      //     carsNumber.assignAll(List.filled(1, 0.0));
      //     break;
      //   default:
      //     revenue.assignAll(List.filled(12, 0.0));
      //     expenses.assignAll(List.filled(12, 0.0));
      //     net.assignAll(List.filled(12, 0.0));
      //     carsNumber.assignAll(List.filled(12, 0.0));
      // }
      // final String dateType = isSoldStatusSelected.value ? 'SELL' : 'BUY';

      // for (var trade in filteredTrades) {
      //   DateTime? parsed;

      //   var pay = 0.0;
      //   var receive = 0.0;
      //   final items = trade['items'] as List<dynamic>?;
      //   if (items == null || items.isEmpty) continue;
      //   for (var item in items) {
      //     try {
      //       // if (getdataName(item['item'], allItems) == dateType) {
      //       //   parsed = itemformat.parse(item['date']);
      //       // }
      //     } catch (_) {
      //       continue;
      //     }
      //     pay += double.tryParse(item['pay']) ?? 0;
      //     receive += double.tryParse(item['receive']) ?? 0;
      //   }
      //   int idx;
      //   switch (mode) {
      //     case 'year':
      //       idx = parsed!.month - 1;
      //       break;
      //     case 'month':
      //       idx = parsed!.day - 1;
      //       break;
      //     case 'day':
      //       idx = 0;
      //       break;
      //     default:
      //       idx = -1;
      //   }
      //   revenue[idx] += receive; // sum of all receives
      //   expenses[idx] += pay; // sum of all pays
      //   net[idx] += (receive - pay); // net = receive minus pay
      //   carsNumber[idx] += 1;
      //   // if (idx >= 0 && idx < revenue.length) {
      //   //   revenue[idx] += receive; // sum of all receives
      //   //   expenses[idx] += pay; // sum of all pays
      //   //   net[idx] += (receive - pay); // net = receive minus pay
      //   // }
      // }
    } catch (e) {
      // print(e);
    }
  }

  void filterTradesByDate() {
    // final int? selectedYear = year.value.text.isNotEmpty
    //     ? int.tryParse(year.value.text)
    //     : null;
    // final int? selectedMonth = month.value.text.isNotEmpty
    //     ? monthNameToNumber(month.value.text)
    //     : null;
    // final int? selectedDay = day.value.text.isNotEmpty
    //     ? int.tryParse(day.value.text)
    //     : null;

    // final String? selectedBrand = carBrandId.value != ''
    //     ? carBrandId.value
    //     : null;
    // final String? selectedModel = carModelId.value != ''
    //     ? carModelId.value
    //     : null;

    // // 1️⃣ New: read “new status” toggle
    // final bool isNewSelected = isNewStatusSelected.value;

    // final String dateType = isSoldStatusSelected.value ? 'SELL' : 'BUY';

    // final List<Map<String, dynamic>> temp = [];

    // for (var trade in allTrades) {
    //   // 2️⃣ New: if we only want “new” trades, skip all others
    //   if (isNewSelected) {
    //     final String? status = trade['status'] as String?;
    //     if (status?.toLowerCase() != 'new') continue;
    //   }

    //   final String? tradeBrand = trade['car_brand'] as String?;
    //   final String? tradeModel = trade['car_model'] as String?;
    //   if (selectedBrand != null && tradeBrand != selectedBrand) continue;
    //   if (selectedModel != null && tradeModel != selectedModel) continue;
    //   final items = trade['items'] as List<dynamic>?;
    //   if (items == null || items.isEmpty) continue;

    //   DateTime? latestForThisTrade;

    //   for (var item in items) {
    //     if (getdataName(item['item'], allItems) != dateType) continue;

    //     DateTime parsed;
    //     try {
    //       parsed = itemformat.parse(item['date']);
    //     } catch (_) {
    //       continue;
    //     }

    //     if (selectedYear != null && parsed.year != selectedYear) continue;
    //     if (selectedMonth != null && parsed.month != selectedMonth) continue;
    //     if (selectedDay != null && parsed.day != selectedDay) continue;

    //     if (latestForThisTrade == null || parsed.isAfter(latestForThisTrade)) {
    //       latestForThisTrade = parsed;
    //     }
    //   }

    //   if (latestForThisTrade != null) {
    //     temp.add({'trade': trade, 'date': latestForThisTrade});
    //   }
    // }

    // if (selectedYear == null && selectedMonth == null && selectedDay == null) {
    //   temp.sort(
    //     (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime),
    //   );
    // }

    // filteredTrades.value = temp
    //     .map((e) => e['trade'] as DocumentSnapshot<Object?>)
    //     .toList();

    // calculateTotalsForAllTrades();
    // filterTradesForChart();
    // numberOfCars.value = filteredTrades.length;
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

  void calculateTotalsForCapitals(RxList allMap) {
    totalPays.value = 0;
    totalReceives.value = 0;
    totalNETs.value = 0;
    for (var element in allMap) {
      totalPays.value += element.pay;
      totalReceives.value += element.receive;
      totalNETs.value = totalReceives.value - totalPays.value;
    }
  }

  // this function is to filter the search results for web
  void filterCapitalsOrOutstandingOrGeneralExpenses(
    Rx<TextEditingController> mapQuery,
    RxList allMap,
    RxList filteredMap,
    bool isGeneral,
  ) {
    query.value = mapQuery.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredMap.clear();
      calculateTotalsForCapitals(allMap);
    } else {
      filteredMap.assignAll(
        allMap.where((cap) {
          return cap.pay.toString().toLowerCase().contains(query) ||
              cap.receive.toString().toLowerCase().contains(query) ||
              cap.comment.toString().toLowerCase().contains(query) ||
              (isGeneral == false ? cap.name : cap.item)
                  .toString()
                  .toLowerCase()
                  .contains(query) ||
              textToDate(cap.date).toLowerCase().contains(query);
        }).toList(),
      );
      calculateTotalsForCapitals(filteredMap);
    }
  }
}
