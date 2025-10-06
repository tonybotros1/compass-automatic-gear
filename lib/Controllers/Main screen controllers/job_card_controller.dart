import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:datahubai/consts.dart';
import 'package:uuid/uuid.dart';
import '../../Models/job cards/job_card_invoice_items_model.dart';
import '../../Models/job cards/job_card_model.dart';
import '../../Screens/Main screens/System Administrator/Setup/quotation_card.dart';
import '../../helpers.dart';
import '../Mobile section controllers/cards_screen_controller.dart';
import 'main_screen_contro.dart';
import 'quotation_card_controller.dart';

class JobCardController extends GetxController {
  RxString quotationCounter = RxString('');
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

  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  RxBool creatingNewQuotation = RxBool(false);
  RxString companyId = RxString('');
  RxMap companyDetails = RxMap({});
  RxMap allCountries = RxMap({});
  RxMap allCities = RxMap({});
  RxMap allColors = RxMap({});
  RxMap allEngineType = RxMap({});
  RxMap allBranches = RxMap({});
  RxMap allCurrencies = RxMap({});
  RxMap allInvoiceItemsFromCollection = RxMap({});
  RxBool loadingCopyJob = RxBool(false);
  var selectedRowIndex = Rxn<int>();
  var buttonLoadingStates = <String, bool>{}.obs;

  RxMap allBrands = RxMap({});
  RxMap allModels = RxMap({});
  RxMap allCustomers = RxMap({});
  RxMap salesManMap = RxMap({});
  RxBool isCashSelected = RxBool(true);
  RxBool isCreditSelected = RxBool(false);
  RxString payType = RxString('Cash');
  RxMap allUsers = RxMap();
  RxString userId = RxString('');
  RxString jobStatus1 = RxString('');
  RxString jobStatus2 = RxString('');
  RxBool postingJob = RxBool(false);
  RxBool cancellingJob = RxBool(false);
  RxBool newingJob = RxBool(false);
  RxBool approvingJob = RxBool(false);
  RxBool readingJob = RxBool(false);
  // internal notes section
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
  @override
  void onInit() async {
    super.onInit();
    await getCompanyDetails();
    jobWarrentyEndDate.value.addListener(() {
      jobWarrentyEndDate.refresh();
    });
    getInvoiceItemsFromCollection();
    getAllCustomers();
    getAllUsers();
    getBranches();
    getCurrencies();
    getSalesMan();
    getCarBrands();
    getCountries();
    getColors();
    getEngineTypes();
  }

  @override
  void onClose() {
    textFieldFocusNode.dispose();
    super.onClose();
  }

  Future<void> getColors() async {
    allColors.assignAll(await helper.getAllListValues('COLORS'));
  }

  Future<void> getEngineTypes() async {
    allEngineType.assignAll(await helper.getAllListValues('ENGINE_TYPES'));
  }

  Future<void> getCarBrands() async {
    allBrands.assignAll(await helper.getCarBrands());
  }

  Future<void> getModelsByCarBrand(String brandID) async {
    allModels.assignAll(await helper.getModelsValues(brandID));
  }

  Future<void> getCountries() async {
    allCountries.assignAll(await helper.getCountries());
  }

  Future<void> getCitiesByCountryID(String countryID) async {
    allCities.assignAll(await helper.getCitiesValues(countryID));
  }

  Future<void> getSalesMan() async {
    salesManMap.assignAll(await helper.getSalesMan());
  }

  Future<void> getCurrencies() async {
    allCurrencies.assignAll(await helper.getCurrencies());
  }

  Future<void> getCompanyDetails() async {
    companyDetails.assignAll(await helper.getCurrentCompanyDetails());
  }

  Future<void> getBranches() async {
    allBranches.assignAll(await helper.getBrunches());
  }

  Future<void> getAllUsers() async {
    allCustomers.assignAll(await helper.getCustomers());
  }

  Future<void> getAllCustomers() async {
    allUsers.assignAll(await helper.getSysUsers());
  }

  Future<void> getInvoiceItemsFromCollection() async {
    allInvoiceItemsFromCollection.assignAll(await helper.getInvoiceItems());
  }

  Future<void> addNewJobCard() async {
    try {
      if (jobStatus1.value != 'New' && jobStatus1.value != '') {
        showSnackBar('Alert', 'Only new jobs can be edited');
        return;
      }
      showSnackBar('Adding', 'Please Wait');
      addingNewValue.value = true;
      Map<String, dynamic> newData = {
        'label': '',
        'job_status_1': jobStatus1.value,
        'job_status_2': jobStatus2.value,
        'car_brand_logo': carBrandLogo.value,
        'company_id': companyId.value,
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

      if (jobCardAdded.isFalse) {
        jobStatus1.value = 'New';
        jobStatus2.value = 'New';
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
                  ).map((item)=> item.toJson())
                  .toList(),
            ),
          );
          if (response.statusCode == 200) {
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
    } catch (e) {
      print(e);
    }
  }

