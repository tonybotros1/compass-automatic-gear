import 'dart:convert';
import 'package:datahubai/Controllers/Main%20screen%20controllers/car_brands_controller.dart';
import 'package:datahubai/Controllers/Main%20screen%20controllers/list_of_values_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../Models/car trading/capitals_outstanding_model.dart';
import '../../Models/car trading/car_trade_model.dart';
import '../../Models/car trading/car_trading_items_model.dart';
import '../../Models/car trading/general_expenses_model.dart';
import '../../Models/car trading/last_changes_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import '../Main screen controllers/websocket_controller.dart';

class CarTradingDashboardController extends GetxController {
  Rx<TextEditingController> searchForCapitalsOrOutstandingOrGeneralExpenses =
      TextEditingController().obs;
  Rx<TextEditingController> carModelFilter = TextEditingController().obs;
  Rx<TextEditingController> carBrandFilter = TextEditingController().obs;
  Rx<TextEditingController> carEngineSizeFilter = TextEditingController().obs;
  Rx<TextEditingController> carBoughtFromFilter = TextEditingController().obs;
  Rx<TextEditingController> carSoldToFilter = TextEditingController().obs;
  Rx<TextEditingController> carSoldByFilter = TextEditingController().obs;
  Rx<TextEditingController> carBoughtByFilter = TextEditingController().obs;
  Rx<TextEditingController> carSpecificationFilter =
      TextEditingController().obs;
  RxString carBrandFilterId = RxString('');
  RxString carModelFilterId = RxString('');
  RxString carEngineSizeFilterId = RxString('');
  RxString carBoughtFromFilterId = RxString('');
  RxString carSoldToFilterId = RxString('');
  RxString carSoldByFilterId = RxString('');
  RxString carBoughtByFilterId = RxString('');
  RxString carSpecificationFilterId = RxString('');
  final RxList<CapitalsAndOutstandingModel> allCapitals =
      RxList<CapitalsAndOutstandingModel>([]);
  final RxList<CapitalsAndOutstandingModel> allOutstanding =
      RxList<CapitalsAndOutstandingModel>([]);
  final RxList<GeneralExpensesModel> allGeneralExpenses =
      RxList<GeneralExpensesModel>([]);
  final RxList<CarTradeModel> filteredTrades = RxList<CarTradeModel>([]);
  final RxList<CapitalsAndOutstandingModel> filteredCapitals =
      RxList<CapitalsAndOutstandingModel>([]);
  final RxList<CapitalsAndOutstandingModel> filteredOutstanding =
      RxList<CapitalsAndOutstandingModel>([]);
  final RxList<GeneralExpensesModel> filteredGeneralExpenses =
      RxList<GeneralExpensesModel>([]);
  final RxList<LastCarTradingChangesModel> lastChanges =
      RxList<LastCarTradingChangesModel>([]);
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
  RxDouble totalNETsForBanckBalance = RxDouble(0.0);
  RxDouble totalNetProfit = RxDouble(0.0);
  DateFormat inputFormat = DateFormat("dd-MM-yyyy");
  RxBool isNewStatusSelected = RxBool(false);
  RxBool isSoldStatusSelected = RxBool(false);
  RxBool isTodaySelected = RxBool(false);
  RxBool isThisMonthSelected = RxBool(false);
  RxBool isThisYearSelected = RxBool(false);
  RxMap allModels = RxMap({});
  RxString status = RxString('');
  RxString currentTradId = RxString('');
  RxString colorOutId = RxString('');
  RxBool addingNewValue = RxBool(false);
  Rx<TextEditingController> searchForItems = TextEditingController().obs;
  Rx<TextEditingController> date = TextEditingController().obs;
  Rx<TextEditingController> mileage = TextEditingController().obs;
  Rx<TextEditingController> colorOut = TextEditingController().obs;
  Rx<TextEditingController> colorIn = TextEditingController().obs;
  Rx<TextEditingController> carSpecification = TextEditingController().obs;
  Rx<TextEditingController> carBrand = TextEditingController().obs;
  Rx<TextEditingController> carModel = TextEditingController().obs;
  Rx<TextEditingController> engineSize = TextEditingController().obs;
  Rx<TextEditingController> boughtFrom = TextEditingController().obs;
  Rx<TextEditingController> boughtBy = TextEditingController().obs;
  Rx<TextEditingController> year = TextEditingController().obs;
  Rx<TextEditingController> soldTo = TextEditingController().obs;
  Rx<TextEditingController> soldBy = TextEditingController().obs;
  Rx<TextEditingController> serviceContractEndDate =
      TextEditingController().obs;
  Rx<TextEditingController> warrantyEndDate = TextEditingController().obs;
  TextEditingController pay = TextEditingController();
  TextEditingController receive = TextEditingController();
  Rx<TextEditingController> comments = TextEditingController().obs;
  TextEditingController note = TextEditingController();
  TextEditingController item = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController accountName = TextEditingController();
  RxString accountNameId = RxString('');
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
  RxString boughtById = RxString('');
  RxString yearId = RxString('');
  RxString soldToId = RxString('');
  RxString soldById = RxString('');
  RxString itemId = RxString('');
  RxString nameId = RxString('');
  RxList<CarTradingItemsModel> addedItems = RxList([]);
  RxDouble totalPays = RxDouble(0.0);
  RxDouble totalReceives = RxDouble(0.0);
  RxDouble totalNETs = RxDouble(0.0);
  RxList<CarTradingItemsModel> filteredAddedItems =
      RxList<CarTradingItemsModel>([]);
  RxBool isCapitalLoading = RxBool(false);
  String backendUrl = backendTestURI;
  WebSocketService ws = Get.find<WebSocketService>();
  RxBool gettingCapitalsSummary = RxBool(false);
  RxBool gettingOutstandingSummary = RxBool(false);
  RxBool gettingGeneralExpensesSummary = RxBool(false);
  Rx<TextEditingController> fromDate = TextEditingController().obs;
  Rx<TextEditingController> fromDateForChanges = TextEditingController().obs;
  Rx<TextEditingController> toDate = TextEditingController().obs;
  Rx<TextEditingController> toDateForChanges = TextEditingController().obs;
  RxBool carModified = RxBool(false);
  RxBool itemsModified = RxBool(false);
  final Uuid _uuid = const Uuid();
  RxBool searching = RxBool(false);
  RxBool changesSearching = RxBool(false);
  final ScrollController scrollControllerForTable = ScrollController();
  var buttonLoadingStates = <String, bool>{}.obs;
  final ScrollController scrollControllerForCarInformation = ScrollController();
  final ScrollController scrollControllerForBuySell = ScrollController();
  final carBrandsController = Get.put(CarBrandsController());
  final listOfValuesController = Get.put(ListOfValuesController());

