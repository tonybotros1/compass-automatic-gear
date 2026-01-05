import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../Models/ar receipts and ap payments/ap_invoices_model.dart';
import '../../Models/job cards/job_card_model.dart';
import '../../consts.dart';
import '../../helpers.dart';

class ApInvoicesController extends GetxController {
  TextEditingController invoiceType = TextEditingController();
  RxString invoiceTypeFilterId = RxString('');
  TextEditingController invoiceTypeFilter = TextEditingController();
  RxString status = RxString('');
  TextEditingController referenceNumber = TextEditingController();
  TextEditingController referenceNumberFilter = TextEditingController();
  TextEditingController invoiceNumberFilter = TextEditingController();
  TextEditingController transactionDate = TextEditingController();
  TextEditingController vendor = TextEditingController();
  Rx<TextEditingController> vendorFilter = TextEditingController().obs;
  Rx<TextEditingController> statusFilter = TextEditingController().obs;
  TextEditingController description = TextEditingController();
  TextEditingController searchForJobCards = TextEditingController();
  TextEditingController jobNumber = TextEditingController();
  TextEditingController jobNumberId = TextEditingController();
  TextEditingController vendorForInvoice = TextEditingController();
  TextEditingController invoiceDate = TextEditingController();
  TextEditingController invoiceNumber = TextEditingController();
  TextEditingController vat = TextEditingController();
  TextEditingController receivedNumber = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController transactionType = TextEditingController();
  TextEditingController invoiceNote = TextEditingController();
  Rx<TextEditingController> fromDate = TextEditingController().obs;
  Rx<TextEditingController> toDate = TextEditingController().obs;
  RxBool isYearSelected = RxBool(false);
  RxBool isMonthSelected = RxBool(false);
  RxBool isDaySelected = RxBool(false);
  RxBool isTodaySelected = RxBool(false);
  RxBool isAllSelected = RxBool(false);
  RxBool isThisMonthSelected = RxBool(false);
  RxBool isThisYearSelected = RxBool(false);
  RxString query = RxString('');
  final ScrollController scrollControllerFotTable1 = ScrollController();
  var buttonLoadingStates = <String, bool>{}.obs;

  RxBool isScreenLoding = RxBool(false);
  final RxList<ApInvoicesModel> allApInvoices = RxList<ApInvoicesModel>([]);
  final RxList<ApInvoicesItem> allInvoices = RxList<ApInvoicesItem>([]);
  final RxList<JobCardModel> allJobCards = RxList<JobCardModel>([]);
  // RxBool addingNewinvoiceItemsValue = RxBool(false);
  RxString invoiceTypeId = RxString('');
  RxString vendorId = RxString('');
  RxString vendorFilterId = RxString('');
  RxString vendorForInvoiceId = RxString('');
  RxString transactionTypeId = RxString('');
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool loadingInvoices = RxBool(false);
  RxMap allInvoiceTypes = RxMap({});

  RxBool loadingJobCards = RxBool(false);
  // RxBool loadingInvoiceItems = RxBool(false);
  RxBool addingNewValue = RxBool(false);
  RxBool apInvoiceAdded = RxBool(false);
  // RxBool canAddInvoice = RxBool(false);
  RxString currentApInvoiceId = RxString('');
  DateFormat format = DateFormat("dd-MM-yyyy");
  // RxBool postingapInvoice = RxBool(false);
  RxBool cancellingapInvoice = RxBool(false);
  RxBool deletingapInvoice = RxBool(false);

  // for the new invoice item
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();
  final FocusNode focusNode5 = FocusNode();
  final FocusNode focusNode6 = FocusNode();
  final FocusNode focusNode7 = FocusNode();
  final FocusNode focusNode8 = FocusNode();

  // for the payment header
  final FocusNode focusNodePayementHeader1 = FocusNode();
  final FocusNode focusNodePayementHeader2 = FocusNode();
  final FocusNode focusNodePayementHeader3 = FocusNode();
  final FocusNode focusNodePayementHeader4 = FocusNode();

  String backendUrl = backendTestURI;
  final Uuid _uuid = const Uuid();
  RxBool isInvoiceModified = RxBool(false);
  RxBool isInvoiceItemsModified = RxBool(false);
  RxInt numberOfAPInvoices = RxInt(0);
  RxDouble totalAmountForAPInvoices = RxDouble(0);
  RxDouble totalVATForAPInvoices = RxDouble(0);
  RxDouble calculatedAmountForInvoiceItems = RxDouble(0.0);
  RxDouble calculatedVatForInvoiceItems = RxDouble(0.0);

