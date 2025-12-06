import 'package:flutter/material.dart';
import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../consts.dart';
import '../../my_text_field.dart';

Widget noteSection({
  required BuildContext context,
  required BoxConstraints constraints,
  required CarTradingDashboardController controller,
}) {
  return Container(
    height: 225,
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    child: myTextFormFieldWithBorder(
      controller: controller.note,
      maxLines: 8,
      onChanged: (_) {
        controller.carModified.value = true;
      },
    ),
  );
}
