import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';

import '../../../Controllers/Mobile section controllers/cards_screen_controller.dart';
import '../../../consts.dart';
import '../../drop_down_menu3.dart';
import '../../my_text_field.dart';
import 'break_and_tire_wheel.dart';
import 'check_box_section.dart';

Padding buildInspectionReportBody(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(3),
    child: ListView(
      children: [
        labelContainer(
            lable: Text(
          'MAIN DETAILS',
          style: fontStyle1,
        )),
        GetX<CardsScreenController>(builder: (controller) {
          bool techniciansLoading = controller.allTechnicians.isEmpty;

          return Container(
            padding: EdgeInsets.all(10),
            decoration: containerDecor,
            child: Column(
              spacing: 10,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomDropdown(
                        textcontroller: controller.technicianName.value.text,
                        showedSelectedName: 'name',
                        hintText: 'Technician',
                        items:
                            techniciansLoading ? {} : controller.allTechnicians,
                        itemBuilder: (context, key, value) {
                          return ListTile(
                            title: Text(value['name']),
                          );
                        },
                        onChanged: (key, value) {
                          controller.technicianId.value = key;
                        },
                      ),
                    ),
                    Expanded(
                        child: myTextFormFieldWithBorder(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  controller.selectDateContext(
                                      context, controller.date);
                                },
                                icon: Icon(Icons.date_range)),
                            labelText: 'Date',
                            isDate: true,
                            controller: controller.date))
                  ],
                ),
                GetX<CardsScreenController>(builder: (controller) {
                  bool customerLoading = controller.allCustomers.isEmpty;
                  return CustomDropdown(
                    textcontroller: controller.customer.text,
                    showedSelectedName: 'entity_name',
                    hintText: 'Customer',
                    items: customerLoading ? {} : controller.allCustomers,
                    itemBuilder: (context, key, value) {
                      return ListTile(
                        title: Text(value['entity_name']),
                      );
                    },
                    onChanged: (key, value) {
                      controller.customerId.value = key;
                      controller.onSelectForCustomers(key);
                    },
                  );
                }),
                GetX<CardsScreenController>(builder: (controller) {
                  bool brandsLoading = controller.allBrands.isEmpty;
                  bool modelLoading = controller.allModels.isEmpty;

                  return Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: CustomDropdown(
                          showedSelectedName: 'name',
                          hintText: 'Brand',
                          textcontroller: controller.brand.text,
                          items: brandsLoading ? {} : controller.allBrands,
                          itemBuilder: (context, key, value) {
                            return ListTile(
                              title: Text(value['name']),
                            );
                          },
                          onChanged: (key, value) {
                            controller.carBrandLogo.value = value['logo'];
                            controller.getModelsByCarBrand(key);
                            controller.model.clear();
                            controller.brandId.value = key;
                            controller.brand.text = value['name'];
                          },
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: CustomDropdown(
                            showedSelectedName: 'name',
                            hintText: 'Model',
                            textcontroller: controller.model.text,
                            items: modelLoading ? {} : controller.allModels,
                            itemBuilder: (context, key, value) {
                              return ListTile(
                                title: Text(value['name']),
                              );
                            },
                            onChanged: (key, value) {
                              controller.modelId.value = key;
                            },
                          ))
                    ],
                  );
                }),
                GetX<CardsScreenController>(builder: (controller) {
                  bool isColorsLoading = controller.allColors.isEmpty;
                  return Row(
                    spacing: 10,
                    children: [
                      Expanded(
                          child: CustomDropdown(
                        hintText: 'Color',
                        showedSelectedName: 'name',
                        textcontroller: controller.color.text,
                        items: isColorsLoading ? {} : controller.allColors,
                        itemBuilder: (context, key, value) {
                          return ListTile(
                            title: Text(value['name']),
                          );
                        },
                        onChanged: (key, value) {
                          controller.colorId.value = key;
                        },
                      )),
                      Expanded(
                        child: myTextFormFieldWithBorder(
                            labelText: 'Plate Number',
                            controller: controller.plateNumber),
                      ),
                      Expanded(
                        child: myTextFormFieldWithBorder(
                            labelText: 'Code', controller: controller.code),
                      ),
                    ],
                  );
                }),
                GetX<CardsScreenController>(builder: (controller) {
                  bool isEngineLoading = controller.allEngineTypes.isEmpty;
                  return Column(
                    spacing: 10,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          Expanded(
                              child: CustomDropdown(
                            hintText: 'Engine Type',
                            showedSelectedName: 'name',
                            textcontroller: controller.engineType.text,
                            items: isEngineLoading
                                ? {}
                                : controller.allEngineTypes,
                            itemBuilder: (context, key, value) {
                              return ListTile(
                                title: Text(value['name']),
                              );
                            },
                            onChanged: (key, value) {
                              controller.engineTypeId.value = key;
                            },
                          )),
                          Expanded(
                            child: myTextFormFieldWithBorder(
                                isnumber: true,
                                labelText: 'Year',
                                keyboardType: TextInputType.number,
                                controller: controller.year),
                          ),
                          Expanded(
                            child: myTextFormFieldWithBorder(
                                isDouble: true,
                                labelText: 'Mileage',
                                keyboardType: TextInputType.number,
                                controller: controller.mileage),
                          )
                        ],
                      ),
                      myTextFormFieldWithBorder(
                          labelText: 'VIN Number', controller: controller.vin),
                    ],
                  );
                })
              ],
            ),
          );
        }),
        SizedBox(height: 10),
        labelContainer(
            lable: Text(
          'BREAK AND TIRE',
          style: fontStyle1,
        )),
        Container(
          padding: EdgeInsets.all(10),
          decoration: containerDecor,
          child: Column(
            spacing: 10,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      hintSection(hint: 'Checked And Ok', color: Colors.green),
                      hintSection(
                          hint: 'May Need Future Attention',
                          color: Colors.yellow),
                      hintSection(
                          hint: 'Requires Immediate Attention',
                          color: Colors.red),
                    ],
                  ),
                  Image.asset(
                    'assets/car_wheel.png',
                    width: 70,
                  )
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Left Front',
                        style: textStyleForInspectionHints,
                      ),
                      Text(
                        'Right Front',
                        style: textStyleForInspectionHints,
                      ),
                    ],
                  ),
                  GetBuilder<CardsScreenController>(builder: (controller) {
                    return Row(
                      spacing: 4,
                      children: [
                        Expanded(
                          child: breakAndTireWheel(
                              brakeLiningTextcontroller:
                                  controller.leftFrontBrakeLining,
                              tireTreadTextController:
                                  controller.leftFrontTireTread,
                              wearPatternTextController:
                                  controller.leftFrontWearPattern,
                              tirePressureBeforeTextController:
                                  controller.leftFrontTirePressureBefore,
                              tirePressureAfterTextController:
                                  controller.leftFrontTirePressureAfter,
                              dataMap: controller
                                  .selectedCheckBoxIndicesForLeftFront),
                        ),
                        Expanded(
                            child: breakAndTireWheel(
                                brakeLiningTextcontroller:
                                    controller.rightFrontBrakeLining,
                                tireTreadTextController:
                                    controller.rightFrontTireTread,
                                wearPatternTextController:
                                    controller.rightFrontWearPattern,
                                tirePressureBeforeTextController:
                                    controller.rightFrontTirePressureBefore,
                                tirePressureAfterTextController:
                                    controller.rightFrontTirePressureAfter,
                                dataMap: controller
                                    .selectedCheckBoxIndicesForRightFront))
                      ],
                    );
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Left Rear',
                        style: textStyleForInspectionHints,
                      ),
                      Text(
                        'Right Rear',
                        style: textStyleForInspectionHints,
                      ),
                    ],
                  ),
                  GetBuilder<CardsScreenController>(builder: (controller) {
                    return Row(
                      spacing: 4,
                      children: [
                        Expanded(
                          child: breakAndTireWheel(
                              brakeLiningTextcontroller:
                                  controller.leftRearBrakeLining,
                              tireTreadTextController:
                                  controller.leftRearTireTread,
                              wearPatternTextController:
                                  controller.leftRearWearPattern,
                              tirePressureBeforeTextController:
                                  controller.leftRearTirePressureBefore,
                              tirePressureAfterTextController:
                                  controller.leftRearTirePressureAfter,
                              dataMap: controller
                                  .selectedCheckBoxIndicesForLeftRear),
                        ),
                        Expanded(
                            child: breakAndTireWheel(
                                brakeLiningTextcontroller:
                                    controller.rightRearBrakeLining,
                                tireTreadTextController:
                                    controller.rightRearTireTread,
                                wearPatternTextController:
                                    controller.rightRearWearPattern,
                                tirePressureBeforeTextController:
                                    controller.rightRearTirePressureBefore,
                                tirePressureAfterTextController:
                                    controller.rightRearTirePressureAfter,
                                dataMap: controller
                                    .selectedCheckBoxIndicesForRightRear))
                      ],
                    );
                  }),
                ],
              )
            ],
          ),
        ),
        SizedBox(height: 10),
        labelContainer(
            lable: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PRIOR BODY DAMAGE',
              style: fontStyle1,
            ),
            GetBuilder<CardsScreenController>(builder: (controller) {
              return controller.damagePoints.isNotEmpty &&
                      controller.inEditMode.isFalse
                  ? IconButton(
                      onPressed: () {
                        controller.removeLastMark();
                      },
                      icon: Icon(
                        Icons.repartition_outlined,
                        color: Colors.white,
                      ))
                  : SizedBox();
            })
          ],
        )),
        Container(
          padding: EdgeInsets.all(10),
          decoration: containerDecor,
          child: Column(
            children: [
              GetBuilder<CardsScreenController>(builder: (controller) {
                return controller.inEditMode.isFalse
                    ? LayoutBuilder(builder: (context, constraints) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (controller.repaintBoundaryKey.currentContext !=
                              null) {
                            controller.updateDamagePoints();
                            // Optionally, call your image capture function here
                          }
                        });
                        return GestureDetector(
                          onTapDown: (details) =>
                              controller.addDamagePoint(details),
                          child: RepaintBoundary(
                            key: controller.repaintBoundaryKey,
                            child: Stack(
                              children: [
                                Image.asset(
                                  'assets/vehicle.jpg',
                                  width: constraints.maxWidth,
                                  height: 500,
                                  key: controller.imageKey,
                                ),
                                CustomPaint(
                                  size: Size(constraints.maxWidth, 500),
                                  painter:
                                      DamagePainter(controller.damagePoints),
                                  child: SizedBox(
                                      width: constraints.maxWidth, height: 500),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                    : CachedNetworkImage(
                        cacheManager: controller.customCachedManeger,
                        progressIndicatorBuilder: (context, url, progress) =>
                            Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              value: progress.progress,
                              color: mainColor,
                              strokeWidth: 3,
                            ),
                          ),
                        ),
                        imageUrl: controller.carDialogImageURL.value,
                        key: UniqueKey(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      );
              })
            ],
          ),
        ),
        SizedBox(height: 10),
        labelContainer(
            lable: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'CAR IMAGES',
              style: fontStyle1,
            ),
            kIsWeb
                ? SizedBox()
                : GetBuilder<CardsScreenController>(builder: (controller) {
                    return Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              controller.takePhoto('Gallery');
                            },
                            icon: Icon(
                              Icons.image,
                              color: Colors.white,
                            )),
                        IconButton(
                            onPressed: () {
                              controller.takePhoto('Camera');
                            },
                            icon: Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                            )),
                      ],
                    );
                  })
          ],
        )),
        GetX<CardsScreenController>(builder: (controller) {
          return Container(
            padding: EdgeInsets.all(10),
            decoration: containerDecor,
            child: controller.imagesList.isNotEmpty ||
                    controller.carImagesURLs.isNotEmpty
                ? GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.inEditMode.isFalse
                        ? controller.imagesList.length
                        : controller.carImagesURLs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                    ),
                    itemBuilder: (context, i) {
                      return InkWell(
                        onTap: () {
                          controller.openImageViewer(
                              controller.inEditMode.isFalse
                                  ? controller.imagesList
                                  : controller.carImagesURLs,
                              i);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(3),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  clipBehavior: Clip.hardEdge,
                                  child: controller.inEditMode.isFalse
                                      ? Image.file(
                                          File(controller.imagesList[i].path),
                                        )
                                      : CachedNetworkImage(
                                          cacheManager:
                                              controller.customCachedManeger,
                                          progressIndicatorBuilder:
                                              (context, url, progress) =>
                                                  Padding(
                                            padding: const EdgeInsets.all(30.0),
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                value: progress.progress,
                                                color: mainColor,
                                                strokeWidth: 3,
                                              ),
                                            ),
                                          ),
                                          imageUrl: controller.carImagesURLs[i],
                                          key: UniqueKey(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                    onPressed: () {
                                      controller.inEditMode.isFalse
                                          ? controller.imagesList.removeAt(i)
                                          : controller.carImagesURLs
                                              .removeAt(i);
                                    },
                                    icon: const Icon(
                                      Icons.remove_circle,
                                      color: Colors.red,
                                    )),
                              )
                            ],
                          ),
                        ),
                      );
                    })
                : SizedBox(
                    height: 100,
                    child: Center(
                      child: Text(
                        'Images',
                        style: textStyleForInspectionHints,
                      ),
                    ),
                  ),
          );
        }),
        SizedBox(height: 10),
        GetX<CardsScreenController>(builder: (controller) {
          return controller.inEditMode.isTrue &&
                  controller.imagesList.isNotEmpty
              ? labelContainer(
                  lable: Text(
                  'NEW IMAGES',
                  style: fontStyle1,
                ))
              : SizedBox();
        }),
        GetX<CardsScreenController>(builder: (controller) {
          return controller.inEditMode.isTrue &&
                  controller.imagesList.isNotEmpty
              ? Container(
                  padding: EdgeInsets.all(10),
                  decoration: containerDecor,
                  child: controller.imagesList.isNotEmpty
                      ? GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.imagesList.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                          ),
                          itemBuilder: (context, i) {
                            return InkWell(
                              onTap: () {
                                controller.openImageViewer(
                                    controller.imagesList, i);
                              },
                              child: Container(
                                margin: const EdgeInsets.all(3),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: FittedBox(
                                          fit: BoxFit.cover,
                                          clipBehavior: Clip.hardEdge,
                                          child: Image.file(
                                            File(controller.imagesList[i].path),
                                          )),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                          onPressed: () {
                                            controller.imagesList.removeAt(i);
                                          },
                                          icon: const Icon(
                                            Icons.remove_circle,
                                            color: Colors.red,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            );
                          })
                      : SizedBox(
                          height: 100,
                          child: Center(
                            child: Text(
                              'Images',
                              style: textStyleForInspectionHints,
                            ),
                          ),
                        ),
                )
              : SizedBox();
        }),
        SizedBox(height: 10),
        labelContainer(
            lable: Text(
          'INTERIOIR / EXTERIOIR',
          style: fontStyle1,
        )),
        Container(
          padding: EdgeInsets.all(10),
          decoration: containerDecor,
          child: GetBuilder<CardsScreenController>(builder: (controller) {
            return Column(
                spacing: 10,
                children: List.generate(
                    controller.entrioirExterioirList.length,
                    (item) => checkBoxesSection(
                        label: controller.entrioirExterioirList[item],
                        dataMap: controller
                            .selectedCheckBoxIndicesForInteriorExterior)));
          }),
        ),
        SizedBox(height: 10),
        labelContainer(
            lable: Text(
          'UNDER VEHICLE',
          style: fontStyle1,
        )),
        Container(
          padding: EdgeInsets.all(10),
          decoration: containerDecor,
          child: GetBuilder<CardsScreenController>(builder: (controller) {
            return Column(
              spacing: 10,
              children: List.generate(
                  controller.underVehicleList.length,
                  (item) => checkBoxesSection(
                      label: controller.entrioirExterioirList[item],
                      dataMap:
                          controller.selectedCheckBoxIndicesForUnderVehicle)),
            );
          }),
        ),
        labelContainer(
            lable: Text(
          'UNDER HOOD',
          style: fontStyle1,
        )),
        Container(
          padding: EdgeInsets.all(10),
          decoration: containerDecor,
          child: GetBuilder<CardsScreenController>(builder: (controller) {
            return Column(
              spacing: 10,
              children: List.generate(
                  controller.underHoodList.length,
                  (item) => checkBoxesSection(
                      label: controller.underHoodList[item],
                      dataMap: controller.selectedCheckBoxIndicesForUnderHood)),
            );
          }),
        ),
        labelContainer(
            lable: Text(
          'BATTERY PERFORMANCE',
          style: fontStyle1,
        )),
        Container(
          padding: EdgeInsets.all(10),
          decoration: containerDecor,
          child: GetBuilder<CardsScreenController>(builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  spacing: 10,
                  children: List.generate(
                      controller.underHoodList.length,
                      (item) => checkBoxesSection(
                          label: controller.underHoodList[item],
                          dataMap: controller
                              .selectedCheckBoxIndicesForBatteryPerformance)),
                ),
                Text('Battery Cold Cranking Amps',
                    style: textStyleForInspectionHints),
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: myTextFormFieldWithBorder(
                        controller:
                            controller.batteryColdCrankingAmpsFactorySpecs,
                        onChanged: (value) {
                          controller.updateEnteredField(
                              'Battery Cold Cranking Amps',
                              'Factory Specs',
                              value,
                              controller
                                  .selectedCheckBoxIndicesForBatteryPerformance);
                        },
                        isnumber: true,
                        labelText: 'Factory Specs',
                      ),
                    ),
                    Expanded(
                      child: myTextFormFieldWithBorder(
                        controller: controller.batteryColdCrankingAmpsActual,
                        onChanged: (value) {
                          controller.updateEnteredField(
                              'Battery Cold Cranking Amps',
                              'Actual',
                              value,
                              controller
                                  .selectedCheckBoxIndicesForBatteryPerformance);
                        },
                        isnumber: true,
                        labelText: 'Actual',
                      ),
                    ),
                  ],
                )
              ],
            );
          }),
        ),
        SizedBox(height: 10),
        labelContainer(
            lable: Text(
          'COMMENTS',
          style: fontStyle1,
        )),
        Container(
          padding: EdgeInsets.all(10),
          decoration: containerDecor,
          child: GetBuilder<CardsScreenController>(builder: (controller) {
            return myTextFormFieldWithBorder(
                labelText: 'Comments',
                maxLines: 5,
                controller: controller.comments);
          }),
        ),
        SizedBox(height: 10),
        labelContainer(
            lable: Text(
          'SIGNATURES',
          style: fontStyle1,
        )),
        GetBuilder<CardsScreenController>(builder: (controller) {
          return LayoutBuilder(builder: (context, constraints) {
            return Container(
              // height: 500,
              padding: EdgeInsets.all(10),
              decoration: containerDecor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 10,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Advisor', style: textStyleForInspectionHints),
                            controller.inEditMode.isFalse
                                ? IconButton(
                                    visualDensity: VisualDensity.compact,
                                    onPressed: () {
                                      controller.signatureControllerForAdvisor
                                          .clear();
                                    },
                                    icon: Icon(
                                      Icons.clear,
                                      color: Colors.grey.shade700,
                                    ))
                                : SizedBox()
                          ],
                        ),
                        Container(
                          // width: constraints.maxWidth / 2.2,
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          child: controller.inEditMode.isFalse
                              ? Signature(
                                  height: 250,
                                  controller:
                                      controller.signatureControllerForAdvisor,
                                  backgroundColor: Colors.white,
                                )
                              : Image.network(
                                  width: double.infinity, height: 250,
                                  errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.error,
                                      color: Colors.red); // Show an error icon
                                }, controller.advisorSignatureURL.value),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Customer',
                                style: textStyleForInspectionHints),
                            controller.inEditMode.isFalse
                                ? IconButton(
                                    visualDensity: VisualDensity.compact,
                                    onPressed: () {
                                      controller.signatureControllerForCustomer
                                          .clear();
                                    },
                                    icon: Icon(
                                      Icons.clear,
                                      color: Colors.grey.shade700,
                                    ))
                                : SizedBox()
                          ],
                        ),
                        Container(
                          // width: constraints.maxWidth / 2.2,
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          child: controller.inEditMode.isFalse
                              ? Signature(
                                  height: 250,
                                  controller:
                                      controller.signatureControllerForCustomer,
                                  backgroundColor: Colors.white,
                                )
                              : Image.network(
                                  width: double.infinity, height: 250,
                                  errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.error,
                                      color: Colors.red); // Show an error icon
                                }, controller.customerSignatureURL.value),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        }),
      ],
    ),
  );
}

class DamagePainter extends CustomPainter {
  final List<Offset> points;

  DamagePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (var point in points) {
      canvas.drawCircle(point, 10, paint);
    }
  }

  @override
  bool shouldRepaint(DamagePainter oldDelegate) => true;
}
