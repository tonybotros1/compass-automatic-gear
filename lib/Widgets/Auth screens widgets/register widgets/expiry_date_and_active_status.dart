import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../consts.dart';

Widget expiryDateAndActiveStatus({
  required BuildContext context,
  required constraints,
  required date,
  required usersController,
  showActiveStatus,
  activeStatusValue,
}) {
  if (date != '') {
    usersController.selectedDate.value = DateTime.parse(date);
  } else {
    usersController.selectedDate.value = DateTime.now();
  }
  return ListTile(
    trailing: showActiveStatus == true
        ? Obx(() => CupertinoSwitch(
            value: activeStatusValue.value,
            onChanged: (status) {
              usersController.userStatus.value = status;
            }))
        : const SizedBox(),
    contentPadding: const EdgeInsets.all(0),
    title: Text(
      "Expiry Date ",
      style: regTextStyle,
    ),
    subtitle: Row(
      children: [
        Obx(
          () => Text(usersController.textToDate(
              usersController.formatDate(usersController.selectedDate.value))),
        ),
        const SizedBox(
          width: 10,
        ),
        IconButton(
            onPressed: () => usersController.selectDateContext(context),
            icon: const Icon(
              Icons.calendar_month,
              color: Colors.blue,
            ))
      ],
    ),
  );
}
