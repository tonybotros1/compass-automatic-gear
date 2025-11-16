import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Mobile section controllers/cards_screen_controller.dart';
import '../../../Models/job cards/inspection_report_model.dart';
import '../../../consts.dart';

Widget cardStyle({
  required CardsScreenController controller,
  required RxList<InspectionReportModel> listName,
}) {
  return ListView.builder(
    itemCount: listName.length,
    shrinkWrap: true,
    itemBuilder: (context, i) {
      var carCard = listName[i];
      List<CarImage> carImages =
          carCard.inspectionReportDetails?.carImages ?? [];
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Container(
          color: Colors.grey.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  controller.loadingDetailsVariables(carCard);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 5,
                  ),
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 30,
                            child: Image.network(
                              carCard.carLogo ?? '',
                              errorBuilder: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 60,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${carCard.carBrandName} ${carCard.carModelName}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Row(
                                    spacing: 10,
                                    children: [
                                      if (carCard.plateNumber != '')
                                        Text(
                                          carCard.plateNumber ?? '',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      Text(
                                        textToDate(carCard.jobDate),
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (carCard.jobStatus2 != null &&
                          carCard.jobStatus2 != '')
                        statusBox(carCard.jobStatus2 ?? '', width: 100.0),
                      if (carCard.customerId != null &&
                          carCard.customerId != '')
                        Text(
                          carCard.customerName ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              carImages.isNotEmpty
                  ? InkWell(
                      onTap: () {
                        controller.openImageViewer(
                          carImages.map((img) => img.url).toList(),
                          0,
                        );
                      },
                      child: Container(
                        height: 270,
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.grey[200]),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: CachedNetworkImage(
                            cacheManager: controller.customCachedManeger,
                            imageUrl:
                                carImages.isNotEmpty &&
                                    controller.isValidUrl(carImages[0].url)
                                ? carImages[0].url!
                                : 'https://dummyimage.com/600x400/cccccc/000000&text=No+Image',
                            key: UniqueKey(),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 270,
                            progressIndicatorBuilder:
                                (context, url, progress) => Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value: progress.progress,
                                      color: mainColor,
                                      strokeWidth: 3,
                                    ),
                                  ),
                                ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      controller.loadingDetailsVariables(carCard);
                    },
                    label: Text('Details', style: textStyleForCardBottomBar),
                    icon: Icon(
                      Icons.display_settings,
                      color: iconColorForCardBottomBar,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    label: Text('Share', style: textStyleForCardBottomBar),
                    icon: Icon(
                      Icons.ios_share,
                      color: iconColorForCardBottomBar,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
