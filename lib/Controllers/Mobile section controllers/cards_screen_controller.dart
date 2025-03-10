import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';

import '../../consts.dart';

class CardsScreenController extends GetxController {
  TextEditingController customerName = TextEditingController();
  TextEditingController technicianName = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController brand = TextEditingController();
  TextEditingController model = TextEditingController();
  TextEditingController year = TextEditingController();
  TextEditingController vin = TextEditingController();
  TextEditingController mileage = TextEditingController();
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
  RxString technicianId = RxString('');
  RxString brandId = RxString('');
  RxString modelId = RxString('');
  RxString companyId = RxString('');
  RxString userId = RxString('');
  RxMap allCustomers = RxMap({});
  RxMap allTechnicians = RxMap({});
  RxMap allBrands = RxMap({});
  RxMap allModels = RxMap({});
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

RxMap<String, Map<String, String>> selectedCheckBoxIndicesForBatteryPerformance =
      <String, Map<String, String>>{}.obs;

  // Wheel controllers section
  TextEditingController leftFrontBrakeLining = TextEditingController();
  TextEditingController leftFrontTireTread = TextEditingController();
  TextEditingController leftFrontWearPattern = TextEditingController();
  TextEditingController leftFrontTirePressureBefore = TextEditingController();
  TextEditingController leftFrontTirePressureAfter = TextEditingController();

  // prioi body damage
  RxList<Offset> damagePoints = <Offset>[].obs;
  RxList<Offset> relativePoints = <Offset>[].obs;
  GlobalKey imageKey = GlobalKey();
  GlobalKey repaintBoundaryKey = GlobalKey();
  RxList<File> imagesList = RxList([]);

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
    'Battery Terminal / Cables / Mountings','Condition Of Battery / Cold Cranking Amps'
  ]);
  TextEditingController batteryColdCrankingAmpsFactorySpecs = TextEditingController();
  TextEditingController batteryColdCrankingAmpsActual= TextEditingController();


  @override
  void onInit() async {
    await getUserAndCompanyId();
    getAllCustomers();
    getAllCards();
    getCarBrands();
    getTechnicians();
    super.onInit();
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

  Future<void> saveImage() async {
    try {
      RenderRepaintBoundary boundary = repaintBoundaryKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Save locally (optional)
      // final directory = await getApplicationDocumentsDirectory();
      File imgFile = File('damaged_car.png');
      await imgFile.writeAsBytes(pngBytes);

      // Upload to Firebase Storage
      // await _uploadToFirebase(imgFile);
    } catch (e) {
      // print("Error saving image: $e");
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
}
