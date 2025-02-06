import 'package:datahubai/Controllers/Main%20screen%20controllers/car_brands_controller.dart';
import 'package:flutter/material.dart';
import '../../my_text_field.dart';

Widget addNewmodelOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required CarBrandsController controller,
  bool? canEdit,
}) {
  return SizedBox(
    width: constraints.maxWidth / 2.5,
    height: 100,
    child: Form(
      key: controller.formKeyForAddingNewvalue,
      child: ListView(
        children: [
          SizedBox(
            height: 5,
          ),
          myTextFormFieldWithBorder(
            obscureText: false,
            controller: controller.modelName,
            labelText: 'Name',
            hintText: 'Enter Name',
            validate: true,
          ),
        ],
      ),
    ),
  );
}
