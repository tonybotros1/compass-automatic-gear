import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';
import '../../Models/job cards/inspection_report_model.dart';
import '../../Screens/mobile Screens/card_details_screen.dart';
import '../../consts.dart';
import '../../helpers.dart';
import '../Main screen controllers/websocket_controller.dart';

class CardsScreenController extends GetxController {
  TextEditingController customer = TextEditingController();
  TextEditingController customerEntityName = TextEditingController();
  TextEditingController customerEntityEmail = TextEditingController();
  TextEditingController customerCreditNumber = TextEditingController();
  Rx<TextEditingController> technicianName = TextEditingController().obs;
  TextEditingController date = TextEditingController(
    text: textToDate(DateTime.now()),
  );
  TextEditingController brand = TextEditingController();
  TextEditingController model = TextEditingController();
  TextEditingController plateNumber = TextEditingController();
  TextEditingController code = TextEditingController();
  TextEditingController year = TextEditingController();
  TextEditingController color = TextEditingController();
  TextEditingController engineType = TextEditingController();
  TextEditingController vin = TextEditingController();
  TextEditingController mileage = TextEditingController();
  TextEditingController comments = TextEditingController();
  TextEditingController jobNumber = TextEditingController();
  TextEditingController transmissionType = TextEditingController();
  TextEditingController fuelAmount = TextEditingController();
  TextEditingController customerEntityPhoneNumber = TextEditingController();
  // final RxList<DocumentSnapshot> allCarCards = RxList<DocumentSnapshot>([]);
  final RxList<InspectionReportModel> newCarCards =
      RxList<InspectionReportModel>([]);

  final RxList<InspectionReportModel> doneCarCards =
      RxList<InspectionReportModel>([]);

  final RxList<InspectionReportModel> filteredCarCards =
      RxList<InspectionReportModel>([]);
  Rx<TextEditingController> search = TextEditingController().obs;
  RxString query = RxString('');
  final RxBool loading = RxBool(false);
  final RxInt numberOfNewCars = RxInt(0);
  final RxInt numberOfDoneCars = RxInt(0);
  RxString customerId = RxString('');
  RxString carBrandLogo = RxString('');
  RxString technicianId = RxString('');
  RxString brandId = RxString('');
  RxString modelId = RxString('');
  RxString engineTypeId = RxString('');
  RxString colorId = RxString('');
  // RxString companyId = RxString('');
  // RxString userId = RxString('');
  RxString customerSaleManId = RxString('');
  // RxMap allCustomers = RxMap({});
  // RxMap allTechnicians = RxMap({});
  // RxMap allBrands = RxMap({});
  RxMap allModels = RxMap({});
  // RxMap allColors = RxMap({});
  // RxMap allEngineTypes = RxMap({});
  RxList<CarImage> carImagesURLs = RxList<CarImage>([]);
  RxString carDialogImageURL = RxString('');
  Uint8List? customerSignatureAsImage;
  Uint8List? advisorSignatureAsImage;
  RxString customerSignatureURL = RxString('');
  RxString advisorSignatureURL = RxString('');
  RxBool inEditMode = RxBool(false);
  RxString currenyJobId = RxString('');

  RxMap<String, Map<String, String>> selectedCheckBoxIndicesForLeftFront =
      <String, Map<String, String>>{}.obs;
  RxMap<String, Map<String, String>> selectedCheckBoxIndicesForRightFront =
      <String, Map<String, String>>{}.obs;
  RxMap<String, Map<String, String>> selectedCheckBoxIndicesForLeftRear =
      <String, Map<String, String>>{}.obs;
  RxMap<String, Map<String, String>> selectedCheckBoxIndicesForRightRear =
      <String, Map<String, String>>{}.obs;

  RxMap<String, Map<String, String>>
  selectedCheckBoxIndicesForInteriorExterior =
      <String, Map<String, String>>{}.obs;

  RxMap<String, Map<String, String>> selectedCheckBoxIndicesForUnderVehicle =
      <String, Map<String, String>>{}.obs;

