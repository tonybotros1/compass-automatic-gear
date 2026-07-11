import 'package:flutter/material.dart';
import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../my_text_field.dart';

Widget noteSection({
  required BuildContext context,
  required BoxConstraints constraints,
  required CarTradingDashboardController controller,
}) {
  return Padding(
    padding: const EdgeInsets.all(12),
    child: myTextFormFieldWithBorder(
      controller: controller.note,
      validate: false,
      maxLines: 8,
      hintText: 'Write notes here...',
      onChanged: (_) {
        controller.carModified.value = true;
      },
    ),
  );
}
