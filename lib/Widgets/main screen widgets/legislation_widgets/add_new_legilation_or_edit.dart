import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/legislation_controller.dart';
import '../../../consts.dart';
import 'legilation_information.dart';

Widget addNewLegistlationOrEdit({
  required LegislationController controller,
  required BoxConstraints constraints,
  required BuildContext context,
}) {
  return SingleChildScrollView(
    child: Column(
      children: [
        labelContainer(lable: Text('Information', style: fontStyle1)),
        legislationInformation(context, controller),
      ],
    ),
  );
}
