import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/payroll_elements_controller.dart';
import '../../../consts.dart';
import '../../menu_dialog.dart';
import '../../my_text_field.dart';

Container elementDetails(
  BuildContext context,
  PayrollElementsController controller,
) {
  return Container(
    // height: 245,
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 50,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  myTextFormFieldWithBorder(
                    labelText: 'Element Key',
                    controller: controller.elementName,
                    width: 310,
                  ),
                  myTextFormFieldWithBorder(
                    labelText: 'Element Name',
                    controller: controller.elementKey,
                    width: 620,
                  ),
                  MenuWithValues(
                    labelText: 'Element Type',
                    headerLqabel: 'Element Type',
                    dialogWidth: 600,
                    width: 200,
                    controller: controller.elementType,
                    displayKeys: const ['name'],
                    displaySelectedKeys: const ['name'],
                    data: controller.elementTypes,
                    onDelete: () {
                      controller.elementType.clear();
                    },
                    onSelected: (value) {
                      controller.elementType.text = value['name'];
                    },
                  ),
                  myTextFormFieldWithBorder(
                    labelText: 'Priority',
                    isnumber: true,
                    controller: controller.elementPriority,
                    width: 200,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: myTextFormFieldWithBorder(
                maxLines: 10,
                labelText: 'Comments',
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: mainColor, width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 5,
                children: [
                  GetX<PayrollElementsController>(
                    builder: (controller) {
                      return CupertinoCheckbox(
                        value: controller.allowOverride.value,
                        onChanged: (val) {
                          controller.allowOverride.value = val ?? false;
                        },
                      );
                    },
                  ),
                  Text('Allow Override', style: coolTextStyle),
                ],
              ),
              Row(
                spacing: 5,
                children: [
                  GetX<PayrollElementsController>(
                    builder: (controller) {
                      return CupertinoCheckbox(
                        value: controller.recurring.value,
                        onChanged: (val) {
                          controller.recurring.value = val ?? false;
                        },
                      );
                    },
                  ),
                  Text('Recurring', style: coolTextStyle),
                ],
              ),
              Row(
                spacing: 5,
                children: [
                  GetX<PayrollElementsController>(
                    builder: (controller) {
                      return CupertinoCheckbox(
                        value: controller.entryValue.value,
                        onChanged: (val) {
                          controller.entryValue.value = val ?? false;
                        },
                      );
                    },
                  ),
                  Text('Entry Value', style: coolTextStyle),
                ],
              ),
              Row(
                spacing: 5,
                children: [
                  GetX<PayrollElementsController>(
                    builder: (controller) {
                      return CupertinoCheckbox(
                        value: controller.standardLink.value,
                        onChanged: (val) {
                          controller.standardLink.value = val ?? false;
                        },
                      );
                    },
                  ),
                  Text('Standard Link', style: coolTextStyle),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
