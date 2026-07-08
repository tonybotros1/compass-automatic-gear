import 'dart:async';
import 'dart:convert';

import 'package:datahubai/Controllers/Main%20screen%20controllers/car_brands_controller.dart';
import 'package:datahubai/Controllers/Main%20screen%20controllers/list_of_values_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/car trading/accounts_summary_model.dart';
import '../../Models/car trading/capitals_outstanding_model.dart';
import '../../Models/car trading/car_trade_model.dart';
import '../../Models/car trading/car_trading_items_model.dart';
import '../../Models/car trading/car_trading_purchase_agreement_model.dart';
import '../../Models/car trading/general_expenses_model.dart';
import '../../Models/car trading/last_changes_model.dart';
import '../../Models/car trading/transfer_model.dart';
import '../../Widgets/main screen widgets/job_cards_widgets/print_delivery_note.dart';
import '../../Widgets/main screen widgets/job_cards_widgets/print_invoice_pdf.dart';
import '../../consts.dart';
import '../../helpers.dart';
import '../Main screen controllers/websocket_controller.dart';

class CarTradingDashboardController extends GetxController {
  final GlobalKey<FormState> carTradeFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> lineItemFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> salesAgreementFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> transferFormKey = GlobalKey<FormState>();

  Rx<TextEditingController> searchForCapitalsOrOutstandingOrGeneralExpenses =
      TextEditingController().obs;
  Rx<TextEditingController> carModelFilter = TextEditingController().obs;
  Rx<TextEditingController> carBrandFilter = TextEditingController().obs;
  Rx<TextEditingController> carEngineSizeFilter = TextEditingController().obs;
  Rx<TextEditingController> carBoughtFromFilter = TextEditingController().obs;
  Rx<TextEditingController> carSoldToFilter = TextEditingController().obs;
  Rx<TextEditingController> carSoldByFilter = TextEditingController().obs;
  Rx<TextEditingController> carBoughtByFilter = TextEditingController().obs;
  Rx<TextEditingController> carInvestedByFilter = TextEditingController().obs;
  Rx<TextEditingController> carConsignmentForFilter =
      TextEditingController().obs;
  Rx<TextEditingController> carSpecificationFilter =
      TextEditingController().obs;
  RxString carBrandFilterId = RxString('');
  RxString carModelFilterId = RxString('');
  RxString carEngineSizeFilterId = RxString('');
  RxString carBoughtFromFilterId = RxString('');
  RxString carSoldToFilterId = RxString('');
  RxString carSoldByFilterId = RxString('');
  RxString carBoughtByFilterId = RxString('');
  RxString carInvestedByFilterId = RxString('');
  RxString carConsignmentForFilterId = RxString('');
  RxString carSpecificationFilterId = RxString('');
  final RxList<CapitalsAndOutstandingModel> allCapitals =
      RxList<CapitalsAndOutstandingModel>([]);
  final RxList<CapitalsAndOutstandingModel> allOutstanding =
      RxList<CapitalsAndOutstandingModel>([]);
  final RxList<GeneralExpensesModel> allGeneralExpenses =
      RxList<GeneralExpensesModel>([]);
  final RxList<CarTradeModel> filteredTrades = RxList<CarTradeModel>([]);
  final RxList<CapitalsAndOutstandingModel> filteredCapitals =
      RxList<CapitalsAndOutstandingModel>([]);
  final RxList<CapitalsAndOutstandingModel> filteredOutstanding =
      RxList<CapitalsAndOutstandingModel>([]);
  final RxList<GeneralExpensesModel> filteredGeneralExpenses =
      RxList<GeneralExpensesModel>([]);
  final RxList<LastCarTradingChangesModel> lastChanges =
      RxList<LastCarTradingChangesModel>([]);
  RxInt numberOfCars = RxInt(0);
  RxInt numberOfCapitalsDocs = RxInt(0);
  RxInt numberOfOutstandingDocs = RxInt(0);
  RxInt numberOfGeneralExpensesDocs = RxInt(0);
  RxDouble totalPaysForAllTrades = RxDouble(0.0);
  RxDouble totalReceivesForAllTrades = RxDouble(0.0);
  RxDouble totalNETsForAllTrades = RxDouble(0.0);
  RxDouble totalPaysForAllCapitals = RxDouble(0.0);
  RxDouble totalReceivesForAllCapitals = RxDouble(0.0);
  RxDouble totalNETsForAllCapitals = RxDouble(0.0);
  RxDouble totalPaysForAllOutstanding = RxDouble(0.0);
  RxDouble totalReceivesForAllOutstanding = RxDouble(0.0);
  RxDouble totalNETsForAllOutstanding = RxDouble(0.0);
  RxDouble totalPaysForAllGeneralExpenses = RxDouble(0.0);
  RxDouble totalReceivesForAllGeneralExpenses = RxDouble(0.0);
  RxDouble totalNETsForAllGeneralExpenses = RxDouble(0.0);
  // RxDouble totalNETsForAll = RxDouble(0.0);
  // RxDouble totalNETsForBanckBalance = RxDouble(0.0);
  RxDouble totalMoneyForAccounts = RxDouble(0.0);
  RxDouble totalNetProfit = RxDouble(0.0);
  DateFormat inputFormat = DateFormat("dd-MM-yyyy");
  RxBool isNewStatusSelected = RxBool(false);
  RxBool isSoldStatusSelected = RxBool(false);
  RxBool isTodaySelected = RxBool(false);
  RxBool isThisMonthSelected = RxBool(false);
  RxBool isThisYearSelected = RxBool(false);
  RxMap allModels = RxMap({});
  RxString status = RxString('');
  RxString currentTradId = RxString('');
  RxString colorOutId = RxString('');
  RxBool addingNewValue = RxBool(false);
  RxBool addingNewTransferValue = RxBool(false);
  Rx<TextEditingController> searchForItems = TextEditingController().obs;
  Rx<TextEditingController> searchForTransfers = TextEditingController().obs;
  Rx<TextEditingController> date = TextEditingController().obs;
  Rx<TextEditingController> mileage = TextEditingController().obs;
  Rx<TextEditingController> colorOut = TextEditingController().obs;
  Rx<TextEditingController> colorIn = TextEditingController().obs;
  Rx<TextEditingController> carSpecification = TextEditingController().obs;
  Rx<TextEditingController> carBrand = TextEditingController().obs;
  Rx<TextEditingController> carModel = TextEditingController().obs;
  Rx<TextEditingController> engineSize = TextEditingController().obs;
  Rx<TextEditingController> boughtFrom = TextEditingController().obs;
  Rx<TextEditingController> boughtBy = TextEditingController().obs;
  Rx<TextEditingController> year = TextEditingController().obs;
  Rx<TextEditingController> consignmentFor = TextEditingController().obs;
  Rx<TextEditingController> vin = TextEditingController().obs;
  Rx<TextEditingController> soldTo = TextEditingController().obs;
  Rx<TextEditingController> soldBy = TextEditingController().obs;
  Rx<TextEditingController> investedBy = TextEditingController().obs;
  Rx<TextEditingController> serviceContractEndDate =
      TextEditingController().obs;
  Rx<TextEditingController> warrantyEndDate = TextEditingController().obs;
  TextEditingController pay = TextEditingController();
  TextEditingController receive = TextEditingController();
  Rx<TextEditingController> comments = TextEditingController().obs;
  TextEditingController note = TextEditingController();
  TextEditingController item = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController accountName = TextEditingController();
  RxString accountNameId = RxString('');
  Rx<TextEditingController> itemDate = TextEditingController().obs;
  RxString query = RxString('');
  RxString queryForItems = RxString('');
  RxBool isValuesLoading = RxBool(false);
  RxString colorInId = RxString('');
  RxString carSpecificationId = RxString('');
  RxString carModelId = RxString('');
  RxString carBrandId = RxString('');
  RxString engineSizeId = RxString('');
  RxString boughtFromId = RxString('');
  RxString boughtById = RxString('');
  RxString yearId = RxString('');
  RxString consignmentForId = RxString('');
  RxString soldToId = RxString('');
  RxString soldById = RxString('');
  RxString investedById = RxString('');
  RxString itemId = RxString('');
  RxString nameId = RxString('');
  RxList<CarTradingItemsModel> addedItems = RxList([]);
  RxList<CarTradingPurchaseAgreementModel> purchaseAgreementAddedItems = RxList(
    [],
  );
  RxDouble totalPays = RxDouble(0.0);
  RxDouble totalTransfersAmount = RxDouble(0.0);
  RxDouble totalReceives = RxDouble(0.0);
  RxDouble totalNETs = RxDouble(0.0);
  RxDouble totalPurchaseAgreementAmount = RxDouble(0.0);
  RxDouble totalPurchaseAgreementDownPayment = RxDouble(0.0);
  RxList<CarTradingItemsModel> filteredAddedItems =
      RxList<CarTradingItemsModel>([]);
  RxList<CarTradingPurchaseAgreementModel> filteredPurchaseAgreementAddedItems =
      RxList<CarTradingPurchaseAgreementModel>([]);
  RxBool isCapitalLoading = RxBool(false);
  RxBool isTransfersLoading = RxBool(false);
  String backendUrl = backendTestURI;
  WebSocketService ws = Get.find<WebSocketService>();
  StreamSubscription? _carTradingEventsSubscription;
  RxBool gettingCapitalsSummary = RxBool(false);
  RxBool gettingOutstandingSummary = RxBool(false);
  RxBool gettingGeneralExpensesSummary = RxBool(false);
  Rx<TextEditingController> fromDate = TextEditingController().obs;
  Rx<TextEditingController> fromDateForChanges = TextEditingController().obs;
  Rx<TextEditingController> toDate = TextEditingController().obs;
  Rx<TextEditingController> toDateForChanges = TextEditingController().obs;
  Rx<TextEditingController> minAmount = TextEditingController().obs;
  Rx<TextEditingController> maxAmount = TextEditingController().obs;
  Rx<TextEditingController> accountForLastChanges = TextEditingController().obs;
  RxBool carModified = RxBool(false);
  // RxBool itemsModified = RxBool(false);
  RxBool purchasedItemsModified = RxBool(false);
  RxBool searching = RxBool(false);
  RxBool hideCarTradeFinancialValues = RxBool(true);
  RxBool changesSearching = RxBool(false);
  final ScrollController scrollControllerForTable = ScrollController();
  var buttonLoadingStates = <String, bool>{}.obs;
  final ScrollController scrollControllerForCarInformation = ScrollController();
  final ScrollController scrollControllerForBuySell = ScrollController();
  final carBrandsController = Get.put(CarBrandsController());
  final listOfValuesController = Get.put(ListOfValuesController());

  final FocusNode focusNodeForitems1 = FocusNode();
  final FocusNode focusNodeForitems2 = FocusNode();
  final FocusNode focusNodeForitems3 = FocusNode();
  final FocusNode focusNodeForitems4 = FocusNode();
  final FocusNode focusNodeForitems5 = FocusNode();

