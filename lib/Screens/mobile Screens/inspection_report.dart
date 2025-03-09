import 'package:datahubai/Controllers/Mobile%20section%20controllers/cards_screen_controller.dart';
import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../Widgets/my_text_field.dart';
import '../../consts.dart';

class InspectionReposrt extends StatelessWidget {
  const InspectionReposrt({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: EdgeInsets.all(20),
              decoration: containerDecor,
              child: Column(
                spacing: 10,
                children: [
                  GetX<CardsScreenController>(builder: (controller) {
                    bool techniciansLoading = controller.allTechnicians.isEmpty;
                    return CustomDropdown(
                      textcontroller: controller.technicianName.text,
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

                    return CustomDropdown(
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
                    );
                  }),
                  GetX<CardsScreenController>(builder: (controller) {
                    bool modelLoading = controller.allModels.isEmpty;

                    return CustomDropdown(
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
                    );
                  }),
                  GetBuilder<CardsScreenController>(builder: (controller) {
                    return Column(
                      spacing: 10,
                      children: [
                        myTextFormFieldWithBorder(
                            isnumber: true,
                            labelText: 'Year',
                            keyboardType: TextInputType.number,
                            controller: controller.year),
                        myTextFormFieldWithBorder(
                            labelText: 'VIN Number',
                            keyboardType: TextInputType.number,
                            controller: controller.vin),
                        myTextFormFieldWithBorder(
                            isDouble: true,
                            labelText: 'Mileage',
                            keyboardType: TextInputType.number,
                            controller: controller.mileage),
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
              padding: EdgeInsets.all(20),
              decoration: containerDecor,
              child: Column(
                spacing: 10,
                children: [
                  hintSection(hint: 'Checked And Ok', color: Colors.green),
                  hintSection(
                      hint: 'May Need Future Attention', color: Colors.yellow),
                  hintSection(
                      hint: 'Requires Immediate Attention', color: Colors.red),
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
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey)),
                              child: GetBuilder<CardsScreenController>(
                                  builder: (controller) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 5,
                                  children: [
                                    checkBoxesSection(
                                        label: 'Brake Lining',
                                        textcontroller:
                                            controller.leftFrontBrakeLining),
                                    checkBoxesSection(
                                        label: 'Tire Tread',
                                        textcontroller:
                                            controller.leftFrontTireTread),
                                    checkBoxesSection(
                                        label: 'Wear Pattern',
                                        textcontroller:
                                            controller.leftFrontWearPattern),
                                    Text(
                                      'Tire Pressure PSI',
                                      style: textStyleForInspectionHints,
                                    ),
                                    Row(
                                      spacing: 5,
                                      children: [
                                        Expanded(
                                          child: myTextFormFieldWithBorder(
                                              labelText: 'Before'),
                                        ),
                                        Expanded(
                                          child: myTextFormFieldWithBorder(
                                              labelText: 'After'),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              }),
                            ),
                          ),
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey)),
                          ))
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget checkBoxesSection(
      {required String label, required TextEditingController textcontroller}) {
    return GetBuilder<CardsScreenController>(builder: (controller) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          checkBox(
              value: controller.selectedCheckBoxIndices[label]?['status'] ==
                  'Checked And Ok',
              color: Colors.green,
              onChanged: (value) =>
                  controller.updateSelectedIndex(label, 'Checked And Ok')),
          checkBox(
              value: controller.selectedCheckBoxIndices[label]?['status'] ==
                  'May Need Future Attention',
              color: Colors.yellow,
              onChanged: (value) => controller.updateSelectedIndex(
                  label, 'May Need Future Attention')),
          checkBox(
              value: controller.selectedCheckBoxIndices[label]?['status'] ==
                  'Requires Immediate Attention',
              color: Colors.red,
              onChanged: (value) => controller.updateSelectedIndex(
                  label, 'Requires Immediate Attention')),
          Expanded(
              child: myTextFormFieldWithBorder(
                  labelText: label,
                  controller: textcontroller,
                  onChanged: (value) {
                    print(controller.selectedCheckBoxIndices);
                    controller.selectedCheckBoxIndices[label]?.addAll({'value':value});
                  }))
        ],
      );
    });
  }

  Checkbox checkBox(
      {required bool value,
      required Color color,
      required void Function(bool?)? onChanged}) {
    return Checkbox(
        checkColor: mainColor,
        fillColor:
            WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return color;
          }
          return color;
        }),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        value: value,
        onChanged: onChanged);
  }
}
