import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../Models/car trading/capitals_model.dart';
import '../../Models/car trading/car_trade_model.dart';
import '../../Models/car trading/car_trading_items_model.dart';
import '../../Models/car trading/general_expenses_model.dart';
import '../../Models/car trading/outstanding_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import '../Main screen controllers/websocket_controller.dart';

class CarTradingDashboardController extends GetxController {
  Rx<TextEditingController> searchForCapitalsOrOutstandingOrGeneralExpenses =
      TextEditingController().obs;
  Rx<TextEditingController> yearFilter = TextEditingController().obs;
  TextEditingController monthFilter = TextEditingController();
  TextEditingController dayFilter = TextEditingController();
  Rx<TextEditingController> carModelFilter = TextEditingController().obs;
  Rx<TextEditingController> carBrandFilter = TextEditingController().obs;
  Rx<TextEditingController> carEngineSizeFilter = TextEditingController().obs;
  Rx<TextEditingController> carBoughtFromFilter = TextEditingController().obs;
  Rx<TextEditingController> carSoldToFilter = TextEditingController().obs;
  Rx<TextEditingController> carSpecificationFilter =
      TextEditingController().obs;
  RxString carBrandFilterId = RxString('');
  RxString carModelFilterId = RxString('');
  RxString carEngineSizeFilterId = RxString('');
  RxString carBoughtFromFilterId = RxString('');
  RxString carSoldToFilterId = RxString('');
  RxString carSpecificationFilterId = RxString('');
  final RxList<CapitalsModel> allCapitals = RxList<CapitalsModel>([]);
  final RxList<OutstandingModel> allOutstanding = RxList<OutstandingModel>([]);
  final RxList<GeneralExpensesModel> allGeneralExpenses =
      RxList<GeneralExpensesModel>([]);
  final RxList<CarTradeModel> filteredTrades = RxList<CarTradeModel>([]);
  final RxList<CapitalsModel> filteredCapitals = RxList<CapitalsModel>([]);
  final RxList<OutstandingModel> filteredOutstanding = RxList<OutstandingModel>(
    [],
  );
  final RxList<GeneralExpensesModel> filteredGeneralExpenses =
      RxList<GeneralExpensesModel>([]);
  RxMap allYears = RxMap({});
  RxBool isScreenLoding = RxBool(false);
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
  RxInt pagesPerPage = RxInt(15);
  DateFormat format = DateFormat('yyyy-MM-dd');
  DateFormat inputFormat = DateFormat("dd-MM-yyyy");
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
  RxList<CarTradingItemsModel> addedItems = RxList([]);
  RxDouble totalPays = RxDouble(0.0);
  RxDouble totalReceives = RxDouble(0.0);
  RxDouble totalNETs = RxDouble(0.0);
  RxList<CarTradingItemsModel> filteredAddedItems =
      RxList<CarTradingItemsModel>([]);
  RxMap allItems = RxMap({});
  RxMap allNames = RxMap({});
  RxBool isCapitalLoading = RxBool(false);
  String backendUrl = backendTestURI;
  WebSocketService ws = Get.find<WebSocketService>();
  final focusNode = FocusNode();
  RxBool gettingCapitalsSummary = RxBool(false);
  RxBool gettingOutstandingSummary = RxBool(false);
  RxBool gettingGeneralExpensesSummary = RxBool(false);
  Rx<TextEditingController> fromDate = TextEditingController().obs;
  Rx<TextEditingController> toDate = TextEditingController().obs;
  RxBool carModified = RxBool(false);
  RxBool itemsModified = RxBool(false);
  final Uuid _uuid = const Uuid();
  RxBool searching = RxBool(false);
  final ScrollController scrollControllerForTable = ScrollController();
  var buttonLoadingStates = <String, bool>{}.obs;

