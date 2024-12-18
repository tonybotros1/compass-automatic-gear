import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../consts.dart';

Widget expiryDateAndActiveStatus(
    {required BuildContext context,
    required constraints,
    required date,
    required registerController}) {
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
      trailing: ToggleSwitch(
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
      ),
      contentPadding: const EdgeInsets.all(0),
      title: Text(
        "Expiry Date ",
        style: fontStyle2,
      ),
      subtitle: Row(
        children: [
          Text(registerController
              .formatDate(registerController.selectedDate.value)),
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