  RxMap<String, Map<String, String>> selectedCheckBoxIndicesForUnderHood =
      <String, Map<String, String>>{}.obs;

  RxMap<String, Map<String, String>>
  selectedCheckBoxIndicesForBatteryPerformance =
      <String, Map<String, String>>{}.obs;

  RxMap<String, Map<String, String>>
  selectedCheckBoxIndicesForSingleCheckBoxForBrakeAndTire =
      <String, Map<String, String>>{}.obs;

  // Wheel controllers section
  TextEditingController leftFrontBrakeLining = TextEditingController();
  TextEditingController leftFrontTireTread = TextEditingController();
  TextEditingController leftFrontWearPattern = TextEditingController();
  TextEditingController leftFrontTirePressureBefore = TextEditingController();
  TextEditingController leftFrontTirePressureAfter = TextEditingController();

  TextEditingController rightFrontBrakeLining = TextEditingController();
  TextEditingController rightFrontTireTread = TextEditingController();
  TextEditingController rightFrontWearPattern = TextEditingController();
  TextEditingController rightFrontTirePressureBefore = TextEditingController();
  TextEditingController rightFrontTirePressureAfter = TextEditingController();

  TextEditingController leftRearBrakeLining = TextEditingController();
  TextEditingController leftRearTireTread = TextEditingController();
  TextEditingController leftRearWearPattern = TextEditingController();
  TextEditingController leftRearTirePressureBefore = TextEditingController();
  TextEditingController leftRearTirePressureAfter = TextEditingController();

  TextEditingController rightRearBrakeLining = TextEditingController();
  TextEditingController rightRearTireTread = TextEditingController();
  TextEditingController rightRearWearPattern = TextEditingController();
  TextEditingController rightRearTirePressureBefore = TextEditingController();
  TextEditingController rightRearTirePressureAfter = TextEditingController();

  // prioi body damage
  RxList<Offset> damagePoints = <Offset>[].obs;
  RxList<Offset> relativePoints = <Offset>[].obs;
  GlobalKey imageKey = GlobalKey();
  GlobalKey repaintBoundaryKey = GlobalKey();
  RxList<File> imagesList = RxList([]);
  final ImagePicker picker = ImagePicker();
  String backendUrl = backendTestURI;
  RxMap companyDetails = RxMap({});
  RxBool canShowBreakAndTire = RxBool(false);
  RxBool canShowInteriorExterior = RxBool(false);
  RxBool canShowUnderVehicle = RxBool(false);
  RxBool canShowUnderHood = RxBool(false);
  RxBool canShowBatteryPerformance = RxBool(false);
  RxBool canShowBodyDamage = RxBool(false);
  final bottomBarController = Get.put(PersistentTabController());
  // final formKey = GlobalKey<FormState>();

  // interioir / exterioir
  RxList entrioirExterioirList = RxList([
    'Head Lights, Tail Lights, Turn Signals, Breake Lights, Hazard Lights, Exterioi Lamps, License Plate Lights',
    'Windshield Washer/Wiper Operation, Wiper Blades',
    'Windshield Condition: Cracks / Chips / Pitting',
    'Mirrors / Glass',
    'Emergency Brake Adjustment',
    'Horn Operation',
    'Fuel Tank Cap Gasket',
    'Air Conditioning Filter (if equipped)',
    'Clutch Operation (if equipped)',
    'Back Up Lights Left / Right',
    'Dash Warning Lights',
    'Carpet / Upholstery / Floor Mats',
  ]);

  // under vehicle
  RxList underVehicleList = RxList([
    'Shock Absorbers / Suspension / Struts',
    'Steering Box, Linkage, Ball Joints, Dust Covers',
    'Muffler, Exhaust Pipes/Mounts. Catalytic Converter',
    'Engine Oil and Fluid Leaks',
    'Brakes Lines, Hoses, Parking Brake Cable',
    'Drive Shaft Boots, Constant Velocity Boots, U-Joints, Transmission Linkage (if equipped)',
    'Transmission, Differential, Transfer Case, (Check Fluid Level, Fluid Condition and Fluid Leaks)',
    'Fluid Lines and Connections, Fluid Tank Band, Fuel Tank Vapor Vent Systems Hoses',
    'Inspect Nuts and Blots on Body and Chassis',
  ]);

