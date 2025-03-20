import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../Models/car_card_model.dart';
import '../../Models/image_with_data_model.dart';
import 'cards_screen_controller.dart';

class CardDetailsController extends GetxController {
  Map<String, List<ImageWithDate>> groupedImages = {};
  OverlayEntry? overlayEntry;
  Timer? hoverTimer;
  bool isOverlayVisible = false;

  late String customerName = 'Tony Botros';

  late String carBrand = 'BMW';
  late String carModel = '2025';
  late String plateNumber = '131511/1fgvfvgggggggggggggggg';
  late String carMileage = '5000000';
  late String chassisNumber = '';
  late String phoneNumber = '0934914410';
  late String emailAddress = '';
  late String color = '';
  late String date = '';
  late String id = '';
  late String video = '';
  late String status = '';
  late String comments =
      'This is a comment ttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt';
  double fuelAmount = 50;
  late String customerSignature = '';
  late String advisorSignature = '';
  List<String> carImages = [];
  Map? data = {};
    CardsScreenController controller = Get.put(CardsScreenController());

  @override
  void onInit() async {
    await getDetails();
    await getImagesGroupedByDate(carImages);
    super.onInit();
  }

  clearVariables(){
    controller.clearAllValues();
  }

  loadVariables() {
    controller.imagesList.clear();
    controller.currenyJobId.value = id;
    controller.inEditMode.value = true;
    controller.technicianName.value.text =
        controller.getdataName(data?['technician'], controller.allTechnicians);
    controller.technicianId.value = data?['technician'];
    controller.date.text = data?['added_date'];
    controller.customer.text = customerName;
    controller.customerId.value = data?['customer'];
    controller.brand.text = carBrand;
    controller.brandId.value = data?['car_brand'];
    controller.model.text = carModel;
    controller.modelId.value = data?['car_model'];
    controller.color.text = color;
    controller.colorId.value = data?['color'];
    controller.plateNumber.text = plateNumber;
    controller.code.text = data?['plate_code'];
    controller.engineType.text =
        controller.getdataName(data?['engine_type'], controller.allEngineTypes);
    controller.year.text = data?['year'];
    controller.mileage.text = data?['mileage_in'];
    controller.vin.text = data?['vehicle_identification_number'];
    controller.comments.text = data?['inspection_report_comments'] ?? '';
    controller.selectedCheckBoxIndicesForLeftFront.assignAll(
      (data?['left_front_wheel'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
              key,
              Map<String, String>.from(value as Map), // Explicit conversion
            ),
          ) ??
          {},
    );
    controller.leftFrontBrakeLining.text = controller
            .selectedCheckBoxIndicesForLeftFront['Brake Lining']?['value'] ??
        '';
    controller.leftFrontTireTread.text = controller
            .selectedCheckBoxIndicesForLeftFront['Tire Tread']?['value'] ??
        '';

    controller.leftFrontWearPattern.text = controller
            .selectedCheckBoxIndicesForLeftFront['Wear Pattern']?['value'] ??
        '';
    controller.leftFrontTirePressureBefore.text =
        controller.selectedCheckBoxIndicesForLeftFront['Tire Pressure PSI']
                ?['before'] ??
            '';
    controller.leftFrontTirePressureAfter.text =
        controller.selectedCheckBoxIndicesForLeftFront['Tire Pressure PSI']
                ?['after'] ??
            '';

    controller.selectedCheckBoxIndicesForRightFront.value =
        (data?['right_front_wheel'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(
                key,
                Map<String, String>.from(value as Map),
              ),
            ) ??
            {};

    controller.rightFrontBrakeLining.text = controller
            .selectedCheckBoxIndicesForRightFront['Brake Lining']?['value'] ??
        '';
    controller.rightFrontTireTread.text = controller
            .selectedCheckBoxIndicesForRightFront['Tire Tread']?['value'] ??
        '';

    controller.rightFrontWearPattern.text = controller
            .selectedCheckBoxIndicesForRightFront['Wear Pattern']?['value'] ??
        '';
    controller.rightFrontTirePressureBefore.text =
        controller.selectedCheckBoxIndicesForRightFront['Tire Pressure PSI']
                ?['before'] ??
            '';
    controller.rightFrontTirePressureAfter.text =
        controller.selectedCheckBoxIndicesForRightFront['Tire Pressure PSI']
                ?['after'] ??
            '';

    controller.selectedCheckBoxIndicesForLeftRear.value =
        (data?['left_rear_wheel'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(
                key,
                Map<String, String>.from(value as Map),
              ),
            ) ??
            {};

    controller.leftRearBrakeLining.text = controller
            .selectedCheckBoxIndicesForLeftRear['Brake Lining']?['value'] ??
        '';
    controller.leftRearTireTread.text =
        controller.selectedCheckBoxIndicesForLeftRear['Tire Tread']?['value'] ??
            '';

    controller.leftRearWearPattern.text = controller
            .selectedCheckBoxIndicesForLeftRear['Wear Pattern']?['value'] ??
        '';
    controller.leftRearTirePressureBefore.text =
        controller.selectedCheckBoxIndicesForLeftRear['Tire Pressure PSI']
                ?['before'] ??
            '';
    controller.leftRearTirePressureAfter.text =
        controller.selectedCheckBoxIndicesForLeftRear['Tire Pressure PSI']
                ?['after'] ??
            '';

    controller.selectedCheckBoxIndicesForRightRear.value =
        (data?['right_rear_wheel'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(
                key,
                Map<String, String>.from(value as Map),
              ),
            ) ??
            {};

    controller.rightRearBrakeLining.text = controller
            .selectedCheckBoxIndicesForRightRear['Brake Lining']?['value'] ??
        '';
    controller.rightRearTireTread.text = controller
            .selectedCheckBoxIndicesForRightRear['Tire Tread']?['value'] ??
        '';

    controller.rightRearWearPattern.text = controller
            .selectedCheckBoxIndicesForRightRear['Wear Pattern']?['value'] ??
        '';
    controller.rightRearTirePressureBefore.text =
        controller.selectedCheckBoxIndicesForRightRear['Tire Pressure PSI']
                ?['before'] ??
            '';
    controller.rightRearTirePressureAfter.text =
        controller.selectedCheckBoxIndicesForRightRear['Tire Pressure PSI']
                ?['after'] ??
            '';

    controller.selectedCheckBoxIndicesForInteriorExterior.value =
        (data?['interior_exterior'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(
                key,
                Map<String, String>.from(value as Map),
              ),
            ) ??
            {};

    controller.selectedCheckBoxIndicesForUnderVehicle.value =
        (data?['under_vehicle'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(
                key,
                Map<String, String>.from(value as Map),
              ),
            ) ??
            {};

    controller.selectedCheckBoxIndicesForUnderHood.value =
        (data?['under_hood'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(
                key,
                Map<String, String>.from(value as Map),
              ),
            ) ??
            {};

    controller.selectedCheckBoxIndicesForBatteryPerformance.value =
        (data?['battery_performance'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(
                key,
                Map<String, String>.from(value as Map),
              ),
            ) ??
            {};

    controller.carImagesURLs.assignAll(List<String>.from(data?['car_images']));
    controller.customerSignatureURL.value = data?['customer_signature'] ?? '';
    controller.advisorSignatureURL.value = data?['advisor_signature'] ?? '';
    controller.carDialogImageURL.value = data?['car_dialog'] ?? '';
  }

  void openImageViewer(List imageUrls, int index) {
    Get.toNamed('/imageViewer',
        arguments: {'images': imageUrls, 'index': index});
  }

// this is for cached images
  final customCachedManeger = CacheManager(
      Config('customCacheKey', stalePeriod: const Duration(days: 3)));

  getDetails() {
    if (Get.arguments != null) {
      CarCardModel arguments = Get.arguments;
      data = arguments.data;
      customerSignature = arguments.customerSignature!;
      advisorSignature = arguments.advisorSignature!;
      customerName = arguments.customerName!;
      carImages = arguments.carImages!;
      carBrand = arguments.carBrand!;
      carModel = arguments.carModel!;
      plateNumber = arguments.plateNumber!;
      carMileage = arguments.carMileage!;
      chassisNumber = arguments.chassisNumber!;
      comments = arguments.comments!;
      phoneNumber = arguments.phoneNumber!;
      emailAddress = arguments.emailAddress!;
      color = arguments.color!;
      // fuelAmount = arguments.fuelAmount;
      date = arguments.date!;
      id = arguments.docID!;
      status = arguments.status1!;
    }
    update();
  }

  void showFullScreen(BuildContext context, String imageUrl) {
    // تجنب عرض الصورة مجددًا إذا كانت موجودة بالفعل
    if (isOverlayVisible) return;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: GestureDetector(
          onTap: () => removeOverlay(),
          child: Container(
            color: Colors.black,
            child: Center(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry!);
    isOverlayVisible = true; // يتم عرض الصورة
  }

  void removeOverlay() {
    hoverTimer?.cancel(); // تأكد من إلغاء المؤقت
    overlayEntry?.remove();
    overlayEntry = null;
    isOverlayVisible = false; // تم إزالة الصورة
  }

// this fuction is the get the path of the image from url
  String getFilePathFromUrl(String url) {
    final uri = Uri.parse(url);
    final encodedPath = uri.pathSegments[4]; // path segment after /o/
    return Uri.decodeComponent(encodedPath); // decode %2F back to /
  }

// this function is to get the date of each image from firebase storage
  Future<Map<String, List<ImageWithDate>>> getImagesGroupedByDate(
      List<String> imageUrls) async {
    for (var url in imageUrls) {
      try {
        final filePath = getFilePathFromUrl(url);
        final storageRef = FirebaseStorage.instance.ref().child(filePath);
        final metadata = await storageRef.getMetadata();
        final dateAdded = metadata.timeCreated;

        if (dateAdded != null) {
          // تحويل التاريخ إلى تنسيق "yyyy-MM-dd"
          final dateKey =
              "${dateAdded.year}-${dateAdded.month.toString().padLeft(2, '0')}-${dateAdded.day.toString().padLeft(2, '0')}";

          // إضافة الصورة إلى المجموعة المناسبة
          if (groupedImages.containsKey(dateKey)) {
            groupedImages[dateKey]
                ?.add(ImageWithDate(imageUrl: url, dateAdded: dateAdded));
          } else {
            groupedImages[dateKey] = [
              ImageWithDate(imageUrl: url, dateAdded: dateAdded)
            ];
          }
        }
      } catch (e) {
        //
      }
    }

    return groupedImages;
  }

  void updateMethod() {
    update();
  }
}
