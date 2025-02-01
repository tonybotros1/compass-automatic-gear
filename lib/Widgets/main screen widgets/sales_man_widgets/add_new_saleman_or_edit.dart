import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/sales_man_controller.dart';

Widget addNewSaleManOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required SalesManController controller,
  TextEditingController? name,
  TextEditingController? target,
  bool? canEdit,
}) {
  return SizedBox(
    width: constraints.maxWidth / 2.5,
    height: 150,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        myTextFormFieldWithBorder(
          obscureText: false,
          controller: name ?? controller.name,
          labelText: 'Name',
          hintText: 'Enter Sale Man Name',
          validate: true,
          isEnabled: canEdit,
        ),
        SizedBox(
          height: 10,
        ),
        myTextFormFieldWithBorder(
          isnumber: true,
          obscureText: false,
          controller: target ?? controller.target,
          labelText: 'Target',
          hintText: 'Enter Target',
          validate: true,
        ),
      ],
    ),
  );
}
