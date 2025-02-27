import 'package:datahubai/Controllers/Main%20screen%20controllers/currency_controller.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../drop_down_menu2.dart';
import '../../drop_down_menu3.dart';

Widget addNewCurrencyOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required CurrencyController controller,
  bool? canEdit = true,
}) {
  return SizedBox(
    width: constraints.maxWidth / 2.5,
    height: 250,
    child: Form(
      key: controller.formKeyForAddingNewvalue,
      child: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          // GetX<CurrencyController>(builder: (controller) {
          //   bool isCountryLoading = controller.allCountries.isEmpty;
          //   return CustomDropdown(
          //     onChanged: (value){},
          //     hintText: 'Code',
          //     items: isCountryLoading
          //         ? {}
          //         : controller.allCountries
          //            , itemBuilder: (BuildContext , Map<String, dynamic> ) {  }, controller: null,
          //   );
          //   // return dropDownValues2(
          //   //   textController: controller.code,
          //   //   onSelected: (value) {
          //   //     var selectedItem = controller.allCountries.entries.firstWhere(
          //   //       (entry) =>
          //   //           '${entry.value['currency_code']} (${entry.value['currency_name']})' ==
          //   //           value,
          //   //       orElse: () => MapEntry(null, {}),
          //   //     );
          //   //     if (selectedItem.key != null && selectedItem.value.isNotEmpty) {
          //   //       controller.name.text = selectedItem.value['currency_name'];
          //   //       controller.countryId.value = selectedItem.key;
          //   //     }
          //   //   },
          //   //   hintText: 'Code',
          //   //   list: isCountryLoading
          //   //       ? []
          //   //       : controller.allCountries.values
          //   //           .map((item) =>
          //   //               '${item['currency_code']} (${item['currency_name']})')
          //   //           .toList(),
          //   //   validate: true,
          //   // );
          // }),
          SizedBox(
            height: 10,
          ),
          myTextFormFieldWithBorder(
            isEnabled: false,
            obscureText: false,
            controller: controller.name,
            labelText: 'Name',
            hintText: 'Enter Name',
            validate: false,
          ),
          SizedBox(
            height: 10,
          ),
          myTextFormFieldWithBorder(
            isDouble: true,
            obscureText: false,
            controller: controller.rate,
            labelText: 'Rate',
            hintText: 'Enter Rate',
            validate: true,
          ),
        ],
      ),
    ),
  );
}
