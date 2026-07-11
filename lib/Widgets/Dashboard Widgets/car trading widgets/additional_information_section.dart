import 'package:flutter/material.dart';
import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../drop_down_menu3.dart';
import '../../main screen widgets/add_new_values_button.dart';

Widget additionalInformation({
  required BuildContext context,
  required BoxConstraints constraints,
  required CarTradingDashboardController controller,
}) {
  return FocusTraversalGroup(
    policy: WidgetOrderTraversalPolicy(),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: LayoutBuilder(
        builder: (context, sectionConstraints) {
          return Row(
            spacing: 60,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  spacing: 10,
                  // crossAxisAlignment: WrapCrossAlignment.end,
                  children: [
                    _ActionField(
                      field: CustomDropdown(
                        width: 300,
                        showedSelectedName: 'name',
                        textcontroller: controller.consignmentFor.value.text,
                        hintText: 'Consignment For',
                        onChanged: (key, value) {
                          controller.consignmentFor.value.text = value['name'];
                          controller.consignmentForId.value = key;
                          controller.carModified.value = true;
                        },
                        onDelete: () {
                          controller.consignmentFor.value.clear();
                          controller.consignmentForId.value = '';
                          controller.carModified.value = true;
                        },
                        onOpen: () {
                          return controller.getConsignmentsFor();
                        },
                      ),
                      action: valSectionInTheTable(
                        controller.listOfValuesController,
                        constraints,
                        'CONSIGNMENT_FOR',
                        'New Consignment For',
                        'Consignment For',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _ActionField(
                      field: CustomDropdown(
                        width: 300,
                        textcontroller: controller.investedBy.value.text,
                        hintText: 'Capital By', // old name was (invested By)
                        onChanged: (key, value) {
                          controller.investedBy.value.text = value['name'];
                          controller.investedById.value = key;
                          controller.carModified.value = true;
                        },
                        onDelete: () {
                          controller.investedBy.value.clear();
                          controller.investedById.value = '';
                          controller.carModified.value = true;
                        },
                        onOpen: () {
                          return controller.getInvestedBy();
                        },
                      ),
                      action: valSectionInTheTable(
                        controller.listOfValuesController,
                        constraints,
                        'INVESTED_BY',
                        'New Investor',
                        'Investors',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}

class _ActionField extends StatelessWidget {
  const _ActionField({required this.field, required this.action});

  final Widget field;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        field,
        const SizedBox(width: 6),
        SizedBox(width: 34, height: 38, child: action),
      ],
    );
  }
}
