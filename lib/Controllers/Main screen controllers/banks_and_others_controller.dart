import 'dart:convert';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/banks/banks_model.dart';
import '../../helpers.dart';
import 'main_screen_contro.dart';
import 'websocket_controller.dart';

class BanksAndOthersController extends GetxController {
  Rx<TextEditingController> accountName = TextEditingController().obs;
  Rx<TextEditingController> accountNumber = TextEditingController().obs;
  Rx<TextEditingController> currency = TextEditingController().obs;
  // Rx<TextEditingController> currencyRate = TextEditingController().obs;
  Rx<TextEditingController> accountType = TextEditingController().obs;
  RxString currencyId = RxString('');
  RxString accountTypeId = RxString('');
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(false);
  final RxList<BanksModel> allBanks = RxList<BanksModel>([]);
  final RxList<BanksModel> filteredBanks = RxList<BanksModel>([]);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  RxString companyId = RxString('');
  // final RxMap<String, String> currencyNames = <String, String>{}.obs;
  RxMap allCurrencies = RxMap({});
  RxMap allAccountTypes = RxMap({});
  String backendUrl = backendTestURI;
  WebSocketService ws = Get.find<WebSocketService>();

  @override
  void onInit() async {
    connectWebSocket();
    getAllBanks();
    getCurrencies();
    getAccountTypes();
    super.onInit();
  }

  void connectWebSocket() {
    ws.events.listen((message) {
      switch (message["type"]) {
        case "bank_created":
          final newCounter = BanksModel.fromJson(message["data"]);
          allBanks.add(newCounter);
          break;

        case "bank_updated":
          final updated = BanksModel.fromJson(message["data"]);
          final index = allBanks.indexWhere((m) => m.id == updated.id);
          if (index != -1) {
            allBanks[index] = updated;
          }
          break;

        case "bank_deleted":
          final deletedId = message["data"]["_id"];
          allBanks.removeWhere((m) => m.id == deletedId);
          break;
      }
    });
  }

  Future<void> getAccountTypes() async {
    allAccountTypes.assignAll(await helper.getAllListValues('ACCOUNTS_TYPES'));
  }

  Future<void> getCurrencies() async {
    allCurrencies.assignAll(await helper.getCurrencies());
  }

  Future<void> getAllBanks() async {
    try {
      isScreenLoding.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/banks_and_others/get_all_banks');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List banks = decoded['banks'];
        allBanks.assignAll(banks.map((bank) => BanksModel.fromJson(bank)));
        isScreenLoding.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllBanks();
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

  Future<void> addNewBank() async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/banks_and_others/add_new_bank');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "account_name": accountName.value.text,
          "account_number": accountNumber.value.text,
          "currency_id": currencyId.value,
          "account_type_id": accountTypeId.value,
        }),
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewBank();
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

  Future<void> updateBank(String id) async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/banks_and_others/update_bank/$id');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "account_name": accountName.value.text,
          "account_number": accountNumber.value.text,
          "currency_id": currencyId.value,
          "account_type_id": accountTypeId.value,
        }),
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await updateBank(id);
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

  Future<void> deleteBank(String id) async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/banks_and_others/delete_bank/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteBank(id);
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

  // =======================================================================================

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allBanks.sort((bank1, bank2) {
        final String? value1 = bank1.accountName;
        final String? value2 = bank2.accountName;

        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allBanks.sort((bank1, bank2) {
        final String? value1 = bank1.accountNumber;
        final String? value2 = bank2.accountNumber;

        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 4) {
      allBanks.sort((bank1, bank2) {
        final String value1 = bank1.createdAt.toString();
        final String value2 = bank2.createdAt.toString();

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allBanks.sort((bank1, bank2) {
        final String value1 = bank1.currency.toString().toLowerCase();
        final String value2 = bank2.currency.toString().toLowerCase();
        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 3) {
      allBanks.sort((bank1, bank2) {
        final String value1 = bank1.accountTypeName.toString().toLowerCase();
        final String value2 = bank2.accountTypeName.toString().toLowerCase();
        return compareString(ascending, value1, value2);
      });
    }

    sortColumnIndex.value = columnIndex;
    isAscending.value = ascending;
  }

  int compareString(bool ascending, String value1, String value2) {
    int comparison = value1.compareTo(value2);
    return ascending ? comparison : -comparison;
  }

  void clearValues() {
    accountName.value.clear();
    accountNumber.value.clear();
    currency.value.clear();
    accountType.value.clear();
    currencyId.value = '';
    accountTypeId.value = '';
  }

  void loadValues(BanksModel data) {
    accountName.value.text = data.accountName ?? '';
    accountNumber.value.text = data.accountNumber ?? '';
    currency.value.text = data.currency ?? '';
    currencyId.value = data.currencyId ?? '';
    accountType.value.text = data.accountTypeName ?? '';
    accountTypeId.value = data.accountTypeId ?? '';
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  // this function is to filter the search results for web
  void filterBanks() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredBanks.clear();
    } else {
      filteredBanks.assignAll(
        allBanks.where((bank) {
          return bank.accountName.toString().toLowerCase().contains(query) ||
              bank.accountNumber.toString().toLowerCase().contains(query) ||
              bank.currency.toString().toLowerCase().contains(query) ||
              bank.accountTypeName.toString().toLowerCase().contains(query) ||
              bank.rate.toString().toLowerCase().contains(query) ||
              bank.countryName.toString().toLowerCase().contains(query) ||
              textToDate(
                bank.createdAt,
              ).toString().toLowerCase().contains(query);
        }).toList(),
      );
    }
  }
}
