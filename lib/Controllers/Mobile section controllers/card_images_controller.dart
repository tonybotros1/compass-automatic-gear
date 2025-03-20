import 'dart:async';

import 'package:datahubai/Models/image_with_data_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';


class CardImagesScreenController extends GetxController {
  late String customerName;
  List<String> carImages = [];
  OverlayEntry? overlayEntry;
  Timer? hoverTimer;
  bool isOverlayVisible = false;
  Map<String, List<ImageWithDate>> groupedImages = {};

  final customCachedManeger = CacheManager(
      Config('customCacheKey', stalePeriod: const Duration(days: 3)));

  @override
  void onInit() async {
    await getDetails();
    await getImagesGroupedByDate(carImages);
    super.onInit();
  }

  getDetails() {
    if (Get.arguments != null) {
      var arguments = Get.arguments;
      carImages = arguments.carImages;
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
      // print(url);
      try {
        final filePath = getFilePathFromUrl(url);
        final storageRef = FirebaseStorage.instance.ref().child(filePath);
        final metadata = await storageRef.getMetadata();
        final dateAdded = metadata.timeCreated;
        // print(dateAdded);
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
        // print('error: $e');
      }
      update();
    }

    return groupedImages;
  }

   void openImageViewer(List imageUrls, int index) {
    Get.toNamed('/imageViewer',
        arguments: {'images': imageUrls, 'index': index});
  }
}
