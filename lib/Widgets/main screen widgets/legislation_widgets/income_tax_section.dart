import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/legislation_controller.dart';
import '../../../consts.dart';

Container incomeTaxSection(LegislationController controller) {
  return Container(
    height: 430,
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    width: double.infinity,
    child: Obx(() {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                myTextFormFieldWithBorder(
                  labelText: 'Fallback Percentage',
                  controller: controller.incomeTaxPercentage,
                  isDouble: true,
                  validate: false,
                  width: 150,
                  suffixIcon: const Icon(Icons.percent),
                ),
                myTextFormFieldWithBorder(
                  labelText: 'Fallback Ceiling',
                  controller: controller.incomeTaxCeiling,
                  isDouble: true,
                  validate: false,
                  width: 150,
                ),
              ],
            ),
            Row(
              children: [
                Text('Tax Brackets', style: fontStyle1),
                const Spacer(),
                IconButton(
                  onPressed: () => controller.addIncomeTaxBracket(),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            ...controller.incomeTaxBrackets.asMap().entries.map((entry) {
              final index = entry.key;
              final bracket = entry.value;

              return Row(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  myTextFormFieldWithBorder(
                    labelText: 'From',
                    controller: bracket.fromAmount,
                    isDouble: true,
                    validate: false,
                    width: 110,
                  ),
                  myTextFormFieldWithBorder(
                    labelText: 'To',
                    controller: bracket.toAmount,
                    isDouble: true,
                    validate: false,
                    width: 110,
                  ),
                  myTextFormFieldWithBorder(
                    labelText: 'Percentage',
                    controller: bracket.percentage,
                    isDouble: true,
                    validate: false,
                    width: 120,
                    suffixIcon: const Icon(Icons.percent),
                  ),
                  IconButton(
                    onPressed: () => controller.removeIncomeTaxBracket(index),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              );
            }),
          ],
        ),
      );
    }),
  );
}
