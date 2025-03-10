import 'package:datahubai/Controllers/Mobile%20section%20controllers/cards_screen_controller.dart';
import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/Mobile widgets/inspection report widgets/break_and_tire_wheel.dart';
import '../../Widgets/my_text_field.dart';
import '../../consts.dart';

class InspectionReposrt extends StatelessWidget {
  const InspectionReposrt({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Inspection Report',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(3),
        child: ListView(
          children: [
            labelContainer(
                lable: Text(
              'Main Details',
              style: fontStyle1,
            )),
            Container(
              padding: EdgeInsets.all(10),
              decoration: containerDecor,
              child: Column(
                spacing: 10,
                children: [
                  GetX<CardsScreenController>(builder: (controller) {
                    bool techniciansLoading = controller.allTechnicians.isEmpty;
                    return Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          flex: 2,
                          child: CustomDropdown(
                            textcontroller: controller.technicianName.text,
                            showedSelectedName: 'name',
                            hintText: 'Technician',
                            items: techniciansLoading
                                ? {}
                                : controller.allTechnicians,
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
                    );
                  }),
                  GetX<CardsScreenController>(builder: (controller) {
                    bool customerLoading = controller.allCustomers.isEmpty;
                    return CustomDropdown(
                      textcontroller: controller.customerName.text,
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
                              controller.getModelsByCarBrand(key);
                              controller.model.clear();

                              controller.brandId.value = key;
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
                  GetBuilder<CardsScreenController>(builder: (controller) {
                    return Column(
                      spacing: 10,
                      children: [
                        Row(
                          spacing: 10,
                          children: [
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
                            labelText: 'VIN Number',
                            keyboardType: TextInputType.number,
                            controller: controller.vin),
                      ],
                    );
                  })
                ],
              ),
            ),
            SizedBox(height: 10),
            labelContainer(
                lable: Text(
              'Break And Tire',
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
                          hintSection(
                              hint: 'Checked And Ok', color: Colors.green),
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
                                  dataMap: controller
                                      .selectedCheckBoxIndicesForLeftFront),
                            ),
                            Expanded(
                                child: breakAndTireWheel(
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
                                  dataMap: controller
                                      .selectedCheckBoxIndicesForLeftRear),
                            ),
                            Expanded(
                                child: breakAndTireWheel(
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
                lable: Text(
              'Prior Body Damage',
              style: fontStyle1,
            )),
            LayoutBuilder(builder: (context, constraints) {
              return Container(
                padding: EdgeInsets.all(10),
                decoration: containerDecor,
                child: Column(
                  children: [
                    GetBuilder<CardsScreenController>(builder: (controller) {
                      return GestureDetector(
                        onTapDown: (details) =>
                            controller.addDamagePoint(context, details),
                        child: RepaintBoundary(
                          key: controller.repaintBoundaryKey,
                          child: Stack(
                            children: [
                              Image.asset('assets/vehicle.jpg',
                                  width: constraints.maxWidth, height: 500),
                              CustomPaint(
                                size: Size(constraints.maxWidth, 500),
                                painter: DamagePainter(controller.damagePoints),
                                child: SizedBox(
                                    width: constraints.maxWidth, height: 500),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
  }
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
