
  import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Mobile section controllers/cards_screen_controller.dart';
import '../../../consts.dart';
import '../../my_text_field.dart';

Widget checkBoxesSection(
      {required String label,
      TextEditingController? textcontroller,
      required RxMap<String, Map<String, String>> dataMap}) {
    return GetBuilder<CardsScreenController>(builder: (controller) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          checkBox(
              value: dataMap[label]?['status'] == 'Checked And Ok',
              color: Colors.green,
              onChanged: (value) => controller.updateSelectedBox(
                  label, 'status', 'Checked And Ok', dataMap)),
          checkBox(
              value: dataMap[label]?['status'] == 'May Need Future Attention',
              color: Colors.yellow,
              onChanged: (value) => controller.updateSelectedBox(
                  label, 'status', 'May Need Future Attention', dataMap)),
          checkBox(
              value:
                  dataMap[label]?['status'] == 'Requires Immediate Attention',
              color: Colors.red,
              onChanged: (value) => controller.updateSelectedBox(
                  label, 'status', 'Requires Immediate Attention', dataMap)),
          textcontroller != null
              ? Expanded(
                  child: myTextFormFieldWithBorder(
                      labelText: label,
                      controller: textcontroller,
                      onChanged: (value) {
                        controller.updateEnteredField(
                            label, 'value', value, dataMap);
                      }))
              : Text(
                  label,
                  style: textStyleForInspectionHints,
                )
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
