import 'package:datahubai/Controllers/Main%20screen%20controllers/job_card_controller.dart';
import 'package:flutter/material.dart';
import 'car_details_section.dart';
import 'customer_details_section.dart';

Widget addNewJobCardOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required JobCardController controller,
  bool? canEdit,
}) {
  return SizedBox(
    width: constraints.maxWidth,
    child: ListView(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.centerLeft,
              height: 50,
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                children: [
                  Icon(
                    Icons.directions_car,
                    color: Colors.grey[700],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Car Details',
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
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
            style:
                TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold),
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