  final FocusNode focusNodeForCarInformation1 = FocusNode();
  final FocusNode focusNodeForCarInformation2 = FocusNode();
  final FocusNode focusNodeForCarInformation3 = FocusNode();
  final FocusNode focusNodeForCarInformation4 = FocusNode();
  final FocusNode focusNodeForCarInformation5 = FocusNode();
  final FocusNode focusNodeForCarInformation6 = FocusNode();
  final FocusNode focusNodeForCarInformation7 = FocusNode();
  final FocusNode focusNodeForCarInformation8 = FocusNode();
  final FocusNode focusNodeForCarInformation9 = FocusNode();

  final FocusNode focusNodeForBuySell1 = FocusNode();
  final FocusNode focusNodeForBuySell2 = FocusNode();
  final FocusNode focusNodeForBuySell3 = FocusNode();
  final FocusNode focusNodeForBuySell4 = FocusNode();
  RxBool addingPurchaseAgreement = RxBool(false);
  RxBool addingTradeItem = RxBool(false);
  TextEditingController agreementNumber = TextEditingController();
  TextEditingController agreementdate = TextEditingController();
  TextEditingController sellerName = TextEditingController();
  TextEditingController sellerID = TextEditingController();
  TextEditingController sellerPhone = TextEditingController();
  TextEditingController sellerEmail = TextEditingController();
  TextEditingController buyerName = TextEditingController();
  TextEditingController buyerID = TextEditingController();
  TextEditingController buyerPhone = TextEditingController();
  TextEditingController buyerEmail = TextEditingController();
  TextEditingController agreementNote = TextEditingController();
  TextEditingController agreementTotal = TextEditingController();
  TextEditingController agreementdownpayment = TextEditingController();

  // transfers:
  Rx<TextEditingController> transferDate = TextEditingController().obs;
  TextEditingController fromAccount = TextEditingController();
  RxString fromAccountId = RxString('');
  TextEditingController toAccount = TextEditingController();
  RxString toAccountId = RxString('');
  TextEditingController transferAmount = TextEditingController();
  Rx<TextEditingController> transferComments = TextEditingController().obs;

  RxList<Map<String, dynamic>> summaryData = RxList<Map<String, dynamic>>([
    {"category": "Cars"},
    {"category": "Capital Docs"},
    {"category": "Outstanding"},
    {"category": "Expenses"},
  ]);

  RxList<AccountSummaryModel> accountsSummary = RxList<AccountSummaryModel>([]);
  RxList<TransferModel> alltransfers = RxList<TransferModel>([]);
  RxList<TransferModel> filteredTransfers = RxList<TransferModel>([]);

  List<Widget> carsTabs = const [
    Tab(text: 'Sales Agreement'), // note previous name was purchase agreement
    Tab(text: 'Items'),
  ];
  RxMap companyDetails = RxMap({});

  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
  final selectedRowIndex = (-1).obs;
  RxString itemsPageName = RxString('');

  RxInt initValueForDatePicker = RxInt(1);
  RxInt initValueForStatusPicker = RxInt(1);

  List<Widget> carTradingTabs = const [
    Tab(text: 'Cars Information'),
    Tab(text: 'Financial Information'),
  ];

  void selectRow(int index) {
    selectedRowIndex.value = index;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    connectWebSocket();
    getCompanyDetails();
    allSearches();
    focusNodeForitems1.addListener(() {
      if (!focusNodeForitems1.hasFocus) {
        normalizeDate(itemDate.value.text, itemDate.value);
      }
    });
  }

  @override
  void onClose() {
    _carTradingEventsSubscription?.cancel();
    searchForCapitalsOrOutstandingOrGeneralExpenses.value.dispose();
    carModelFilter.value.dispose();
    carBrandFilter.value.dispose();
    carEngineSizeFilter.value.dispose();
    carBoughtFromFilter.value.dispose();
    carSoldToFilter.value.dispose();
    carSoldByFilter.value.dispose();
    carBoughtByFilter.value.dispose();
    carInvestedByFilter.value.dispose();
    carConsignmentForFilter.value.dispose();
    carSpecificationFilter.value.dispose();
    searchForItems.value.dispose();
    searchForTransfers.value.dispose();
    date.value.dispose();
    mileage.value.dispose();
    colorOut.value.dispose();
    colorIn.value.dispose();
    carSpecification.value.dispose();
    carBrand.value.dispose();
    carModel.value.dispose();
    engineSize.value.dispose();
    boughtFrom.value.dispose();
    boughtBy.value.dispose();
    year.value.dispose();
    consignmentFor.value.dispose();
    vin.value.dispose();
    soldTo.value.dispose();
    soldBy.value.dispose();
    investedBy.value.dispose();
    serviceContractEndDate.value.dispose();
    warrantyEndDate.value.dispose();
    pay.dispose();
    receive.dispose();
    comments.value.dispose();
    note.dispose();
    item.dispose();
    name.dispose();
    accountName.dispose();
    itemDate.value.dispose();
    fromDate.value.dispose();
    fromDateForChanges.value.dispose();
    toDate.value.dispose();
    toDateForChanges.value.dispose();
    minAmount.value.dispose();
    maxAmount.value.dispose();
    accountForLastChanges.value.dispose();
    scrollControllerForTable.dispose();
    scrollControllerForCarInformation.dispose();
    scrollControllerForBuySell.dispose();
    focusNodeForitems1.dispose();
    focusNodeForitems2.dispose();
    focusNodeForitems3.dispose();
    focusNodeForitems4.dispose();
    focusNodeForitems5.dispose();
    focusNodeForCarInformation1.dispose();
    focusNodeForCarInformation2.dispose();
    focusNodeForCarInformation3.dispose();
    focusNodeForCarInformation4.dispose();
    focusNodeForCarInformation5.dispose();
    focusNodeForCarInformation6.dispose();
    focusNodeForCarInformation7.dispose();
    focusNodeForCarInformation8.dispose();
    focusNodeForCarInformation9.dispose();
    focusNodeForBuySell1.dispose();
    focusNodeForBuySell2.dispose();
    focusNodeForBuySell3.dispose();
    focusNodeForBuySell4.dispose();
    agreementNumber.dispose();
    agreementdate.dispose();
    sellerName.dispose();
    sellerID.dispose();
    sellerPhone.dispose();
    sellerEmail.dispose();
    buyerName.dispose();
    buyerID.dispose();
    buyerPhone.dispose();
    buyerEmail.dispose();
    agreementNote.dispose();
    agreementTotal.dispose();
    agreementdownpayment.dispose();
    transferDate.value.dispose();
    fromAccount.dispose();
    toAccount.dispose();
    transferAmount.dispose();
    transferComments.value.dispose();
    super.onClose();
  }

  Future<void> allSearches() async {
    await filterSearch();
    await filterGeneralExpensesSearch();
    await getCashOnHandOrBankBalance();
    await getCapitalsOROutstandingSummary('capitals');
    await getCapitalsOROutstandingSummary('outstanding');
  }

  void onChooseForDatePicker(int i) {
    switch (i) {
      case 1:
        initValueForDatePicker.value = 1;
        isTodaySelected.value = false;
        isThisMonthSelected.value = false;
        isThisYearSelected.value = false;
        fromDate.value.clear();
        toDate.value.clear();
        allSearches();
        break;
      case 2:
        initValueForDatePicker.value = 2;
        setTodayRange(fromDate.value, toDate.value);
        isTodaySelected.value = true;
        isThisMonthSelected.value = false;
        isThisYearSelected.value = false;
        allSearches();
        break;
      case 3:
        initValueForDatePicker.value = 3;
        setThisMonthRange(fromDate.value, toDate.value);
        isTodaySelected.value = false;
        isThisMonthSelected.value = true;
        isThisYearSelected.value = false;
        allSearches();
        break;
      case 4:
        initValueForDatePicker.value = 4;
        setThisYearRange(fromDate.value, toDate.value);
        isTodaySelected.value = false;
        isThisMonthSelected.value = false;
        isThisYearSelected.value = true;
        allSearches();
        break;
      default:
    }
  }

  void onChooseForDatePickerForChanges(int i) {
    switch (i) {
      case 1:
        setTodayRange(fromDateForChanges.value, toDateForChanges.value);
        filterLastChangesSearch();
        break;
      case 2:
        setThisMonthRange(fromDateForChanges.value, toDateForChanges.value);
        filterLastChangesSearch();
        break;
      case 3:
        setThisYearRange(fromDateForChanges.value, toDateForChanges.value);
        filterLastChangesSearch();

        break;
      default:
    }
  }

  void onChooseForStatusPicker(int i) {
    switch (i) {
      case 1:
        initValueForStatusPicker.value = 1;
        isNewStatusSelected.value = false;
        isSoldStatusSelected.value = false;
        allSearches();
        break;
      case 2:
        initValueForStatusPicker.value = 2;
        if (isNewStatusSelected.isFalse) {
          isNewStatusSelected.value = true;
          isSoldStatusSelected.value = false;
          allSearches();
        } else {
          isNewStatusSelected.value = false;
          allSearches();
        }
        break;
      case 3:
        initValueForStatusPicker.value = 3;
        if (isSoldStatusSelected.isFalse) {
          isSoldStatusSelected.value = true;
          isNewStatusSelected.value = false;
          allSearches();
        } else {
          isSoldStatusSelected.value = false;
          allSearches();
        }
        break;

      default:
    }
  }

