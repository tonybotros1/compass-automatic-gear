import 'package:cached_network_image/cached_network_image.dart';
import 'package:datahubai/Models/job%20cards/inspection_report_model.dart';
import 'package:datahubai/Screens/mobile%20Screens/edit_inspection_report.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import '../../Controllers/Mobile section controllers/card_details_controller.dart';
import '../../consts.dart';

class CarDetailsScreen extends StatelessWidget {
  CarDetailsScreen({super.key});

  final CardDetailsController cardDetailsController = Get.put(
    CardDetailsController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text('Details', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          onPressed: () {
            cardDetailsController.clearVariables();
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              cardDetailsController.loadVariables();
              Get.to(() => const EditInspectionReport());
            },
            child: const Text('Edit', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: constraints.maxWidth,
                    color: containerColor,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            cardDetailsController.carBrand,
                            style: GoogleFonts.mooli(fontSize: 30),
                          ),
                          Row(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                cardDetailsController.carModel,
                                style: GoogleFonts.mooli(
                                  fontSize: 20,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                cardDetailsController.year.toString(),
                                style: GoogleFonts.mooli(
                                  fontSize: 20,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: constraints.maxWidth,
                    color: containerColor,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20, left: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Images',
                                  style: GoogleFonts.mooli(
                                    fontSize: 14,
                                    color: Colors.grey[900],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(
                                      '/cardImagesScreen',
                                      arguments: InspectionReportDetails(
                                        carImages:
                                            cardDetailsController.carImages,
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    child: Row(
                                      children: [
                                        Text(
                                          '${cardDetailsController.carImages.length}',
                                          style: GoogleFonts.mooli(
                                            fontSize: 14,
                                            color: Colors.grey[900],
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.grey[900],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          cardDetailsController.carImages.isNotEmpty
                              ? SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List.generate(
                                      cardDetailsController.carImages.length >=
                                              5
                                          ? 5
                                          : cardDetailsController
                                                .carImages
                                                .length,
                                      (index) {
                                        if (cardDetailsController
                                                    .carImages
                                                    .length >=
                                                5 &&
                                            index == 4) {
                                          return Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: IconButton.filledTonal(
                                              onPressed: () {
                                                Get.toNamed(
                                                  '/cardImagesScreen',
                                                  arguments:
                                                      InspectionReportDetails(
                                                        carImages:
                                                            cardDetailsController
                                                                .carImages,
                                                      ),
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                              ),
                                            ),
                                          );
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            width: 125,
                                            height: 125,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: FittedBox(
                                                fit: BoxFit.cover,
                                                clipBehavior: Clip.hardEdge,
                                                child: InkWell(
                                                  onTap: () {
                                                    cardDetailsController
                                                        .openImageViewer(
                                                          cardDetailsController
                                                              .carImages
                                                              .map(
                                                                (img) =>
                                                                    img.url,
                                                              )
                                                              .toList(),
                                                          index,
                                                        );
                                                  },
                                                  child: CachedNetworkImage(
                                                    memCacheWidth: 1000,
                                                    cacheManager:
                                                        cardDetailsController
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
                                                                  color:
                                                                      mainColor,
                                                                  strokeWidth:
                                                                      3,
                                                                ),
                                                          ),
                                                        ),
                                                    imageUrl:
                                                        cardDetailsController
                                                            .carImages[index]
                                                            .url ??
                                                        '',
                                                    key: ValueKey(index),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            const Icon(
                                                              Icons.error,
                                                            ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  cardDetailsController.comments.isNotEmpty
                      ? Container(
                          width: constraints.maxWidth,
                          color: containerColor,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Comments',
                                  style: GoogleFonts.mooli(
                                    fontSize: 14,
                                    color: Colors.grey[900],
                                  ),
                                ),
                                SizedBox(
                                  width: constraints.maxWidth,
                                  child: ReadMoreText(
                                    isExpandable: true,
                                    cardDetailsController.comments,
                                    trimLines: 1,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: 'Read more',
                                    trimExpandedText: ' Read less',
                                    style: const TextStyle(fontSize: 15),
                                    textAlign: TextAlign.start,
                                    moreStyle: const TextStyle(
                                      color: Colors.blue,
                                    ),
                                    lessStyle: const TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 5),
                  Container(
                    width: constraints.maxWidth,
                    color: containerColor,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        spacing: 35,
                        children: [
                          cardDetails(
                            title: 'Job Date',
                            icon: Icons.date_range,
                            controller: textToDate(cardDetailsController.date),
                          ),
                          cardDetails(
                            title: 'Job Number',
                            icon: Icons.format_list_numbered_outlined,
                            controller: cardDetailsController.jobNumber,
                          ),
                          cardDetails(
                            title: 'Customer | Number',
                            icon: Icons.person,
                            controller:
                                '${cardDetailsController.customerName} | ${cardDetailsController.phoneNumber}',
                          ),
                          cardDetails(
                            title: 'Car Color',
                            icon: Icons.color_lens,
                            controller: cardDetailsController.color.isNotEmpty
                                ? cardDetailsController.color
                                : '',
                          ),
                          cardDetails(
                            title: 'Technician',
                            icon: Icons.manage_accounts,
                            controller: cardDetailsController.technician,
                          ),
                          cardDetails(
                            title: 'VIN',
                            icon: Icons.tag,
                            controller: cardDetailsController.vin.isNotEmpty
                                ? cardDetailsController.vin
                                : '',
                          ),
                          cardDetails(
                            title: 'Engine Type',
                            icon: Icons.settings,
                            controller: cardDetailsController.engineType,
                          ),
                          cardDetails(
                            title: 'Plate Number | Code',
                            icon: Icons.pin,
                            controller:
                                '${cardDetailsController.plateNumber} | ${cardDetailsController.code}',
                          ),
                          cardDetails(
                            title: 'Car Mileage',
                            icon: Icons.add_road,
                            controller:
                                cardDetailsController.carMileage
                                    .toString()
                                    .isNotEmpty
                                ? '${cardDetailsController.carMileage} KM'
                                : '',
                          ),
                          cardDetails(
                            title: 'Fuel Amount',
                            icon: Icons.local_gas_station_outlined,
                            controller: '${cardDetailsController.fuelAmount} %',
                          ),
                          cardDetails(
                            title: 'Email',
                            icon: Icons.email,
                            controller:
                                cardDetailsController.emailAddress.isNotEmpty
                                ? cardDetailsController.emailAddress
                                : '',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    alignment: Alignment.center,
                    width: constraints.maxWidth,
                    color: containerColor,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Customer Signature',
                        style: GoogleFonts.mooli(
                          fontSize: 14,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  cardDetailsController.customerSignature.isNotEmpty
                      ? Image.network(cardDetailsController.customerSignature)
                      : const SizedBox(),
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.center,
                    width: constraints.maxWidth,
                    color: containerColor,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Advisor Signature',
                        style: GoogleFonts.mooli(
                          fontSize: 14,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  cardDetailsController.advisorSignature.isNotEmpty
                      ? Image.network(cardDetailsController.advisorSignature)
                      : const SizedBox(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Row cardDetails({
    required String title,
    required IconData icon,
    required String controller,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Icon(icon, color: secColor, size: 35)],
          ),
        ),
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 17, color: Colors.grey[700]),
              ),
              Text(controller, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}
