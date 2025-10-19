import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datahubai/Models/quotation%20cards/quotation_cards_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:datahubai/consts.dart';
import 'package:uuid/uuid.dart';
import '../../Models/job cards/internal_notes_model.dart';
import '../../Models/job cards/job_card_invoice_items_model.dart';
import '../../Models/job cards/job_card_model.dart';
import '../../Screens/Main screens/System Administrator/Setup/quotation_card.dart';
import '../../helpers.dart';
import '../Mobile section controllers/cards_screen_controller.dart';
import 'main_screen_contro.dart';
import 'quotation_card_controller.dart';

class JobCardController extends GetxController {
  RxString quotationCounter = RxString('');
  RxString quotationId = RxString('');
  Rx<TextEditingController> jobCardCounter = TextEditingController().obs;
  Rx<TextEditingController> jobCardDate = TextEditingController().obs;
  Rx<TextEditingController> invoiceDate = TextEditingController().obs;
  Rx<TextEditingController> approvalDate = TextEditingController().obs;
  Rx<TextEditingController> startDate = TextEditingController().obs;
  Rx<TextEditingController> finishDate = TextEditingController().obs;
  Rx<TextEditingController> deliveryDate = TextEditingController().obs;
  Rx<TextEditingController> jobWarrentyDays = TextEditingController().obs;
  Rx<TextEditingController> jobWarrentyKM = TextEditingController().obs;
  Rx<TextEditingController> jobWarrentyEndDate = TextEditingController().obs;
  Rx<TextEditingController> jobCancelationDate = TextEditingController().obs;
  Rx<TextEditingController> reference1 = TextEditingController().obs;
  Rx<TextEditingController> reference2 = TextEditingController().obs;
  Rx<TextEditingController> deliveryTime = TextEditingController().obs;
  Rx<TextEditingController> minTestKms = TextEditingController().obs;
  Rx<TextEditingController> invoiceCounter = TextEditingController().obs;
  Rx<TextEditingController> lpoCounter = TextEditingController().obs;
  TextEditingController jobNotes = TextEditingController();
  TextEditingController deliveryNotes = TextEditingController();
  TextEditingController plateNumber = TextEditingController();
  TextEditingController plateCode = TextEditingController();
  TextEditingController carBrand = TextEditingController();
  TextEditingController carModel = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController year = TextEditingController();
  TextEditingController vin = TextEditingController();
  TextEditingController transmissionType = TextEditingController();
  TextEditingController color = TextEditingController();
  TextEditingController engineType = TextEditingController();
  TextEditingController customerName = TextEditingController();
  TextEditingController customerEntityName = TextEditingController();
  TextEditingController customerEntityEmail = TextEditingController();
  TextEditingController customerEntityPhoneNumber = TextEditingController();
  TextEditingController customerCreditNumber = TextEditingController();
  TextEditingController customerOutstanding = TextEditingController();
  RxString customerSaleMan = RxString('');
  TextEditingController customerBranch = TextEditingController();
  TextEditingController customerCurrency = TextEditingController();
  TextEditingController customerCurrencyRate = TextEditingController();
  Rx<TextEditingController> mileageIn = TextEditingController().obs;
  Rx<TextEditingController> fuelAmount = TextEditingController().obs;
  Rx<TextEditingController> mileageOut = TextEditingController().obs;
  Rx<TextEditingController> inOutDiff = TextEditingController().obs;
  RxString carBrandId = RxString('');
  RxString carBrandLogo = RxString('');
  RxString carModelId = RxString('');
  RxString countryId = RxString('');
  RxString colorId = RxString('');
  RxString engineTypeId = RxString('');
  RxString cityId = RxString('');
  RxString customerId = RxString('');
  RxString customerSaleManId = RxString('');
  RxString customerBranchId = RxString('');
  RxString customerCurrencyId = RxString('');
  RxString queryForInvoiceItems = RxString('');
  RxString label = RxString('');
  RxBool isScreenLoding = RxBool(false);
  RxBool loadingInvoiceItems = RxBool(false);
  final RxList<JobCardModel> allJobCards = RxList<JobCardModel>([]);
  final RxList<JobCardModel> historyJobCards = RxList<JobCardModel>([]);
  final RxList<JobCardInvoiceItemsModel> allInvoiceItems =
      RxList<JobCardInvoiceItemsModel>([]);
  final RxList<InternalNotesModel> allInternalNotes =
      RxList<InternalNotesModel>([]);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  RxBool creatingNewQuotation = RxBool(false);
  RxMap companyDetails = RxMap({});
  RxMap allCities = RxMap({});
  RxBool loadingCopyJob = RxBool(false);
  var selectedRowIndex = Rxn<int>();
  var buttonLoadingStates = <String, bool>{}.obs;

  RxMap allModels = RxMap({});
  RxBool isCashSelected = RxBool(true);
  RxBool isCreditSelected = RxBool(false);
  RxString payType = RxString('Cash');
  RxMap allUsers = RxMap();
  RxString jobStatus1 = RxString('');
  RxString jobStatus2 = RxString('');
  RxBool addingNewInternalNotProcess = RxBool(false);
  RxBool jobCardAdded = RxBool(false);
  RxString curreentJobCardId = RxString('');
  RxBool canAddInternalNotesAndInvoiceItems = RxBool(false);
  final ScrollController scrollController = ScrollController();
  final ScrollController scrollControllerFotTable1 = ScrollController();
  final ScrollController scrollControllerFotTable2 = ScrollController();
  Rx<TextEditingController> internalNote = TextEditingController().obs;
  RxString noteMessage = RxString('');
  final ScrollController scrollControllerForNotes = ScrollController();
  FocusNode textFieldFocusNode = FocusNode();
  Rx<Uint8List?> fileBytes = Rx<Uint8List?>(null);
  RxString fileType = RxString('');
  RxString fileName = RxString('');
  RxString imageUrl = RxString('');
  RxString pdfUrl = RxString('');
  // invoice items section
  final GlobalKey<FormState> formKeyForInvoiceItems = GlobalKey<FormState>();
  RxBool addingNewinvoiceItemsValue = RxBool(false);
  TextEditingController invoiceItemName = TextEditingController();
  RxString invoiceItemNameId = RxString('');
  TextEditingController lineNumber = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController discount = TextEditingController();
  TextEditingController total = TextEditingController();
  TextEditingController vat = TextEditingController();
  RxString currentCountryVAT = RxString('');
  TextEditingController net = TextEditingController();
  CardsScreenController controller = Get.put(CardsScreenController());
  RxBool openingQuotationCardScreen = RxBool(false);
  RxInt numberOfJobs = RxInt(0);
  RxDouble allJobsVATS = RxDouble(0.0);
  RxDouble allJobsTotals = RxDouble(0.0);
  RxDouble allJobsNET = RxDouble(0.0);
  DocumentSnapshot? lastDocument;
  bool hasMore = true;
  RxBool isYearSelected = RxBool(false);
  RxBool isMonthSelected = RxBool(false);
  RxBool isDaySelected = RxBool(false);
  RxBool isTodaySelected = RxBool(false);
  RxBool isAllSelected = RxBool(false);
  RxBool isThisMonthSelected = RxBool(false);
  RxBool isThisYearSelected = RxBool(false);
  // search section
  Rx<TextEditingController> jobNumberFilter = TextEditingController().obs;
  Rx<TextEditingController> invoiceNumberFilter = TextEditingController().obs;
  Rx<TextEditingController> carBrandIdFilterName = TextEditingController().obs;
  RxString carBrandIdFilter = RxString('');
  RxString carModelIdFilter = RxString('');
  RxString customerNameIdFilter = RxString('');
  Rx<TextEditingController> carModelIdFilterName = TextEditingController().obs;
  Rx<TextEditingController> customerNameIdFilterName =
      TextEditingController().obs;
  Rx<TextEditingController> plateNumberFilter = TextEditingController().obs;
  Rx<TextEditingController> vinFilter = TextEditingController().obs;
  Rx<TextEditingController> fromDate = TextEditingController().obs;
  Rx<TextEditingController> toDate = TextEditingController().obs;
  Rx<TextEditingController> statusFilter = TextEditingController().obs;
  final Uuid _uuid = const Uuid();
  String backendUrl = backendTestURI;
  RxBool isJobModified = RxBool(false);
  RxBool isJobInvoicesModified = RxBool(false);
  RxBool isJobInternalNotesLoading = RxBool(false);
  @override
  void onInit() async {
    super.onInit();
    searchEngine({"today": true});
    await getCompanyDetails();
    jobWarrentyEndDate.value.addListener(() {
      jobWarrentyEndDate.refresh();
    });
    getInvoiceItemsFromCollection();
    getAllUsers();
  }