  void setTodayRange(
    TextEditingController fromDate,
    TextEditingController toDate,
  ) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    fromDate.text = dateFormat.format(today);
    toDate.text = dateFormat.format(today);
  }

  void setThisMonthRange(
    TextEditingController fromDate,
    TextEditingController toDate,
  ) {
    final now = DateTime.now();

    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    fromDate.text = dateFormat.format(firstDayOfMonth);
    toDate.text = dateFormat.format(lastDayOfMonth);
  }

  void setThisYearRange(
    TextEditingController fromDate,
    TextEditingController toDate,
  ) {
    final now = DateTime.now();

    final firstDayOfYear = DateTime(now.year, 1, 1);
    final lastDayOfYear = DateTime(now.year, 12, 31);

    fromDate.text = dateFormat.format(firstDayOfYear);
    toDate.text = dateFormat.format(lastDayOfYear);
  }

  // function to manage loading button
  void setButtonLoading(String id, bool isLoading) {
    buttonLoadingStates[id] = isLoading;
    buttonLoadingStates.refresh(); // Notify listeners
  }

  void _showError(String content, {String? title}) {
    final context = Get.context;
    if (context == null) return;
    alertMessage(context: context, title: title, content: content);
  }

  Future<String> _accessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken') ?? '';
  }

  Future<String> _refreshToken() async {
    return await secureStorage.read(key: "refreshToken") ?? '';
  }

  Map<String, dynamic> _jsonObject(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (e) {
      //
    }
    return {};
  }

  double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ??
        double.tryParse(value?.toString() ?? '')?.toInt() ??
        0;
  }

  String? _isoDateFromText(
    TextEditingController controller,
    String label, {
    bool required = false,
  }) {
    final value = controller.text.trim();
    if (value.isEmpty) {
      if (required) _showError('Please add valid $label');
      return null;
    }
    try {
      return inputFormat.parseStrict(value).toIso8601String();
    } catch (e) {
      _showError('Please add valid $label');
      return null;
    }
  }

  bool _validateForm(GlobalKey<FormState> key) {
    return key.currentState?.validate() ?? true;
  }

  bool validateTradeForm() {
    if (addingNewValue.value) return false;
    if (!_validateForm(carTradeFormKey)) return false;
    if (_isoDateFromText(date.value, 'Transaction Date', required: true) ==
        null) {
      return false;
    }
    if (carBrandId.value.isEmpty) {
      _showError('Please select car brand');
      return false;
    }
    if (carModelId.value.isEmpty) {
      _showError('Please select car model');
      return false;
    }
    return true;
  }

  bool validateLineItemForm({
    required bool isTrade,
    required bool isGeneralExpenses,
  }) {
    if (addingTradeItem.value || isCapitalLoading.value) return false;
    if (!_validateForm(lineItemFormKey)) return false;
    if (_isoDateFromText(itemDate.value, 'Date', required: true) == null) {
      return false;
    }
    if (isTrade || isGeneralExpenses) {
      if (itemId.value.isEmpty) {
        _showError('Please select item');
        return false;
      }
    } else if (nameId.value.isEmpty) {
      _showError('Please select name');
      return false;
    }
    if (accountNameId.value.isEmpty) {
      _showError('Please select account name');
      return false;
    }
    return true;
  }

  bool validateTransferForm() {
    if (addingNewTransferValue.value) return false;
    if (!_validateForm(transferFormKey)) return false;
    if (_isoDateFromText(transferDate.value, 'Date', required: true) == null) {
      return false;
    }
    if (fromAccountId.value.isEmpty || toAccountId.value.isEmpty) {
      _showError('Please add both accounts');
      return false;
    }
    if (fromAccountId.value == toAccountId.value) {
      _showError('Please choose different accounts');
      return false;
    }
    return true;
  }

  bool validateSalesAgreementForm() {
    if (addingPurchaseAgreement.value) return false;
    if (!_validateForm(salesAgreementFormKey)) return false;
    if (currentTradId.value.isEmpty) {
      _showError('Save trade first');
      return false;
    }
    if (_isoDateFromText(agreementdate, 'Agreement Date', required: true) ==
        null) {
      return false;
    }
    return true;
  }

  void _upsertCapital(
    RxList<CapitalsAndOutstandingModel> list,
    CapitalsAndOutstandingModel model,
  ) {
    final index = list.indexWhere((item) => item.id == model.id);
    if (index == -1) {
      list.insert(0, model);
    } else {
      list[index] = model;
    }
  }

  void _upsertGeneralExpense(GeneralExpensesModel model) {
    final index = allGeneralExpenses.indexWhere((item) => item.id == model.id);
    if (index == -1) {
      allGeneralExpenses.insert(0, model);
    } else {
      allGeneralExpenses[index] = model;
    }
  }

  void _upsertTransfer(TransferModel model) {
    final id = model.id;
    if (id == null || id.isEmpty) return;
    final index = alltransfers.indexWhere((item) => item.id == id);
    if (index == -1) {
      alltransfers.insert(0, model);
    } else {
      alltransfers[index] = model;
    }
  }

  void _upsertTradeItem(CarTradingItemsModel model) {
    final id = model.id;
    if (id == null || id.isEmpty) return;
    final index = addedItems.indexWhere((item) => item.id == id);
    if (index == -1) {
      addedItems.insert(0, model);
    } else {
      addedItems[index] = model;
    }
  }

  void _upsertPurchaseAgreement(CarTradingPurchaseAgreementModel model) {
    final id = model.id;
    if (id == null || id.isEmpty) return;
    final index = purchaseAgreementAddedItems.indexWhere(
      (item) => item.id == id,
    );
    if (index == -1) {
      purchaseAgreementAddedItems.insert(0, model);
    } else {
      purchaseAgreementAddedItems[index] = model;
    }
  }

  void connectWebSocket() {
    _carTradingEventsSubscription?.cancel();
    _carTradingEventsSubscription = ws.events.listen((message) {
      try {
        switch (message["type"]) {
          case "capital_created":
            final newCapital = CapitalsAndOutstandingModel.fromJson(
              Map<String, dynamic>.from(message["data"]),
            );
            _upsertCapital(allCapitals, newCapital);
            break;

          case "capital_updated":
            final updated = CapitalsAndOutstandingModel.fromJson(
              Map<String, dynamic>.from(message["data"]),
            );
            final totals = message['totals'] ?? {};
            _upsertCapital(allCapitals, updated);
            totalPays.value = _toDouble(totals['pay']);
            totalReceives.value = _toDouble(totals['receive']);
            totalNETs.value = _toDouble(totals['net']);
            break;

          case "capital_deleted":
            final deletedId = message["data"]["_id"]?.toString();
            allCapitals.removeWhere((b) => b.id == deletedId);
            break;

          case "outstanding_created":
            final newModel = CapitalsAndOutstandingModel.fromJson(
              Map<String, dynamic>.from(message["data"]),
            );
            _upsertCapital(allOutstanding, newModel);
            break;

          case "outstanding_updated":
            final updated = CapitalsAndOutstandingModel.fromJson(
              Map<String, dynamic>.from(message["data"]),
            );
            final totals = message['totals'] ?? {};
            _upsertCapital(allOutstanding, updated);
            totalPays.value = _toDouble(totals['pay']);
            totalReceives.value = _toDouble(totals['receive']);
            totalNETs.value = _toDouble(totals['net']);
            break;

          case "outstanding_deleted":
            final deletedId = message["data"]["_id"]?.toString();
            allOutstanding.removeWhere((m) => m.id == deletedId);
            break;

          case "general_expenses_created":
            final newModel = GeneralExpensesModel.fromJson(
              Map<String, dynamic>.from(message["data"]),
            );
            _upsertGeneralExpense(newModel);
            break;

          case "general_expenses_updated":
            final updated = GeneralExpensesModel.fromJson(
              Map<String, dynamic>.from(message["data"]),
            );
            final totals = message['totals'] ?? {};
            _upsertGeneralExpense(updated);
            totalPays.value = _toDouble(totals['pay']);
            totalReceives.value = _toDouble(totals['receive']);
            totalNETs.value = _toDouble(totals['net']);
            break;

          case "general_expenses_deleted":
            final deletedId = message["data"]["_id"]?.toString();
            allGeneralExpenses.removeWhere((m) => m.id == deletedId);
            break;

          case "purchase_agreement_item_created":
            final newModel = CarTradingPurchaseAgreementModel.fromJson(
              Map<String, dynamic>.from(message["data"]),
            );
            _upsertPurchaseAgreement(newModel);
            calculatePurchaseAgreementTotals();
            break;
          case "purchase_agreement_item_updated":
            final updated = CarTradingPurchaseAgreementModel.fromJson(
              Map<String, dynamic>.from(message["data"]),
            );
            _upsertPurchaseAgreement(updated);
            calculatePurchaseAgreementTotals();
            break;

          case "purchase_agreement_item_deleted":
            final deletedId = message["data"]["_id"]?.toString();
            purchaseAgreementAddedItems.removeWhere((m) => m.id == deletedId);
            calculatePurchaseAgreementTotals();
            break;

          case "transfer_created":
            final newModel = TransferModel.fromJson(
              Map<String, dynamic>.from(message["data"]),
            );
            _upsertTransfer(newModel);
            calculateTransfersAmount();
            break;
          case "transfer_deleted":
            final deletedId = message["data"]["_id"]?.toString();
            alltransfers.removeWhere((m) => m.id == deletedId);
            calculateTransfersAmount();
            break;
          case "transfer_updated":
            final updated = TransferModel.fromJson(
              Map<String, dynamic>.from(message["data"]),
            );
            _upsertTransfer(updated);
            calculateTransfersAmount();
            break;

          case "trade_item_added":
            final newModel = CarTradingItemsModel.fromJson(
              Map<String, dynamic>.from(message["data"]),
            );
            _upsertTradeItem(newModel);
            calculateTotals();
            break;
          case "trade_item_updated":
            final updated = CarTradingItemsModel.fromJson(
              Map<String, dynamic>.from(message["data"]),
            );
            _upsertTradeItem(updated);
            calculateTotals();
            break;
          case "trade_item_deleted":
            final deletedId = message["data"]["_id"]?.toString();
            addedItems.removeWhere((m) => m.id == deletedId);
            calculateTotals();
            break;
        }
      } catch (e) {
        //
      }
    });
  }

  Future<Map<String, dynamic>> getYears() async {
    return await helper.getAllListValues('YEARS');
  }

  Future<Map<String, dynamic>> getConsignmentsFor() async {
    return await helper.getAllListValues('CONSIGNMENT_FOR');
  }

  Future<Map<String, dynamic>> getItems() async {
    return await helper.getAllListValues('ITEMS');
  }

  Future<Map<String, dynamic>> getColors() async {
    return await helper.getAllListValues('COLORS');
  }

  Future<Map<String, dynamic>> getCarSpecefications() async {
    return await helper.getAllListValues('CAR_SPECIFICATIONS');
  }

  Future<Map<String, dynamic>> getEngineTypes() async {
    return await helper.getAllListValues('ENGINE_TYPES');
  }

  Future<Map<String, dynamic>> getBuyersAndSellers() async {
    return await helper.getAllListValues('BUYERS_AND_SELLERS');
  }

  Future<Map<String, dynamic>> getBuyersAndSellersBy() async {
    return await helper.getAllListValues('BOUGHT_SOLD_BY');
  }

  Future<Map<String, dynamic>> getInvestedBy() async {
    return await helper.getAllListValues('INVESTED_BY');
  }

  Future<Map<String, dynamic>> getNamesOfPeople() async {
    return await helper.getAllListValues('NAMES_OF_PEOPLE');
  }

  Future<Map<String, dynamic>> getNamesOfAccount() async {
    return await helper.getAllListValues('CAR_TRADING_CASH_BANK');
  }

  Future<Map<String, dynamic>> getListDetils(String code) async {
    return await helper.getListDetails(code);
  }

  Future<Map<String, dynamic>> getCarBrands() async {
    return await helper.getCarBrands();
  }

  Future<Map<String, dynamic>> getModelsByCarBrand(String brandId) async {
    return await helper.getModelsValues(brandId);
  }

  Future<void> getCompanyDetails() async {
    companyDetails.assignAll(await helper.getCurrentCompanyDetails());
  }

  void addNewCapitalOrOutstandingOrGeneralExpenses(String type) async {
    switch (type) {
      case 'capitals':
        await addNewCapitalOrOutstanding(type);
        break;
      case 'outstanding':
        await addNewCapitalOrOutstanding(type);
        break;
      case 'general_expenses':
        await addNewGeneralExpenses();
        break;
      default:
    }
  }

  void deleteCapitalOrOutstandingOrGeneralExpenses(
    String type,
    String id,
  ) async {
    switch (type) {
      case 'capitals':
        await deleteCapitalOrOutstanding(id, type);
        break;
      case 'outstanding':
        await deleteCapitalOrOutstanding(id, type);
        break;
      case 'general_expenses':
        await deleteGeneralExpenses(id);
        break;
      default:
    }
  }

  void updateCapitalOrOutstandingOrGeneralExpenses(
    String type,
    String id,
  ) async {
    switch (type) {
      case 'capitals':
        await updateCapitalOrOutstanding(id, type);
        break;
      case 'outstanding':
        await updateCapitalOrOutstanding(id, type);
        break;
      case 'general_expenses':
        await updateGeneralEpenses(id);
        break;
      default:
    }
  }

  // PRINT SECTION
  // ===========================================================================
  void printPurchaseAgreementOrQuotation(
    CarTradingPurchaseAgreementModel data,
    String type,
  ) async {
    final pdfData = await generatePurchaseAgreementOrQuotationPdf(data, type);

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfData);
  }

  Future<Uint8List> generatePurchaseAgreementOrQuotationPdf(
    CarTradingPurchaseAgreementModel data,
    String type,
  ) async {
    // final Font robotoMono = pw.Font.ttf(
    //   await rootBundle.load('assets/fonts/RobotoMono-VariableFont_wght.ttf'),
    // );

    // var countryCurrency = await helper.getCountryCurrency(companyDetails['']);
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

    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(0),
        header: (context) => pw.Image(
          headerImage,
          height: 115,
          fit: pw.BoxFit.fitWidth,
          alignment: pw.Alignment.topCenter,
        ),

        footer: (context) => pw.Image(
          footerImage,
          height: 100,
          fit: pw.BoxFit.fitWidth,
          alignment: pw.Alignment.bottomCenter,
        ),
        build: (context) {
          return [
            ...List.generate(1, (pageIndex) {
              return pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),

                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          type == 'sales agreement'
                              ? 'SALES AGREEMENT'
                              : 'QUOTATION',
                          style: const pw.TextStyle(
                            color: PdfColors.red,
                            fontSize: 20,
                          ),
                        ),
                        pw.Text(
                          "No. ${data.agreementNumber ?? ''}",
                          style: const pw.TextStyle(
                            color: PdfColors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    pw.Divider(color: PdfColors.red),
                    pw.SizedBox(height: 10),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 10),
                      child: pw.Row(
                        children: [
                          pw.Text('Date: ', style: fontStyleForPDFLable),
                          pw.Text(
                            textToDate(data.agreementDate),
                            style: fontStyleForPDFText,
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(height: 4),

                    // pw.Row(
                    //   children: [
                    //     pw.Text(
                    //       'Payment Method: ',
                    //       style: fontStyleForPDFLable,
                    //     ),
                    //     pw.Text("", style: fontStyleForPDFText),
                    //   ],
                    // ),

                    // pw.SizedBox(height: 4),

                    // pw.Row(
                    //   children: [
                    //     pw.Text('Reference No.: ', style: fontStyleForPDFLable),
                    //     pw.Text("", style: fontStyleForPDFText),
                    //   ],
                    // ),
                    pw.SizedBox(height: 10),

                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'VEHICLE DETAILS',
                                style: fontStyleForPDFLableGREY,
                              ),
                              pw.Divider(color: PdfColors.grey, thickness: 0.3),
                              pw.SizedBox(
                                height: 90,
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
                                        padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 10,
                                        ),
                                        alignment: pw.Alignment.centerLeft,
                                        decoration: const pw.BoxDecoration(
                                          color: PdfColors.grey200,
                                          borderRadius: pw.BorderRadius.only(
                                            topRight: pw.Radius.circular(5),
                                            bottomRight: pw.Radius.circular(5),
                                          ),
                                        ),
                                        child: pw.Column(
                                          children: [
                                            infoRow(
                                              title: 'Car Brand/Model:',
                                              value:
                                                  "${carBrand.value.text} ${carModel.value.text} ${year.value.text}",
                                            ),
                                            infoRow(
                                              title: 'Car Year:',
                                              value: year.value.text,
                                            ),
                                            infoRow(
                                              title: 'Color out/in:',
                                              value:
                                                  "${colorOut.value.text} / ${colorIn.value.text} ",
                                            ),
                                            infoRow(
                                              title: 'VIN:',
                                              value: vin.value.text,
                                            ),
                                            infoRow(
                                              title: 'Mileage:',
                                              value: mileage.value.text,
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
                        pw.SizedBox(width: 20),

                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'TOTALS',
                                style: fontStyleForPDFLableGREY,
                              ),
                              pw.Divider(color: PdfColors.grey, thickness: 0.3),
                              infoRow(
                                isNumber: true,
                                title: 'Vehicle Total Amount:',
                                value: formatNum(data.amount ?? 0, priceFormat),
                              ),
                              pw.SizedBox(height: 5),
                              type == 'sales agreement'
                                  ? pw.Column(
                                      children: [
                                        infoRow(
                                          isNumber: true,
                                          title: 'Down Payment:',
                                          value: formatNum(
                                            data.aownpayment ?? 0,
                                            priceFormat,
                                          ),
                                        ),
                                        pw.SizedBox(height: 5),
                                        infoRow(
                                          isNumber: true,
                                          title: 'Remaning Amount:',
                                          value: formatNum(
                                            (data.amount ?? 0) -
                                                (data.aownpayment ?? 0),
                                            priceFormat,
                                          ),
                                        ),
                                      ],
                                    )
                                  : pw.SizedBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 20),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('NOTES', style: fontStyleForPDFLableGREY),
                        pw.Divider(color: PdfColors.grey, thickness: 0.3),
                        pw.Padding(
                          padding: const pw.EdgeInsets.fromLTRB(8, 0, 8, 16),
                          child: pw.Text(
                            data.note ?? '',
                            style: fontStyleForPDFText,
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 20),

                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'SELLER INFORMATION',
                                style: fontStyleForPDFLableGREY,
                              ),
                              pw.Divider(color: PdfColors.grey, thickness: 0.3),
                              infoRow(
                                title: 'Name:',
                                value: data.sellerName ?? '',
                              ),
                              pw.SizedBox(height: 5),
                              infoRow(
                                title: 'Emirates ID:',
                                value: data.sellerID ?? '',
                              ),
                              pw.SizedBox(height: 5),
                              infoRow(
                                title: 'Phone:',
                                value: data.sellerPhone ?? '',
                              ),
                              pw.SizedBox(height: 5),
                              infoRow(
                                title: 'Email:',
                                value: data.sellerEmail ?? '',
                              ),
                              pw.SizedBox(height: 20),
                            ],
                          ),
                        ),
                        pw.SizedBox(width: 20),

                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'BUYER INFORMATION',
                                style: fontStyleForPDFLableGREY,
                              ),
                              pw.Divider(color: PdfColors.grey, thickness: 0.3),
                              infoRow(
                                title: 'Name:',
                                value: data.buyerName ?? '',
                              ),
                              pw.SizedBox(height: 5),
                              infoRow(
                                title: 'Emirates ID:',
                                value: data.buyerID ?? '',
                              ),
                              pw.SizedBox(height: 5),
                              infoRow(
                                title: 'Phone:',
                                value: data.buyerPhone ?? '',
                              ),
                              pw.SizedBox(height: 5),
                              infoRow(
                                title: 'Email:',
                                value: data.buyerEmail ?? '',
                              ),
                              pw.SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                    type == 'sales agreement'
                        ? pw.Row(
                            children: [
                              pw.Expanded(
                                child: pw.Column(
                                  children: [
                                    infoRow(
                                      title: 'Date:',
                                      value:
                                          '---------------------------------------------',
                                    ),
                                    pw.SizedBox(height: 20),
                                    infoRow(
                                      title: 'Signature:',
                                      value:
                                          '---------------------------------------------',
                                    ),
                                  ],
                                ),
                              ),
                              pw.SizedBox(width: 20),

                              pw.Expanded(
                                child: pw.Column(
                                  children: [
                                    infoRow(
                                      title: 'Date:',
                                      value:
                                          '---------------------------------------------',
                                    ),
                                    pw.SizedBox(height: 20),
                                    infoRow(
                                      title: 'Signature:',
                                      value:
                                          '---------------------------------------------',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : pw.SizedBox(),
                  ],
                ),
              );
            }),
          ];
        },
      ),
    );
    return pdf.save();
  }

  // ===========================================================================

  void clearCangesVariables() {
    lastChanges.clear();
    fromDateForChanges.value.clear();
    toDateForChanges.value.clear();
    minAmount.value.clear();
    maxAmount.value.clear();
    accountForLastChanges.value.clear();
  }
  // =============================== trnsfers section ============================================

  Future<void> getAllTransferes() async {
    try {
      isTransfersLoading.value = true;
      final accessToken = await _accessToken();
      final refreshToken = await _refreshToken();
      Uri url = Uri.parse('$backendUrl/car_trading/get_all_transfers');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = _jsonObject(response.body);
        List transferes = decoded['transfers'] ?? [];
        alltransfers.assignAll(
          transferes.whereType<Map>().map(
            (tr) => TransferModel.fromJson(Map<String, dynamic>.from(tr)),
          ),
        );
        calculateTransfersAmount();
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await getAllTransferes();
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

  Future<bool> addNewTransfer() async {
    try {
      if (!validateTransferForm()) return false;
      final isoDate = _isoDateFromText(
        transferDate.value,
        'Date',
        required: true,
      );
      if (isoDate == null) return false;
      addingNewTransferValue.value = true;
      final accessToken = await _accessToken();
      final refreshToken = await _refreshToken();
      Uri url = Uri.parse('$backendUrl/car_trading/add_new_transfer');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "date": isoDate,
          "from_account": fromAccountId.value,
          "to_account": toAccountId.value,
          "amount": double.tryParse(transferAmount.text) ?? 0.0,
          "comment": transferComments.value.text,
        }),
      );
      if (response.statusCode == 200) {
        await getAllTransferes();
        calculateTransfersAmount();
        addingNewTransferValue.value = false;
        Get.back();
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          addingNewTransferValue.value = false;
          return await addNewTransfer();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        _showError('Could not save transfer. Please try again.');
      }
      addingNewTransferValue.value = false;
      return false;
    } catch (e) {
      addingNewTransferValue.value = false;
      _showError('Something went wrong please try again');
      return false;
    }
  }

  Future<bool> updateTransfer(String id) async {
    try {
      if (id.isEmpty) return false;
      if (!validateTransferForm()) return false;
      final isoDate = _isoDateFromText(
        transferDate.value,
        'Date',
        required: true,
      );
      if (isoDate == null) return false;
      addingNewTransferValue.value = true;
      final accessToken = await _accessToken();
      final refreshToken = await _refreshToken();
      Uri url = Uri.parse('$backendUrl/car_trading/update_new_transfer/$id');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "date": isoDate,
          "from_account": fromAccountId.value,
          "to_account": toAccountId.value,
          "amount": double.tryParse(transferAmount.text) ?? 0.0,
          "comment": transferComments.value.text,
        }),
      );
      if (response.statusCode == 200) {
        await getAllTransferes();
        calculateTransfersAmount();
        addingNewTransferValue.value = false;
        Get.back();
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          addingNewTransferValue.value = false;
          return await updateTransfer(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        _showError('Could not update transfer. Please try again.');
      }
      addingNewTransferValue.value = false;
      return false;
    } catch (e) {
      addingNewTransferValue.value = false;
      _showError('Something went wrong please try again');
      return false;
    }
  }

  Future<bool> deleteTransfer(String id) async {
    try {
      if (id.isEmpty) return false;
      final accessToken = await _accessToken();
      final refreshToken = await _refreshToken();
      Uri url = Uri.parse('$backendUrl/car_trading/delete_transfer/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        alltransfers.removeWhere((item) => item.id == id);
        calculateTransfersAmount();
        Get.back();
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await deleteTransfer(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        _showError('Could not delete transfer. Please try again.');
      }
      return false;
    } catch (e) {
      _showError('Something went wrong please try again');
      return false;
    }
  }

  // ===========================================================================

  void filterLastChangesSearch() async {
    Map body = {};
    if (fromDateForChanges.value.text.isNotEmpty) {
      final fromIso = _isoDateFromText(fromDateForChanges.value, 'From Date');
      if (fromIso == null) return;
      body['from_date'] = fromIso;
    }
    if (toDateForChanges.value.text.isNotEmpty) {
      final toIso = _isoDateFromText(toDateForChanges.value, 'To Date');
      if (toIso == null) return;
      body['to_date'] = toIso;
    }
    if (minAmount.value.text.isNotEmpty) {
      body['min_amount'] = minAmount.value.text;
    }
    if (maxAmount.value.text.isNotEmpty) {
      body['max_amount'] = maxAmount.value.text;
    }
    if (accountForLastChanges.value.text.isNotEmpty) {
      body['account'] = accountForLastChanges.value.text;
    }
    await getLastChanges(body);
  }

  Future<void> getLastChanges(Map body) async {
    try {
      changesSearching.value = true;
      final accessToken = await _accessToken();
      final refreshToken = await _refreshToken();
      Uri url = Uri.parse('$backendUrl/car_trading/get_last_changes');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        final decoded = _jsonObject(response.body);
        List changes = decoded['last_changes'] ?? [];
        lastChanges.assignAll(
          changes.whereType<Map>().map(
            (change) => LastCarTradingChangesModel.fromJson(
              Map<String, dynamic>.from(change),
            ),
          ),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await getLastChanges(body);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      changesSearching.value = false;
    } catch (e) {
      changesSearching.value = false;
    }
  }

  // ==================================== Capitals and Outstanding section ====================================

  Future<void> getCapitalsOROutstandingSummary(String type) async {
    try {
      final accessToken = await _accessToken();
      final refreshToken = await _refreshToken();
      Uri url = Uri.parse(
        '$backendUrl/car_trading/get_capitals_or_outstanding_summary/$type',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = _jsonObject(response.body);
        Map totals = decoded["summary"] ?? {};
        if (type == 'capitals') {
          totalPaysForAllCapitals.value = _toDouble(totals['total_pay']);
          totalReceivesForAllCapitals.value = _toDouble(
            totals['total_receive'],
          );
          totalNETsForAllCapitals.value = _toDouble(totals['total_net']);
          numberOfCapitalsDocs.value = _toInt(totals['count']);

          int i = summaryData.indexWhere(
            (data) => data['category'].contains('Capital Docs'),
          );
          summaryData[i] = {
            ...summaryData[i],
            'count': numberOfCapitalsDocs.value,
            'paid': totalPaysForAllCapitals.value,
            'received': totalReceivesForAllCapitals.value,
            'net': totalNETsForAllCapitals.value,
          };
        } else if (type == 'outstanding') {
          totalPaysForAllOutstanding.value = _toDouble(totals['total_pay']);
          totalReceivesForAllOutstanding.value = _toDouble(
            totals['total_receive'],
          );
          totalNETsForAllOutstanding.value = _toDouble(totals['total_net']);
          numberOfOutstandingDocs.value = _toInt(totals['count']);
          int i = summaryData.indexWhere(
            (data) => data['category'].contains('Outstanding'),
          );

          if (i != -1) {
            summaryData[i] = {
              ...summaryData[i],
              'count': numberOfOutstandingDocs.value,
              'paid': totalPaysForAllOutstanding.value,
              'received': totalReceivesForAllOutstanding.value,
              'net': totalNETsForAllOutstanding.value,
            };
          }
        }
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await getCapitalsOROutstandingSummary(type);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
    } catch (e) {
      //
    }
  }

  Future<void> getAllCapitalsOROutstanding(String type) async {
    try {
      isCapitalLoading.value = true;
      totalPays.value = 0;
      totalReceives.value = 0;
      totalNETs.value = 0;
      final accessToken = await _accessToken();
      final refreshToken = await _refreshToken();
      Uri url = Uri.parse(
        '$backendUrl/car_trading/get_all_capitals_or_outstanding/$type',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = _jsonObject(response.body);
        List data = decoded['data'] ?? [];
        Map totals = decoded["totals"] ?? {};
        totalPays.value = _toDouble(totals['total_pay']);
        totalReceives.value = _toDouble(totals['total_receive']);
        totalNETs.value = _toDouble(totals['total_net']);
        if (type == "capitals") {
          allCapitals.assignAll(
            data.whereType<Map>().map(
              (c) => CapitalsAndOutstandingModel.fromJson(
                Map<String, dynamic>.from(c),
              ),
            ),
          );
        } else if (type == "outstanding") {
          allOutstanding.assignAll(
            data.whereType<Map>().map(
              (c) => CapitalsAndOutstandingModel.fromJson(
                Map<String, dynamic>.from(c),
              ),
            ),
          );
        }
        isCapitalLoading.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await getAllCapitalsOROutstanding(type);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        isCapitalLoading.value = false;
        logout();
      } else {
        isCapitalLoading.value = false;
      }
    } catch (e) {
      isCapitalLoading.value = false;
    }
  }

  Future<bool> addNewCapitalOrOutstanding(String type) async {
    try {
      if (!validateLineItemForm(isTrade: false, isGeneralExpenses: false)) {
        return false;
      }
      final isoDate = _isoDateFromText(itemDate.value, 'Date', required: true);
      if (isoDate == null) return false;
      isCapitalLoading.value = true;
      final accessToken = await _accessToken();
      final refreshToken = await _refreshToken();
      Uri url = Uri.parse(
        '$backendUrl/car_trading/add_new_capital_or_outstanding/$type',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "date": isoDate,
          "name": nameId.value,
          "account_name": accountNameId.value,
          "pay": double.tryParse(pay.text) ?? 0.0,
          "receive": double.tryParse(receive.text) ?? 0.0,
          "comment": comments.value.text,
        }),
      );
      if (response.statusCode == 200) {
        await getAllCapitalsOROutstanding(type);
        await getCapitalsOROutstandingSummary(type);
        await getCashOnHandOrBankBalance();
        isCapitalLoading.value = false;
        Get.back();
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          isCapitalLoading.value = false;
          return await addNewCapitalOrOutstanding(type);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        _showError('Could not save item. Please try again.');
      }
      isCapitalLoading.value = false;
      return false;
    } catch (e) {
      isCapitalLoading.value = false;
      _showError('Something went wrong please try again');
      return false;
    }
  }

  Future<bool> deleteCapitalOrOutstanding(String id, String type) async {
    try {
      if (id.isEmpty) return false;
      final accessToken = await _accessToken();
      final refreshToken = await _refreshToken();
      Uri url = Uri.parse(
        '$backendUrl/car_trading/delete_capital_or_outstanding/$type/$id',
      );
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        if (type == 'capitals') {
          allCapitals.removeWhere((item) => item.id == id);
        } else {
          allOutstanding.removeWhere((item) => item.id == id);
        }
        await getCapitalsOROutstandingSummary(type);
        await getCashOnHandOrBankBalance();
        calculateTotalsForCapitals(
          type == 'capitals' ? allCapitals : allOutstanding,
        );
        Get.back();
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await deleteCapitalOrOutstanding(id, type);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        _showError('Could not delete item. Please try again.');
      }
      return false;
    } catch (e) {
      _showError('Something went wrong please try again');
      return false;
    }
  }

  Future<bool> updateCapitalOrOutstanding(String id, String type) async {
    try {
      if (id.isEmpty) return false;
      if (!validateLineItemForm(isTrade: false, isGeneralExpenses: false)) {
        return false;
      }
      final isoDate = _isoDateFromText(itemDate.value, 'Date', required: true);
      if (isoDate == null) return false;
      isCapitalLoading.value = true;
      final accessToken = await _accessToken();
      final refreshToken = await _refreshToken();
      Uri url = Uri.parse(
        '$backendUrl/car_trading/update_capital_or_outstanding/$type/$id',
      );
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "date": isoDate,
          "name": nameId.value,
          "account_name": accountNameId.value,
          "pay": double.tryParse(pay.text) ?? 0.0,
          "receive": double.tryParse(receive.text) ?? 0.0,
          "comment": comments.value.text,
        }),
      );
      if (response.statusCode == 200) {
        await getAllCapitalsOROutstanding(type);
        await getCapitalsOROutstandingSummary(type);
        await getCashOnHandOrBankBalance();
        isCapitalLoading.value = false;
        Get.back();
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          isCapitalLoading.value = false;
          return await updateCapitalOrOutstanding(id, type);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        _showError('Could not update item. Please try again.');
      }
      isCapitalLoading.value = false;
      return false;
    } catch (e) {
      isCapitalLoading.value = false;
      _showError('Something went wrong please try again');
      return false;
    }
  }

  // ==================================== Geneal Expenses section ====================================

  Future<void> getAllGeneralExpenses() async {
    try {
      isCapitalLoading.value = true;
      totalPays.value = 0;
      totalReceives.value = 0;
      totalNETs.value = 0;
      final accessToken = await _accessToken();
      final refreshToken = await _refreshToken();
      Uri url = Uri.parse('$backendUrl/car_trading/get_all_general_expenses');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = _jsonObject(response.body);
        List data = decoded['data'] ?? [];
        Map totals = decoded["totals"] ?? {};
        totalPays.value = _toDouble(totals['total_pay']);
        totalReceives.value = _toDouble(totals['total_receive']);
        totalNETs.value = _toDouble(totals['total_net']);

        allGeneralExpenses.assignAll(
          data.whereType<Map>().map(
            (g) => GeneralExpensesModel.fromJson(Map<String, dynamic>.from(g)),
          ),
        );

        isCapitalLoading.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await getAllGeneralExpenses();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        isCapitalLoading.value = false;
        logout();
      } else {
        isCapitalLoading.value = false;
      }
    } catch (e) {
      isCapitalLoading.value = false;
    }
  }

  Future<void> filterGeneralExpensesSearch() async {
    searching.value = true;

    Map<String, dynamic> body = {};
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
      final fromIso = _isoDateFromText(fromDate.value, 'From Date');
      if (fromIso == null) {
        searching.value = false;
        return;
      }
      body["from_date"] = fromIso;
    }
    if (toDate.value.text.isNotEmpty) {
      final toIso = _isoDateFromText(toDate.value, 'To Date');
      if (toIso == null) {
        searching.value = false;
        return;
      }
      body["to_date"] = toIso;
    }
    if (body.isNotEmpty) {
      await getGeneralExpensesSummary(body);
    } else {
      await getGeneralExpensesSummary({"all": true});
    }
    searching.value = false;
  }

  Future<void> getGeneralExpensesSummary(Map body) async {
    try {
      final accessToken = await _accessToken();
      final refreshToken = await _refreshToken();
      Uri url = Uri.parse(
        '$backendUrl/car_trading/get_general_expenses_summary',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        final decoded = _jsonObject(response.body);
        Map totals = decoded["summary"] ?? {};
        totalPaysForAllGeneralExpenses.value = _toDouble(totals['total_pay']);
        totalReceivesForAllGeneralExpenses.value = _toDouble(
          totals['total_receive'],
        );
        totalNETsForAllGeneralExpenses.value = _toDouble(totals['total_net']);
        numberOfGeneralExpensesDocs.value = _toInt(totals['count']);
        totalNetProfit.value = _toDouble(totals['net_profit']);

        int i = summaryData.indexWhere(
          (data) => data['category'].contains('Expenses'),
        );
        summaryData[i] = {
          ...summaryData[i],
          'count': numberOfGeneralExpensesDocs.value,
          'paid': totalPaysForAllGeneralExpenses.value,
          'received': totalReceivesForAllGeneralExpenses.value,
          'net': totalNETsForAllGeneralExpenses.value,
        };
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await getGeneralExpensesSummary(body);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
    } catch (e) {
      //
    }
  }

  Future<bool> addNewGeneralExpenses() async {
    try {
      if (!validateLineItemForm(isTrade: false, isGeneralExpenses: true)) {
        return false;
      }
      final isoDate = _isoDateFromText(itemDate.value, 'Date', required: true);
      if (isoDate == null) return false;
      isCapitalLoading.value = true;
      final accessToken = await _accessToken();
      final refreshToken = await _refreshToken();
      Uri url = Uri.parse('$backendUrl/car_trading/add_new_general_expenses');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "date": isoDate,
          "item": itemId.value,
          "account_name": accountNameId.value,
          "pay": double.tryParse(pay.text) ?? 0.0,
          "receive": double.tryParse(receive.text) ?? 0.0,
          "comment": comments.value.text,
        }),
      );
      if (response.statusCode == 200) {
        await getAllGeneralExpenses();
        await getGeneralExpensesSummary({"all": true});
        await getCashOnHandOrBankBalance();
        isCapitalLoading.value = false;
        Get.back();
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          isCapitalLoading.value = false;
          return await addNewGeneralExpenses();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        _showError('Could not save expense. Please try again.');
      }
      isCapitalLoading.value = false;
      return false;
    } catch (e) {
      isCapitalLoading.value = false;
      _showError('Something went wrong please try again');
      return false;
    }
  }

  Future<bool> deleteGeneralExpenses(String id) async {
    try {
      if (id.isEmpty) return false;
      final accessToken = await _accessToken();
      final refreshToken = await _refreshToken();
      Uri url = Uri.parse(
        '$backendUrl/car_trading/delete_general_expenses/$id',
      );
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        allGeneralExpenses.removeWhere((item) => item.id == id);
        await getGeneralExpensesSummary({"all": true});
        await getCashOnHandOrBankBalance();
        calculateTotalsForCapitals(allGeneralExpenses);
        Get.back();
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await deleteGeneralExpenses(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        _showError('Could not delete expense. Please try again.');
      }
      return false;
    } catch (e) {
      _showError('Something went wrong please try again');
      return false;
    }
  }

  Future<bool> updateGeneralEpenses(String id) async {
    try {
      if (id.isEmpty) return false;
      if (!validateLineItemForm(isTrade: false, isGeneralExpenses: true)) {
        return false;
      }
      final isoDate = _isoDateFromText(itemDate.value, 'Date', required: true);
      if (isoDate == null) return false;
      isCapitalLoading.value = true;
      final accessToken = await _accessToken();
      final refreshToken = await _refreshToken();
      Uri url = Uri.parse(
        '$backendUrl/car_trading/update_generale_expenses/$id',
      );
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "date": isoDate,
          "item": itemId.value,
          "pay": double.tryParse(pay.text) ?? 0.0,
          "account_name": accountNameId.value,
          "receive": double.tryParse(receive.text) ?? 0.0,
          "comment": comments.value.text,
        }),
      );
      if (response.statusCode == 200) {
        await getAllGeneralExpenses();
        await getGeneralExpensesSummary({"all": true});
        await getCashOnHandOrBankBalance();
        isCapitalLoading.value = false;
        Get.back();
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          isCapitalLoading.value = false;
          return await updateGeneralEpenses(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        _showError('Could not update expense. Please try again.');
      }
      isCapitalLoading.value = false;
      return false;
    } catch (e) {
      isCapitalLoading.value = false;
      _showError('Something went wrong please try again');
      return false;
    }
  }

  // ==================================== Car Trading section ====================================

  void calculateTotals() {
    totalNETs.value = 0.0;
    totalPays.value = 0.0;
    totalReceives.value = 0.0;

    for (var item in addedItems) {
      totalPays.value += item.pay ?? 0;
      totalReceives.value += item.receive ?? 0;
    }

    totalNETs.value = totalReceives.value - totalPays.value;
  }

  void calculateTransfersAmount() {
    totalTransfersAmount.value = 0.0;
    for (var item in alltransfers) {
      totalTransfersAmount.value += item.amount ?? 0;
    }
  }

  void calculatePurchaseAgreementTotals() {
    totalPurchaseAgreementAmount.value = 0.0;
    totalPurchaseAgreementDownPayment.value = 0.0;

    for (var item in purchaseAgreementAddedItems) {
      totalPurchaseAgreementAmount.value += item.amount ?? 0;
      totalPurchaseAgreementDownPayment.value += item.aownpayment ?? 0;
    }
  }

  Future<bool> addNewItem() async {
    try {
      if (currentTradId.value.isEmpty) {
        _showError('Save trade first');
        return false;
      }
      if (!validateLineItemForm(isTrade: true, isGeneralExpenses: false)) {
        return false;
      }
      final isoDate = _isoDateFromText(itemDate.value, 'Date', required: true);
      if (isoDate == null) return false;
      addingTradeItem.value = true;
      final accessToken = await _accessToken();
      final refreshToken = await _refreshToken();
      Uri url = Uri.parse('$backendUrl/car_trading/add_trade_item');
      Map data = {
        "trade_id": currentTradId.value,
        "date": isoDate,
        "item": itemId.value,
        "account_name": accountNameId.value,
        "pay": double.tryParse(pay.value.text) ?? 0,
        "receive": double.tryParse(receive.value.text) ?? 0,
        "comment": comments.value.text,
      };
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final decoded = _jsonObject(response.body);
        final itemData = decoded['item'] ?? decoded['data'];
        if (itemData is Map) {
          _upsertTradeItem(
            CarTradingItemsModel.fromJson(Map<String, dynamic>.from(itemData)),
          );
        }
        calculateTotals();
        addingTradeItem.value = false;
        Get.back();
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          addingTradeItem.value = false;
          return await addNewItem();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        _showError('Could not save item. Please try again.');
      }
      addingTradeItem.value = false;
      return false;
    } catch (e) {
      addingTradeItem.value = false;
      _showError('Something went wrong please try again');
      return false;
    }
  }

  Future<bool> updateItem(String tradeItemID) async {
    try {
      if (currentTradId.value.isEmpty) {
        _showError('Save trade first');
        return false;
      }
      if (tradeItemID.isEmpty) return false;
      if (!validateLineItemForm(isTrade: true, isGeneralExpenses: false)) {
        return false;
      }
      final isoDate = _isoDateFromText(itemDate.value, 'Date', required: true);
      if (isoDate == null) return false;
      addingTradeItem.value = true;
      final accessToken = await _accessToken();
      final refreshToken = await _refreshToken();
      Uri url = Uri.parse(
        '$backendUrl/car_trading/update_trade_item/$tradeItemID',
      );
      Map data = {
        "trade_id": currentTradId.value,
        "date": isoDate,
        "item": itemId.value,
        "account_name": accountNameId.value,
        "pay": double.tryParse(pay.value.text) ?? 0,
        "receive": double.tryParse(receive.value.text) ?? 0,
        "comment": comments.value.text,
      };
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final decoded = _jsonObject(response.body);
        final itemData = decoded['item'] ?? decoded['data'];
        if (itemData is Map) {
          _upsertTradeItem(
            CarTradingItemsModel.fromJson(Map<String, dynamic>.from(itemData)),
          );
        }
        calculateTotals();
        addingTradeItem.value = false;
        Get.back();
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          addingTradeItem.value = false;
          return await updateItem(tradeItemID);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        _showError('Could not update item. Please try again.');
      }
      addingTradeItem.value = false;
      return false;
    } catch (e) {
      addingTradeItem.value = false;
      _showError('Something went wrong please try again');
      return false;
    }
  }

  Future<bool> deleteItem(String tradeItemID) async {
    try {
      if (currentTradId.value.isEmpty) {
        _showError('Save trade first');
        return false;
      }
      if (tradeItemID.isEmpty) return false;
      final accessToken = await _accessToken();
      final refreshToken = await _refreshToken();
      Uri url = Uri.parse(
        '$backendUrl/car_trading/delete_trade_item/$tradeItemID',
      );

      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        addedItems.removeWhere((item) => item.id == tradeItemID);
        calculateTotals();
        Get.back();
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await deleteItem(tradeItemID);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        _showError('Could not delete item. Please try again.');
      }
      return false;
    } catch (e) {
      _showError('Something went wrong please try again');
      return false;
    }
  }

  Future<void> getPurchaseAgreementForCurrentTrade(String tradeId) async {
    try {
      final accessToken = await _accessToken();
      final refreshToken = await _refreshToken();
      Uri url = Uri.parse(
        '$backendUrl/car_trading/get_purchase_agreement_for_current_trade/$tradeId',
      );

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = _jsonObject(response.body);
        List purchase = decoded['purchase_agreement_items'] ?? [];
        purchaseAgreementAddedItems.assignAll(
          purchase.whereType<Map>().map(
            (item) => CarTradingPurchaseAgreementModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          ),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await getPurchaseAgreementForCurrentTrade(tradeId);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
    } catch (e) {
      //
    }
  }

  Future<bool> addNewPurchaseAgreementItem() async {
    try {
      if (!validateSalesAgreementForm()) return false;
      final agreementIso = _isoDateFromText(
        agreementdate,
        'Agreement Date',
        required: true,
      );
      if (agreementIso == null) return false;
      addingPurchaseAgreement.value = true;
      final accessToken = await _accessToken();
      final refreshToken = await _refreshToken();
      Uri url = Uri.parse(
        '$backendUrl/car_trading/add_purchase_agreement_item',
      );
      Map data = {
        "trade_id": currentTradId.value,
        "agreement_date": agreementIso,
        "seller_name": sellerName.text,
        "seller_email": sellerEmail.text,
        "seller_phone": sellerPhone.text,
        "seller_ID": sellerID.text,
        "buyer_ID": buyerID.text,
        "buyer_name": buyerName.text,
        "buyer_email": buyerEmail.text,
        "buyer_phone": buyerPhone.text,
        "note": agreementNote.text,
        "agreement_amount": double.tryParse(agreementTotal.text) ?? 0,
        "agreement_down_payment":
            double.tryParse(agreementdownpayment.text) ?? 0,
      };
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final decoded = _jsonObject(response.body);
        final itemData = decoded['item'] ?? decoded['data'];
        if (itemData is Map) {
          _upsertPurchaseAgreement(
            CarTradingPurchaseAgreementModel.fromJson(
              Map<String, dynamic>.from(itemData),
            ),
          );
        } else {
          await getPurchaseAgreementForCurrentTrade(currentTradId.value);
        }
        calculatePurchaseAgreementTotals();
        addingPurchaseAgreement.value = false;
        Get.back();
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          addingPurchaseAgreement.value = false;
          return await addNewPurchaseAgreementItem();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        _showError('Could not save sales agreement. Please try again.');
      }
      addingPurchaseAgreement.value = false;
      return false;
    } catch (e) {
      addingPurchaseAgreement.value = false;
      _showError('Something went wrong please try again');
      return false;
    }
  }

  Future<bool> updatePurchaseAgreementItem(String id) async {
    try {
      if (currentTradId.value.isEmpty) {
        _showError('Save trade first');
        return false;
      }
      if (id.isEmpty) return false;
      if (!validateSalesAgreementForm()) return false;
      final agreementIso = _isoDateFromText(
        agreementdate,
        'Agreement Date',
        required: true,
      );
      if (agreementIso == null) return false;
      addingPurchaseAgreement.value = true;
      final accessToken = await _accessToken();
      final refreshToken = await _refreshToken();
      Uri url = Uri.parse(
        '$backendUrl/car_trading/update_purchase_agreement_item/$id',
      );
      Map data = {
        "trade_id": currentTradId.value,
        "agreement_date": agreementIso,
        "seller_name": sellerName.text,
        "seller_email": sellerEmail.text,
        "seller_phone": sellerPhone.text,
        "seller_ID": sellerID.text,
        "buyer_ID": buyerID.text,
        "buyer_name": buyerName.text,
        "buyer_email": buyerEmail.text,
        "buyer_phone": buyerPhone.text,
        "note": agreementNote.text,
        "agreement_amount": double.tryParse(agreementTotal.text) ?? 0,
        "agreement_down_payment":
            double.tryParse(agreementdownpayment.text) ?? 0,
      };
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final decoded = _jsonObject(response.body);
        final itemData = decoded['item'] ?? decoded['data'];
        if (itemData is Map) {
          _upsertPurchaseAgreement(
            CarTradingPurchaseAgreementModel.fromJson(
              Map<String, dynamic>.from(itemData),
            ),
          );
        } else {
          await getPurchaseAgreementForCurrentTrade(currentTradId.value);
        }
        calculatePurchaseAgreementTotals();
        addingPurchaseAgreement.value = false;
        Get.back();
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          addingPurchaseAgreement.value = false;
          return await updatePurchaseAgreementItem(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        _showError('Could not update sales agreement. Please try again.');
      }
      addingPurchaseAgreement.value = false;
      return false;
    } catch (e) {
      addingPurchaseAgreement.value = false;
      _showError('Something went wrong please try again');
      return false;
    }
  }

  Future<bool> deletePurchaseAgreementItem(String id) async {
    try {
      if (id.isEmpty) return false;
      final accessToken = await _accessToken();
      final refreshToken = await _refreshToken();
      Uri url = Uri.parse(
        '$backendUrl/car_trading/delete_purchase_agreement_item/$id',
      );
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        purchaseAgreementAddedItems.removeWhere((item) => item.id == id);
        calculatePurchaseAgreementTotals();
        Get.back();
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await deletePurchaseAgreementItem(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        _showError('Could not delete sales agreement. Please try again.');
      }
      return false;
    } catch (e) {
      _showError('Something went wrong please try again');
      return false;
    }
  }

  // void updateIdsFromBackend(List response) {
  //   for (var map in response) {
  //     final uuid = map['uuid'];
  //     final realId = map['db_id'];

  //     final index = addedItems.indexWhere((item) => item.id == uuid);
  //     if (index != -1) {
  //       addedItems[index].id = realId; // replace temp uuid with real id
  //       addedItems[index].modified = false; // reset if needed
  //       addedItems.refresh();
  //     }
  //   }
  // }

  Future<bool> addNewTrade() async {
    try {
      if (!validateTradeForm()) return false;

      addingNewValue.value = true;

      final isoDate = _isoDateFromText(
        date.value,
        'Transaction Date',
        required: true,
      );
      if (isoDate == null) {
        addingNewValue.value = false;
        return false;
      }
      final accessToken = await _accessToken();
      final refreshToken = await _refreshToken();

      Uri addUrl = Uri.parse('$backendUrl/car_trading/add_new_trade');
      Uri updateTradeUrl = Uri.parse(
        '$backendUrl/car_trading/update_trade/${currentTradId.value}',
      );

      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };

      Map<String, dynamic> body = {
        'bought_from': boughtFromId.value,
        'sold_to': soldToId.value,
        'bought_by': boughtById.value,
        'sold_by': soldById.value,
        'invested_by': investedById.value,
        'consignment_for': consignmentForId.value,
        'date': isoDate,
        'car_brand': carBrandId.value,
        'car_model': carModelId.value,
        'mileage': double.tryParse(mileage.value.text) ?? 0,
        'specification': carSpecificationId.value,
        'engine_size': engineSizeId.value,
        'color_in': colorInId.value,
        'color_out': colorOutId.value,
        'year': yearId.value,
        'note': note.text,
        'vin': vin.value.text,
      };

      final rawDate = warrantyEndDate.value.text.trim();
      if (rawDate.isNotEmpty) {
        final warrantyIso = _isoDateFromText(
          warrantyEndDate.value,
          'Warranty End Date',
        );
        if (warrantyIso == null) {
          addingNewValue.value = false;
          return false;
        }
        body['warranty_end_date'] = warrantyIso;
      } else {
        body['warranty_end_date'] = null;
      }

      final rawDate2 = serviceContractEndDate.value.text.trim();
      if (rawDate2.isNotEmpty) {
        final serviceIso = _isoDateFromText(
          serviceContractEndDate.value,
          'Service Contract End Date',
        );
        if (serviceIso == null) {
          addingNewValue.value = false;
          return false;
        }
        body['service_contract_end_date'] = serviceIso;
      } else {
        body['service_contract_end_date'] = null;
      }

      if (currentTradId.value == '') {
        // ---------- ADD ----------
        final response = await http.post(
          addUrl,
          headers: headers,
          body: jsonEncode(body),
        );

        final decoded = _jsonObject(response.body);
        if (response.statusCode == 200) {
          String tradeId = decoded["trade_id"]?.toString() ?? '';
          currentTradId.value = tradeId;
          status.value = 'New';
          carModified.value = false;
          await filterSearch();
          addingNewValue.value = false;
          return true;
        } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
          final refreshed = await helper.refreshAccessToken(refreshToken);
          if (refreshed == RefreshResult.success) {
            addingNewValue.value = false;
            return await addNewTrade();
          } else if (refreshed == RefreshResult.invalidToken) {
            logout();
          }
        } else if (response.statusCode == 401) {
          logout();
        } else {
          _showError(
            decoded["detail"]?.toString() ?? "Failed to add trade",
            title: 'Error',
          );
        }
      } else {
        // ---------- UPDATE ----------
        http.Response? carResponse;

        if (carModified.isTrue) {
          body.remove("items");
          body["status"] = status.value;
          carResponse = await http.patch(
            updateTradeUrl,
            headers: headers,
            body: jsonEncode(body),
          );
          final decoded = _jsonObject(carResponse.body);
          if (carResponse.statusCode == 200) {
            carModified.value = false;
            await filterSearch();
            addingNewValue.value = false;
            return true;
          } else if (carResponse.statusCode == 401 && refreshToken.isNotEmpty) {
            final refreshed = await helper.refreshAccessToken(refreshToken);
            if (refreshed == RefreshResult.success) {
              addingNewValue.value = false;
              return await addNewTrade();
            } else if (refreshed == RefreshResult.invalidToken) {
              logout();
            }
          } else if (carResponse.statusCode == 401) {
            logout();
          } else {
            _showError(
              decoded["detail"]?.toString() ?? "Failed to update trade",
              title: 'Error',
            );
          }
        } else {
          addingNewValue.value = false;
          return true;
        }
      }
      addingNewValue.value = false;
      return false;
    } catch (e) {
      addingNewValue.value = false;
      _showError('Something went wrong please try again');
      return false;
    }
  }

  Future<void> filterSearch() async {
    searching.value = true;

    Map<String, dynamic> body = {};
    // final parsedDate = inputFormat.parse(date.value.text);
    // final isoDate = parsedDate.toIso8601String();
    if (carBrandFilterId.value != '') {
      body["car_brand"] = carBrandFilterId.value;
    }
    if (carModelFilterId.value != '') {
      body["car_model"] = carModelFilterId.value;
    }
    if (carSpecificationFilterId.value != '') {
      body["specification"] = carSpecificationFilterId.value;
    }
    if (carEngineSizeFilterId.value != '') {
      body["engine_size"] = carEngineSizeFilterId.value;
    }
    if (carBoughtFromFilterId.value != '') {
      body["bought_from"] = carBoughtFromFilterId.value;
    }
    if (carSoldToFilterId.value != '') {
      body["sold_to"] = carSoldToFilterId.value;
    }
    if (carBoughtByFilterId.value != '') {
      body["bought_by"] = carBoughtByFilterId.value;
    }
    if (carSoldByFilterId.value != '') {
      body["sold_by"] = carSoldByFilterId.value;
    }
    if (carInvestedByFilterId.value != '') {
      body["invested_by"] = carInvestedByFilterId.value;
    }
    if (carConsignmentForFilterId.value != '') {
      body["consignment_for"] = carConsignmentForFilterId.value;
    }
    if (isSoldStatusSelected.isTrue) {
      body["status"] = "Sold";
    }
    if (isNewStatusSelected.isTrue) {
      body["status"] = "New";
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
      final fromIso = _isoDateFromText(fromDate.value, 'From Date');
      if (fromIso == null) {
        searching.value = false;
        return;
      }
      body["from_date"] = fromIso;
    }
    if (toDate.value.text.isNotEmpty) {
      final toIso = _isoDateFromText(toDate.value, 'To Date');
      if (toIso == null) {
        searching.value = false;
        return;
      }
      body["to_date"] = toIso;
    }
    if (body.isNotEmpty) {
      await searchEngine(body);
    } else {
      await searchEngine({"all": true});
    }
    searching.value = false;
  }

  Future<void> searchEngine(Map<String, dynamic> body) async {
    try {
      final accessToken = await _accessToken();
      final refreshToken = await _refreshToken();

      final url = Uri.parse(
        '$backendUrl/car_trading/search_engine_for_car_trading',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final data = decoded is List && decoded.isNotEmpty
            ? decoded[0]
            : decoded;
        if (data is! Map) return;
        List trades = data["trades"] ?? [];
        print(trades[0]);
        totalPaysForAllTrades.value = _toDouble(data['grand_total_pay']);
        totalReceivesForAllTrades.value = _toDouble(
          data['grand_total_receive'],
        );
        totalNETsForAllTrades.value = _toDouble(data['grand_net']);

        filteredTrades.assignAll(
          trades.whereType<Map>().map(
            (item) => CarTradeModel.fromJson(Map<String, dynamic>.from(item)),
          ),
        );
        numberOfCars.value = trades.length;
        int i = summaryData.indexWhere(
          (data) => data['category'].contains('Cars'),
        );
        summaryData[i] = {
          ...summaryData[i],
          'count': numberOfCars.value,
          'paid': totalPaysForAllTrades.value,
          'received': totalReceivesForAllTrades.value,
          'net': totalNETsForAllTrades.value,
        };
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await searchEngine(body);
        } else {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
    } catch (e) {
      // print(e);
    }
  }

  Future<bool> deleteTrade(String id) async {
    try {
      if (id.isEmpty) return false;
      final accessToken = await _accessToken();
      final refreshToken = await _refreshToken();

      final url = Uri.parse('$backendUrl/car_trading/delete_trade/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        filteredTrades.removeWhere((trade) => trade.id == id);
        numberOfCars.value = numberOfCars.value > 0
            ? numberOfCars.value - 1
            : 0;
        await allSearches();
        Get.close(2);
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await deleteTrade(id);
        } else {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        Get.back();
        _showError('Something went wrong please try again');
      }
      return false;
    } catch (e) {
      _showError('Something went wrong please try again');
      return false;
    }
  }

  Future<void> getCashOnHandOrBankBalance() async {
    try {
      final accessToken = await _accessToken();
      final refreshToken = await _refreshToken();

      final url = Uri.parse(
        '$backendUrl/car_trading/get_cash_on_hand_or_bank_balance',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = _jsonObject(response.body);
        Map data = decoded['totals'] ?? {};
        List totals = data['all_accounts'] ?? [];
        totalMoneyForAccounts.value = _toDouble(data['total_final_net']);
        accountsSummary.assignAll(
          totals.whereType<Map>().map(
            (acc) =>
                AccountSummaryModel.fromJson(Map<String, dynamic>.from(acc)),
          ),
        );
        // if (accountName == 'CASH') {
        //   totalNETsForAll.value = decoded['totals']['final_net'];
        // } else {
        //   totalNETsForBanckBalance.value = decoded['totals']['final_net'];
        // }
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await getCashOnHandOrBankBalance();
        } else {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
    } catch (e) {
      //
    }
  }

  // =======================================================================================================

  void calculateTotalsForCapitals(RxList allMap) {
    totalPays.value = 0;
    totalReceives.value = 0;
    totalNETs.value = 0;
    for (var element in allMap) {
      totalPays.value += element.pay;
      totalReceives.value += element.receive;
      totalNETs.value = totalReceives.value - totalPays.value;
    }
  }

  // this function is to filter the search results for web
  void filterCapitalsOrOutstandingOrGeneralExpenses(
    Rx<TextEditingController> mapQuery,
    RxList allMap,
    RxList filteredMap,
    bool isGeneral,
  ) {
    query.value = mapQuery.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredMap.clear();
      calculateTotalsForCapitals(allMap);
    } else {
      filteredMap.assignAll(
        allMap.where((cap) {
          return cap.pay.toString().toLowerCase().contains(query) ||
              cap.receive.toString().toLowerCase().contains(query) ||
              cap.comment.toString().toLowerCase().contains(query) ||
              (isGeneral == false ? cap.name : cap.item)
                  .toString()
                  .toLowerCase()
                  .contains(query) ||
              textToDate(cap.date).toLowerCase().contains(query);
        }).toList(),
      );
      calculateTotalsForCapitals(filteredMap);
    }
  }

  void filterItems() {
    final query = searchForItems.value.text.trim().toLowerCase();
    if (query.isEmpty) {
      filteredAddedItems.clear();
    } else {
      filteredAddedItems.assignAll(
        addedItems.where((item) {
          final dateStr = item.date.toString().toLowerCase();
          final itemName = item.item.toString().toLowerCase();
          final payStr = item.pay.toString().toLowerCase();
          final receiveStr = item.receive.toString().toLowerCase();
          final commentStr = item.comment.toString().toLowerCase();

          return dateStr.contains(query) ||
              itemName.contains(query) ||
              payStr.contains(query) ||
              commentStr.contains(query) ||
              receiveStr.contains(query);
        }).toList(),
      );
    }
  }

  void filterTransfers() {
    final query = searchForTransfers.value.text.trim().toLowerCase();
    if (query.isEmpty) {
      filteredTransfers.clear();
    } else {
      filteredTransfers.assignAll(
        alltransfers.where((item) {
          final dateStr = item.date.toString().toLowerCase();
          final fromAccountName = item.fromAccountName.toString().toLowerCase();
          final toAccountName = item.toAccountName.toString().toLowerCase();
          final comment = item.comment.toString().toLowerCase();

          return dateStr.contains(query) ||
              toAccountName.contains(query) ||
              fromAccountName.contains(query) ||
              comment.contains(query);
        }).toList(),
      );
    }
  }

  Future loadValues(CarTradeModel data) async {
    itemsPageName.value = 'sales agreement';
    boughtFrom.value.text = data.boughtFrom ?? '';
    boughtFromId.value = data.boughtFromId ?? '';
    boughtById.value = data.boughtById ?? '';
    boughtBy.value.text = data.boughtBy ?? '';
    vin.value.text = data.vin ?? '';
    soldById.value = data.soldById ?? '';
    soldBy.value.text = data.soldBy ?? '';
    investedById.value = data.investedById ?? '';
    investedBy.value.text = data.investedBy ?? '';
    consignmentForId.value = data.consignmentForId ?? '';
    consignmentFor.value.text = data.consignmentFor ?? '';
    soldTo.value.text = data.soldTo ?? '';
    soldToId.value = data.soldToId ?? '';
    totalPays.value = data.totalPay ?? 0.0;
    totalNETs.value = data.net ?? 0.0;
    totalReceives.value = data.totalReceive ?? 0.0;
    query.value = '';
    queryForItems.value = '';
    searchForItems.value.clear();
    await getModelsByCarBrand(data.carBrandId ?? '');
    date.value.text = textToDate(data.date);
    mileage.value.text = data.mileage.toString();
    colorIn.value.text = data.colorIn ?? '';
    colorInId.value = data.colorInId ?? '';
    colorOut.value.text = data.colorOut ?? '';
    colorOutId.value = data.colorOutId ?? '';
    carBrand.value.text = data.carBrand ?? '';
    carBrandId.value = data.carBrandId ?? '';
    carModel.value.text = data.carModel ?? '';
    carModelId.value = data.carModelId ?? '';
    carSpecification.value.text = data.specification ?? '';
    carSpecificationId.value = data.specificationId ?? '';
    engineSize.value.text = data.engineSize ?? '';
    engineSizeId.value = data.engineSizeId ?? '';
    year.value.text = data.year ?? '';
    yearId.value = data.yearId ?? '';
    note.text = data.note ?? '';
    addedItems.assignAll(data.tradeItems ?? []);
    status.value = data.status ?? '';
    currentTradId.value = data.id ?? '';
    carModified.value = false;
    warrantyEndDate.value.text = textToDate(data.warrantyEndDate);
    serviceContractEndDate.value.text = textToDate(data.serviceContractEndDate);
    await getPurchaseAgreementForCurrentTrade(data.id ?? '');
    calculatePurchaseAgreementTotals();
  }

  void clearValues() {
    itemsPageName.value = 'sales agreement';
    purchaseAgreementAddedItems.clear();
    warrantyEndDate.value.clear();
    serviceContractEndDate.value.clear();
    boughtFrom.value.clear();
    boughtBy.value.clear();
    soldBy.value.clear();
    investedBy.value.clear();
    consignmentFor.value.clear();
    boughtFromId.value = '';
    boughtById.value = '';
    soldById.value = '';
    investedById.value = '';
    consignmentForId.value = '';
    soldTo.value.clear();
    soldToId.value = '';
    totalPays.value = 0.0;
    totalNETs.value = 0.0;
    totalReceives.value = 0.0;
    query.value = '';
    queryForItems.value = '';
    searchForItems.value.clear();
    allModels.clear();
    date.value.text = textToDate(DateTime.now());
    mileage.value.text = '';
    colorIn.value.clear();
    colorInId.value = '';
    colorOut.value.clear();
    colorOutId.value = '';
    carBrand.value.clear();
    carBrandId.value = '';
    carModel.value.clear();
    carModelId.value = '';
    carSpecification.value.clear();
    carSpecificationId.value = '';
    engineSize.value.clear();
    engineSizeId.value = '';
    year.value.clear();
    vin.value.clear();
    yearId.value = '';
    note.clear();
    addedItems.clear();
    status.value = '';
    currentTradId.value = '';
  }

  void clearFilters() {
    initValueForDatePicker.value = 1;
    initValueForStatusPicker.value = 1;
    carSoldByFilter.value.clear();
    carBoughtByFilter.value.clear();
    carInvestedByFilter.value.clear();
    carConsignmentForFilter.value.clear();
    carSoldByFilterId.value = '';
    carBoughtByFilterId.value = '';
    carInvestedByFilterId.value = '';
    carConsignmentForFilterId.value = '';
    isTodaySelected.value = false;
    isThisMonthSelected.value = false;
    isThisYearSelected.value = false;
    carBrandFilter.value.clear();
    carModelFilter.value.clear();
    carBrandFilterId.value = '';
    carModelFilterId.value = '';
    allModels.clear();
    carSoldToFilter.value.clear();
    carSoldToFilterId.value = '';
    carBoughtFromFilter.value.clear();
    carBoughtFromFilterId.value = '';
    isNewStatusSelected.value = false;
    isSoldStatusSelected.value = false;
    carEngineSizeFilter.value.clear();
    carEngineSizeFilterId.value = '';
    carSpecificationFilter.value.clear();
    carSpecificationFilterId.value = '';
    fromDate.value.clear();
    toDate.value.clear();
    allSearches();
  }
}
