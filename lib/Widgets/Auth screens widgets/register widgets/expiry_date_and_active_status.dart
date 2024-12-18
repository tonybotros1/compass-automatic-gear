import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../consts.dart';

Widget expiryDateAndActiveStatus(
    {required BuildContext context,
    required constraints,
    required date,
    required registerController,
    activeStatus,
    }) {
  if (date != '') {
    registerController.selectedDate.value = DateTime.parse(date);
  } else {
    registerController.selectedDate.value = DateTime.now();
  }
  return Container(
    constraints: BoxConstraints(
        maxHeight: constraints.maxHeight > 400
            ? constraints.maxHeight / 3
            : constraints.maxHeight / 1.3,
        maxWidth: constraints.maxWidth > 796
            ? constraints.maxWidth / 3
            : constraints.maxWidth < 796 && constraints.maxWidth > 400
                ? constraints.maxWidth / 2
                : constraints.maxWidth / 1.5),
    child: ListTile(
      trailing:activeStatus == true? ToggleSwitch(
        activeBgColors: const [
          [Colors.blue],
          [Colors.red]
        ],
        activeFgColor: Colors.white,
        inactiveBgColor: Colors.grey,
        inactiveFgColor: Colors.white,
        initialLabelIndex: 0,
        totalSwitches: 2,
        labels: const ['Enable', 'Disable'],
        onToggle: (index) {
          print('switched to: $index');
        },
      ):const SizedBox(),
      contentPadding: const EdgeInsets.all(0),
      title: Text(
        "Expiry Date ",
        style: fontStyle2,
      ),
      subtitle: Row(
        children: [
          Obx(
            () => Text(
              registerController
                  .formatDate(registerController.selectedDate.value),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
              onPressed: () => registerController.selectDateContext(context),
              icon: const Icon(
                Icons.calendar_month,
                color: Colors.blue,
              ))
        ],
      ),
    ),
  );
}
