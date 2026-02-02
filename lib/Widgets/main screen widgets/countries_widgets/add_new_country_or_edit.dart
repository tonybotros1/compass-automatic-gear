import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/countries_controller.dart';
import '../../my_text_field.dart';

Widget addNewCountryOrEdit({
  required CountriesController controller,
  required bool canEdit,
}) {
  return Form(
    key: controller.formKeyForAddingNewvalue,
    child: ListView(
      children: [
        const SizedBox(height: 5),
        myTextFormFieldWithBorder(
          obscureText: false,
          controller: controller.countryName,
          labelText: 'Name',
          validate: true,
        ),
        const SizedBox(height: 10),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: myTextFormFieldWithBorder(
                obscureText: false,
                controller: controller.countryCode,
                labelText: 'Code',
                validate: true,
                isEnabled: canEdit,
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                obscureText: false,
                controller: controller.countryCallingCode,
                labelText: 'Calling Code',
                validate: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: myTextFormFieldWithBorder(
                obscureText: false,
                controller: controller.currencyName,
                labelText: 'Currency Name',
                validate: true,
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                obscureText: false,
                controller: controller.currencyCode,
                labelText: 'Currency Code',
                validate: true,
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                obscureText: false,
                controller: controller.subunitName,
                labelText: 'Subunit Name',
                validate: true,
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                obscureText: false,
                controller: controller.subunitCode,
                labelText: 'Subunit Code',
                validate: true,
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                isDouble: true,
                obscureText: false,
                controller: controller.vat,
                labelText: 'VAT',
                validate: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        GetX<CountriesController>(
          builder: (controller) {
            return InkWell(
              onTap: () {
                controller.pickImage();
              },
              child: Container(
                height: 155,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    style: BorderStyle.solid,
                    color: controller.flagSelectedError.isFalse
                        ? Colors.grey
                        : Colors.red,
                  ),
                ),
                child:
                    controller.imageBytes.value.isEmpty &&
                        controller.flagUrl.value.isEmpty
                    ? const Center(
                        child: FittedBox(
                          child: Text(
                            'No image selected',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    : controller.imageBytes.value.isNotEmpty
                    ? Image.memory(
                        controller.imageBytes.value,
                        fit: BoxFit.contain,
                      )
                    : Image.network(
                        controller.flagUrl.value,
                        fit: BoxFit.contain,
                        errorBuilder: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
              ),
            );
          },
        ),
      ],
    ),
  );
}
