import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datahubai/consts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobCardController extends GetxController {
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
  Rx<TextEditingController> reference3 = TextEditingController().obs;
  Rx<TextEditingController> minTestKms = TextEditingController().obs;
  Rx<TextEditingController> invoiceCounter = TextEditingController().obs;
  Rx<TextEditingController> lpoCounter = TextEditingController().obs;
  Rx<TextEditingController> quotationCounter = TextEditingController().obs;
  Rx<TextEditingController> quotationDate = TextEditingController().obs;
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
  RxString query = RxString('');
  RxString queryForInvoiceItems = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  Rx<TextEditingController> searchForInvoiceItems = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(true);
  RxBool loadingInvoiceItems = RxBool(false);
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
  RxMap allCities = RxMap({});
  RxMap allColors = RxMap({});
  RxMap allEngineType = RxMap({});
  RxMap allBranches = RxMap({});
  RxMap allCurrencies = RxMap({});
  RxMap allInvoiceItemsFromCollection = RxMap({});

  RxMap allBrands = RxMap({});
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
  RxString jobStatus1 = RxString('');
  RxString jobStatus2 = RxString('');
  RxString quotationStatus = RxString('');
  RxBool postingJob = RxBool(false);
  // internal notes section
  RxBool addingNewInternalNotProcess = RxBool(false);
  RxBool jobCardAdded = RxBool(false);
  RxString curreentJobCardId = RxString('');
  RxBool canAddInternalNotesAndInvoiceItems = RxBool(false);
  final ScrollController scrollController = ScrollController();
  final ScrollController scrollControllerFotTable = ScrollController();
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
  @override
  void onInit() async {
    super.onInit();
    jobWarrentyEndDate.value.addListener(() {
      // Refresh the Rx to notify GetX that something changed
      jobWarrentyEndDate.refresh();
    });
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
    getAllJobCards();
    getInvoiceItemsFromCollection();
    search.value.addListener(() {
      filterJobCards();
    });
    searchForInvoiceItems.value.addListener(() {
      filterInvoiceItems();
    });
  }

  @override
  void onClose() {
    textFieldFocusNode.dispose();
    super.onClose();
  }

  void openImageViewer(List imageUrls, int index) {
    Get.toNamed('/imageViewer',
        arguments: {'images': imageUrls, 'index': index});
  }

  // Stream<Map<String, double>> calculateGrandSums() {
  //   return FirebaseFirestore.instance
  //       .collectionGroup('invoice_items')
  //       .where('company_id', isEqualTo: companyId.value)
  //       .snapshots()
  //       .map((invoiceItemsSnapshot) {
  //     double grandTotal = 0.0;
  //     double grandVAT = 0.0;
  //     double grandNET = 0.0;

  //     for (var job in invoiceItemsSnapshot.docs) {
  //       var data = job.data() as Map<String, dynamic>?;

  //       grandTotal += double.tryParse(data?['total']?.toString() ?? '0') ?? 0;
  //       grandVAT += double.tryParse(data?['vat']?.toString() ?? '0') ?? 0;
  //       grandNET += double.tryParse(data?['net']?.toString() ?? '0') ?? 0;
  //     }

  //     return {
  //       'total': grandTotal,
  //       'vat': grandVAT,
  //       'net': grandNET,
  //     };
  //   });
  // }

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

  clearValues() {
    jobCancelationDate.value.text = '';
    jobStatus1.value = '';
    jobStatus2.value = '';
    quotationStatus.value = '';
    carBrandLogo.value = '';
    isQuotationExpanded.value = false;
    allModels.clear();
    jobCardCounter.value.clear();
    quotationCounter.value.clear();
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
  }

  loadValues(Map<String, dynamic> data) {
    jobCancelationDate.value.text = textToDate(data['job_cancelation_date']);
    jobStatus1.value = data['job_status_1'];
    jobStatus2.value = data['job_status_2'];
    quotationStatus.value = data['quotation_status'];
    carBrandLogo.value = data['car_brand_logo'];
    carBrandId.value = data['car_brand'];
    carBrand.text = getdataName(data['car_brand'], allBrands);
    carModelId.value = data['car_model'];
    getCitiesByCountryID(data['country']);
    getModelsByCarBrand(data['car_brand']);
    getModelName(data['car_brand'], data['car_model']).then((value) {
      carModel.text = value;
    });
    plateNumber.text = data['plate_number'];
    plateCode.text = data['plate_code'];
    countryId.value = data['country'];
    country.text = getdataName(data['country'], allCountries);
    cityId.value = data['city'];
    getCityName(data['country'], data['city']).then((value) {
      city.text = value;
    });
    year.text = data['year'];
    colorId.value = data['color'];
    engineTypeId.value = data['engine_type'];
    color.text = getdataName(data['color'], allColors);
    engineType.text = getdataName(data['engine_type'], allEngineType);
    vin.text = data['vehicle_identification_number'];
    transmissionType.text = data['transmission_type'];
    mileageIn.value.text = data['mileage_in'];
    mileageOut.value.text = data['mileage_out'];
    inOutDiff.value.text = data['mileage_in_out_diff'];
    customerId.value = data['customer'];
    customerName.text =
        getdataName(data['customer'], allCustomers, title: 'entity_name');
    customerEntityName.text = data['contact_name'];
    customerEntityPhoneNumber.text = data['contact_number'];
    customerEntityEmail.text = data['contact_email'];
    customerCreditNumber.text = data['credit_limit'];
    customerOutstanding.text = data['outstanding'];
    customerSaleManId.value = data['saleMan'];
    customerSaleMan.text = getdataName(data['saleMan'], salesManMap);
    customerBranchId.value = data['branch'];
    customerBranch.text = getdataName(data['branch'], allBranches);
    customerCurrencyId.value = data['currency'];
    customerCurrency.text = data['currency'] != ''
        ? getdataName(
            getdataName(data['currency'], allCurrencies, title: 'country_id'),
            allCountries,
            title: 'currency_code')
        : '';
    customerCurrencyRate.text = data['rate'];
    payType.value = data['payment_method'];
    data['payment_method'] == 'Cash'
        ? (isCashSelected.value = true) && (isCreditSelected.value = false)
        : (isCreditSelected.value = true) && (isCashSelected.value = false);
    quotationCounter.value.text = data['quotation_number'];
    quotationCounter.value.text.isNotEmpty
        ? isQuotationExpanded.value = true
        : isQuotationExpanded.value = false;
    quotationDate.value.text = data['quotation_date'];
    quotationDays.value.text = data['validity_days'];
    validityEndDate.value.text = data['validity_end_date'];
    referenceNumber.value.text = data['reference_number'];
    deliveryTime.value.text = data['delivery_time'];
    quotationWarrentyDays.value.text = data['quotation_warrenty_days'];
    quotationWarrentyKM.value.text = data['quotation_warrenty_km'];
    quotationNotes.text = data['quotation_notes'];
    jobCardCounter.value.text = data['job_number'];
    jobCardCounter.value.text.isNotEmpty
        ? isJobCardExpanded.value = true
        : isJobCardExpanded.value = false;
    invoiceCounter.value.text = data['invoice_number'];
    lpoCounter.value.text = data['lpo_number'];
    jobCardDate.value.text = data['job_date'];
    invoiceDate.value.text = data['invoice_date'];
    approvalDate.value.text = textToDate(data['job_approval_date']);
    startDate.value.text = data['job_start_date'];
    finishDate.value.text = data['job_finish_date'];
    deliveryDate.value.text = data['job_delivery_date'];
    jobWarrentyDays.value.text = data['job_warrenty_days'];
    jobWarrentyKM.value.text = data['job_warrenty_km'];
    jobWarrentyEndDate.value.text = data['job_warrenty_end_date'];
    minTestKms.value.text = data['job_min_test_km'];
    reference1.value.text = data['job_reference_1'];
    reference2.value.text = data['job_reference_2'];
    reference3.value.text = data['job_reference_3'];
    jobNotes.text = data['job_notes'];
    deliveryNotes.text = data['job_delivery_notes'];
  }

  Future<void> addNewJobCardAndQuotation() async {
    try {
      addingNewValue.value = true;
      Map<String, dynamic> newData = {
        'job_status_1': jobStatus1.value,
        'job_status_2': jobStatus2.value,
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
        'job_number': jobCardCounter.value.text,
        'invoice_number': invoiceCounter.value.text,
        'lpo_number': lpoCounter.value.text,
        'job_date': jobCardDate.value.text,
        'invoice_date': invoiceDate.value.text,
        'job_approval_date': approvalDate.value.text,
        'job_start_date': startDate.value.text,
        'job_cancelation_date': jobCancelationDate.value.text,
        'job_finish_date': finishDate.value.text,
        'job_delivery_date': deliveryDate.value.text,
        'job_warrenty_days': jobWarrentyDays.value.text,
        'job_warrenty_km': jobWarrentyKM.value.text,
        'job_warrenty_end_date': jobWarrentyEndDate.value.text,
        'job_min_test_km': minTestKms.value.text,
        'job_reference_1': reference1.value.text,
        'job_reference_2': reference2.value.text,
        'job_reference_3': reference3.value.text,
        'job_notes': jobNotes.text,
        'job_delivery_notes': deliveryNotes.text,
      };

      if (isQuotationExpanded.isTrue && quotationCounter.value.text.isEmpty) {
        quotationStatus.value = 'New';
        newData['quotation_status'] = 'New';

        await getCurrentQuotationCounterNumber();
        newData['quotation_number'] = quotationCounter.value.text;
      }
      if (isJobCardExpanded.isTrue && jobCardCounter.value.text.isEmpty) {
        jobStatus1.value = 'New';
        jobStatus2.value = 'New';

        newData['job_status_1'] = 'New';
        newData['job_status_2'] = 'New';
        await getCurrentJobCardCounterNumber();
        newData['job_number'] = jobCardCounter.value.text;
      }

      if (jobCardAdded.isFalse) {
        var newJob = await FirebaseFirestore.instance
            .collection('job_cards')
            .add(newData);
        jobCardAdded.value = true;
        curreentJobCardId.value = newJob.id;
      } else {
        await FirebaseFirestore.instance
            .collection('job_cards')
            .doc(curreentJobCardId.value)
            .update(newData);
      }
      canAddInternalNotesAndInvoiceItems.value = true;
      addingNewValue.value = false;
    } catch (e) {
      canAddInternalNotesAndInvoiceItems.value = false;
      addingNewValue.value = false;
    }
  }

  Future<void> addNewInternalNote(
      String jobcardID, Map<String, dynamic> note) async {
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
        final timestamp = DateTime.now()
            .toIso8601String()
            .replaceAll(RegExp(r'[^0-9T-]'), '_');
        final storageFileName = extension.isNotEmpty
            ? '${fileName}_$timestamp.$extension'
            : '${fileName}_$timestamp';

        // Create storage reference
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('internal_notes/$storageFileName');

        // Determine MIME type
        final mimeType =
            note['type'] as String? ?? _getMimeTypeFromExtension(extension);

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

// Helper to get MIME type from file extension
  String? _getMimeTypeFromExtension(String extension) {
    const mimeTypes = {
      'pdf': 'application/pdf',
      'doc': 'application/msword',
      'docx':
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'xls': 'application/vnd.ms-excel',
      'xlsx':
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'ppt': 'application/vnd.ms-powerpoint',
      'pptx':
          'application/vnd.openxmlformats-officedocument.presentationml.presentation',
      'txt': 'text/plain',
    };
    return mimeTypes[extension.toLowerCase()];
  }

  addNewInvoiceItem(String jobId) async {
    try {
      addingNewinvoiceItemsValue.value = true;
      await FirebaseFirestore.instance
          .collection('job_cards')
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

  editInvoiceItem(String jobId, String itemId) async {
    try {
      Get.back();
      await FirebaseFirestore.instance
          .collection('job_cards')
          .doc(jobId)
          .collection('invoice_items')
          .doc(itemId)
          .update({
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
      });
    } catch (e) {
      //
    }
  }

  void editJobCardAndQuotation(jobId) {
    try {
      FirebaseFirestore.instance.collection('job_cards').doc(jobId).update({
        'job_status_1': jobStatus1.value,
        'job_status_2': jobStatus2.value,
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
        'job_number': jobCardCounter.value.text,
        'invoice_number': invoiceCounter.value.text,
        'lpo_number': lpoCounter.value.text,
        'job_date': jobCardDate.value.text,
        'invoice_date': invoiceDate.value.text,
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
        'job_reference_3': reference3.value.text,
        'job_notes': jobNotes.text,
        'job_delivery_notes': deliveryNotes.text,
      });
      addingNewValue.value = false;
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  editApproveForJobCard(jobId, status) async {
    try {
      await FirebaseFirestore.instance
          .collection('job_cards')
          .doc(jobId)
          .update({
        'job_status_2': status,
        'job_approval_date': DateTime.now().toString()
      });
    } catch (e) {
      //
    }
  }

  editReadyForJobCard(jobId, status) async {
    try {
      await FirebaseFirestore.instance
          .collection('job_cards')
          .doc(jobId)
          .update({
        'job_status_2': status,
        'job_finish_date': DateTime.now().toString()
      });
    } catch (e) {
      //
    }
  }

  editNewForJobCard(jobId, status) async {
    try {
      await FirebaseFirestore.instance
          .collection('job_cards')
          .doc(jobId)
          .update({
        'job_status_2': status,
        'job_status_1': status,
        'job_finish_date': '',
        'job_approval_date': ''
      });
      finishDate.value.text = '';
      approvalDate.value.text = '';
      jobStatus2.value = 'New';
      jobStatus1.value = 'New';
    } catch (e) {
      //
    }
  }

  editCancelForJobCard(jobId, status) async {
    try {
      await FirebaseFirestore.instance
          .collection('job_cards')
          .doc(jobId)
          .update({
        'job_status_1': status,
        'job_status_2': status,
        'job_cancelation_date': DateTime.now().toString()
      });
      jobCancelationDate.value.text = textToDate(DateTime.now());
      jobStatus1.value = status;
      jobStatus2.value = status;
    } catch (e) {
      //
    }
  }

  editPostForJobCard(jobId) async {
    try {
      var status2 = '';
      postingJob.value = true;
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
    } catch (e) {
      postingJob.value = false;
    }
  }

  editPostForQuotation(jobId) async {
    try {
      await FirebaseFirestore.instance
          .collection('job_cards')
          .doc(jobId)
          .update({'quotation_status': 'Posted'});
      quotationStatus.value = 'Posted';
    } catch (e) {
      //
    }
  }

  editCancelForQuotation(jobId) async {
    try {
      await FirebaseFirestore.instance
          .collection('job_cards')
          .doc(jobId)
          .update({'quotation_status': 'Canceled'});
      quotationStatus.value = 'Cancelled';
    } catch (e) {
      //
    }
  }

// this function is to see if the warrant date is end or not
  bool isBeforeToday(String dateStr) {
    DateFormat format = DateFormat("dd-MM-yyyy");

    DateTime inputDate = format.parse(dateStr);

    DateTime today = DateTime.now();
    DateTime todayOnly = DateTime(today.year, today.month, today.day);

    return inputDate.isBefore(todayOnly);
  }

  deleteInvoiceItem(String jobId, String itemId) {
    try {
      Get.back();
      FirebaseFirestore.instance
          .collection('job_cards')
          .doc(jobId)
          .collection('invoice_items')
          .doc(itemId)
          .delete();
    } catch (e) {
      //
    }
  }

  deleteJobCard(jobId) async {
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

  getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId.value = prefs.getString('userId')!;
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

  getInvoiceItemsFromCollection() {
    FirebaseFirestore.instance
        .collection('invoice_items')
        .snapshots()
        .listen((items) {
      allInvoiceItemsFromCollection.value = {
        for (var doc in items.docs) doc.id: doc.data()
      };
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

// this function is to get industries
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

        var newCounter =
            await FirebaseFirestore.instance.collection('counters').add({
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

      await FirebaseFirestore.instance
          .collection('counters')
          .doc(jcnId)
          .update({
        'value': int.parse(updateJobCard),
      });
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

        var newCounter =
            await FirebaseFirestore.instance.collection('counters').add({
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

      await FirebaseFirestore.instance
          .collection('counters')
          .doc(jciId)
          .update({
        'value': int.parse(updateInvoice), // Increment the value
      });
    } catch (e) {
      // Optionally handle the error here
      // print("Error in getCurrentInvoiceCounterNumber: $e");
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
          return {
            'id': doc.id,
            ...doc.data(),
          };
        }).toList();
      } else {
        return [];
      }
    });
  }

  getAllInvoiceItems(jobId) {
    try {
      loadingInvoiceItems.value = true;
      FirebaseFirestore.instance
          .collection('job_cards')
          .doc(jobId)
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
        getdataName(currentUserDetails.value['sales_man'], salesManMap);
  }

  void filterInvoiceItems() async {
    final searchQuery = searchForInvoiceItems.value.text.toLowerCase();
    queryForInvoiceItems.value = searchQuery;
    if (searchQuery.isEmpty) {
      filteredInvoiceItems.clear();
    } else {
      filteredInvoiceItems.assignAll(
        allInvoiceItems.where((item) {
          return item['line_number']
                  .toString()
                  .toLowerCase()
                  .contains(queryForInvoiceItems) ||
              item['description']
                  .toString()
                  .toLowerCase()
                  .contains(queryForInvoiceItems) ||
              item['discount']
                  .toString()
                  .toLowerCase()
                  .contains(queryForInvoiceItems) ||
              item['net']
                  .toString()
                  .toLowerCase()
                  .contains(queryForInvoiceItems) ||
              item['price']
                  .toString()
                  .toLowerCase()
                  .contains(queryForInvoiceItems) ||
              item['quantity']
                  .toString()
                  .toLowerCase()
                  .contains(queryForInvoiceItems) ||
              item['total']
                  .toString()
                  .toLowerCase()
                  .contains(queryForInvoiceItems) ||
              item['vat']
                  .toString()
                  .toLowerCase()
                  .contains(queryForInvoiceItems) ||
              getdataName(item['name'], allCustomers, title: 'entity_name')
                  .toLowerCase()
                  .contains(queryForInvoiceItems);
        }).toList(),
      );
    }
  }

  void filterJobCards() async {
    final searchQuery = search.value.text.toLowerCase();
    query.value = searchQuery;

    if (searchQuery.isEmpty) {
      filteredJobCards.clear();
      return;
    }

    // Map each card to a Future that returns the card if it matches, else null.
    List<Future<DocumentSnapshot<Object?>?>> futures =
        allJobCards.map((card) async {
      final data = card.data() as Map<String, dynamic>;

      // Run asynchronous operations concurrently.
      final results = await Future.wait([
        getModelName(data['car_brand'], data['car_model']),
        getCityName(data['country'], data['city']),
      ]);
      final modelName = results[0];
      final cityName = results[1];

      final brandName = getdataName(data['car_brand'], allBrands).toLowerCase();
      final customerName =
          getdataName(data['customer'], allCustomers, title: 'entity_name')
              .toLowerCase();

      // Check if any field contains the search query.
      bool matches = data['quotation_number']
              .toString()
              .toLowerCase()
              .contains(searchQuery) ||
          data['quotation_date']
              .toString()
              .toLowerCase()
              .contains(searchQuery) ||
          data['job_number'].toString().toLowerCase().contains(searchQuery) ||
          data['job_date'].toString().toLowerCase().contains(searchQuery) ||
          data['invoice_number']
              .toString()
              .toLowerCase()
              .contains(searchQuery) ||
          data['invoice_date'].toString().toLowerCase().contains(searchQuery) ||
          data['lpo_number'].toString().toLowerCase().contains(searchQuery) ||
          brandName.contains(searchQuery) ||
          modelName.toLowerCase().contains(searchQuery) ||
          data['plate_number'].toString().toLowerCase().contains(searchQuery) ||
          data['plate_code'].toString().toLowerCase().contains(searchQuery) ||
          cityName.toLowerCase().contains(searchQuery) ||
          customerName.contains(searchQuery) ||
          data['vehicle_identification_number']
              .toString()
              .toLowerCase()
              .contains(query.value);

      // Return the card if it matches, otherwise return null.
      return matches ? card : null;
    }).toList();

    // Await all asynchronous operations concurrently.
    final resultsList = await Future.wait(futures);

    // Filter out null values.
    final filtered = resultsList
        .where((card) => card != null)
        .cast<DocumentSnapshot<Object?>>();
    filteredJobCards.assignAll(filtered.toList());
  }
}
