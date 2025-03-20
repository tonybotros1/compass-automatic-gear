import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';
import '../../consts.dart';

class CardsScreenController extends GetxController {
  TextEditingController customer = TextEditingController();
  TextEditingController customerEntityName = TextEditingController();
  TextEditingController customerEntityEmail = TextEditingController();
  TextEditingController customerCreditNumber = TextEditingController();
  Rx<TextEditingController> technicianName = TextEditingController().obs;
  TextEditingController date =
      TextEditingController(text: textToDate(DateTime.now()));
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
  TextEditingController customerEntityPhoneNumber = TextEditingController();
  final RxList<DocumentSnapshot> allCarCards = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> newCarCards = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> doneCarCards = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredCarCards =
      RxList<DocumentSnapshot>([]);
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
  RxString companyId = RxString('');
  RxString userId = RxString('');
  RxString customerSaleManId = RxString('');
  RxMap allCustomers = RxMap({});
  RxMap allTechnicians = RxMap({});
  RxMap allBrands = RxMap({});
  RxMap allModels = RxMap({});
  RxMap allColors = RxMap({});
  RxMap allEngineTypes = RxMap({});
  RxList carImagesURLs = RxList([]);
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
    'Carpet / Upholstery / Floor Mats'
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
    'Inspect Nuts and Blots on Body and Chassis'
  ]);

  RxList underHoodList = RxList([
    'Fluid Levels: Oil, Coolant, Battery, Power Steering, Brake Fluid, Washer, Automatic Transmission',
    'Engine Air Filter',
    'Drive Belts (condition and adjustment)',
    'Cooling System Hoses, Heater Hpses, Air Condition, Hoses and Connections',
    'Radiator Core, Air Conditioner Condenser',
    'Clutch Reservoir Fluid / Condition (as equipped)'
  ]);

  RxList batteryPerformanceList = RxList([
    'Battery Terminal / Cables / Mountings',
    'Condition Of Battery / Cold Cranking Amps'
  ]);
  TextEditingController batteryColdCrankingAmpsFactorySpecs =
      TextEditingController();
  TextEditingController batteryColdCrankingAmpsActual = TextEditingController();

  @override
  void onInit() async {
    await getUserAndCompanyId();
    getAllCustomers();
    getAllCards();
    getCarBrands();
    getTechnicians();
    getColors();
    getEngineTypes();
    super.onInit();
  }

  void clearAllValues() {
    // Clear all TextEditingControllers
    batteryColdCrankingAmpsFactorySpecs.clear();
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
    numberOfNewCars.value = 0;
    numberOfDoneCars.value = 0;

    // Reset RxString values
    customerId.value = '';
    technicianId.value = '';
    brandId.value = '';
    modelId.value = '';
    engineTypeId.value = '';
    colorId.value = '';
    companyId.value = '';
    userId.value = '';
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
      Config('customCacheKey', stalePeriod: const Duration(days: 3)));

  editInspectionCard(BuildContext context, String jobId) async {
    try {
      var myData = {
        'technician': technicianId.value,
        'company_id': companyId.value,
        'car_brand': brandId.value,
        'car_model': modelId.value,
        'plate_number': plateNumber.text,
        'plate_code': code.text,
        'year': year.text,
        'color': colorId.value,
        'engine_type': engineTypeId.value,
        'vehicle_identification_number': vin.text,
        'mileage_in': mileage.text,
        'customer': customerId.value,
        'contact_name': customerEntityName.text,
        'contact_number': customerEntityPhoneNumber.text,
        'contact_email': customerEntityEmail.text,
        'credit_limit': customerCreditNumber.text,
        'saleMan': customerSaleManId.value,
        'inspection_report_comments': comments.text.trim(),
        'left_front_wheel': selectedCheckBoxIndicesForLeftFront,
        'right_front_wheel': selectedCheckBoxIndicesForRightFront,
        'left_rear_wheel': selectedCheckBoxIndicesForLeftRear,
        'right_rear_wheel': selectedCheckBoxIndicesForRightRear,
        'interior_exterior': selectedCheckBoxIndicesForInteriorExterior,
        'under_vehicle': selectedCheckBoxIndicesForUnderVehicle,
        'under_hood': selectedCheckBoxIndicesForUnderHood,
        'battery_performance': selectedCheckBoxIndicesForBatteryPerformance,
      };

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return Center(
                child: Row(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Colors.white,
                ),
                Text(
                  'Please Wait...',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )
              ],
            ));
          });
      if (imagesList.isNotEmpty) {
        await saveCarImages();
        myData['car_images'] = carImagesURLs;
      }
      await FirebaseFirestore.instance
          .collection('job_cards')
          .doc(jobId)
          .update(myData);
      Get.back();
      showSnackBar('Done', 'Addedd Successfully');
    } catch (e) {
      Get.back();
      showSnackBar('Failed', 'Please ty again');
    }
  }

  addInspectionCard(BuildContext context) async {
    try {
      Map<String, dynamic> newData = {
        'added_date': DateTime.now().toString(),
        'label': 'Draft',
        'job_status_1': '',
        'job_status_2': '',
        'quotation_status': '',
        'car_brand_logo': 'carBrandLogo.value',
        'technician': technicianId.value,
        'company_id': companyId.value,
        'car_brand': brandId.value,
        'car_model': modelId.value,
        'plate_number': plateNumber.text,
        'plate_code': code.text,
        'country': '',
        'city': '',
        'year': year.text,
        'color': colorId.value,
        'engine_type': engineTypeId.value,
        'vehicle_identification_number': vin.text,
        'transmission_type': '',
        'mileage_in': mileage.text,
        'mileage_out': '',
        'mileage_in_out_diff': '',
        'customer': customerId.value,
        'contact_name': customerEntityName.text,
        'contact_number': customerEntityPhoneNumber.text,
        'contact_email': customerEntityEmail.text,
        'credit_limit': customerCreditNumber.text,
        'outstanding': '',
        'saleMan': customerSaleManId.value,
        'branch': '',
        'currency': '',
        'rate': '',
        'payment_method': 'Cash',
        'quotation_number': '',
        'quotation_date': '',
        'validity_days': '',
        'validity_end_date': '',
        'reference_number': '',
        'delivery_time': '',
        'quotation_warrenty_days': '',
        'quotation_warrenty_km': '',
        'quotation_notes': '',
        'job_number': '',
        'invoice_number': '',
        'lpo_number': '',
        'job_date': '',
        'invoice_date': '',
        'job_approval_date': '',
        'job_start_date': '',
        'job_cancelation_date': '',
        'job_finish_date': '',
        'job_delivery_date': '',
        'job_warrenty_days': '',
        'job_warrenty_km': '',
        'job_warrenty_end_date': '',
        'job_min_test_km': '',
        'job_reference_1': '',
        'job_reference_2': '',
        'job_reference_3': '',
        'job_notes': '',
        'job_delivery_notes': '',
        'inspection_report_comments': comments.text.trim(),
        'left_front_wheel': selectedCheckBoxIndicesForLeftFront,
        'right_front_wheel': selectedCheckBoxIndicesForRightFront,
        'left_rear_wheel': selectedCheckBoxIndicesForLeftRear,
        'right_rear_wheel': selectedCheckBoxIndicesForRightRear,
        'interior_exterior': selectedCheckBoxIndicesForInteriorExterior,
        'under_vehicle': selectedCheckBoxIndicesForUnderVehicle,
        'under_hood': selectedCheckBoxIndicesForUnderHood,
        'battery_performance': selectedCheckBoxIndicesForBatteryPerformance,
      };
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return Center(
                child: Row(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Colors.white,
                ),
                Text(
                  'Please Wait...',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )
              ],
            ));
          });
      if (imagesList.isNotEmpty) {
        await saveCarImages();
        newData['car_images'] = carImagesURLs;
      } else {
        newData['car_images'] = [];
      }
      await saveCarDialogImage();
      newData['car_dialog'] = carDialogImageURL.value;

      customerSignatureAsImage =
          await signatureControllerForCustomer.toPngBytes();
      advisorSignatureAsImage =
          await signatureControllerForAdvisor.toPngBytes();

      if (customerSignatureAsImage != null) {
        customerSignatureURL.value =
            await saveSignatureImage(customerSignatureAsImage);
      }

      if (advisorSignatureAsImage != null) {
        advisorSignatureURL.value =
            await saveSignatureImage(advisorSignatureAsImage);
      }

      newData['customer_signature'] = customerSignatureURL.value;
      newData['advisor_signature'] = advisorSignatureURL.value;

      await FirebaseFirestore.instance.collection('job_cards').add(newData);

      Get.back();
      showSnackBar('Done', 'Addedd Successfully');
    } catch (e) {
      Get.back();
      showSnackBar('Failed', 'Please ty again');
    }
  }

  Future<void> saveCarImages() async {
    try {
      for (var image in imagesList) {
        final Reference storageRef = FirebaseStorage.instance.ref().child(
            'car_images/${formatPhrase(brand.text)}_${DateTime.now().millisecondsSinceEpoch}.png');

        final Uint8List imageBytes = await image.readAsBytes();

        final UploadTask uploadTask = storageRef.putData(
          imageBytes,
          // SettableMetadata(contentType: 'image/png'),
        );

        final TaskSnapshot snapshot = await uploadTask;
        final String imageUrl = await snapshot.ref.getDownloadURL();

        carImagesURLs.add(imageUrl);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Future<void> saveCarDialogImage() async {
  //   try {
  //     final RenderRepaintBoundary? boundary = repaintBoundaryKey.currentContext!
  //         .findRenderObject() as RenderRepaintBoundary?;

  //     ui.Image image = await boundary!.toImage(pixelRatio: 1.5);
  //     ByteData? byteData =
  //         await image.toByteData(format: ui.ImageByteFormat.png);

  //     Uint8List pngBytes = byteData!.buffer.asUint8List();

  //     final Reference storageRef = FirebaseStorage.instance.ref().child(
  //         'car_images/${formatPhrase(brand.text)}_${DateTime.now().millisecondsSinceEpoch}.png');

  //     final UploadTask uploadTask = storageRef.putData(
  //       pngBytes,
  //       // SettableMetadata(contentType: 'image/png'),
  //     );

  //     await uploadTask.then((p0) async {
  //       carDialogImageURL.value = await storageRef.getDownloadURL();
  //     });

  //     // if (snapshot.state == TaskState.success) {
  //     //   final String imageUrl = await snapshot.ref.getDownloadURL();
  //     //   carDialogImageURL.value = imageUrl;
  //     // }
  //   } catch (e, stackTrace) {
  //     debugPrint('Error in saveCarDialogImage: $e\n$stackTrace');
  //     rethrow;
  //   }
  // }

  Future<String?> saveCarDialogImage() async {
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
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception('Error: Failed to convert image to byte data');
      }

      Uint8List pngBytes = byteData.buffer.asUint8List();

      final Reference storageRef = FirebaseStorage.instance.ref().child(
          'car_images/${formatPhrase(brand.text)}_${DateTime.now().millisecondsSinceEpoch}.png');

      final UploadTask uploadTask = storageRef.putData(pngBytes);
      final TaskSnapshot snapshot = await uploadTask;

      final String imageUrl = await snapshot.ref.getDownloadURL();
      carDialogImageURL.value = imageUrl;

      return imageUrl;
    } catch (e) {
      return e.toString(); // Return the exception message
    }
  }

  // for saving signature image in firebase
  saveSignatureImage(signatureAsImage) async {
    try {
      // uploading.value = true;
      var url = '';
      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('signatures')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      final UploadTask uploadTask = ref.putData(signatureAsImage!);
      await uploadTask.then((p0) async {
        url = await ref.getDownloadURL();
      });
      return url;
    } catch (e) {
      rethrow;
    }
  }

  void openImageViewer(List imageUrls, int index) {
    Get.toNamed('/imageViewer',
        arguments: {'images': imageUrls, 'index': index});
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

  removeLastMark() {
    damagePoints.removeLast();
    relativePoints.removeLast();
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

    update();
  }

// to check a box and save its value in the map
  void updateSelectedBox(String label, String statusKey, String statusValue,
      RxMap<String, Map<String, String>> dataMap) {
    if (!dataMap.containsKey(label)) {
      dataMap[label] = {};
    }
    if (dataMap[label] is Map<String, String>) {
      dataMap[label]?[statusKey] = statusValue;
    }
    update();
  }

// to upate the text field and save its value in the map
  void updateEnteredField(String label, String valueKey, String value,
      RxMap<String, Map<String, String>> dataMap) {
    if (!dataMap.containsKey(label)) {
      dataMap[label] = {};
    }
    if (dataMap[label] is Map<String, String>) {
      dataMap[label]?[valueKey] = value;
    }
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

// this function is to get user and company id:
  getUserAndCompanyId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId.value = (prefs.getString('userId'))!;
    companyId.value = prefs.getString('companyId')!;
  }

// this function is to get the data name from id
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

  getAllCards() {
    try {
      loading.value = true;

      FirebaseFirestore.instance
          .collection('job_cards')
          .where('company_id', isEqualTo: companyId.value)
          .orderBy('added_date', descending: true)
          .snapshots()
          .listen((event) {
        allCarCards.assignAll(event.docs); // Assign all cards first

        // Clear the lists before refilling
        newCarCards.clear();
        doneCarCards.clear();

        for (var element in event.docs) {
          var data = element.data();
          if (data['label'] == 'Draft') {
            newCarCards.add(element);
          } else {
            doneCarCards.add(element);
          }
        }

        numberOfNewCars.value = newCarCards.length;
        numberOfDoneCars.value = doneCarCards.length;

        loading.value = false;
      }, onError: (e) {
        loading.value = false;
      });
    } catch (e) {
      loading.value = false;
    }
  }

  // Function to filter the list based on search criteria
  void filterResults(String query) {
    query = query.toLowerCase();

    // Use where() to filter the list based on multiple fields
    List<DocumentSnapshot> filteredResults =
        allCarCards.where((documentSnapshot) {
      final data = documentSnapshot.data() as Map<String, dynamic>?;

      final customerName = data?['customer_name'] ?? '';
      final carBrand = data?['car_brand'] ?? '';
      final carModel = data?['car_model'] ?? '';
      final platNumber = data?['plate_number'] ?? '';
      final date = data?['date'] ?? '';

      // Check if any of the fields start with the query
      return customerName.toString().toLowerCase().contains(query) ||
          carBrand.toString().toLowerCase().contains(query) ||
          carModel.toString().toLowerCase().contains(query) ||
          platNumber.toString().toLowerCase().contains(query) ||
          date.toString().toLowerCase().contains(query);
    }).toList();

    // Update the list with the filtered results
    filteredCarCards.assignAll(filteredResults);
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

  getTechnicians() {
    try {
      FirebaseFirestore.instance
          .collection('all_technicians')
          .snapshots()
          .listen((tech) {
        allTechnicians.value = {for (var doc in tech.docs) doc.id: doc.data()};
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
      allEngineTypes.value = {for (var doc in types.docs) doc.id: doc.data()};
    });
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
  }
}
