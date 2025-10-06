import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datahubai/Controllers/Main%20screen%20controllers/job_card_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Screens/Main screens/System Administrator/Setup/job_card.dart';
import '../../consts.dart';
import 'main_screen_contro.dart';

class QuotationCardController extends GetxController {
  Rx<TextEditingController> quotationCounter = TextEditingController().obs;
  RxString jobCardCounter = RxString('');
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
  // TextEditingController customerSaleMan = TextEditingController();
  RxString customerSaleMan = RxString('');
  TextEditingController customerBranch = TextEditingController();
  TextEditingController customerCurrency = TextEditingController();
  TextEditingController customerCurrencyRate = TextEditingController();
  Rx<TextEditingController> mileageIn = TextEditingController().obs;
  Rx<TextEditingController> fuelAmount = TextEditingController().obs;
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(false);
  RxBool loadingInvoiceItems = RxBool(false);
  final RxList<QueryDocumentSnapshot<Map<String, dynamic>>> allQuotationCards =
      RxList<QueryDocumentSnapshot<Map<String, dynamic>>>([]);
  final RxList<QueryDocumentSnapshot<Map<String, dynamic>>>
  filteredQuotationCards = RxList<QueryDocumentSnapshot<Map<String, dynamic>>>(
    [],
  );
  final RxList<QueryDocumentSnapshot<Map<String, dynamic>>> allInvoiceItems =
      RxList<QueryDocumentSnapshot<Map<String, dynamic>>>([]);
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
  RxMap allYears = RxMap({});
  final RxMap<String, Map<String, dynamic>> allModels =
      <String, Map<String, dynamic>>{}.obs;
  RxMap allCustomers = RxMap({});
  RxMap salesManMap = RxMap({});
  RxBool addingNewValue = RxBool(false);
  RxBool creatingNewJob = RxBool(false);
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
  RxBool loadingCopyQuotation = RxBool(false);
  RxBool loadingMakeJob = RxBool(false);
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
  RxBool postingQuotation = RxBool(false);
  RxBool cancelingQuotation = RxBool(false);
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

  @override
  void onInit() async {
    super.onInit();
    // jobWarrentyEndDate.value.addListener(() {
    //   // Refresh the Rx to notify GetX that something changed
    //   jobWarrentyEndDate.refresh();
    // });
    getColors();
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
    getEngineTypes();
    getYears();
    getInvoiceItemsFromCollection();
  }

  // this function is to get years
  Future<void> getYears() async {
    var typeDoc = await FirebaseFirestore.instance
        .collection('all_lists')
        .where('code', isEqualTo: 'YEARS')
        .get();

    var typeId = typeDoc.docs.first.id;
    FirebaseFirestore.instance
        .collection('all_lists')
        .doc(typeId)
        .collection('values')
        .where('available', isEqualTo: true)
        .orderBy('name', descending: true)
        .snapshots()
        .listen((year) {
          allYears.value = {for (var doc in year.docs) doc.id: doc.data()};
        });
  }

  // calculateMoneyForAllQuotations() async {
  //   try {
  //     allQuotationsVATS.value = 0.0;
  //     allQuotationsTotals.value = 0.0;
  //     allQuotationsNET.value = 0.0;

  //     for (var quot in filteredQuotationCards.isEmpty
  //         ? allQuotationCards
  //         : filteredQuotationCards) {
  //       final id = quot.id;

  //       FirebaseFirestore.instance
  //           .collection('quotation_cards')
  //           .doc(id)
  //           .collection('invoice_items')
  //           .snapshots()
  //           .listen((invoices) {
  //         for (var invoice in invoices.docs) {
  //           var data = invoice.data() as Map<String, dynamic>?;
  //           allQuotationsVATS.value += double.parse(data?['vat']);
  //           allQuotationsTotals.value += double.parse(data?['total']);
  //           allQuotationsNET.value += double.parse(data?['net']);
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     // print(e);
  //   }
  // }

  Future<void> calculateMoneyForAllQuotations() async {
    try {
      // Reset totals at the beginning.
      double totalVat = 0.0;
      double grandTotal = 0.0;
      double totalNet = 0.0;

      if (allQuotationCards.isEmpty) {
        allQuotationsVATS.value = 0;
        allQuotationsTotals.value = 0;
        allQuotationsNET.value = 0;
        return;
      }

      // 1. Create a list of Futures for fetching the 'invoice_items' for each quotation.
      List<Future<QuerySnapshot<Map<String, dynamic>>>> futures = [];
      for (var quotation in allQuotationCards) {
        final future = FirebaseFirestore.instance
            .collection('quotation_cards')
            .doc(quotation.id)
            .collection(
              'quotation_invoice_items',
            ) // Assuming the subcollection is named this
            .get();
        futures.add(future);
      }

      // 2. Execute all the Futures in parallel.
      final List<QuerySnapshot<Map<String, dynamic>>> snapshots =
          await Future.wait(futures);

      // 3. Iterate through the results in memory to perform calculations.
      for (var invoiceListSnapshot in snapshots) {
        for (var invoiceDoc in invoiceListSnapshot.docs) {
          var data = invoiceDoc.data();
          totalVat += double.tryParse(data['vat'].toString()) ?? 0.0;
          grandTotal += double.tryParse(data['total'].toString()) ?? 0.0;
          totalNet += double.tryParse(data['net'].toString()) ?? 0.0;
        }
      }

      // 4. Update the UI with the final calculated totals.
      allQuotationsVATS.value = totalVat;
      allQuotationsTotals.value = grandTotal;
      allQuotationsNET.value = totalNet;
    } catch (e) {
      allQuotationsVATS.value = 0;
      allQuotationsTotals.value = 0;
      allQuotationsNET.value = 0;
    }
  }

