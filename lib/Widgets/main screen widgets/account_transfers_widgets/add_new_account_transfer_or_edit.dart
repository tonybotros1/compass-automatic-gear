import 'package:datahubai/Controllers/Main%20screen%20controllers/account_transfers_controller.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../../main screen widgets/add_new_values_button.dart';
import '../../menu_dialog.dart';

Widget addNewAccountTransferItemOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required AccountTransfersController controller,
}) {
  return GetBuilder<AccountTransfersController>(
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
                  Expanded(
                    child: MenuWithValues(
                      labelText: 'From Account',
                      headerLqabel: 'Accounts',
                      dialogWidth: constraints.maxWidth / 3,
                      // width: 250,
                      controller: controller.fromAccount,
                      displayKeys: const ['account_number'],
                      displaySelectedKeys: const ['account_number'],
                      onOpen: () {
                        return controller.getAllAccounts();
                      },
                      onDelete: () {
                        controller.fromAccountId.value = '';
                        controller.fromAccount.clear();
                      },
                      onSelected: (value) {
                        controller.fromAccountId.value = value['_id'];
                        controller.fromAccount.text = value['account_number'];
                      },
                    ),
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
                  Expanded(
                    child: MenuWithValues(
                      labelText: 'To Account',
                      headerLqabel: 'Accounts',
                      dialogWidth: constraints.maxWidth / 3,
                      // width: ,
                      controller: controller.toAccount,
                      displayKeys: const ['account_number'],
                      displaySelectedKeys: const ['account_number'],
                      onOpen: () {
                        return controller.getAllAccounts();
                      },
                      onDelete: () {
                        controller.toAccountId.value = '';
                        controller.toAccount.clear();
                      },
                      onSelected: (value) {
                        controller.toAccountId.value = value['_id'];
                        controller.toAccount.text = value['account_number'];
                      },
                    ),
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