  RxList underHoodList = RxList([
    'Fluid Levels: Oil, Coolant, Battery, Power Steering, Brake Fluid, Washer, Automatic Transmission',
    'Engine Air Filter',
    'Drive Belts (condition and adjustment)',
    'Cooling System Hoses, Heater Hpses, Air Condition, Hoses and Connections',
    'Radiator Core, Air Conditioner Condenser',
    'Clutch Reservoir Fluid / Condition (as equipped)',
  ]);

  RxList batteryPerformanceList = RxList([
    'Battery Terminal / Cables / Mountings',
    'Condition Of Battery / Cold Cranking Amps',
  ]);

  RxList singleCheckBoxForBrakeAndTireList = RxList([
    'Alignment Check Needed',
    'Wheel Ballance Needed',
    'Brake Inspection Not Performed This Visit',
  ]);

  TextEditingController batteryColdCrankingAmpsFactorySpecs =
      TextEditingController();
  TextEditingController batteryColdCrankingAmpsActual = TextEditingController();
  WebSocketService ws = Get.find<WebSocketService>();

  @override
  void onInit() async {
    await getCurrentCompanyDetails();
    connectWebSocket();
    assignTheWidgetsInInspectionReportScreen();
    getNewInspectionReporst();
    super.onInit();
  }

  @override
  void onReady() async {
    scheduleUpdateDamagePoints();
    super.onReady();
  }

