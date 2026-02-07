import 'package:flutter/material.dart';
import '../Models/dynamic_boxes_line_model.dart';
import '../Screens/Dashboard/car_trading_dashboard.dart';

Widget dynamicBoxesLine({required List<DynamicBoxesLineModel> dynamicConfigs}) {
  return Row(
    spacing: 10,
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey.shade300),
            color: const Color(0xffF4F5F8).withValues(alpha: 0.5),
          ),
        ),
      ),
      ...List.generate(dynamicConfigs.length, (index) {
        final config = dynamicConfigs[index];
        return SummaryBox(
          title: config.label,
          value: config.value,
          textColor: config.valueColor,
          isFormated: config.isFormated ?? true,
          width: config.width ?? 300,
          iconColor: config.iconColor ?? Colors.grey.shade300,
          showRefreshIcon: false,
          icon: config.icon,
        );
      }),
    ],
  );
}