  // Future<void> calculateMoneyForAllQuotations() async {
  //   try {
  //     double totalVat = 0.0;
  //     double grandTotal = 0.0;
  //     double totalNet = 0.0;

  //     final snapshot = await FirebaseFirestore.instance
  //         .collectionGroup('quotation_invoice_items')
  //         .get();

  //     for (var doc in snapshot.docs) {
  //       final data = doc.data();
  //       print(data);
  //       totalVat += double.tryParse(data['vat'].toString()) ?? 0.0;
  //       grandTotal += double.tryParse(data['total'].toString()) ?? 0.0;
  //       totalNet += double.tryParse(data['net'].toString()) ?? 0.0;
  //     }

  //     allQuotationsVATS.value = totalVat;
  //     allQuotationsTotals.value = grandTotal;
  //     allQuotationsNET.value = totalNet;
  //   } catch (e) {
  //     allQuotationsVATS.value = 0;
  //     allQuotationsTotals.value = 0;
  //     allQuotationsNET.value = 0;
  //   }
  // }

  Future<void> openJobCardScreenByNumber() async {
    // try {
    //   openingJobCardScreen.value = true;
    //   var job = await FirebaseFirestore.instance
    //       .collection('job_cards')
    //       .where('job_number', isEqualTo: jobCardCounter.value)
    //       .get();
    //   var id = job.docs.first.id;
    //   var data = job.docs.first.data();

    //   JobCardController jobCardController = Get.put(JobCardController());
    //   jobCardController.getAllInvoiceItems(id);
    //   // await jobCardController.loadValues(data); // need to br changed
    //   editJobCardDialog(
    //     jobCardController,
    //     data,
    //     id,
    //     screenName: '💳 Job Card',
    //     headerColor: Colors.deepPurple,
    //   );
    //   openingJobCardScreen.value = false;
    //   showSnackBar('Done', 'Opened Successfully');
    // } catch (e) {
    //   openingJobCardScreen.value = false;
    //   showSnackBar('Alert', 'Something Went Wrong');
    // }
  }

