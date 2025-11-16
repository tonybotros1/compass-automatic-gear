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
  TextEditingController transactionDate = TextEditingController();
  TextEditingController vendor = TextEditingController();
  Rx<TextEditingController> vendorFilter = TextEditingController().obs;
  Rx<TextEditingController> statusFilter = TextEditingController().obs;
  TextEditingController description = TextEditingController();
  TextEditingController searchForJobCards = TextEditingController();
  TextEditingController jobNumber = TextEditingController();
  TextEditingController vendorForInvoice = TextEditingController();
  TextEditingController invoiceDate = TextEditingController();
  TextEditingController invoiceNumber = TextEditingController();
  TextEditingController vat = TextEditingController();
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
  final RxList<JobCardModel> filteredJobCards = RxList<JobCardModel>([]);
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

  @override
  void onInit() async {
    searchEngine({"today": true});
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

  void calculateAmountForSelectedReceipts() {
    calculatedAmountForInvoiceItems.value = 0.0;
    calculatedVatForInvoiceItems.value = 0.0;
    for (var element in allInvoices.where((inv) => inv.isDeleted != true)) {
      calculatedAmountForInvoiceItems.value += element.amount ?? 0;
      calculatedVatForInvoiceItems.value += element.vat ?? 0;
    }
  }

  Future<void> getAllJobCards() async {
    try {
      loadingJobCards.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/job_cards/get_all_job_cards');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List jobs = decoded['all_jobs'];
        allJobCards.assignAll(jobs.map((job) => JobCardModel.fromJson(job)));
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllJobCards();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
    } catch (e) {
      loadingJobCards.value = false;
    } finally {
      loadingJobCards.value = false;
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
          showSnackBar('Alert', 'Only new jobs can be edited');
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
          showSnackBar('Alert', 'Please enter valid job date');
        }
      } else {
        newData['transaction_date'] = null;
      }

      final rawDate2 = invoiceDate.value.text.trim();
      if (rawDate2.isNotEmpty) {
        try {
          newData['invoice_date'] = convertDateToIson(rawDate2);
        } catch (e) {
          showSnackBar('Alert', 'Please enter valid invoice date');
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
        showSnackBar('Adding', 'Please Wait');
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
          allInvoices.value = newInvoice.items ?? [];
          isInvoiceModified.value = false;
          isInvoiceItemsModified.value = false;
          showSnackBar('Done', 'Invoice Added Successfully');
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
        if (isInvoiceModified.isTrue || isInvoiceItemsModified.isTrue) {
          showSnackBar('Updating', 'Please Wait');
        }
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
            List updatedItems = decoded['updated_items'];
            List deletedItems = decoded['deleted_items'];
            if (deletedItems.isNotEmpty) {
              for (var id in deletedItems) {
                allInvoices.removeWhere((item) => item.id == id);
              }
            }
            if (updatedItems.isNotEmpty) {
              for (var item in updatedItems) {
                var uuid = item['uuid'];
                var id = item['_id'];
                final localIndex = allInvoices.indexWhere(
                  (item) => item.uuid == uuid,
                );

                if (localIndex != -1) {
                  allInvoices[localIndex].id = id;
                  allInvoices[localIndex].isAdded = false;
                  allInvoices[localIndex].isModified = false;
                  allInvoices[localIndex].isDeleted = false;
                }
              }
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
            (responseForEditingAPInvoice?.statusCode == 200)) {
          showSnackBar('Done', 'Updated Successfully');
        }
      }
      addingNewValue.value = false;
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
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
        showSnackBar('Success', 'AP Invoice deleted successfully');
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        final decoded = jsonDecode(response.body) ?? 'Failed to delete invoice';
        String error = decoded['detail'];
        showSnackBar('Alert', error);
      } else if (response.statusCode == 403) {
        final decoded = jsonDecode(response.body);
        String error = decoded['detail'] ?? 'Only New AP Invoice Allowed';
        showSnackBar('Alert', error);
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
    if (invoiceTypeFilterId.value.isNotEmpty) {
      body["invoice_type"] = invoiceTypeFilterId.value;
    }
    if (referenceNumberFilter.text.isNotEmpty) {
      body["reference_number"] = referenceNumberFilter.text;
    }
    if (vendorFilterId.value.isNotEmpty) {
      body["vandor"] = vendorFilterId.value;
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

  // =======================================================================================================================

  Future<void> loadValues(ApInvoicesModel typeData) async {
    currentApInvoiceId.value = typeData.id ?? '';
    isInvoiceItemsModified.value = false;
    isInvoiceModified.value = false;
    invoiceNumber.text = typeData.invoiceNumber ?? '';
    invoiceDate.text = textToDate(typeData.invoiceDate ?? '');
    invoiceType.text = typeData.invoiceTypeName ?? '';
    allInvoices.assignAll(typeData.items ?? []);
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
    invoiceType.clear();
    invoiceTypeId.value = '';
    referenceNumber.clear();
    transactionDate.clear();
    vendor.clear();
    vendorId.value = '';
    description.clear();
    allInvoices.clear();
    status.value = '';
    calculatedAmountForInvoiceItems.value = 0;
    calculatedVatForInvoiceItems.value = 0;
  }

  Future<void> editPostForApInvoices(String id) async {
    if (status.value.isEmpty) {
      showSnackBar('Alert', 'Please Save The Invoice First');
      return;
    }
    Map invoiceStatus = await getCurrentAPInvoicedStatus(id);
    String status1 = invoiceStatus['status'];

    if (status1 != 'Posted' && status1 != 'Cancelled' && status1.isNotEmpty) {
      status.value = 'Posted';
      isInvoiceModified.value = true;
    } else if (status1 == 'Posted') {
      showSnackBar('Alert', 'AP Invoice is Already Posted');
    } else if (status1 == 'Cancelled') {
      showSnackBar('Alert', 'AP Invoice is Cancelled');
    }
  }

  Future<void> editCancelForApInvoices(String id) async {
    if (status.value.isEmpty) {
      showSnackBar('Alert', 'Please Save The Invoice First');
      return;
    }
    Map invoiceStatus = await getCurrentAPInvoicedStatus(id);
    String status1 = invoiceStatus['status'];

    if (status1 != 'Cancelled' && status1 != 'Posted' && status1.isNotEmpty) {
      status.value = 'Cancelled';
      isInvoiceModified.value = true;
    } else if (status1 == 'Cancelled') {
      showSnackBar('Alert', 'AP Invoice Already Cancelled');
    } else if (status1 == 'Posted') {
      showSnackBar('Alert', 'AP Invoice is Posted');
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
        note: invoiceNote.text,
        transactionType: transactionTypeId.value,
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
        note: invoiceNote.text,
        transactionType: transactionTypeId.value,
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

  void searchEngineForJobCards() {
    query.value = searchForJobCards.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredJobCards.clear();
    } else {
      filteredJobCards.assignAll(
        allJobCards.where((job) {
          return job.jobNumber.toString().toLowerCase().contains(query) ||
              job.carBrandName.toString().toLowerCase().contains(query) ||
              job.carModelName.toString().toLowerCase().contains(query) ||
              job.plateNumber.toString().toLowerCase().contains(query) ||
              job.vehicleIdentificationNumber.toString().toLowerCase().contains(
                query,
              ) ||
              job.customerName.toString().toLowerCase().contains(query);
        }).toList(),
      );
    }
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