  final FocusNode focusNodeForitems1 = FocusNode();
  final FocusNode focusNodeForitems2 = FocusNode();
  final FocusNode focusNodeForitems3 = FocusNode();
  final FocusNode focusNodeForitems4 = FocusNode();
  final FocusNode focusNodeForitems5 = FocusNode();

  final FocusNode focusNodeForCarInformation1 = FocusNode();
  final FocusNode focusNodeForCarInformation2 = FocusNode();
  final FocusNode focusNodeForCarInformation3 = FocusNode();
  final FocusNode focusNodeForCarInformation4 = FocusNode();
  final FocusNode focusNodeForCarInformation5 = FocusNode();
  final FocusNode focusNodeForCarInformation6 = FocusNode();
  final FocusNode focusNodeForCarInformation7 = FocusNode();
  final FocusNode focusNodeForCarInformation8 = FocusNode();
  final FocusNode focusNodeForCarInformation9 = FocusNode();

  final FocusNode focusNodeForBuySell1 = FocusNode();
  final FocusNode focusNodeForBuySell2 = FocusNode();
  final FocusNode focusNodeForBuySell3 = FocusNode();
  final FocusNode focusNodeForBuySell4 = FocusNode();

  RxList<Map<String, dynamic>> summaryData = RxList<Map<String, dynamic>>([
    {"category": "🚘  Cars"},
    {"category": "🏷️  Capital Docs"},
    {"category": "⚠️  Outstanding"},
    {"category": "📜  Expenses"},
  ]);

  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
   final selectedRowIndex = (-1).obs;

  void selectRow(int index) {
    selectedRowIndex.value = index;
    update();
  }

  @override
  void onInit() async {
    connectWebSocket();
    getCashOnHandOrBankBalance('CASH');
    getCashOnHandOrBankBalance('FAB BANK');
    getCapitalsOROutstandingSummary('capitals');
    getCapitalsOROutstandingSummary('outstanding');
    filterGeneralExpensesSearch();
    filterSearch();
    focusNodeForitems1.addListener(() {
      if (!focusNodeForitems1.hasFocus) {
        normalizeDate(itemDate.value.text, itemDate.value);
      }
    });
    super.onInit();
  }

  @override
  void dispose() {
    focusNodeForitems1.dispose();
    super.dispose();
  }

  void onChooseForDatePicker(int i) {
    switch (i) {
      case 1:
        isTodaySelected.value = false;
        isThisMonthSelected.value = false;
        isThisYearSelected.value = false;
        fromDate.value.clear();
        toDate.value.clear();
        filterSearch();
        break;
      case 2:
        setTodayRange(fromDate.value, toDate.value);
        isTodaySelected.value = true;
        isThisMonthSelected.value = false;
        isThisYearSelected.value = false;
        filterSearch();
        break;
      case 3:
        setThisMonthRange(fromDate.value, toDate.value);
        isTodaySelected.value = false;
        isThisMonthSelected.value = true;
        isThisYearSelected.value = false;
        filterSearch();

        break;
      case 4:
        setThisYearRange(fromDate.value, toDate.value);
        isTodaySelected.value = false;
        isThisMonthSelected.value = false;
        isThisYearSelected.value = true;
        filterSearch();

        break;
      default:
    }
  }

  void onChooseForDatePickerForChanges(int i) {
    switch (i) {
      case 1:
        setTodayRange(fromDateForChanges.value, toDateForChanges.value);
        filterLastChangesSearch();
        break;
      case 2:
        setThisMonthRange(fromDateForChanges.value, toDateForChanges.value);
        filterLastChangesSearch();
        break;
      case 3:
        setThisYearRange(fromDateForChanges.value, toDateForChanges.value);
        filterLastChangesSearch();

        break;
      default:
    }
  }

