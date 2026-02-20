import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../Models/inventory items/inventory_items_model.dart';
import '../../Models/receiving/receiving_items_model.dart';
import '../../Models/receiving/receiving_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import 'list_of_values_controller.dart';
import 'main_screen_contro.dart';

class ReceivingController extends GetxController {
  Rx<TextEditingController> receivingNumber = TextEditingController().obs;
  Rx<TextEditingController> referenceNumber = TextEditingController().obs;
  Rx<TextEditingController> date = TextEditingController().obs;
  Rx<TextEditingController> branch = TextEditingController().obs;
  Rx<TextEditingController> vendor = TextEditingController().obs;
  Rx<TextEditingController> note = TextEditingController().obs;
  Rx<TextEditingController> currency = TextEditingController().obs;
  Rx<TextEditingController> rate = TextEditingController().obs;
  Rx<TextEditingController> approvedBy = TextEditingController().obs;
  Rx<TextEditingController> orderedBy = TextEditingController().obs;
  Rx<TextEditingController> purchasedBy = TextEditingController().obs;
  Rx<TextEditingController> shipping = TextEditingController().obs;
  Rx<TextEditingController> handling = TextEditingController().obs;
  Rx<TextEditingController> other = TextEditingController().obs;
  Rx<TextEditingController> amount = TextEditingController().obs;
  Rx<TextEditingController> itemCode = TextEditingController().obs;
  Rx<TextEditingController> itemName = TextEditingController().obs;
  Rx<TextEditingController> quantity = TextEditingController().obs;
  Rx<TextEditingController> addCost = TextEditingController().obs;
  Rx<TextEditingController> orginalPrice = TextEditingController().obs;
  Rx<TextEditingController> addDisc = TextEditingController().obs;
  Rx<TextEditingController> discount = TextEditingController().obs;
  Rx<TextEditingController> localPrice = TextEditingController().obs;
  Rx<TextEditingController> vat = TextEditingController().obs;
  Rx<TextEditingController> total = TextEditingController().obs;
  Rx<TextEditingController> net = TextEditingController().obs;
  Rx<TextEditingController> inventoryCodeFilter = TextEditingController().obs;
  Rx<TextEditingController> inventoryNameFilter = TextEditingController().obs;
  Rx<TextEditingController> inventoryMinQuantityFilter =
      TextEditingController().obs;
  RxString branchId = RxString('');
  RxString vendorId = RxString('');
  RxString currencyId = RxString('');
  RxString approvedById = RxString('');
  RxString orderedById = RxString('');
  RxString purchasedById = RxString('');
  ListOfValuesController listOfValuesController = Get.put(
    ListOfValuesController(),
  );
  RxString status = RxString('');
  Rx<TextEditingController> receivingNumberFilter = TextEditingController().obs;
  Rx<TextEditingController> referenceNumberFilter = TextEditingController().obs;
  Rx<TextEditingController> vendorNameIdFilterName =
      TextEditingController().obs;
  Rx<TextEditingController> statusFilter = TextEditingController().obs;
  RxString vendorNameIdFilter = RxString('');
  Rx<TextEditingController> fromDate = TextEditingController().obs;
  Rx<TextEditingController> toDate = TextEditingController().obs;
  final ScrollController scrollControllerFotTable1 = ScrollController();
  RxBool isTodaySelected = RxBool(false);
  RxBool isAllSelected = RxBool(false);
  RxBool isThisMonthSelected = RxBool(false);
  RxBool isThisYearSelected = RxBool(false);
  RxBool isYearSelected = RxBool(false);
  RxBool isMonthSelected = RxBool(false);
  RxBool isDaySelected = RxBool(false);
  RxInt numberOfReceivingDocs = RxInt(0);
  RxDouble allReceivingVATS = RxDouble(0.0);
  RxDouble allReceivingTotals = RxDouble(0.0);
  RxDouble allReceivingNET = RxDouble(0.0);
  RxBool isScreenLoding = RxBool(false);
  final RxList<ReceivingModel> allReceivingDocs = RxList<ReceivingModel>([]);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxString curreentReceivingId = RxString('');
  RxBool loadingItems = RxBool(false);
  RxList<ReceivingItemsModel> allReceivingItems = RxList<ReceivingItemsModel>();