  @override
  void onClose() {
    textFieldFocusNode.dispose();
    super.onClose();
  }

  Future<Map<String, dynamic>> getColors() async {
    return await helper.getAllListValues('COLORS');
  }

  Future<Map<String, dynamic>> getEngineTypes() async {
    return await helper.getAllListValues('ENGINE_TYPES');
  }

  Future<Map<String, dynamic>> getCarBrands() async {
    return await helper.getCarBrands();
  }

  Future<void> getModelsByCarBrand(String brandID) async {
    allModels.assignAll(await helper.getModelsValues(brandID));
  }

  Future<Map<String, dynamic>> getCountries() async {
    return await helper.getCountries();
  }

  Future<void> getCitiesByCountryID(String countryID) async {
    allCities.assignAll(await helper.getCitiesValues(countryID));
  }

  Future<Map<String, dynamic>> getSalesMan() async {
    return await helper.getSalesMan();
  }

  Future<Map<String, dynamic>> getCurrencies() async {
    return await helper.getCurrencies();
  }

  Future<void> getCompanyDetails() async {
    companyDetails.assignAll(await helper.getCurrentCompanyDetails());
  }

  Future<Map<String, dynamic>> getBranches() async {
    return await helper.getBrunches();
  }

  Future<Map<String, dynamic>> getAllCustomers() async {
    return await helper.getCustomers();
  }

  Future<void> getAllUsers() async {
    allUsers.assignAll(await helper.getSysUsers());
  }

  Future<Map<String, dynamic>> getInvoiceItemsFromCollection() async {
    return await helper.getInvoiceItems();
  }

  Future getCurrentJobCardStatus(String id) async {
    return await helper.getJobCardStatus(id);
  }

