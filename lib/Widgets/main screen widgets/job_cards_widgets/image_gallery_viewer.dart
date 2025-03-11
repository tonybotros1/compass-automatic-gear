import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../Controllers/Main screen controllers/gallery_image_viewer_controller.dart';

class ImageGalleryViewer extends StatelessWidget {
  ImageGalleryViewer({super.key});

  final ImageViewerController imageViewerController =
      Get.put(ImageViewerController());
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      autofocus: true,
      focusNode: focusNode,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            if (imageViewerController.currentIndex.value > 0) {
              imageViewerController.pageController!.previousPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            if (imageViewerController.currentIndex.value <
                imageViewerController.imagesURLs.length - 1) {
              imageViewerController.pageController!.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Image Gallery
            PhotoViewGallery.builder(
              itemCount: imageViewerController.imagesURLs.length,
              pageController: imageViewerController.pageController,
              onPageChanged: (index) =>
                  imageViewerController.setCurrentIndex(index),
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: imageViewerController.imagesURLs.first is String ?
                      NetworkImage(imageViewerController.imagesURLs[index]) : FileImage(imageViewerController.imagesURLs[index]),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                );
              },
              scrollPhysics: BouncingScrollPhysics(),
              backgroundDecoration: BoxDecoration(color: Colors.black),
            ),

            // Close Button
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Get.back(),
              ),
            ),

            // Left Arrow
            Obx(() => imageViewerController.currentIndex.value > 0
                ? Positioned(
                    left: 10,
                    top: MediaQuery.of(context).size.height / 2 - 20,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios,
                          color: Colors.white, size: 30),
                      onPressed: () {
                        imageViewerController.pageController!.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  )
                : SizedBox()),

            // Right Arrow
            Obx(() => imageViewerController.currentIndex.value <
                    imageViewerController.imagesURLs.length - 1
                ? Positioned(
                    right: 10,
                    top: MediaQuery.of(context).size.height / 2 - 20,
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward_ios,
                          color: Colors.white, size: 30),
                      onPressed: () {
                        imageViewerController.pageController!.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  )
                : SizedBox()),
          ],
        ),
      ),
    );
  }
}
