import 'dart:convert';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/currencies/currencies_model.dart';
import '../../helpers.dart';
import 'main_screen_contro.dart';
import 'websocket_controller.dart';

class CurrencyController extends GetxController {
  TextEditingController code = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController rate = TextEditingController();
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(false);
  final RxList<CurrenciesModel> allCurrencies = RxList<CurrenciesModel>([]);
  final RxList<CurrenciesModel> filteredCurrencies = RxList<CurrenciesModel>(
    [],
  );
  final GlobalKey<FormState> formKeyForAddingNewvalue = GlobalKey<FormState>();
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  RxString companyId = RxString('');
  RxString countryId = RxString('');
  RxMap allCountries = RxMap({});
  String backendUrl = backendTestURI;
  WebSocketService ws = Get.find<WebSocketService>();

  @override
  void onInit() {
    connectWebSocket();
    getCountries();
    getAllCurrencies();

    super.onInit();
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  void connectWebSocket() {
    ws.events.listen((message) {
      switch (message["type"]) {
        case "currency_created":
          final newCounter = CurrenciesModel.fromJson(message["data"]);
          allCurrencies.add(newCounter);
          break;

        case "currency_status_updated":
          final branchId = message["data"]['_id'];
          final branchStatus = message["data"]['status'];
          final index = allCurrencies.indexWhere((m) => m.id == branchId);
          if (index != -1) {
            allCurrencies[index].status = branchStatus;
            allCurrencies.refresh();
          }
          break;

        case "currency_updated":
          final updated = CurrenciesModel.fromJson(message["data"]);
          final index = allCurrencies.indexWhere((m) => m.id == updated.id);
          if (index != -1) {
            allCurrencies[index] = updated;
          }
          break;

        case "currency_deleted":
          final deletedId = message["data"]["_id"];
          allCurrencies.removeWhere((m) => m.id == deletedId);
          break;
      }
    });
  }

  Future<void> getCountries() async {
    allCountries.assignAll(await helper.getCountries());
  }

  Future<void> getAllCurrencies() async {
    try {
      isScreenLoding.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/currencies/get_all_currencies');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List currencies = decoded['currencies'];
        allCurrencies.assignAll(
          currencies.map((branch) => CurrenciesModel.fromJson(branch)),
        );
        isScreenLoding.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllCurrencies();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        isScreenLoding.value = false;
        logout();
      } else {
        isScreenLoding.value = false;
      }
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  Future<void> addNewCurrency() async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/currencies/add_new_currency');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "country_id": countryId.value,
          "rate": double.tryParse(rate.text) ?? 0,
        }),
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewCurrency();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
      Get.back();
    }
  }

  Future<void> updateCurrency(String id) async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/currencies/update_currency/$id');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "country_id": countryId.value,
          "rate": double.tryParse(rate.text) ?? 0,
        }),
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await updateCurrency(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
      Get.back();
    }
  }

  Future<void> deleteCurrency(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/currencies/delete_currency/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteCurrency(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      Get.back();
    } catch (e) {
      Get.back();
    }
  }

  Future<void> changeCurrencyStatus(String id, bool status) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/currencies/change_currency_status/$id');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode(status),
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await changeCurrencyStatus(id, status);
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

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allCurrencies.sort((counter1, counter2) {
        final String? value1 = counter1.code;
        final String? value2 = counter2.code;

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allCurrencies.sort((counter1, counter2) {
        final String? value1 = counter1.name;
        final String? value2 = counter2.name;

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allCurrencies.sort((counter1, counter2) {
        final String value1 = counter1.rate.toString();
        final String value2 = counter2.rate.toString();

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 3) {
      allCurrencies.sort((counter1, counter2) {
        final String value1 = counter1.createdAt.toString();
        final String value2 = counter2.createdAt.toString();

        return compareString(ascending, value1, value2);
      });
    }
    sortColumnIndex.value = columnIndex;
    isAscending.value = ascending;
  }

  int compareString(bool ascending, String value1, String value2) {
    int comparison = value1.compareTo(value2);
    return ascending ? comparison : -comparison; // Reverse if descending
  }

  // this function is to filter the search results for web
  void filterCurrencies() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredCurrencies.clear();
    } else {
      filteredCurrencies.assignAll(
        allCurrencies.where((currency) {
          return currency.code.toString().toLowerCase().contains(query) ||
              currency.name.toString().toLowerCase().contains(query) ||
              currency.rate.toString().toLowerCase().contains(query) ||
              textToDate(
                currency.createdAt,
              ).toString().toLowerCase().contains(query);
        }).toList(),
      );
    }
  }
}
