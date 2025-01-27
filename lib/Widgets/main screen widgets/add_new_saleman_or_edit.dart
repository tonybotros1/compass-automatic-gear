import 'package:flutter/material.dart';
import '../../Controllers/Main screen controllers/sales_man_controller.dart';
import '../Auth screens widgets/register widgets/my_text_form_field.dart';

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
    height: 100,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        myTextFormField(
          constraints: constraints,
          obscureText: false,
          controller: name ?? controller.name,
          labelText: 'Name',
          hintText: 'Enter Sale Man Name',
          validate: true,
          canEdit: canEdit,
        ),
        myTextFormField(
          isnumber: true,
          constraints: constraints,
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