  // RxBool addingNewItemsValue = RxBool(false);
  RxBool addingNewValue = RxBool(false);
  RxBool receivingDocAdded = RxBool(false);
  RxBool loadingInventeryItems = RxBool(false);
  final RxList<InventoryItemsModel> allInventeryItems =
      RxList<InventoryItemsModel>([]);

  RxString selectedInventeryItemID = RxString('');
  RxString query = RxString('');
  RxDouble itemsTotal = RxDouble(0.0);
  RxDouble finalItemsTotal = RxDouble(0.0);
  RxDouble finalItemsVAT = RxDouble(0.0);
  RxDouble finalItemsNet = RxDouble(0.0);
  String backendUrl = backendTestURI;
  final Uuid _uuid = const Uuid();
  RxBool isReceivingModified = RxBool(false);
  RxBool isReceivingItemsModified = RxBool(false);
  RxInt initValueForDatePickker = RxInt(1);
  RxMap companyDetails = RxMap({});

  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();
  final FocusNode focusNode5 = FocusNode();
  final FocusNode focusNode6 = FocusNode();
  final FocusNode focusNode7 = FocusNode();
  final FocusNode focusNode8 = FocusNode();
  final FocusNode focusNode9 = FocusNode();
  final FocusNode focusNode10 = FocusNode();
  final FocusNode focusNode11 = FocusNode();
  final FocusNode focusNode12 = FocusNode();
  final FocusNode focusNode13 = FocusNode();
  final FocusNode focusNode14 = FocusNode();

  @override
  void onInit() async {
    getCompanyDetails();
    // filterSearch();
    super.onInit();
  }

