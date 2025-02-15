import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datahubai/consts.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  RxBool canSaveJobCard = RxBool(true);
  // internal notes section
  RxBool addingNewInternalNotProcess = RxBool(false);
  RxBool jobCardAdded = RxBool(false);
  RxString curreentJobCardId = RxString('');
  RxBool canAddInternalNotesAndInvoiceItems = RxBool(false);
  final ScrollController scrollController = ScrollController();
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
  TextEditingController net = TextEditingController();

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
    getInvoiceItemsFromCollection();
    search.value.addListener(() {
      filterJobCards();
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

  void updateCalculating() {
    if (price.text.isEmpty) price.text = '0';
    if (quantity.text.isEmpty) quantity.text = '0';
    if (discount.text.isEmpty) discount.text = '0';
    if (vat.text.isEmpty) vat.text = '0';
    final currwnQquanity = int.tryParse(quantity.text) ?? 0;
    final currentPrice = double.tryParse(price.text) ?? 0.0;
    final currentDiscount = double.tryParse(discount.text) ?? 0.0;
    amount.text = (currwnQquanity * currentPrice).toString();
    total.text = (double.tryParse(amount.text)! - currentDiscount).toString();
    vat.text = ((double.tryParse(total.text)! * 5) / 100).toString();
    net.text =
        (double.tryParse(total.text)! + double.tryParse(vat.text)!).toString();
  }

  void updateAmount() {
    if (net.text.isEmpty) net.text = '0';
    if (net.text != '0') {
      total.text =
          (double.tryParse(net.text)! - double.tryParse(vat.text)!).toString();
      amount.text =
          (double.tryParse(total.text)! + double.tryParse(discount.text)!)
              .toString();
      price.text =
          (double.tryParse(amount.text)! / double.tryParse(quantity.text)!)
              .toString();
    }

    // vat.text =
    //     (double.tryParse(net.text)! - double.tryParse(total.text)!).toString();
  }

  void clearInvoiceItemsVariables() {
    invoiceItemName.clear();
    invoiceItemNameId.value = '';
    lineNumber.clear();
    description.clear();
    quantity.text = '0';
    price.text = '0';
    amount.text = '0';
    discount.text = '0';
    total.text = '0';
    vat.text = '0';
    net.text = '0';
  }

  clearValues() {
    canSaveJobCard.value = true;
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
  }

  loadValues(Map<String, dynamic> data) {
    carBrandId.value = data['car_brand'];
    carBrand.text = getdataName(data['car_brand'], allBrands)!;
    carModelId.value = data['car_model'];
    getCitiesByCountryID(data['country']);
    getModelsByCarBrand(data['car_brand']);
    getModelName(data['car_brand'], data['car_model']).then((value) {
      carModel.text = value;
    });
    plateNumber.text = data['plate_number'];
    plateCode.text = data['plate_code'];
    countryId.value = data['country'];
    country.text = getdataName(data['country'], allCountries)!;
    cityId.value = data['city'];
    getCityName(data['country'], data['city']).then((value) {
      city.text = value;
    });
    year.text = data['year'];
    colorId.value = data['color'];
    color.text = getdataName(data['color'], allColors)!;
    vin.text = data['vehicle_identification_number'];
    mileageIn.value.text = data['mileage_in'];
    mileageOut.value.text = data['mileage_out'];
    inOutDiff.value.text = data['mileage_in_out_diff'];
    customerId.value = data['customer'];
    customerName.text =
        getdataName(data['customer'], allCustomers, title: 'entity_name')!;
    customerEntityName.text = data['contact_name'];
    customerEntityPhoneNumber.text = data['contact_number'];
    customerEntityEmail.text = data['contact_email'];
    customerCreditNumber.text = data['credit_limit'];
    customerOutstanding.text = data['outstanding'];
    customerSaleManId.value = data['saleMan'];
    customerSaleMan.text = getdataName(data['saleMan'], salesManMap)!;
    customerBranchId.value = data['branch'];
    customerBranch.text = getdataName(data['branch'], allBranches)!;
    customerCurrencyId.value = data['currency'];
    customerCurrency.text = getdataName(data['currency'], allCurrencies)!;
    customerCurrencyRate.text = data['rate'];
    payType.value = data['payment_method'];
    data['payment_method'] == 'Cash'
        ? (isCashSelected.value = true) && (isCreditSelected.value = false)
        : (isCreditSelected.value = true) && (isCashSelected.value = false);
    quotationCounter.value.text = data['quotation_number'];
    quotationDate.value.text = textToDate(data['quotation_date']);
    quotationDays.value.text = data['validity_days'];
    validityEndDate.value.text = textToDate(data['validity_end_date']);
    referenceNumber.value.text = data['reference_number'];
    deliveryTime.value.text = data['delivery_time'];
    quotationWarrentyDays.value.text = data['quotation_warrenty_days'];
    quotationWarrentyKM.value.text = data['quotation_warrenty_km'];
    quotationNotes.text = data['quotation_notes'];
    jobCardCounter.value.text = data['job_number'];
    invoiceCounter.value.text = data['invoice_number'];
    lpoCounter.value.text = data['lpo_number'];
    jobCardDate.value.text = textToDate(data['job_date']);
    invoiceDate.value.text = textToDate(data['invoice_date']);
    approvalDate.value.text = textToDate(data['job_approval_date']);
    startDate.value.text = textToDate(data['job_start_date']);
    finishDate.value.text = textToDate(data['job_finish_date']);
    deliveryDate.value.text = textToDate(data['job_delivery_date']);
    jobWarrentyDays.value.text = data['job_warrenty_days'];
    jobWarrentyKM.value.text = data['job_warrenty_km'];
    jobWarrentyEndDate.value.text = textToDate(data['job_warrenty_end_date']);
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

      await getCurrentQuotationCounterNumber();
      await getCurrentJobCardCounterNumber();

      if (jobCardAdded.isFalse) {
        var newJob =
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
        jobCardAdded.value = true;
        curreentJobCardId.value = newJob.id;
      }
      canAddInternalNotesAndInvoiceItems.value = true;
      canSaveJobCard.value = false;
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
        'name': invoiceItemNameId.value,
        'line_number': lineNumber.text,
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
        'line_number': lineNumber.text,
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
      addingNewValue.value = true;
      FirebaseFirestore.instance.collection('job_cards').doc(jobId).update({
        'car_brand': carBrandId.value,
        'car_model': carModelId.value,
        'plate_number': plateNumber.text,
        'plate_code': plateCode.text,
        'country': countryId.value,
        'city': cityId.value,
        'year': year.text,
        'color': colorId.value,
        'vehicle_identification_number': vin.text,
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
        return cities.data()!['name'].toString();
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
          .snapshots()
          .listen((items) {
        allInvoiceItems.assignAll(List<DocumentSnapshot>.from(items.docs));
        loadingInvoiceItems.value = false;
      });
    } catch (e) {
      loadingInvoiceItems.value = false;
    }
  }

  String? getdataName(String id, Map allData, {title = 'name'}) {
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
        getdataName(currentUserDetails.value['sales_man'], salesManMap)!;
  }

  // this function is to filter the search results for web
  void filterJobCards() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredJobCards.clear();
    } else {
      filteredJobCards.assignAll(
        allJobCards.where((card) {
          return card['description'].toString().toLowerCase().contains(query) ||
              card['name'].toString().toLowerCase().contains(query) ||
              card['price'].toString().toLowerCase().contains(query) ||
              textToDate(card['added_date'])
                  .toString()
                  .toLowerCase()
                  .contains(query);
        }).toList(),
      );
    }
  }
}
