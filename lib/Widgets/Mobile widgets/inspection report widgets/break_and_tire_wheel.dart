
  import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Mobile section controllers/cards_screen_controller.dart';
import '../../../consts.dart';
import '../../my_text_field.dart';
import 'check_box_section.dart';

Widget breakAndTireWheel(
      {required RxMap<String, Map<String, String>> dataMap}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey)),
          child: GetBuilder<CardsScreenController>(builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                checkBoxesSection(
                    dataMap: dataMap,
                    label: 'Brake Lining',
                    textcontroller: controller.leftFrontBrakeLining),
                checkBoxesSection(
                    dataMap: dataMap,
                    label: 'Tire Tread',
                    textcontroller: controller.leftFrontTireTread),
                checkBoxesSection(
                    dataMap: dataMap,
                    label: 'Wear Pattern',
                    textcontroller: controller.leftFrontWearPattern),
                Text(
                  'Tire Pressure PSI',
                  style: textStyleForInspectionHints,
                ),
                Row(
                  spacing: 5,
                  children: [
                    Expanded(
                      child: myTextFormFieldWithBorder(
                          onChanged: (value) {
                            controller.updateEnteredField(
                                'Tire Pressure PSI', 'before', value, dataMap);
                          },
                          controller: controller.leftFrontTirePressureBefore,
                          labelText: 'Before'),
                    ),
                    Expanded(
                      child: myTextFormFieldWithBorder(
                          onChanged: (value) {
                            controller.updateEnteredField(
                                'Tire Pressure PSI', 'after', value, dataMap);
                          },
                          controller: controller.leftFrontTirePressureAfter,
                          labelText: 'After'),
                    ),
                  ],
                ),
                checkBoxesSection(
                  dataMap: dataMap,
                  label: 'Rotor / Drum',
                )
              ],
            );
          }),
        ),
      ],
    );
  }