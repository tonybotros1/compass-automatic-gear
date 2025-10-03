import 'package:datahubai/Controllers/Main%20screen%20controllers/receiving_controller.dart';
import 'package:flutter/material.dart';
import '../../../consts.dart';
import 'additional_costs_section.dart';
import 'additional_discount_section.dart';
import 'currency_section.dart';
import 'items_section.dart';
import 'main_infos_section.dart';
import 'makeer_checker_and_approver_section.dart';

Widget addNewReceiveOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required ReceivingController controller,
  bool? canEdit,
  required String id,
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
              child: Row(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        labelContainer(
                          lable: Text('Main Infos', style: fontStyle1),
                        ),
                        mainInfosSection(context, controller),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              labelContainer(
                                lable: Text('Currency', style: fontStyle1),
                              ),
                              currencySection(context, controller),

                              const SizedBox(height: 10),
                              labelContainer(
                                lable: Text(
                                  'Maker, Checker & Approver',
                                  style: fontStyle1,
                                ),
                              ),
                              makerCheckerAndApproverSection(
                                context,
                                controller,
                                constraints,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),

                        Expanded(
                          child: Column(
                            children: [
                              labelContainer(
                                lable: Text(
                                  'Additional Costs',
                                  style: fontStyle1,
                                ),
                              ),
                              additionalCostsSection(context, controller),
                              const SizedBox(height: 10),
                              labelContainer(
                                lable: Text(
                                  'Additional Discount',
                                  style: fontStyle1,
                                ),
                              ),
                              additionalDiscountSection(context, controller),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        labelContainer(
          lable: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Items', style: fontStyle1),
              newItemButton(context, constraints, controller, id),
            ],
          ),
        ),
        itemsSection(context: context, constraints: constraints, id: id),
      ],
    ),
  );
}
