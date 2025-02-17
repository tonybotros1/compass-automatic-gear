import 'package:flutter/material.dart';
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
      imagesURLs.value = List<String>.from(arguments['images']);
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
}