  void onChooseForStatusPicker(int i) {
    switch (i) {
      case 1:
        isNewStatusSelected.value = false;
        isSoldStatusSelected.value = false;
        filterSearch();
        break;
      case 2:
        if (isNewStatusSelected.isFalse) {
          isNewStatusSelected.value = true;
          isSoldStatusSelected.value = false;
          filterSearch();
        } else {
          isNewStatusSelected.value = false;
        }
        break;
      case 3:
        if (isSoldStatusSelected.isFalse) {
          isSoldStatusSelected.value = true;
          isNewStatusSelected.value = false;
          filterSearch();
        } else {
          isSoldStatusSelected.value = false;
        }
        break;

      default:
    }
  }

  void setTodayRange(
    TextEditingController fromDate,
    TextEditingController toDate,
  ) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    fromDate.text = dateFormat.format(today);
    toDate.text = dateFormat.format(today);
  }

  void setThisMonthRange(
    TextEditingController fromDate,
    TextEditingController toDate,
  ) {
    final now = DateTime.now();

    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    fromDate.text = dateFormat.format(firstDayOfMonth);
    toDate.text = dateFormat.format(lastDayOfMonth);
  }

  void setThisYearRange(
    TextEditingController fromDate,
    TextEditingController toDate,
  ) {
    final now = DateTime.now();

    final firstDayOfYear = DateTime(now.year, 1, 1);
    final lastDayOfYear = DateTime(now.year, 12, 31);

    fromDate.text = dateFormat.format(firstDayOfYear);
    toDate.text = dateFormat.format(lastDayOfYear);
  }

  // function to manage loading button
  void setButtonLoading(String id, bool isLoading) {
    buttonLoadingStates[id] = isLoading;
    buttonLoadingStates.refresh(); // Notify listeners
  }

  void connectWebSocket() {
    ws.events.listen((message) {
      switch (message["type"]) {
        case "capital_created":
          final newCapital = CapitalsAndOutstandingModel.fromJson(
            message["data"],
          );
          allCapitals.add(newCapital);
          break;

        case "capital_updated":
          final updated = CapitalsAndOutstandingModel.fromJson(message["data"]);
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

        case "outstanding_created":
          final newModel = CapitalsAndOutstandingModel.fromJson(
            message["data"],
          );
          allOutstanding.add(newModel);
          break;

        case "outstanding_updated":
          final updated = CapitalsAndOutstandingModel.fromJson(message["data"]);
          final totals = message['totals'];
          final index = allOutstanding.indexWhere((m) => m.id == updated.id);
          if (index != -1) {
            allOutstanding[index] = updated;
            totalPays.value = totals['pay'];
            totalReceives.value = totals['receive'];
            totalNETs.value = totals['net'];
          }
          break;

        case "outstanding_deleted":
          final deletedId = message["data"]["_id"];
          allOutstanding.removeWhere((m) => m.id == deletedId);
          break;

        case "general_expenses_created":
          final newModel = GeneralExpensesModel.fromJson(message["data"]);
          allGeneralExpenses.add(newModel);
          break;

        case "general_expenses_updated":
          final updated = GeneralExpensesModel.fromJson(message["data"]);
          final totals = message['totals'];
          final index = allGeneralExpenses.indexWhere(
            (m) => m.id == updated.id,
          );
          if (index != -1) {
            allGeneralExpenses[index] = updated;
            totalPays.value = totals['pay'];
            totalReceives.value = totals['receive'];
            totalNETs.value = totals['net'];
          }
          break;

        case "general_expenses_deleted":
          final deletedId = message["data"]["_id"];
          allGeneralExpenses.removeWhere((m) => m.id == deletedId);
          break;
      }
    });
  }

  Future<Map<String, dynamic>> getYears() async {
    return await helper.getAllListValues('YEARS');
  }

  Future<Map<String, dynamic>> getItems() async {
    return await helper.getAllListValues('ITEMS');
  }

  Future<Map<String, dynamic>> getColors() async {
    return await helper.getAllListValues('COLORS');
  }

  Future<Map<String, dynamic>> getCarSpecefications() async {
    return await helper.getAllListValues('CAR_SPECIFICATIONS');
  }

  Future<Map<String, dynamic>> getEngineTypes() async {
    return await helper.getAllListValues('ENGINE_TYPES');
  }

  Future<Map<String, dynamic>> getBuyersAndSellers() async {
    return await helper.getAllListValues('BUYERS_AND_SELLERS');
  }

  Future<Map<String, dynamic>> getBuyersAndSellersBy() async {
    return await helper.getAllListValues('BOUGHT_SOLD_BY');
  }

  Future<Map<String, dynamic>> getNamesOfPeople() async {
    return await helper.getAllListValues('NAMES_OF_PEOPLE');
  }

  Future<Map<String, dynamic>> getNamesOfAccount() async {
    return await helper.getAllListValues('CAR_TRADING_CASH_BANK');
  }

  Future<Map<String, dynamic>> getListDetils(String code) async {
    return await helper.getListDetails(code);
  }

  Future<Map<String, dynamic>> getCarBrands() async {
    return await helper.getCarBrands();
  }

  Future<Map<String, dynamic>> getModelsByCarBrand(String brandId) async {
    return await helper.getModelsValues(brandId);
  }

  void addNewCapitalOrOutstandingOrGeneralExpenses(String type) async {
    switch (type) {
      case 'capitals':
        await addNewCapitalOrOutstanding(type);
        break;
      case 'outstanding':
        await addNewCapitalOrOutstanding(type);
        break;
      case 'general_expenses':
        await addNewGeneralExpenses();
        break;
      default:
    }
  }

  void deleteCapitalOrOutstandingOrGeneralExpenses(
    String type,
    String id,
  ) async {
    switch (type) {
      case 'capitals':
        await deleteCapitalOrOutstanding(id, type);
        break;
      case 'outstanding':
        await deleteCapitalOrOutstanding(id, type);
        break;
      case 'general_expenses':
        await deleteGeneralExpenses(id);
        break;
      default:
    }
  }

  void updateCapitalOrOutstandingOrGeneralExpenses(
    String type,
    String id,
  ) async {
    switch (type) {
      case 'capitals':
        await updateCapitalOrOutstanding(id, type);
        break;
      case 'outstanding':
        await updateCapitalOrOutstanding(id, type);
        break;
      case 'general_expenses':
        await updateGeneralEpenses(id);
        break;
      default:
    }
  }

  void filterLastChangesSearch() async {
    Map body = {};
    if (fromDateForChanges.value.text.isNotEmpty) {
      body['from_date'] = convertDateToIson(fromDateForChanges.value.text);
    }
    if (toDateForChanges.value.text.isNotEmpty) {
      body['to_date'] = convertDateToIson(toDateForChanges.value.text);
    }
    await getLastChanges(body);
  }

  Future<void> getLastChanges(Map body) async {
    try {
      changesSearching.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/car_trading/get_last_changes');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List changes = decoded['last_changes'] ?? [];
        lastChanges.assignAll(
          changes.map((change) => LastCarTradingChangesModel.fromJson(change)),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getLastChanges(body);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      changesSearching.value = false;
    } catch (e) {
      changesSearching.value = false;
    }
  }

  // ==================================== Capitals and Outstanding section ====================================

  Future<void> getCapitalsOROutstandingSummary(String type) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/car_trading/get_capitals_or_outstanding_summary/$type',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        Map totals = decoded["summary"];
        if (type == 'capitals') {
          totalPaysForAllCapitals.value = totals['total_pay'];
          totalReceivesForAllCapitals.value = totals['total_receive'];
          totalNETsForAllCapitals.value = totals['total_net'];
          numberOfCapitalsDocs.value = totals['count'];

          int i = summaryData.indexWhere(
            (data) => data['category'].contains('Capital Docs'),
          );
          summaryData[i] = {
            ...summaryData[i],
            'count': numberOfCapitalsDocs.value,
            'paid': totalPaysForAllCapitals.value,
            'received': totalReceivesForAllCapitals.value,
            'net': totalNETsForAllCapitals.value,
          };
        } else if (type == 'outstanding') {
          totalPaysForAllOutstanding.value = totals['total_pay'];
          totalReceivesForAllOutstanding.value = totals['total_receive'];
          totalNETsForAllOutstanding.value = totals['total_net'];
          numberOfOutstandingDocs.value = totals['count'];
          int i = summaryData.indexWhere(
            (data) => data['category'].contains('Outstanding'),
          );

          if (i != -1) {
            summaryData[i] = {
              ...summaryData[i],
              'count': numberOfOutstandingDocs.value,
              'paid': totalPaysForAllOutstanding.value,
              'received': totalReceivesForAllOutstanding.value,
              'net': totalNETsForAllOutstanding.value,
            };
          }
        }
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getCapitalsOROutstandingSummary(type);
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

  Future<void> getAllCapitalsOROutstanding(String type) async {
    try {
      isCapitalLoading.value = true;
      totalPays.value = 0;
      totalReceives.value = 0;
      totalNETs.value = 0;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/car_trading/get_all_capitals_or_outstanding/$type',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List data = decoded['data'];
        Map totals = decoded["totals"];
        totalPays.value = totals['total_pay'];
        totalReceives.value = totals['total_receive'];
        totalNETs.value = totals['total_net'];
        if (type == "capitals") {
          allCapitals.assignAll(
            data.map((c) => CapitalsAndOutstandingModel.fromJson(c)),
          );
        } else if (type == "outstanding") {
          allOutstanding.assignAll(
            data.map((c) => CapitalsAndOutstandingModel.fromJson(c)),
          );
        }
        isCapitalLoading.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllCapitalsOROutstanding(type);
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

  Future<void> addNewCapitalOrOutstanding(String type) async {
    try {
      if (itemDate.value.text.isEmpty) {
        alertMessage(context: Get.context!, content: 'Please add valid Date');
        return;
      }
      final parsedDate = inputFormat.parse(itemDate.value.text);
      final isoDate = parsedDate.toIso8601String();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/car_trading/add_new_capital_or_outstanding/$type',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "date": isoDate,
          "name": nameId.value,
          "account_name": accountNameId.value,
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
          await addNewCapitalOrOutstanding(type);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      Get.back();
    } catch (e) {
      Get.back();
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  Future<void> deleteCapitalOrOutstanding(String id, String type) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/car_trading/delete_capital_or_outstanding/$type/$id',
      );
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        Map totals = decoded["totals"];
        totalPays.value -= totals["pay"];
        totalReceives.value -= totals["receive"];
        totalNETs.value = totalReceives.value - totalPays.value;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteCapitalOrOutstanding(id, type);
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

  Future<void> updateCapitalOrOutstanding(String id, String type) async {
    try {
      if (itemDate.value.text.isEmpty) {
        alertMessage(context: Get.context!, content: 'Please add valid Date');
        return;
      }
      final parsedDate = inputFormat.parse(itemDate.value.text);
      final isoDate = parsedDate.toIso8601String();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/car_trading/update_capital_or_outstanding/$type/$id',
      );
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "date": isoDate,
          "name": nameId.value,
          "account_name": accountNameId.value,
          "pay": double.tryParse(pay.text) ?? 0.0,
          "receive": double.tryParse(receive.text) ?? 0.0,
          "comment": comments.value.text,
        }),
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await updateCapitalOrOutstanding(id, type);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      Get.back();
    } catch (e) {
      Get.back();
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  // ==================================== Geneal Expenses section ====================================

  Future<void> getAllGeneralExpenses() async {
    try {
      isCapitalLoading.value = true;
      totalPays.value = 0;
      totalReceives.value = 0;
      totalNETs.value = 0;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/car_trading/get_all_general_expenses');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List data = decoded['data'];
        Map totals = decoded["totals"];
        totalPays.value = totals['total_pay'];
        totalReceives.value = totals['total_receive'];
        totalNETs.value = totals['total_net'];

        allGeneralExpenses.assignAll(
          data.map((g) => GeneralExpensesModel.fromJson(g)),
        );

        isCapitalLoading.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllGeneralExpenses();
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

  void filterGeneralExpensesSearch() async {
    searching.value = true;

    Map<String, dynamic> body = {};
    if (isTodaySelected.isTrue) {
      body["today"] = true;
    }
    if (isThisMonthSelected.isTrue) {
      body["this_month"] = true;
    }
    if (isThisYearSelected.isTrue) {
      body["this_year"] = true;
    }
    if (fromDate.value.text.isNotEmpty) {
      final parsedDate = inputFormat
          .parse(fromDate.value.text)
          .toIso8601String();

      body["from_date"] = parsedDate;
    }
    if (toDate.value.text.isNotEmpty) {
      final parsedDate = inputFormat.parse(toDate.value.text).toIso8601String();

      body["to_date"] = parsedDate;
    }
    if (body.isNotEmpty) {
      await getGeneralExpensesSummary(body);
    } else {
      await getGeneralExpensesSummary({"all": true});
    }
    searching.value = false;
  }

  Future<void> getGeneralExpensesSummary(Map body) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/car_trading/get_general_expenses_summary',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        Map totals = decoded["summary"];
        totalPaysForAllGeneralExpenses.value = totals['total_pay'];
        totalReceivesForAllGeneralExpenses.value = totals['total_receive'];
        totalNETsForAllGeneralExpenses.value = totals['total_net'];
        numberOfGeneralExpensesDocs.value = totals['count'];
        totalNetProfit.value = totals['net_profit'];

        int i = summaryData.indexWhere(
          (data) => data['category'].contains('Expenses'),
        );
        summaryData[i] = {
          ...summaryData[i],
          'count': numberOfGeneralExpensesDocs.value,
          'paid': totalPaysForAllGeneralExpenses.value,
          'received': totalReceivesForAllGeneralExpenses.value,
          'net': totalNETsForAllGeneralExpenses.value,
        };
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getGeneralExpensesSummary(body);
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

  Future<void> addNewGeneralExpenses() async {
    try {
      if (itemDate.value.text.isEmpty) {
        alertMessage(context: Get.context!, content: 'Please add valid Date');
        return;
      }
      final parsedDate = inputFormat.parse(itemDate.value.text);
      final isoDate = parsedDate.toIso8601String();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/car_trading/add_new_general_expenses');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "date": isoDate,
          "item": itemId.value,
          "account_name": accountNameId.value,
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
          await addNewGeneralExpenses();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      Get.back();
    } catch (e) {
      Get.back();
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  Future<void> deleteGeneralExpenses(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/car_trading/delete_general_expenses/$id',
      );
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        Map totals = decoded["totals"];
        totalPays.value -= totals["pay"];
        totalReceives.value -= totals["receive"];
        totalNETs.value = totalReceives.value - totalPays.value;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteGeneralExpenses(id);
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

  Future<void> updateGeneralEpenses(String id) async {
    try {
      if (itemDate.value.text.isEmpty) {
        alertMessage(context: Get.context!, content: 'Please add valid Date');
        return;
      }
      final parsedDate = inputFormat.parse(itemDate.value.text);
      final isoDate = parsedDate.toIso8601String();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/car_trading/update_generale_expenses/$id',
      );
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "date": isoDate,
          "item": itemId.value,
          "pay": double.tryParse(pay.text) ?? 0.0,
          "account_name": accountNameId.value,
          "receive": double.tryParse(receive.text) ?? 0.0,
          "comment": comments.value.text,
        }),
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await updateGeneralEpenses(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      Get.back();
    } catch (e) {
      Get.back();
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  // ==================================== Car Trading section ====================================

  void calculateTotals() {
    totalNETs.value = 0.0;
    totalPays.value = 0.0;
    totalReceives.value = 0.0;

    for (var item in addedItems) {
      totalPays.value += item.pay!;
      totalReceives.value += item.receive!;
    }

    totalNETs.value = totalReceives.value - totalPays.value;
  }

  void addNewItem() {
    final String uniqueId = _uuid.v4();

    final parsedDate = inputFormat.parse(itemDate.value.text);
    addedItems.add(
      CarTradingItemsModel(
        id: uniqueId,
        date: parsedDate,
        tradeId: currentTradId.value,
        item: item.text,
        itemId: itemId.value,
        accountName: accountName.text,
        accountNameId: accountNameId.value,
        pay: double.tryParse(pay.value.text) ?? 0,
        receive: double.tryParse(receive.value.text) ?? 0,
        comment: comments.value.text,
        added: true,
        modified: true,
      ),
    );
    itemsModified.value = true;
    Get.back();
  }

  void updateIdsFromBackend(List response) {
    for (var map in response) {
      final uuid = map['uuid'];
      final realId = map['db_id'];

      final index = addedItems.indexWhere((item) => item.id == uuid);
      if (index != -1) {
        addedItems[index].id = realId; // replace temp uuid with real id
        addedItems[index].modified = false; // reset if needed
        addedItems.refresh();
      }
    }
  }

  Future<void> addNewTrade() async {
    try {
      if (date.value.text.isEmpty) {
        alertMessage(context: Get.context!, content: 'Please add valid Date');
        return;
      }

      addingNewValue.value = true;

      final parsedDate = inputFormat.parse(date.value.text);
      final isoDate = parsedDate.toIso8601String();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';

      Uri addUrl = Uri.parse('$backendUrl/car_trading/add_new_trade');
      Uri updateTradeUrl = Uri.parse(
        '$backendUrl/car_trading/update_trade/${currentTradId.value}',
      );
      Uri updateTradeItemUrl = Uri.parse(
        '$backendUrl/car_trading/update_trade_items',
      );

      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };

      Map<String, dynamic> body = {
        'bought_from': boughtFromId.value,
        'sold_to': soldToId.value,
        'bought_by': boughtById.value,
        'sold_by': soldById.value,
        'date': isoDate,
        'car_brand': carBrandId.value,
        'car_model': carModelId.value,
        'mileage': double.tryParse(mileage.value.text) ?? 0,
        'specification': carSpecificationId.value,
        'engine_size': engineSizeId.value,
        'color_in': colorInId.value,
        'color_out': colorOutId.value,
        'year': yearId.value,
        'note': note.text,
        'items': addedItems.where((item) => item.deleted == false).map((item) {
          final isoDate = (item.date is DateTime)
              ? (item.date as DateTime).toIso8601String()
              : DateTime.parse(item.date.toString()).toIso8601String();

          return {
            "item_id": item.itemId,
            "date": isoDate,
            "comment": item.comment,
            "pay": item.pay,
            "account_name": accountNameId.value,
            "receive": item.receive,
            "uuid": item.id,
          };
        }).toList(),
      };

      final rawDate = warrantyEndDate.value.text.trim();
      if (rawDate.isNotEmpty) {
        try {
          body['warranty_end_date'] = convertDateToIson(rawDate);
        } catch (e) {
          alertMessage(
            context: Get.context!,
            content: 'Please enter valid Warranty End Date',
          );
        }
      } else {
        body['warranty_end_date'] = null;
      }

      final rawDate2 = serviceContractEndDate.value.text.trim();
      if (rawDate2.isNotEmpty) {
        try {
          body['service_contract_end_date'] = convertDateToIson(rawDate2);
        } catch (e) {
          alertMessage(
            context: Get.context!,
            content: 'Please enter valid Service Contract End Date',
          );
        }
      } else {
        body['service_contract_end_date'] = null;
      }

      if (currentTradId.value == '') {
        // ---------- ADD ----------
        final response = await http.post(
          addUrl,
          headers: headers,
          body: jsonEncode(body),
        );

        final decoded = jsonDecode(response.body);
        if (response.statusCode == 200) {
          String tradeId = decoded["trade_id"];
          final uuids = decoded["items_map"];
          updateIdsFromBackend(uuids);
          currentTradId.value = tradeId;
          status.value = 'New';
          itemsModified.value = false;
          carModified.value = false;
        } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
          final refreshed = await helper.refreshAccessToken(refreshToken);
          if (refreshed == RefreshResult.success) {
            await addNewTrade();
          } else if (refreshed == RefreshResult.invalidToken) {
            logout();
          }
        } else if (response.statusCode == 401) {
          logout();
        } else {
          alertMessage(
            title: 'Error',
            content: decoded["detail"] ?? "Failed to add trade",
            context: Get.context!,
          );
        }
      } else {
        // ---------- UPDATE ----------
        http.Response? itemsResponse;
        http.Response? carResponse;

        if (itemsModified.isTrue) {
          itemsResponse = await http.patch(
            updateTradeItemUrl,
            headers: headers,
            body: jsonEncode(
              addedItems.where((item) => item.modified == true).map((item) {
                return {
                  "uuid": item.id,
                  "item": item.item,
                  "item_id": item.itemId,
                  "pay": item.pay,
                  "account_name": accountNameId.value,
                  "trade_id": item.tradeId,
                  "receive": item.receive,
                  "comment": item.comment,
                  "date": item.date?.toIso8601String(),
                  "deleted": item.deleted,
                  "modified": item.modified,
                  "added": item.added,
                };
              }).toList(),
            ),
          );
          final decoded = jsonDecode(itemsResponse.body);
          if (itemsResponse.statusCode == 200) {
            final uuids = decoded["items_map"];
            updateIdsFromBackend(uuids);
            itemsModified.value = false;
          } else if (itemsResponse.statusCode == 401 &&
              refreshToken.isNotEmpty) {
            final refreshed = await helper.refreshAccessToken(refreshToken);
            if (refreshed == RefreshResult.success) {
              await addNewTrade();
            } else if (refreshed == RefreshResult.invalidToken) {
              logout();
            }
          } else if (itemsResponse.statusCode == 401) {
            logout();
          } else {
            alertMessage(
              title: 'Error',
              content: decoded["detail"] ?? "Failed to update trade",
              context: Get.context!,
            );
          }
        }

        if (carModified.isTrue) {
          body.remove("items");
          body["status"] = status.value;
          carResponse = await http.patch(
            updateTradeUrl,
            headers: headers,
            body: jsonEncode(body),
          );
          final decoded = jsonDecode(carResponse.body);
          if (carResponse.statusCode == 200) {
            carModified.value = false;
          } else if (carResponse.statusCode == 401 && refreshToken.isNotEmpty) {
            final refreshed = await helper.refreshAccessToken(refreshToken);
            if (refreshed == RefreshResult.success) {
              await addNewTrade();
            } else if (refreshed == RefreshResult.invalidToken) {
              logout();
            }
          } else if (carResponse.statusCode == 401) {
            logout();
          } else {
            alertMessage(
              title: 'Error',
              content: decoded["detail"] ?? "Failed to update trade",
              context: Get.context!,
            );
          }
        }
      }
      addingNewValue.value = false;
    } catch (e) {
      addingNewValue.value = false;
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  void filterSearch() async {
    searching.value = true;

    Map<String, dynamic> body = {};
    // final parsedDate = inputFormat.parse(date.value.text);
    // final isoDate = parsedDate.toIso8601String();
    if (carBrandFilterId.value != '') {
      body["car_brand"] = carBrandFilterId.value;
    }
    if (carModelFilterId.value != '') {
      body["car_model"] = carModelFilterId.value;
    }
    if (carSpecificationFilterId.value != '') {
      body["specification"] = carSpecificationFilterId.value;
    }
    if (carEngineSizeFilterId.value != '') {
      body["engine_size"] = carEngineSizeFilterId.value;
    }
    if (carBoughtFromFilterId.value != '') {
      body["bought_from"] = carBoughtFromFilterId.value;
    }
    if (carSoldToFilterId.value != '') {
      body["sold_to"] = carSoldToFilterId.value;
    }
    if (carBoughtByFilterId.value != '') {
      body["bought_by"] = carBoughtByFilterId.value;
    }
    if (carSoldByFilterId.value != '') {
      body["sold_by"] = carSoldByFilterId.value;
    }
    if (isSoldStatusSelected.isTrue) {
      body["status"] = "Sold";
    }
    if (isNewStatusSelected.isTrue) {
      body["status"] = "New";
    }

    if (isTodaySelected.isTrue) {
      body["today"] = true;
    }
    if (isThisMonthSelected.isTrue) {
      body["this_month"] = true;
    }
    if (isThisYearSelected.isTrue) {
      body["this_year"] = true;
    }
    if (fromDate.value.text.isNotEmpty) {
      final parsedDate = inputFormat
          .parse(fromDate.value.text)
          .toIso8601String();

      body["from_date"] = parsedDate;
    }
    if (toDate.value.text.isNotEmpty) {
      final parsedDate = inputFormat.parse(toDate.value.text).toIso8601String();

      body["to_date"] = parsedDate;
    }
    if (body.isNotEmpty) {
      await searchEngine(body);
    } else {
      await searchEngine({"all": true});
    }
    searching.value = false;
  }

  Future<void> searchEngine(Map<String, dynamic> body) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      final refreshToken = await secureStorage.read(key: "refreshToken") ?? '';

      final url = Uri.parse(
        '$backendUrl/car_trading/search_engine_for_car_trading',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final data = decoded is List ? decoded[0] : decoded;
        List trades = data["trades"] ?? [];
        totalPaysForAllTrades.value = data['grand_total_pay'] ?? 0;
        totalReceivesForAllTrades.value = data['grand_total_receive'] ?? 0;
        totalNETsForAllTrades.value = data['grand_net'] ?? 0;

        filteredTrades.assignAll(
          trades.map((item) => CarTradeModel.fromJson(item)),
        );
        numberOfCars.value = trades.length;
        int i = summaryData.indexWhere(
          (data) => data['category'].contains('Cars'),
        );
        summaryData[i] = {
          ...summaryData[i],
          'count': numberOfCars.value,
          'paid': totalPaysForAllTrades.value,
          'received': totalReceivesForAllTrades.value,
          'net': totalNETsForAllTrades.value,
        };
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await searchEngine(body); // retry once
        } else {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
    } catch (e) {
      // print(e);
    }
  }

  Future<void> deleteTrade(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      final refreshToken = await secureStorage.read(key: "refreshToken") ?? '';

      final url = Uri.parse('$backendUrl/car_trading/delete_trade/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        filteredTrades.removeWhere((trade) => trade.id == id);
        numberOfCars.value -= 1;
        Get.close(2);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteTrade(id);
        } else {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        Get.back();
        alertMessage(
          context: Get.context!,
          content: 'Something went wrong please try again',
        );
      }
    } catch (e) {
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  Future<void> getCashOnHandOrBankBalance(String accountName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      final refreshToken = await secureStorage.read(key: "refreshToken") ?? '';

      final url = Uri.parse(
        '$backendUrl/car_trading/get_cash_on_hand_or_bank_balance/$accountName',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (accountName == 'CASH') {
          totalNETsForAll.value = decoded['totals']['final_net'];
        } else {
          totalNETsForBanckBalance.value = decoded['totals']['final_net'];
        }
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getCashOnHandOrBankBalance(accountName);
        } else {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        Get.back();
      }
    } catch (e) {
      //
    }
  }

  // =======================================================================================================

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

  void filterItems() {
    final query = searchForItems.value.text.trim().toLowerCase();
    if (query.isEmpty) {
      filteredAddedItems.clear();
    } else {
      filteredAddedItems.assignAll(
        addedItems.where((item) {
          final dateStr = item.date.toString().toLowerCase();
          final itemName = item.item.toString().toLowerCase();
          final payStr = item.pay.toString().toLowerCase();
          final receiveStr = item.receive.toString().toLowerCase();
          final commentStr = item.comment.toString().toLowerCase();

          return dateStr.contains(query) ||
              itemName.contains(query) ||
              payStr.contains(query) ||
              commentStr.contains(query) ||
              receiveStr.contains(query);
        }).toList(),
      );
    }
  }

  Future loadValues(CarTradeModel data) async {
    boughtFrom.value.text = data.boughtFrom ?? '';
    boughtFromId.value = data.boughtFromId ?? '';
    boughtById.value = data.boughtById ?? '';
    boughtBy.value.text = data.boughtBy ?? '';
    soldById.value = data.soldById ?? '';
    soldBy.value.text = data.soldBy ?? '';
    soldTo.value.text = data.soldTo ?? '';
    soldToId.value = data.soldToId ?? '';
    totalPays.value = data.totalPay ?? 0.0;
    totalNETs.value = data.net ?? 0.0;
    totalReceives.value = data.totalReceive ?? 0.0;
    query.value = '';
    queryForItems.value = '';
    searchForItems.value.clear();
    await getModelsByCarBrand(data.carBrandId ?? '');
    date.value.text = textToDate(data.date);
    mileage.value.text = data.mileage.toString();
    colorIn.value.text = data.colorIn ?? '';
    colorInId.value = data.colorInId ?? '';
    colorOut.value.text = data.colorOut ?? '';
    colorOutId.value = data.colorOutId ?? '';
    carBrand.value.text = data.carBrand ?? '';
    carBrandId.value = data.carBrandId ?? '';
    carModel.value.text = data.carModel ?? '';
    carModelId.value = data.carModelId ?? '';
    carSpecification.value.text = data.specification ?? '';
    carSpecificationId.value = data.specificationId ?? '';
    engineSize.value.text = data.engineSize ?? '';
    engineSizeId.value = data.engineSizeId ?? '';
    year.value.text = data.year ?? '';
    yearId.value = data.yearId ?? '';
    note.text = data.note ?? '';
    addedItems.assignAll(data.tradeItems ?? []);
    status.value = data.status ?? '';
    currentTradId.value = data.id ?? '';
    carModified.value = false;
    itemsModified.value = false;
    warrantyEndDate.value.text = textToDate(data.warrantyEndDate);
    serviceContractEndDate.value.text = textToDate(data.serviceContractEndDate);
  }

  void clearValues() {
    warrantyEndDate.value.clear();
    serviceContractEndDate.value.clear();
    boughtFrom.value.clear();
    boughtBy.value.clear();
    soldBy.value.clear();
    boughtFromId.value = '';
    boughtById.value = '';
    soldById.value = '';
    soldTo.value.clear();
    soldToId.value = '';
    totalPays.value = 0.0;
    totalNETs.value = 0.0;
    totalReceives.value = 0.0;
    query.value = '';
    queryForItems.value = '';
    searchForItems.value.clear();
    allModels.clear();
    date.value.text = textToDate(DateTime.now());
    mileage.value.text = '';
    colorIn.value.clear();
    colorInId.value = '';
    colorOut.value.clear();
    colorOutId.value = '';
    carBrand.value.clear();
    carBrandId.value = '';
    carModel.value.clear();
    carModelId.value = '';
    carSpecification.value.clear();
    carSpecificationId.value = '';
    engineSize.value.clear();
    engineSizeId.value = '';
    year.value.clear();
    yearId.value = '';
    note.clear();
    addedItems.clear();
    status.value = '';
    currentTradId.value = '';
  }

  void clearFilters() {
    isTodaySelected.value = false;
    isThisMonthSelected.value = false;
    isThisYearSelected.value = false;
    carBrandFilter.value.clear();
    carModelFilter.value.clear();
    carBrandFilterId.value = '';
    carModelFilterId.value = '';
    allModels.clear();
    carSoldToFilter.value.clear();
    carSoldToFilterId.value = '';
    carBoughtFromFilter.value.clear();
    carBoughtFromFilterId.value = '';
    isNewStatusSelected.value = false;
    isSoldStatusSelected.value = false;
    carEngineSizeFilter.value.clear();
    carEngineSizeFilterId.value = '';
    carSpecificationFilter.value.clear();
    carSpecificationFilterId.value == '';
    fromDate.value.clear();
    toDate.value.clear();
  }
}
