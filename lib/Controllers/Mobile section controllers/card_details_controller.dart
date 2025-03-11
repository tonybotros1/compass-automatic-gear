import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../Models/image_with_data_model.dart';


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
  late bool status = true;
  late String comments =
      'This is a comment ttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt';
  double fuelAmount = 50;
  late String customerSignature = '';
  List<String> carImages = [];

  @override
  void onInit() async {
    await getDetails();
    await getImagesGroupedByDate(carImages);
    super.onInit();
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
      var arguments = Get.arguments;
      customerSignature = arguments.customerSignature;
      customerName = arguments.customerName;
      carImages = arguments.carImages;
      customerName = arguments.customerName;
      carBrand = arguments.carBrand;
      carModel = arguments.carModel;
      plateNumber = arguments.plateNumber;
      carMileage = arguments.carMileage;
      chassisNumber = arguments.chassisNumber;
      comments = arguments.comments;
      phoneNumber = arguments.phoneNumber;
      emailAddress = arguments.emailAddress;
      color = arguments.color;
      fuelAmount = arguments.fuelAmount;
      date = arguments.date;
      id = arguments.docID;
      video = arguments.carVideo;
      status = arguments.status;
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

  void changeStatus(stat) {
    status = stat;
    FirebaseFirestore.instance
        .collection('car_card')
        .doc(id)
        .update({"status": stat});
    update();
  }

  void updateMethod() {
    update();
  }
}
