import 'package:datahubai/Controllers/Main%20screen%20controllers/ap_payment_type_controller.dart';
import 'package:flutter/material.dart';

import '../../my_text_field.dart';

Widget addNewTypeOrEdit({
  required ApPaymentTypeController controller,
  required bool canEdit,
}) {
  return ListView(
    children: [
      const SizedBox(
        height: 5,
      ),
      myTextFormFieldWithBorder(
        obscureText: false,
        controller: controller.type,
        labelText: 'Type',
        validate: true,
      ),
    ],
  );
}