  // job filters
  TextEditingController jobNumberFilter = TextEditingController();
  TextEditingController carBrandIdFilterName = TextEditingController();
  RxString carBrandIdFilter = RxString('');
  RxString carModelIdFilter = RxString('');
  TextEditingController carModelIdFilterName = TextEditingController();
  TextEditingController plateNumberFilter = TextEditingController();
  TextEditingController vinFilter = TextEditingController();
  TextEditingController customerNameIdFilterName = TextEditingController();
  RxString customerNameIdFilter = RxString('');

  @override
  void onInit() async {
    setTodayRange(fromDate: fromDate.value, toDate: toDate.value);
    filterSearch();
    super.onInit();
  }

  Future<Map<String, dynamic>> getAllVendors() async {
    return await helper.getVendors();
  }

  Future<Map<String, dynamic>> getInvoiceTypes() async {
    return await helper.getAllListValues('MISC_TYPE');
  }

  Future<Map<String, dynamic>> getTransactionTypes() async {
    return await helper.getAllAPPaymentTypes();
  }

  Future getCurrentAPInvoicedStatus(String id) async {
    return await helper.getAPInvoiceStatus(id);
  }

  Future<Map<String, dynamic>> getCarBrands() async {
    return await helper.getCarBrands();
  }

  Future<Map<String, dynamic>> getModelsByCarBrand(String brandID) async {
    return await helper.getModelsValues(brandID);
  }

  Future<Map<String, dynamic>> getAllCustomers() async {
    return await helper.getCustomers();
  }

