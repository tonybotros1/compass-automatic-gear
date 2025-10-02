import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/invoice items/invoice_items_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import 'main_screen_contro.dart';
import 'websocket_controller.dart';

class InvoiceItemsController extends GetxController {
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(false);
  final RxList<InvoiceItemsModel> allInvoiceItems = RxList<InvoiceItemsModel>(
    [],
  );
  final RxList<InvoiceItemsModel> filteredInvoiceItems =
      RxList<InvoiceItemsModel>([]);
  RxString companyId = RxString('');
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  String backendUrl = backendTestURI;
  WebSocketService ws = Get.find<WebSocketService>();

  @override
  void onInit() {
    connectWebSocket();
    getAllInvoiceItems();
    super.onInit();
  }

  @override
  void onClose() {
    name.dispose();
    description.dispose();
    price.dispose();
    search.value.dispose();
    super.onClose();
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  void connectWebSocket() {
    ws.events.listen((message) {
      switch (message["type"]) {
        case "invoice_item_added":
          final newCounter = InvoiceItemsModel.fromJson(message["data"]);
          allInvoiceItems.add(newCounter);
          break;

        case "invoice_item_updated":
          final updated = InvoiceItemsModel.fromJson(message["data"]);
          final index = allInvoiceItems.indexWhere((m) => m.id == updated.id);
          if (index != -1) {
            allInvoiceItems[index] = updated;
          }
          break;

        case "invoice_item_deleted":
          final deletedId = message["data"]["_id"];
          allInvoiceItems.removeWhere((m) => m.id == deletedId);
          break;
      }
    });
  }

  Future<void> getAllInvoiceItems() async {
    try {
      isScreenLoding.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/invoice_items/get_all_invoice_items');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List invoices = decoded['invoice_items'];
        allInvoiceItems.assignAll(
          invoices.map((invoice) => InvoiceItemsModel.fromJson(invoice)),
        );
        isScreenLoding.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllInvoiceItems();
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

  Future<void> addNewInvoiceItem() async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/invoice_items/add_new_invoice_item');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name.text,
          "description": description.text,
          "price": double.tryParse(price.text) ?? 0,
        }),
      );
      if (response.statusCode == 200) {
        addingNewValue.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewInvoiceItem();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        addingNewValue.value = false;
      }
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  Future<void> updateInvoiceItem(String id) async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/invoice_items/update_invoice_item/$id');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name.text,
          "description": description.text,
          "price": double.tryParse(price.text) ?? 0,
        }),
      );
      if (response.statusCode == 200) {
        addingNewValue.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await updateInvoiceItem(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        addingNewValue.value = false;
      }
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  Future<void> deleteInvoiceItem(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/invoice_items/delete_invoice_item/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteInvoiceItem(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      Get.back();
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  // ============================================================================================

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allInvoiceItems.sort((counter1, counter2) {
        final String? value1 = counter1.name;
        final String? value2 = counter2.name;

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allInvoiceItems.sort((counter1, counter2) {
        final String? value1 = counter1.description;
        final String? value2 = counter2.description;

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allInvoiceItems.sort((counter1, counter2) {
        final String value1 = counter1.price.toString();
        final String value2 = counter2.price.toString();

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 3) {
      allInvoiceItems.sort((counter1, counter2) {
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
  void filterInvoiceItems() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredInvoiceItems.clear();
    } else {
      filteredInvoiceItems.assignAll(
        allInvoiceItems.where((saleman) {
          return saleman.description.toString().toLowerCase().contains(query) ||
              saleman.name.toString().toLowerCase().contains(query) ||
              saleman.price.toString().toLowerCase().contains(query) ||
              textToDate(
                saleman.createdAt,
              ).toString().toLowerCase().contains(query);
        }).toList(),
      );
    }
  }
}
