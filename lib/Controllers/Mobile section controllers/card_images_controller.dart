import 'dart:async';
import 'package:datahubai/Models/image_with_data_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../../Models/job cards/inspection_report_model.dart';

class CardImagesScreenController extends GetxController {
  late String customerName;
  List<CarImage> carImages = [];
  OverlayEntry? overlayEntry;
  Timer? hoverTimer;
  bool isOverlayVisible = false;
  Map<String, List<ImageWithDate>> groupedImages = {};

  final customCachedManeger = CacheManager(
    Config('customCacheKey', stalePeriod: const Duration(days: 3)),
  );

  @override
  void onInit() async {
    getDetails();
    super.onInit();
  }

  void getDetails() {
    if (Get.arguments != null) {
      InspectionReportDetails arguments = Get.arguments;
      carImages = arguments.carImages ?? [];
    }
    getImagesGroupedByDate(carImages);
  }

  void showFullScreen(BuildContext context, String imageUrl) {
    if (isOverlayVisible) return;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: GestureDetector(
          onTap: () => removeOverlay(),
          child: Container(
            color: Colors.black,
            child: Center(child: Image.network(imageUrl, fit: BoxFit.contain)),
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

  void getImagesGroupedByDate(List<CarImage> imageUrls) async {
    for (var image in imageUrls) {
      final dateAdded = image.createdAt;
      if (dateAdded != null) {
        final dateKey =
            "${dateAdded.day.toString().padLeft(2, '0')}-${dateAdded.month.toString().padLeft(2, '0')}-${dateAdded.year}";

        if (groupedImages.containsKey(dateKey)) {
          groupedImages[dateKey]?.add(
            ImageWithDate(imageUrl: image.url ?? '', dateAdded: dateAdded),
          );
        } else {
          groupedImages[dateKey] = [
            ImageWithDate(imageUrl: image.url ?? '', dateAdded: dateAdded),
          ];
        }
      }
    }
  }

  void openImageViewer(List imageUrls, int index) {
    Get.toNamed(
      '/imageViewer',
      arguments: {'images': imageUrls, 'index': index},
    );
  }
}