  Future<void> addNewJobCard() async {
    try {
      if (curreentJobCardId.isNotEmpty) {
        Map jobStatus = await getCurrentJobCardStatus(curreentJobCardId.value);
        String status1 = jobStatus['job_status_1'];
        if (status1 != 'New' && status1 != '') {
          showSnackBar('Alert', 'Only new jobs can be edited');
          return;
        }
      }
      addingNewValue.value = true;
      Map<String, dynamic> newData = {
        'label': '',
        'job_status_1': jobStatus1.value,
        'job_status_2': jobStatus2.value,
        'car_brand_logo': carBrandLogo.value,
        'car_brand': carBrandId.value,
        'car_model': carModelId.value,
        'plate_number': plateNumber.text,
        'plate_code': plateCode.text,
        'country': countryId.value,
        'city': cityId.value,
        'year': year.text,
        'color': colorId.value,
        'engine_type': engineTypeId.value,
        'vehicle_identification_number': vin.text,
        'transmission_type': transmissionType.text,
        'mileage_in': double.tryParse(mileageIn.value.text) ?? 0,
        'mileage_out': double.tryParse(mileageOut.value.text) ?? 0,
        'fuel_amount': double.tryParse(fuelAmount.value.text) ?? 0,
        'mileage_in_out_diff': double.tryParse(inOutDiff.value.text) ?? 0,
        'customer': customerId.value,
        'contact_name': customerEntityName.text,
        'contact_number': customerEntityPhoneNumber.text,
        'contact_email': customerEntityEmail.text,
        'credit_limit': double.tryParse(customerCreditNumber.text) ?? 0,
        'outstanding': double.tryParse(customerOutstanding.text) ?? 0,
        'salesman': customerSaleManId.value,
        'branch': customerBranchId.value,
        'currency': customerCurrencyId.value,
        'rate': double.tryParse(customerCurrencyRate.text) ?? 0,
        'payment_method': payType.value,
        'lpo_number': lpoCounter.value.text,
        'job_approval_date': convertDateToIson(approvalDate.value.text),
        'job_start_date': convertDateToIson(startDate.value.text),
        'job_cancellation_date': convertDateToIson(
          jobCancelationDate.value.text,
        ),
        'job_finish_date': convertDateToIson(finishDate.value.text),
        'job_delivery_date': convertDateToIson(deliveryDate.value.text),
        'job_warranty_end_date': convertDateToIson(
          jobWarrentyEndDate.value.text,
        ),
        'job_warranty_days': int.tryParse(jobWarrentyDays.value.text) ?? 0,
        'job_warranty_km': double.tryParse(jobWarrentyKM.value.text) ?? 0,
        'job_min_test_km': double.tryParse(minTestKms.value.text) ?? 0,
        'job_reference_1': reference1.value.text,
        'job_reference_2': reference2.value.text,
        'delivery_time': deliveryTime.value.text,
        'job_notes': jobNotes.text,
        'job_delivery_notes': deliveryNotes.text,
        'invoice_number': invoiceCounter.value.text,
        'invoice_items': allInvoiceItems.map((item) => item.toJson()).toList(),
      };

      final rawDate = jobCardDate.value.text.trim();
      if (rawDate.isNotEmpty) {
        try {
          newData['job_date'] = convertDateToIson(rawDate);
        } catch (e) {
          showSnackBar('Alert', 'Please enter valid job date');
        }
      }

      final rawDate2 = invoiceDate.value.text.trim();
      if (rawDate2.isNotEmpty) {
        try {
          newData['invoice_date'] = convertDateToIson(rawDate2);
        } catch (e) {
          showSnackBar('Alert', 'Please enter valid invoice date');
        }
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri addingJobUrl = Uri.parse('$backendUrl/job_cards/add_new_job_card');

      if (jobCardAdded.isFalse && curreentJobCardId.isEmpty) {
        showSnackBar('Adding', 'Please Wait');
        newData['job_status_1'] = 'New';
        newData['job_status_2'] = 'New';
        final response = await http.post(
          addingJobUrl,
          headers: {
            'Authorization': 'Bearer $accessToken',
            "Content-Type": "application/json",
          },
          body: jsonEncode(newData),
        );
        if (response.statusCode == 200) {
          jobStatus1.value = 'New';
          jobStatus2.value = 'New';
          final decoded = jsonDecode(response.body);
          JobCardModel newJob = JobCardModel.fromJson(decoded['job_card']);
          jobCardCounter.value.text = newJob.jobNumber ?? '';
          jobCardAdded.value = true;
          addingNewValue.value = false;
          curreentJobCardId.value = newJob.id ?? '';
          allInvoiceItems.value = newJob.invoiceItemsDetails ?? [];
          isJobInvoicesModified.value = false;
          isJobModified.value = false;
          showSnackBar('Done', 'Job Added Successfully');
        } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
          final refreshed = await helper.refreshAccessToken(refreshToken);
          if (refreshed == RefreshResult.success) {
            await addNewJobCard();
          } else if (refreshed == RefreshResult.invalidToken) {
            logout();
          }
        } else if (response.statusCode == 401) {
          logout();
        }
      } else {
        if (isJobInvoicesModified.isTrue || isJobModified.isTrue) {
          showSnackBar('Updating', 'Please Wait');
        }
        if (isJobModified.isTrue) {
          Uri updatingJobUrl = Uri.parse(
            '$backendUrl/job_cards/update_job_card/$curreentJobCardId',
          );
          Map newDataToUpdate = newData;
          newDataToUpdate.remove('invoice_items');
          final response = await http.patch(
            updatingJobUrl,
            headers: {
              'Authorization': 'Bearer $accessToken',
              "Content-Type": "application/json",
            },
            body: jsonEncode(newDataToUpdate),
          );
          if (response.statusCode == 200) {
            showSnackBar('Done', 'Updated Successfully');
            isJobModified.value = false;
          } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
            final refreshed = await helper.refreshAccessToken(refreshToken);
            if (refreshed == RefreshResult.success) {
              await addNewJobCard();
            } else if (refreshed == RefreshResult.invalidToken) {
              logout();
            }
          } else if (response.statusCode == 401) {
            logout();
          }
        }
        if (isJobInvoicesModified.isTrue) {
          Uri updatingJobInvoicesUrl = Uri.parse(
            '$backendUrl/job_cards/update_job_invoice_items',
          );
          final response = await http.patch(
            updatingJobInvoicesUrl,
            headers: {
              'Authorization': 'Bearer $accessToken',
              "Content-Type": "application/json",
            },
            body: jsonEncode(
              allInvoiceItems
                  .where(
                    (item) =>
                        (item.isModified == true ||
                        item.added == true ||
                        (item.deleted == true && item.id != null)),
                  )
                  .map((item) => item.toJson())
                  .toList(),
            ),
          );
          if (response.statusCode == 200) {
            final decoded = jsonDecode(response.body);
            List updatedItems = decoded['updated_items'];
            List deletedItems = decoded['deleted_items'];
            if (deletedItems.isNotEmpty) {
              for (var id in deletedItems) {
                allInvoiceItems.removeWhere((item) => item.id == id);
              }
            }
            if (updatedItems.isNotEmpty) {
              for (var item in updatedItems) {
                var uid = item['uid'];
                var id = item['_id'];
                final localIndex = allInvoiceItems.indexWhere(
                  (item) => item.uid == uid,
                );

                if (localIndex != -1) {
                  allInvoiceItems[localIndex].id = id;
                  allInvoiceItems[localIndex].added = false;
                  allInvoiceItems[localIndex].isModified = false;
                  allInvoiceItems[localIndex].deleted = false;
                }
              }
            }
            showSnackBar('Done', 'Updated Successfully');
            isJobInvoicesModified.value = false;
          } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
            final refreshed = await helper.refreshAccessToken(refreshToken);
            if (refreshed == RefreshResult.success) {
              await addNewJobCard();
            } else if (refreshed == RefreshResult.invalidToken) {
              logout();
            }
          } else if (response.statusCode == 401) {
            logout();
          }
        }
      }
      canAddInternalNotesAndInvoiceItems.value = true;
      addingNewValue.value = false;
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
      addingNewValue.value = false;
    }
  }

  Future<void> deleteJobCard(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/job_cards/delete_job_card/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        String deletedJobId = decoded['job_id'];
        allJobCards.removeWhere((job) => job.id == deletedJobId);
        numberOfJobs.value -= 1;
        Get.close(2);
        showSnackBar('Success', 'Job card deleted successfully');
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        final decoded =
            jsonDecode(response.body) ?? 'Failed to delete job card';
        String error = decoded['detail'];
        showSnackBar('Alert', error);
      } else if (response.statusCode == 403) {
        final decoded = jsonDecode(response.body);
        String error = decoded['detail'] ?? 'Only New Job Cards Allowed';
        showSnackBar('Alert', error);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteJobCard(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 500) {
        final decoded = jsonDecode(response.body);
        final error =
            decoded['detail'] ?? 'Server error while deleting job card';
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
    if (carBrandIdFilter.value.isNotEmpty) {
      body["car_brand"] = carBrandIdFilter.value;
    }
    if (carModelIdFilter.value.isNotEmpty) {
      body["car_model"] = carModelIdFilter.value;
    }
    if (jobNumberFilter.value.text.isNotEmpty) {
      body["job_number"] = jobNumberFilter.value.text;
    }
    if (invoiceNumberFilter.value.text.isNotEmpty) {
      body["invoice_number"] = invoiceNumberFilter.value.text;
    }
    if (plateNumberFilter.value.text.isNotEmpty) {
      body["plate_number"] = plateNumberFilter.value.text;
    }
    if (vinFilter.value.text.isNotEmpty) {
      body["vin"] = vinFilter.value.text;
    }
    if (statusFilter.value.text.isNotEmpty) {
      body["status"] = statusFilter.value.text;
    }
    if (customerNameIdFilter.value.isNotEmpty) {
      body["customer_name"] = customerNameIdFilter.value;
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
      Uri url = Uri.parse('$backendUrl/job_cards/search_engine_for_job_cards');
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
        List jobs = decoded['job_cards'];
        Map grandTotals = decoded['grand_totals'];
        allJobsTotals.value = grandTotals['grand_total'];
        allJobsVATS.value = grandTotals['grand_vat'];
        allJobsNET.value = grandTotals['grand_net'];
        // print(jobs[0]);
        allJobCards.assignAll(jobs.map((job) => JobCardModel.fromJson(job)));
        numberOfJobs.value = allJobCards.length;
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

  void addNewInvoiceItem() {
    final String uniqueId = _uuid.v4();

    allInvoiceItems.add(
      JobCardInvoiceItemsModel(
        added: true,
        uid: uniqueId,
        nameId: invoiceItemNameId.value,
        name: invoiceItemName.text,
        lineNumber: int.tryParse(lineNumber.text) ?? 0,
        description: description.text,
        quantity: int.tryParse(quantity.text) ?? 0,
        price: double.tryParse(price.text) ?? 0.0,
        amount: double.tryParse(amount.text) ?? 0.0,
        discount: double.tryParse(discount.text) ?? 0.0,
        total: double.tryParse(total.text) ?? 0.0,
        vat: double.tryParse(vat.text) ?? 0.0,
        net: double.tryParse(net.text) ?? 0.0,
        jobId: curreentJobCardId.value,
      ),
    );
    isJobInvoicesModified.value = true;
    Get.back();
  }

  Future<void> deleteInvoiceItem(String itemId) async {
    int index = allInvoiceItems.indexWhere(
      (item) => (item.id == itemId || item.uid == itemId),
    );
    allInvoiceItems[index].deleted = true;
    allInvoiceItems.refresh();
    isJobInvoicesModified.value = true;
    Get.back();
  }

  Future<void> editInvoiceItem(String itemId) async {
    int index = allInvoiceItems.indexWhere(
      (item) => (item.id == itemId || item.uid == itemId),
    );
    final oldItem = allInvoiceItems[index];

    if (index != -1) {
      allInvoiceItems[index] = JobCardInvoiceItemsModel(
        id: oldItem.id,
        uid: oldItem.uid,
        nameId: invoiceItemNameId.value,
        name: invoiceItemName.text,
        lineNumber: int.tryParse(lineNumber.text) ?? 0,
        description: description.text,
        quantity: int.tryParse(quantity.text) ?? 0,
        price: double.tryParse(price.text) ?? 0.0,
        amount: double.tryParse(amount.text) ?? 0.0,
        discount: double.tryParse(discount.text) ?? 0.0,
        total: double.tryParse(total.text) ?? 0.0,
        vat: double.tryParse(vat.text) ?? 0.0,
        net: double.tryParse(net.text) ?? 0.0,
        isModified: true,
      );
    }
    isJobInvoicesModified.value = true;

    Get.back();
  }

  Future copyJob(String id) async {
    try {
      Map jobStatus = await getCurrentJobCardStatus(id);
      final status1 = jobStatus['job_status_1'];
      if (status1 == 'New' || status1 == 'Approved' || status1 == 'Ready') {
        showSnackBar('Alert', 'Only Posted / Cancelled Jobs Can be Copied');
        return;
      }
      Get.back();
      showSnackBar('Copying', 'Please Wait');

      loadingCopyJob.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/job_cards/copy_job_card/$id');
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        var copiedJobData = decoded['copied_job'];
        JobCardModel copiedJob = JobCardModel.fromJson(copiedJobData);
        allJobCards.add(copiedJob);
        return copiedJob;
      } else if (response.statusCode == 403) {
        final decoded = jsonDecode(response.body);
        String error = decoded['detail'];
        showSnackBar('Alert', error);
      } else if (response.statusCode == 404) {
        final decoded = jsonDecode(response.body);
        String error = decoded['detail'];
        showSnackBar('Alert', error);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await copyJob(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }

      loadingCopyJob.value = false;
    } catch (e) {
      loadingCopyJob.value = false;
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  Future<void> getJobCardInternalNotes(String jobId) async {
    try {
      isJobInternalNotesLoading.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/job_cards/get_all_internal_notes_for_job_card/$jobId',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List jobInternalNotes = decoded['internal_notes'];
        allInternalNotes.assignAll(
          jobInternalNotes.map((note) => InternalNotesModel.fromJson(note)),
        );
      } else if (response.statusCode == 403) {
        final decoded = jsonDecode(response.body);
        String error = decoded['detail'];
        showSnackBar('Alert', error);
      } else if (response.statusCode == 404) {
        final decoded = jsonDecode(response.body);
        String error = decoded['detail'];
        showSnackBar('Alert', error);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getJobCardInternalNotes(jobId);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      isJobInternalNotesLoading.value = false;
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
      isJobInternalNotesLoading.value = false;
    }
  }

  Future<void> addNewInternalNote(
    String jobId,
    Map<String, dynamic> note,
  ) async {
    try {
      addingNewInternalNotProcess.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/job_cards/add_new_internal_note_for_job_card/$jobId',
      );
      final request = http.MultipartRequest('POST', url);
      request.headers.addAll({
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'multipart/form-data',
      });
      if (note.containsKey('note_type')) {
        if (note['note_type'] == 'text') {
          request.fields['note'] = note['note'];
          request.fields['note_type'] = note['note_type'];
        } else {
          request.fields['file_name'] = note['file_name'];
          request.fields['note_type'] = note['note_type'];
          request.files.add(
            http.MultipartFile.fromBytes(
              'media_note',
              note['media_note'],
              filename: note['file_name'],
            ),
          );
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        Map<String, dynamic> data = decoded['new_internal_note'];
        allInternalNotes.add(InternalNotesModel.fromJson(data));
      } else if (response.statusCode == 403) {
        final decoded = jsonDecode(response.body);
        String error = decoded['detail'];
        showSnackBar('Alert', error);
      } else if (response.statusCode == 404) {
        final decoded = jsonDecode(response.body);
        String error = decoded['detail'];
        showSnackBar('Alert', error);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewInternalNote(jobId, note);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      addingNewInternalNotProcess.value = false;
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
      addingNewInternalNotProcess.value = false;
    }
  }

  Future<void> createQuotationCard(String id) async {
    try {
      Map quotationStatus = await getCurrentJobCardStatus(id);
      final status1 = quotationStatus['job_status_1'];
      if (status1 != 'Posted') {
        showSnackBar('Alert', 'Only Posted Jobs Allowed');
        return;
      }
      creatingNewQuotation.value = true;
      showSnackBar('Creating', 'Please wait');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/job_cards/create_quotation_card_for_current_job/$id',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'multipart/form-data',
        },
      );
      if (response.statusCode == 200) {
        showSnackBar('Done', 'Quotation created successfully');
        final decoded = jsonDecode(response.body);
        quotationCounter.value = decoded['quotation_number'];
        quotationId.value = decoded['quotation_card_id'];
      } else if (response.statusCode == 409) {
        final decoded = jsonDecode(response.body);
        showSnackBar('Alert', decoded['detail']);
      } else if (response.statusCode == 403) {
        final decoded = jsonDecode(response.body);
        String error = decoded['detail'];
        showSnackBar('Alert', error);
      } else if (response.statusCode == 404) {
        final decoded = jsonDecode(response.body);
        String error = decoded['detail'];
        showSnackBar('Alert', error);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await createQuotationCard(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      creatingNewQuotation.value = false;
    } catch (e) {
      creatingNewQuotation.value = false;
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  // Future<void> createQuotationCard(String jobId) async {
  //   try {
  //     showSnackBar('Creating', 'Please Wait');
  //     creatingNewQuotation.value = true;
  //     Map<String, dynamic> newData = {
  //       'quotation_status': 'New',
  //       'car_brand_logo': carBrandLogo.value,
  //       'car_brand': carBrandId.value,
  //       'car_model': carModelId.value,
  //       'plate_number': plateNumber.text,
  //       'plate_code': plateCode.text,
  //       'country': countryId.value,
  //       'city': cityId.value,
  //       'year': year.text,
  //       'color': colorId.value,
  //       'engine_type': engineTypeId.value,
  //       'vehicle_identification_number': vin.text,
  //       'transmission_type': transmissionType.text,
  //       'mileage_in': mileageIn.value.text,
  //       'mileage_out': mileageOut.value.text,
  //       'mileage_in_out_diff': inOutDiff.value.text,
  //       'customer': customerId.value,
  //       'contact_name': customerEntityName.text,
  //       'contact_number': customerEntityPhoneNumber.text,
  //       'contact_email': customerEntityEmail.text,
  //       'credit_limit': customerCreditNumber.text,
  //       'outstanding': customerOutstanding.text,
  //       'saleMan': customerSaleManId.value,
  //       'branch': customerBranchId.value,
  //       'currency': customerCurrencyId.value,
  //       'rate': customerCurrencyRate.text,
  //       'payment_method': payType.value,
  //       'quotation_number': quotationCounter.value,
  //       'quotation_date': '',
  //       'validity_days': '',
  //       'validity_end_date': '',
  //       'reference_number': '',
  //       'delivery_time': '',
  //       'quotation_warrenty_days': jobWarrentyDays.value.text,
  //       'quotation_warrenty_km': jobWarrentyKM.value.text,
  //       'quotation_notes': '',
  //     };

  //     // await getCurrentQuotationCounterNumber();
  //     newData['quotation_number'] = quotationCounter.value;
  //     newData['added_date'] = DateTime.now().toString();
  //     var newQuotation = await FirebaseFirestore.instance
  //         .collection('quotation_cards')
  //         .add(newData);

  //     // for (var element in allInvoiceItems) {
  //     //   var data = element.data();
  //     //   await FirebaseFirestore.instance
  //     //       .collection('quotation_cards')
  //     //       .doc(newQuotation.id)
  //     //       .collection('invoice_items')
  //     //       .add(data);
  //     // }
  //     await FirebaseFirestore.instance
  //         .collection('job_cards')
  //         .doc(jobId)
  //         .update({'quotation_id': newQuotation.id});
  //     showSnackBar('Done', 'Quotation Created Successfully');

  //     creatingNewQuotation.value = false;
  //   } catch (e) {
  //     creatingNewQuotation.value = false;
  //     showSnackBar('Alert', 'Something Went Wrong');
  //   }
  // }

  Future<void> editApproveForJobCard(String jobId, String status) async {
    if (jobStatus1.value.isEmpty) {
      showSnackBar('Alert', 'Please Save The Job First');
      return;
    }
    Map jobStatus = await getCurrentJobCardStatus(jobId);
    String status1 = jobStatus['job_status_1'];
    String status2 = jobStatus['job_status_2'];
    if (status1 == 'New' && status2 != 'Approved') {
      approvalDate.value.text = textToDate(DateTime.now());
      jobStatus2.value = 'Approved';
      isJobModified.value = true;
    } else if (status2 == 'Approved') {
      showSnackBar('Alert', 'Job is Already Approved');
    } else if (status1 == 'Posted') {
      showSnackBar('Alert', 'Job is Posted');
    } else if (status1 == 'Cancelled') {
      showSnackBar('Alert', 'Job is Cancelled');
    }
  }

  // ===============================================================================================================
  void changejobWarrentyEndDateDependingOnWarrentyDays() {
    DateTime date = format.parse(deliveryDate.value.text);
    DateTime newDate = date.add(
      Duration(days: int.parse(jobWarrentyDays.value.text)),
    );
    jobWarrentyEndDate.value.text = format.format(newDate);
  }

  Future<void> openQuotationCardScreenByNumber(String id) async {
    try {
      openingQuotationCardScreen.value = true;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/job_cards/open_quotation_card_screen_by_quotation_number_for_job/$id',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        QuotationCardsModel requiredQuotation = QuotationCardsModel.fromJson(
          decoded['required_quotation'],
        );
        QuotationCardController quotationCardController = Get.put(
          QuotationCardController(),
        );
        await quotationCardController.loadValues(requiredQuotation);
        await editQuotationCardDialog(
          quotationCardController,
          requiredQuotation,
          id,
          screenName: '🧾 Quotation',
          headerColor: Colors.deepPurple,
        );
      } else if (response.statusCode == 403) {
        final decoded = jsonDecode(response.body);
        String error = decoded['detail'];
        showSnackBar('Alert', error);
      } else if (response.statusCode == 404) {
        final decoded = jsonDecode(response.body);
        String error = decoded['detail'];
        showSnackBar('Alert', error);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await openQuotationCardScreenByNumber(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      openingQuotationCardScreen.value = false;
    } catch (e) {
      openingQuotationCardScreen.value = false;
    }
  }

  // Future<void> openQuotationCardScreenByNumber() async {
  //   try {
  //     openingQuotationCardScreen.value = true;
  //     QuotationCardController quotationCardController = Get.put(
  //       QuotationCardController(),
  //     );
  //     var quotation = await FirebaseFirestore.instance
  //         .collection('quotation_cards')
  //         .where('quotation_number', isEqualTo: quotationCounter.value)
  //         .get();
  //     var id = quotation.docs.first.id;
  //     // var data = quotation.docs.first.data();

  //     // quotationCardController.getAllInvoiceItems(id);
  //     // await quotationCardController.loadValues(data, id);
  //     // showSnackBar('Done', 'Opened Successfully');
  //     // await editQuotationCardDialog(
  //     //   quotationCardController,
  //     //   data,
  //     //   id,
  //     //   screenName: '🧾 Quotation',
  //     //   headerColor: Colors.deepPurple,
  //     // );
  //     openingQuotationCardScreen.value = false;
  //   } catch (e) {
  //     openingQuotationCardScreen.value = false;
  //     showSnackBar('Alert', 'Something Went Wrong');
  //   }
  // }

  // function to manage loading button
  void setButtonLoading(String menuId, bool isLoading) {
    buttonLoadingStates[menuId] = isLoading;
    buttonLoadingStates.refresh();
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  void selectForHistory(String vin) {
    // historyJobCards.assignAll(
    //   allJobCards.where((job) {
    //     final data = job.data() as Map<String, dynamic>?;
    //     if (data?['vehicle_identification_number'] != '') {
    //       return data?['vehicle_identification_number'] == vin;
    //     } else {
    //       return false;
    //     }
    //   }).toList(),
    // );
  }

  List<double> calculateTotals() {
    double sumofTotal = 0.0;
    double sumofVAT = 0.0;
    double sumofNET = 0.0;

    for (var job in allInvoiceItems.where((item) => item.deleted != true)) {
      sumofTotal += job.total ?? 0;
      sumofNET += job.net ?? 0;
      sumofVAT += job.vat ?? 0;
    }

    return [sumofTotal, sumofVAT, sumofNET];
  }

  void updateCalculating() {
    if (price.text.isEmpty) price.text = '0';
    if (quantity.text.isEmpty) quantity.text = '0';
    if (discount.text.isEmpty) discount.text = '0';
    if (vat.text.isEmpty) vat.text = '0';
    final currwnQquanity = int.tryParse(quantity.text) ?? 0;
    final currentPrice = double.tryParse(price.text) ?? 0.0;
    final currentDiscount = double.tryParse(discount.text) ?? 0.0;
    amount.text = (currwnQquanity * currentPrice).toStringAsFixed(2);
    total.text = (double.tryParse(amount.text)! - currentDiscount)
        .toStringAsFixed(2);
    vat.text =
        ((double.tryParse(total.text))! *
                (double.parse(currentCountryVAT.value)) /
                100)
            .toStringAsFixed(2);
    net.text = (double.tryParse(total.text)! + double.tryParse(vat.text)!)
        .toStringAsFixed(2);
  }

  void updateAmount() {
    if (net.text.isEmpty) net.text = '0';
    if (net.text != '0') {
      total.text =
          (double.tryParse(net.text)! /
                  (1 + double.tryParse(currentCountryVAT.value)! / 100))
              .toStringAsFixed(2);
      amount.text =
          (double.tryParse(total.text)! + double.tryParse(discount.text)!)
              .toStringAsFixed(2);
      price.text =
          (double.tryParse(amount.text)! / double.tryParse(quantity.text)!)
              .toStringAsFixed(2);
      vat.text =
          ((double.tryParse(total.text))! *
                  (double.parse(currentCountryVAT.value)) /
                  100)
              .toStringAsFixed(2);
    }

    // vat.text =
    //     (double.tryParse(net.text)! - double.tryParse(total.text)!).toString();
  }

  void clearInvoiceItemsVariables() {
    invoiceItemName.clear();
    invoiceItemNameId.value = '';
    lineNumber.clear();
    description.clear();
    quantity.text = '1';
    price.text = '0';
    amount.text = '0';
    discount.text = '0';
    total.text = '0';
    vat.text = '0';
    net.text = '0';
  }

  void clearValues() {
    quotationId.value = '';
    currentCountryVAT.value = companyDetails.containsKey('country_vat')
        ? companyDetails['country_vat'].toString()
        : "";
    country.text = companyDetails.containsKey('country')
        ? companyDetails['country'] ?? ""
        : "";
    countryId.value = companyDetails.containsKey('country_id')
        ? companyDetails['country_id'] ?? ""
        : "";
    getCitiesByCountryID(companyDetails['country_id']);
    jobCardDate.value.text = textToDate(DateTime.now());
    invoiceDate.value.text = textToDate(DateTime.now());
    startDate.value.text = textToDate(DateTime.now());
    customerCurrencyId.value = companyDetails.containsKey('currency_id')
        ? companyDetails['currency_id'] ?? ""
        : "";
    customerCurrencyRate.text = companyDetails.containsKey('currency_rate')
        ? companyDetails['currency_rate'].toString()
        : "";
    customerCurrency.text = companyDetails.containsKey('currency_code')
        ? companyDetails['currency_code'] ?? ""
        : "";
    mileageIn.value.text = '0';
    mileageOut.value.text = '0';
    inOutDiff.value.text = '0';
    customerCreditNumber.text = '0';
    customerOutstanding.text = '0';
    isCashSelected.value = true;
    payType.value = 'Cash';
    canAddInternalNotesAndInvoiceItems.value = false;
    quotationCounter.value = '';
    allInvoiceItems.clear();
    jobCancelationDate.value.text = '';
    jobStatus1.value = '';
    jobStatus2.value = '';
    carBrandLogo.value = '';
    allModels.clear();
    jobCardCounter.value.clear();
    invoiceCounter.value.clear();
    curreentJobCardId.value = '';
    jobCardAdded.value = false;
    carBrand.clear();
    carBrandId.value = '';
    carModel.clear();
    carModelId.value = '';
    plateNumber.clear();
    plateCode.clear();
    city.clear();
    year.clear();
    color.clear();
    engineType.clear();
    colorId.value = '';
    engineTypeId.value = '';
    vin.clear();
    transmissionType.clear();
    customerName.clear();
    customerId.value = '';
    customerEntityName.clear();
    customerEntityPhoneNumber.clear();
    customerEntityEmail.clear();
    customerSaleManId.value = '';
    customerSaleMan.value = '';
    customerBranchId.value = '';
    customerBranch.clear();
    lpoCounter.value.clear();
    approvalDate.value.clear();
    finishDate.value.clear();
    deliveryDate.value.clear();
    jobWarrentyDays.value.text = '0';
    jobWarrentyKM.value.text = '0';
    jobWarrentyEndDate.value.clear();
    minTestKms.value.clear();
    reference1.value.clear();
    reference2.value.clear();
    deliveryTime.value.clear();
    jobNotes.clear();
    deliveryNotes.clear();
  }

  void loadInspectionFormValues(String id, JobCardModel data) {
    // controller.imagesList.clear();
    // controller.currenyJobId.value = id;
    // controller.inEditMode.value = true;
    // controller.inEditMode.value = true;
    // controller.technicianId.value = data.technician ?? '';
    // controller.date.text = textToDate(data.date);
    // controller.customer.text = customerName.text;
    // controller.customerId.value = data.customer ?? '';
    // controller.brand.text = carBrand.text;
    // controller.brandId.value = data.carBrand ?? '';
    // controller.model.text = carModel.text;
    // controller.modelId.value = data.carModel ?? '';
    // controller.color.text = color.text;
    // controller.colorId.value = data.color ?? '';
    // controller.plateNumber.text = plateNumber.text;
    // controller.code.text = data.plateCode ?? '';
    // controller.engineType.text = engineType.text;
    // controller.year.text = data.year ?? '';
    // controller.mileage.text = data.mileageIn.toString();
    // controller.vin.text = data.vehicleIdentificationNumber??'';
    // controller.comments.text = data['inspection_report_comments'] ?? '';
    // controller.selectedCheckBoxIndicesForLeftFront.assignAll(
    //   (data['left_front_wheel'] as Map<String, dynamic>?)?.map(
    //         (key, value) => MapEntry(
    //           key,
    //           Map<String, String>.from(value as Map), // Explicit conversion
    //         ),
    //       ) ??
    //       {},
    // );
    // controller.leftFrontBrakeLining.text =
    //     controller
    //         .selectedCheckBoxIndicesForLeftFront['Brake Lining']?['value'] ??
    //     '';
    // controller.leftFrontTireTread.text =
    //     controller
    //         .selectedCheckBoxIndicesForLeftFront['Tire Tread']?['value'] ??
    //     '';

    // controller.leftFrontWearPattern.text =
    //     controller
    //         .selectedCheckBoxIndicesForLeftFront['Wear Pattern']?['value'] ??
    //     '';
    // controller.leftFrontTirePressureBefore.text =
    //     controller
    //         .selectedCheckBoxIndicesForLeftFront['Tire Pressure PSI']?['before'] ??
    //     '';
    // controller.leftFrontTirePressureAfter.text =
    //     controller
    //         .selectedCheckBoxIndicesForLeftFront['Tire Pressure PSI']?['after'] ??
    //     '';

    // controller.selectedCheckBoxIndicesForRightFront.value =
    //     (data['right_front_wheel'] as Map<String, dynamic>?)?.map(
    //       (key, value) => MapEntry(key, Map<String, String>.from(value as Map)),
    //     ) ??
    //     {};

    // controller.rightFrontBrakeLining.text =
    //     controller
    //         .selectedCheckBoxIndicesForRightFront['Brake Lining']?['value'] ??
    //     '';
    // controller.rightFrontTireTread.text =
    //     controller
    //         .selectedCheckBoxIndicesForRightFront['Tire Tread']?['value'] ??
    //     '';

    // controller.rightFrontWearPattern.text =
    //     controller
    //         .selectedCheckBoxIndicesForRightFront['Wear Pattern']?['value'] ??
    //     '';
    // controller.rightFrontTirePressureBefore.text =
    //     controller
    //         .selectedCheckBoxIndicesForRightFront['Tire Pressure PSI']?['before'] ??
    //     '';
    // controller.rightFrontTirePressureAfter.text =
    //     controller
    //         .selectedCheckBoxIndicesForRightFront['Tire Pressure PSI']?['after'] ??
    //     '';

    // controller.selectedCheckBoxIndicesForLeftRear.value =
    //     (data['left_rear_wheel'] as Map<String, dynamic>?)?.map(
    //       (key, value) => MapEntry(key, Map<String, String>.from(value as Map)),
    //     ) ??
    //     {};

    // controller.leftRearBrakeLining.text =
    //     controller
    //         .selectedCheckBoxIndicesForLeftRear['Brake Lining']?['value'] ??
    //     '';
    // controller.leftRearTireTread.text =
    //     controller.selectedCheckBoxIndicesForLeftRear['Tire Tread']?['value'] ??
    //     '';

    // controller.leftRearWearPattern.text =
    //     controller
    //         .selectedCheckBoxIndicesForLeftRear['Wear Pattern']?['value'] ??
    //     '';
    // controller.leftRearTirePressureBefore.text =
    //     controller
    //         .selectedCheckBoxIndicesForLeftRear['Tire Pressure PSI']?['before'] ??
    //     '';
    // controller.leftRearTirePressureAfter.text =
    //     controller
    //         .selectedCheckBoxIndicesForLeftRear['Tire Pressure PSI']?['after'] ??
    //     '';

    // controller.selectedCheckBoxIndicesForRightRear.value =
    //     (data['right_rear_wheel'] as Map<String, dynamic>?)?.map(
    //       (key, value) => MapEntry(key, Map<String, String>.from(value as Map)),
    //     ) ??
    //     {};

    // controller.rightRearBrakeLining.text =
    //     controller
    //         .selectedCheckBoxIndicesForRightRear['Brake Lining']?['value'] ??
    //     '';
    // controller.rightRearTireTread.text =
    //     controller
    //         .selectedCheckBoxIndicesForRightRear['Tire Tread']?['value'] ??
    //     '';

    // controller.rightRearWearPattern.text =
    //     controller
    //         .selectedCheckBoxIndicesForRightRear['Wear Pattern']?['value'] ??
    //     '';
    // controller.rightRearTirePressureBefore.text =
    //     controller
    //         .selectedCheckBoxIndicesForRightRear['Tire Pressure PSI']?['before'] ??
    //     '';
    // controller.rightRearTirePressureAfter.text =
    //     controller
    //         .selectedCheckBoxIndicesForRightRear['Tire Pressure PSI']?['after'] ??
    //     '';

    // controller.selectedCheckBoxIndicesForInteriorExterior.value =
    //     (data['interior_exterior'] as Map<String, dynamic>?)?.map(
    //       (key, value) => MapEntry(key, Map<String, String>.from(value as Map)),
    //     ) ??
    //     {};

    // controller.selectedCheckBoxIndicesForUnderVehicle.value =
    //     (data['under_vehicle'] as Map<String, dynamic>?)?.map(
    //       (key, value) => MapEntry(key, Map<String, String>.from(value as Map)),
    //     ) ??
    //     {};

    // controller.selectedCheckBoxIndicesForUnderHood.value =
    //     (data['under_hood'] as Map<String, dynamic>?)?.map(
    //       (key, value) => MapEntry(key, Map<String, String>.from(value as Map)),
    //     ) ??
    //     {};

    // controller.selectedCheckBoxIndicesForBatteryPerformance.value =
    //     (data['battery_performance'] as Map<String, dynamic>?)?.map(
    //       (key, value) => MapEntry(key, Map<String, String>.from(value as Map)),
    //     ) ??
    //     {};

    // controller.selectedCheckBoxIndicesForSingleCheckBoxForBrakeAndTire.value =
    //     (data['extra_checks'] as Map<String, dynamic>?)?.map(
    //       (key, value) => MapEntry(key, Map<String, String>.from(value as Map)),
    //     ) ??
    //     {};

    // controller.carImagesURLs.assignAll(
    //   List<String>.from(data['car_images'] ?? []),
    // );
    // controller.customerSignatureURL.value = data['customer_signature'] ?? '';
    // controller.advisorSignatureURL.value = data['advisor_signature'] ?? '';
    // controller.carDialogImageURL.value = data['car_dialog'] ?? '';
    // controller.carBrandLogo.value = data['car_brand_logo'] ?? '';
  }

  Future<void> loadValues(JobCardModel data) async {
    quotationId.value = data.quotationId ?? '';
    jobCardAdded.value = true;
    curreentJobCardId.value = data.id ?? '';
    allInvoiceItems.value = data.invoiceItemsDetails ?? [];
    quotationCounter.value = data.quotationNumber ?? '';
    canAddInternalNotesAndInvoiceItems.value = true;
    jobCancelationDate.value.text = textToDate(data.jobCancellationDate);
    jobStatus1.value = data.jobStatus1 ?? '';
    jobStatus2.value = data.jobStatus2 ?? '';
    carBrandLogo.value = data.carBrandLogo ?? '';
    carBrandId.value = data.carBrand ?? '';
    carBrand.text = data.carBrandName ?? '';
    carModelId.value = data.carModel ?? '';
    carModel.text = data.carModelName ?? '';
    var jobCountry = data.country ?? "";
    var jobCarBrand = data.carBrand ?? "";
    if (jobCountry.isNotEmpty) {
      getCitiesByCountryID(jobCountry);
    }
    if (jobCarBrand.isNotEmpty) {
      getModelsByCarBrand(jobCarBrand);
    }

    plateNumber.text = data.plateNumber ?? '';
    plateCode.text = data.plateCode ?? '';
    countryId.value = jobCountry;
    country.text = data.countryName ?? '';
    cityId.value = data.city ?? '';
    city.text = data.cityName ?? '';

    year.text = data.year ?? '';
    colorId.value = data.color ?? '';
    engineTypeId.value = data.engineType ?? '';
    color.text = data.colorName ?? '';
    engineType.text = data.engineTypeName ?? '';
    vin.text = data.vehicleIdentificationNumber ?? '';
    transmissionType.text = data.transmissionType ?? '';
    mileageIn.value.text = data.mileageIn.toString();
    fuelAmount.value.text = data.fuelAmount.toString();
    mileageOut.value.text = data.mileageOut.toString();
    inOutDiff.value.text = data.mileageInOutDiff.toString();
    customerId.value = data.customer ?? '';
    customerName.text = data.customerName ?? '';
    customerEntityName.text = data.contactName ?? '';
    customerEntityPhoneNumber.text = data.contactNumber ?? '';
    customerEntityEmail.text = data.contactEmail ?? '';
    customerCreditNumber.text = data.creditLimit.toString();
    customerOutstanding.text = data.outstanding.toString();
    customerSaleManId.value = data.salesman ?? '';
    customerSaleMan.value = data.salesmanName ?? '';
    customerBranchId.value = data.branch ?? '';
    customerBranch.text = data.branchName ?? '';
    customerCurrencyId.value = data.currency ?? '';
    customerCurrency.text = data.currencyCode ?? '';

    customerCurrencyRate.text = data.rate.toString();
    payType.value = data.paymentMethod ?? '';
    data.paymentMethod == 'Cash'
        ? (isCashSelected.value = true) && (isCreditSelected.value = false)
        : (isCreditSelected.value = true) && (isCashSelected.value = false);
    jobCardCounter.value.text = data.jobNumber ?? '';

    invoiceCounter.value.text = data.invoiceNumber ?? '';
    lpoCounter.value.text = data.lpoNumber ?? '';
    jobCardDate.value.text = textToDate(data.jobDate);
    invoiceDate.value.text = textToDate(data.invoiceDate);
    approvalDate.value.text = textToDate(data.jobApprovalDate);
    startDate.value.text = textToDate(data.jobStartDate);
    finishDate.value.text = textToDate(data.jobFinishDate);
    deliveryDate.value.text = textToDate(data.jobDeliveryDate);
    jobWarrentyDays.value.text = data.jobWarrantyDays.toString();
    jobWarrentyKM.value.text = data.jobWarrantyKm.toString();
    jobWarrentyEndDate.value.text = textToDate(data.jobWarrantyEndDate);
    minTestKms.value.text = data.jobMinTestKm.toString();
    reference1.value.text = data.jobReference1 ?? '';
    reference2.value.text = data.jobReference2 ?? '';
    deliveryTime.value.text = data.deliveryTime ?? '';

    jobNotes.text = data.jobNotes ?? '';
    deliveryNotes.text = data.jobDeliveryNotes ?? '';
  }

  Future<void> editReadyForJobCard(String jobId, String status) async {
    if (jobStatus1.value.isEmpty) {
      showSnackBar('Alert', 'Please Save The Job First');
      return;
    }
    Map jobStatus = await getCurrentJobCardStatus(jobId);
    String status1 = jobStatus['job_status_1'];
    String status2 = jobStatus['job_status_2'];
    if (status1 == 'New' && status2 != 'Ready') {
      jobStatus2.value = 'Ready';
      finishDate.value.text = textToDate(DateTime.now());
      isJobModified.value = true;
    } else if (status2 == 'Ready') {
      showSnackBar('Alert', 'Job is Already Ready');
    } else if (status1 == 'Posted') {
      showSnackBar('Alert', 'Job is Posted');
    } else if (status1 == 'Cancelled') {
      showSnackBar('Alert', 'Job is Cancelled');
    }
  }

  Future<void> editNewForJobCard(String jobId, String status) async {
    if (jobStatus1.value.isEmpty) {
      showSnackBar('Alert', 'Please Save The Job First');
      return;
    }
    Map jobStatus = await getCurrentJobCardStatus(jobId);
    String status1 = jobStatus['job_status_1'];
    String status2 = jobStatus['job_status_2'];
    if (status1 == 'New' && status2 != 'New') {
      finishDate.value.text = '';
      approvalDate.value.text = '';
      jobStatus2.value = status;
      jobStatus1.value = status;
      isJobModified.value = true;
    } else if (status2 == 'New') {
      showSnackBar('Alert', 'Job is Already New');
    } else if (status1 == 'Cancelled') {
      // showSnackBar('Alert', 'Job is Cancelled');
      finishDate.value.text = '';
      approvalDate.value.text = '';
      jobStatus2.value = status;
      jobStatus1.value = status;
      isJobModified.value = true;
    } else if (status1 == 'Posted') {
      showSnackBar('Alert', 'Job is Posted');
    }
  }

  Future<void> editCancelForJobCard(String jobId, String status) async {
    if (jobStatus1.value.isEmpty) {
      showSnackBar('Alert', 'Please Save The Job First');
      return;
    }
    Map jobStatus = await getCurrentJobCardStatus(jobId);
    String status1 = jobStatus['job_status_1'];
    String status2 = jobStatus['job_status_2'];
    if (status1 == 'Cancelled') {
      showSnackBar('Alert', 'Job is Already Cancelled');
    } else if (status1 == 'Posted') {
      showSnackBar('Alert', 'Job is Posted');
    } else if (status1 != 'Cancelled' &&
        status2 != 'Cancelled' &&
        status1 != '') {
      jobCancelationDate.value.text = textToDate(DateTime.now());
      jobStatus1.value = status;
      jobStatus2.value = status;
      isJobModified.value = true;
    }
  }

  Future<void> editPostForJobCard(String jobId) async {
    if (jobStatus1.value.isEmpty) {
      showSnackBar('Alert', 'Please Save The Job First');
      return;
    }
    Map jobStatus = await getCurrentJobCardStatus(jobId);
    String status1 = jobStatus['job_status_1'];
    if (status1 == 'Posted') {
      showSnackBar('Alert', 'Job is Already Posted');
    } else if (status1 == 'Cancelled') {
      showSnackBar('Alert', 'Job is Cancelled');
    } else if (jobWarrentyEndDate.value.text.isEmpty &&
        status1.isNotEmpty &&
        status1 != 'Cancelled' &&
        status1 != 'Posted') {
      showSnackBar('Alert', 'You Must Enter Warranty End Date First');
    } else {
      // controllerr.editPostForJobCard(jobId);
      if (isBeforeToday(jobWarrentyEndDate.value.text)) {
        jobStatus2.value = 'Closed';
      } else {
        jobStatus2.value = 'Warranty';
      }
      jobStatus1.value = 'Posted';
      isJobModified.value = true;
    }
  }

  List<dynamic> buildCombinedItems(List<Map<String, dynamic>> sortedNotes) {
    List<dynamic> combinedItems = [];
    DateTime? currentDate;

    for (var note in sortedNotes) {
      final noteTime = note['time'] as DateTime;
      final noteDate = DateTime(noteTime.year, noteTime.month, noteTime.day);

      if (currentDate == null || noteDate != currentDate) {
        combinedItems.add(noteDate);
        currentDate = noteDate;
      }
      combinedItems.add(note);
    }

    return combinedItems;
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent * 5,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> selectDateContext(
    BuildContext context,
    TextEditingController date,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      date.text = textToDate(picked.toString());
    }
  }

  void selectCashOrCredit(String selected) {
    bool isCash = selected == 'Cash';
    isCashSelected.value = isCash;
    isCreditSelected.value = !isCash;
    payType.value = selected;
  }

  void inOutDiffCalculating() {
    inOutDiff.value.text =
        (int.parse(mileageOut.value.text) - int.parse(mileageIn.value.text))
            .toString();
  }

  void onSelectForCustomers(Map selectedCustomer) {
    List phoneDetails = selectedCustomer['entity_phone'];
    Map phone = phoneDetails.firstWhere(
      (value) => value['isPrimary'] == true,
      orElse: () => {'phone': ''},
    );

    customerEntityPhoneNumber.text = phone['number'] ?? '';
    customerEntityName.text = phone['name'] ?? '';
    customerEntityEmail.text = phone['email'] ?? '';

    customerCreditNumber.text = (selectedCustomer['credit_limit'] ?? '0')
        .toString();
    customerSaleManId.value = selectedCustomer['salesman_id'] ?? '';
    customerSaleMan.value = selectedCustomer['salesman'] ?? "";
  }

  void clearAllFilters() {
    statusFilter.value.clear();
    // allJobCards.clear();
    // numberOfJobs.value = 0;
    // allJobsTotals.value = 0;
    // allJobsVATS.value = 0;
    // allJobsNET.value = 0;
    allModels.clear();
    isAllSelected.value = false;
    isTodaySelected.value = false;
    isThisMonthSelected.value = false;
    isThisYearSelected.value = false;
    jobNumberFilter.value.clear();
    invoiceNumberFilter.value.clear();
    carBrandIdFilterName.value.clear();
    carBrandIdFilter = RxString('');
    carModelIdFilter = RxString('');
    customerNameIdFilter = RxString('');
    carModelIdFilterName.value.clear();
    customerNameIdFilterName.value.clear();
    plateNumberFilter.value.clear();
    vinFilter.value.clear();
    fromDate.value.clear();
    toDate.value.clear();
    isScreenLoding.value = false;
  }
}