  void clearValues() {
    jobCardCounter.value = '';
    allInvoiceItems.clear();
    canAddInternalNotesAndInvoiceItems.value = false;
    quotationStatus.value = '';
    carBrandLogo.value = '';
    allModels.clear();
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
    customerSaleMan.value = '';
    customerBranchId.value = '';
    customerBranch.clear();
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

  Future<void> loadValues(Map<String, dynamic> data, String id) async {
    var job = await FirebaseFirestore.instance
        .collection('job_cards')
        .where('quotation_id', isEqualTo: id)
        .get();
    if (job.docs.isNotEmpty) {
      jobCardCounter.value = job.docs.first.data()['job_number'];
    } else {
      jobCardCounter.value = '';
    }
    // jobCardCounter.value.text = data['job_number'] ?? '';
    canAddInternalNotesAndInvoiceItems.value = true;
    quotationStatus.value = data['quotation_status'] as String? ?? '';
    carBrandLogo.value = data['car_brand_logo'] as String? ?? '';
    carBrandId.value = data['car_brand'] as String? ?? '';

    color.text = getdataName(data['color'], allColors);
    colorId.value = data['color'];

    // Car brand & model (with async model name lookup)
    final brandId = data['car_brand'] as String? ?? '';
    carBrand.text = getdataName(brandId, allBrands);
    carBrandId.value = brandId;

    final modelId = data['car_model'] as String? ?? '';
    carModelId.value = modelId;
    carModel.text = await getModelName(brandId, modelId);

    // Country & city
    final countryIdVal = data['country'] as String? ?? '';
    countryId.value = countryIdVal;
    country.text = getdataName(countryIdVal, allCountries);

    // If you need these lists populated before setting city name:
    getCitiesByCountryID(countryIdVal);
    getModelsByCarBrand(brandId);

    final cityIdVal = data['city'] as String? ?? '';
    cityId.value = cityIdVal;
    city.text = await getCityName(countryIdVal, cityIdVal);

    // Plate, year, code, VIN, transmission
    plateNumber.text = data['plate_number'] as String? ?? '';
    plateCode.text = data['plate_code'] as String? ?? '';
    year.text = data['year'] as String? ?? '';
    vin.text = data['vehicle_identification_number'] as String? ?? '';
    transmissionType.text = data['transmission_type'] as String? ?? '';

    // Mileage & fuel amounts
    mileageIn.value.text = data['mileage_in'] as String? ?? '';
    fuelAmount.value.text = data['fuel_amount'] as String? ?? '';

    // Customer info
    final custId = data['customer'] as String? ?? '';
    customerId.value = custId;
    customerName.text = getdataName(custId, allCustomers, title: 'entity_name');
    customerEntityName.text = data['contact_name'] as String? ?? '';
    customerEntityPhoneNumber.text = data['contact_number'] as String? ?? '';
    customerEntityEmail.text = data['contact_email'] as String? ?? '';
    customerCreditNumber.text = data['credit_limit'] as String? ?? '';
    customerOutstanding.text = data['outstanding'] as String? ?? '';

    // Salesman & branch
    final saleManId = data['saleMan'] as String? ?? '';
    customerSaleManId.value = saleManId;
    customerSaleMan.value = getdataName(saleManId, salesManMap);

    final branchId = data['branch'] as String? ?? '';
    customerBranchId.value = branchId;
    customerBranch.text = getdataName(branchId, allBranches);

    // Currency & rate
    final currencyId = data['currency'] as String? ?? '';
    customerCurrencyId.value = currencyId;
    if (currencyId.isNotEmpty) {
      final countryForCurr = getdataName(
        currencyId,
        allCurrencies,
        title: 'country_id',
      );
      customerCurrency.text = getdataName(
        countryForCurr,
        allCountries,
        title: 'currency_code',
      );
    } else {
      customerCurrency.text = '';
    }
    customerCurrencyRate.text = data['rate'] as String? ?? '';

    // Payment method
    final payMethod = data['payment_method'] as String? ?? '';
    payType.value = payMethod;
    isCashSelected.value = payMethod == 'Cash';
    isCreditSelected.value = !isCashSelected.value;

    // Quotation metadata
    quotationCounter.value.text = data['quotation_number'] as String? ?? '';
    quotationDate.value.text =
        textToDate(data['quotation_date']) as String? ?? '';
    quotationDays.value.text = data['validity_days'] as String? ?? '';
    validityEndDate.value.text = data['validity_end_date'] as String? ?? '';
    referenceNumber.value.text = data['reference_number'] as String? ?? '';
    deliveryTime.value.text = data['delivery_time'] as String? ?? '';
    quotationWarrentyDays.value.text =
        data['quotation_warrenty_days'] as String? ?? '';
    quotationWarrentyKM.value.text =
        data['quotation_warrenty_km'] as String? ?? '';
    quotationNotes.text = data['quotation_notes'] as String? ?? '';
  }

  Future<void> addNewInternalNote(String id, Map<String, dynamic> note) async {
    try {
      addingNewInternalNotProcess.value = true;
      final jobDoc = FirebaseFirestore.instance
          .collection('quotation_cards')
          .doc(id)
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

  Stream<List<Map<String, dynamic>>> getQuotationCardInternalNotes(String id) {
    return FirebaseFirestore.instance
        .collection('quotation_cards')
        .doc(id)
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

  Future<void> addNewQuotationCard() async {
    try {
      if (quotationStatus.value != 'New' && quotationStatus.value != '') {
        showSnackBar('Alert', 'Only new quotations can be edited');
        return;
      }
      addingNewValue.value = true;
      Map<String, dynamic> newData = {
        'job_number': '',
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
        // 'quotation_date': Timestamp.fromDate(
        //   format.parse(quotationDate.value.text.trim()),
        // ),
        'validity_days': quotationDays.value.text,
        'validity_end_date': validityEndDate.value.text,
        'reference_number': referenceNumber.value.text,
        'delivery_time': deliveryTime.value.text,
        'quotation_warrenty_days': quotationWarrentyDays.value.text,
        'quotation_warrenty_km': quotationWarrentyKM.value.text,
        'quotation_notes': quotationNotes.text,
      };

      final rawDate = quotationDate.value.text.trim();
      if (rawDate.isNotEmpty) {
        try {
          newData['quotation_date'] = Timestamp.fromDate(
            format.parseStrict(rawDate),
          );
        } catch (e) {
          // إذا حابب تعرض للمستخدم خطأ في التنسيق
          // print('Invalid quotation_date format: $e');
        }
      }

      if (quotationCounter.value.text.isEmpty) {
        quotationStatus.value = 'New';
        newData['quotation_status'] = 'New';
        newData['label'] = '';

        await getCurrentQuotationCounterNumber();
        newData['quotation_number'] = quotationCounter.value.text;
      }

      if (quotationCardAdded.isFalse) {
        newData['added_date'] = DateTime.now().toString();
        var newQuotation = await FirebaseFirestore.instance
            .collection('quotation_cards')
            .add(newData);
        quotationCardAdded.value = true;
        curreentQuotationCardId.value = newQuotation.id;
        getAllInvoiceItems(newQuotation.id);
        showSnackBar('Done', 'Added Successfully');
      } else {
        newData.remove('added_date');
        await FirebaseFirestore.instance
            .collection('quotation_cards')
            .doc(curreentQuotationCardId.value)
            .update(newData);
        showSnackBar('Done', 'Updated Successfully');
      }
      canAddInternalNotesAndInvoiceItems.value = true;
      addingNewValue.value = false;
    } catch (e) {
      canAddInternalNotesAndInvoiceItems.value = false;
      addingNewValue.value = false;
      showSnackBar('Alert', 'Something Went Wrong');
    }
  }

  void editQuotationCard(String id) {
    try {
      // منع التعديل إذا الحالة Posted أو Cancelled
      if (quotationStatus.value == 'Posted' ||
          quotationStatus.value == 'Cancelled') {
        showSnackBar('Alert', 'Can\'t Edit For Posted / Cancelled Quotations');
        return;
      }

      addingNewValue.value = true;

      // بناء خريطة التحديث بدون quotation_date مبدئيًا
      Map<String, dynamic> updatedData = {
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
        'fuel_amount': fuelAmount.value.text,
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
        // 'quotation_date' نضيفه لاحقًا بشرط عدم كونه فارغ
        'validity_days': quotationDays.value.text,
        'validity_end_date': validityEndDate.value.text,
        'reference_number': referenceNumber.value.text,
        'delivery_time': deliveryTime.value.text,
        'quotation_warrenty_days': quotationWarrentyDays.value.text,
        'quotation_warrenty_km': quotationWarrentyKM.value.text,
        'quotation_notes': quotationNotes.text,
      };

      // تحويل التاريخ إلى Timestamp إذا حقل التاريخ غير فارغ
      final rawDate = quotationDate.value.text.trim();
      if (rawDate.isNotEmpty) {
        try {
          updatedData['quotation_date'] = Timestamp.fromDate(
            format.parseStrict(rawDate),
          );
        } catch (e) {
          // اختياري: تقدر تعرض تنبيه إذا التنسيق خاطئ
          // print('Invalid quotation_date format: $e');
        }
      }

      // تنفيذ التحديث في Firestore
      FirebaseFirestore.instance
          .collection('quotation_cards')
          .doc(id)
          .update(updatedData)
          .then((_) {
            addingNewValue.value = false;
            showSnackBar('Done', 'Updated Successfully');
          })
          .catchError((e) {
            addingNewValue.value = false;
            showSnackBar('Alert', 'Something Went Wrong');
            // print('Error updating quotation_card $id: $e');
          });
    } catch (e) {
      addingNewValue.value = false;
      showSnackBar('Alert', 'Something Went Wrong');
      // print('Unexpected error in editQuotationCard: $e');
    }
  }

  Future<void> deleteQuotationCard(String id) async {
    try {
      Get.back();
      Get.back();
      await FirebaseFirestore.instance
          .collection('quotation_cards')
          .doc(id)
          .delete();
      showSnackBar('Done', 'Deleted Successfully');
    } catch (e) {
      showSnackBar('Alert', 'Something Went Wrong');
    }
  }

  Future<void> editPostForQuotation(String id) async {
    try {
      postingQuotation.value = true;
      await FirebaseFirestore.instance
          .collection('quotation_cards')
          .doc(id)
          .update({'quotation_status': 'Posted'});
      quotationStatus.value = 'Posted';
      postingQuotation.value = false;
      showSnackBar('Done', 'Quotation Posted');
    } catch (e) {
      postingQuotation.value = false;
    }
  }

  Future<void> editCancelForQuotation(String id) async {
    try {
      cancelingQuotation.value = true;
      await FirebaseFirestore.instance
          .collection('quotation_cards')
          .doc(id)
          .update({'quotation_status': 'Cancelled'});
      quotationStatus.value = 'Cancelled';
      cancelingQuotation.value = false;
      showSnackBar('Done', 'Quotation Cancelled');
    } catch (e) {
      cancelingQuotation.value = false;
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
        jobCardCounter.value = '$prefix$separator$initialValue';
        updateJobCard = initialValue.toString();
      } else {
        var firstDoc = jcnDoc.docs.first;
        jcnId = firstDoc.id;
        var currentValue = firstDoc.data()['value'] ?? 0;
        // Use the existing prefix and separator from the document
        jobCardCounter.value =
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

  Future<void> createNewJobCard(String quotationID) async {
    try {
      creatingNewJob.value = true;

      // var job = await FirebaseFirestore.instance
      //     .collection('job_cards')
      //     .where('company_id', isEqualTo: companyId.value)
      //     .where('quotation_id', isEqualTo: quotationID)
      //     .get();

      if (jobCardCounter.value.isNotEmpty) {
        showSnackBar('Alert', 'Job Already Exists');
        creatingNewJob.value = false;

        return;
      }
      showSnackBar('Creating', 'Please Wait');

      Map<String, dynamic> newData = {
        'quotation_id': quotationID,
        'label': '',
        'job_status_1': 'New',
        'job_status_2': 'New',
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
        'fuel_amount': fuelAmount.value.text,
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
        'job_number': jobCardCounter.value,
        'invoice_number': '',
        'lpo_number': '',
        'job_date': '',
        'invoice_date': '',
        'job_approval_date': '',
        'job_start_date': '',
        'job_cancelation_date': '',
        'job_finish_date': '',
        'job_delivery_date': '',
        'job_warrenty_days': quotationWarrentyDays.value.text,
        'job_warrenty_km': quotationWarrentyKM.value.text,
        'job_warrenty_end_date': '',
        'job_min_test_km': '',
        'job_reference_1': '',
        'job_reference_2': '',
        'job_reference_3': '',
        'job_notes': '',
        'job_delivery_notes': '',
      };

      await getCurrentJobCardCounterNumber();
      newData['job_number'] = jobCardCounter.value;
      newData['added_date'] = DateTime.now().toString();

      var newJob = await FirebaseFirestore.instance
          .collection('job_cards')
          .add(newData);

      for (var element in allInvoiceItems) {
        var data = element.data();
        await FirebaseFirestore.instance
            .collection('job_cards')
            .doc(newJob.id)
            .collection('invoice_items')
            .add(data);
      }

      creatingNewJob.value = false;
      showSnackBar('Done', 'Job Created Successfully');
    } catch (e) {
      creatingNewJob.value = false;
      showSnackBar('Alert', 'Something Went Wrong');
    }
  }

  Future<Map<String, dynamic>> copyQuotation(String id) async {
    try {
      showSnackBar('Copying', 'Please Wait');
      loadingCopyQuotation.value = true;
      var mainJob = await FirebaseFirestore.instance
          .collection('quotation_cards')
          .doc(id)
          .get();

      Map<String, dynamic>? data = mainJob.data();
      if (data != null) {
        data.remove('id');
        data['quotation_status'] = 'New';

        await getCurrentQuotationCounterNumber();
        data['quotation_number'] = quotationCounter.value.text;

        var newCopiedQuotation = await FirebaseFirestore.instance
            .collection('quotation_cards')
            .add(data);

        var quotationInvoices = await FirebaseFirestore.instance
            .collection('quotation_cards')
            .doc(id)
            .collection('quotation_invoice_items')
            .get();
        if (quotationInvoices.docs.isNotEmpty) {
          for (var element in quotationInvoices.docs) {
            await FirebaseFirestore.instance
                .collection('quotation_cards')
                .doc(newCopiedQuotation.id)
                .collection('quotation_invoice_items')
                .add(element.data());
          }
        }

        loadingCopyQuotation.value = false;
        return {'newId': newCopiedQuotation.id, 'data': data};
      } else {
        loadingCopyQuotation.value = false;
        showSnackBar('Alert', 'Quotation has no data');
        throw Exception('Job data is empty');
      }
    } catch (e) {
      showSnackBar(
        'Alert',
        'Something went wrong while copying the quotation. Please try again',
      );
      loadingCopyQuotation.value = false;
      rethrow;
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

  void deleteInvoiceItem(String quotationId, String itemId) {
    try {
      Get.back();
      FirebaseFirestore.instance
          .collection('quotation_cards')
          .doc(quotationId)
          .collection('quotation_invoice_items')
          .doc(itemId)
          .delete();
    } catch (e) {
      //
    }
  }

  Future<void> editInvoiceItem(String quotationId, String itemId) async {
    try {
      Get.back();
      await FirebaseFirestore.instance
          .collection('quotation_cards')
          .doc(quotationId)
          .collection('quotation_invoice_items')
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

  Future<void> addNewInvoiceItem(String id) async {
    try {
      addingNewinvoiceItemsValue.value = true;
      await FirebaseFirestore.instance
          .collection('quotation_cards')
          .doc(id)
          .collection('quotation_invoice_items')
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
            'parent_collection': 'quotation_cards',
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

  void getInvoiceItemsFromCollection() {
    FirebaseFirestore.instance
        .collection('invoice_items')
        .where('company_id', isEqualTo: companyId.value)
        .orderBy('name')
        .snapshots()
        .listen((items) {
          allInvoiceItemsFromCollection.value = {
            for (var doc in items.docs) doc.id: doc.data(),
          };
        });
  }

  void getAllInvoiceItems(String quotationId) {
    try {
      loadingInvoiceItems.value = true;
      FirebaseFirestore.instance
          .collection('quotation_cards')
          .doc(quotationId)
          .collection('quotation_invoice_items')
          .orderBy('line_number')
          .snapshots()
          .listen((QuerySnapshot<Map<String, dynamic>> items) {
            allInvoiceItems.assignAll(items.docs);
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

    for (var job in allInvoiceItems) {
      var data = job.data() as Map<String, dynamic>?;
      sumofTotal += double.parse(data?['total']);
      sumofNET += double.parse(data?['net']);
      sumofVAT += double.parse(data?['vat']);
    }

    return [sumofTotal, sumofVAT, sumofNET];
  }

  // this function is to get engine types
  Future<void> getEngineTypes() async {
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
          allEngineType.value = {
            for (var doc in types.docs) doc.id: doc.data(),
          };
        });
  }

  // this function is to get colors
  Future<void> getColors() async {
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
        .orderBy('name')
        .snapshots()
        .listen((colors) {
          allColors.value = {for (var doc in colors.docs) doc.id: doc.data()};
        });
  }

  void getBranches() {
    FirebaseFirestore.instance
        .collection('branches')
        .where('company_id', isEqualTo: companyId.value)
        .orderBy('name')
        .snapshots()
        .listen((branches) {
          allBranches.value = {
            for (var doc in branches.docs) doc.id: doc.data(),
          };
        });
  }

  void getCurrencies() {
    FirebaseFirestore.instance
        .collection('currencies')
        .where('company_id', isEqualTo: companyId.value)
        .snapshots()
        .listen((branches) {
          allCurrencies.value = {
            for (var doc in branches.docs) doc.id: doc.data(),
          };
        });
  }

  void getSalesMan() {
    FirebaseFirestore.instance
        .collection('sales_man')
        .where('company_id', isEqualTo: companyId.value)
        .orderBy('name')
        .snapshots()
        .listen((branches) {
          salesManMap.value = {
            for (var doc in branches.docs) doc.id: doc.data(),
          };
        });
  }

  void getAllUsers() {
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

  Future<void> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId.value = prefs.getString('userId')!;
  }

  void getCompanyDetails() {
    try {
      FirebaseFirestore.instance
          .collection('companies')
          .where(FieldPath.documentId, isEqualTo: companyId.value)
          .snapshots()
          .listen((company) {
            companyDetails.assignAll(
              Map<String, dynamic>.from(company.docs.first.data() as Map),
            );
          });
    } catch (e) {
      //
    }
  }

  void getCountries() {
    try {
      FirebaseFirestore.instance
          .collection('all_countries')
          .orderBy('name')
          .snapshots()
          .listen((countries) {
            allCountries.value = {
              for (var doc in countries.docs) doc.id: doc.data(),
            };
          });
    } catch (e) {
      //
    }
  }

  void getCarBrands() {
    try {
      FirebaseFirestore.instance
          .collection('all_brands')
          .orderBy('name')
          .snapshots()
          .listen((brands) {
            allBrands.value = {for (var doc in brands.docs) doc.id: doc.data()};
          });
    } catch (e) {
      //
    }
  }

  void getAllCustomers() {
    try {
      FirebaseFirestore.instance
          .collection('entity_informations')
          .where('company_id', isEqualTo: companyId.value)
          .where('entity_code', arrayContains: 'Customer')
          .orderBy('entity_name')
          .snapshots()
          .listen((customers) {
            allCustomers.value = {
              for (var doc in customers.docs) doc.id: doc.data(),
            };
          });
    } catch (e) {
      //
    }
  }

  Future<void> getCompanyId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId.value = prefs.getString('companyId')!;
  }

  void selectCashOrCredit(String selected, bool value) {
    bool isCash = selected == 'cash';

    isCashSelected.value = isCash ? value : false;
    isCreditSelected.value = isCash ? false : value;
    payType.value = isCash ? 'Cash' : 'Credit';
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

  void onSelectForCustomers(String selectedId) {
    var currentUserDetails = allCustomers.entries.firstWhere((entry) {
      return entry.key.toString().toLowerCase().contains(
        selectedId.toLowerCase(),
      );
    });

    var phoneDetails = currentUserDetails.value['entity_phone'].firstWhere(
      (value) => value['isPrimary'] == true,
      orElse: () => {'phone': ''},
    );

    customerEntityPhoneNumber.text = phoneDetails['number'] ?? '';
    customerEntityName.text = phoneDetails['name'] ?? '';
    customerEntityEmail.text = phoneDetails['email'] ?? '';

    customerCreditNumber.text =
        (currentUserDetails.value['credit_limit'] ?? '0').toString();
    customerSaleManId.value = currentUserDetails.value['sales_man'] ?? '';
    customerSaleMan.value = getdataName(
      currentUserDetails.value['sales_man'],
      salesManMap,
    );
  }

  void getCitiesByCountryID(String countryID) {
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

  void getModelsByCarBrand(String brandId) {
    try {
      FirebaseFirestore.instance
          .collection('all_brands')
          .doc(brandId)
          .collection('values')
          .snapshots()
          .listen((snapshot) {
            final Map<String, Map<String, dynamic>> mapped = {
              for (var doc in snapshot.docs) doc.id: doc.data(),
            };
            allModels.value = mapped;
          }, onError: (e) {});
    } catch (e) {
      //
    }
  }

  Stream<double> calculateAllTotals(String jobId) {
    return FirebaseFirestore.instance
        .collection('quotation_cards')
        .doc(jobId)
        .collection('quotation_invoice_items')
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
        .collection('quotation_cards')
        .doc(jobId)
        .collection('quotation_invoice_items')
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
        .collection('quotation_cards')
        .doc(jobId)
        .collection('quotation_invoice_items')
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

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  String getdataName(String id, Map allData, {title = 'name'}) {
    try {
      final data = allData.entries.firstWhere((data) => data.key == id);
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

  // Future<void> searchEngine() async {
  //   isScreenLoding.value = true;
  //   final collection = FirebaseFirestore.instance
  //       .collection('quotation_cards')
  //       .where('company_id', isEqualTo: companyId.value);
  //   Query<Map<String, dynamic>> query = collection;

  //   // 1) زر "All" يجلب كل البيانات فورًا
  //   if (isAllSelected.value) {
  //     // لا نضيف أي where، نجلب كل الوثائق
  //     final snapshot = await query.get();
  //     allQuotationCards.assignAll(snapshot.docs);
  //     calculateMoneyForAllQuotations();
  //     numberOfQuotations.value = allQuotationCards.length;

  //     isScreenLoding.value = false;
  //     return;
  //   }

  //   // 2) زر "Today"
  //   if (isTodaySelected.value) {
  //     final now = DateTime.now();
  //     final startOfDay = DateTime(now.year, now.month, now.day);
  //     final endOfDay =
  //         startOfDay.add(Duration(days: 1)).subtract(Duration(milliseconds: 1));
  //     fromDate.value.text = textToDate(startOfDay);
  //     toDate.value.text = textToDate(endOfDay);
  //     query = query
  //         .where('quotation_date',
  //             isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
  //         .where('quotation_date',
  //             isLessThanOrEqualTo: Timestamp.fromDate(endOfDay));
  //   }

  //   // 3) زر "This Month"
  //   else if (isThisMonthSelected.value) {
  //     final now = DateTime.now();
  //     final startOfMonth = DateTime(now.year, now.month, 1);
  //     final startOfNextMonth = (now.month < 12)
  //         ? DateTime(now.year, now.month + 1, 1)
  //         : DateTime(now.year + 1, 1, 1);
  //     final endOfMonth = startOfNextMonth.subtract(Duration(milliseconds: 1));
  //     fromDate.value.text = textToDate(startOfMonth);
  //     toDate.value.text = textToDate(endOfMonth);
  //     query = query
  //         .where('quotation_date',
  //             isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
  //         .where('quotation_date',
  //             isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth));
  //   }

  //   // 4) زر "This Year"
  //   else if (isThisYearSelected.value) {
  //     final now = DateTime.now();
  //     final startOfYear = DateTime(now.year, 1, 1);
  //     final startOfNextYear = DateTime(now.year + 1, 1, 1);
  //     final endOfYear = startOfNextYear.subtract(Duration(milliseconds: 1));
  //     fromDate.value.text = textToDate(startOfYear);
  //     toDate.value.text = textToDate(endOfYear);
  //     query = query
  //         .where('quotation_date',
  //             isGreaterThanOrEqualTo: Timestamp.fromDate(startOfYear))
  //         .where('quotation_date',
  //             isLessThanOrEqualTo: Timestamp.fromDate(endOfYear));
  //   }

  //   // 5) إذا لم يُختر أي من الأزرار الخاصة بالفترة، نطبق فلتر التواريخ اليدوي
  //   else {
  //     if (fromDate.value.text.trim().isNotEmpty) {
  //       try {
  //         final dtFrom = format.parseStrict(fromDate.value.text.trim());
  //         query = query.where(
  //           'quotation_date',
  //           isGreaterThanOrEqualTo: Timestamp.fromDate(dtFrom),
  //         );
  //       } catch (_) {}
  //     }
  //     if (toDate.value.text.trim().isNotEmpty) {
  //       try {
  //         final dtTo = format.parseStrict(toDate.value.text.trim());
  //         query = query.where(
  //           'quotation_date',
  //           isLessThanOrEqualTo: Timestamp.fromDate(dtTo),
  //         );
  //       } catch (_) {}
  //     }
  //   }

  //   // 6) باقي الفلاتر العامة
  //   if (quotaionNumberFilter.value.text.trim().isNotEmpty) {
  //     query = query.where(
  //       'quotation_number',
  //       isEqualTo: quotaionNumberFilter.value.text.trim(),
  //     );
  //   }

  //   if (statusFilter.value.text.trim().isNotEmpty) {
  //     query = query.where(
  //       'quotation_status',
  //       isEqualTo: statusFilter.value.text.trim(),
  //     );
  //   }
  //   if (carBrandIdFilter.value.isNotEmpty) {
  //     query = query.where('car_brand', isEqualTo: carBrandIdFilter.value);
  //   }
  //   if (carModelIdFilter.value.isNotEmpty) {
  //     query = query.where('car_model', isEqualTo: carModelIdFilter.value);
  //   }
  //   if (plateNumberFilter.value.text.trim().isNotEmpty) {
  //     query = query.where(
  //       'plate_number',
  //       isEqualTo: plateNumberFilter.value.text.trim(),
  //     );
  //   }
  //   if (vinFilter.value.text.trim().isNotEmpty) {
  //     query = query.where(
  //       'vehicle_identification_number',
  //       isEqualTo: vinFilter.value.text.trim(),
  //     );
  //   }
  //   if (customerNameIdFilter.value.isNotEmpty) {
  //     query = query.where(
  //       'customer',
  //       isEqualTo: customerNameIdFilter.value,
  //     );
  //   }

  //   // 7) تنفيذ الاستعلام وجلب النتائج
  //   final snapshot = await query.get();
  //   allQuotationCards.assignAll(snapshot.docs);
  //   numberOfQuotations.value = allQuotationCards.length;
  //   calculateMoneyForAllQuotations();
  //   isScreenLoding.value = false;
  // }

  Future<void> searchEngine() async {
    isScreenLoding.value = true;

    // Start with the base query for the company.
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('quotation_cards')
        .where('company_id', isEqualTo: companyId.value);

    // 1. APPLY DATE FILTERS TO THE FIRESTORE QUERY
    // This requires only ONE composite index: (company_id, quotation_date).

    if (isAllSelected.value) {
      // No date filter needed if "All" is selected.
    } else if (isTodaySelected.value) {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      fromDate.value.text = textToDate(startOfDay);
      toDate.value.text = textToDate(endOfDay);
      query = query
          .where(
            'quotation_date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
          )
          .where('quotation_date', isLessThan: Timestamp.fromDate(endOfDay));
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
            'quotation_date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth),
          )
          .where('quotation_date', isLessThan: Timestamp.fromDate(endOfMonth));
    } else if (isThisYearSelected.value) {
      final now = DateTime.now();
      final startOfYear = DateTime(now.year, 1, 1);
      final endOfYear = DateTime(now.year + 1, 1, 1);
      fromDate.value.text = textToDate(startOfYear);
      toDate.value.text = textToDate(endOfYear);
      query = query
          .where(
            'quotation_date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfYear),
          )
          .where('quotation_date', isLessThan: Timestamp.fromDate(endOfYear));
    } else {
      // Manual date range
      if (fromDate.value.text.trim().isNotEmpty) {
        try {
          final dtFrom = format.parseStrict(fromDate.value.text.trim());
          query = query.where(
            'quotation_date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(dtFrom),
          );
        } catch (_) {}
      }
      if (toDate.value.text.trim().isNotEmpty) {
        try {
          final dtTo = format
              .parseStrict(toDate.value.text.trim())
              .add(const Duration(days: 1));
          query = query.where(
            'quotation_date',
            isLessThan: Timestamp.fromDate(dtTo),
          );
        } catch (_) {}
      }
    }

    // 2. EXECUTE THE FIRESTORE QUERY
    final snapshot = await query.get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> fetchedQuotations =
        snapshot.docs;

    // 3. APPLY ALL OTHER FILTERS ON THE CLIENT-SIDE
    List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredQuotations =
        fetchedQuotations.where((doc) {
          final data = doc.data();

          // Quotation Number Filter
          if (quotaionNumberFilter.value.text.trim().isNotEmpty &&
              data['quotation_number'] !=
                  quotaionNumberFilter.value.text.trim()) {
            return false;
          }
          // Status Filter
          if (statusFilter.value.text.trim().isNotEmpty &&
              data['quotation_status'] != statusFilter.value.text.trim()) {
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
    allQuotationCards.assignAll(filteredQuotations);
    numberOfQuotations.value = allQuotationCards.length;
    await calculateMoneyForAllQuotations(); // Call the optimized calculation method
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
    numberOfQuotations.value = 0;
    allQuotationsTotals.value = 0;
    allQuotationsVATS.value = 0;
    allQuotationsNET.value = 0;
    allModels.clear();
    isAllSelected.value = false;
    isTodaySelected.value = false;
    isThisMonthSelected.value = false;
    isThisYearSelected.value = false;
    quotaionNumberFilter.value.clear();
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
    allQuotationCards.clear();
    isScreenLoding.value = false;
  }
}
