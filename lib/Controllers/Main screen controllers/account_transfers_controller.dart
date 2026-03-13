import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/car trading/transfer_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import 'list_of_values_controller.dart';
import 'main_screen_contro.dart';

class AccountTransfersController extends GetxController {
  RxBool isScreenLoding = RxBool(false);
  RxBool addingNewTransfer = RxBool(false);
  RxBool addingNewTransferValue = RxBool(false);
  Rx<TextEditingController> transferDate = TextEditingController().obs;
  TextEditingController fromAccount = TextEditingController();
  TextEditingController fromAccountFilter = TextEditingController();
  RxString fromAccountId = RxString('');
  RxString fromAccountIdFilter = RxString('');
  TextEditingController toAccount = TextEditingController();
  TextEditingController toAccountFilter = TextEditingController();
  RxString toAccountId = RxString('');
  RxString toAccountIdFilter = RxString('');
  TextEditingController transferAmount = TextEditingController();
  TextEditingController commentsFilter = TextEditingController();
  Rx<TextEditingController> transferComments = TextEditingController().obs;
  final listOfValuesController = Get.put(ListOfValuesController());
  RxBool isTransfersLoading = RxBool(false);
  String backendUrl = backendTestURI;
  RxList<TransferModel> alltransfers = RxList<TransferModel>([]);
  Rx<TextEditingController> fromDate = TextEditingController().obs;
  Rx<TextEditingController> toDate = TextEditingController().obs;
  RxInt countOfTransfers = RxInt(0);
  // @override
  // void onInit() {
  //   super.onInit();
  // }

  Future<Map<String, dynamic>> getAllAccounts() async {
    return await helper.getAllBanksAndOthers();
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  Future<void> getAllTransferes() async {
    try {
      isTransfersLoading.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/account_transfers/get_all_transfers');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List transferes = decoded['transfers'];
        alltransfers.assignAll(
          transferes.map((tr) => TransferModel.fromJson(tr)),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllTransferes();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      isTransfersLoading.value = false;
    } catch (e) {
      isTransfersLoading.value = false;
    }
  }

  Future<void> addNewTransfer() async {
    try {
      if (fromAccountId.value.isEmpty || toAccountId.value.isEmpty) {
        alertMessage(
          context: Get.context!,
          content: 'Please add both accounts',
        );
        return;
      }
      addingNewTransferValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/account_transfers/add_new_transfer');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "date": convertDateToIson(transferDate.value.text),
          "from_account": fromAccountId.value,
          "to_account": toAccountId.value,
          "amount": double.tryParse(transferAmount.text) ?? 0.0,
          "comment": transferComments.value.text,
        }),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        TransferModel newTransfer = TransferModel.fromJson(decoded['transfer']);
        alltransfers.insert(0, newTransfer);
        countOfTransfers.value += 1;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewTransfer();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      Get.back();
      addingNewTransferValue.value = false;
    } catch (e) {
      addingNewTransferValue.value = false;
      Get.back();
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  Future<void> updateTransfer(String id) async {
    try {
      if (fromAccountId.value.isEmpty || toAccountId.value.isEmpty) {
        alertMessage(
          context: Get.context!,
          content: 'Please add both accounts',
        );
        return;
      }
      addingNewTransferValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/account_transfers/update_new_transfer/$id',
      );
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "date": convertDateToIson(transferDate.value.text),
          "from_account": fromAccountId.value,
          "to_account": toAccountId.value,
          "amount": double.tryParse(transferAmount.text) ?? 0.0,
          "comment": transferComments.value.text,
        }),
      );
      if (response.statusCode == 200) {
        int index = alltransfers.indexWhere((tr) => tr.id == id);
        alltransfers[index].amount = double.tryParse(transferAmount.text) ?? 0;
        alltransfers[index].fromAccount = fromAccountId.value;
        alltransfers[index].fromAccountName = fromAccount.text;
        alltransfers[index].toAccount = toAccountId.value;
        alltransfers[index].toAccountName = toAccount.text;
        alltransfers[index].comment = transferComments.value.text;
        alltransfers[index].date = textToDate(transferDate.value.text);
        alltransfers.refresh();
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await updateTransfer(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      Get.back();
      addingNewTransferValue.value = false;
    } catch (e) {
      addingNewTransferValue.value = false;
      Get.back();
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  Future<void> deleteTransfer(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/account_transfers/delete_transfer/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        alltransfers.removeWhere((tr) => tr.id == id);
        countOfTransfers.value -= 1;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteTransfer(id);
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

  void filterSearch() async {
    Map<String, dynamic> body = {};
    if (fromAccountIdFilter.value.isNotEmpty) {
      body["from_account"] = fromAccountIdFilter.value;
    }
    if (toAccountIdFilter.value.isNotEmpty) {
      body["to_account"] = toAccountIdFilter.value;
    }
    if (commentsFilter.text.isNotEmpty) {
      body["comment"] = commentsFilter.text;
    }

    if (fromDate.value.text.isNotEmpty) {
      body["from_date"] = convertDateToIson(fromDate.value.text);
    }
    if (toDate.value.text.isNotEmpty) {
      body["to_date"] = convertDateToIson(toDate.value.text);
    }
    if (body.isNotEmpty) {
      await searchEngine(body);
    } else {
      await searchEngine({"all": true});
    }
  }

  Future<void> searchEngine(Map<String, dynamic> body) async {
    try {
      isScreenLoding.value = true;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/account_transfers/search_engine_for_account_transfers',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List transfers = decoded['transfers'];
        int count = decoded['count'] ?? 0;
        countOfTransfers.value = count;
        alltransfers.assignAll(
          transfers.map((tr) => TransferModel.fromJson(tr)),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await searchEngine(body);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }

      isScreenLoding.value = false;
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  void clearAllFilters() {
    fromAccountFilter.clear();
    fromAccountIdFilter.value = '';
    toAccountFilter.clear();
    toAccountIdFilter.value = '';
    commentsFilter.clear();
    fromDate.value.clear();
    toDate.value.clear();
  }
}