  @override
  void onInit() async {
    connectWebSocket();
    getCapitalsOROutstandingSummary('capitals');
    getCapitalsOROutstandingSummary('outstanding');
    getGeneralExpensesSummary();
    getCarBrands();
    getYears();
    getColors();
    getEngineTypes();
    getCarSpecefications();
    getBuyersAndSellers();
    getNamesOfPeople();
    getItems();
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

  // function to manage loading button
  void setButtonLoading(String id, bool isLoading) {
    buttonLoadingStates[id] = isLoading;
    buttonLoadingStates.refresh(); // Notify listeners
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

        case "outstanding_created":
          final newModel = OutstandingModel.fromJson(message["data"]);
          allOutstanding.add(newModel);
          break;

        case "outstanding_updated":
          final updated = OutstandingModel.fromJson(message["data"]);
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

  Future<void> getYears() async {
    allYears.assignAll(await helper.getAllListValues('YEARS'));
  }

  Future<void> getItems() async {
    allItems.assignAll(await helper.getAllListValues('ITEMS'));
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

  // ==================================== Capitals and Outstanding section ====================================

  Future<void> getCapitalsOROutstandingSummary(String type) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      print(accessToken);
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
        } else if (type == 'outstanding') {
          totalPaysForAllOutstanding.value = totals['total_pay'];
          totalReceivesForAllOutstanding.value = totals['total_receive'];
          totalNETsForAllOutstanding.value = totals['total_net'];
          numberOfOutstandingDocs.value = totals['count'];
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
          allCapitals.assignAll(data.map((c) => CapitalsModel.fromJson(c)));
        } else if (type == "outstanding") {
          allOutstanding.assignAll(
            data.map((c) => OutstandingModel.fromJson(c)),
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
        showSnackBar('Alert', 'Please add valid Date');
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
      showSnackBar('Alert', 'Something went wrong please try again');
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
        showSnackBar('Alert', 'Please add valid Date');
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
      showSnackBar('Alert', 'Something went wrong please try again');
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

  Future<void> getGeneralExpensesSummary() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/car_trading/get_general_expenses_summary',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        Map totals = decoded["summary"];
        totalPaysForAllGeneralExpenses.value = totals['total_pay'];
        totalReceivesForAllGeneralExpenses.value = totals['total_receive'];
        totalNETsForAllGeneralExpenses.value = totals['total_net'];
        numberOfGeneralExpensesDocs.value = totals['count'];
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getGeneralExpensesSummary();
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
        showSnackBar('Alert', 'Please add valid Date');
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
      showSnackBar('Alert', 'Something went wrong please try again');
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
        showSnackBar('Alert', 'Please add valid Date');
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
      showSnackBar('Alert', 'Something went wrong please try again');
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
        showSnackBar('Alert', 'Please add valid Date');
        return;
      }

      addingNewValue.value = true;
      bool finishUpdatind = false;

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
            "receive": item.receive,
            "uuid": item.id,
          };
        }).toList(),
      };

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
          showSnackBar('Done', decoded["message"]);
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
          showSnackBar('Error', decoded["detail"] ?? "Failed to add trade");
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
            finishUpdatind = true;
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
            showSnackBar(
              'Error',
              decoded["detail"] ?? "Failed to update items",
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
            finishUpdatind = true;
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
            showSnackBar(
              'Error',
              decoded["detail"] ?? "Failed to update trade",
            );
          }
        }
      }
      if (finishUpdatind == true) {
        showSnackBar('Done', 'Trade updated successfully');
      }
      addingNewValue.value = false;
    } catch (e) {
      addingNewValue.value = false;
      showSnackBar('Alert', 'Something went wrong please try again');
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
        print("yes");
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
      print(e);
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
        showSnackBar('Alert', 'Something went wrong please try again');
      }
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  // =======================================================================================================

  void calculateTotalsForAllAndNetProfit() {
    totalNETsForAll.value =
        totalNETsForAllCapitals.value +
        totalNETsForAllGeneralExpenses.value +
        totalNETsForAllOutstanding.value +
        totalNETsForAllTrades.value;

    totalNetProfit.value =
        totalNETsForAllTrades.value + totalNETsForAllGeneralExpenses.value;
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
  }

  void clearValues() {
    boughtFrom.value.clear();
    boughtFromId.value = '';
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
    mileage.value.text = '0';
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

  void onTapForAll() {
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
