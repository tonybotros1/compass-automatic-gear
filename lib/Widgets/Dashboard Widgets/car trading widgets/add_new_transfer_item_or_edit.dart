import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../consts.dart';
import '../../main screen widgets/add_new_values_button.dart';

Widget addNewTransferItemOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required CarTradingDashboardController controller,
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
                width: 160,
                onFieldSubmitted: (_) {
                  normalizeDate(
                    controller.transferDate.value.text,
                    controller.transferDate.value,
                  );
                },
                onTapOutside: (_) {
                  normalizeDate(
                    controller.transferDate.value.text,
                    controller.transferDate.value,
                  );
                },
                validate: true,
                controller: controller.transferDate.value,
                labelText: 'Date',
                suffixIcon: IconButton(
                  focusNode: FocusNode(skipTraversal: true),
                  onPressed: () async {
                    selectDateContext(context, controller.transferDate.value);
                  },

                  icon: const Icon(Icons.date_range),
                ),
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomDropdown(
                    width: 300,
                    textcontroller: controller.fromAccount.text,
                    hintText: 'From Account',
                    showedSelectedName: 'name',
                    onChanged: (key, value) {
                      controller.fromAccountId.value = key;
                      controller.fromAccount.text = value['name'];
                    },
                    onDelete: () {
                      controller.fromAccountId.value = '';
                      controller.fromAccount.clear();
                    },
                    onOpen: () {
                      return controller.getNamesOfAccount();
                    },
                  ),
                  valSectionInTheTable(
                    controller.listOfValuesController,
                    constraints,
                    'CAR_TRADING_CASH_BANK',
                    'New Account',
                    'Car trading Cash Bank',
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomDropdown(
                    width: 300,
                    textcontroller: controller.toAccount.text,
                    hintText: 'To Account',
                    showedSelectedName: 'name',
                    onChanged: (key, value) {
                      controller.toAccountId.value = key;
                      controller.toAccount.text = value['name'];
                    },
                    onDelete: () {
                      controller.toAccountId.value = '';
                      controller.toAccount.clear();
                    },
                    onOpen: () {
                      return controller.getNamesOfAccount();
                    },
                  ),
                  valSectionInTheTable(
                    controller.listOfValuesController,
                    constraints,
                    'CAR_TRADING_CASH_BANK',
                    'New Account',
                    'Car trading Cash Bank',
                  ),
                ],
              ),

              myTextFormFieldWithBorder(
                width: 160,
                validate: true,
                controller: controller.transferAmount,
                labelText: 'Amount',
                isDouble: true,
              ),

              myTextFormFieldWithBorder(
                controller: controller.transferComments.value,
                labelText: 'Comments',
                maxLines: 7,
              ),
            ],
          ),
        ),
      );
    },
  );
}
