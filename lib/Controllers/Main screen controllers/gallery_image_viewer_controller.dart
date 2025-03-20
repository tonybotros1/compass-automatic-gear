import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

class ImageViewerController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxMap arguments = RxMap({});
  RxList imagesURLs = RxList([]);
  PageController? pageController;

  @override
  void onInit() {
    if (Get.arguments != null) {
      arguments.value = Get.arguments as Map<String, dynamic>;
      imagesURLs.value = List<dynamic>.from(arguments['images']);
      currentIndex.value = arguments['index'];
      pageController = PageController(initialPage: currentIndex.value);
    }
    super.onInit();
  }

  @override
  void onClose() {
    pageController?.dispose();
    currentIndex.value = 0;
    imagesURLs.clear();
    arguments.clear();
    super.onClose();
  }

  void setCurrentIndex(int index) {
    currentIndex.value = index;
  }

   final customCachedManeger = CacheManager(
      Config('customCacheKey', stalePeriod: const Duration(days: 3)));

}
