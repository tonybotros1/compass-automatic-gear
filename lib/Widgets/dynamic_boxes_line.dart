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
            border: Border.all(color: Colors.grey.shade300, width: 1.2),
            // gradient: LinearGradient(
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            //   colors: [
            //     Colors.grey.shade300,
            //     Colors.grey.shade200,
            //     Colors.grey.shade100,
            //     Colors.grey.shade200,
            //     Colors.grey.shade300,
            //   ],
            // ),
          ),
          child: Center(
            child: Icon(
              Icons.dashboard_customize_outlined,
              color: Colors.grey.shade400,
              size: 28,
            ),
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

// import 'package:flutter/material.dart';
// import '../Models/dynamic_boxes_line_model.dart';
// import '../Screens/Dashboard/car_trading_dashboard.dart';

// Widget dynamicBoxesLine({required List<DynamicBoxesLineModel> dynamicConfigs}) {
//   return LayoutBuilder(
//     builder: (context, constraints) {
//       final availableWidth = constraints.maxWidth;
//       const spacing = 10.0;
//       const placeholderMinWidth = 180.0;

//       // Calculate total width required by boxes
//       double boxesWidth = 0;
//       for (var config in dynamicConfigs) {
//         boxesWidth += (config.width ?? 300);
//       }

//       final totalWidth =
//           placeholderMinWidth + boxesWidth + (dynamicConfigs.length * spacing);

//       final shouldScroll = totalWidth > availableWidth;

//       Widget placeholder = Container(
//         width: shouldScroll ? placeholderMinWidth : null,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: Colors.grey.shade300, width: 1.2),
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Colors.grey.shade100, Colors.grey.shade200],
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 Icons.dashboard_customize_outlined,
//                 color: Colors.grey.shade400,
//                 size: 28,
//               ),
//               const SizedBox(height: 6),
//               Text(
//                 "Reserved",
//                 style: TextStyle(
//                   color: Colors.grey.shade500,
//                   fontWeight: FontWeight.w500,
//                   letterSpacing: 0.8,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );

//       Widget rowContent = Row(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // Placeholder
//           shouldScroll ? placeholder : Expanded(child: placeholder),

//           const SizedBox(width: spacing),

//           ...List.generate(dynamicConfigs.length, (index) {
//             final config = dynamicConfigs[index];

//             return Padding(
//               padding: const EdgeInsets.only(right: spacing),
//               child: SummaryBox(
//                 title: config.label,
//                 value: config.value,
//                 textColor: config.valueColor,
//                 isFormated: config.isFormated ?? true,
//                 width: config.width ?? 300,
//                 iconColor: config.iconColor ?? Colors.grey.shade300,
//                 showRefreshIcon: false,
//                 icon: config.icon,
//               ),
//             );
//           }),
//         ],
//       );

//       if (shouldScroll) {
//         return SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: ConstrainedBox(
//             constraints: BoxConstraints(minWidth: totalWidth),
//             child: rowContent,
//           ),
//         );
//       }

//       return rowContent;
//     },
//   );
// }
