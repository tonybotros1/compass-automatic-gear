import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controllers/Mobile section controllers/card_images_controller.dart';
import '../../consts.dart';

class CardImagesScreen extends StatelessWidget {
  CardImagesScreen({super.key});
  final CardImagesScreenController cardImagesScreenController = Get.put(
    CardImagesScreenController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text('Card Images', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Container(
                width: Get.width,
                color: containerColor,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Images',
                    style: GoogleFonts.mooli(
                      fontSize: 14,
                      color: Colors.grey[900],
                    ),
                  ),
                ),
              ),
            ),
            GetBuilder<CardImagesScreenController>(
              init: CardImagesScreenController(),
              builder: (controller) {
                return controller.groupedImages.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.groupedImages.keys.length,
                        itemBuilder: (context, index) {
                          final dateKey = controller.groupedImages.keys
                              .elementAt(index);
                          final images =
                              controller.groupedImages[dateKey] ?? [];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Date: $dateKey',
                                    style: GoogleFonts.mooli(
                                      fontSize: 14,
                                      color: Colors.grey[900],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                      ),
                                  itemCount: images.length,
                                  itemBuilder: (context, i) {
                                    final image = images[i];
                                    return Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: ClipRRect(
                                        child: FittedBox(
                                          fit: BoxFit.cover,
                                          clipBehavior: Clip.hardEdge,
                                          child: InkWell(
                                            onTap: () {
                                              controller.openImageViewer(
                                                controller.carImages
                                                    .map((img) => img.url)
                                                    .toList(),
                                                index,
                                              );
                                            },
                                            child: CachedNetworkImage(
                                              cacheManager: controller
                                                  .customCachedManeger,
                                              progressIndicatorBuilder:
                                                  (
                                                    context,
                                                    url,
                                                    progress,
                                                  ) => Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          30.0,
                                                        ),
                                                    child: Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                            value: progress
                                                                .progress,
                                                            color: mainColor,
                                                            strokeWidth: 3,
                                                          ),
                                                    ),
                                                  ),
                                              imageUrl: image.imageUrl,
                                              key: UniqueKey(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: CircularProgressIndicator(color: mainColor),
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