  void onChooseForDatePicker(int i) {
    switch (i) {
      case 1:
        isTodaySelected.value = false;
        isThisMonthSelected.value = false;
        isThisYearSelected.value = false;
        fromDate.value.clear();
        toDate.value.clear();
        break;
      case 2:
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

  void calculateAmountForSelectedReceipts() {
    calculatedAmountForInvoiceItems.value = 0.0;
    calculatedVatForInvoiceItems.value = 0.0;
    for (var element in allInvoices.where((inv) => inv.isDeleted != true)) {
      calculatedAmountForInvoiceItems.value += element.amount;
      calculatedVatForInvoiceItems.value += element.vat;
    }
  }

  Future<void> addNewApInvoice() async {
    try {
      if (currentApInvoiceId.isNotEmpty) {
        Map jobStatus = await getCurrentAPInvoicedStatus(
          currentApInvoiceId.value,
        );
        String status1 = jobStatus['status'];
        if (status1 != 'New' && status1 != '') {
          alertMessage(
            context: Get.context!,
            content: 'Only new jobs can be edited',
          );
          return;
        }
      }
      addingNewValue.value = true;
      Map<String, dynamic> newData = {
        'invoice_type': invoiceTypeId.value,
        'vendor': vendorId.value,
        'description': description.text,
        'invoice_number': invoiceNumber.text,
        'status': status.value,
        'items': allInvoices
            .where((item) => item.isDeleted != true)
            .map((i) => i.toJson())
            .toList(),
      };

      final rawDate = transactionDate.value.text.trim();
      if (rawDate.isNotEmpty) {
        try {
          newData['transaction_date'] = convertDateToIson(rawDate);
        } catch (e) {
          alertMessage(
            context: Get.context!,
            content: 'Please enter valid job date',
          );
        }
      } else {
        newData['transaction_date'] = null;
      }

      final rawDate2 = invoiceDate.value.text.trim();
      if (rawDate2.isNotEmpty) {
        try {
          newData['invoice_date'] = convertDateToIson(rawDate2);
        } catch (e) {
          alertMessage(
            context: Get.context!,
            content: 'Please enter valid invoice date',
          );
        }
      } else {
        newData['invoice_date'] = null;
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri addingJobUrl = Uri.parse(
        '$backendUrl/ap_invoices/add_new_ap_invoice',
      );

      if (currentApInvoiceId.isEmpty) {
        newData['status'] = 'New';
        final response = await http.post(
          addingJobUrl,
          headers: {
            'Authorization': 'Bearer $accessToken',
            "Content-Type": "application/json",
          },
          body: jsonEncode(newData),
        );
        if (response.statusCode == 200) {
          status.value = 'New';
          final decoded = jsonDecode(response.body);
          ApInvoicesModel newInvoice = ApInvoicesModel.fromJson(
            decoded['invoice'],
          );
          referenceNumber.text = newInvoice.referenceNumber ?? '';
          addingNewValue.value = false;
          currentApInvoiceId.value = newInvoice.id ?? '';
          allInvoices.value = newInvoice.items;
          isInvoiceModified.value = false;
          isInvoiceItemsModified.value = false;
          allApInvoices.insert(0, newInvoice);
        } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
          final refreshed = await helper.refreshAccessToken(refreshToken);
          if (refreshed == RefreshResult.success) {
            await addNewApInvoice();
          } else if (refreshed == RefreshResult.invalidToken) {
            logout();
          }
        } else if (response.statusCode == 401) {
          logout();
        }
      } else {
        http.Response? responseForEditingAPInvoice;
        http.Response? responseForEditingAPInvoiceItems;
        if (isInvoiceModified.isTrue) {
          Uri updatingJobUrl = Uri.parse(
            '$backendUrl/ap_invoices/update_ap_invoice/${currentApInvoiceId.value}',
          );
          Map newDataToUpdate = newData;
          newDataToUpdate.remove('items');
          responseForEditingAPInvoice = await http.patch(
            updatingJobUrl,
            headers: {
              'Authorization': 'Bearer $accessToken',
              "Content-Type": "application/json",
            },
            body: jsonEncode(newDataToUpdate),
          );
          if (responseForEditingAPInvoice.statusCode == 200) {
            final decoded = jsonDecode(responseForEditingAPInvoice.body);
            ApInvoicesModel updatedApInvoice = ApInvoicesModel.fromJson(
              decoded['updated_ap_invoice'],
            );
            int index = allApInvoices.indexWhere(
              (item) => item.id == updatedApInvoice.id,
            );
            if (index != -1) {
              allApInvoices[index] = updatedApInvoice;
            }
            isInvoiceModified.value = false;
          } else if (responseForEditingAPInvoice.statusCode == 401 &&
              refreshToken.isNotEmpty) {
            final refreshed = await helper.refreshAccessToken(refreshToken);
            if (refreshed == RefreshResult.success) {
              await addNewApInvoice();
            } else if (refreshed == RefreshResult.invalidToken) {
              logout();
            }
          } else if (responseForEditingAPInvoice.statusCode == 401) {
            logout();
          }
        }
        if (isInvoiceItemsModified.isTrue) {
          Uri updatingJobInvoicesUrl = Uri.parse(
            '$backendUrl/ap_invoices/update_invoice_items',
          );
          responseForEditingAPInvoiceItems = await http.patch(
            updatingJobInvoicesUrl,
            headers: {
              'Authorization': 'Bearer $accessToken',
              "Content-Type": "application/json",
            },
            body: jsonEncode(
              allInvoices
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
          if (responseForEditingAPInvoiceItems.statusCode == 200) {
            final decoded = jsonDecode(responseForEditingAPInvoiceItems.body);

            final updated = ApInvoicesModel.fromJson(
              decoded['updated_ap_invoice'],
            );

            int index = allApInvoices.indexWhere((e) => e.id == updated.id);

            if (index != -1) {
              allApInvoices[index] = allApInvoices[index].copyWith(
                items: updated.items.isNotEmpty
                    ? updated.items
                    : allApInvoices[index].items,
                totalAmount: updated.totalAmount.isNaN
                    ? allApInvoices[index].totalAmount
                    : updated.totalAmount,
                totalVat: updated.totalVat.isNaN
                    ? allApInvoices[index].totalVat
                    : updated.totalVat,
              );
              allApInvoices.refresh();
            }

            isInvoiceItemsModified.value = false;
          } else if (responseForEditingAPInvoiceItems.statusCode == 401 &&
              refreshToken.isNotEmpty) {
            final refreshed = await helper.refreshAccessToken(refreshToken);
            if (refreshed == RefreshResult.success) {
              await addNewApInvoice();
            } else if (refreshed == RefreshResult.invalidToken) {
              logout();
            }
          } else if (responseForEditingAPInvoiceItems.statusCode == 401) {
            logout();
          }
        }
        if ((responseForEditingAPInvoiceItems?.statusCode == 200) ||
            (responseForEditingAPInvoice?.statusCode == 200)) {}
      }
      addingNewValue.value = false;
    } catch (e) {
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
      addingNewValue.value = false;
    }
  }

  Future<void> deleteAPInvoice(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/ap_invoices/delete_ap_invoice/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        String deletedId = decoded['invoice_id'];
        allApInvoices.removeWhere((inv) => inv.id == deletedId);
        numberOfAPInvoices.value -= 1;
        Get.close(2);
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        final decoded = jsonDecode(response.body) ?? 'Failed to delete invoice';
        String error = decoded['detail'];
        alertMessage(context: Get.context!, content: error);
      } else if (response.statusCode == 403) {
        final decoded = jsonDecode(response.body);
        String error = decoded['detail'] ?? 'Only New AP Invoice Allowed';
        alertMessage(context: Get.context!, content: error);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteAPInvoice(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 500) {
        final decoded = jsonDecode(response.body);
        final error =
            decoded['detail'] ?? 'Server error while deleting AP Invoice';
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

  void filterSearch() async {
    Map<String, dynamic> body = {};
    if (invoiceTypeFilterId.value.isNotEmpty) {
      body["invoice_type"] = invoiceTypeFilterId.value;
    }
    if (referenceNumberFilter.text.isNotEmpty) {
      body["reference_number"] = referenceNumberFilter.text;
    }
    if (vendorFilterId.value.isNotEmpty) {
      body["vendor"] = vendorFilterId.value;
    }

    if (statusFilter.value.text.isNotEmpty) {
      body["status"] = statusFilter.value.text;
    }
    if (invoiceNumberFilter.text.isNotEmpty) {
      body['invoice_number'] = invoiceNumberFilter.text;
    }
    // if (isTodaySelected.isTrue) {
    //   body["today"] = true;
    // }
    // if (isThisMonthSelected.isTrue) {
    //   body["this_month"] = true;
    // }
    // if (isThisYearSelected.isTrue) {
    //   body["this_year"] = true;
    // }
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
      Uri url = Uri.parse('$backendUrl/ap_invoices/search_engine');
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
        List invs = decoded['invoices'];
        Map grandTotals = decoded['grand_totals'];
        totalAmountForAPInvoices.value = grandTotals['grand_amounts'];
        totalVATForAPInvoices.value = grandTotals['grand_vats'];
        allApInvoices.assignAll(
          invs.map((inv) => ApInvoicesModel.fromJson(inv)),
        );
        numberOfAPInvoices.value = allApInvoices.length;
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

  void filterSearchForJobCards() async {
    Map<String, dynamic> body = {};
    if (carBrandIdFilter.value.isNotEmpty) {
      body["car_brand"] = carBrandIdFilter.value;
    }
    if (carModelIdFilter.value.isNotEmpty) {
      body["car_model"] = carModelIdFilter.value;
    }
    if (jobNumberFilter.text.isNotEmpty) {
      body["job_number"] = jobNumberFilter.text;
    }

    if (plateNumberFilter.text.isNotEmpty) {
      body["plate_number"] = plateNumberFilter.text;
    }
    if (vinFilter.text.isNotEmpty) {
      body["vin"] = vinFilter.text;
    }
    if (customerNameIdFilter.value.isNotEmpty) {
      body["customer_name"] = customerNameIdFilter.value;
    }
    if (body.isNotEmpty) {
      await searchEngineForJobCard(body);
    } else {
      await searchEngineForJobCard({"all": true});
    }
  }

  Future<void> searchEngineForJobCard(Map<String, dynamic> body) async {
    try {
      loadingJobCards.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/job_cards/search_engine_for_job_card_in_ap_invoices_screen',
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
        List invs = decoded['job_cards'];
        allJobCards.assignAll(invs.map((job) => JobCardModel.fromJson(job)));
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await searchEngineForJobCard(body);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }

      loadingJobCards.value = false;
    } catch (e) {
      loadingJobCards.value = false;
    }
  }

  // =======================================================================================================================

  Future<void> loadValues(ApInvoicesModel typeData) async {
    currentApInvoiceId.value = typeData.id ?? '';
    isInvoiceItemsModified.value = false;
    isInvoiceModified.value = false;
    invoiceNumber.text = typeData.invoiceNumber ?? '';
    invoiceDate.text = textToDate(typeData.invoiceDate ?? '');
    invoiceType.text = typeData.invoiceTypeName ?? '';
    allInvoices.assignAll(typeData.items);
    invoiceTypeId.value = typeData.invoiceType ?? '';
    referenceNumber.text = typeData.referenceNumber ?? '';
    transactionDate.text = textToDate(typeData.transactionDate);
    vendor.text = typeData.vendorName ?? '';
    vendorId.value = typeData.vendor ?? '';
    description.text = typeData.description ?? '';
    status.value = typeData.status ?? '';
    calculateAmountForSelectedReceipts();
  }

  void clearValues() {
    currentApInvoiceId.value = '';
    invoiceNumber.clear();
    invoiceDate.clear();
    invoiceType = TextEditingController();
    invoiceTypeId.value = '';
    referenceNumber.clear();
    transactionDate.clear();
    vendor = TextEditingController();
    vendorId.value = '';
    description.clear();
    allInvoices.clear();
    status.value = '';
    calculatedAmountForInvoiceItems.value = 0;
    calculatedVatForInvoiceItems.value = 0;
    update();
  }

  Future<void> editPostForApInvoices(String id) async {
    if (status.value.isEmpty) {
      alertMessage(
        context: Get.context!,
        content: 'Please Save The Invoice First',
      );
      return;
    }
    Map invoiceStatus = await getCurrentAPInvoicedStatus(id);
    String status1 = invoiceStatus['status'];

    if (status1 != 'Posted' && status1 != 'Cancelled' && status1.isNotEmpty) {
      status.value = 'Posted';
      isInvoiceModified.value = true;
      addNewApInvoice();
    } else if (status1 == 'Posted') {
      alertMessage(
        context: Get.context!,
        content: 'AP Invoice is Already Posted',
      );
    } else if (status1 == 'Cancelled') {
      alertMessage(context: Get.context!, content: 'AP Invoice is Cancelled');
    }
  }

  Future<void> editCancelForApInvoices(String id) async {
    if (status.value.isEmpty) {
      alertMessage(
        context: Get.context!,
        content: 'Please Save The Invoice First',
      );
      return;
    }
    Map invoiceStatus = await getCurrentAPInvoicedStatus(id);
    String status1 = invoiceStatus['status'];

    if (status1 != 'Cancelled' && status1 != 'Posted' && status1.isNotEmpty) {
      status.value = 'Cancelled';
      isInvoiceModified.value = true;
      addNewApInvoice();
    } else if (status1 == 'Cancelled') {
      alertMessage(
        context: Get.context!,
        content: 'AP Invoice Already Cancelled',
      );
    } else if (status1 == 'Posted') {
      alertMessage(context: Get.context!, content: 'AP Invoice is Posted');
    }
  }

  void addNewInvoiceItem() {
    final String uniqueId = _uuid.v4();
    isInvoiceItemsModified.value = true;
    allInvoices.add(
      ApInvoicesItem(
        uuid: uniqueId,
        amount: double.tryParse(amount.text) ?? 0,
        jobNumber: jobNumber.text,
        jobNumberId: jobNumberId.text,
        note: invoiceNote.text,
        transactionType: transactionTypeId.value,
        receivedNumber: receivedNumber.text,
        vat: double.tryParse(vat.text) ?? 0,
        apInvoiceId: currentApInvoiceId.value,
        transactionTypeName: transactionType.text,
        isAdded: true,
      ),
    );
    calculateAmountForSelectedReceipts();
    Get.back();
  }

  void editInvoiceItem(String id) {
    int index = allInvoices.indexWhere(
      (item) => (item.id == id || item.uuid == id),
    );
    if (index != -1) {
      isInvoiceItemsModified.value = true;
      final oldItem = allInvoices[index];
      allInvoices[index] = ApInvoicesItem(
        id: oldItem.id,
        uuid: oldItem.uuid,
        amount: double.tryParse(amount.text) ?? 0,
        jobNumber: jobNumber.text,
        jobNumberId: jobNumberId.text,
        note: invoiceNote.text,
        transactionType: transactionTypeId.value,
        receivedNumber: receivedNumber.text,
        vat: double.tryParse(vat.text) ?? 0,
        apInvoiceId: currentApInvoiceId.value,
        transactionTypeName: transactionType.text,
        isModified: true,
      );
      allInvoices.refresh();
    }
    calculateAmountForSelectedReceipts();
    Get.back();
  }

  void deleteInvoiceItem(String id) {
    int index = allInvoices.indexWhere(
      (item) => (item.id == id || item.uuid == id),
    );
    if (index != -1) {
      isInvoiceItemsModified.value = true;
      allInvoices[index].isDeleted = true;
      allInvoices.refresh();
    }
    calculateAmountForSelectedReceipts();

    Get.back();
  }

  void removeFilters() {
    isAllSelected.value = false;
    isTodaySelected.value = false;
    isThisMonthSelected.value = false;
    isThisYearSelected.value = false;
  }

  void clearAllFilters() {
    numberOfAPInvoices.value = 0;
    totalAmountForAPInvoices.value = 0;
    totalVATForAPInvoices.value = 0;
    statusFilter.value.clear();
    isAllSelected.value = false;
    isTodaySelected.value = false;
    isThisMonthSelected.value = false;
    isThisYearSelected.value = false;
    referenceNumberFilter.clear();
    invoiceTypeFilterId.value = '';
    invoiceTypeFilter.clear();
    vendorFilter.value = TextEditingController();
    fromDate.value.clear();
    toDate.value.clear();
  }
}