  // Future<void> addNewJobCard() async {
  //   try {
  //     if (jobStatus1.value != 'New' && jobStatus1.value != '') {
  //       showSnackBar('Alert', 'Only new jobs can be edited');
  //       return;
  //     }
  //     showSnackBar('Adding', 'Please Wait');
  //     addingNewValue.value = true;
  // Map<String, dynamic> newData = {
  //   'label': '',
  //   'job_status_1': jobStatus1.value,
  //   'job_status_2': jobStatus2.value,
  //   'car_brand_logo': carBrandLogo.value,
  //   'company_id': companyId.value,
  //   'car_brand': carBrandId.value,
  //   'car_model': carModelId.value,
  //   'plate_number': plateNumber.text,
  //   'plate_code': plateCode.text,
  //   'country': countryId.value,
  //   'city': cityId.value,
  //   'year': year.text,
  //   'color': colorId.value,
  //   'engine_type': engineTypeId.value,
  //   'vehicle_identification_number': vin.text,
  //   'transmission_type': transmissionType.text,
  //   'mileage_in': mileageIn.value.text,
  //   'fuel_amount': fuelAmount.value.text,
  //   'mileage_out': mileageOut.value.text,
  //   'mileage_in_out_diff': inOutDiff.value.text,
  //   'customer': customerId.value,
  //   'contact_name': customerEntityName.text,
  //   'contact_number': customerEntityPhoneNumber.text,
  //   'contact_email': customerEntityEmail.text,
  //   'credit_limit': customerCreditNumber.text,
  //   'outstanding': customerOutstanding.text,
  //   'saleMan': customerSaleManId.value,
  //   'branch': customerBranchId.value,
  //   'currency': customerCurrencyId.value,
  //   'rate': customerCurrencyRate.text,
  //   'payment_method': payType.value,
  //   'job_number': jobCardCounter.value.text,
  //   'invoice_number': invoiceCounter.value.text,
  //   'lpo_number': lpoCounter.value.text,
  //   'job_approval_date': approvalDate.value.text,
  //   'job_start_date': startDate.value.text,
  //   'job_cancelation_date': jobCancelationDate.value.text,
  //   'job_finish_date': finishDate.value.text,
  //   'job_delivery_date': deliveryDate.value.text,
  //   'job_warrenty_days': jobWarrentyDays.value.text,
  //   'job_warrenty_km': jobWarrentyKM.value.text,
  //   'job_warrenty_end_date': jobWarrentyEndDate.value.text,
  //   'job_min_test_km': minTestKms.value.text,
  //   'job_reference_1': reference1.value.text,
  //   'job_reference_2': reference2.value.text,
  //   'delivery_time': deliveryTime.value.text,
  //   'job_notes': jobNotes.text,
  //   'job_delivery_notes': deliveryNotes.text,
  // };

  //     final rawDate = jobCardDate.value.text.trim();
  //     if (rawDate.isNotEmpty) {
  //       try {
  //         newData['job_date'] = Timestamp.fromDate(format.parseStrict(rawDate));
  //       } catch (e) {
  //         // إذا حابب تعرض للمستخدم خطأ في التنسيق
  //         // print('Invalid quotation_date format: $e');
  //       }
  //     }

  //     final rawDate2 = invoiceDate.value.text.trim();
  //     if (rawDate2.isNotEmpty) {
  //       try {
  //         newData['invoice_date'] = Timestamp.fromDate(
  //           format.parseStrict(rawDate2),
  //         );
  //       } catch (e) {
  //         // إذا حابب تعرض للمستخدم خطأ في التنسيق
  //         // print('Invalid quotation_date format: $e');
  //       }
  //     }

  //     if (jobCardCounter.value.text.isEmpty) {
  //       jobStatus1.value = 'New';
  //       jobStatus2.value = 'New';
  //       newData['label'] = '';

  //       newData['job_status_1'] = 'New';
  //       newData['job_status_2'] = 'New';
  //       await getCurrentJobCardCounterNumber();
  //       newData['job_number'] = jobCardCounter.value.text;
  //     }

