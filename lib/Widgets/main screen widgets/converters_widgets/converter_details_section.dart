import 'package:datahubai/Controllers/Main%20screen%20controllers/converters_controller.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import '../../../consts.dart';

Container converterDetails(
  BuildContext context,
  ConvertersController controller,
) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    child: Row(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            myTextFormFieldWithBorder(
              width: 150,
              onFieldSubmitted: (_) async {
                normalizeDate(controller.date.text, controller.date);
              },
              controller: controller.date,
              labelText: 'Date',
              suffixIcon: IconButton(
                onPressed: () {
                  selectDateContext(context, controller.date);
                },
                icon: const Icon(Icons.date_range),
              ),
              isDate: true,
            ),
            myTextFormFieldWithBorder(
              width: 150,
              labelText: 'Number',
              isEnabled: false,
              controller: controller.converterNumber,
            ),

            myTextFormFieldWithBorder(
              width: 310,
              labelText: 'Converter Name',
              controller: controller.converterName,
            ),
          ],
        ),
        myTextFormFieldWithBorder(
          width: 800,
          labelText: 'Description',
          maxLines: 7,
          controller: controller.description,
        ),
      ],
    ),
  );
}
