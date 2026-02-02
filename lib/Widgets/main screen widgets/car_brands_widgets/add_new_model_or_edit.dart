import 'package:datahubai/Controllers/Main%20screen%20controllers/car_brands_controller.dart';
import 'package:flutter/material.dart';
import '../../my_text_field.dart';

Widget addNewmodelOrEdit({
  required CarBrandsController controller,
  bool? canEdit,
}) {
  return Form(
    key: controller.formKeyForAddingNewvalue,
    child: ListView(
      children: [
        const SizedBox(
          height: 5,
        ),
        myTextFormFieldWithBorder(
          obscureText: false,
          controller: controller.modelName,
          labelText: 'Name',
          validate: true,
        ),
      ],
    ),
  );
}