  //     if (jobCardAdded.isFalse) {
  //       newData['added_date'] = DateTime.now().toString();
  //       var newJob = await FirebaseFirestore.instance
  //           .collection('job_cards')
  //           .add(newData);
  //       jobCardAdded.value = true;
  //       curreentJobCardId.value = newJob.id;
  //       getAllInvoiceItems(newJob.id);
  //       showSnackBar('Done', 'Job Added Successfully');
  //     } else {
  //       newData.remove('added_date');
  //       await FirebaseFirestore.instance
  //           .collection('job_cards')
  //           .doc(curreentJobCardId.value)
  //           .update(newData);
  //       showSnackBar('Done', 'Updated Successfully');
  //     }
  //     canAddInternalNotesAndInvoiceItems.value = true;
  //     addingNewValue.value = false;
  //   } catch (e) {
  //     canAddInternalNotesAndInvoiceItems.value = false;
  //     addingNewValue.value = false;
  //     showSnackBar('Alert', 'Something Went Wrong');
  //   }
  // }

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
      );
    }
    isJobInvoicesModified.value = true;

    Get.back();
  }

  // ===============================================================================================================
  void changejobWarrentyEndDateDependingOnWarrentyDays() {
    DateTime date = format.parse(deliveryDate.value.text);
    DateTime newDate = date.add(
      Duration(days: int.parse(jobWarrentyDays.value.text)),
    );
    jobWarrentyEndDate.value.text = format.format(newDate);
  }

  Future<void> calculateMoneyForAllJobs() async {
    // try {
    //   allJobsVATS.value = 0;
    //   allJobsTotals.value = 0;
    //   allJobsNET.value = 0;
    //   if (allJobCards.isEmpty) {
    //     return;
    //   }
    //   for (var job in allJobCards) {
    //     allJobsVATS.value +=
    //         double.tryParse(job.data()['total_vat_amount'].toString()) ?? 0.0;
    //     allJobsTotals.value +=
    //         double.tryParse(job.data()['totals_amount'].toString()) ?? 0.0;
    //     allJobsNET.value +=
    //         double.tryParse(job.data()['total_net_amount'].toString()) ?? 0.0;
    //   }
    // } catch (e) {
    //   allJobsVATS.value = 0;
    //   allJobsTotals.value = 0;
    //   allJobsNET.value = 0;
    // }
  }

  Future<void> openQuotationCardScreenByNumber() async {
    try {
      openingQuotationCardScreen.value = true;
      QuotationCardController quotationCardController = Get.put(
        QuotationCardController(),
      );
      var quotation = await FirebaseFirestore.instance
          .collection('quotation_cards')
          .where('quotation_number', isEqualTo: quotationCounter.value)
          .get();
      var id = quotation.docs.first.id;
      var data = quotation.docs.first.data();

      quotationCardController.getAllInvoiceItems(id);
      await quotationCardController.loadValues(data, id);
      showSnackBar('Done', 'Opened Successfully');
      await editQuotationCardDialog(
        quotationCardController,
        data,
        id,
        screenName: '🧾 Quotation',
        headerColor: Colors.deepPurple,
      );
      openingQuotationCardScreen.value = false;
    } catch (e) {
      openingQuotationCardScreen.value = false;
      showSnackBar('Alert', 'Something Went Wrong');
    }
  }

  // function to manage loading button
  void setButtonLoading(String menuId, bool isLoading) {
    buttonLoadingStates[menuId] = isLoading;
    buttonLoadingStates.refresh(); // Notify listeners
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
    // this is for invoice items
    double sumofTotal = 0.0;
    double sumofVAT = 0.0;
    double sumofNET = 0.0;

    for (var job in allInvoiceItems) {
      sumofTotal += job.total ?? 0;
      sumofNET += job.net ?? 0;
      sumofVAT += job.vat ?? 0;
    }

    return [sumofTotal, sumofVAT, sumofNET];
  }

  Stream<double> calculateAllTotals(String jobId) {
    return FirebaseFirestore.instance
        .collection('job_cards')
        .doc(jobId)
        .collection('invoice_items')
        .snapshots()
        .map((snapshot) {
          double sumOfTotal = 0.0;

          for (var job in snapshot.docs) {
            var data = job.data() as Map<String, dynamic>?;
            sumOfTotal +=
                double.tryParse(data?['total']?.toString() ?? '0') ?? 0;
          }
          return sumOfTotal;
        });
  }

  Stream<double> calculateAllVATs(String jobId) {
    return FirebaseFirestore.instance
        .collection('job_cards')
        .doc(jobId)
        .collection('invoice_items')
        .snapshots()
        .map((snapshot) {
          double sumOfVAT = 0.0;

          for (var job in snapshot.docs) {
            var data = job.data() as Map<String, dynamic>?;
            sumOfVAT += double.tryParse(data?['vat']?.toString() ?? '0') ?? 0;
          }
          return sumOfVAT;
        });
  }

  Stream<double> calculateAllNETs(String jobId) {
    return FirebaseFirestore.instance
        .collection('job_cards')
        .doc(jobId)
        .collection('invoice_items')
        .snapshots()
        .map((snapshot) {
          double sumOfNET = 0.0;

          for (var job in snapshot.docs) {
            var data = job.data() as Map<String, dynamic>?;
            sumOfNET += double.tryParse(data?['net']?.toString() ?? '0') ?? 0;
          }
          return sumOfNET;
        });
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

  Future<void> addNewInternalNote(
    String jobcardID,
    Map<String, dynamic> note,
  ) async {
    try {
      addingNewInternalNotProcess.value = true;
      final jobDoc = FirebaseFirestore.instance
          .collection('job_cards')
          .doc(jobcardID)
          .collection('internal_notes');

      if (note['type'] == 'Text') {
        await jobDoc.add(note);
      } else {
        final originalFileName = note['file_name'] as String;

        // Extract filename and extension
        final extIndex = originalFileName.lastIndexOf('.');
        final (String fileName, String extension) = extIndex != -1
            ? (
                originalFileName.substring(0, extIndex),
                originalFileName.substring(extIndex + 1),
              )
            : (originalFileName, '');

        // Create timestamped filename
        final timestamp = DateTime.now().toIso8601String().replaceAll(
          RegExp(r'[^0-9T-]'),
          '_',
        );
        final storageFileName = extension.isNotEmpty
            ? '${fileName}_$timestamp.$extension'
            : '${fileName}_$timestamp';

        // Create storage reference
        final Reference storageRef = FirebaseStorage.instance.ref().child(
          'internal_notes/$storageFileName',
        );

        // Determine MIME type
        final mimeType =
            note['type'] as String? ?? getMimeTypeFromExtension(extension);

        // Upload file and wait for completion
        final UploadTask uploadTask = storageRef.putData(
          note['note'],
          SettableMetadata(
            contentType: mimeType ?? 'application/octet-stream',
            customMetadata: {'original_filename': originalFileName},
          ),
        );

        // Wait for upload to complete
        final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});

        // Get download URL after upload completion
        final String fileUrl = await snapshot.ref.getDownloadURL();

        // Store the note in Firestore
        await jobDoc.add({
          'file_name': originalFileName,
          'type': mimeType ?? 'application/octet-stream',
          'note': fileUrl,
          'user_id': note['user_id'],
          'time': note['time'],
        });
      }
      addingNewInternalNotProcess.value = false;
    } catch (e) {
      addingNewInternalNotProcess.value = false;
    }
  }

  void editJobCard(String jobId) {
    try {
      if (jobStatus1.value == 'Posted' || jobStatus1.value == 'Cancelled') {
        showSnackBar('Alert', 'Can\'t Edit For Posted / Cancelled Jobs');
        return;
      }
      addingNewValue.value = true;

      Map<String, dynamic> updatedData = {
        'label': label.value,
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
        'mileage_in': mileageIn.value.text,
        'fuel_amount': fuelAmount.value.text,
        'mileage_out': mileageOut.value.text,
        'mileage_in_out_diff': inOutDiff.value.text,
        'customer': customerId.value,
        'contact_name': customerEntityName.text,
        'contact_number': customerEntityPhoneNumber.text,
        'contact_email': customerEntityEmail.text,
        'credit_limit': customerCreditNumber.text,
        'outstanding': customerOutstanding.text,
        'saleMan': customerSaleManId.value,
        'branch': customerBranchId.value,
        'currency': customerCurrencyId.value,
        'rate': customerCurrencyRate.text,
        'payment_method': payType.value,
        'job_number': jobCardCounter.value.text,
        'invoice_number': invoiceCounter.value.text,
        'lpo_number': lpoCounter.value.text,
        // 'job_date': jobCardDate.value.text,
        // 'invoice_date': invoiceDate.value.text,
        'job_approval_date': approvalDate.value.text,
        'job_start_date': startDate.value.text,
        'job_finish_date': finishDate.value.text,
        'job_delivery_date': deliveryDate.value.text,
        'job_warrenty_days': jobWarrentyDays.value.text,
        'job_warrenty_km': jobWarrentyKM.value.text,
        'job_warrenty_end_date': jobWarrentyEndDate.value.text,
        'job_min_test_km': minTestKms.value.text,
        'job_reference_1': reference1.value.text,
        'job_reference_2': reference2.value.text,
        'delivery_time': deliveryTime.value.text,
        'job_notes': jobNotes.text,
        'job_delivery_notes': deliveryNotes.text,
      };

      // تحويل التاريخ إلى Timestamp إذا حقل التاريخ غير فارغ
      final rawDate = jobCardDate.value.text.trim();
      if (rawDate.isNotEmpty) {
        try {
          updatedData['job_date'] = Timestamp.fromDate(
            format.parseStrict(rawDate),
          );
        } catch (e) {
          // اختياري: تقدر تعرض تنبيه إذا التنسيق خاطئ
          // print('Invalid quotation_date format: $e');
        }
      }

      final rawDate2 = invoiceDate.value.text.trim();
      if (rawDate2.isNotEmpty) {
        try {
          updatedData['invoice_date'] = Timestamp.fromDate(
            format.parseStrict(rawDate2),
          );
        } catch (e) {
          // اختياري: تقدر تعرض تنبيه إذا التنسيق خاطئ
          // print('Invalid quotation_date format: $e');
        }
      }

      FirebaseFirestore.instance
          .collection('job_cards')
          .doc(jobId)
          .update(updatedData);

      addingNewValue.value = false;
      showSnackBar('Done', 'Job Updated Successfully');
    } catch (e) {
      addingNewValue.value = false;
      showSnackBar('Alert', 'Something Went Wrong');
    }
  }

  Future<void> getCurrentQuotationCounterNumber() async {
    try {
      var qnId = '';
      var updateqn = '';
      var qnDoc = await FirebaseFirestore.instance
          .collection('counters')
          .where('code', isEqualTo: 'QN')
          .where('company_id', isEqualTo: companyId.value)
          .get();

      if (qnDoc.docs.isEmpty) {
        // Define constants for new counter values
        const prefix = 'QN';
        const separator = '-';
        const initialValue = 1;

        var newCounter = await FirebaseFirestore.instance
            .collection('counters')
            .add({
              'code': 'QN',
              'description': 'Quotation Number',
              'prefix': prefix,
              'value': initialValue,
              'length': 0,
              'separator': separator,
              'added_date': DateTime.now().toString(),
              'company_id': companyId.value,
              'status': true,
            });
        qnId = newCounter.id;
        // Set the counter text with prefix and separator
        quotationCounter.value = '$prefix$separator$initialValue';
        updateqn = initialValue.toString();
      } else {
        var firstDoc = qnDoc.docs.first;
        qnId = firstDoc.id;
        var currentValue = firstDoc.data()['value'] ?? 0;
        quotationCounter.value =
            '${firstDoc.data()['prefix']}${firstDoc.data()['separator']}${(currentValue + 1).toString().padLeft(firstDoc.data()['length'], '0')}';
        updateqn = (currentValue + 1).toString();
      }

      await FirebaseFirestore.instance.collection('counters').doc(qnId).update({
        'value': int.parse(updateqn),
      });
    } catch (e) {
      //
    }
  }

  Future<void> createQuotationCard(String jobId) async {
    try {
      showSnackBar('Creating', 'Please Wait');
      creatingNewQuotation.value = true;
      Map<String, dynamic> newData = {
        'quotation_status': 'New',
        'car_brand_logo': carBrandLogo.value,
        'company_id': companyId.value,
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
        'mileage_in': mileageIn.value.text,
        'mileage_out': mileageOut.value.text,
        'mileage_in_out_diff': inOutDiff.value.text,
        'customer': customerId.value,
        'contact_name': customerEntityName.text,
        'contact_number': customerEntityPhoneNumber.text,
        'contact_email': customerEntityEmail.text,
        'credit_limit': customerCreditNumber.text,
        'outstanding': customerOutstanding.text,
        'saleMan': customerSaleManId.value,
        'branch': customerBranchId.value,
        'currency': customerCurrencyId.value,
        'rate': customerCurrencyRate.text,
        'payment_method': payType.value,
        'quotation_number': quotationCounter.value,
        'quotation_date': '',
        'validity_days': '',
        'validity_end_date': '',
        'reference_number': '',
        'delivery_time': '',
        'quotation_warrenty_days': jobWarrentyDays.value.text,
        'quotation_warrenty_km': jobWarrentyKM.value.text,
        'quotation_notes': '',
      };

      await getCurrentQuotationCounterNumber();
      newData['quotation_number'] = quotationCounter.value;
      newData['added_date'] = DateTime.now().toString();
      var newQuotation = await FirebaseFirestore.instance
          .collection('quotation_cards')
          .add(newData);

      // for (var element in allInvoiceItems) {
      //   var data = element.data();
      //   await FirebaseFirestore.instance
      //       .collection('quotation_cards')
      //       .doc(newQuotation.id)
      //       .collection('invoice_items')
      //       .add(data);
      // }
      await FirebaseFirestore.instance
          .collection('job_cards')
          .doc(jobId)
          .update({'quotation_id': newQuotation.id});
      showSnackBar('Done', 'Quotation Created Successfully');

      creatingNewQuotation.value = false;
    } catch (e) {
      creatingNewQuotation.value = false;
      showSnackBar('Alert', 'Something Went Wrong');
    }
  }

  Future<Map<String, dynamic>> copyJob(String jobId) async {
    try {
      loadingCopyJob.value = true;

      var mainJob = await FirebaseFirestore.instance
          .collection('job_cards')
          .doc(jobId)
          .get();

      Map<String, dynamic>? data = mainJob.data();
      if (data != null) {
        data.remove('id');
        data['job_status_1'] = 'New';
        data['job_status_2'] = 'New';
        data['invoice_number'] = '';
        data['invoice_date'] = '';
        await getCurrentJobCardCounterNumber();
        data['job_number'] = jobCardCounter.value.text;
        final warrentyEndDate = data['job_warrenty_end_date'];
        if (warrentyEndDate != null && isBeforeToday(warrentyEndDate)) {
          data['label'] = '';
        } else {
          data['label'] = 'Returned';
        }

        var newCopiedJob = await FirebaseFirestore.instance
            .collection('job_cards')
            .add(data);

        var jobInvoices = await FirebaseFirestore.instance
            .collection('job_cards')
            .doc(jobId)
            .collection('invoice_items')
            .get();
        if (jobInvoices.docs.isNotEmpty) {
          for (var element in jobInvoices.docs) {
            await FirebaseFirestore.instance
                .collection('job_cards')
                .doc(newCopiedJob.id)
                .collection('invoice_items')
                .add(element.data());
          }
        }

        return {'newId': newCopiedJob.id, 'data': data};
      } else {
        loadingCopyJob.value = false;
        showSnackBar('Alert', 'Job has no data');
        throw Exception('Job data is empty');
      }
    } catch (e) {
      showSnackBar(
        'Alert',
        'Something went wrong while copying the job. Please try again',
      );
      loadingCopyJob.value = false;
      rethrow;
    }
  }

  Future<void> editApproveForJobCard(String jobId, String status) async {
    try {
      approvingJob.value = true;
      await FirebaseFirestore.instance
          .collection('job_cards')
          .doc(jobId)
          .update({
            'job_status_2': status,
            'job_approval_date': DateTime.now().toString(),
          });
      approvalDate.value.text = textToDate(DateTime.now());
      jobStatus2.value = 'Approved';
      approvingJob.value = false;
      showSnackBar('Done', 'Status is Approved Now');
    } catch (e) {
      approvingJob.value = false;
    }
  }

  Future<void> editReadyForJobCard(String jobId, String status) async {
    try {
      readingJob.value = true;
      await FirebaseFirestore.instance
          .collection('job_cards')
          .doc(jobId)
          .update({
            'job_status_2': status,
            'job_finish_date': DateTime.now().toString(),
          });
      finishDate.value.text = textToDate(DateTime.now());
      jobStatus2.value = 'Ready';
      readingJob.value = false;
      showSnackBar('Done', 'Status is Ready Now');
    } catch (e) {
      readingJob.value = false;
    }
  }

  Future<void> editNewForJobCard(String jobId, String status) async {
    try {
      newingJob.value = true;
      await FirebaseFirestore.instance
          .collection('job_cards')
          .doc(jobId)
          .update({
            'job_status_2': status,
            'job_status_1': status,
            'job_finish_date': '',
            'job_approval_date': '',
          });
      finishDate.value.text = '';
      approvalDate.value.text = '';
      jobStatus2.value = 'New';
      jobStatus1.value = 'New';
      newingJob.value = false;

      showSnackBar('Done', 'Status is New Now');
    } catch (e) {
      newingJob.value = false;
    }
  }

  Future<void> editCancelForJobCard(String jobId, String status) async {
    try {
      cancellingJob.value = true;
      await FirebaseFirestore.instance
          .collection('job_cards')
          .doc(jobId)
          .update({
            'job_status_1': status,
            'job_status_2': status,
            'job_cancelation_date': DateTime.now().toString(),
          });
      jobCancelationDate.value.text = textToDate(DateTime.now());
      jobStatus1.value = status;
      jobStatus2.value = status;
      cancellingJob.value = false;
      showSnackBar('Done', 'Status is Cancelled Now');
    } catch (e) {
      cancellingJob.value = false;
    }
  }

  Future<void> editPostForJobCard(String jobId) async {
    try {
      var status2 = '';
      postingJob.value = true;
      var doc = await FirebaseFirestore.instance
          .collection('job_cards')
          .doc(jobId)
          .get();
      var warrEndDate = doc.data()?['job_warrenty_end_date'];

      if (warrEndDate != '') {
        if (isBeforeToday(jobWarrentyEndDate.value.text)) {
          status2 = 'Closed';
        } else {
          status2 = 'Warranty';
        }
        await getCurrentInvoiceCounterNumber();
        await FirebaseFirestore.instance
            .collection('job_cards')
            .doc(jobId)
            .update({
              'invoice_number': invoiceCounter.value.text,
              'invoice_date': DateTime.now().toString(),
              'job_status_1': 'Posted',
              'job_status_2': status2,
            });

        jobStatus1.value = 'Posted';
        jobStatus2.value = status2;
        postingJob.value = false;
        showSnackBar('Done', 'Status is Posted Now');
      } else {
        showSnackBar('Alert', 'Save Job To get the Warrenty End Date');
        postingJob.value = false;
      }
    } catch (e) {
      postingJob.value = false;
    }
  }

  Future<void> deleteJobCard(String jobId) async {
    try {
      Get.back();
      Get.back();
      await FirebaseFirestore.instance
          .collection('job_cards')
          .doc(jobId)
          .delete();
    } catch (e) {
      //
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

  void selectCashOrCredit(String selected, bool value) {
    bool isCash = selected == 'cash';

    isCashSelected.value = isCash ? value : false;
    isCreditSelected.value = isCash ? false : value;
    payType.value = isCash ? 'Cash' : 'Credit';
  }

  Future<String> getCityName(String countryId, String cityId) async {
    try {
      var cities = await FirebaseFirestore.instance
          .collection('all_countries')
          .doc(countryId)
          .collection('values')
          .doc(cityId)
          .get();

      if (cities.exists) {
        return cities.data()!['name'].toString();
      } else {
        return '';
      }
    } catch (e) {
      return ''; // Return empty string on error
    }
  }

  Future<String> getModelName(String brandId, String modelId) async {
    try {
      var cities = await FirebaseFirestore.instance
          .collection('all_brands')
          .doc(brandId)
          .collection('values')
          .doc(modelId)
          .get();

      if (cities.exists) {
        return cities.data()!['name'];
      } else {
        return '';
      }
    } catch (e) {
      return ''; // Return empty string on error
    }
  }

  void inOutDiffCalculating() {
    inOutDiff.value.text =
        (int.parse(mileageOut.value.text) - int.parse(mileageIn.value.text))
            .toString();
  }

  Future<void> getCurrentJobCardCounterNumber() async {
    try {
      var jcnId = '';
      var updateJobCard = '';
      var jcnDoc = await FirebaseFirestore.instance
          .collection('counters')
          .where('code', isEqualTo: 'JCN')
          .where('company_id', isEqualTo: companyId.value)
          .get();

      if (jcnDoc.docs.isEmpty) {
        // Define constants for the new counter values
        const prefix = 'JCN';
        const separator = '-';
        const initialValue = 1;

        var newCounter = await FirebaseFirestore.instance
            .collection('counters')
            .add({
              'code': 'JCN',
              'description': 'Job Card Number',
              'prefix': prefix,
              'value': initialValue,
              'length': 0,
              'separator': separator,
              'added_date': DateTime.now().toString(),
              'company_id': companyId.value,
              'status': true,
            });
        jcnId = newCounter.id;
        // Set the counter text with prefix and separator
        jobCardCounter.value.text = '$prefix$separator$initialValue';
        updateJobCard = initialValue.toString();
      } else {
        var firstDoc = jcnDoc.docs.first;
        jcnId = firstDoc.id;
        var currentValue = firstDoc.data()['value'] ?? 0;
        // Use the existing prefix and separator from the document
        jobCardCounter.value.text =
            '${firstDoc.data()['prefix']}${firstDoc.data()['separator']}${(currentValue + 1).toString().padLeft(firstDoc.data()['length'], '0')}';
        updateJobCard = (currentValue + 1).toString();
      }

      await FirebaseFirestore.instance.collection('counters').doc(jcnId).update(
        {'value': int.parse(updateJobCard)},
      );
    } catch (e) {
      // Optionally handle errors here
      // print("Error in getCurrentJobCardCounterNumber: $e");
    }
  }

  Future<void> getCurrentInvoiceCounterNumber() async {
    try {
      var jciId = '';
      var updateInvoice = '';
      var jciDoc = await FirebaseFirestore.instance
          .collection('counters')
          .where('code', isEqualTo: 'JCI')
          .where('company_id', isEqualTo: companyId.value)
          .get();

      if (jciDoc.docs.isEmpty) {
        // Define constants for the new counter values
        const prefix = 'JCI';
        const separator = '-';
        const initialValue = 1;

        var newCounter = await FirebaseFirestore.instance
            .collection('counters')
            .add({
              'code': 'JCI',
              'description': 'Job Card Invoice Number',
              'prefix': prefix,
              'value': initialValue,
              'length': 0,
              'separator': separator,
              'added_date': DateTime.now().toString(),
              'company_id': companyId.value,
              'status': true,
            });
        jciId = newCounter.id;
        // Set the counter text with prefix and separator
        invoiceCounter.value.text = '$prefix$separator$initialValue';
        updateInvoice = initialValue.toString();
      } else {
        var firstDoc = jciDoc.docs.first;
        jciId = firstDoc.id;
        var currentValue = firstDoc.data()['value'] ?? 0;
        invoiceCounter.value.text =
            '${firstDoc.data()['prefix']}${firstDoc.data()['separator']}${(currentValue + 1).toString().padLeft(firstDoc.data()['length'], '0')}';
        updateInvoice = (currentValue + 1).toString();
      }

      await FirebaseFirestore.instance.collection('counters').doc(jciId).update(
        {
          'value': int.parse(updateInvoice), // Increment the value
        },
      );
    } catch (e) {
      // Optionally handle the error here
      // print("Error in getCurrentInvoiceCounterNumber: $e");
    }
  }

  Stream<List<Map<String, dynamic>>> getJobCardInternalNotes(String jobId) {
    return FirebaseFirestore.instance
        .collection('job_cards')
        .doc(jobId)
        .collection('internal_notes')
        .orderBy('time')
        .snapshots()
        .map((querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            return querySnapshot.docs.map((doc) {
              return {'id': doc.id, ...doc.data()};
            }).toList();
          } else {
            return [];
          }
        });
  }

  void getAllInvoiceItems(String jobId) {
    // try {
    //   loadingInvoiceItems.value = true;
    //   FirebaseFirestore.instance
    //       .collection('job_cards')
    //       .doc(jobId)
    //       .collection('invoice_items')
    //       .orderBy('line_number')
    //       .snapshots()
    //       .listen((QuerySnapshot<Map<String, dynamic>> items) {
    //         allInvoiceItems.assignAll(items.docs);
    //         loadingInvoiceItems.value = false;
    //       });
    // } catch (e) {
    //   loadingInvoiceItems.value = false;
    // }
  }

  String getdataName(String id, Map allData, {title = 'name'}) {
    try {
      final data = allData.entries.firstWhere((data) => data.key == id);
      return data.value[title];
    } catch (e) {
      return '';
    }
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

  Future<void> searchEngine() async {
    isScreenLoding.value = true;

    // Start with the base query for the company.
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('job_cards')
        .where('company_id', isEqualTo: companyId.value);

    // 1. APPLY DATE FILTERS TO THE FIRESTORE QUERY
    // This requires only ONE composite index: (company_id, job_date).

    if (isAllSelected.value) {
      // If "All" is selected, we don't apply any date filter to the Firestore query.
      // We will fetch all documents for the company.
    } else if (isTodaySelected.value) {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      fromDate.value.text = textToDate(startOfDay);
      toDate.value.text = textToDate(endOfDay);
      query = query
          .where(
            'job_date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
          )
          .where('job_date', isLessThan: Timestamp.fromDate(endOfDay));
    } else if (isThisMonthSelected.value) {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = (now.month < 12)
          ? DateTime(now.year, now.month + 1, 1)
          : DateTime(now.year + 1, 1, 1);
      fromDate.value.text = textToDate(startOfMonth);
      toDate.value.text = textToDate(endOfMonth);
      query = query
          .where(
            'job_date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth),
          )
          .where('job_date', isLessThan: Timestamp.fromDate(endOfMonth));
    } else if (isThisYearSelected.value) {
      final now = DateTime.now();
      final startOfYear = DateTime(now.year, 1, 1);
      final endOfYear = DateTime(now.year + 1, 1, 1);
      fromDate.value.text = textToDate(startOfYear);
      toDate.value.text = textToDate(endOfYear);
      query = query
          .where(
            'job_date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfYear),
          )
          .where('job_date', isLessThan: Timestamp.fromDate(endOfYear));
    } else {
      // Manual date range
      if (fromDate.value.text.trim().isNotEmpty) {
        try {
          final dtFrom = format.parseStrict(fromDate.value.text.trim());
          query = query.where(
            'job_date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(dtFrom),
          );
        } catch (_) {}
      }
      if (toDate.value.text.trim().isNotEmpty) {
        try {
          final dtTo = format
              .parseStrict(toDate.value.text.trim())
              .add(const Duration(days: 1));
          query = query.where('job_date', isLessThan: Timestamp.fromDate(dtTo));
        } catch (_) {}
      }
    }

    // 2. EXECUTE THE FIRESTORE QUERY
    // Fetch all documents matching the company and date range.
    final snapshot = await query.get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> fetchedJobCards =
        snapshot.docs;

    // 3. APPLY ALL OTHER FILTERS ON THE CLIENT-SIDE
    // Filter the 'fetchedJobCards' list in memory.
    List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredJobCards =
        fetchedJobCards.where((doc) {
          final data = doc.data();

          // Job Number Filter
          if (jobNumberFilter.value.text.trim().isNotEmpty &&
              data['job_number'] != jobNumberFilter.value.text.trim()) {
            return false;
          }
          // Status Filter
          if (statusFilter.value.text.trim().isNotEmpty &&
              data['job_status_1'] != statusFilter.value.text.trim()) {
            return false;
          }
          // Car Brand Filter
          if (carBrandIdFilter.value.isNotEmpty &&
              data['car_brand'] != carBrandIdFilter.value) {
            return false;
          }
          // Car Model Filter
          if (carModelIdFilter.value.isNotEmpty &&
              data['car_model'] != carModelIdFilter.value) {
            return false;
          }
          // Plate Number Filter
          if (plateNumberFilter.value.text.trim().isNotEmpty &&
              data['plate_number'] != plateNumberFilter.value.text.trim()) {
            return false;
          }
          // VIN Filter
          if (vinFilter.value.text.trim().isNotEmpty &&
              data['vehicle_identification_number'] !=
                  vinFilter.value.text.trim()) {
            return false;
          }
          // Customer Filter
          if (customerNameIdFilter.value.isNotEmpty &&
              data['customer'] != customerNameIdFilter.value) {
            return false;
          }

          // If the document passed all filters, keep it.
          return true;
        }).toList();

    // 4. UPDATE THE UI
    // allJobCards.assignAll(filteredJobCards);
    numberOfJobs.value = allJobCards.length;
    calculateMoneyForAllJobs(); // Make sure this function iterates over the final list
    isScreenLoding.value = false;
  }

  void removeFilters() {
    isAllSelected.value = false;
    isTodaySelected.value = false;
    isThisMonthSelected.value = false;
    isThisYearSelected.value = false;
  }

  void clearAllFilters() {
    statusFilter.value.clear();
    allJobCards.clear();
    numberOfJobs.value = 0;
    allJobsTotals.value = 0;
    allJobsVATS.value = 0;
    allJobsNET.value = 0;
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
