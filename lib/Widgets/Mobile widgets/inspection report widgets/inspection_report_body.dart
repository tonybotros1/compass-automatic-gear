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
    child: SingleChildScrollView(
      child: Column(
        children: [
          !kIsWeb
              ? Column(
                  children: [
                    labelContainer(
                      lable: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('MAIN DETAILS', style: fontStyle1),
                          GetBuilder<CardsScreenController>(
                            builder: (controller) {
                              return Text(
                                controller.jobNumber.text,
                                style: fontStyle1,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    GetX<CardsScreenController>(
                      builder: (controller) {
                        return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: containerDecor,
                          child: Column(
                            spacing: 10,
                            children: [
                              myTextFormFieldWithBorder(
                                validate: true,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    controller.selectDateContext(
                                      context,
                                      controller.date,
                                    );
                                  },
                                  icon: const Icon(Icons.date_range),
                                ),
                                labelText: 'Job Date',
                                isDate: true,
                                controller: controller.date,
                              ),
                              CustomDropdown(
                                width: double.infinity,
                                textcontroller:
                                    controller.technicianName.value.text,
                                showedSelectedName: 'name',
                                hintText: 'Technician',
                                onChanged: (key, value) {
                                  controller.technicianId.value = key;
                                },
                                onDelete: () {
                                  controller.technicianName.value.clear();
                                  controller.technicianId.value = "";
                                },
                                onOpen: () {
                                  return controller.getTechnicians();
                                },
                              ),
                              CustomDropdown(
                                width: double.infinity,
                                textcontroller: controller.customer.text,
                                showedSelectedName: 'entity_name',
                                hintText: 'Customer',
                                onChanged: (key, value) {
                                  controller.customerId.value = key;
                                  controller.onSelectForCustomers(value);
                                },
                                onDelete: () {
                                  controller.customerId.value = "";
                                  controller.customerEntityPhoneNumber.clear();
                                  controller.customerEntityName.clear();
                                  controller.customerEntityEmail.clear();
                                  controller.customerCreditNumber.clear();
                                  controller.customerSaleManId.value = '';
                                },
                                onOpen: () {
                                  return controller.getAllCustomers();
                                },
                              ),
                              CustomDropdown(
                                validator: true,
                                width: double.infinity,
                                showedSelectedName: 'name',
                                hintText: 'Brand',
                                textcontroller: controller.brand.text,
                                onChanged: (key, value) {
                                  controller.carBrandLogo.value =
                                      value['logo'] ?? '';
                                  controller.model.clear();
                                  controller.modelId.value = '';
                                  controller.getModelsByCarBrand(key);
                                  controller.brandId.value = key;
                                  controller.brand.text = value['name'];
                                },
                                onDelete: () {
                                  controller.carBrandLogo.value = '';
                                  controller.model.clear();
                                  controller.modelId.value = '';
                                  controller.allModels.clear();
                                  controller.brandId.value = '';
                                  controller.brand.text = '';
                                },
                                onOpen: () {
                                  return controller.getCarBrands();
                                },
                              ),
                              CustomDropdown(
                                validator: true,
                                width: double.infinity,
                                showedSelectedName: 'name',
                                hintText: 'Model',
                                items: controller.allModels,
                                textcontroller: controller.model.text,
                                onChanged: (key, value) {
                                  controller.model.text = value['name'];
                                  controller.modelId.value = key;
                                },
                                onDelete: () {
                                  controller.model.clear();
                                  controller.modelId.value = '';
                                },
                              ),
                              myTextFormFieldWithBorder(
                                validate: false,
                                isnumber: true,
                                labelText: 'Year',
                                keyboardType: TextInputType.number,
                                controller: controller.year,
                              ),
                              myTextFormFieldWithBorder(
                                validate: true,
                                labelText: 'Plate Number',
                                controller: controller.plateNumber,
                              ),
                              myTextFormFieldWithBorder(
                                validate: false,
                                labelText: 'VIN Number',
                                controller: controller.vin,
                              ),
                              CustomDropdown(
                                width: double.infinity,
                                hintText: 'Color',
                                showedSelectedName: 'name',
                                textcontroller: controller.color.text,
                                onChanged: (key, value) {
                                  controller.colorId.value = key;
                                },
                                onDelete: () {
                                  controller.colorId.value = '';
                                },
                                onOpen: () {
                                  return controller.getColors();
                                },
                              ),

                              myTextFormFieldWithBorder(
                                validate: false,
                                labelText: 'Plate Code',
                                controller: controller.code,
                              ),
                              myTextFormFieldWithBorder(
                                validate: false,
                                isDouble: true,
                                labelText: 'Mileage',
                                keyboardType: TextInputType.number,
                                controller: controller.mileage,
                              ),
                              CustomDropdown(
                                width: double.infinity,
                                hintText: 'Engine Type',
                                showedSelectedName: 'name',
                                textcontroller: controller.engineType.text,
                                onChanged: (key, value) {
                                  controller.engineTypeId.value = key;
                                },
                                onDelete: () {
                                  controller.engineTypeId.value = '';
                                },
                                onOpen: () {
                                  return controller.getEngineTypes();
                                },
                              ),

                              myTextFormFieldWithBorder(
                                validate: false,
                                labelText: 'Transmission Type',
                                controller: controller.transmissionType,
                              ),
                              myTextFormFieldWithBorder(
                                validate: false,
                                suffixIcon: const IconButton(
                                  onPressed: null,
                                  icon: Icon(Icons.percent_rounded, size: 15),
                                ),
                                keyboardType: TextInputType.number,
                                isnumber: true,
                                labelText: 'Fuel Amount',
                                controller: controller.fuelAmount,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                )
              : const SizedBox(),
          GetX<CardsScreenController>(
            builder: (controller) {
              return controller.canShowBodyDamage.isTrue
                  ? (controller.inEditMode.isFalse ||
                            (controller.inEditMode.isTrue &&
                                controller.carDialogImageURL.isNotEmpty))
                        ? Column(
                            children: [
                              const SizedBox(height: 10),
                              labelContainer(
                                lable: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'PRIOR BODY DAMAGE',
                                      style: fontStyle1,
                                    ),
                                    controller.damagePoints.isNotEmpty &&
                                            controller.inEditMode.isFalse
                                        ? IconButton(
                                            onPressed: () {
                                              controller.removeLastMark();
                                            },
                                            icon: const Icon(
                                              Icons.repartition_outlined,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                              Container(
                                height: 550,
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: containerDecor,
                                child: controller.inEditMode.isFalse
                                    ? InkWell(
                                        onTapDown: (details) =>
                                            controller.addDamagePoint(details),
                                        child: RepaintBoundary(
                                          key: controller.repaintBoundaryKey,
                                          child: Stack(
                                            children: [
                                              // Car image
                                              Image.asset(
                                                'assets/vehicle.jpg',
                                                width: MediaQuery.of(
                                                  context,
                                                ).size.width,
                                                height: 500,
                                                key: controller.imageKey,
                                                fit: BoxFit.contain,
                                              ),
                                              CustomPaint(
                                                size: Size(
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width,
                                                  500,
                                                ),
                                                painter: DamagePainter(
                                                  controller.damagePoints,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : CachedNetworkImage(
                                        cacheManager:
                                            controller.customCachedManeger,
                                        progressIndicatorBuilder:
                                            (context, url, progress) => Padding(
                                              padding: const EdgeInsets.all(
                                                30.0,
                                              ),
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                      value: progress.progress,
                                                      color: mainColor,
                                                      strokeWidth: 3,
                                                    ),
                                              ),
                                            ),
                                        imageUrl:
                                            controller.carDialogImageURL.value,
                                        key: UniqueKey(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                              ),
                            ],
                          )
                        : const SizedBox()
                  : const SizedBox();
            },
          ),
          const SizedBox(height: 10),
          labelContainer(
            lable: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('CAR IMAGES', style: fontStyle1),
                kIsWeb
                    ? const SizedBox()
                    : GetBuilder<CardsScreenController>(
                        builder: (controller) {
                          return Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  controller.takePhoto('Gallery');
                                },
                                icon: const Icon(
                                  Icons.image,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  controller.takePhoto('Camera');
                                },
                                icon: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ],
            ),
          ),
          GetX<CardsScreenController>(
            builder: (controller) {
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: containerDecor,
                child:
                    controller.imagesList.isNotEmpty ||
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
                                    : controller.carImagesURLs
                                          .map((img) => img.url)
                                          .toList(),
                                i,
                              );
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
                                              File(
                                                controller.imagesList[i].path,
                                              ),
                                            )
                                          : CachedNetworkImage(
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
                                              imageUrl:
                                                  controller
                                                      .carImagesURLs[i]
                                                      .url ??
                                                  '',
                                              key: UniqueKey(),
                                              errorWidget:
                                                  (context, url, error) =>
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
                                            : controller.carImagesURLs.removeAt(
                                                i,
                                              );
                                      },
                                      icon: const Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
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
            },
          ),
          const SizedBox(height: 10),
          GetX<CardsScreenController>(
            builder: (controller) {
              return controller.inEditMode.isTrue &&
                      controller.imagesList.isNotEmpty
                  ? labelContainer(lable: Text('NEW IMAGES', style: fontStyle1))
                  : const SizedBox();
            },
          ),
          GetX<CardsScreenController>(
            builder: (controller) {
              return controller.inEditMode.isTrue &&
                      controller.imagesList.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.all(10),
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
                                      controller.imagesList,
                                      i,
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(3),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                          child: FittedBox(
                                            fit: BoxFit.cover,
                                            clipBehavior: Clip.hardEdge,
                                            child: Image.file(
                                              File(
                                                controller.imagesList[i].path,
                                              ),
                                            ),
                                          ),
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
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
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
                  : const SizedBox();
            },
          ),
          GetX<CardsScreenController>(
            builder: (controller) {
              return controller.canShowBreakAndTire.isTrue
                  ? Column(
                      children: [
                        const SizedBox(height: 10),
                        labelContainer(
                          lable: Text('BREAK AND TIRE', style: fontStyle1),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: containerDecor,
                          child: Column(
                            spacing: 10,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      hintSection(
                                        hint: 'Checked And Ok',
                                        color: Colors.green,
                                      ),
                                      hintSection(
                                        hint: 'May Need Future Attention',
                                        color: Colors.yellow,
                                      ),
                                      hintSection(
                                        hint: 'Requires Immediate Attention',
                                        color: Colors.red,
                                      ),
                                    ],
                                  ),
                                  Image.asset(
                                    'assets/car_wheel.png',
                                    width: 70,
                                  ),
                                ],
                              ),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  bool isMobile =
                                      constraints.maxWidth <
                                      600; // Adjust breakpoint as needed
                                  return Column(
                                    children: [
                                      // Front Section
                                      Row(
                                        mainAxisAlignment: isMobile
                                            ? MainAxisAlignment.start
                                            : MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Left Front',
                                            style: textStyleForInspectionHints,
                                          ),
                                          if (!isMobile)
                                            Text(
                                              'Right Front',
                                              style:
                                                  textStyleForInspectionHints,
                                            ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: isMobile
                                            ? [
                                                breakAndTireWheel(
                                                  brakeLiningTextcontroller:
                                                      controller
                                                          .leftFrontBrakeLining,
                                                  tireTreadTextController:
                                                      controller
                                                          .leftFrontTireTread,
                                                  wearPatternTextController:
                                                      controller
                                                          .leftFrontWearPattern,
                                                  tirePressureBeforeTextController:
                                                      controller
                                                          .leftFrontTirePressureBefore,
                                                  tirePressureAfterTextController:
                                                      controller
                                                          .leftFrontTirePressureAfter,
                                                  dataMap: controller
                                                      .selectedCheckBoxIndicesForLeftFront,
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  'Right Front',
                                                  style:
                                                      textStyleForInspectionHints,
                                                ),
                                                breakAndTireWheel(
                                                  brakeLiningTextcontroller:
                                                      controller
                                                          .rightFrontBrakeLining,
                                                  tireTreadTextController:
                                                      controller
                                                          .rightFrontTireTread,
                                                  wearPatternTextController:
                                                      controller
                                                          .rightFrontWearPattern,
                                                  tirePressureBeforeTextController:
                                                      controller
                                                          .rightFrontTirePressureBefore,
                                                  tirePressureAfterTextController:
                                                      controller
                                                          .rightFrontTirePressureAfter,
                                                  dataMap: controller
                                                      .selectedCheckBoxIndicesForRightFront,
                                                ),
                                              ]
                                            : [
                                                Row(
                                                  spacing: 5,
                                                  children: [
                                                    Expanded(
                                                      child: breakAndTireWheel(
                                                        brakeLiningTextcontroller:
                                                            controller
                                                                .leftFrontBrakeLining,
                                                        tireTreadTextController:
                                                            controller
                                                                .leftFrontTireTread,
                                                        wearPatternTextController:
                                                            controller
                                                                .leftFrontWearPattern,
                                                        tirePressureBeforeTextController:
                                                            controller
                                                                .leftFrontTirePressureBefore,
                                                        tirePressureAfterTextController:
                                                            controller
                                                                .leftFrontTirePressureAfter,
                                                        dataMap: controller
                                                            .selectedCheckBoxIndicesForLeftFront,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: breakAndTireWheel(
                                                        brakeLiningTextcontroller:
                                                            controller
                                                                .rightFrontBrakeLining,
                                                        tireTreadTextController:
                                                            controller
                                                                .rightFrontTireTread,
                                                        wearPatternTextController:
                                                            controller
                                                                .rightFrontWearPattern,
                                                        tirePressureBeforeTextController:
                                                            controller
                                                                .rightFrontTirePressureBefore,
                                                        tirePressureAfterTextController:
                                                            controller
                                                                .rightFrontTirePressureAfter,
                                                        dataMap: controller
                                                            .selectedCheckBoxIndicesForRightFront,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                      ),
                                      const SizedBox(height: 10),

                                      // Rear Section
                                      Row(
                                        mainAxisAlignment: isMobile
                                            ? MainAxisAlignment.start
                                            : MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Left Rear',
                                            style: textStyleForInspectionHints,
                                          ),
                                          if (!isMobile)
                                            Text(
                                              'Right Rear',
                                              style:
                                                  textStyleForInspectionHints,
                                            ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: isMobile
                                            ? [
                                                breakAndTireWheel(
                                                  brakeLiningTextcontroller:
                                                      controller
                                                          .leftRearBrakeLining,
                                                  tireTreadTextController:
                                                      controller
                                                          .leftRearTireTread,
                                                  wearPatternTextController:
                                                      controller
                                                          .leftRearWearPattern,
                                                  tirePressureBeforeTextController:
                                                      controller
                                                          .leftRearTirePressureBefore,
                                                  tirePressureAfterTextController:
                                                      controller
                                                          .leftRearTirePressureAfter,
                                                  dataMap: controller
                                                      .selectedCheckBoxIndicesForLeftRear,
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  'Right Rear',
                                                  style:
                                                      textStyleForInspectionHints,
                                                ),
                                                breakAndTireWheel(
                                                  brakeLiningTextcontroller:
                                                      controller
                                                          .rightRearBrakeLining,
                                                  tireTreadTextController:
                                                      controller
                                                          .rightRearTireTread,
                                                  wearPatternTextController:
                                                      controller
                                                          .rightRearWearPattern,
                                                  tirePressureBeforeTextController:
                                                      controller
                                                          .rightRearTirePressureBefore,
                                                  tirePressureAfterTextController:
                                                      controller
                                                          .rightRearTirePressureAfter,
                                                  dataMap: controller
                                                      .selectedCheckBoxIndicesForRightRear,
                                                ),
                                              ]
                                            : [
                                                Row(
                                                  spacing: 5,
                                                  children: [
                                                    Expanded(
                                                      child: breakAndTireWheel(
                                                        brakeLiningTextcontroller:
                                                            controller
                                                                .leftRearBrakeLining,
                                                        tireTreadTextController:
                                                            controller
                                                                .leftRearTireTread,
                                                        wearPatternTextController:
                                                            controller
                                                                .leftRearWearPattern,
                                                        tirePressureBeforeTextController:
                                                            controller
                                                                .leftRearTirePressureBefore,
                                                        tirePressureAfterTextController:
                                                            controller
                                                                .leftRearTirePressureAfter,
                                                        dataMap: controller
                                                            .selectedCheckBoxIndicesForLeftRear,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: breakAndTireWheel(
                                                        brakeLiningTextcontroller:
                                                            controller
                                                                .rightRearBrakeLining,
                                                        tireTreadTextController:
                                                            controller
                                                                .rightRearTireTread,
                                                        wearPatternTextController:
                                                            controller
                                                                .rightRearWearPattern,
                                                        tirePressureBeforeTextController:
                                                            controller
                                                                .rightRearTirePressureBefore,
                                                        tirePressureAfterTextController:
                                                            controller
                                                                .rightRearTirePressureAfter,
                                                        dataMap: controller
                                                            .selectedCheckBoxIndicesForRightRear,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                              Column(
                                children: List.generate(
                                  controller
                                              .singleCheckBoxForBrakeAndTireList
                                              .length *
                                          2 -
                                      1,
                                  (index) {
                                    if (index.isEven) {
                                      int itemIndex = index ~/ 2;
                                      return singleCheckBoxesSection(
                                        label: controller
                                            .singleCheckBoxForBrakeAndTireList[itemIndex],
                                        dataMap: controller
                                            .selectedCheckBoxIndicesForSingleCheckBoxForBrakeAndTire,
                                      );
                                    } else {
                                      return const Divider();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : const SizedBox();
            },
          ),

          GetX<CardsScreenController>(
            builder: (controller) {
              return controller.canShowInteriorExterior.isTrue
                  ? Column(
                      children: [
                        const SizedBox(height: 10),

                        labelContainer(
                          lable: Text(
                            'INTERIOIR / EXTERIOIR',
                            style: fontStyle1,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: containerDecor,
                          child: Column(
                            children: List.generate(
                              controller.entrioirExterioirList.length * 2 - 1,
                              (index) {
                                if (index.isEven) {
                                  int itemIndex = index ~/ 2;
                                  return checkBoxesSection(
                                    label: controller
                                        .entrioirExterioirList[itemIndex],
                                    dataMap: controller
                                        .selectedCheckBoxIndicesForInteriorExterior,
                                  );
                                } else {
                                  return const Divider();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox();
            },
          ),

          GetX<CardsScreenController>(
            builder: (controller) {
              return controller.canShowUnderVehicle.isTrue
                  ? Column(
                      children: [
                        const SizedBox(height: 10),

                        labelContainer(
                          lable: Text('UNDER VEHICLE', style: fontStyle1),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: containerDecor,
                          child: Column(
                            children: List.generate(
                              controller.underVehicleList.length * 2 - 1,
                              (index) {
                                if (index.isEven) {
                                  int itemIndex = index ~/ 2;
                                  return checkBoxesSection(
                                    label:
                                        controller.underVehicleList[itemIndex],
                                    dataMap: controller
                                        .selectedCheckBoxIndicesForUnderVehicle,
                                  );
                                } else {
                                  return const Divider();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox();
            },
          ),

          GetX<CardsScreenController>(
            builder: (controller) {
              return controller.canShowUnderHood.isTrue
                  ? Column(
                      children: [
                        const SizedBox(height: 10),

                        labelContainer(
                          lable: Text('UNDER HOOD', style: fontStyle1),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: containerDecor,
                          child: Column(
                            children: List.generate(
                              controller.underHoodList.length * 2 - 1,
                              (index) {
                                if (index.isEven) {
                                  int itemIndex = index ~/ 2;
                                  return checkBoxesSection(
                                    label: controller.underHoodList[itemIndex],
                                    dataMap: controller
                                        .selectedCheckBoxIndicesForUnderHood,
                                  );
                                } else {
                                  return const Divider();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox();
            },
          ),

          GetX<CardsScreenController>(
            builder: (controller) {
              return controller.canShowBatteryPerformance.isTrue
                  ? Column(
                      children: [
                        const SizedBox(height: 10),

                        labelContainer(
                          lable: Text('BATTERY PERFORMANCE', style: fontStyle1),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: containerDecor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: List.generate(
                                  controller.batteryPerformanceList.length * 2 -
                                      1,
                                  (index) {
                                    if (index.isEven) {
                                      int itemIndex = index ~/ 2;
                                      return checkBoxesSection(
                                        label: controller
                                            .batteryPerformanceList[itemIndex], // Corrected label
                                        dataMap: controller
                                            .selectedCheckBoxIndicesForBatteryPerformance,
                                      );
                                    } else {
                                      return const Divider();
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Battery Cold Cranking Amps',
                                style: textStyleForInspectionHints,
                              ),
                              Row(
                                spacing: 10,
                                children: [
                                  Expanded(
                                    child: myTextFormFieldWithBorder(
                                      controller: controller
                                          .batteryColdCrankingAmpsFactorySpecs,
                                      onChanged: (value) {
                                        controller.updateEnteredField(
                                          'Battery Cold Cranking Amps',
                                          'Factory Specs',
                                          value,
                                          controller
                                              .selectedCheckBoxIndicesForBatteryPerformance,
                                        );
                                      },
                                      isnumber: true,
                                      labelText: 'Factory Specs',
                                    ),
                                  ),
                                  Expanded(
                                    child: myTextFormFieldWithBorder(
                                      controller: controller
                                          .batteryColdCrankingAmpsActual,
                                      onChanged: (value) {
                                        controller.updateEnteredField(
                                          'Battery Cold Cranking Amps',
                                          'Actual',
                                          value,
                                          controller
                                              .selectedCheckBoxIndicesForBatteryPerformance,
                                        );
                                      },
                                      isnumber: true,
                                      labelText: 'Actual',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : const SizedBox();
            },
          ),

          const SizedBox(height: 10),
          labelContainer(lable: Text('COMMENTS', style: fontStyle1)),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: containerDecor,
            child: GetBuilder<CardsScreenController>(
              builder: (controller) {
                return myTextFormFieldWithBorder(
                  labelText: 'Comments',
                  maxLines: 5,
                  controller: controller.comments,
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          labelContainer(lable: Text('SIGNATURES', style: fontStyle1)),
          GetBuilder<CardsScreenController>(
            builder: (controller) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    // height: 500,
                    padding: const EdgeInsets.all(10),
                    decoration: containerDecor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 10,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Advisor',
                                    style: textStyleForInspectionHints,
                                  ),
                                  controller.inEditMode.isFalse
                                      ? IconButton(
                                          visualDensity: VisualDensity.compact,
                                          onPressed: () {
                                            controller
                                                .signatureControllerForAdvisor
                                                .clear();
                                          },
                                          icon: Icon(
                                            Icons.clear,
                                            color: Colors.grey.shade700,
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                              Container(
                                // width: constraints.maxWidth / 2.2,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                ),
                                child: controller.inEditMode.isFalse
                                    ? Signature(
                                        height: 250,
                                        controller: controller
                                            .signatureControllerForAdvisor,
                                        backgroundColor: Colors.white,
                                      )
                                    : Image.network(
                                        width: double.infinity,
                                        height: 250,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.error,
                                                color: Colors.red,
                                              ); // Show an error icon
                                            },
                                        controller.advisorSignatureURL.value,
                                      ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Customer',
                                    style: textStyleForInspectionHints,
                                  ),
                                  controller.inEditMode.isFalse
                                      ? IconButton(
                                          visualDensity: VisualDensity.compact,
                                          onPressed: () {
                                            controller
                                                .signatureControllerForCustomer
                                                .clear();
                                          },
                                          icon: Icon(
                                            Icons.clear,
                                            color: Colors.grey.shade700,
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                              Container(
                                // width: constraints.maxWidth / 2.2,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                ),
                                child: controller.inEditMode.isFalse
                                    ? Signature(
                                        height: 250,
                                        controller: controller
                                            .signatureControllerForCustomer,
                                        backgroundColor: Colors.white,
                                      )
                                    : Image.network(
                                        width: double.infinity,
                                        height: 250,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.error,
                                                color: Colors.red,
                                              ); // Show an error icon
                                            },
                                        controller.customerSignatureURL.value,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
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
