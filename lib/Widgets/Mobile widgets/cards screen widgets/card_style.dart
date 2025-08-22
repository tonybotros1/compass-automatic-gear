import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Mobile section controllers/cards_screen_controller.dart';
import '../../../consts.dart';

Widget cardStyle({
  required CardsScreenController controller,
  required RxList listName,
}) {
  return ListView.builder(
      itemCount: listName.length,
      shrinkWrap: true,
      itemBuilder: (context, i) {
        var carCard = listName[i];
        List<String> carImages = [];

        for (var item in carCard['car_images']) {
          try {
            carImages.add(item.toString());
          } catch (e) {
            // Handle the exception, or skip the item if necessary
          }
        }

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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
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
                                carCard['car_brand_logo'],
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
                                    FutureBuilder<String>(
                                      future: controller.getModelName(
                                          carCard['car_brand'],
                                          carCard['car_model']),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Text('Loading...');
                                        } else if (snapshot.hasError) {
                                          return const Text('Error');
                                        } else {
                                          return Flexible(
                                            child: Text(
                                              '${controller.getdataName(carCard['car_brand'], controller.allBrands)} ${snapshot.data}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    Row(
                                      spacing: 10,
                                      children: [
                                        if (carCard['plate_number'] != '')
                                          Text(
                                            carCard['plate_number'],
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        Text(
                                          textToDate(carCard['added_date']),
                                          style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (carCard['job_status_2'] != null &&
                            carCard['job_status_2'] != '')
                          statusBox(carCard['job_status_2'], width: 100.0),
                     if(carCard['customer'] != null && carCard['customer'] != '')
                        Text(
                          controller.getdataName(
                              carCard['customer'], controller.allCustomers,
                              title: 'entity_name'),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                carImages.isNotEmpty
                    ? InkWell(
                        onTap: () {
                          controller.openImageViewer(carImages, 0);
                        },
                        child: Container(
                          height: 270,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(0),
                            child: CachedNetworkImage(
                              cacheManager: controller.customCachedManeger,
                              imageUrl: carImages[0],
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
                      icon: Icon(Icons.display_settings,
                          color: iconColorForCardBottomBar),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      label: Text('Share', style: textStyleForCardBottomBar),
                      icon: Icon(Icons.ios_share,
                          color: iconColorForCardBottomBar),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      });
}


// Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Customer:',
//                           style: TextStyle(
//                             fontSize: 19,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black54,
//                           ),
//                         ),
//                         FittedBox(
//                           child: Text(
//                             '${carCard['customer']}',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               color: Colors.black54,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         const Text(
//                           'Car:',
//                           style: TextStyle(
//                             fontSize: 19,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black54,
//                           ),
//                         ),
//                         Text(
//                           '${carCard['car_brand']} | ${carCard['car_model']}',
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.black54,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         const Text(
//                           'Plate Number:',
//                           style: TextStyle(
//                             fontSize: 19,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black54,
//                           ),
//                         ),
//                         FittedBox(
//                           child: Text(
//                             '${carCard['plate_number']}',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               color: Colors.black54,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Received On:',
//                           style: TextStyle(
//                             fontSize: 19,
//                             fontWeight: FontWeight.bold,
//                             color: mainColor,
//                           ),
//                         ),
//                         Text(
//                           textToDate(carCard['added_date']),
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.black54,
//                           ),
//                         ),
//                         const SizedBox(height: 15),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Container(
//                               width: 70,
//                               height: 30,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(25),
//                                   color: color
//                                   // carCard['status'] == true
//                                   //     ? const Color.fromARGB(255, 50, 212, 56)
//                                   //     : Colors.grey,
//                                   ),
//                               child: Center(
//                                   child: Text(
//                                 status,
//                                 style: const TextStyle(color: Colors.white),
//                               )
//                                   //  carCard['label'] == true
//                                   //     ? const Text(
//                                   //         'New',
//                                   //         style: TextStyle(color: Colors.white),
//                                   //       )
//                                   //     : const Text(
//                                   //         'Added',
//                                   //         style: TextStyle(color: Colors.white),
//                                   //       ),
//                                   ),
//                             ),
//                             const SizedBox(
//                               width: 20,
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 controller.shareToSocialMedia(
//                                   'Dear ${carCard['customer_name']},\n\nWe are pleased to inform you that we have received your car. Here are its details:\n\nBrand & Model: ${carCard['car_brand']}, ${carCard['car_model']}\nPlate:  ${carCard['plate_number']}\nMileage: ${carCard['car_mileage']} km\nChassis No.: ${carCard['chassis_number']}\nColor:  ${carCard['color']}\nReceived on: ${carCard['date']}\nShould you have any queries, please do not hesitate to reach out. Thank you for trusting us with your vehicle.\n\nWarm regards,\nCompass Automatic Gear',
//                                 );
//                               },
//                               icon: Icon(
//                                 Icons.share,
//                                 color: mainColor,
//                                 size: 35,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),