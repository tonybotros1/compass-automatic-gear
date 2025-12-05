import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datahubai/Models/converters/converter_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../../Models/issuing/base_model_for_issing_items.dart';
import '../../Models/issuing/issung_model.dart';
import '../../Models/job cards/job_card_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import 'main_screen_contro.dart';

class IssueItemsController extends GetxController {
  Rx<TextEditingController> date = TextEditingController().obs;
  Rx<TextEditingController> branch = TextEditingController().obs;
  Rx<TextEditingController> note = TextEditingController().obs;
  Rx<TextEditingController> issueNumber = TextEditingController().obs;
  RxString issueType = RxString('');
  // Rx<TextEditingController> issueType = TextEditingController().obs;
  RxString branchId = RxString('');
  RxString issueTypeId = RxString('');
  RxString receivedById = RxString('');

  Rx<TextEditingController> receivedBy = TextEditingController().obs;
  Rx<TextEditingController> issueNumberFilter = TextEditingController().obs;
  Rx<TextEditingController> jobConverterFilter = TextEditingController().obs;
  Rx<TextEditingController> receivedByFilter = TextEditingController().obs;
  Rx<TextEditingController> statusFilter = TextEditingController().obs;
  RxString jobConverterIdFilter = RxString('');
  RxString receivedByIdFilter = RxString('');
  RxString status = RxString(''); // change to empty
  Rx<TextEditingController> fromDate = TextEditingController().obs;
  Rx<TextEditingController> toDate = TextEditingController().obs;
  RxBool isTodaySelected = RxBool(false);
  RxBool isAllSelected = RxBool(false);
  RxBool isThisMonthSelected = RxBool(false);
  RxBool isThisYearSelected = RxBool(false);
  RxBool isYearSelected = RxBool(false);
  RxBool isMonthSelected = RxBool(false);
  RxBool isDaySelected = RxBool(false);
  RxInt numberOfIssuesgDocs = RxInt(0);
  RxDouble allIssuesVATS = RxDouble(0.0);
  RxDouble allIssuesTotals = RxDouble(0.0);
  RxDouble allIssuesNET = RxDouble(0.0);
  RxBool isScreenLoding = RxBool(false);
  final RxList<IssuingModel> allIssuesDocs = RxList<IssuingModel>([]);
  final ScrollController scrollControllerFotTable1 = ScrollController();
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  RxBool postingReceivingDoc = RxBool(false);
  RxBool deletingReceivingDoc = RxBool(false);
  RxBool cancellingReceivingDoc = RxBool(false);
  RxMap alljobConverters = RxMap({});
  RxMap allReceivedBy = RxMap({});
  RxMap allBranches = RxMap({});
  RxMap allIssueTypes = RxMap({});
  RxMap allBrands = RxMap({});
  // RxMap allTechs = RxMap({});
  RxMap allCustomers = RxMap({});

  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();
  final FocusNode focusNode5 = FocusNode();
  // RxString companyId = RxString('slowXdVvhLdsVQItgO3n');
  RxBool loadingJobCards = RxBool(false);
  RxBool loadingConverters = RxBool(false);
  final RxList<BaseModelForIssuingItems> allInventeryItems =
      RxList<BaseModelForIssuingItems>([]);
  final RxList<BaseModelForIssuingItems> filteredInventeryItems =
      RxList<BaseModelForIssuingItems>([]);
  final RxList<BaseModelForIssuingItems> selectedInventeryItems =
      RxList<BaseModelForIssuingItems>([]);
  final RxList<BaseModelForIssuingItems> selectedConvertersDetails =
      RxList<BaseModelForIssuingItems>([]);
  final RxList<BaseModelForIssuingItems> allConvertersDetails =
      RxList<BaseModelForIssuingItems>([]);
  final RxList<BaseModelForIssuingItems> filteredConvertersDetails =
      RxList<BaseModelForIssuingItems>([]);
  RxList<JobCardModel> allJobCards = RxList<JobCardModel>([]);
  final RxList<JobCardModel> filteredJobCards = RxList<JobCardModel>([]);
  TextEditingController searchForJobCards = TextEditingController();
  TextEditingController searchForConverters = TextEditingController();
  RxString jobQuery = RxString('');
  RxString converterQuery = RxString('');
  RxString converterDetailsQuery = RxString('');
  RxString inventoryQuery = RxString('');
  TextEditingController jobDetails = TextEditingController();
  final RxList<ConverterModel> allConverters = RxList<ConverterModel>([]);
  final RxList<ConverterModel> filteredConverters = RxList<ConverterModel>([]);
  final RxList<QueryDocumentSnapshot<Map<String, dynamic>>> allConvertersTable =
      RxList([]);
  RxBool loadingItemsTable = RxBool(false);
  TextEditingController searchForInventoryItems = TextEditingController();
  TextEditingController searchForConvertersDetails = TextEditingController();
  String backendUrl = backendTestURI;
  RxString currentIssuingId = RxString('');
  var editingIndexForInventoryDetails = (-1).obs;
  var editingIndexForConvertersDetails = (-1).obs;
  RxString jobCardId = RxString('');
  RxString converterId = RxString('');
  RxBool isIssuingModified = RxBool(false);
  RxBool isIssuingItemsDetailsModified = RxBool(false);
  RxBool isIssuingConvertersDetailsModified = RxBool(false);
  RxDouble totalsForSelectedInventoryItemsDetails = RxDouble(0.0);
  RxDouble totalsForSelectedConvertersDetails = RxDouble(0.0);
  final Uuid _uuid = const Uuid();

