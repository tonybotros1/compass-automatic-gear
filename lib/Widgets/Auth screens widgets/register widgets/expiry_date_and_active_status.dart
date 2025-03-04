import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../consts.dart';

Widget expiryDateAndActiveStatus({
  required BuildContext context,
  required constraints,
  required date,
  required controller,
 
}) {
  if (date != '' && date != null) {
    controller.selectedDate.value = DateTime.parse(date);
  } else {
    controller.selectedDate.value = DateTime.now();
  }
  return ListTile(
   
    contentPadding: const EdgeInsets.all(0),
    title: Text(
      "Expiry Date ",
      style: regTextStyle,
    ),
    subtitle: Row(
      children: [
        Obx(
          () => Text(textToDate(
              controller.formatDate(controller.selectedDate.value))),
        ),
        const SizedBox(
          width: 10,
        ),
        IconButton(
            onPressed: () => controller.selectDateContext(context),
            icon: const Icon(
              Icons.calendar_month,
              color: Colors.blue,
            ))
      ],
    ),
  );
}
