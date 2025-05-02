import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../consts.dart';
import 'main_screen_contro.dart';

class QuotationCardController extends GetxController {
  Rx<TextEditingController> quotationCounter = TextEditingController().obs;
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
  TextEditingController technician = TextEditingController();
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
  // TextEditingController customerSaleMan = TextEditingController();
  RxString customerSaleMan = RxString('');
  TextEditingController customerBranch = TextEditingController();
  TextEditingController customerCurrency = TextEditingController();
  TextEditingController customerCurrencyRate = TextEditingController();
  Rx<TextEditingController> mileageIn = TextEditingController().obs;
  Rx<TextEditingController> fuelAmount = TextEditingController().obs;
  Rx<TextEditingController> mileageOut = TextEditingController().obs;
  Rx<TextEditingController> inOutDiff = TextEditingController().obs;
  Rx<TextEditingController> search = TextEditingController().obs;
  Rx<TextEditingController> searchForInvoiceItems = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(true);
  RxBool loadingInvoiceItems = RxBool(false);
  final RxList<DocumentSnapshot> allQuotationCards =
      RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredQuotationCards =
      RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> allInvoiceItems = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredInvoiceItems =
      RxList<DocumentSnapshot>([]);
  RxString carBrandId = RxString('');
  RxString technicianId = RxString('');
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
  RxString label = RxString('');
  RxString userId = RxString('');
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxMap allBrands = RxMap({});
  RxMap allTechnicians = RxMap({});
  RxMap allModels = RxMap({});
  RxMap allCustomers = RxMap({});
  RxMap salesManMap = RxMap({});
  RxBool addingNewValue = RxBool(false);
  RxString companyId = RxString('');
  RxMap companyDetails = RxMap({});
  RxMap allCountries = RxMap({});
  RxMap allCities = RxMap({});
  RxMap allColors = RxMap({});
  RxMap allEngineType = RxMap({});
  RxMap allBranches = RxMap({});
  RxMap allCurrencies = RxMap({});
  RxMap allInvoiceItemsFromCollection = RxMap({});
  RxMap allUsers = RxMap();
  RxBool loadingCopyJob = RxBool(false);
  var selectedRowIndex = Rxn<int>();
  final ScrollController scrollController = ScrollController();
  RxString quotationStatus = RxString('');
  RxBool isCashSelected = RxBool(true);
  RxBool isCreditSelected = RxBool(false);
  RxString payType = RxString('Cash');
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
  RxString currentCountryVAT = RxString('');
  TextEditingController net = TextEditingController();
  RxBool addingNewinvoiceItemsValue = RxBool(false);
  RxBool quotationCardAdded = RxBool(false);
  RxInt pagesPerPage = RxInt(5);

  @override
  void onInit() async {
    super.onInit();
    // jobWarrentyEndDate.value.addListener(() {
    //   // Refresh the Rx to notify GetX that something changed
    //   jobWarrentyEndDate.refresh();
    // });
    await getCompanyId();
    getAllCustomers();
    getCarBrands();
    getCountries();
    getCompanyDetails();
    getUserId();
    getAllUsers();
    getSalesMan();
    getBranches();
    getCurrencies();
    getColors();
    getEngineTypes();
    getAllQuotationCards();
    // getInvoiceItemsFromCollection();
    // search.value.addListener(() {
    //   filterJobCards();
    // });
    // searchForInvoiceItems.value.addListener(() {
    //   filterInvoiceItems();
    // });
  }