  @override
  void onInit() async {
    searchEngine({"today": true});
    super.onInit();
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  Future<Map<String, dynamic>> getBranches() async {
    return await helper.getBrunches();
  }

  Future<Map<String, dynamic>> getIssueTypes() async {
    return await helper.getAllListValues('ISSUE_TYPES');
  }

  Future<Map<String, dynamic>> getEmployeesByDepartment() async {
    return await helper.getAllEmployeesByDepartment('Issueing');
  }

  Future getCurrentIssuingStatus(String id) async {
    return await helper.getIssuingStatus(id);
  }

  Future<void> getAllJobCards() async {
    loadingJobCards.value = true;
    allJobCards.assignAll(await helper.getAllJobCards());
    loadingJobCards.value = false;
  }

  Future<void> getAllConverters() async {
    try {
      loadingConverters.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/converters/get_all_converter');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List converters = decoded['converters'];
        allConverters.assignAll(
          converters.map((conv) => ConverterModel.fromJson(conv)),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllConverters();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      loadingConverters.value = false;
    } catch (e) {
      loadingConverters.value = false;
    }
  }

  Future<void> getAllInventeryItems() async {
    try {
      if (currentIssuingId.isNotEmpty) {
        Map jobStatus = await getCurrentIssuingStatus(currentIssuingId.value);
        String status1 = jobStatus['status'];
        if (status1 != 'New' && status1 != '') {
          showSnackBar('Alert', 'Only new converters can be edited');
          return;
        }
      }
      loadingItemsTable.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/issue_items/get_items_details_section');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List items = decoded['items_details'];
        allInventeryItems.assignAll(
          items.map(
            (item) => BaseModelForIssuingItems.fromJsonForInventoryItems(item),
          ),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllInventeryItems();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      loadingItemsTable.value = false;
    } catch (e) {
      loadingItemsTable.value = false;
    }
  }

  Future<void> getAllConvertersDetails() async {
    try {
      if (currentIssuingId.isNotEmpty) {
        Map jobStatus = await getCurrentIssuingStatus(currentIssuingId.value);
        String status1 = jobStatus['status'];
        if (status1 != 'New' && status1 != '') {
          showSnackBar('Alert', 'Only new converters can be edited');
          return;
        }
      }
      loadingItemsTable.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/issue_items/get_converters_details_section',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List items = decoded['converters_details'];
        allConvertersDetails.assignAll(
          items.map(
            (item) => BaseModelForIssuingItems.fromJsonForConverters(item),
          ),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllInventeryItems();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      loadingItemsTable.value = false;
    } catch (e) {
      loadingItemsTable.value = false;
    }
  }

  Future<void> addNewIssuingDoc() async {
    try {
      if (currentIssuingId.isNotEmpty) {
        Map jobStatus = await getCurrentIssuingStatus(currentIssuingId.value);

        String status1 = jobStatus['status'];
        if (status1 != 'New' && status1 != '') {
          showSnackBar('Alert', 'Only new issuing docs can be edited');
          return;
        }
      }
      addingNewValue.value = true;

      // Base data
      final Map<String, dynamic> newData = {
        'branch': branchId.value,
        'issue_type': issueTypeId.value,
        'job_card_id': jobCardId.value,
        'converter_id': converterId.value,
        'note': note.value.text.trim(),
        'received_by': receivedById.value,
        'status': status.value,
        'items_details': selectedInventeryItems
            .where((inv) => inv.isDeleted != true)
            .map((item) => item.toJsonForinventoryItems())
            .toList(),
        'converters_details': selectedConvertersDetails
            .where((inv) => inv.isDeleted != true)
            .map((item) => item.toJsonForConverters())
            .toList(),
      };

      // Handle date parsing safely
      final rawDate = date.value.text.trim();
      if (rawDate.isNotEmpty) {
        try {
          newData['date'] = convertDateToIson(rawDate);
        } catch (e) {
          showSnackBar('Alert', 'Please enter a valid date');
          addingNewValue.value = false;
          return;
        }
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';

      if (currentIssuingId.isEmpty) {
        Uri addingRecUrl = Uri.parse('$backendUrl/issue_items/add_new_issuing');

        showSnackBar('Adding', 'Please Wait');
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
          String issNumber = decoded['issuing_number'];
          String issId = decoded['issuing_id'];
          addingNewValue.value = false;
          issueNumber.value.text = issNumber;
          currentIssuingId.value = issId;
          isIssuingModified.value = false;
          isIssuingConvertersDetailsModified.value = false;
          isIssuingItemsDetailsModified.value = false;
          showSnackBar('Done', 'Issuing Added Successfully');
        } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
          final refreshed = await helper.refreshAccessToken(refreshToken);
          if (refreshed == RefreshResult.success) {
            await addNewIssuingDoc();
          } else if (refreshed == RefreshResult.invalidToken) {
            logout();
          }
        } else if (response.statusCode == 401) {
          logout();
        }
      } else {
        if (isIssuingModified.isTrue ||
            isIssuingConvertersDetailsModified.isTrue ||
            isIssuingItemsDetailsModified.isTrue) {
          http.Response? responseForEditingIssuing;
          http.Response? responseForEditingIssuingItemsDetails;
          http.Response? responseForEditingIssuingConvertersDetails;

          showSnackBar('Updating', 'Please Wait');

          if (isIssuingModified.isTrue) {
            Uri updatingJobUrl = Uri.parse(
              '$backendUrl/issue_items/update_issuing/${currentIssuingId.value}',
            );
            Map newDataToUpdate = newData;
            newDataToUpdate.remove('items_details');
            newDataToUpdate.remove('converters_details');
            responseForEditingIssuing = await http.patch(
              updatingJobUrl,
              headers: {
                'Authorization': 'Bearer $accessToken',
                "Content-Type": "application/json",
              },
              body: jsonEncode(newDataToUpdate),
            );
            if (responseForEditingIssuing.statusCode == 200) {
              final decoded = jsonDecode(responseForEditingIssuing.body);
              IssuingModel newIss = IssuingModel.fromJson(decoded['issuing']);
              currentIssuingId.value = newIss.id ?? '';
              // selectedInventeryItems.value = newIss.itemsDetailsSection ?? [];
              // selectedConvertersDetails.value = newIss.convertersDetailsSection ?? [];
              isIssuingModified.value = false;
              // calculateTotalsForSelectedReceive();
            } else if (responseForEditingIssuing.statusCode == 401 &&
                refreshToken.isNotEmpty) {
              final refreshed = await helper.refreshAccessToken(refreshToken);
              if (refreshed == RefreshResult.success) {
                await addNewIssuingDoc();
              } else if (refreshed == RefreshResult.invalidToken) {
                logout();
              }
            } else if (responseForEditingIssuing.statusCode == 401) {
              logout();
            }
          }
          if (isIssuingItemsDetailsModified.isTrue) {
            Uri updatingJobInvoicesUrl = Uri.parse(
              '$backendUrl/issue_items/update_issuing_items_details',
            );
            responseForEditingIssuingItemsDetails = await http.patch(
              updatingJobInvoicesUrl,
              headers: {
                'Authorization': 'Bearer $accessToken',
                "Content-Type": "application/json",
              },
              body: jsonEncode(
                selectedInventeryItems
                    .where(
                      (item) =>
                          (item.isModified == true ||
                          item.isAdded == true ||
                          (item.isDeleted == true && item.id != null)),
                    )
                    .map((item) => item.toJsonForinventoryItems())
                    .toList(),
              ),
            );
            if (responseForEditingIssuingItemsDetails.statusCode == 200) {
              // final decoded = jsonDecode(
              //   responseForEditingIssuingItemsDetails.body,
              // );
              // List updatedItems = decoded['updated_items']['items_details'];
              // if (updatedItems.isNotEmpty) {
              //   selectedInventeryItems.assignAll(
              //     updatedItems.map(
              //       (item) =>
              //           BaseModelForIssuingItems.fromJsonForInventoryItems(
              //             item,
              //           ),
              //     ),
              //   );
              // }
              isIssuingItemsDetailsModified.value = false;
            } else if (responseForEditingIssuingItemsDetails.statusCode ==
                    401 &&
                refreshToken.isNotEmpty) {
              final refreshed = await helper.refreshAccessToken(refreshToken);
              if (refreshed == RefreshResult.success) {
                await addNewIssuingDoc();
              } else if (refreshed == RefreshResult.invalidToken) {
                logout();
              }
            } else if (responseForEditingIssuingItemsDetails.statusCode ==
                401) {
              logout();
            }
          }
          if (isIssuingConvertersDetailsModified.isTrue) {
            Uri updatingIssueConverterUrl = Uri.parse(
              '$backendUrl/issue_items/update_issuing_converters_details',
            );
            responseForEditingIssuingConvertersDetails = await http.patch(
              updatingIssueConverterUrl,
              headers: {
                'Authorization': 'Bearer $accessToken',
                "Content-Type": "application/json",
              },
              body: jsonEncode(
                selectedConvertersDetails
                    .where(
                      (item) =>
                          (item.isModified == true ||
                          item.isAdded == true ||
                          (item.isDeleted == true && item.id != null)),
                    )
                    .map((item) => item.toJsonForConverters())
                    .toList(),
              ),
            );
            if (responseForEditingIssuingConvertersDetails.statusCode == 200) {
              // final decoded = jsonDecode(
              //   responseForEditingIssuingConvertersDetails.body,
              // );
              // List updatedItems = decoded['updated_items']['items_details'];
              // if (updatedItems.isNotEmpty) {
              //   allInventeryItems.assignAll(
              //     updatedItems.map(
              //       (item) =>
              //           BaseModelForIssuingItems.fromJsonForInventoryItems(
              //             item,
              //           ),
              //     ),
              //   );
              // }
              isIssuingConvertersDetailsModified.value = false;
              // calculateTotalsForSelectedReceive();
            } else if (responseForEditingIssuingConvertersDetails.statusCode ==
                    401 &&
                refreshToken.isNotEmpty) {
              final refreshed = await helper.refreshAccessToken(refreshToken);
              if (refreshed == RefreshResult.success) {
                await addNewIssuingDoc();
              } else if (refreshed == RefreshResult.invalidToken) {
                logout();
              }
            } else if (responseForEditingIssuingConvertersDetails.statusCode ==
                401) {
              logout();
            }
          }
          if ((responseForEditingIssuing?.statusCode == 200) ||
              (responseForEditingIssuingItemsDetails?.statusCode == 200 ||
                  responseForEditingIssuingConvertersDetails?.statusCode ==
                      200)) {
            showSnackBar('Done', 'Updated Successfully');
          }
        }
      }
      addingNewValue.value = false; // Ensure loading flag is reset
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong');
      addingNewValue.value = false; // Ensure loading flag is reset
    }
  }

  Future<void> deleteIssuing(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/issue_items/delete_issuing/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        String deletedIssuingId = decoded['issuing_id'];
        allIssuesDocs.removeWhere((rec) => rec.id == deletedIssuingId);
        numberOfIssuesgDocs.value -= 1;
        Get.close(2);
        showSnackBar('Success', 'Issuing deleted successfully');
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        final decoded =
            jsonDecode(response.body) ?? 'Failed to delete receiving';
        String error = decoded['detail'];
        showSnackBar('Alert', error);
      } else if (response.statusCode == 403) {
        final decoded = jsonDecode(response.body);
        String error = decoded['detail'] ?? 'Only New Issuing Allowed';
        showSnackBar('Alert', error);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteIssuing(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 500) {
        final decoded = jsonDecode(response.body);
        final error =
            decoded['detail'] ?? 'Server error while deleting issuing';
        showSnackBar('Server Error', error);
      } else if (response.statusCode == 401) {
        logout();
      }
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  void filterSearch() async {
    Map<String, dynamic> body = {};
    if (issueNumberFilter.value.text.isNotEmpty) {
      body["issuing_number"] = issueNumberFilter.value.text;
    }
    // if (referenceNumberFilter.value.text.isNotEmpty) {
    //   body["reference_number"] = referenceNumberFilter.value.text;
    // }
    // if (vendorNameIdFilter.value.isNotEmpty) {
    //   body["vendor"] = vendorNameIdFilter.value;
    // }
    if (receivedByIdFilter.value.isNotEmpty) {
      body["received_by"] = receivedByIdFilter.value;
    }

    if (statusFilter.value.text.isNotEmpty) {
      body["status"] = statusFilter.value.text;
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
      Uri url = Uri.parse('$backendUrl/issue_items/search_engine_for_issuing');
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
        List issuing = decoded['issuing'];
        Map grandTotals = decoded['grand_totals'];
        allIssuesTotals.value = grandTotals['grand_total'];
        allIssuesDocs.assignAll(
          issuing.map((iss) => IssuingModel.fromJson(iss)),
        );
        numberOfIssuesgDocs.value = allIssuesDocs.length;
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

  void addSelectedInventoryItems() {
    for (final item in allInventeryItems.where((r) => r.isSelected == true)) {
      final String uniqueId = _uuid.v4();

      selectedInventeryItems.add(
        BaseModelForIssuingItems(
          id: uniqueId,
          inventoryItemId: item.id,
          code: item.code,
          name: item.name,
          finalQuantity: 0,
          lastPrice: item.lastPrice,
          isDeleted: false,
          isAdded: true,
          isSelected: true,
          issueId: currentIssuingId.value,
        ),
      );
    }
    calculateTotalsForSelectedInventoryItemsDetails();
    isIssuingItemsDetailsModified.value = true;
    selectedInventeryItems.refresh();
    Get.back();
  }

  void addSelectedConvertersDetails() {
    final existingConvertersIds = selectedConvertersDetails
        .map((r) => r.id)
        .toSet();

    for (final item in allConvertersDetails.where(
      (r) => r.isSelected == true,
    )) {
      if (existingConvertersIds.contains(item.id)) {
        final idx = selectedConvertersDetails.indexWhere(
          (i) => i.id == item.id,
        );

        if (idx != -1) {
          final existing = selectedConvertersDetails[idx];
          existing
            ..issueId = currentIssuingId.value
            ..isDeleted = false
            ..isAdded = true
            ..isSelected = true
            ..finalQuantity = 1;
        }

        item
          ..issueId = currentIssuingId.value
          ..isDeleted = false
          ..isAdded = true
          ..isSelected = true
          ..finalQuantity = 1;
      } else {
        item
          ..issueId = currentIssuingId.value
          ..isAdded = true
          ..isSelected = true
          ..isDeleted = false
          ..finalQuantity = 1;

        selectedConvertersDetails.add(item);
        existingConvertersIds.add(item.id);
      }
    }
    calculateTotalsForSelectedConvertersDetails();
    selectedConvertersDetails.refresh();
    isIssuingConvertersDetailsModified.value = true;
    allConvertersDetails.refresh();
    Get.back();
  }

  void removeSelectedInventoryItems(String id) {
    if (status.value != 'New' && status.value != '') {
      showSnackBar('Alert', 'Only new issuing allowed');
      return;
    }

    final selIdx = selectedInventeryItems.indexWhere((s) => s.id == id);
    if (selIdx != -1) {
      final r = selectedInventeryItems[selIdx];
      r
        ..isDeleted = true
        ..isModified = true
        ..isSelected = false;
    }

    // 3) Trigger recalculations and reactive updates
    calculateTotalsForSelectedInventoryItemsDetails();
    // allInventeryItems.refresh();
    isIssuingItemsDetailsModified.value = true;
    selectedInventeryItems.refresh();
    Get.back();
  }

  void removeSelectedConvertersDetails(String id) {
    if (status.value != 'New' && status.value != '') {
      showSnackBar('Alert', 'Only new issuing allowed');
      return;
    }

    final availIdx = allConvertersDetails.indexWhere((r) => r.id == id);
    if (availIdx != -1) {
      final r = allConvertersDetails[availIdx];
      r
        ..isSelected = false
        ..isModified = true
        ..isDeleted = true;
    }

    final selIdx = selectedConvertersDetails.indexWhere((s) => s.id == id);
    if (selIdx != -1) {
      final r = selectedConvertersDetails[selIdx];
      r
        ..isDeleted = true
        ..isModified = true
        ..isSelected = false;
    }
    calculateTotalsForSelectedConvertersDetails();
    allConvertersDetails.refresh();
    isIssuingConvertersDetailsModified.value = true;
    selectedConvertersDetails.refresh();
    Get.back();
  }

  void finishEditingForInventoryItems(String newValue, int idx) {
    selectedInventeryItems[idx].finalQuantity = int.tryParse(newValue) ?? 0;
    selectedInventeryItems[idx].total =
        selectedInventeryItems[idx].finalQuantity! *
        selectedInventeryItems[idx].lastPrice!;
    calculateTotalsForSelectedInventoryItemsDetails();
    selectedInventeryItems[idx].isModified = true;
    isIssuingItemsDetailsModified.value = true;
    editingIndexForInventoryDetails.value = -1;
  }

  void finishEditingForConverters(String newValue, int idx) {
    selectedConvertersDetails[idx].finalQuantity = int.tryParse(newValue) ?? 0;
    selectedConvertersDetails[idx].total =
        selectedConvertersDetails[idx].finalQuantity! *
        selectedConvertersDetails[idx].lastPrice!;
    calculateTotalsForSelectedConvertersDetails();
    selectedConvertersDetails[idx].isModified = true;
    isIssuingConvertersDetailsModified.value = true;
    editingIndexForConvertersDetails.value = -1;
  }

  void startEditing(bool isConverter, int idx) {
    isConverter == false
        ? editingIndexForInventoryDetails.value = idx
        : editingIndexForConvertersDetails.value = idx;
  }

  void calculateTotalsForSelectedInventoryItemsDetails() {
    totalsForSelectedInventoryItemsDetails.value = 0;
    for (var item in selectedInventeryItems) {
      totalsForSelectedInventoryItemsDetails.value += item.total ?? 0;
    }
  }

  void calculateTotalsForSelectedConvertersDetails() {
    totalsForSelectedConvertersDetails.value = 0;
    for (var item in selectedConvertersDetails) {
      totalsForSelectedConvertersDetails.value += item.total ?? 0;
    }
  }

  // ======================================================================================================================

  void selectedJobOrConverter(String selected) {
    if (selected != '') {
      if (selected == 'Job Card') {
        getAllJobCards();
      } else {
        getAllConverters();
      }
    }
  }

  void updateToPostedStatus() async {
    if (currentIssuingId.isNotEmpty) {
      Map jobStatus = await getCurrentIssuingStatus(currentIssuingId.value);

      String status1 = jobStatus['status'];
      if (status1 == 'Posted') {
        showSnackBar('Alert', 'Status is already posted');
        return;
      } else if (status1 == 'Cancelled') {
        showSnackBar('Alert', 'Status is cancelled');
        return;
      } else {
        status.value = 'Posted';
        isIssuingModified.value = true;
      }
    } else {
      showSnackBar('Alert', 'Please save the issue doc first');
    }
  }

  void updateToCanelledStatus() async {
    if (currentIssuingId.isNotEmpty) {
      Map jobStatus = await getCurrentIssuingStatus(currentIssuingId.value);

      String status1 = jobStatus['status'];
      if (status1 == 'Cancelled') {
        showSnackBar('Alert', 'Status is already cancelled');
        return;
      } else if (status1 == 'Posted') {
        showSnackBar('Alert', 'Status is cancelled');
        return;
      } else {
        status.value = 'Cancelled';
        isIssuingModified.value = true;
      }
    } else {
      showSnackBar('Alert', 'Please save the issue doc first');
    }
  }

  void searchEngineForJobCards() {
    jobQuery.value = searchForJobCards.value.text.toLowerCase();
    if (jobQuery.value.isEmpty) {
      filteredJobCards.clear();
    } else {
      filteredJobCards.assignAll(
        allJobCards.where((job) {
          return job.jobNumber.toString().toLowerCase().contains(jobQuery) ||
              job.carBrandName.toString().toLowerCase().contains(jobQuery) ||
              job.carModelName.toString().toLowerCase().contains(jobQuery) ||
              job.customerName.toString().toLowerCase().contains(jobQuery) ||
              job.plateNumber.toString().toLowerCase().contains(jobQuery) ||
              job.vehicleIdentificationNumber.toString().toLowerCase().contains(
                jobQuery,
              );
        }).toList(),
      );
    }
  }

  void searchEngineForConverters() {
    converterQuery.value = searchForConverters.value.text.toLowerCase();
    if (converterQuery.value.isEmpty) {
      filteredConverters.clear();
    } else {
      filteredConverters.assignAll(
        allConverters.where((converter) {
          return converter.converterNumber.toString().toLowerCase().contains(
                converterQuery,
              ) ||
              converter.name.toString().toLowerCase().contains(
                converterQuery,
              ) ||
              converter.description.toString().toLowerCase().contains(
                converterQuery,
              );
        }).toList(),
      );
    }
  }

  void searchEngineForInverntoryItems() {
    inventoryQuery.value = searchForInventoryItems.value.text.toLowerCase();
    if (inventoryQuery.value.isEmpty) {
      filteredInventeryItems.clear();
    } else {
      filteredInventeryItems.assignAll(
        allInventeryItems.where((item) {
          return item.name.toString().toLowerCase().contains(inventoryQuery) ||
              item.code.toString().toLowerCase().contains(inventoryQuery);
        }).toList(),
      );
    }
  }

  void searchEngineForConvertersDetails() {
    converterDetailsQuery.value = searchForConvertersDetails.value.text
        .toLowerCase();
    if (converterDetailsQuery.value.isEmpty) {
      filteredConvertersDetails.clear();
    } else {
      filteredConvertersDetails.assignAll(
        allConvertersDetails.where((item) {
          return item.name.toString().toLowerCase().contains(inventoryQuery) ||
              item.number.toString().toLowerCase().contains(inventoryQuery);
        }).toList(),
      );
    }
  }

  void clearValues() {
    currentIssuingId.value = '';
    branch.value.clear();
    branchId.value = '';
    date.value.text = textToDate(DateTime.now());
    issueNumber.value.clear();
    issueType.value = '';
    issueTypeId.value = '';
    jobDetails.clear();
    allJobCards.clear();
    allConverters.clear();
    allConvertersDetails.clear();
    allInventeryItems.clear();
    selectedConvertersDetails.clear();
    note.value.clear();
    selectedInventeryItems.clear();
    receivedBy.value.clear();
    receivedById.value = '';
    status.value = '';
    totalsForSelectedConvertersDetails.value = 0.0;
    totalsForSelectedInventoryItemsDetails.value = 0.0;
  }

  void loadValues(IssuingModel data) {
    List<BaseModelForIssuingItems> items = data.itemsDetailsSection ?? [];
    List<BaseModelForIssuingItems> converters =
        data.convertersDetailsSection ?? [];
    currentIssuingId.value = data.id ?? '';
    issueNumber.value.text = data.issuingNumber ?? '';
    date.value.text = textToDate(data.date);
    issueType.value = data.issueTypeName ?? '';
    jobCardId.value = data.jobCardId ?? '';
    converterId.value = data.converterId ?? '';
    issueTypeId.value = data.issueType ?? '';
    branch.value.text = data.branchName ?? '';
    branchId.value = data.branch ?? '';
    jobDetails.text = data.detailsString ?? '';
    receivedBy.value.text = data.receivedByName ?? '';
    receivedById.value = data.receivedBy ?? '';
    selectedInventeryItems.assignAll(items);
    selectedConvertersDetails.assignAll(converters);
    status.value = data.status ?? '';
    isIssuingModified.value = false;
    isIssuingConvertersDetailsModified.value = false;
    isIssuingItemsDetailsModified.value = false;
    note.value.text = data.note ?? '';
    calculateTotalsForSelectedConvertersDetails();
    calculateTotalsForSelectedInventoryItemsDetails();
  }

  void clearAllFilters() {
    issueNumberFilter.value.clear();
    receivedByFilter.value.clear();
    receivedById.value = '';
    statusFilter.value.clear();
    fromDate.value.clear();
    toDate.value.clear();
    isAllSelected.value = false;
    isTodaySelected.value = false;
    isThisMonthSelected.value = false;
    isThisYearSelected.value = false;
  }
}
