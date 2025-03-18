import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import '../../Controllers/Mobile section controllers/card_details_controller.dart';
import '../../consts.dart';

class CarDetailsScreen extends StatelessWidget {
  CarDetailsScreen({super.key});

  final CardDetailsController cardDetailsController =
      Get.put(CardDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: mainColor,
          title: const Text(
            'Details',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          centerTitle: true,
          actions: [
            TextButton(
                onPressed: () {
                  // Get.toNamed(
                  //   '/editCardScreen',
                  //   arguments: JobCardModel(
                  //       carImages: cardDetailsController.carImages,
                  //       customerSignature:
                  //           cardDetailsController.customerSignature,
                  //       carBrand: cardDetailsController.carBrand,
                  //       carMileage: cardDetailsController.carMileage,
                  //       carModel: cardDetailsController.carModel,
                  //       chassisNumber: cardDetailsController.chassisNumber,
                  //       color: cardDetailsController.color,
                  //       customerName: cardDetailsController.customerName,
                  //       date: cardDetailsController.date,
                  //       emailAddress: cardDetailsController.emailAddress,
                  //       fuelAmount: cardDetailsController.fuelAmount,
                  //       phoneNumber: cardDetailsController.phoneNumber,
                  //       plateNumber: cardDetailsController.plateNumber,
                  //       docID: cardDetailsController.id,
                  //       comments: cardDetailsController.comments,
                  //       carVideo: cardDetailsController.video),
                  // );
                },
                child: const Text(
                  'Edit',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: LayoutBuilder(builder: (context, constraints) {
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            cardDetailsController.carBrand,
                            // cardDetailsController.customerName,
                            style: GoogleFonts.mooli(fontSize: 30),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            cardDetailsController.carModel,
                            style: GoogleFonts.mooli(
                                fontSize: 20, color: Colors.grey[600]),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: constraints.maxWidth,
                    color: containerColor,
                    child: Padding(
                      // padding: const EdgeInsets.all(20.0),
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
                                      fontSize: 14, color: Colors.grey[900]),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Get.toNamed('/cardImagesScreen',
                                    //     arguments: JobCardModel(
                                    //         customerName: cardDetailsController
                                    //             .customerName,
                                    //         carImages:
                                    //             cardDetailsController.carImages,
                                    //             ),
                                    //     // transition: Transition.leftToRight,
                                    //     );
                                  },
                                  child: SizedBox(
                                    child: Row(
                                      children: [
                                        Text(
                                          '${cardDetailsController.carImages.length}',
                                          style: GoogleFonts.mooli(
                                              fontSize: 14,
                                              color: Colors.grey[900]),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.grey[900],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          cardDetailsController.carImages.isNotEmpty
                              ? SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List.generate(
                                        cardDetailsController
                                                    .carImages.length >=
                                                5
                                            ? 5
                                            : cardDetailsController
                                                .carImages.length, //length
                                        (index) {
                                      if (cardDetailsController
                                                  .carImages.length >=
                                              5 &&
                                          index == 4) {
                                        return Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: IconButton.filledTonal(
                                              onPressed: () {
                                                // Get.toNamed('/cardImagesScreen',
                                                //     arguments: JobCardModel(
                                                //         customerName:
                                                //             cardDetailsController
                                                //                 .customerName,
                                                //         carImages:
                                                //             cardDetailsController
                                                //                 .carImages),
                                                //     // transition:
                                                //     //     Transition.leftToRight
                                                //         );
                                              },
                                              icon: const Icon(Icons
                                                  .arrow_forward_ios_rounded)),
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
                                                  // Get.toNamed(
                                                  //     '/singleImageViewer',
                                                  //     arguments: ImageModel(
                                                  //         url:
                                                  //             cardDetailsController
                                                  //                     .carImages[
                                                  //                 index]));
                                                },
                                                child: CachedNetworkImage(
                                                  cacheManager:
                                                      cardDetailsController
                                                          .customCachedManeger,
                                                  progressIndicatorBuilder:
                                                      (context, url,
                                                              progress) =>
                                                          Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            30.0),
                                                    child: Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        value:
                                                            progress.progress,
                                                        color: mainColor,
                                                        strokeWidth: 3,
                                                      ),
                                                    ),
                                                  ),
                                                  imageUrl:
                                                      cardDetailsController
                                                          .carImages[index],
                                                  key: UniqueKey(),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),

                                                // child: Image.network(
                                                //   cardDetailsController
                                                //       .carImages[index],
                                                //   loadingBuilder:
                                                //       (BuildContext context,
                                                //           Widget child,
                                                //           ImageChunkEvent?
                                                //               loadingProgress) {
                                                //     if (loadingProgress == null) {
                                                //       return child; // Return the actual image if it's already loaded.
                                                //     } else {
                                                //       // Show a loading indicator while the image is loading.
                                                //       return Center(
                                                //         child: Padding(
                                                //           padding:
                                                //               const EdgeInsets
                                                //                   .all(30.0),
                                                //           child:
                                                //               CircularProgressIndicator(
                                                //             color: secColor,
                                                //             value: loadingProgress
                                                //                         .expectedTotalBytes !=
                                                //                     null
                                                //                 ? loadingProgress
                                                //                         .cumulativeBytesLoaded /
                                                //                     (loadingProgress
                                                //                             .expectedTotalBytes ??
                                                //                         1)
                                                //                 : null,
                                                //           ),
                                                //         ),
                                                //       );
                                                //     }
                                                //   },
                                                // ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  cardDetailsController.comments.isNotEmpty
                      ? Container(
                          width: constraints.maxWidth,
                          color: containerColor,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Comments',
                                  style: GoogleFonts.mooli(
                                      fontSize: 14, color: Colors.grey[900]),
                                ),
                                const SizedBox(
                                  height: 10,
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
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: constraints.maxWidth,
                    color: containerColor,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          cardDetails(
                              title: 'Customer | Number',
                              icon: Icons.person,
                              controller:
                                  '${cardDetailsController.customerName} | ${cardDetailsController.phoneNumber}'),
                          const SizedBox(
                            height: 35,
                          ),
                          cardDetails(
                              title: 'Car Color',
                              icon: Icons.color_lens,
                              controller: cardDetailsController.color.isNotEmpty
                                  ? cardDetailsController.color
                                  : ''),
                          const SizedBox(
                            height: 35,
                          ),
                          cardDetails(
                              title: 'Chassis Number',
                              icon: Icons.tag,
                              controller:
                                  cardDetailsController.chassisNumber.isNotEmpty
                                      ? cardDetailsController.chassisNumber
                                      : ''),
                          const SizedBox(
                            height: 35,
                          ),
                          cardDetails(
                              title: 'Plate Number',
                              icon: Icons.pin,
                              controller:
                                  cardDetailsController.plateNumber.isNotEmpty
                                      ? cardDetailsController.plateNumber
                                      : ''),
                          const SizedBox(
                            height: 35,
                          ),
                          cardDetails(
                              title: 'Car Mileage',
                              icon: Icons.add_road,
                              controller:
                                  cardDetailsController.carMileage.isNotEmpty
                                      ? '${cardDetailsController.carMileage} KM'
                                      : ''),
                          const SizedBox(
                            height: 35,
                          ),
                          cardDetails(
                              title: 'Fuel Amount',
                              icon: Icons.local_gas_station_outlined,
                              controller:
                                  '${cardDetailsController.fuelAmount} %'),
                          const SizedBox(
                            height: 35,
                          ),
                          cardDetails(
                              title: 'Email',
                              icon: Icons.email,
                              controller:
                                  cardDetailsController.emailAddress.isNotEmpty
                                      ? cardDetailsController.emailAddress
                                      : ''),
                          const SizedBox(
                            height: 35,
                          ),
                          cardDetails(
                              title: 'Received On',
                              icon: Icons.date_range,
                              controller:
                                  textToDate(cardDetailsController.date))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: constraints.maxWidth,
                    color: containerColor,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Customer Signature',
                        style: GoogleFonts.mooli(
                            fontSize: 14, color: Colors.grey[900]),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  cardDetailsController.customerSignature.isNotEmpty
                      ? Image.network(cardDetailsController.customerSignature)
                      : const SizedBox(),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: constraints.maxWidth,
                    color: containerColor,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Advisor Signature',
                        style: GoogleFonts.mooli(
                            fontSize: 14, color: Colors.grey[900]),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  cardDetailsController.advisorSignature.isNotEmpty
                      ? Image.network(cardDetailsController.advisorSignature)
                      : const SizedBox(),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
        }));
  }

  Row cardDetails(
      {required String title,
      required IconData icon,
      required String controller}) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: secColor,
                size: 35,
              )
            ],
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
                Text(
                  controller,
                  style: const TextStyle(fontSize: 14),
                )
              ],
            ))
      ],
    );
  }
}