  @override
  void onClose() {
    allInventeryItems.clear();
    allReceivingDocs.clear();
    super.onClose();
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  Future<Map<String, dynamic>> getAllBranches() async {
    return await helper.getBrunches();
  }

  Future<Map<String, dynamic>> getAllVendors() async {
    return await helper.getVendors();
  }

  Future<Map<String, dynamic>> getCurrencies() async {
    return await helper.getCurrencies();
  }

  Future<Map<String, dynamic>> getISSUERECEIVEPEOPLE() async {
    return await helper.getAllListValues('ISSUE_RECEIVE_PEOPLE');
  }

  Future getCurrentReceivingStatus(String id) async {
    return await helper.getReceivingStatus(id);
  }

  Future<void> getCompanyDetails() async {
    companyDetails.assignAll(await helper.getCurrentCompanyDetails());
  }

  void onChooseForDatePicker(int i) {
    switch (i) {
      case 1:
        initValueForDatePickker.value = 1;
        isTodaySelected.value = false;
        isThisMonthSelected.value = false;
        isThisYearSelected.value = false;
        fromDate.value.clear();
        toDate.value.clear();
        filterSearch();
        break;
      case 2:
        initValueForDatePickker.value = 2;
        setTodayRange(fromDate: fromDate.value, toDate: toDate.value);
        isAllSelected.value = false;
        isTodaySelected.value = true;
        isThisMonthSelected.value = false;
        isThisYearSelected.value = false;
        isYearSelected.value = false;
        isMonthSelected.value = false;
        isDaySelected.value = true;
        filterSearch();
        break;
      case 3:
        initValueForDatePickker.value = 3;
        setThisMonthRange(fromDate: fromDate.value, toDate: toDate.value);
        isAllSelected.value = false;
        isTodaySelected.value = false;
        isThisMonthSelected.value = true;
        isThisYearSelected.value = false;
        isYearSelected.value = false;
        isMonthSelected.value = true;
        isDaySelected.value = false;
        filterSearch();
        break;
      case 4:
        initValueForDatePickker.value = 4;
        setThisYearRange(fromDate: fromDate.value, toDate: toDate.value);
        isTodaySelected.value = false;
        isThisMonthSelected.value = false;
        isThisYearSelected.value = true;
        isYearSelected.value = true;
        isMonthSelected.value = false;
        isDaySelected.value = false;
        filterSearch();
        break;
      default:
    }
  }

  void filterSearchFirInventoryItems() async {
    Map<String, dynamic> body = {};
    if (inventoryCodeFilter.value.text.isNotEmpty) {
      body["code"] = inventoryCodeFilter.value.text;
    }
    if (inventoryNameFilter.value.text.isNotEmpty) {
      body["name"] = inventoryNameFilter.value.text;
    }
    if (inventoryMinQuantityFilter.value.text.isNotEmpty) {
      body["min_quantity"] = inventoryMinQuantityFilter.value.text;
    }

    if (body.isNotEmpty) {
      await searchEngineForInventoryItems(body);
    } else {
      await searchEngineForInventoryItems({});
    }
  }

  Future<void> searchEngineForInventoryItems(Map<String, dynamic> body) async {
    try {
      loadingInventeryItems.value = true;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/inventory_items/search_engine_for_inventory_items',
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
        List items = decoded['inventory_items'];
        allInventeryItems.assignAll(
          items.map((job) => InventoryItemsModel.fromJson(job)),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await searchEngineForInventoryItems(body);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }

      loadingInventeryItems.value = false;
    } catch (e) {
      loadingInventeryItems.value = false;
    }
  }
  // Future<void> getAllInventeryItems() async {
  //   try {
  //     loadingInventeryItems.value = true;
  //     final SharedPreferences prefs = await SharedPreferences.getInstance();
  //     var accessToken = '${prefs.getString('accessToken')}';
  //     final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
  //     Uri url = Uri.parse(
  //       '$backendUrl/inventory_items/get_all_inventory_items',
  //     );
  //     final response = await http.get(
  //       url,
  //       headers: {'Authorization': 'Bearer $accessToken'},
  //     );
  //     if (response.statusCode == 200) {
  //       final decoded = jsonDecode(response.body);
  //       List items = decoded['inventory_items'];
  //       allInventeryItems.assignAll(
  //         items.map((item) => InventoryItemsModel.fromJson(item)),
  //       );
  //       loadingInventeryItems.value = false;
  //     } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
  //       final refreshed = await helper.refreshAccessToken(refreshToken);
  //       if (refreshed == RefreshResult.success) {
  //         await getAllInventeryItems();
  //       } else if (refreshed == RefreshResult.invalidToken) {
  //         logout();
  //       }
  //     } else if (response.statusCode == 401) {
  //       loadingInventeryItems.value = false;
  //       logout();
  //     } else {
  //       loadingInventeryItems.value = false;
  //     }
  //   } catch (e) {
  //     loadingInventeryItems.value = false;
  //   }
  // }

  Future<void> addNewReceivingDoc() async {
    try {
      if (curreentReceivingId.isNotEmpty) {
        Map jobStatus = await getCurrentReceivingStatus(
          curreentReceivingId.value,
        );

        String status1 = jobStatus['status'];
        if (status1 != 'New' && status1 != '') {
          alertMessage(
            context: Get.context!,
            content: 'Only new receiving docs can be edited',
          );
          return;
        }
      }
      addingNewValue.value = true;
      final Map<String, dynamic> newData = {
        'branch': branchId.value,
        'reference_number': referenceNumber.value.text.trim(),
        'vendor': vendorId.value,
        'note': note.value.text.trim(),
        'currency': currencyId.value,
        'rate': double.tryParse(rate.value.text) ?? 1,
        'approved_by': approvedById.value,
        'ordered_by': orderedById.value,
        'purchased_by': purchasedById.value,
        'shipping': double.tryParse(shipping.value.text) ?? 0,
        'handling': double.tryParse(handling.value.text) ?? 0,
        'other': double.tryParse(other.value.text) ?? 0,
        'amount': double.tryParse(amount.value.text) ?? 0,
        'status': status.value,
        'items': allReceivingItems
            .where((inv) => inv.isDeleted != true)
            .map((item) => item.toJson())
            .toList(),
      };

      // Handle date parsing safely
      final rawDate = date.value.text.trim();
      if (rawDate.isNotEmpty) {
        try {
          newData['date'] = convertDateToIson(rawDate);
        } catch (e) {
          alertMessage(
            context: Get.context!,
            content: 'Please enter a valid date',
          );
          addingNewValue.value = false;
          return;
        }
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri addingRecUrl = Uri.parse('$backendUrl/receiving/add_new_receiving');

      if (curreentReceivingId.isEmpty) {
        newData['status'] = 'New';
        final response = await http.post(
          addingRecUrl,
          headers: {
            'Authorization': 'Bearer $accessToken',
            "Content-Type": "application/json",
          },
          body: jsonEncode(newData),
        );
        if (response.statusCode == 200) {
          status.value = 'New';
          final decoded = jsonDecode(response.body);
          ReceivingModel newRec = ReceivingModel.fromJson(decoded['receiving']);
          receivingNumber.value.text = newRec.receivingNumber ?? '';
          addingNewValue.value = false;
          curreentReceivingId.value = newRec.id ?? '';
          allReceivingItems.value = newRec.itemsDetails ?? [];
          isReceivingItemsModified.value = false;
          isReceivingModified.value = false;
          calculateTotalsForSelectedReceive();
          allReceivingDocs.insert(0, newRec);
        } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
          final refreshed = await helper.refreshAccessToken(refreshToken);
          if (refreshed == RefreshResult.success) {
            await addNewReceivingDoc();
          } else if (refreshed == RefreshResult.invalidToken) {
            logout();
          }
        } else if (response.statusCode == 401) {
          logout();
        }
      } else {
        if (isReceivingItemsModified.isTrue || isReceivingModified.isTrue) {
          http.Response? responseForEditingReceving;
          http.Response? responseForEditingRececingItems;

          if (isReceivingModified.isTrue) {
            Uri updatingJobUrl = Uri.parse(
              '$backendUrl/receiving/update_receiving/${curreentReceivingId.value}',
            );
            Map newDataToUpdate = newData;
            newDataToUpdate.remove('items');
            responseForEditingReceving = await http.patch(
              updatingJobUrl,
              headers: {
                'Authorization': 'Bearer $accessToken',
                "Content-Type": "application/json",
              },
              body: jsonEncode(newDataToUpdate),
            );
            if (responseForEditingReceving.statusCode == 200) {
              final decoded = jsonDecode(responseForEditingReceving.body);
              ReceivingModel newRec = ReceivingModel.fromJson(
                decoded['receiving'],
              );
              curreentReceivingId.value = newRec.id ?? '';
              allReceivingItems.value = newRec.itemsDetails ?? [];
              isReceivingModified.value = false;
              calculateTotalsForSelectedReceive();
            } else if (responseForEditingReceving.statusCode == 401 &&
                refreshToken.isNotEmpty) {
              final refreshed = await helper.refreshAccessToken(refreshToken);
              if (refreshed == RefreshResult.success) {
                await addNewReceivingDoc();
              } else if (refreshed == RefreshResult.invalidToken) {
                logout();
              }
            } else if (responseForEditingReceving.statusCode == 401) {
              logout();
            }
          }
          if (isReceivingItemsModified.isTrue) {
            Uri updatingJobInvoicesUrl = Uri.parse(
              '$backendUrl/receiving/update_receiving_items',
            );
            responseForEditingRececingItems = await http.patch(
              updatingJobInvoicesUrl,
              headers: {
                'Authorization': 'Bearer $accessToken',
                "Content-Type": "application/json",
              },
              body: jsonEncode(
                allReceivingItems
                    .where(
                      (item) =>
                          (item.isModified == true ||
                          item.isAdded == true ||
                          (item.isDeleted == true && item.id != null)),
                    )
                    .map((item) => item.toJson())
                    .toList(),
              ),
            );
            if (responseForEditingRececingItems.statusCode == 200) {
              final decoded = jsonDecode(responseForEditingRececingItems.body);
              List updatedItems = decoded['updated_items']['items_details'];
              if (updatedItems.isNotEmpty) {
                allReceivingItems.assignAll(
                  updatedItems.map(
                    (item) => ReceivingItemsModel.fromJson(item),
                  ),
                );
              }
              isReceivingItemsModified.value = false;
              calculateTotalsForSelectedReceive();
            } else if (responseForEditingRececingItems.statusCode == 401 &&
                refreshToken.isNotEmpty) {
              final refreshed = await helper.refreshAccessToken(refreshToken);
              if (refreshed == RefreshResult.success) {
                await addNewReceivingDoc();
              } else if (refreshed == RefreshResult.invalidToken) {
                logout();
              }
            } else if (responseForEditingRececingItems.statusCode == 401) {
              logout();
            }
          }
          // if ((responseForEditingReceving?.statusCode == 200) ||
          //     (responseForEditingRececingItems?.statusCode == 200)) {
          // }
        }
      }
      addingNewValue.value = false; // Ensure loading flag is reset
    } catch (e) {
      alertMessage(context: Get.context!, content: 'Something went wrong');
      addingNewValue.value = false; // Ensure loading flag is reset
    }
  }

  void filterSearch() async {
    Map<String, dynamic> body = {};
    if (receivingNumberFilter.value.text.isNotEmpty) {
      body["receiving_number"] = receivingNumberFilter.value.text;
    }
    if (referenceNumberFilter.value.text.isNotEmpty) {
      body["reference_number"] = referenceNumberFilter.value.text;
    }
    if (vendorNameIdFilter.value.isNotEmpty) {
      body["vendor"] = vendorNameIdFilter.value;
    }

    if (statusFilter.value.text.isNotEmpty) {
      body["status"] = statusFilter.value.text;
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
      Uri url = Uri.parse('$backendUrl/receiving/search_engine_for_receiving');
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
        List receiving = decoded['receiving'];
        Map grandTotals = decoded['grand_totals'];
        allReceivingTotals.value = grandTotals['total_amount'];
        allReceivingVATS.value = grandTotals['vat_amount'];
        allReceivingNET.value = grandTotals['net_amount'];
        numberOfReceivingDocs.value = grandTotals['total_items_count'];
        allReceivingDocs.assignAll(
          receiving.map((rec) => ReceivingModel.fromJson(rec)),
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

  Future<void> deleteReceiving(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/receiving/delete_receiving/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        String deletedReceivingId = decoded['receiving_id'];
        allReceivingDocs.removeWhere((rec) => rec.id == deletedReceivingId);
        numberOfReceivingDocs.value -= 1;
        Get.close(2);
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        final decoded =
            jsonDecode(response.body) ?? 'Failed to delete receiving';
        String error = decoded['detail'];
        alertMessage(context: Get.context!, content: error);
      } else if (response.statusCode == 403) {
        final decoded = jsonDecode(response.body);
        String error = decoded['detail'] ?? 'Only New Receiving Allowed';
        alertMessage(context: Get.context!, content: error);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteReceiving(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 500) {
        final decoded = jsonDecode(response.body);
        final error =
            decoded['detail'] ?? 'Server error while deleting receiving';
        alertMessage(context: Get.context!, content: error);
      } else if (response.statusCode == 401) {
        logout();
      }
    } catch (e) {
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  Future<void> addNewItem() async {
    final String uniqueId = _uuid.v4();
    allReceivingItems.add(
      ReceivingItemsModel(
        receivingId: curreentReceivingId.value.isEmpty
            ? null
            : curreentReceivingId.value,
        uuid: uniqueId,
        inventoryItemId: selectedInventeryItemID.value,
        itemName: itemName.value.text,
        itemCode: itemCode.value.text,
        quantity: double.tryParse(quantity.value.text) ?? 1,
        originalPrice: double.tryParse(orginalPrice.value.text) ?? 0,
        discount: double.tryParse(discount.value.text) ?? 0,
        vat: double.tryParse(vat.value.text) ?? 0,
        isAdded: true,
      ),
    );
    isReceivingItemsModified.value = true;
    calculateTotalsForSelectedReceive();
    Get.back();
  }

  Future<void> editItem(String itemId) async {
    int index = allReceivingItems.indexWhere(
      (item) => (item.id == itemId || item.uuid == itemId),
    );
    if (index != -1) {
      final oldItem = allReceivingItems[index];
      isReceivingItemsModified.value = true;

      allReceivingItems[index] = ReceivingItemsModel(
        receivingId: oldItem.receivingId,
        id: oldItem.id,
        uuid: oldItem.uuid,
        addCost: oldItem.addCost,
        addDisc: oldItem.addDisc,
        localPrice: oldItem.localPrice,
        total: oldItem.total,
        net: oldItem.net,
        inventoryItemId: selectedInventeryItemID.value,
        itemName: itemName.value.text,
        itemCode: itemCode.value.text,
        quantity: double.tryParse(quantity.value.text) ?? 1,
        originalPrice: double.tryParse(orginalPrice.value.text) ?? 0,
        discount: double.tryParse(discount.value.text) ?? 0,
        vat: double.tryParse(vat.value.text) ?? 0,
        isModified: true,
      );
    }
    calculateTotalsForSelectedReceive();

    Get.back();
  }

  Future<void> deleteItem(String itemId) async {
    int index = allReceivingItems.indexWhere(
      (item) => (item.id == itemId || item.uuid == itemId),
    );
    allReceivingItems[index].isDeleted = true;
    allReceivingItems.refresh();
    isReceivingItemsModified.value = true;
    calculateTotalsForSelectedReceive();

    Get.back();
  }

  // =============================================================================================================
  void clearValues() {
    currencyId.value = companyDetails.containsKey('currency_id')
        ? companyDetails['currency_id'] ?? ""
        : "";
    rate.value.text = companyDetails.containsKey('currency_rate')
        ? companyDetails['currency_rate'].toString()
        : "";
    currency.value.text = companyDetails.containsKey('currency_code')
        ? companyDetails['currency_code'] ?? ""
        : "";
    receivingNumber.value.clear();
    date.value.text = textToDate(DateTime.now());
    branch.value.text = companyDetails['current_user_branch_name'] ?? '';
    branchId.value = companyDetails['current_user_branch_id'] ?? '';
    referenceNumber.value.clear();
    vendor.value.clear();
    vendorId.value = '';
    note.value.clear();
    curreentReceivingId.value = '';
    approvedBy.value.clear();
    orderedBy.value.clear();
    purchasedBy.value.clear();
    approvedById.value = '';
    orderedById.value = '';
    purchasedById.value = '';
    shipping.value.text = '0';
    handling.value.text = '0';
    other.value.text = '0';
    amount.value.text = '0';
    allReceivingItems.clear();
    status.value = '';
    receivingDocAdded.value = false;
    isReceivingItemsModified.value = false;
    isReceivingModified.value = false;
    finalItemsNet.value = 0;
    finalItemsTotal.value = 0;
    finalItemsVAT.value = 0;
  }

  void loadValues(ReceivingModel data) {
    isReceivingItemsModified.value = false;
    isReceivingModified.value = false;
    curreentReceivingId.value = data.id ?? '';
    // allReceivingItems.assignAll(data.itemsDetails ?? []);
    allReceivingItems.assignAll(
      (data.itemsDetails ?? []).map((e) => e.copyJson()).toList(),
    );

    status.value = data.status ?? '';
    receivingNumber.value.text = data.receivingNumber ?? '';
    date.value.text = textToDate(data.date);
    branch.value.text = data.branchName ?? '';
    branchId.value = data.branch ?? '';
    referenceNumber.value.text = data.referenceNumber ?? '';
    vendor.value.text = data.vendorName ?? '';
    vendorId.value = data.vendor ?? '';
    note.value.text = data.note ?? '';
    currencyId.value = data.currency ?? '';
    currency.value.text = data.currencyCode ?? '';
    rate.value.text = data.rate.toString();
    approvedBy.value.text = data.approvedByName ?? '';
    orderedBy.value.text = data.orderedByName ?? '';
    purchasedBy.value.text = data.purchasedByName ?? '';
    approvedById.value = data.approvedBy ?? '';
    orderedById.value = data.orderedBy ?? '';
    purchasedById.value = data.purchasedBy ?? '';
    shipping.value.text = data.shipping.toString();
    handling.value.text = data.handling.toString();
    other.value.text = data.other.toString();
    amount.value.text = data.amount.toString();
    calculateTotalsForSelectedReceive();
  }

  // this function is to filter the search results for inventery items

  void calculateTotalsForSelectedReceive() {
    finalItemsTotal.value = 0;
    finalItemsVAT.value = 0;
    finalItemsNet.value = 0;
    for (var item in allReceivingItems.where(
      (item) => item.isDeleted != true,
    )) {
      finalItemsTotal.value += item.total ?? 0;
      finalItemsVAT.value += item.vat ?? 0;
      finalItemsNet.value += item.net ?? 0;
    }
  }

  void clearItemsValues() {
    itemCode.value.clear();
    itemName.value.clear();
    selectedInventeryItemID.value = '';
    quantity.value.text = '1';
    addCost.value.text = '0';
    orginalPrice.value.text = '';
    addDisc.value.text = '0';
    discount.value.text = '';
    localPrice.value.text = '0';
    vat.value.text = '';
    total.value.text = '0';
    net.value.text = '0';
  }

  Future<void> editPostForReceiving(String id) async {
    if (status.value.isEmpty) {
      alertMessage(context: Get.context!, content: 'Please save doc first');
      return;
    }
    Map recStatus = await getCurrentReceivingStatus(curreentReceivingId.value);

    String status1 = recStatus['status'];

    if (status1 == 'Posted') {
      alertMessage(context: Get.context!, content: 'Doc is already posted');
      return;
    }
    if (status1 == 'Cancelled') {
      alertMessage(context: Get.context!, content: 'Doc is cancelled');
      return;
    }

    status.value = 'Posted';
    isReceivingModified.value = true;
    addNewReceivingDoc();
  }

  Future<void> editCancelForReceiving(String id) async {
    if (status.value.isEmpty) {
      alertMessage(context: Get.context!, content: 'Please save doc first');
      return;
    }
    Map recStatus = await getCurrentReceivingStatus(curreentReceivingId.value);

    String status1 = recStatus['status'];

    if (status1 == 'Posted') {
      alertMessage(context: Get.context!, content: 'Doc is posted');
      return;
    }

    if (status1 == 'Cancelled') {
      alertMessage(context: Get.context!, content: 'Doc is already cancelled');
      return;
    }

    status.value = 'Cancelled';
    isReceivingModified.value = true;
    addNewReceivingDoc();
  }

  void removeFilters() {
    isAllSelected.value = false;
    isTodaySelected.value = false;
    isThisMonthSelected.value = false;
    isThisYearSelected.value = false;
  }

  void clearAllFilters() {
    initValueForDatePickker.value = 1;
    statusFilter.value.clear();
    allReceivingDocs.clear();
    numberOfReceivingDocs.value = 0;
    allReceivingTotals.value = 0;
    allReceivingVATS.value = 0;
    allReceivingNET.value = 0;
    isAllSelected.value = false;
    isTodaySelected.value = false;
    isThisMonthSelected.value = false;
    isThisYearSelected.value = false;
    receivingNumberFilter.value.clear();
    referenceNumberFilter.value.clear();
    vendorNameIdFilter = RxString('');
    vendorNameIdFilterName.value = TextEditingController();
    fromDate.value.clear();
    toDate.value.clear();
    isScreenLoding.value = false;
  }
}
