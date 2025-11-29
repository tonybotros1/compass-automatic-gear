import 'package:datahubai/Controllers/Main%20screen%20controllers/converters_controller.dart';
import 'package:flutter/material.dart';
import '../../../consts.dart';
import 'converter_details_section.dart';
import 'items_section.dart';

Widget addNewConverterOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required ConvertersController controller,
  bool? canEdit,
}) {
  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth - 16),
            child: IntrinsicWidth(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  labelContainer(
                    lable: Text('Converter Details', style: fontStyle1),
                  ),
                  converterDetails(context, controller),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        labelContainer(lable: Text('Items', style: fontStyle1)),
        itemsSection(context: context, constraints: constraints),
      ],
    ),
  );
}
