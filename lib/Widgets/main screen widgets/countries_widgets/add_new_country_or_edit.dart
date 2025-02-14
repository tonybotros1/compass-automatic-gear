import 'package:datahubai/Widgets/main%20screen%20widgets/drop_down_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/countries_controller.dart';
import '../../my_text_field.dart';

Widget addNewCountryOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required CountriesController controller,
  bool? canEdit = true,
}) {
  return SizedBox(
    width: constraints.maxWidth / 2.5,
    height: 350,
    child: Form(
      key: controller.formKeyForAddingNewvalue,
      child: ListView(
        children: [
          SizedBox(
            height: 5,
          ),
          myTextFormFieldWithBorder(
            obscureText: false,
            controller: controller.countryName,
            labelText: 'Name',
            hintText: 'Enter Name',
            validate: true,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: myTextFormFieldWithBorder(
                    obscureText: false,
                    controller: controller.countryCode,
                    labelText: 'Code',
                    hintText: 'Enter Code',
                    validate: true,
                    isEnabled: canEdit),
              ),
              Expanded(
                child: myTextFormFieldWithBorder(
                  obscureText: false,
                  controller: controller.countryCallingCode,
                  labelText: 'Calling Code',
                  hintText: 'Enter Calling Code',
                  validate: true,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: GetX<CountriesController>(builder: (controller) {
                  final isCurrenciesLoading = controller.allCurrencies.isEmpty;
      
                  return dropDownValues(
                    textController: controller.currency,
                    labelText: 'Based Currency',
                    hintText: 'Select Based Currency',
                    menus: isCurrenciesLoading ? {} : controller.allCurrencies,
                    validate: true,
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text('${suggestion['code']}'),
                      );
                    },
                    onSelected: (suggestion) {
                      controller.currency.text = suggestion['code'];
                      controller.allCurrencies.entries.where((entry) {
                        return entry.value['code'] ==
                            suggestion['code'].toString();
                      }).forEach(
                        (entry) {
                          controller.currencyId.value = entry.key;
                          controller.currencyRate.text =
                              (entry.value['rate'] ?? '0').toString();
                        },
                      );
                    },
                    listValues: controller.allCurrencies.values
                        .map((value) => value['code'].toString())
                        .toList(),
                  );
                }),
              ),
              Expanded(
                child: myTextFormFieldWithBorder(
                  obscureText: false,
                  controller: controller.currencyRate,
                  labelText: 'Currency Rate',
                  hintText: 'Enter Calling Code',
                  validate: true,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          GetX<CountriesController>(builder: (controller) {
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
                          : Colors.red),
                ),
                child: controller.imageBytes.value.isEmpty &&
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
                          ),
              ),
            );
          }),
        ],
      ),
    ),
  );
}
