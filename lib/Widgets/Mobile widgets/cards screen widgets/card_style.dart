import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Mobile section controllers/cards_screen_controller.dart';
import '../../../Models/car_card_model.dart';
import '../../../Screens/mobile Screens/card_details_screen.dart';
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

        return Card(
          surfaceTintColor: Colors.white,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () async {
              var carData = carCard.data() as Map<String, dynamic>;
              String carBrandName = carCard['car_brand'] != ''
                  ? controller.getdataName(
                      carCard['car_brand'], controller.allBrands)
                  : '';
              String carModelName = carCard['car_brand'] != ''
                  ? await controller.getModelName(
                      carCard['car_brand'], carCard['car_model'])
                  : '';
              String customerName = carCard['customer'] != ''
                  ? controller.getdataName(
                      carCard['customer'], controller.allCustomers,
                      title: 'entity_name')
                  : '';
              String carColor = carCard['color'] != ''
                  ? controller.getdataName(
                      carCard['color'], controller.allColors)
                  : '';
              String technician = carCard['technician'] != ''
                  ? controller.getdataName(
                      carCard['technician'], controller.allTechnicians)
                  : '';
              String engineType = carCard['engine_type'] != ''
                  ? controller.getdataName(
                      carCard['engine_type'], controller.allEngineTypes)
                  : '';
              Get.to(() => CarDetailsScreen(),
                  arguments: CarCardModel(
                    vin: carCard['vehicle_identification_number']?.toString() ??
                        '',
                    engineType: engineType,
                    technician: technician,
                    year: carData['year']?.toString() ?? '',
                    code: carData['plate_code']?.toString() ?? '',
                    fuelAmount: double.tryParse(
                            carData['fuel_amount']?.toString() ?? '') ??
                        0,
                    data: carData,
                    carImages: List<String>.from(carData['car_images'] ?? []),
                    customerSignature:
                        carData['customer_signature']?.toString() ?? '',
                    advisorSignature:
                        carData['advisor_signature']?.toString() ?? '',
                    carBrand: carBrandName,
                    carMileage: carData['mileage_in']?.toString() ?? '',
                    carModel: carModelName,
                    chassisNumber:
                        carData['vehicle_identification_number']?.toString() ??
                            '',
                    color: carColor,
                    customerName: customerName,
                    date: carData['added_date']?.toString() ?? '',
                    emailAddress: carData['contact_email']?.toString() ?? '',
                    phoneNumber: carData['contact_number']?.toString() ?? '',
                    plateNumber: carData['plate_number']?.toString() ?? '',
                    comments:
                        carData['inspection_report_comments']?.toString() ?? '',
                    docID:
                        carCard.id, // Document ID is directly from the snapshot
                    status1: carData['job_status_1']?.toString() ?? '',
                    status2: carData['job_status_2']?.toString() ?? '',
                  ),
                  transition: Transition.leftToRight);
            },
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FutureBuilder<String>(
                          future: controller.getModelName(
                              carCard['car_brand'], carCard['car_model']),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text('Loading...');
                            } else if (snapshot.hasError) {
                              return const Text('Error');
                            } else {
                              return Flexible(
                                child: Text(
                                  '${controller.getdataName(carCard['car_brand'], controller.allBrands)} | ${snapshot.data}',
                                  style:
                                      textStyleForCardsLabelsCarBrandAndModel,
                                ),
                              );
                            }
                          },
                        ),
                        carCard['job_status_2'] != ''
                            ? Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 4),
                                width: null,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: secColor, width: 3),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(carCard['job_status_2'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19,
                                        color: carCard['job_status_2'] ==
                                                'Posted'
                                            ? Colors.blueGrey
                                            : carCard['job_status_2'] == 'New'
                                                ? Colors.green
                                                : carCard['job_status_2'] ==
                                                            'Warranty' ||
                                                        carCard['job_status_2'] ==
                                                            'Closed'
                                                    ? Colors.black
                                                    : carCard['job_status_2'] ==
                                                            'Approved'
                                                        ? Color(0xffD2665A)
                                                        : carCard['job_status_2'] ==
                                                                'Ready'
                                                            ? Color(0xff7886C7)
                                                            : Colors.red)),
                              )
                            : SizedBox()
                      ],
                    ),
                    Text('Customer', style: textStyleForCardsLabels),
                    Text(
                        controller.getdataName(
                            carCard['customer'], controller.allCustomers,
                            title: 'entity_name'),
                        style: textStyleForCardsContents),
                    SizedBox(height: 8),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Plate Number', style: textStyleForCardsLabels),
                        Text('Received On', style: textStyleForCardsLabels),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${carCard['plate_number']}',
                            style: textStyleForCardsContents),
                        Text(textToDate(carCard['added_date']),
                            style: textStyleForCardsContents),
                      ],
                    ),
                  ],
                )),
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