import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobCardController extends GetxController {
  Rx<TextEditingController> jobCardCounter =
      TextEditingController(text: 'Auto').obs;
  Rx<TextEditingController> jobCardDate =
      TextEditingController(text: '${textToDate(DateTime.now())}').obs;
  Rx<TextEditingController> invoiceDate =
      TextEditingController(text: '${textToDate(DateTime.now())}').obs;
  Rx<TextEditingController> approvalDate = TextEditingController().obs;
  Rx<TextEditingController> startDate =
      TextEditingController(text: '${textToDate(DateTime.now())}').obs;
  Rx<TextEditingController> finishDate = TextEditingController().obs;
  Rx<TextEditingController> deliveryDate = TextEditingController().obs;
  Rx<TextEditingController> jobWarrentyDays = TextEditingController().obs;
  Rx<TextEditingController> jobWarrentyKM = TextEditingController().obs;
  Rx<TextEditingController> jobWarrentyEndDate = TextEditingController().obs;
  Rx<TextEditingController> reference1 = TextEditingController().obs;
  Rx<TextEditingController> reference2 = TextEditingController().obs;
  Rx<TextEditingController> reference3 = TextEditingController().obs;
  Rx<TextEditingController> minTestKms = TextEditingController().obs;
  Rx<TextEditingController> invoiceCounter =
      TextEditingController(text: 'Auto').obs;
  Rx<TextEditingController> lpoCounter = TextEditingController().obs;
  Rx<TextEditingController> quotationCounter =
      TextEditingController(text: 'Auto').obs;
  Rx<TextEditingController> quotationDate =
      TextEditingController(text: '${textToDate(DateTime.now())}').obs;
  Rx<TextEditingController> quotationDays = TextEditingController().obs;
  Rx<TextEditingController> validityEndDate = TextEditingController().obs;
  Rx<TextEditingController> referenceNumber = TextEditingController().obs;
  Rx<TextEditingController> deliveryTime = TextEditingController().obs;
  Rx<TextEditingController> quotationWarrentyDays = TextEditingController().obs;
  Rx<TextEditingController> quotationWarrentyKM = TextEditingController().obs;
  TextEditingController quotationNotes = TextEditingController();
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
  TextEditingController color = TextEditingController();
  TextEditingController customerName = TextEditingController();
  TextEditingController customerEntityName = TextEditingController();
  TextEditingController customerEntityEmail = TextEditingController();
  TextEditingController customerEntityPhoneNumber = TextEditingController();
  TextEditingController customerCreditNumber = TextEditingController(text: '0');
  TextEditingController customerOutstanding = TextEditingController(text: '0');
  TextEditingController customerSaleMan = TextEditingController();
  TextEditingController customerBranch = TextEditingController();
  TextEditingController customerCurrency = TextEditingController();
  TextEditingController customerCurrencyRate = TextEditingController(text: '0');
  Rx<TextEditingController> mileageIn = TextEditingController(text: '0').obs;
  Rx<TextEditingController> mileageOut = TextEditingController(text: '0').obs;
  Rx<TextEditingController> inOutDiff = TextEditingController(text: '0').obs;
  RxString carBrandId = RxString('');
  RxString carModelId = RxString('');
  RxString countryId = RxString('');
  RxString colorId = RxString('');
  RxString cityId = RxString('');
  RxString customerId = RxString('');
  RxString customerSaleManId = RxString('');
  RxString customerBranchId = RxString('');
  RxString customerCurrencyId = RxString('');
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  Rx<TextEditingController> searchForInvoiceItems = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(true);
  RxBool loadingInvoiceItems = RxBool(true);
  final RxList<DocumentSnapshot> allJobCards = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> allInvoiceItems = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredJobCards =
      RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredInvoiceItems =
      RxList<DocumentSnapshot>([]);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  RxString companyId = RxString('');
  RxMap companyDetails = RxMap({});
  RxMap allCountries = RxMap({});
  // RxMap filterdCitiesByCountry = RxMap({});
  RxMap allCities = RxMap({});
  RxMap allColors = RxMap({});
  RxMap allBranches = RxMap({});
  RxMap allCurrencies = RxMap({});

  RxMap allBrands = RxMap({});
  // RxMap filterdModelsByBrands = RxMap({});
  RxMap allModels = RxMap({});
  RxMap allCustomers = RxMap({});
  RxMap salesManMap = RxMap({});
  RxBool isCashSelected = RxBool(true);
  RxBool isCreditSelected = RxBool(false);
  RxString payType = RxString('Cash');
  DateFormat format = DateFormat("dd-MM-yyyy");
  RxBool isQuotationExpanded = RxBool(false);
  RxBool isJobCardExpanded = RxBool(true);
  RxMap allUsers = RxMap();
  RxString userId = RxString('');
  // internal notes section
  RxBool loadingInternalNotes = RxBool(false);
  final ScrollController scrollController = ScrollController();
  RxList<Map> internalNotes = RxList<Map>([]);
  Rx<TextEditingController> internalNote = TextEditingController().obs;
  RxString noteMessage = RxString('');
  final ScrollController scrollControllerForNotes = ScrollController();
  FocusNode textFieldFocusNode = FocusNode();
  Rx<Uint8List?> fileBytes = Rx<Uint8List?>(null);
  RxString fileType = RxString('');
  RxString fileName = RxString('');
  // invoice items section
  RxBool addingNewinvoiceItemsValue = RxBool(false);

  @override
  void onInit() async {
    super.onInit();
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
    getAllJobCards();
  }

  @override
  void onClose() {
    textFieldFocusNode.dispose();
    super.onClose();
  }

  clearValues() {
    carBrand.clear();
    carBrandId.value = '';
    carModel.clear();
    carModelId.value = '';
    plateNumber.clear();
    plateCode.clear();
    city.clear();
    year.clear();
    color.clear();
    colorId.value = '';
    vin.clear();
    customerName.clear();
    customerId.value = '';
    customerEntityName.clear();
    customerEntityPhoneNumber.clear();
    customerEntityEmail.clear();
    customerSaleManId.value = '';
    customerSaleMan.clear();
    customerBranchId.value = '';
    customerBranch.clear();
    customerCurrencyRate.clear();
    customerCurrencyId.value = '';
    customerCurrency.clear();
    quotationDays.value.clear();
    validityEndDate.value.clear();
    referenceNumber.value.clear();
    deliveryTime.value.clear();
    quotationWarrentyDays.value.text = '0';
    quotationWarrentyKM.value.text = '0';
    quotationNotes.clear();
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
    reference3.value.clear();
    jobNotes.clear();
    deliveryNotes.clear();
    internalNotes.clear();
  }

  int safeParseInt(String? value, {defaultValue = ''}) {
    if (value == null || value.trim().isEmpty) return defaultValue;
    return int.tryParse(value) ?? defaultValue;
  }

  Future<void> addNewJobCardAndQuotation() async {
    try {
      // Indicate that a new value is being added
      addingNewValue.value = true;

      // Ensure quotation and job card counters are updated
      await getCurrentQuotationCounterNumber();
      await getCurrentJobCardCounterNumber();
      // await getCurrentInvoiceCounterNumber();

      await FirebaseFirestore.instance.collection('job_cards').add({
        'company_id': companyId.value,
        'car_brand': carBrandId.value,
        'car_model': carModelId.value,
        'plate_number': plateNumber.text,
        'plate_code': plateCode.text,
        'country': countryId.value,
        'city': cityId.value,
        'year': year.text,
        'color': colorId.value,
        'vehicle_identification_number': vin.text,
        'mileage_in': safeParseInt(mileageIn.value.text),
        'mileage_out': safeParseInt(mileageOut.value.text),
        'mileage_in_out_diff': safeParseInt(inOutDiff.value.text),
        'customer': customerId.value,
        'contact_name': customerEntityName.text,
        'contact_number': customerEntityPhoneNumber.text,
        'contact_email': customerEntityEmail.text,
        'credit_limit': safeParseInt(customerCreditNumber.text),
        'outstanding': safeParseInt(customerOutstanding.text),
        'saleMan': customerSaleManId.value,
        'branch': customerBranchId.value,
        'currency': customerCurrencyId.value,
        'rate': customerCurrencyRate.text,
        'payment_method': payType.value,
        'quotation_number': safeParseInt(quotationCounter.value.text),
        'quotation_date': quotationDate.value.text,
        'validity_days': quotationDays.value.text,
        'validity_end_date': validityEndDate.value.text,
        'reference_number': referenceNumber.value.text,
        'delivery_time': deliveryTime.value.text,
        'quotation_warrenty_days':
            safeParseInt(quotationWarrentyDays.value.text),
        'quotation_warrenty_km': safeParseInt(quotationWarrentyKM.value.text),
        'quotation_notes': quotationNotes.text,
        'job_number': safeParseInt(jobCardCounter.value.text),
        'invoice_number': safeParseInt(invoiceCounter.value.text),
        'lpo_number': lpoCounter.value.text,
        'job_date': jobCardDate.value.text,
        'invoice_date': invoiceDate.value.text,
        'job_approval_date': approvalDate.value.text,
        'job_start_date': startDate.value.text,
        'job_finish_date': finishDate.value.text,
        'job_delivery_date': deliveryDate.value.text,
        'job_warrenty_days': safeParseInt(jobWarrentyDays.value.text),
        'job_warrenty_km': safeParseInt(jobWarrentyKM.value.text),
        'job_warrenty_end_date': jobWarrentyEndDate.value.text,
        'job_min_test_km': safeParseInt(minTestKms.value.text),
        'job_reference_1': reference1.value.text,
        'job_reference_2': reference2.value.text,
        'job_reference_3': reference3.value.text,
        'job_notes': jobNotes.text,
        'job_delivery_notes': deliveryNotes.text,
      });

      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  getUserNameByUserId(userId) {
    try {
      final user = allUsers.entries.firstWhere(
        (user) => user.key == userId,
      );
      return user.value['user_name'];
    } catch (e) {
      return '';
    }
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

  List<Map<String, dynamic>> get sortedNotes {
    // Convert RxList<Map<dynamic, dynamic>> to List<Map<String, dynamic>>
    final notes = internalNotes
        .map((e) => Map<String, dynamic>.from(e)) // Explicit type conversion
        .toList();

    notes.sort((a, b) => a['time'].compareTo(b['time']));
    return notes;
  }

  getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId.value = prefs.getString('userId')!;
  }

  addNewNote() {
    internalNotes.add({
      'type': 'Text',
      'note': noteMessage.value.trim(),
      'user_id': userId.value,
      'time': DateTime.now(),
    });
  }

  addNewMediaNote({required type}) {
    internalNotes.add({
      'file_name': fileName.value,
      'type': type,
      'note': fileBytes.value,
      'user_id': userId.value,
      'time': DateTime.now(),
    });
  }

  void scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent * 5,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  changingDaysDependingOnQuotationEndDate() {
    DateTime specificDate = format.parse(validityEndDate.value.text);

    quotationDays.value.text =
        (specificDate.difference(format.parse(quotationDate.value.text)).inDays)
            .toString();
  }

  changeQuotationEndDateDependingOnDays() {
    DateTime date = format.parse(quotationDate.value.text);
    DateTime newDate =
        date.add(Duration(days: int.parse(quotationDays.value.text)));
    validityEndDate.value.text = format.format(newDate);
  }

  Future<void> selectDateContext(BuildContext context, date) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      date.value.text = textToDate(picked.toString());
    }
  }

  void selectCashOrCredit(String selected, bool value) {
    bool isCash = selected == 'cash';

    isCashSelected.value = isCash ? value : false;
    isCreditSelected.value = isCash ? false : value;
    payType.value = isCash ? 'Cash' : 'Credit';
  }

  getCurrencies() {
    FirebaseFirestore.instance
        .collection('currencies')
        .snapshots()
        .listen((branches) {
      allCurrencies.value = {for (var doc in branches.docs) doc.id: doc.data()};
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

// this function is to get all sales man in the system
  getSalesMan() {
    FirebaseFirestore.instance
        .collection('sales_man')
        .snapshots()
        .listen((saleMan) {
      salesManMap.value = {for (var doc in saleMan.docs) doc.id: doc.data()};
    });
  }

  getCompanyId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId.value = prefs.getString('companyId')!;
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

  String? getCountryName(String countryId) {
    try {
      final country = allCountries.entries.firstWhere(
        (country) => country.key == countryId,
      );
      return country.value['name'];
    } catch (e) {
      return '';
    }
  }

  String? getBrandName(String brandId) {
    try {
      final brand = allBrands.entries.firstWhere(
        (brand) => brand.key == brandId,
      );
      return brand.value['name'];
    } catch (e) {
      return '';
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
        return 'ffffffffff';
      }
    } catch (e) {
      return ''; // Return empty string on error
    }
  }

  String? getCustomerName(String customerId) {
    try {
      final customer = allCustomers.entries.firstWhere(
        (customer) => customer.key == customerId,
      );
      return customer.value['entity_name'];
    } catch (e) {
      return '';
    }
  }

  inOutDiffCalculating() {
    inOutDiff.value.text =
        (int.parse(mileageOut.value.text) - int.parse(mileageIn.value.text))
            .toString();
  }

// this function is to get industries
  getColors() async {
    var typeDoc = await FirebaseFirestore.instance
        .collection('all_lists')
        .where('code', isEqualTo: 'COLORS')
        .get();

    var typrId = typeDoc.docs.first.id;

    FirebaseFirestore.instance
        .collection('all_lists')
        .doc(typrId)
        .collection('values')
        .where('available', isEqualTo: true)
        .snapshots()
        .listen((colors) {
      allColors.value = {for (var doc in colors.docs) doc.id: doc.data()};
    });
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

  Future<void> getCurrentJobCardCounterNumber() async {
    try {
      var jcnId = '';
      var jcnDoc = await FirebaseFirestore.instance
          .collection('counters')
          .where('code', isEqualTo: 'JCN')
          .where('company_id', isEqualTo: companyId.value)
          .get();

      if (jcnDoc.docs.isEmpty) {
        var newCounter =
            await FirebaseFirestore.instance.collection('counters').add({
          'code': 'JCN',
          'description': 'Job Card Number',
          'prefix': 'JCN',
          'value': 1,
          'length': 0,
          'separator': '-',
          'added_date': DateTime.now().toString(),
          'company_id': companyId.value,
          'status': true,
        });
        jcnId = newCounter.id;
        jobCardCounter.value.text = "1";
      } else {
        var firstDoc = jcnDoc.docs.first;
        jcnId = firstDoc.id;
        jobCardCounter.value.text = (firstDoc.data()['value'] + 1).toString();
      }

      await FirebaseFirestore.instance
          .collection('counters')
          .doc(jcnId)
          .update({
        'value': int.parse(jobCardCounter.value.text), // Incrementing value
      });
    } catch (e) {
      // print("Error in getCurrentJobCardCounterNumber: $e");
    }
  }

  Future<void> getCurrentInvoiceCounterNumber() async {
    try {
      var jciId = '';
      var jciDoc = await FirebaseFirestore.instance
          .collection('counters')
          .where('code', isEqualTo: 'JCI')
          .where('company_id', isEqualTo: companyId.value)
          .get();

      if (jciDoc.docs.isEmpty) {
        var newCounter =
            await FirebaseFirestore.instance.collection('counters').add({
          'code': 'JCI',
          'description': 'Job Card Invoice Number',
          'prefix': 'JCI',
          'value': 1,
          'length': 0,
          'separator': '-',
          'added_date': DateTime.now().toString(),
          'company_id': companyId.value,
          'status': true,
        });
        jciId = newCounter.id;
        invoiceCounter.value.text = "1";
      } else {
        var firstDoc = jciDoc.docs.first;
        jciId = firstDoc.id;
        invoiceCounter.value.text = (firstDoc.data()['value'] + 1).toString();
      }

      await FirebaseFirestore.instance
          .collection('counters')
          .doc(jciId)
          .update({
        'value': int.parse(invoiceCounter.value.text), // Incrementing value
      });
    } catch (e) {
      // print("Error in getCurrentJobCardCounterNumber: $e");
    }
  }

  Future<void> getCurrentQuotationCounterNumber() async {
    try {
      var qnId = '';
      var qnDoc = await FirebaseFirestore.instance
          .collection('counters')
          .where('code', isEqualTo: 'QN')
          .where('company_id', isEqualTo: companyId.value)
          .get();

      if (qnDoc.docs.isEmpty) {
        var newCounter =
            await FirebaseFirestore.instance.collection('counters').add({
          'code': 'QN',
          'description': 'Quotation Number',
          'prefix': 'QN',
          'value': 1,
          'length': 0,
          'separator': '-',
          'added_date': DateTime.now().toString(),
          'company_id': companyId.value,
          'status': true,
        });
        qnId = newCounter.id;
        quotationCounter.value.text = "1";
      } else {
        var firstDoc = qnDoc.docs.first;
        qnId = firstDoc.id;
        var currentValue = firstDoc.data()['value'] ?? 0;
        quotationCounter.value.text = (currentValue + 1).toString();
      }

      await FirebaseFirestore.instance.collection('counters').doc(qnId).update({
        'value': int.parse(quotationCounter.value.text),
      });
    } catch (e) {
      // print("Error in getCurrentQuotationCounterNumber: $e");
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

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allJobCards.sort((counter1, counter2) {
        final String? value1 = counter1.get('code');
        final String? value2 = counter2.get('code');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allJobCards.sort((counter1, counter2) {
        final String? value1 = counter1.get('name');
        final String? value2 = counter2.get('name');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allJobCards.sort((counter1, counter2) {
        final String? value1 = counter1.get('added_date');
        final String? value2 = counter2.get('added_date');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    }
    sortColumnIndex.value = columnIndex;
    isAscending.value = ascending;
  }

  // this function is to sort data in table
  void onSortForInvoiceItems(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allJobCards.sort((counter1, counter2) {
        final String? value1 = counter1.get('code');
        final String? value2 = counter2.get('code');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allJobCards.sort((counter1, counter2) {
        final String? value1 = counter1.get('name');
        final String? value2 = counter2.get('name');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allJobCards.sort((counter1, counter2) {
        final String? value1 = counter1.get('added_date');
        final String? value2 = counter2.get('added_date');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    }
    sortColumnIndex.value = columnIndex;
    isAscending.value = ascending;
  }

  int compareString(bool ascending, String value1, String value2) {
    int comparison = value1.compareTo(value2);
    return ascending ? comparison : -comparison; // Reverse if descending
  }

  getAllJobCards() {
    try {
      FirebaseFirestore.instance
          .collection('job_cards')
          .where('company_id', isEqualTo: companyId.value)
          .snapshots()
          .listen((jobCards) {
        allJobCards.assignAll(List<DocumentSnapshot>.from(jobCards.docs));
        isScreenLoding.value = false;
      });
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  String? getSaleManName(String saleManId) {
    try {
      final salesMan = salesManMap.entries.firstWhere(
        (saleMan) => saleMan.key == saleManId,
      );
      return salesMan.value['name'];
    } catch (e) {
      return '';
    }
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
    customerSaleMan.text =
        getSaleManName(currentUserDetails.value['sales_man'])!;
  }
}
