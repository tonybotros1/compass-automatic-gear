import 'dart:convert';
import 'dart:typed_data';
import 'package:datahubai/Models/job%20cards/job_card_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../Models/job cards/internal_notes_model.dart';
import '../../Models/job cards/job_card_invoice_items_model.dart';
import '../../Models/quotation cards/quotation_cards_model.dart';
import '../../Screens/Main screens/System Administrator/Setup/job_card.dart';
import '../../Widgets/main screen widgets/job_cards_widgets/print_delivery_note.dart';
import '../../Widgets/main screen widgets/job_cards_widgets/print_invoice_pdf.dart';
import '../../consts.dart';
import '../../helpers.dart';
import 'car_brands_controller.dart';
import 'countries_controller.dart';
import 'job_card_controller.dart';
import 'list_of_values_controller.dart';
import 'main_screen_contro.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class QuotationCardController extends GetxController {
  Rx<TextEditingController> quotationCounter = TextEditingController().obs;
  RxString jobCardCounter = RxString('');
  RxString jobCardId = RxString('');
  Rx<TextEditingController> quotationDate = TextEditingController().obs;
  Rx<TextEditingController> quotationDays = TextEditingController().obs;
  Rx<TextEditingController> validityEndDate = TextEditingController().obs;
  Rx<TextEditingController> referenceNumber = TextEditingController().obs;
  Rx<TextEditingController> deliveryTime = TextEditingController().obs;
  Rx<TextEditingController> quotationWarrentyDays = TextEditingController().obs;
  Rx<TextEditingController> quotationWarrentyKM = TextEditingController().obs;
  TextEditingController quotationNotes = TextEditingController();
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
  TextEditingController customerSaleMan = TextEditingController();
  TextEditingController customerBranch = TextEditingController();
  TextEditingController customerCurrency = TextEditingController();
  TextEditingController customerCurrencyRate = TextEditingController();
  Rx<TextEditingController> mileageIn = TextEditingController().obs;
  // Rx<TextEditingController> fuelAmount = TextEditingController().obs;
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(false);
  RxBool loadingInvoiceItems = RxBool(false);
  final RxList<QuotationCardsModel> allQuotationCards =
      RxList<QuotationCardsModel>([]);
  // final RxList<QueryDocumentSnapshot<Map<String, dynamic>>>
  // filteredQuotationCards = RxList<QueryDocumentSnapshot<Map<String, dynamic>>>(
  //   [],
  // );
  final RxList<JobCardInvoiceItemsModel> allInvoiceItems =
      RxList<JobCardInvoiceItemsModel>([]);
  final ScrollController scrollControllerFotTable1 = ScrollController();
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
  RxString query = RxString('');
  RxString queryForInvoiceItems = RxString('');
  RxString userId = RxString('');
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxMap allBrands = RxMap({});
  RxMap allTechnicians = RxMap({});
  RxMap allCustomers = RxMap({});
  RxMap salesManMap = RxMap({});
  RxBool addingNewValue = RxBool(false);
  RxBool creatingNewJob = RxBool(false);
  RxString companyId = RxString('');
  RxMap companyDetails = RxMap({});
  RxMap allCountries = RxMap({});
  RxMap allColors = RxMap({});
  RxMap allEngineType = RxMap({});
  RxMap allBranches = RxMap({});
  RxMap allCurrencies = RxMap({});
  RxMap allInvoiceItemsFromCollection = RxMap({});
  RxMap allUsers = RxMap();
  RxBool loadingCopyQuotation = RxBool(false);
  RxBool loadingMakeJob = RxBool(false);
  var selectedRowIndex = Rxn<int>();
  final ScrollController scrollController = ScrollController();
  RxString quotationStatus = RxString('');
  DateFormat format = DateFormat("dd-MM-yyyy");
  RxString curreentQuotationCardId = RxString('');
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
  RxDouble currentCountryVAT = RxDouble(0.0);
  TextEditingController net = TextEditingController();
  RxBool addingNewinvoiceItemsValue = RxBool(false);
  RxBool quotationCardAdded = RxBool(false);
  RxInt pagesPerPage = RxInt(5);
  RxBool canAddInternalNotesAndInvoiceItems = RxBool(false);
  var buttonLoadingStates = <String, bool>{}.obs;
  final ScrollController scrollControllerForNotes = ScrollController();
  Rx<Uint8List?> fileBytes = Rx<Uint8List?>(null);
  RxString fileType = RxString('');
  RxString fileName = RxString('');
  FocusNode textFieldFocusNode = FocusNode();
  Rx<TextEditingController> internalNote = TextEditingController().obs;
  RxString noteMessage = RxString('');
  RxBool addingNewInternalNotProcess = RxBool(false);
  RxBool openingJobCardScreen = RxBool(false);
  RxInt numberOfQuotations = RxInt(0);
  RxDouble allQuotationsVATS = RxDouble(0.0);
  RxDouble allQuotationsTotals = RxDouble(0.0);
  RxDouble allQuotationsNET = RxDouble(0.0);
  RxBool isYearSelected = RxBool(false);
  RxBool isMonthSelected = RxBool(false);
  RxBool isDaySelected = RxBool(false);
  RxBool isTodaySelected = RxBool(false);
  RxBool isAllSelected = RxBool(false);
  RxBool isThisMonthSelected = RxBool(false);
  RxBool isThisYearSelected = RxBool(false);
  // search section
  Rx<TextEditingController> quotaionNumberFilter = TextEditingController().obs;
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
  String backendUrl = backendTestURI;
  RxBool isQuotationInvoicesModified = RxBool(false);
  RxBool isQuotationModified = RxBool(false);
  final Uuid _uuid = const Uuid();
  RxBool isQuotationInternalNotesLoading = RxBool(false);
  final RxList<InternalNotesModel> allInternalNotes =
      RxList<InternalNotesModel>([]);
  CarBrandsController carBrandsController = Get.put(CarBrandsController());
  CountriesController countriesController = Get.put(CountriesController());
  ListOfValuesController listOfValuesController = Get.put(
    ListOfValuesController(),
  );

  ScrollController scrollerForCarDetails = ScrollController();
  ScrollController scrollerForCustomer = ScrollController();
  ScrollController scrollerForQuotationSection = ScrollController();
  RxInt initDatePickerValue = RxInt(1);
  RxInt initStatusPickersValue = RxInt(1);

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

  final FocusNode focusNodeForCustomerDetails1 = FocusNode();
  final FocusNode focusNodeForCustomerDetails2 = FocusNode();
  final FocusNode focusNodeForCustomerDetails3 = FocusNode();
  final FocusNode focusNodeForCustomerDetails4 = FocusNode();
  final FocusNode focusNodeForCustomerDetails5 = FocusNode();
  final FocusNode focusNodeForCustomerDetails6 = FocusNode();
  final FocusNode focusNodeForCustomerDetails7 = FocusNode();
  final FocusNode focusNodeForCustomerDetails8 = FocusNode();

  final FocusNode focusNodeForQuotationDetails1 = FocusNode();

  final FocusNode focusNodeForItemsDetails1 = FocusNode();
  final FocusNode focusNodeForItemsDetails2 = FocusNode();
  final FocusNode focusNodeForItemsDetails3 = FocusNode();
  final FocusNode focusNodeForItemsDetails4 = FocusNode();
  final FocusNode focusNodeForItemsDetails5 = FocusNode();
  final FocusNode focusNodeForItemsDetails6 = FocusNode();
  final FocusNode focusNodeForItemsDetails7 = FocusNode();

  @override
  void onInit() async {
    super.onInit();
    // filterSearch();
    await getCompanyDetails();
    getAllUsers();
  }

  Future<void> getAllUsers() async {
    allUsers.assignAll(await helper.getSysUsers());
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
    return await helper.getBrunches();
  }

  Future<Map<String, dynamic>> getAllCustomers() async {
    return await helper.getCustomers();
  }

  Future<Map<String, dynamic>> getInvoiceItemsFromCollection() async {
    return await helper.getInvoiceItems();
  }

  Future getCurrentQuotationCardStatus(String id) async {
    return await helper.getQuotationCardStatus(id);
  }

  void onChooseForDatePicker(int i) {
    switch (i) {
      case 1:
        initDatePickerValue.value = 1;
        isTodaySelected.value = false;
        isThisMonthSelected.value = false;
        isThisYearSelected.value = false;
        fromDate.value.clear();
        toDate.value.clear();
        filterSearch();
        break;
      case 2:
        initDatePickerValue.value = 2;
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
        initDatePickerValue.value = 3;
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
        initDatePickerValue.value = 4;
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
        initStatusPickersValue.value = 1;
        statusFilter.value.clear();
        filterSearch();
        break;
      case 2:
        initStatusPickersValue.value = 2;
        statusFilter.value.text = 'New';
        filterSearch();
        break;
      case 3:
        initStatusPickersValue.value = 3;
        statusFilter.value.text = 'Posted';
        filterSearch();
        break;
      case 4:
        initStatusPickersValue.value = 4;
        statusFilter.value.text = 'Cancelled';
        filterSearch();
        break;
      default:
    }
  }

  Future<void> addNewQuotationCard() async {
    try {
      if (curreentQuotationCardId.isNotEmpty) {
        Map jobStatus = await getCurrentQuotationCardStatus(
          curreentQuotationCardId.value,
        );
        String status1 = jobStatus['quotation_status'];
        if (status1 != 'New' && status1 != '') {
          alertMessage(
            context: Get.context!,
            content: 'Only new quotation can be edited',
          );
          return;
        }
      }
      addingNewValue.value = true;
      Map<String, dynamic> newData = {
        'quotation_status': quotationStatus.value,
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
        'validity_days': int.tryParse(quotationDays.value.text) ?? 0,
        'validity_end_date': convertDateToIson(validityEndDate.value.text),
        'reference_number': referenceNumber.value.text,
        'delivery_time': deliveryTime.value.text,
        'quotation_warranty_days':
            int.tryParse(quotationWarrentyDays.value.text) ?? 0,
        'quotation_warranty_km':
            double.tryParse(quotationWarrentyKM.value.text) ?? 0,
        'quotation_notes': quotationNotes.text,
        'invoice_items': allInvoiceItems
            .where((inv) => inv.deleted != true)
            .map((item) => item.toJsonForQuotation())
            .toList(),
      };

      final rawDate = quotationDate.value.text.trim();
      if (rawDate.isNotEmpty) {
        try {
          newData['quotation_date'] = convertDateToIson(rawDate);
        } catch (e) {
          alertMessage(
            context: Get.context!,
            content: 'Please enter valid job date',
          );
        }
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri addingJobUrl = Uri.parse(
        '$backendUrl/quotation_cards/add_new_quotation_card',
      );

      if (quotationCardAdded.isFalse && curreentQuotationCardId.isEmpty) {
        newData['quotation_status'] = 'New';
        final response = await http.post(
          addingJobUrl,
          headers: {
            'Authorization': 'Bearer $accessToken',
            "Content-Type": "application/json",
          },
          body: jsonEncode(newData),
        );
        if (response.statusCode == 200) {
          quotationStatus.value = 'New';
          final decoded = jsonDecode(response.body);
          QuotationCardsModel newQuotation = QuotationCardsModel.fromJson(
            decoded['quotation_card'],
          );
          quotationCounter.value.text = newQuotation.quotationNumber ?? '';
          quotationCardAdded.value = true;
          addingNewValue.value = false;
          curreentQuotationCardId.value = newQuotation.id ?? '';
          allInvoiceItems.value = newQuotation.invoiceItemsDetails ?? [];
          isQuotationInvoicesModified.value = false;
          isQuotationModified.value = false;
          allQuotationCards.add(newQuotation);
        } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
          final refreshed = await helper.refreshAccessToken(refreshToken);
          if (refreshed == RefreshResult.success) {
            await addNewQuotationCard();
          } else if (refreshed == RefreshResult.invalidToken) {
            logout();
          }
        } else if (response.statusCode == 401) {
          logout();
        }
      } else {
        if (isQuotationModified.isTrue) {
          Uri updatingJobUrl = Uri.parse(
            '$backendUrl/quotation_cards/update_quotation_card/$curreentQuotationCardId',
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
            QuotationCardsModel updated = QuotationCardsModel.fromJson(
              decoded['quotation_card'],
            );
            int ind = allQuotationCards.indexWhere(
              (job) => job.id == updated.id,
            );
            if (ind != -1) {
              allQuotationCards[ind] = updated;
            }
            isQuotationModified.value = false;
          } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
            final refreshed = await helper.refreshAccessToken(refreshToken);
            if (refreshed == RefreshResult.success) {
              await addNewQuotationCard();
            } else if (refreshed == RefreshResult.invalidToken) {
              logout();
            }
          } else if (response.statusCode == 401) {
            logout();
          }
        }
        if (isQuotationInvoicesModified.isTrue) {
          Uri updatingJobInvoicesUrl = Uri.parse(
            '$backendUrl/quotation_cards/update_quotation_invoice_items',
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
                  .map((item) => item.toJsonForQuotation())
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
            isQuotationInvoicesModified.value = false;
          } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
            final refreshed = await helper.refreshAccessToken(refreshToken);
            if (refreshed == RefreshResult.success) {
              await addNewQuotationCard();
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
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
      addingNewValue.value = false;
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
        quantity: double.tryParse(quantity.text) ?? 0,
        price: double.tryParse(price.text) ?? 0.0,
        amount: double.tryParse(amount.text) ?? 0.0,
        discount: double.tryParse(discount.text) ?? 0.0,
        total: double.tryParse(total.text) ?? 0.0,
        vat: double.tryParse(vat.text) ?? 0.0,
        net: double.tryParse(net.text) ?? 0.0,
        jobId: curreentQuotationCardId.value,
      ),
    );
    isQuotationInvoicesModified.value = true;
    Get.back();
  }

  Future<void> deleteInvoiceItem(String itemId) async {
    int index = allInvoiceItems.indexWhere(
      (item) => (item.id == itemId || item.uid == itemId),
    );
    allInvoiceItems[index].deleted = true;
    allInvoiceItems.refresh();
    isQuotationInvoicesModified.value = true;
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
    isQuotationInvoicesModified.value = true;
    Get.back();
  }

  Future<void> deleteQuotationCard(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/quotation_cards/delete_quotation_card/$id',
      );
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        String deletedQuotationId = decoded['quotation_id'];
        allQuotationCards.removeWhere((job) => job.id == deletedQuotationId);
        numberOfQuotations.value -= 1;
        Get.close(2);
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        final decoded =
            jsonDecode(response.body) ?? 'Failed to delete quotation card';
        String error = decoded['detail'];
        alertMessage(context: Get.context!, content: error);
      } else if (response.statusCode == 403) {
        final decoded = jsonDecode(response.body);
        String error = decoded['detail'] ?? 'Only New Quotation Cards Allowed';
        alertMessage(context: Get.context!, content: error);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteQuotationCard(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 500) {
        final decoded = jsonDecode(response.body);
        final error =
            decoded['detail'] ?? 'Server error while deleting job card';
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

  Future<void> editPostForQuotation(String id) async {
    if (quotationStatus.value.isEmpty) {
      alertMessage(
        context: Get.context!,
        content: 'Please save the quotation first',
      );
      return;
    }

    Map currentQuotationStatus = await getCurrentQuotationCardStatus(id);
    String qstatus = currentQuotationStatus['quotation_status'];
    if (qstatus == 'Posted') {
      alertMessage(
        context: Get.context!,
        content: 'Quotation is Already Posted',
      );
    } else if (qstatus == 'Cancelled') {
      alertMessage(context: Get.context!, content: 'Quotation is Cancelled');
    } else {
      alertDialog(
        context: Get.context!,
        content: 'Do you want to post this quotation?',
        onPressed: () {
          quotationStatus.value = 'Posted';
          isQuotationModified.value = true;
          Get.back();
          addNewQuotationCard();
        },
      );
    }
  }

  Future<void> editCancelForQuotation(String id) async {
    if (quotationStatus.value.isEmpty) {
      alertMessage(
        context: Get.context!,
        content: 'Please Save The Quotation First',
      );

      return;
    }
    Map currentQuotationStatus = await getCurrentQuotationCardStatus(id);
    String status1 = currentQuotationStatus['quotation_status'];
    if (status1 == 'Cancelled') {
      alertMessage(
        context: Get.context!,
        content: 'Quotation is Already Cancelled',
      );
    } else if (status1 == 'Posted') {
      alertMessage(context: Get.context!, content: 'Quotation is Posted');
    } else {
      alertDialog(
        context: Get.context!,
        content: 'Do you want to cancel this quotation?',
        onPressed: () {
          quotationStatus.value = 'Cancelled';
          isQuotationModified.value = true;
          Get.back();
          addNewQuotationCard();
        },
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
    if (quotaionNumberFilter.value.text.isNotEmpty) {
      body["quotation_number"] = quotaionNumberFilter.value.text;
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
      Uri url = Uri.parse(
        '$backendUrl/quotation_cards/search_engine_for_quotation_cards_2',
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
        List jobs = decoded['quotation_cards'];
        Map grandTotals = decoded['grand_totals'] ?? 0;
        allQuotationsTotals.value = grandTotals['grand_total'] ?? 0;
        allQuotationsVATS.value = grandTotals['total_vat'] ?? 0;
        allQuotationsNET.value = grandTotals['total_items_net'] ?? 0;
        numberOfQuotations.value = grandTotals['total_items_count'] ?? 0;
        allQuotationCards.assignAll(
          jobs.map((job) => QuotationCardsModel.fromJson(job)),
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
      } else {
        isScreenLoding.value = false;
      }

      isScreenLoding.value = false;
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  Future copyQuotation(String id) async {
    try {
      Map quotationStatus = await getCurrentQuotationCardStatus(id);
      final status1 = quotationStatus['quotation_status'];
      if (status1 == 'New' || status1 == 'Approved' || status1 == 'Ready') {
        alertMessage(
          context: Get.context!,
          content: 'Only Posted / Cancelled Quotations Can be Copied',
        );

        return;
      }
      Get.back();

      loadingCopyQuotation.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/quotation_cards/copy_quotation_card/$id',
      );
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        var copiedQuotationData = decoded['copied_quotation'];
        QuotationCardsModel copiedQuotation = QuotationCardsModel.fromJson(
          copiedQuotationData,
        );
        allQuotationCards.add(copiedQuotation);
        return copiedQuotation;
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
          await copyQuotation(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }

      loadingCopyQuotation.value = false;
    } catch (e) {
      loadingCopyQuotation.value = false;
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  Future<void> getQuotationCardInternalNotes(String id) async {
    try {
      isQuotationInternalNotesLoading.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/quotation_cards/get_all_internal_notes_for_quotation_card/$id',
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
          await getQuotationCardInternalNotes(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      isQuotationInternalNotesLoading.value = false;
    } catch (e) {
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
      isQuotationInternalNotesLoading.value = false;
    }
  }

  Future<void> addNewInternalNote(String id, Map<String, dynamic> note) async {
    try {
      addingNewInternalNotProcess.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/quotation_cards/add_new_internal_note_for_quotation_card/$id',
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
          await addNewInternalNote(id, note);
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

  Future<void> createNewJobCard(String id) async {
    try {
      Map quotationStatus = await getCurrentQuotationCardStatus(id);
      final status1 = quotationStatus['quotation_status'];
      if (status1 != 'Posted') {
        alertMessage(
          context: Get.context!,
          content: 'Only Posted Quotations Allowed',
        );
        return;
      }
      creatingNewJob.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/quotation_cards/create_job_card_for_current_quotation/$id',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'multipart/form-data',
        },
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        jobCardCounter.value = decoded['job_number'];
        jobCardId.value = decoded['job_card_id'];
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
          await createNewJobCard(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      creatingNewJob.value = false;
    } catch (e) {
      creatingNewJob.value = false;
      alertMessage(
        context: Get.context!,
        content: 'Something went wrong please try again',
      );
    }
  }

  // ====================== print quotation ========================
  List<List<T>> chunkList<T>(List<T> list, int chunkSize) {
    if (chunkSize == 0) {
      chunkSize = 1;
    }
    List<List<T>> chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(
        list.sublist(
          i,
          i + chunkSize > list.length ? list.length : i + chunkSize,
        ),
      );
    }
    return chunks;
  }

  void printQuotation() async {
    // Map jobStatus = await getCurrentJobCardStatus(curreentJobCardId.value);
    // String status1 = jobStatus['job_status_1'];
    // if ((status1 != 'Posted')) {
    //   alertMessage(
    //     context: Get.context!,
    //     content: 'Only posted jobs can be print',
    //   );
    //   return;
    // }
    final pdfData = await generateQuotationPdf();

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfData);
  }

  Future<Uint8List> generateQuotationPdf() async {
    var headerImage = await networkImageToPdf(
      companyDetails.containsKey('header_url')
          ? companyDetails['header_url'] ?? ''
          : '',
    );
    var footerImage = await networkImageToPdf(
      companyDetails.containsKey('footer_url')
          ? companyDetails['footer_url'] ?? ''
          : '',
    );
    List totals = calculateTotals();
    double net = totals[2] ?? 0;
    final rowsPerPage = 12;
    final chunkedItems = chunkList(
      allInvoiceItems.where((inv) => inv.deleted != true).toList(),
      rowsPerPage,
    );
    String netInWords = await convertNumberToWords(
      net,
      customerCurrencyId.value,
    );

    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(0),
        header: (context) =>
            pw.Image(headerImage, height: 115, fit: pw.BoxFit.fitWidth),
        footer: (context) =>
            pw.Image(footerImage, height: 100, fit: pw.BoxFit.fitWidth),
        build: (context) {
          return [
            ...List.generate(chunkedItems.isEmpty ? 1 : chunkedItems.length, (
              pageIndex,
            ) {
              final isLastPage = pageIndex == chunkedItems.length - 1;
              final pageItems = chunkedItems.isEmpty
                  ? <JobCardInvoiceItemsModel>[]
                  : chunkedItems[pageIndex];

              return pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),

                child: pw.SizedBox(
                  width: double.infinity,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            'QUOTATION',
                            style: const pw.TextStyle(
                              color: PdfColors.red,
                              fontSize: 20,
                            ),
                          ),
                          pw.Text(
                            "No. ${quotationCounter.value.text}",
                            style: const pw.TextStyle(
                              color: PdfColors.grey,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      pw.Divider(color: PdfColors.red),
                      pw.SizedBox(height: 10),

                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Row(
                            children: [
                              pw.Text('Date: ', style: fontStyleForPDFLable),
                              pw.Text(
                                textToDate(quotationDate.value.text),
                                style: fontStyleForPDFText,
                              ),
                            ],
                          ),
                          pw.Row(
                            children: [
                              pw.Text(
                                'Valid Until: ',
                                style: fontStyleForPDFLable,
                              ),
                              pw.Text(
                                textToDate(validityEndDate.value.text),
                                style: fontStyleForPDFText,
                              ),
                            ],
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 10),
                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  'CUSTOMER DETAILS',
                                  style: fontStyleForPDFLableGREY,
                                ),
                                pw.Divider(
                                  color: PdfColors.grey,
                                  thickness: 0.3,
                                ),
                                infoRow(
                                  title: 'Company:',
                                  value: customerName.text,
                                ),
                                infoRow(
                                  title: 'Name:',
                                  value: customerEntityName.text,
                                ),

                                infoRow(
                                  title: 'Mobile:',
                                  value: customerEntityPhoneNumber.text,
                                ),
                                infoRow(
                                  title: 'Email:',
                                  value: customerEntityEmail.text,
                                ),
                              ],
                            ),
                          ),
                          pw.SizedBox(width: 20),
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  'VEHICLE DETAILS',
                                  style: fontStyleForPDFLableGREY,
                                ),
                                pw.Divider(
                                  color: PdfColors.grey,
                                  thickness: 0.3,
                                ),
                                pw.SizedBox(
                                  height: 80,
                                  child: pw.Row(
                                    children: [
                                      pw.Container(
                                        width: 3,
                                        height: double.infinity,
                                        decoration: const pw.BoxDecoration(
                                          color: PdfColors.black,
                                          borderRadius: pw.BorderRadius.only(
                                            topLeft: pw.Radius.circular(5),
                                            bottomLeft: pw.Radius.circular(5),
                                          ),
                                        ),
                                      ),
                                      pw.Expanded(
                                        child: pw.Container(
                                          width: double.infinity,
                                          padding:
                                              const pw.EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 10,
                                              ),
                                          alignment: pw.Alignment.centerLeft,
                                          decoration: const pw.BoxDecoration(
                                            color: PdfColors.grey200,
                                            borderRadius: pw.BorderRadius.only(
                                              topRight: pw.Radius.circular(5),
                                              bottomRight: pw.Radius.circular(
                                                5,
                                              ),
                                            ),
                                          ),
                                          child: pw.Column(
                                            children: [
                                              infoRow(
                                                title: 'Plate:',
                                                value:
                                                    "${plateNumber.text} ${plateCode.text} ${city.text}",
                                              ),
                                              infoRow(
                                                title: 'Model:',
                                                value:
                                                    "${carBrand.text} ${carModel.text} ${year.text}",
                                              ),
                                              infoRow(
                                                title: 'VIN:',
                                                value: vin.text,
                                              ),
                                              infoRow(
                                                title: 'Mileage:',
                                                value: mileageIn.value.text,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 10),
                      buildInvoiceTable(pageItems),
                      pw.SizedBox(height: 10),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Notes', style: fontStyleForPDFLableGREY),
                          pw.Divider(color: PdfColors.grey, thickness: 0.3),
                          pw.Text(
                            quotationNotes.text,
                            style: fontStyleForPDFText,
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 10),

                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Expanded(
                            flex: 3,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  'CONDITIONS',
                                  style: fontStyleForPDFLableGREY,
                                ),
                                pw.Divider(
                                  color: PdfColors.grey,
                                  thickness: 0.3,
                                ),
                                pw.Text(
                                  """- Work will not start until we receive the Purchase Order.
- Above prices estimated final, however delivery date may differ.
- Delivery of repaired car is working days.
- Payment terms as agreement.
- Warranty: [${quotationWarrentyDays.value.text}] Days. Starts from the car delivery date.""",
                                  style: fontStyleForPDFText,
                                ),
                              ],
                            ),
                          ),
                          pw.SizedBox(width: 20),
                          pw.Expanded(
                            child: pw.Column(
                              children: [
                                pw.Text(
                                  'SUMMARY',
                                  style: fontStyleForPDFLableGREY,
                                ),
                                pw.Divider(
                                  color: PdfColors.grey,
                                  thickness: 0.3,
                                ),
                                pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.end,
                                  children: [
                                    pw.Text(
                                      'Total : ',
                                      style: fontStyleForPDFLable,
                                    ),
                                    pw.Container(
                                      width: 60,
                                      decoration: const pw.BoxDecoration(
                                        color: PdfColors.grey200,
                                      ),
                                      child: pw.Text(
                                        isLastPage
                                            ? formatNum(
                                                totals[0] ?? 0,
                                                priceFormat,
                                              )
                                            : "",
                                        style: fontStyleForPDFText,
                                        textAlign: pw.TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                                pw.SizedBox(height: 5),

                                pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.end,
                                  children: [
                                    pw.Text(
                                      'VAT ($currentCountryVAT%): ',
                                      style: fontStyleForPDFLable,
                                    ),
                                    pw.Container(
                                      width: 60,
                                      decoration: const pw.BoxDecoration(
                                        color: PdfColors.grey200,
                                      ),
                                      child: pw.Text(
                                        isLastPage
                                            ? formatNum(
                                                totals[1] ?? 0,
                                                priceFormat,
                                              )
                                            : "",
                                        style: fontStyleForPDFText,
                                        textAlign: pw.TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                                pw.SizedBox(height: 5),

                                pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.end,
                                  children: [
                                    pw.Text(
                                      'Net : ',
                                      style: fontStyleForPDFLable,
                                    ),
                                    pw.Container(
                                      width: 60,
                                      decoration: const pw.BoxDecoration(
                                        color: PdfColors.grey200,
                                      ),
                                      child: pw.Text(
                                        isLastPage
                                            ? formatNum(net, priceFormat)
                                            : "",
                                        style: fontStyleForPDFText,
                                        textAlign: pw.TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(vertical: 5),
                        child: pw.Text(netInWords, style: fontStyleForPDFLable),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ];
        },
      ),
    );
    return pdf.save();
  }

  // ===================================================================================================================================

  Future<void> openJobCardScreenByNumber(String id) async {
    try {
      openingJobCardScreen.value = true;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/quotation_cards/open_job_card_screen_by_job_number_for_quotation/$id',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        JobCardModel requiredJob = JobCardModel.fromJson(
          decoded['required_job'],
        );
        JobCardController jobCardController = Get.put(JobCardController());
        await jobCardController.loadValues(requiredJob);
        editJobCardDialog(
          jobCardController,
          requiredJob,
          id,
          true,
          screenName: '💳 Job Card',
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
          await openJobCardScreenByNumber(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      openingJobCardScreen.value = false;
    } catch (e) {
      openingJobCardScreen.value = false;
    }
  }

  // Future<void> openJobCardScreenByNumber() async {
  //   // try {
  //   //   openingJobCardScreen.value = true;
  //   //   var job = await FirebaseFirestore.instance
  //   //       .collection('job_cards')
  //   //       .where('job_number', isEqualTo: jobCardCounter.value)
  //   //       .get();
  //   //   var id = job.docs.first.id;
  //   //   var data = job.docs.first.data();

  //   //   JobCardController jobCardController = Get.put(JobCardController());
  //   //   jobCardController.getAllInvoiceItems(id);
  //   //   // await jobCardController.loadValues(data); // need to br changed
  //   //   editJobCardDialog(
  //   //     jobCardController,
  //   //     data,
  //   //     id,
  //   //     screenName: '💳 Job Card',
  //   //     headerColor: Colors.deepPurple,
  //   //   );
  //   //   openingJobCardScreen.value = false;
  //   //   showSnackBar('Done', 'Opened Successfully');
  //   // } catch (e) {
  //   //   openingJobCardScreen.value = false;
  //   //   showSnackBar('Alert', 'Something Went Wrong');
  //   // }
  // }

  void clearValues() {
    customerBranch.text = companyDetails['current_user_branch_name'] ?? '';
    customerBranchId.value = companyDetails['current_user_branch_id'] ?? '';

    jobCardId.value = '';
    quotationDate.value.text = textToDate(DateTime.now());
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
    mileageIn.value.text = '0';
    customerCreditNumber.text = '0';
    customerOutstanding.text = '0';
    customerCurrencyId.value = companyDetails.containsKey('currency_id')
        ? companyDetails['currency_id'] ?? ""
        : "";
    customerCurrencyRate.text = companyDetails.containsKey('currency_rate')
        ? companyDetails['currency_rate'].toString()
        : "";
    customerCurrency.text = companyDetails.containsKey('currency_code')
        ? companyDetails['currency_code'] ?? ""
        : "";
    jobCardCounter.value = '';
    allInvoiceItems.clear();
    canAddInternalNotesAndInvoiceItems.value = false;
    quotationStatus.value = '';
    carBrandLogo.value = '';
    quotationCounter.value.clear();
    curreentQuotationCardId.value = '';
    quotationCardAdded.value = false;
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
    customerSaleMan.clear();
    quotationDays.value.clear();
    validityEndDate.value.clear();
    referenceNumber.value.clear();
    deliveryTime.value.clear();
    quotationWarrentyDays.value.text = '0';
    quotationWarrentyKM.value.text = '0';
    quotationNotes.clear();
  }

  // function to manage loading button
  void setButtonLoading(String menuId, bool isLoading) {
    buttonLoadingStates[menuId] = isLoading;
    buttonLoadingStates.refresh(); // Notify listeners
  }

  Future<void> loadValues(QuotationCardsModel data) async {
    curreentQuotationCardId.value = data.id ?? '';
    allInvoiceItems.value = data.invoiceItemsDetails ?? [];

    jobCardCounter.value = data.jobNumber ?? '';
    jobCardId.value = data.jobCardId ?? '';
    canAddInternalNotesAndInvoiceItems.value = true;
    quotationStatus.value = data.quotationStatus ?? '';
    carBrandLogo.value = data.carBrandLogo ?? '';

    color.text = data.color ?? '';
    colorId.value = data.colorId ?? '';

    // Car brand & model (with async model name lookup)
    carBrand.text = data.carBrand ?? '';
    carBrandId.value = data.carBrandId ?? '';

    carModelId.value = data.carModelId ?? '';
    carModel.text = data.carModel ?? '';

    // Country & city
    countryId.value = data.countryId ?? '';
    country.text = data.country ?? '';

    // If you need these lists populated before setting city name:
    // if (countryId.value.isNotEmpty) {
    //   getCitiesByCountryID(countryId.value);
    // }
    // if (carBrandId.value.isNotEmpty) {
    //   getModelsByCarBrand(carBrandId.value);
    // }

    cityId.value = data.cityId ?? '';
    city.text = data.city ?? '';

    // Plate, year, code, VIN, transmission
    plateNumber.text = data.plateNumber ?? '';
    plateCode.text = data.plateCode ?? '';
    year.text = data.year ?? '';
    vin.text = data.vehicleIdentificationNumber ?? '';
    transmissionType.text = data.transmissionType ?? '';

    // Mileage & fuel amounts
    mileageIn.value.text = data.mileageIn.toString();

    // Customer info
    customerId.value = data.customerId ?? '';
    customerName.text = data.customer ?? '';
    customerEntityName.text = data.contactName ?? '';
    customerEntityPhoneNumber.text = data.contactNumber ?? '';
    customerEntityEmail.text = data.contactEmail ?? '';
    customerCreditNumber.text = data.creditLimit.toString();
    customerOutstanding.text = data.outstanding.toString();

    // Salesman & branch
    customerSaleManId.value = data.salesmanId ?? '';
    customerSaleMan.text = data.salesman ?? '';

    customerBranchId.value = data.branchId ?? '';
    customerBranch.text = data.branch ?? '';

    // Currency & rate
    customerCurrencyId.value = data.currencyId ?? '';
    customerCurrency.text = data.currency ?? '';
    customerCurrencyRate.text = data.rate.toString();

    // Quotation metadata
    quotationCounter.value.text = data.quotationNumber ?? '';
    quotationDate.value.text = textToDate(data.quotationDate);
    quotationDays.value.text = data.validityDays.toString();
    validityEndDate.value.text = textToDate(data.validityEndDate);
    referenceNumber.value.text = data.referenceNumber ?? '';
    deliveryTime.value.text = data.deliveryTime ?? '';
    quotationWarrentyDays.value.text = data.quotationWarrentyDays.toString();
    quotationWarrentyKM.value.text = data.quotationWarrentyKm.toString();
    quotationNotes.text = data.quotationNotes ?? '';
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
          ((double.tryParse(total.text))! * currentCountryVAT.value / 100)
              .toStringAsFixed(2);
    }

    // vat.text =
    //     (double.tryParse(net.text)! - double.tryParse(total.text)!).toString();
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

  List<double> calculateTotals() {
    // this is for invoice items
    double sumofTotal = 0.0;
    double sumofVAT = 0.0;
    double sumofNET = 0.0;

    for (var item in allInvoiceItems.where((item) => item.deleted != true)) {
      sumofTotal += item.total ?? 0;
      sumofNET += item.net ?? 0;
      sumofVAT += item.vat ?? 0;
    }

    return [sumofTotal, sumofVAT, sumofNET];
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

  void changeQuotationEndDateDependingOnDays() {
    DateTime date = format.parse(quotationDate.value.text);
    DateTime newDate = date.add(
      Duration(days: int.parse(quotationDays.value.text)),
    );
    validityEndDate.value.text = format.format(newDate);
  }

  void changingDaysDependingOnQuotationEndDate() {
    DateTime specificDate = format.parse(validityEndDate.value.text);

    quotationDays.value.text =
        (specificDate.difference(format.parse(quotationDate.value.text)).inDays)
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
    customerSaleMan.text = selectedCustomer['salesman'] ?? "";
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  void clearAllFilters() {
    initStatusPickersValue.value = 1;
    initDatePickerValue.value = 1;
    statusFilter.value.clear();
    numberOfQuotations.value = 0;
    allQuotationsTotals.value = 0;
    allQuotationsVATS.value = 0;
    allQuotationsNET.value = 0;
    isAllSelected.value = false;
    isTodaySelected.value = false;
    isThisMonthSelected.value = false;
    isThisYearSelected.value = false;
    quotaionNumberFilter.value.clear();
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
