import 'package:flutter/cupertino.dart';
import '../../../Controllers/Main screen controllers/legislation_controller.dart';
import '../../../consts.dart';
import '../../my_text_field.dart';

Container legislationInformation(
  LegislationController controller,
) {
  return Container(
    // height: 245,
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        myTextFormFieldWithBorder(
          labelText: 'Name',
          controller: controller.name,
          width: 310,
        ),
      ],
    ),
  );
}
