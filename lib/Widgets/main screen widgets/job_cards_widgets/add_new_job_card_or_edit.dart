import 'package:datahubai/Controllers/Main%20screen%20controllers/job_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'car_details_section.dart';
import 'customer_details_section.dart';
import 'job_card_section.dart';
import 'quotations_section.dart';
import 'title_bar.dart';

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
        titleBar(
          title: 'Car Details',
          icon: Icons.directions_car,
        ),
        SizedBox(
          height: 3,
        ),
        carDetailsSection(),
        SizedBox(
          height: 20,
        ),
        titleBar(title: 'Customer Details', icon: Icons.person),
        SizedBox(
          height: 3,
        ),
        customerDetailsSection(),
        SizedBox(
          height: 20,
        ),
        titleBar(title: 'Quotation', icon: Icons.format_quote),
        SizedBox(
          height: 3,
        ),
        quotationsSection(context),
        SizedBox(
          height: 20,
        ),
        titleBar(title: 'Job Card', icon: Icons.credit_card),
        SizedBox(
          height: 3,
        ),
        jobCardSection(context),
      ],
    ),
  );
}
