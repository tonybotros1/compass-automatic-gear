import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Mobile section controllers/cards_screen_controller.dart';
import '../../../Models/job cards/inspection_report_model.dart';
import '../../../consts.dart';

// 1. PASTE THE KeepAliveWrapper CLASS HERE (OR IMPORT IT)
class KeepAliveWrapper extends StatefulWidget {
  final Widget child;
  const KeepAliveWrapper({super.key, required this.child});

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}

Widget cardStyle({
  required CardsScreenController controller,
  required RxList<InspectionReportModel> listName,
}) {
  return ListView.builder(
    itemCount: listName.length,
    shrinkWrap: true,
    // Add this key to maintain scroll position when data updates slightly
    key: const PageStorageKey('cards_list'),
    itemBuilder: (context, i) {
      var carCard = listName[i];
      List<CarImage> carImages =
          carCard.inspectionReportDetails?.carImages ?? [];

      // FIX 1: Wrap the entire card row in KeepAliveWrapper
      // This prevents the vertical list items from destroying themselves
      // when you scroll down or navigate away.
      return KeepAliveWrapper(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Container(
            color: Colors.white,
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
                                      '${carCard.carBrandName ?? ''} ${carCard.carModelName ?? ''}',
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
                                            style: TextStyle(
                                              backgroundColor:
                                                  Colors.grey.shade200,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        Text(
                                          textToDate(carCard.jobDate),
                                          style: TextStyle(
                                            backgroundColor:
                                                Colors.grey.shade200,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        if (carCard.jobStatus2 != null &&
                                            carCard.jobStatus2 != '')
                                          statusText(
                                            carCard.jobStatus1 == 'Posted'
                                                ? ((isBeforeToday(
                                                        carCard
                                                            .jobWarrantyEndDate
                                                            .toString(),
                                                      ))
                                                      ? 'Closed'
                                                      : 'Warranty')
                                                : carCard.jobStatus2 ?? '',
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            carCard.jobStatus2 != null &&
                                    carCard.jobStatus2 != ''
                                ? statusDot(carCard.jobStatus2 ?? '')
                                : const SizedBox(),
                          ],
                        ),
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
                          controller.loadingDetailsVariables(carCard);
                        },
                        child: SizedBox(
                          height: 270,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: carImages.length,
                            // cacheExtent: 100, // REMOVED: KeepAlive is better
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            itemBuilder: (context, index) {
                              // FIX 2: Wrap the horizontal image item in KeepAliveWrapper
                              return KeepAliveWrapper(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      cacheManager:
                                          controller.customCachedManeger,
                                      imageUrl:
                                          carImages.isNotEmpty &&
                                              controller.isValidUrl(
                                                carImages[index].url,
                                              )
                                          ? carImages[index].url!
                                          : 'https://dummyimage.com/600x400/cccccc/000000&text=No+Image',
                                      key: ValueKey(carImages[index].url),
                                      fit: BoxFit.cover,
                                      width: 380,
                                      height: 270,

                                      fadeInDuration: Duration.zero,
                                      fadeOutDuration: Duration.zero,
                                      placeholderFadeInDuration: Duration.zero,

                                      memCacheWidth: 1000,

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
                              );
                            },
                          ),
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(height: 10),
                Divider(color: Colors.grey.shade300),
              ],
            ),
          ),
        ),
      );
    },
  );
}