  Future<void> addNewQuotationCard() async {
    try {
      addingNewValue.value = true;
      Map<String, dynamic> newData = {
        'label': '',
        'quotation_status': quotationStatus.value,
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
        'quotation_number': quotationCounter.value.text,
        'quotation_date': quotationDate.value.text,
        'validity_days': quotationDays.value.text,
        'validity_end_date': validityEndDate.value.text,
        'reference_number': referenceNumber.value.text,
        'delivery_time': deliveryTime.value.text,
        'quotation_warrenty_days': quotationWarrentyDays.value.text,
        'quotation_warrenty_km': quotationWarrentyKM.value.text,
        'quotation_notes': quotationNotes.text,
      };

      if (quotationCounter.value.text.isEmpty) {
        quotationStatus.value = 'New';
        newData['quotation_status'] = 'New';
        newData['label'] = '';

        await getCurrentQuotationCounterNumber();
        newData['quotation_number'] = quotationCounter.value.text;
      }

      if (quotationCardAdded.isFalse) {
        newData['added_date'] = DateTime.now().toString();
        var newJob = await FirebaseFirestore.instance
            .collection('quotation_cards')
            .add(newData);
        quotationCardAdded.value = true;
        curreentQuotationCardId.value = newJob.id;
      } else {
        newData.remove('added_date');
        await FirebaseFirestore.instance
            .collection('quotation_cards')
            .doc(curreentQuotationCardId.value)
            .update(newData);
      }
      // canAddInternalNotesAndInvoiceItems.value = true;
      addingNewValue.value = false;
    } catch (e) {
      // canAddInternalNotesAndInvoiceItems.value = false;
      addingNewValue.value = false;
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

        var newCounter =
            await FirebaseFirestore.instance.collection('counters').add({
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
        quotationCounter.value.text = '$prefix$separator$initialValue';
        updateqn = initialValue.toString();
      } else {
        var firstDoc = qnDoc.docs.first;
        qnId = firstDoc.id;
        var currentValue = firstDoc.data()['value'] ?? 0;
        quotationCounter.value.text =
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

  addNewInvoiceItem(String jobId) async {
    try {
      addingNewinvoiceItemsValue.value = true;
      await FirebaseFirestore.instance
          .collection('quotation_cards')
          .doc(jobId)
          .collection('invoice_items')
          .add({
        'company_id': companyId.value,
        'name': invoiceItemNameId.value,
        'line_number': int.tryParse(lineNumber.text),
        'description': description.text,
        'quantity': quantity.text,
        'price': price.text,
        'amount': amount.text,
        'discount': discount.text,
        'total': total.text,
        'vat': vat.text,
        'net': net.text,
        'added_date': DateTime.now().toString(),
      });
      addingNewinvoiceItemsValue.value = false;
      Get.back();
    } catch (e) {
      addingNewinvoiceItemsValue.value = false;
    }
  }

  void updateAmount() {
    if (net.text.isEmpty) net.text = '0';
    if (net.text != '0') {
      total.text = (double.tryParse(net.text)! /
              (1 + double.tryParse(currentCountryVAT.value)! / 100))
          .toStringAsFixed(2);
      amount.text =
          (double.tryParse(total.text)! + double.tryParse(discount.text)!)
              .toStringAsFixed(2);
      price.text =
          (double.tryParse(amount.text)! / double.tryParse(quantity.text)!)
              .toStringAsFixed(2);
      vat.text = ((double.tryParse(total.text))! *
              (double.parse(currentCountryVAT.value)) /
              100)
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
    total.text =
        (double.tryParse(amount.text)! - currentDiscount).toStringAsFixed(2);
    vat.text = ((double.tryParse(total.text))! *
            (double.parse(currentCountryVAT.value)) /
            100)
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

  getAllInvoiceItems(quotationId) {
    try {
      loadingInvoiceItems.value = true;
      FirebaseFirestore.instance
          .collection('quotation_cards')
          .doc(quotationId)
          .collection('invoice_items')
          .orderBy('line_number')
          .snapshots()
          .listen((items) {
        allInvoiceItems.assignAll(List<DocumentSnapshot>.from(items.docs));
        loadingInvoiceItems.value = false;
      });
    } catch (e) {
      loadingInvoiceItems.value = false;
    }
  }

  List<double> calculateTotals() {
    // this is for invoice items
    double sumofTotal = 0.0;
    double sumofVAT = 0.0;
    double sumofNET = 0.0;

    for (var job in filteredInvoiceItems.isEmpty &&
            searchForInvoiceItems.value.text.isEmpty
        ? allInvoiceItems
        : filteredInvoiceItems) {
      var data = job.data() as Map<String, dynamic>?;
      sumofTotal += double.parse(data?['total']);
      sumofNET += double.parse(data?['net']);
      sumofVAT += double.parse(data?['vat']);
    }

    return [sumofTotal, sumofVAT, sumofNET];
  }

// this function is to get engine types
  getEngineTypes() async {
    var typeDoc = await FirebaseFirestore.instance
        .collection('all_lists')
        .where('code', isEqualTo: 'ENGINE_TYPES')
        .get();

    var typeId = typeDoc.docs.first.id;

    FirebaseFirestore.instance
        .collection('all_lists')
        .doc(typeId)
        .collection('values')
        .where('available', isEqualTo: true)
        .orderBy('name')
        .snapshots()
        .listen((types) {
      allEngineType.value = {for (var doc in types.docs) doc.id: doc.data()};
    });
  }

// this function is to get colors
  getColors() async {
    var typeDoc = await FirebaseFirestore.instance
        .collection('all_lists')
        .where('code', isEqualTo: 'COLORS')
        .get();

    var typeId = typeDoc.docs.first.id;

    FirebaseFirestore.instance
        .collection('all_lists')
        .doc(typeId)
        .collection('values')
        .where('available', isEqualTo: true)
        .snapshots()
        .listen((colors) {
      allColors.value = {for (var doc in colors.docs) doc.id: doc.data()};
    });
  }

  getBranches() {
    FirebaseFirestore.instance
        .collection('branches')
        .snapshots()
        .listen((branches) {
      allBranches.value = {for (var doc in branches.docs) doc.id: doc.data()};
    });
  }

  getCurrencies() {
    FirebaseFirestore.instance
        .collection('currencies')
        .snapshots()
        .listen((branches) {
      allCurrencies.value = {for (var doc in branches.docs) doc.id: doc.data()};
    });
  }

  getSalesMan() {
    FirebaseFirestore.instance
        .collection('sales_man')
        .snapshots()
        .listen((branches) {
      salesManMap.value = {for (var doc in branches.docs) doc.id: doc.data()};
    });
  }

  getAllUsers() {
    try {
      FirebaseFirestore.instance
          .collection('sys-users')
          .where('company_id', isEqualTo: companyId.value)
          .snapshots()
          .listen((users) {
        allUsers.value = {for (var doc in users.docs) doc.id: doc.data()};
      });
    } catch (e) {
      //
    }
  }

  getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId.value = prefs.getString('userId')!;
  }

  getCompanyDetails() {
    try {
      FirebaseFirestore.instance
          .collection('companies')
          .where(FieldPath.documentId, isEqualTo: companyId.value)
          .snapshots()
          .listen((company) {
        companyDetails.assignAll(
            Map<String, dynamic>.from(company.docs.first.data() as Map));
      });
    } catch (e) {
      //
    }
  }

  getCountries() {
    try {
      FirebaseFirestore.instance
          .collection('all_countries')
          .snapshots()
          .listen((countries) {
        allCountries.value = {
          for (var doc in countries.docs) doc.id: doc.data()
        };
      });
    } catch (e) {
      //
    }
  }

  getCarBrands() {
    try {
      FirebaseFirestore.instance
          .collection('all_brands')
          .snapshots()
          .listen((brands) {
        allBrands.value = {for (var doc in brands.docs) doc.id: doc.data()};
      });
    } catch (e) {
      //
    }
  }

  getAllCustomers() {
    try {
      FirebaseFirestore.instance
          .collection('entity_informations')
          .where('entity_code', arrayContains: 'Customer')
          .snapshots()
          .listen((customers) {
        allCustomers.value = {
          for (var doc in customers.docs) doc.id: doc.data()
        };
      });
    } catch (e) {
      //
    }
  }

  getCompanyId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId.value = prefs.getString('companyId')!;
  }

  void selectCashOrCredit(String selected, bool value) {
    bool isCash = selected == 'cash';

    isCashSelected.value = isCash ? value : false;
    isCreditSelected.value = isCash ? false : value;
    payType.value = isCash ? 'Cash' : 'Credit';
  }

  inOutDiffCalculating() {
    inOutDiff.value.text =
        (int.parse(mileageOut.value.text) - int.parse(mileageIn.value.text))
            .toString();
  }

  Future<void> selectDateContext(
      BuildContext context, TextEditingController date) async {
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

  changeQuotationEndDateDependingOnDays() {
    DateTime date = format.parse(quotationDate.value.text);
    DateTime newDate =
        date.add(Duration(days: int.parse(quotationDays.value.text)));
    validityEndDate.value.text = format.format(newDate);
  }

  changingDaysDependingOnQuotationEndDate() {
    DateTime specificDate = format.parse(validityEndDate.value.text);

    quotationDays.value.text =
        (specificDate.difference(format.parse(quotationDate.value.text)).inDays)
            .toString();
  }

  void onSelectForCustomers(String selectedId) {
    var currentUserDetails = allCustomers.entries.firstWhere((entry) {
      return entry.key
          .toString()
          .toLowerCase()
          .contains(selectedId.toLowerCase());
    });

    var phoneDetails = currentUserDetails.value['entity_phone'].firstWhere(
      (value) => value['isPrimary'] == true,
      orElse: () => {'phone': ''},
    );

    customerEntityPhoneNumber.text = phoneDetails['number'] ?? '';
    customerEntityName.text = phoneDetails['name'] ?? '';
    customerEntityEmail.text = phoneDetails['email'];

    customerCreditNumber.text =
        (currentUserDetails.value['credit_limit'] ?? '0').toString();
    customerSaleManId.value = currentUserDetails.value['sales_man'];
    customerSaleMan.value =
        getdataName(currentUserDetails.value['sales_man'], salesManMap);
  }

  getCitiesByCountryID(countryID) {
    try {
      FirebaseFirestore.instance
          .collection('all_countries')
          .doc(countryID)
          .collection('values')
          .snapshots()
          .listen((cities) {
        allCities.value = {for (var doc in cities.docs) doc.id: doc.data()};
      });
    } catch (e) {
      //
    }
  }

  getModelsByCarBrand(brandId) {
    try {
      FirebaseFirestore.instance
          .collection('all_brands')
          .doc(brandId)
          .collection('values')
          .snapshots()
          .listen((models) {
        allModels.value = {for (var doc in models.docs) doc.id: doc.data()};
      });
    } catch (e) {
      //
    }
  }

  getAllQuotationCards() {
    try {
      FirebaseFirestore.instance
          .collection('quotation_cards')
          .where('company_id', isEqualTo: companyId.value)
          .snapshots()
          .listen((cards) {
        allQuotationCards.assignAll(List<DocumentSnapshot>.from(cards.docs));
        isScreenLoding.value = false;
      });
    } catch (e) {
      isScreenLoding.value = false;
    }
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
        sumOfTotal += double.tryParse(data?['total']?.toString() ?? '0') ?? 0;
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

  getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  String getdataName(String id, Map allData, {title = 'name'}) {
    try {
      final data = allData.entries.firstWhere(
        (data) => data.key == id,
      );
      return data.value[title];
    } catch (e) {
      return '';
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
}