  void scheduleUpdateDamagePoints() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (repaintBoundaryKey.currentContext != null) {
        updateDamagePoints();
      }
    });
  }

  void connectWebSocket() {
    ws.events.listen((message) {
      switch (message["type"]) {
        case "inspection_report_added":
          final newCounter = InspectionReportModel.fromJson(message["data"]);
          newCarCards.insert(0, newCounter);
          break;

        case "inspection_report_updated":
          final updated = InspectionReportModel.fromJson(message["data"]);
          final index = newCarCards.indexWhere((m) => m.id == updated.id);
          if (index != -1) {
            newCarCards[index] = updated;
          }
          break;
      }
    });
  }

  Future<Map<String, dynamic>> getAllCustomers() async {
    return await helper.getCustomers();
  }

  Future<Map<String, dynamic>> getCarBrands() async {
    return await helper.getCarBrands();
  }

  Future<void> getModelsByCarBrand(String brandID) async {
    allModels.assignAll(await helper.getModelsValues(brandID));
  }

  Future<Map<String, dynamic>> getColors() async {
    return await helper.getAllListValues('COLORS');
  }

  Future<Map<String, dynamic>> getEngineTypes() async {
    return await helper.getAllListValues('ENGINE_TYPES');
  }

  Future<Map<String, dynamic>> getTechnicians() async {
    return await helper.getAllListValues('TIME_SHEET');
  }

  Future getCurrentJobCardStatus(String id) async {
    return await helper.getJobCardStatus(id);
  }

  bool isValidUrl(String? url) {
    if (url == null || url.trim().isEmpty) return false;

    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> getCurrentCompanyDetails() async {
    companyDetails.assignAll(await helper.getCurrentCompanyDetails());
  }

  void assignTheWidgetsInInspectionReportScreen() {
    List inspectionReport = companyDetails.containsKey('inspection_report')
        ? companyDetails['inspection_report'] ?? []
        : [];
    // if (inspectionReport.isEmpty) {
    //   return;
    // }
    if (inspectionReport.contains('Break And Tire')) {
      canShowBreakAndTire.value = true;
    } else {
      canShowBreakAndTire.value = false;
    }
    if (inspectionReport.contains('Interior / Exterior')) {
      canShowInteriorExterior.value = true;
    } else {
      canShowInteriorExterior.value = false;
    }
    if (inspectionReport.contains('Under Vehicle')) {
      canShowUnderVehicle.value = true;
    } else {
      canShowUnderVehicle.value = false;
    }
    if (inspectionReport.contains('Under Hood')) {
      canShowUnderHood.value = true;
    } else {
      canShowUnderHood.value = false;
    }
    if (inspectionReport.contains('Battery Performace')) {
      canShowBatteryPerformance.value = true;
    } else {
      canShowBatteryPerformance.value = false;
    }
    if (inspectionReport.contains('Body Damage')) {
      canShowBodyDamage.value = true;
    } else {
      canShowBodyDamage.value = false;
    }
  }

  Future<void> getNewInspectionReporst() async {
    try {
      loading.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/inspection_reports/get_new_job_cards_inspection_reports',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List cards = decoded['inspection_reports'];
        newCarCards.assignAll(
          cards.map((card) => InspectionReportModel.fromJson(card)),
        );
        numberOfNewCars.value = newCarCards.length;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getNewInspectionReporst();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        Get.back();
        showSnackBar('Alert', 'Something went wrong please try again');
      }

      loading.value = false;
    } catch (e) {
      loading.value = false;
    }
  }

  Future<void> getDoneInspectionReporst() async {
    try {
      loading.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/inspection_reports/get_done_job_cards_inspection_reports',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List cards = decoded['inspection_reports'];
        doneCarCards.assignAll(
          cards.map((card) => InspectionReportModel.fromJson(card)),
        );
        numberOfDoneCars.value = doneCarCards.length;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getDoneInspectionReporst();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        Get.back();
        showSnackBar('Alert', 'Something went wrong please try again');
      }

      loading.value = false;
    } catch (e) {
      loading.value = false;
    }
  }

  Future<void> addInspectionCard() async {
    try {
      if (companyDetails['current_user_branch_id'] == '' ||
          companyDetails['current_user_branch_id'] == null) {
        alertMessage(
          context: Get.context!,
          content: 'This user has no branch selected',
        );
        return;
      }
      loadingScreen();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/inspection_reports/create_job_from_inspection_report',
      );
      final request = http.MultipartRequest("POST", url);

      request.fields['fuel_amount'] = fuelAmount.text;
      request.fields['branch'] = companyDetails['current_user_branch_id'] ?? '';
      request.fields['job_date'] = convertDateToIson(date.text).toString();
      request.fields['comment'] = comments.text;
      request.fields['technician'] = technicianId.value;
      request.fields['customer'] = customerId.value;
      request.fields['car_brand'] = brandId.value;
      request.fields['car_model'] = modelId.value;
      request.fields['plate_number'] = plateNumber.text;
      request.fields['code'] = code.text;
      request.fields['mileage_in'] = mileage.text;
      request.fields['engine_type'] = engineTypeId.value;
      request.fields['year'] = year.text;
      request.fields['transmission_type'] = transmissionType.text;
      request.fields['vin'] = vin.text;
      request.fields['color'] = colorId.value;
      request.fields['car_brand_logo'] = carBrandLogo.value;
      request.fields['customer_name'] = customerEntityName.text;
      request.fields['customer_email'] = customerEntityEmail.text;
      request.fields['customer_phone'] = customerEntityPhoneNumber.text;
      request.fields['credit_limit'] = customerCreditNumber.text;
      request.fields['salesman'] = customerSaleManId.value;

      request.fields['interior_exterior'] = jsonEncode(
        selectedCheckBoxIndicesForInteriorExterior,
      );
      request.fields['under_vehicle'] = jsonEncode(
        selectedCheckBoxIndicesForUnderVehicle,
      );
      request.fields['under_hood'] = jsonEncode(
        selectedCheckBoxIndicesForUnderHood,
      );
      request.fields['left_front_wheel'] = jsonEncode(
        selectedCheckBoxIndicesForLeftFront,
      );
      request.fields['right_front_wheel'] = jsonEncode(
        selectedCheckBoxIndicesForRightFront,
      );
      request.fields['left_rear_wheel'] = jsonEncode(
        selectedCheckBoxIndicesForLeftRear,
      );
      request.fields['right_rear_wheel'] = jsonEncode(
        selectedCheckBoxIndicesForRightRear,
      );
      request.fields['battery_performance'] = jsonEncode(
        selectedCheckBoxIndicesForBatteryPerformance,
      );
      request.fields['extra_checks'] = jsonEncode(
        selectedCheckBoxIndicesForSingleCheckBoxForBrakeAndTire,
      );

      for (var imgFile in imagesList) {
        final bytes = await imgFile.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            'car_images',
            bytes,
            filename: imgFile.path.split('/').last,
          ),
        );
      }
      if (damagePoints.isNotEmpty) {
        // save car dialog
        Uint8List dialogResult = await saveCarDialogImageModified();
        request.files.add(
          http.MultipartFile.fromBytes(
            'car_dialog',
            dialogResult,
            filename:
                'car_dialog${customer.text}_${DateTime.now().millisecondsSinceEpoch}.png',
          ),
        );
      }

      // Save signature images.
      customerSignatureAsImage = await signatureControllerForCustomer
          .toPngBytes();
      advisorSignatureAsImage = await signatureControllerForAdvisor
          .toPngBytes();

      if (customerSignatureAsImage != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'customer_signature',
            customerSignatureAsImage!,
            filename:
                'customer_signature${customer.text}_${DateTime.now().millisecondsSinceEpoch}.png',
          ),
        );
      }
      if (advisorSignatureAsImage != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'advisor_signature',
            advisorSignatureAsImage!,
            filename:
                'advisor_signature_${DateTime.now().millisecondsSinceEpoch}.png',
          ),
        );
      }
      request.headers.addAll({
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'multipart/form-data',
      });
      final response = await request.send();
      // final resBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        Get.back();
        bottomBarController.index = 0;
        clearAllValues();
        showSnackBar('Done', 'Added Successfully');
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addInspectionCard();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        Get.back();
        showSnackBar('Alert', 'Something went wrong please try again');
      }
    } catch (e) {
      Get.back();
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  Future<void> updateInspectionCard() async {
    try {
      Map jobStatus = await getCurrentJobCardStatus(currenyJobId.value);
      String status1 = jobStatus['job_status_1'];
      if (status1 != 'New' && status1 != '' && status1 != 'Draft') {
        showSnackBar('Alert', 'Only new jobs can be edited');
        return;
      }
      loadingScreen();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/inspection_reports/update_job_from_inspection_report/$currenyJobId',
      );
      final request = http.MultipartRequest("PUT", url);

      // جميع الحقول كما في إضافة
      request.fields['fuel_amount'] = fuelAmount.text;
      request.fields['job_date'] = convertDateToIson(date.text).toString();
      request.fields['comment'] = comments.text;
      request.fields['technician'] = technicianId.value;
      request.fields['customer'] = customerId.value;
      request.fields['car_brand'] = brandId.value;
      request.fields['car_model'] = modelId.value;
      request.fields['plate_number'] = plateNumber.text;
      request.fields['code'] = code.text;
      request.fields['mileage_in'] = mileage.text;
      request.fields['engine_type'] = engineTypeId.value;
      request.fields['year'] = year.text;
      request.fields['transmission_type'] = transmissionType.text;
      request.fields['vin'] = vin.text;
      request.fields['color'] = colorId.value;
      request.fields['car_brand_logo'] = carBrandLogo.value;
      request.fields['customer_name'] = customerEntityName.text;
      request.fields['customer_email'] = customerEntityEmail.text;
      request.fields['customer_phone'] = customerEntityPhoneNumber.text;
      request.fields['credit_limit'] = customerCreditNumber.text;
      request.fields['salesman'] = customerSaleManId.value;

      // فحص الخيارات
      request.fields['interior_exterior'] = jsonEncode(
        selectedCheckBoxIndicesForInteriorExterior,
      );
      request.fields['under_vehicle'] = jsonEncode(
        selectedCheckBoxIndicesForUnderVehicle,
      );
      request.fields['under_hood'] = jsonEncode(
        selectedCheckBoxIndicesForUnderHood,
      );
      request.fields['left_front_wheel'] = jsonEncode(
        selectedCheckBoxIndicesForLeftFront,
      );
      request.fields['right_front_wheel'] = jsonEncode(
        selectedCheckBoxIndicesForRightFront,
      );
      request.fields['left_rear_wheel'] = jsonEncode(
        selectedCheckBoxIndicesForLeftRear,
      );
      request.fields['right_rear_wheel'] = jsonEncode(
        selectedCheckBoxIndicesForRightRear,
      );
      request.fields['battery_performance'] = jsonEncode(
        selectedCheckBoxIndicesForBatteryPerformance,
      );
      request.fields['extra_checks'] = jsonEncode(
        selectedCheckBoxIndicesForSingleCheckBoxForBrakeAndTire,
      );

      // الصور الجديدة
      for (var imgFile in imagesList) {
        final bytes = await imgFile.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            'new_images',
            bytes,
            filename: imgFile.path.split('/').last,
          ),
        );
      }

      // kept images IDs
      request.fields['kept_images'] = jsonEncode(
        carImagesURLs.map((img) => img.imagePublicId).toList(),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'multipart/form-data',
      });

      final response = await request.send();

      if (response.statusCode == 200) {
        clearAllValues();
        Get.close(3);
        showSnackBar('Done', 'Updated Successfully');
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await updateInspectionCard();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        Get.back();
        showSnackBar('Alert', 'Something went wrong please try again');
      }
    } catch (e) {
      Get.close(2);
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  // ==================================================================================================
  Future<void> loadingDetailsVariables(InspectionReportModel carCard) async {
    Get.to(
      () => CarDetailsScreen(),
      arguments: carCard,
      transition: Transition.leftToRight,
    );
  }

  void clearAllValues() {
    // Clear all TextEditingControllers
    inEditMode.value = false;
    fuelAmount.clear();
    jobNumber.text = '';
    transmissionType.clear();
    batteryColdCrankingAmpsFactorySpecs.clear();
    currenyJobId.value = '';
    batteryColdCrankingAmpsActual.clear();
    customer.clear();
    customerEntityName.clear();
    customerEntityEmail.clear();
    customerCreditNumber.clear();
    technicianName.value = TextEditingController();
    date.text = textToDate(DateTime.now());
    brand.clear();
    model.clear();
    plateNumber.clear();
    code.clear();
    year.clear();
    color.clear();
    engineType.clear();
    vin.clear();
    mileage.clear();
    comments.clear();
    customerEntityPhoneNumber.clear();

    leftFrontBrakeLining.clear();
    leftFrontTireTread.clear();
    leftFrontWearPattern.clear();
    leftFrontTirePressureBefore.clear();
    leftFrontTirePressureAfter.clear();

    rightFrontBrakeLining.clear();
    rightFrontTireTread.clear();
    rightFrontWearPattern.clear();
    rightFrontTirePressureBefore.clear();
    rightFrontTirePressureAfter.clear();

    leftRearBrakeLining.clear();
    leftRearTireTread.clear();
    leftRearWearPattern.clear();
    leftRearTirePressureBefore.clear();
    leftRearTirePressureAfter.clear();

    rightRearBrakeLining.clear();
    rightRearTireTread.clear();
    rightRearWearPattern.clear();
    rightRearTirePressureBefore.clear();
    rightRearTirePressureAfter.clear();

    filteredCarCards.clear();

    // Clear search field
    search.value.clear();
    query.value = '';

    // Reset Booleans and Integers
    loading.value = false;

    // Reset RxString values
    customerId.value = '';
    technicianId.value = '';
    brandId.value = '';
    modelId.value = '';
    engineTypeId.value = '';
    colorId.value = '';

    customerSaleManId.value = '';

    // Clear image lists and URLs
    carImagesURLs.clear();
    carDialogImageURL.value = '';
    customerSignatureURL.value = '';
    advisorSignatureURL.value = '';

    // Reset signatures
    customerSignatureAsImage = null;
    advisorSignatureAsImage = null;

    // Clear selected checkboxes
    selectedCheckBoxIndicesForLeftFront.clear();
    selectedCheckBoxIndicesForRightFront.clear();
    selectedCheckBoxIndicesForLeftRear.clear();
    selectedCheckBoxIndicesForRightRear.clear();
    selectedCheckBoxIndicesForInteriorExterior.clear();
    selectedCheckBoxIndicesForUnderVehicle.clear();
    selectedCheckBoxIndicesForUnderHood.clear();
    selectedCheckBoxIndicesForBatteryPerformance.clear();
    selectedCheckBoxIndicesForSingleCheckBoxForBrakeAndTire.clear();

    signatureControllerForCustomer.clear();
    signatureControllerForAdvisor.clear();

    // Clear body damage points
    damagePoints.clear();
    relativePoints.clear();

    // Clear images list
    imagesList.clear();
    update();
  }

  final customCachedManeger = CacheManager(
    Config('customCacheKey', stalePeriod: const Duration(days: 3)),
  );

  Future<dynamic> loadingScreen() {
    return showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (context) {
        return const Center(
          child: SpinKitDoubleBounce(color: Colors.grey, size: 30),
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> saveCarImages() async {
    List<Map<String, dynamic>> uploadedImages = [];
    try {
      for (var image in imagesList) {
        final Reference storageRef = FirebaseStorage.instance.ref().child(
          'car_images/${formatPhrase(brand.text)}_${DateTime.now().millisecondsSinceEpoch}.png',
        );
        final Uint8List imageBytes = await image.readAsBytes();
        final UploadTask uploadTask = storageRef.putData(imageBytes);
        await uploadTask;
        final String imageUrl = await storageRef.getDownloadURL();
        uploadedImages.add({'url': imageUrl, 'ref': storageRef});
      }
      return uploadedImages;
    } catch (e) {
      rethrow;
    }
  }

  Future<Uint8List> saveCarDialogImageModified() async {
    try {
      final BuildContext? context = repaintBoundaryKey.currentContext;
      if (context == null) {
        throw Exception('Error: repaintBoundaryKey.currentContext is null');
      }
      final RenderRepaintBoundary? boundary =
          context.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception('Error: RenderRepaintBoundary is null');
      }
      ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) {
        throw Exception('Error: Failed to convert image to byte data');
      }
      Uint8List pngBytes = byteData.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
      rethrow;
    }
  }

  void addDamagePoint(TapDownDetails details) {
    if (imageKey.currentContext == null) return;

    final RenderBox imageBox =
        imageKey.currentContext!.findRenderObject() as RenderBox;
    final Offset imagePosition = imageBox.localToGlobal(Offset.zero);
    final Size imageSize = imageBox.size;

    // Convert tap position to be relative to the image size (0.0 - 1.0)
    final Offset localPosition = details.globalPosition - imagePosition;
    final Offset relativePosition = Offset(
      localPosition.dx / imageSize.width,
      localPosition.dy / imageSize.height,
    );

    relativePoints.add(relativePosition);
    updateDamagePoints(); // Convert to absolute positions for rendering
  }

  void updateDamagePoints() {
    if (imageKey.currentContext == null) return;

    final RenderBox imageBox =
        imageKey.currentContext!.findRenderObject() as RenderBox;
    final Size imageSize = imageBox.size;

    // Convert relative positions back to absolute positions
    damagePoints.value = relativePoints.map((rel) {
      return Offset(rel.dx * imageSize.width, rel.dy * imageSize.height);
    }).toList();
  }

  Future<Map<String, dynamic>> saveSignatureImage(
    dynamic signatureAsImage,
  ) async {
    try {
      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('signatures')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      final UploadTask uploadTask = ref.putData(signatureAsImage);
      await uploadTask;
      final String url = await ref.getDownloadURL();
      return {'url': url, 'ref': ref};
    } catch (e) {
      rethrow;
    }
  }

  void openImageViewer(List imageUrls, int index) {
    Get.toNamed(
      '/imageViewer',
      arguments: {'images': imageUrls, 'index': index},
    );
  }

  // this functions is to take photos
  // Function to take photos
  void takePhoto(String source) async {
    try {
      if (source == 'Camera') {
        // Capture a single image from the camera
        final XFile? photo = await picker.pickImage(source: ImageSource.camera);
        if (photo != null) {
          imagesList.add(File(photo.path));
        }
      } else {
        // Pick multiple images from the gallery
        final List<XFile> photos = await picker.pickMultiImage();
        if (photos.isNotEmpty) {
          imagesList.addAll(photos.map((photo) => File(photo.path)).toList());
        }
      }
    } catch (e) {
      // Handle errors if needed
      // print("Error capturing image: $e");
    }
  }

  // for signature:
  SignatureController signatureControllerForAdvisor = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  SignatureController signatureControllerForCustomer = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  void removeLastMark() {
    damagePoints.removeLast();
    relativePoints.removeLast();
  }

  // to check a box and save its value in the map
  void updateSelectedBox(
    String label,
    String statusKey,
    String statusValue,
    RxMap<String, Map<String, String>> dataMap,
  ) {
    if (!dataMap.containsKey(label)) {
      dataMap[label] = {};
    }
    if (dataMap[label]?[statusKey] == statusValue) {
      // If the checkbox is already selected, remove it
      dataMap[label]?.remove(statusKey);
      if (dataMap[label]?.isEmpty ?? false) {
        dataMap.remove(label); // Remove the label if it's empty
      }
    } else {
      // Otherwise, select it
      dataMap[label]?[statusKey] = statusValue;
    }
    update();
  }

  // to upate the text field and save its value in the map
  void updateEnteredField(
    String label,
    String valueKey,
    String value,
    RxMap<String, Map<String, String>> dataMap,
  ) {
    if (!dataMap.containsKey(label)) {
      dataMap[label] = {};
    }
    if (dataMap[label] is Map<String, String>) {
      dataMap[label]?[valueKey] = value;
    }
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

  // Function to filter the list based on search criteria
  Future<void> filterResults(
    String query,
    List<InspectionReportModel> cards,
  ) async {
    query = query.toLowerCase();

    List<InspectionReportModel> filteredResults = [];

    for (var card in cards) {
      // Fetch the model name asynchronously
      final modelName = card.carModelName ?? '';
      final customerName = card.customerName ?? '';
      final brandName = card.carBrandName ?? '';
      final platNumber = card.plateNumber ?? '';
      final date = textToDate(card.jobDate);

      // Check if any of the fields contain the query
      if (customerName.toString().toLowerCase().contains(query) ||
          brandName.toString().toLowerCase().contains(query) ||
          modelName.toString().toLowerCase().contains(
            query,
          ) || // Now modelName is included
          platNumber.toString().toLowerCase().contains(query) ||
          date.toString().toLowerCase().contains(query)) {
        filteredResults.add(card);
      }
    }

    // Update the list with the filtered results
    filteredCarCards.assignAll(filteredResults);
  }

  void onSelectForCustomers(Map data) {
    var phoneDetails =
        (data['entity_phone'] as List?)?.firstWhere(
          (value) => value['isPrimary'] == true,
          orElse: () => {'number': ''},
        ) ??
        {'number': ''};

    customerEntityPhoneNumber.text = phoneDetails['number'] ?? '';
    customerEntityName.text = phoneDetails['name'] ?? '';
    customerEntityEmail.text = phoneDetails['email'] ?? '';

    customerCreditNumber.text = data["credit_limit"]?.toString() ?? '0';
    customerSaleManId.value = data['salesman_id'] ?? '';
  }
}
