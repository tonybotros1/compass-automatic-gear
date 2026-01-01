import 'dart:convert';
import 'dart:typed_data';
import 'package:datahubai/Controllers/Main%20screen%20controllers/countries_controller.dart';
import 'package:datahubai/Models/quotation%20cards/quotation_cards_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/currency_input_formatter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:datahubai/consts.dart';
import 'package:uuid/uuid.dart';
import '../../Models/ar receipts and ap payments/ar_receipts_model.dart';
import '../../Models/job cards/inspection_report_model.dart';
import '../../Models/job cards/internal_notes_model.dart';
import '../../Models/job cards/job_card_invoice_items_model.dart';
import '../../Models/job cards/job_card_model.dart';
import '../../Screens/Main screens/System Administrator/Setup/cash_management_receipts.dart';
import '../../Screens/Main screens/System Administrator/Setup/quotation_card.dart';
import '../../Widgets/Mobile widgets/inspection report widgets/inspection_reports_hekpers.dart';
import '../../helpers.dart';
import '../Mobile section controllers/cards_screen_controller.dart';
import 'car_brands_controller.dart';
import 'cash_management_receipts_controller.dart';
import 'list_of_values_controller.dart';
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
  RxBool creatingNewReceipt = RxBool(false);
  RxMap companyDetails = RxMap({});
  // RxMap allCities = RxMap({});
  RxBool loadingCopyJob = RxBool(false);
  var selectedRowIndex = Rxn<int>();
  var buttonLoadingStates = <String, bool>{}.obs;

  // RxMap allModels = RxMap({});
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
  // RxString currentCountryVAT = RxString('');
  RxDouble currentCountryVAT = RxDouble(0.0);
  TextEditingController net = TextEditingController();
  CardsScreenController controller = Get.put(CardsScreenController());
  RxBool openingQuotationCardScreen = RxBool(false);
  RxInt numberOfJobs = RxInt(0);
  RxDouble allJobsVATS = RxDouble(0.0);
  RxDouble allJobsTotals = RxDouble(0.0);
  RxDouble allJobsNET = RxDouble(0.0);
  RxDouble allJobsPaid = RxDouble(0.0);
  RxDouble allJobsOutstanding = RxDouble(0.0);
  // DocumentSnapshot? lastDocument;
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
  RxString branchNameIdFilter = RxString('');
  Rx<TextEditingController> carModelIdFilterName = TextEditingController().obs;
  Rx<TextEditingController> customerNameIdFilterName =
      TextEditingController().obs;
  Rx<TextEditingController> branchFilterName = TextEditingController().obs;
  Rx<TextEditingController> plateNumberFilter = TextEditingController().obs;
  Rx<TextEditingController> vinFilter = TextEditingController().obs;
  Rx<TextEditingController> lpoFilter = TextEditingController().obs;
  Rx<TextEditingController> fromDate = TextEditingController().obs;
  Rx<TextEditingController> toDate = TextEditingController().obs;
  Rx<TextEditingController> statusFilter = TextEditingController().obs;
  Rx<TextEditingController> typeFilter = TextEditingController().obs;
  Rx<TextEditingController> lableFilter = TextEditingController().obs;
  final Uuid _uuid = const Uuid();
  String backendUrl = backendTestURI;
  RxBool isJobModified = RxBool(false);
  RxBool isJobInvoicesModified = RxBool(false);
  RxBool isJobInternalNotesLoading = RxBool(false);
  final formatter = CurrencyInputFormatter();
  RxBool loadingIspectionReport = RxBool(false);
  ListOfValuesController listOfValuesController = Get.put(
    ListOfValuesController(),
  );
  CarBrandsController carBrandsController = Get.put(CarBrandsController());
  CountriesController countriesController = Get.put(CountriesController());
  // // for the payment header
  final FocusNode focusNodeForCardDetails1 = FocusNode();
  final FocusNode focusNodeForCardDetails2 = FocusNode();
  final FocusNode focusNodeForCardDetails3 = FocusNode();
  final FocusNode focusNodeForCardDetails4 = FocusNode();
  final FocusNode focusNodeForCardDetails5 = FocusNode();
  final FocusNode focusNodeForCardDetails6 = FocusNode();
  final FocusNode focusNodeForCardDetails7 = FocusNode();
  final FocusNode focusNodeForCardDetails8 = FocusNode();
  final FocusNode focusNodeForCardDetails9 = FocusNode();
  final FocusNode focusNodeForCardDetails10 = FocusNode();
  final FocusNode focusNodeForCardDetails11 = FocusNode();
  final FocusNode focusNodeForCardDetails12 = FocusNode();
  final FocusNode focusNodeForCardDetails13 = FocusNode();
  final FocusNode focusNodeForCardDetails14 = FocusNode();

  final FocusNode focusNodeForCustomerDetails1 = FocusNode();
  final FocusNode focusNodeForCustomerDetails2 = FocusNode();
  final FocusNode focusNodeForCustomerDetails3 = FocusNode();
  final FocusNode focusNodeForCustomerDetails4 = FocusNode();
  final FocusNode focusNodeForCustomerDetails5 = FocusNode();
  final FocusNode focusNodeForCustomerDetails6 = FocusNode();
  final FocusNode focusNodeForCustomerDetails7 = FocusNode();
  final FocusNode focusNodeForCustomerDetails8 = FocusNode();

  final FocusNode focusNodeForItemsDetails1 = FocusNode();
  final FocusNode focusNodeForItemsDetails2 = FocusNode();
  final FocusNode focusNodeForItemsDetails3 = FocusNode();

  RxBool isReturned = RxBool(false);
  RxBool isSales = RxBool(false);
  ScrollController scrollerForCarDetails = ScrollController();
  ScrollController scrollerForCustomer = ScrollController();
  ScrollController scrollerForjobSection = ScrollController();

  RxMap allStatus = RxMap({
    '1': {'name': 'New'},
    '2': {'name': 'Posted'},
    '3': {'name': 'Cancelled'},
    '4': {'name': 'Ready'},
    '5': {'name': 'Approved'},
    '6': {'name': 'Draft'},
  });

  List<Map<String, dynamic>> customers = [
    {"id": "1", "name": "Acme Corp"},
    {"id": "2", "name": "Globex Corporation"},
    {"id": "3", "name": "Soylent Corp"},
    // ... imagine 1000+ more items here
  ];

  String? selectedCustomerId;

  @override
  void onInit() async {
    super.onInit();
    setTodayRange(fromDate: fromDate.value, toDate: toDate.value);
    isAllSelected.value = false;
    isTodaySelected.value = true;
    isThisMonthSelected.value = false;
    isThisYearSelected.value = false;
    isYearSelected.value = false;
    isMonthSelected.value = false;
    isDaySelected.value = true;
    filterSearch();
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
    allJobCards.clear();
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

  Future<Map<String, dynamic>> getModelsByCarBrand(String brandID) async {
    return await helper.getModelsValues(brandID);
  }

  Future<Map<String, dynamic>> getCountries() async {
    return await helper.getCountries();
  }

  Future<Map<String, dynamic>> getCitiesByCountryID(String countryID) async {
    return await helper.getCitiesValues(countryID);
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
    return await helper.getUserBrunches();
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

  Future<double> calculateCustomerOutstanding(String customerId) async {
    return await helper.getCustomerOutstanding(customerId);
  }

  void onChooseForDatePicker(int i) {
    switch (i) {
      case 1:
        isTodaySelected.value = false;
        isThisMonthSelected.value = false;
        isThisYearSelected.value = false;
        fromDate.value.clear();
        toDate.value.clear();
        filterSearch();
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

  void onChooseForStatusPicker(int i) {
    switch (i) {
      case 1:
        statusFilter.value.clear();
        filterSearch();
        break;
      case 2:
        statusFilter.value.text = 'New';
        filterSearch();
        break;
      case 3:
        statusFilter.value.text = 'Posted';
        filterSearch();
        break;
      case 4:
        statusFilter.value.text = 'Cancelled';
        filterSearch();
        break;
      case 5:
        statusFilter.value.text = 'Approved';
        filterSearch();
        break;
      case 6:
        statusFilter.value.text = 'Ready';
        filterSearch();
        break;
      case 7:
        statusFilter.value.text = 'Draft';
        filterSearch();
        break;
      default:
    }
  }

  void onChooseForTypePicker(int i) {
    switch (i) {
      case 1:
        typeFilter.value.clear();
        filterSearch();
        break;
      case 2:
        typeFilter.value.text = 'JOB';
        filterSearch();
        break;
      case 3:
        typeFilter.value.text = 'SALE';
        filterSearch();
        break;

      default:
    }
  }

  void onChooseForLabelPicker(int i) {
    switch (i) {
      case 1:
        lableFilter.value.clear();
        filterSearch();
        break;
      case 2:
        lableFilter.value.text = 'Returned';
        filterSearch();
        break;
      case 3:
        lableFilter.value.text = 'Not Returned';
        filterSearch();
        break;

      default:
    }
  }

  Future<void> addNewJobCard() async {
    try {
      if (curreentJobCardId.isNotEmpty) {
        Map jobStatus = await getCurrentJobCardStatus(curreentJobCardId.value);
        String status1 = jobStatus['job_status_1'];
        if ((status1 != 'New' && status1 != '') && status1 != 'Draft') {
          alertMessage(
            context: Get.context!,
            content: 'Only new jobs can be edited',
          );
          return;
        }
      }
      addingNewValue.value = true;
      Map<String, dynamic> newData = {
        'label': isReturned.isTrue ? 'Returned' : '',
        'type': isSales.isTrue ? 'SALE' : 'JOB',
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
        'invoice_items': allInvoiceItems
            .where((inv) => inv.deleted != true)
            .map((item) => item.toJson())
            .toList(),
      };

      final rawDate = jobCardDate.value.text.trim();
      if (rawDate.isNotEmpty) {
        try {
          newData['job_date'] = convertDateToIson(rawDate);
        } catch (e) {
          alertMessage(
            context: Get.context!,
            content: 'Please enter valid job date',
          );
        }
      } else {
        newData['job_date'] = null;
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
      Uri addingJobUrl = Uri.parse('$backendUrl/job_cards/add_new_job_card');

      if (jobCardAdded.isFalse && curreentJobCardId.isEmpty) {
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
          canAddInternalNotesAndInvoiceItems.value = true;
          allJobCards.insert(0, newJob);
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
        if (isJobInvoicesModified.isTrue || isJobModified.isTrue) {}
        if (isJobModified.isTrue) {
          Uri updatingJobUrl = Uri.parse(
            '$backendUrl/job_cards/update_job_card/${curreentJobCardId.value}',
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
            final decoded = jsonDecode(response.body);
            JobCardModel updatedJob = JobCardModel.fromJson(
              decoded['job_card'],
            );
            invoiceCounter.value.text = updatedJob.invoiceNumber ?? '';
            int ind = allJobCards.indexWhere((job) => job.id == updatedJob.id);
            if (ind != -1) {
              allJobCards[ind] = updatedJob;
            }
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
      addingNewValue.value = false;
    } catch (e) {
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
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
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        final decoded =
            jsonDecode(response.body) ?? 'Failed to delete job card';
        String error = decoded['detail'];
        alertMessage(context: Get.context!, content: error);
      } else if (response.statusCode == 403) {
        final decoded = jsonDecode(response.body);
        String error = decoded['detail'] ?? 'Only New Job Cards Allowed';
        alertMessage(context: Get.context!, content: error);
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
        alertMessage(
          title: 'Server Error',
          context: Get.context!,
          content: error,
        );
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
    if (carBrandIdFilter.value.isNotEmpty) {
      body["car_brand"] = carBrandIdFilter.value;
    }
    if (carModelIdFilter.value.isNotEmpty) {
      body["car_model"] = carModelIdFilter.value;
    }
    if (jobNumberFilter.value.text.isNotEmpty) {
      body["job_number"] = jobNumberFilter.value.text;
    }
    if (typeFilter.value.text.isNotEmpty) {
      body["type"] = typeFilter.value.text;
    }
    if (invoiceNumberFilter.value.text.isNotEmpty) {
      body["invoice_number"] = invoiceNumberFilter.value.text;
    }
    if (plateNumberFilter.value.text.isNotEmpty) {
      body["plate_number"] = plateNumberFilter.value.text;
    }
    if (branchNameIdFilter.value.isNotEmpty) {
      body["branch"] = branchNameIdFilter.value;
    }
    if (vinFilter.value.text.isNotEmpty) {
      body["vin"] = vinFilter.value.text;
    }
    if (lpoFilter.value.text.isNotEmpty) {
      body["lpo"] = lpoFilter.value.text;
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
    if (lableFilter.value.text.isNotEmpty) {
      body["label"] = lableFilter.value.text;
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
        allJobsPaid.value = grandTotals['grand_paid'];
        allJobsOutstanding.value = grandTotals['grand_outstanding'];
        numberOfJobs.value = jobs.length;
        allJobCards.assignAll(jobs.map((job) => JobCardModel.fromJson(job)));
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

  // Future<void> searchEngine(
  //   Map<String, dynamic> body, {
  //   bool isNextPage = false,
  // }) async {
  //   try {
  //     isScreenLoding.value = true;

  //     final SharedPreferences prefs = await SharedPreferences.getInstance();
  //     var accessToken = '${prefs.getString('accessToken')}';
  //     final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
  //     Uri url = Uri.parse('$backendUrl/job_cards/search_engine_2');
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         'Authorization': 'Bearer $accessToken',
  //         "Content-Type": "application/json",
  //       },
  //       body: jsonEncode(body),
  //     );
  //     if (response.statusCode == 200) {
  //       final decoded = jsonDecode(response.body);
  //       List jobs = decoded['job_cards'];
  //       Map grandTotals = decoded['grand_totals'];
  //       allJobsTotals.value = grandTotals['grand_total'];
  //       allJobsVATS.value = grandTotals['grand_vat'];
  //       allJobsNET.value = grandTotals['grand_net'];
  //       allJobsPaid.value = grandTotals['grand_paid'];
  //       allJobsOutstanding.value = grandTotals['grand_outstanding'];
  //       // print(jobs[0]);
  //       numberOfJobs.value = jobs.length;
  //       allJobCards.assignAll(jobs.map((job) => JobCardModel.fromJson(job)));
  //     } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
  //       final refreshed = await helper.refreshAccessToken(refreshToken);
  //       if (refreshed == RefreshResult.success) {
  //         await searchEngine(body);
  //       } else if (refreshed == RefreshResult.invalidToken) {
  //         logout();
  //       }
  //     } else if (response.statusCode == 401) {
  //       logout();
  //     }

  //     isScreenLoding.value = false;
  //   } catch (e) {
  //     isScreenLoding.value = false;
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
        quantity: double.tryParse(quantity.text) ?? 0,
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

    if (index != -1) {
      final oldItem = allInvoiceItems[index];
      allInvoiceItems[index] = JobCardInvoiceItemsModel(
        id: oldItem.id,
        uid: oldItem.uid,
        nameId: invoiceItemNameId.value,
        name: invoiceItemName.text,
        lineNumber: int.tryParse(lineNumber.text) ?? 0,
        description: description.text,
        quantity: double.tryParse(quantity.text) ?? 0,
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
        alertMessage(
          context: Get.context!,
          content: 'Only Posted / Cancelled Jobs Can be Copied',
        );
        return;
      }
      Get.back();

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
        alertMessage(context: Get.context!, content: error);
      } else if (response.statusCode == 404) {
        final decoded = jsonDecode(response.body);
        String error = decoded['detail'];
        alertMessage(context: Get.context!, content: error);
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
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
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
        alertMessage(context: Get.context!, content: error);
      } else if (response.statusCode == 404) {
        final decoded = jsonDecode(response.body);
        String error = decoded['detail'];
        alertMessage(context: Get.context!, content: error);
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
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
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
        alertMessage(context: Get.context!, content: error);
      } else if (response.statusCode == 404) {
        final decoded = jsonDecode(response.body);
        String error = decoded['detail'];
        alertMessage(context: Get.context!, content: error);
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
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
      addingNewInternalNotProcess.value = false;
    }
  }

  Future<void> createQuotationCard(String id) async {
    try {
      creatingNewQuotation.value = true;
      Map quotationStatus = await getCurrentJobCardStatus(id);
      final status1 = quotationStatus['job_status_1'];
      if (status1 == 'Cancelled') {
        alertMessage(
          context: Get.context!,
          content: 'Can\'t create quotation for cancelled jobs',
        );
        creatingNewQuotation.value = false;
        return;
      }
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
        alertMessage(
          title: 'Done',
          context: Get.context!,
          content: 'Only Posted Jobs Allowed',
        );
        final decoded = jsonDecode(response.body);
        quotationCounter.value = decoded['quotation_number'];
        quotationId.value = decoded['quotation_card_id'];
      } else if (response.statusCode == 409) {
        final decoded = jsonDecode(response.body);
        alertMessage(context: Get.context!, content: decoded['detail']);
      } else if (response.statusCode == 403) {
        final decoded = jsonDecode(response.body);
        String error = decoded['detail'];
        alertMessage(context: Get.context!, content: error);
      } else if (response.statusCode == 404) {
        final decoded = jsonDecode(response.body);
        String error = decoded['detail'];
        alertMessage(context: Get.context!, content: error);
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
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  Future<void> createReceipt(String jobId, String customerId) async {
    try {
      creatingNewReceipt.value = true;
      Map quotationStatus = await getCurrentJobCardStatus(jobId);
      final status1 = quotationStatus['job_status_1'];
      if (status1 != 'Posted') {
        alertMessage(
          context: Get.context!,
          content: 'Only Posted Jobs Allowed',
        );
        creatingNewReceipt.value = false;
        return;
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/ar_receipts/create_receipt_for_job_card/$jobId/$customerId',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'multipart/form-data',
        },
      );
      if (response.statusCode == 200) {
        CashManagementReceiptsController receiptController = Get.put(
          CashManagementReceiptsController(),
        );
        final decoded = jsonDecode(response.body);
        ARReceiptsModel receipt = ARReceiptsModel.fromJson(decoded['receipt']);
        await receiptController.loadValuesForReceipts(receipt);
        await editReceipt(receiptController, receipt.id ?? '');
      } else if (response.statusCode == 422) {
        final decoded = jsonDecode(response.body);
        alertMessage(context: Get.context!, content: decoded['detail']);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await createReceipt(jobId, customerId);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }

      creatingNewReceipt.value = false;
    } catch (e) {
      creatingNewReceipt.value = false;
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  Future<void> editApproveForJobCard(String jobId, String status) async {
    if (jobStatus1.value.isEmpty) {
      alertMessage(context: Get.context!, content: 'Please Save The Job First');
      return;
    }
    Map jobStatus = await getCurrentJobCardStatus(jobId);
    String status1 = jobStatus['job_status_1'];
    String status2 = jobStatus['job_status_2'];
    if (status1 == 'New' && status2 != 'Approved') {
      approvalDate.value.text = textToDate(DateTime.now());
      jobStatus2.value = 'Approved';
      isJobModified.value = true;
      addNewJobCard();
    } else if (status2 == 'Approved') {
      alertMessage(context: Get.context!, content: 'Job is Already Approved');
    } else if (status1 == 'Posted') {
      alertMessage(context: Get.context!, content: 'Job is Posted');
    } else if (status1 == 'Cancelled') {
      alertMessage(context: Get.context!, content: 'Job is Cancelled');
    }
  }

  Future<InspectionReportModel> getJobCardInspctionReport(String id) async {
    try {
      loadingIspectionReport.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/inspection_reports/get_current_job_card_inspection_report_details/$id',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        InspectionReportModel resport = InspectionReportModel.fromJson(
          decoded['inspection_report'],
        );
        loadingIspectionReport.value = false;
        return resport;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getJobCardInspctionReport(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      loadingIspectionReport.value = false;
      return InspectionReportModel();
    } catch (e) {
      loadingIspectionReport.value = false;
      return InspectionReportModel();
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
        alertMessage(context: Get.context!, content: error);
      } else if (response.statusCode == 404) {
        final decoded = jsonDecode(response.body);
        String error = decoded['detail'];
        alertMessage(context: Get.context!, content: error);
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
    vat.text = ((double.tryParse(total.text))! * currentCountryVAT.value / 100)
        .toStringAsFixed(2);
    net.text = (double.tryParse(total.text)! + double.tryParse(vat.text)!)
        .toStringAsFixed(2);
  }

  void updateAmount() {
    if (net.text.isEmpty) net.text = '0';
    if (net.text != '0') {
      total.text =
          (double.tryParse(net.text)! / (1 + currentCountryVAT.value / 100))
              .toStringAsFixed(2);
      amount.text =
          (double.tryParse(total.text)! + double.tryParse(discount.text)!)
              .toStringAsFixed(2);
      price.text =
          (double.tryParse(amount.text)! / double.tryParse(quantity.text)!)
              .toStringAsFixed(2);
      vat.text =
          ((double.tryParse(total.text))! * (currentCountryVAT.value) / 100)
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

  void clearValues(bool isJob) {
    if (isJob) {
      isSales.value = false;
    } else {
      isSales.value = true;
    }
    customerBranch.text = companyDetails['current_user_branch_name'] ?? '';
    customerBranchId.value = companyDetails['current_user_branch_id'] ?? '';
    isReturned.value = false;
    quotationId.value = '';
    currentCountryVAT.value =
        (companyDetails['vat_percentage'] != null
            ? companyDetails['vat_percentage'] * 100
            : null) ??
        companyDetails['country_vat'] ??
        0;
    country.text = companyDetails.containsKey('country')
        ? companyDetails['country'] ?? ""
        : "";
    countryId.value = companyDetails.containsKey('country_id')
        ? companyDetails['country_id'] ?? ""
        : "";
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

  Future loadInspectionFormValues(String id) async {
    InspectionReportModel report = await getJobCardInspctionReport(id);
    InspectionReportDetails details =
        report.inspectionReportDetails ?? InspectionReportDetails();

    List inspectionReport = companyDetails['inspection_report'] ?? [];
    if (inspectionReport.contains('Break And Tire')) {
      controller.canShowBreakAndTire.value = true;
    } else {
      controller.canShowBreakAndTire.value = false;
    }
    if (inspectionReport.contains('Interior / Exterior')) {
      controller.canShowInteriorExterior.value = true;
    } else {
      controller.canShowInteriorExterior.value = false;
    }
    if (inspectionReport.contains('Under Vehicle')) {
      controller.canShowUnderVehicle.value = true;
    } else {
      controller.canShowUnderVehicle.value = false;
    }
    if (inspectionReport.contains('Under Hood')) {
      controller.canShowUnderHood.value = true;
    } else {
      controller.canShowUnderHood.value = false;
    }
    if (inspectionReport.contains('Battery Performace')) {
      controller.canShowBatteryPerformance.value = true;
    } else {
      controller.canShowBatteryPerformance.value = false;
    }
    if (inspectionReport.contains('Body Damage')) {
      controller.canShowBodyDamage.value = true;
    } else {
      controller.canShowBodyDamage.value = false;
    }

    controller.imagesList.clear();
    controller.currenyJobId.value = id;
    controller.inEditMode.value = true;
    controller.technicianId.value = report.technicianId ?? '';
    controller.date.text = textToDate(report.jobDate);
    controller.customer.text = report.customerName ?? '';
    controller.customerId.value = report.customerId ?? '';
    controller.brand.text = report.carBrandName ?? '';
    controller.brandId.value = report.carBrandId ?? '';
    controller.model.text = report.carModelName ?? '';
    controller.modelId.value = report.carModelId ?? '';
    controller.color.text = report.colorName ?? '';
    controller.colorId.value = report.colorId ?? '';
    controller.plateNumber.text = report.plateNumber ?? '';
    controller.code.text = report.plateCode ?? '';
    controller.engineType.text = report.engineTypeName ?? '';
    controller.year.text = report.year?.toString() ?? '';
    controller.mileage.text = report.mileageIn?.toString() ?? '';
    controller.vin.text = report.vehicleIdentificationNumber ?? '';
    controller.comments.text = details.comment ?? '';
    controller.selectedCheckBoxIndicesForLeftFront.assignAll(
      wheelCheckToMap(details.leftFrontWheel),
    );
    controller.leftFrontBrakeLining.text =
        controller
            .selectedCheckBoxIndicesForLeftFront['Brake Lining']?['value'] ??
        '';
    controller.leftFrontTireTread.text =
        controller
            .selectedCheckBoxIndicesForLeftFront['Tire Tread']?['value'] ??
        '';

    controller.leftFrontWearPattern.text =
        controller
            .selectedCheckBoxIndicesForLeftFront['Wear Pattern']?['value'] ??
        '';
    controller.leftFrontTirePressureBefore.text =
        controller
            .selectedCheckBoxIndicesForLeftFront['Tire Pressure PSI']?['before'] ??
        '';
    controller.leftFrontTirePressureAfter.text =
        controller
            .selectedCheckBoxIndicesForLeftFront['Tire Pressure PSI']?['after'] ??
        '';

    controller.selectedCheckBoxIndicesForRightFront.assignAll(
      wheelCheckToMap(details.rightFrontWheel),
    );

    controller.rightFrontBrakeLining.text =
        controller
            .selectedCheckBoxIndicesForRightFront['Brake Lining']?['value'] ??
        '';
    controller.rightFrontTireTread.text =
        controller
            .selectedCheckBoxIndicesForRightFront['Tire Tread']?['value'] ??
        '';

    controller.rightFrontWearPattern.text =
        controller
            .selectedCheckBoxIndicesForRightFront['Wear Pattern']?['value'] ??
        '';
    controller.rightFrontTirePressureBefore.text =
        controller
            .selectedCheckBoxIndicesForRightFront['Tire Pressure PSI']?['before'] ??
        '';
    controller.rightFrontTirePressureAfter.text =
        controller
            .selectedCheckBoxIndicesForRightFront['Tire Pressure PSI']?['after'] ??
        '';

    controller.selectedCheckBoxIndicesForLeftRear.assignAll(
      wheelCheckToMap(details.leftRearWheel),
    );

    controller.leftRearBrakeLining.text =
        controller
            .selectedCheckBoxIndicesForLeftRear['Brake Lining']?['value'] ??
        '';
    controller.leftRearTireTread.text =
        controller.selectedCheckBoxIndicesForLeftRear['Tire Tread']?['value'] ??
        '';

    controller.leftRearWearPattern.text =
        controller
            .selectedCheckBoxIndicesForLeftRear['Wear Pattern']?['value'] ??
        '';
    controller.leftRearTirePressureBefore.text =
        controller
            .selectedCheckBoxIndicesForLeftRear['Tire Pressure PSI']?['before'] ??
        '';
    controller.leftRearTirePressureAfter.text =
        controller
            .selectedCheckBoxIndicesForLeftRear['Tire Pressure PSI']?['after'] ??
        '';

    controller.selectedCheckBoxIndicesForRightRear.assignAll(
      wheelCheckToMap(details.rightRearWheel),
    );

    controller.rightRearBrakeLining.text =
        controller
            .selectedCheckBoxIndicesForRightRear['Brake Lining']?['value'] ??
        '';
    controller.rightRearTireTread.text =
        controller
            .selectedCheckBoxIndicesForRightRear['Tire Tread']?['value'] ??
        '';

    controller.rightRearWearPattern.text =
        controller
            .selectedCheckBoxIndicesForRightRear['Wear Pattern']?['value'] ??
        '';
    controller.rightRearTirePressureBefore.text =
        controller
            .selectedCheckBoxIndicesForRightRear['Tire Pressure PSI']?['before'] ??
        '';
    controller.rightRearTirePressureAfter.text =
        controller
            .selectedCheckBoxIndicesForRightRear['Tire Pressure PSI']?['after'] ??
        '';

    controller.selectedCheckBoxIndicesForInteriorExterior.assignAll(
      interiorExteriorToMap(details.interiorExterior),
    );

    controller.selectedCheckBoxIndicesForUnderVehicle.assignAll(
      underVehicleToMap(details.underVehicle),
    );

    controller.selectedCheckBoxIndicesForUnderHood.assignAll(
      underHoodToMap(details.underHood),
    );

    controller.selectedCheckBoxIndicesForBatteryPerformance.assignAll(
      batteryPerformanceToMap(details.batteryPerformance),
    );

    controller.batteryColdCrankingAmpsFactorySpecs.text =
        controller
            .selectedCheckBoxIndicesForBatteryPerformance['Battery Cold Cranking Amps']?['Factory Specs'] ??
        '';
    controller.batteryColdCrankingAmpsActual.text =
        controller
            .selectedCheckBoxIndicesForBatteryPerformance['Battery Cold Cranking Amps']?['Actual'] ??
        '';

    controller.selectedCheckBoxIndicesForSingleCheckBoxForBrakeAndTire
        .assignAll(extraChecksToMap(details.extraChecks));

    List<CarImage> urls = details.carImages ?? [];

    if (urls.isNotEmpty) {
      controller.carImagesURLs.assignAll(urls);
    }
    controller.customerSignatureURL.value = details.customerSugnature ?? '';
    controller.advisorSignatureURL.value = details.advisorSugnature ?? '';
    controller.carDialogImageURL.value = details.carDialog ?? '';
    controller.carBrandLogo.value = report.carLogo ?? '';
  }

  Future<void> loadValues(JobCardModel data) async {
    data.type == 'SALES' ? isSales.value = true : isSales.value = false;
    quotationId.value = data.quotationId ?? '';
    jobCardAdded.value = true;
    isReturned.value = data.label == 'Returned' ? true : false;
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
      alertMessage(context: Get.context!, content: 'Please Save The Job First');
      return;
    }
    Map jobStatus = await getCurrentJobCardStatus(jobId);
    String status1 = jobStatus['job_status_1'];
    String status2 = jobStatus['job_status_2'];
    if (status1 == 'New' && status2 != 'Ready') {
      jobStatus2.value = 'Ready';
      finishDate.value.text = textToDate(DateTime.now());
      isJobModified.value = true;
      addNewJobCard();
    } else if (status2 == 'Ready') {
      alertMessage(context: Get.context!, content: 'Job is Already Ready');
    } else if (status1 == 'Posted') {
      alertMessage(context: Get.context!, content: 'Job is Posted');
    } else if (status1 == 'Cancelled') {
      alertMessage(context: Get.context!, content: 'Job is Cancelled');
    }
  }

  Future<void> editNewForJobCard(String jobId, String status) async {
    if (jobStatus1.value.isEmpty) {
      alertMessage(context: Get.context!, content: 'Please Save The Job First');
      return;
    }
    Map jobStatus = await getCurrentJobCardStatus(jobId);
    String status1 = jobStatus['job_status_1'];
    String status2 = jobStatus['job_status_2'];
    if ((status1 == 'New' && status2 != 'New') ||
        (status1 == 'Draft' && status2 == 'Draft')) {
      finishDate.value.text = '';
      approvalDate.value.text = '';
      jobStatus2.value = status;
      jobStatus1.value = status;
      isJobModified.value = true;
      await addNewJobCard();
    } else if (status2 == 'New') {
      alertMessage(context: Get.context!, content: 'Job is Already New');
    } else if (status1 == 'Cancelled') {
      alertMessage(context: Get.context!, content: 'Job is Cancelled');

      // finishDate.value.text = '';
      // approvalDate.value.text = '';
      // jobStatus2.value = status;
      // jobStatus1.value = status;
      // isJobModified.value = true;
    } else if (status1 == 'Posted') {
      alertMessage(context: Get.context!, content: 'Job is Posted');
    }
  }

  Future<void> editCancelForJobCard(String jobId, String status) async {
    if (jobStatus1.value.isEmpty) {
      alertMessage(context: Get.context!, content: 'Please Save The Job First');
      return;
    }
    Map jobStatus = await getCurrentJobCardStatus(jobId);
    String status1 = jobStatus['job_status_1'];
    String status2 = jobStatus['job_status_2'];
    if (status1 == 'Cancelled') {
      alertMessage(context: Get.context!, content: 'Job is Already Cancelled');
    } else if (status1 == 'Posted') {
      alertMessage(context: Get.context!, content: 'Job is Posted');
    } else if (status1 != 'Cancelled' &&
        status2 != 'Cancelled' &&
        status1 != '') {
      alertDialog(
        context: Get.context!,
        content: 'Are you sure you want to cancel this job card?',
        onPressed: () async {
          jobCancelationDate.value.text = textToDate(DateTime.now());
          jobStatus1.value = status;
          jobStatus2.value = status;
          isJobModified.value = true;
          Get.back();
          await addNewJobCard();
        },
      );
    }
  }

  Future<void> editPostForJobCard(String jobId) async {
    if (jobStatus1.value.isEmpty) {
      alertMessage(context: Get.context!, content: 'Please Save The Job First');
      return;
    }
    Map jobStatus = await getCurrentJobCardStatus(jobId);
    String status1 = jobStatus['job_status_1'];
    if (status1 == 'Posted') {
      alertMessage(context: Get.context!, content: 'Job is Already Posted');
    } else if (status1 == 'Cancelled') {
      alertMessage(context: Get.context!, content: 'Job is Cancelled');
    } else if (jobWarrentyEndDate.value.text.isEmpty &&
        status1.isNotEmpty &&
        status1 != 'Cancelled' &&
        status1 != 'Posted') {
      alertMessage(
        context: Get.context!,
        content: 'You Must Enter Warranty End Date First',
      );
    } else {
      alertDialog(
        context: Get.context!,
        content: 'Are you sure you want to post this job card?',
        onPressed: () async {
          if (isBeforeToday(jobWarrentyEndDate.value.text)) {
            jobStatus2.value = 'Closed';
          } else {
            jobStatus2.value = 'Warranty';
          }
          jobStatus1.value = 'Posted';
          invoiceDate.value.text = textToDate(DateTime.now());
          isJobModified.value = true;
          Get.back();
          await addNewJobCard();
        },
      );
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

  void onSelectForCustomers(String id, Map selectedCustomer) async {
    List phoneDetails = selectedCustomer['entity_phone'];
    Map phone = phoneDetails.firstWhere(
      (value) => value['isPrimary'] == true,
      orElse: () => {'phone': ''},
    );

    customerEntityPhoneNumber.text = phone['number'] ?? '';
    customerEntityName.text = phone['name'] ?? '';
    customerEntityEmail.text = phone['email'] ?? '';
    customerSaleManId.value = selectedCustomer['salesman_id'] ?? '';
    customerSaleMan.value = selectedCustomer['salesman'] ?? "";

    customerCreditNumber.value = formatter.formatEditUpdate(
      customerOutstanding.value,
      TextEditingValue(
        text: (selectedCustomer['credit_limit'] ?? '0').toString(),
      ),
    );

    customerOutstanding.value = formatter.formatEditUpdate(
      customerOutstanding.value,
      TextEditingValue(
        text: await calculateCustomerOutstanding(id).then((value) {
          return value.toString();
        }),
      ),
    );
  }

  void clearAllFilters() {
    lableFilter.value.clear();
    lpoFilter.value.clear();
    statusFilter.value.clear();
    isAllSelected.value = false;
    isTodaySelected.value = false;
    isThisMonthSelected.value = false;
    isThisYearSelected.value = false;
    jobNumberFilter.value.clear();
    invoiceNumberFilter.value.clear();
    carBrandIdFilterName.value = TextEditingController();
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
