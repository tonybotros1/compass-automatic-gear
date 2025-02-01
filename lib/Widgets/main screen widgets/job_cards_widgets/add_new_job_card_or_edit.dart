import 'package:datahubai/Controllers/Main%20screen%20controllers/job_card_controller.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'car_details_section.dart';
import 'customer_details_section.dart';

Widget addNewJobCardOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required JobCardController controller,
  bool? canEdit,
}) {
  return SizedBox(
    width: Get.width, //constraints.maxWidth,
    child: ListView(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.centerLeft,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.grey[400], borderRadius: BorderRadius.circular(5)),
          child: Text(
            'Car Details',
            style: fontStyleForAppBar,
          ),
        ),
        SizedBox(
          height: 3,
        ),
        carDetailsSection(),
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.centerLeft,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.grey[400], borderRadius: BorderRadius.circular(5)),
          child: Text(
            'Customer Details',
            style: fontStyleForAppBar,
          ),
        ),
        SizedBox(
          height: 3,
        ),
        customerDetailsSection(),
      ],
    ),
  );
}
