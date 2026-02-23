import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';

Widget addNewPurchaseAgreementItemOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required CarTradingDashboardController controller,
  required bool canEdit,
}) {
  return GetBuilder<CarTradingDashboardController>(
    builder: (controller) {
      return FocusTraversalGroup(
        policy: WidgetOrderTraversalPolicy(),
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              myTextFormFieldWithBorder(
                labelText: 'Agreement Number',
                isEnabled: false,
                width: 200,
                controller: controller.agreementNumber,
              ),
              myTextFormFieldWithBorder(
                labelText: 'Agreement Date',
                width: 200,
                controller: controller.agreementdate,
              ),
              const Divider(thickness: 2),
              Row(
                spacing: 100,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Seller   '),
                            Expanded(child: Divider(thickness: 2)),
                          ],
                        ),
                        myTextFormFieldWithBorder(
                          labelText: 'Seller Name',
                          controller: controller.sellerName,
                        ),
                        myTextFormFieldWithBorder(
                          width: 250,
                          labelText: 'Seller ID',
                          controller: controller.sellerID,
                        ),
                        myTextFormFieldWithBorder(
                          width: 250,
                          labelText: 'Seller Phone',
                          controller: controller.sellerPhone,
                        ),
                        myTextFormFieldWithBorder(
                          width: 250,
                          labelText: 'Seller Email',
                          controller: controller.sellerEmail,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Buyer   '),
                            Expanded(child: Divider(thickness: 2)),
                          ],
                        ),
                        myTextFormFieldWithBorder(
                          labelText: 'Buyer Name',
                          controller: controller.buyerName,
                        ),
                        myTextFormFieldWithBorder(
                          width: 250,
                          labelText: 'Buyer ID',
                          controller: controller.buyerID,
                        ),
                        myTextFormFieldWithBorder(
                          width: 250,
                          labelText: 'Buyer Phone',
                          controller: controller.buyerPhone,
                        ),
                        myTextFormFieldWithBorder(
                          width: 250,
                          labelText: 'Buyer Email',
                          controller: controller.buyerEmail,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 2),
              myTextFormFieldWithBorder(
                labelText: 'Note',
                maxLines: 7,
                controller: controller.agreementNote,
              ),
              myTextFormFieldWithBorder(
                isDouble: true,
                labelText: 'Total Amount',
                width: 200,
                controller: controller.agreementTotal,
              ),
              myTextFormFieldWithBorder(
                isDouble: true,
                labelText: 'Downpayment',
                width: 200,
                controller: controller.agreementdownpayment,
              ),
            ],
          ),
        ),
      );
    },
  );
}
