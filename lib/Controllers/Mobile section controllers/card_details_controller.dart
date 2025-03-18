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

  @override
  void onInit() async {
    await getDetails();
    await getImagesGroupedByDate(carImages);
    super.onInit();
  }

  loadVariables() {
    CardsScreenController controller = Get.put(CardsScreenController());
    controller.technicianName.text =
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
        Map<String, Map<String, String>>.from(data?['left_front_wheel'] ?? {}));

    controller.selectedCheckBoxIndicesForRightFront.value =
        Map<String, Map<String, String>>.from(data?['right_front_wheel'] ?? {});

    controller.selectedCheckBoxIndicesForLeftRear.value =
        Map<String, Map<String, String>>.from(data?['left_rear_wheel'] ?? {});

    controller.selectedCheckBoxIndicesForRightRear.value =
        Map<String, Map<String, String>>.from(data?['right_rear_wheel'] ?? {});

    controller.selectedCheckBoxIndicesForInteriorExterior.value =
        Map<String, Map<String, String>>.from(data?['interior_exterior'] ?? {});

    controller.selectedCheckBoxIndicesForUnderVehicle.value =
        Map<String, Map<String, String>>.from(data?['under_vehicle'] ?? {});

    controller.selectedCheckBoxIndicesForUnderHood.value =
        Map<String, Map<String, String>>.from(data?['under_hood'] ?? {});

    controller.selectedCheckBoxIndicesForBatteryPerformance.value =
        Map<String, Map<String, String>>.from(
            data?['battery_performance'] ?? {});

    controller.imagesListURLs.assignAll(List<String>.from(data?['car_images']));
    controller.customerSignatureURL.value = data?['customer_signature'] ?? '';
    controller.advisorSignatureURL.value = data?['advisor_signature'] ?? '';
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
