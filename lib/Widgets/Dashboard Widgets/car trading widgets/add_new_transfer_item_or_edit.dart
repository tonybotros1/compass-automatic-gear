import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../consts.dart';
import '../../main screen widgets/add_new_values_button.dart';

const _transferFormSlate = Color(0xFF334155);
const _transferFormMuted = Color(0xFF64748B);

Widget addNewTransferItemOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required CarTradingDashboardController controller,
}) {
  return GetBuilder<CarTradingDashboardController>(
    builder: (controller) {
      return Form(
        key: controller.transferFormKey,
        child: FocusTraversalGroup(
          policy: WidgetOrderTraversalPolicy(),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 4),
            children: [
              _TransferFormSection(
                icon: Icons.swap_horiz_rounded,
                title: 'Transfer details',
                subtitle: 'Choose the date and accounts for this transfer',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    myTextFormFieldWithBorder(
                      width: 200,
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
                      hintText: 'DD/MM/YYYY',
                      suffixIcon: IconButton(
                        focusNode: FocusNode(skipTraversal: true),
                        onPressed: () async {
                          selectDateContext(
                            context,
                            controller.transferDate.value,
                          );
                        },
                        icon: const Icon(
                          Icons.calendar_today_outlined,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 11),
                    _TransferSelectionField(
                      dropdown: CustomDropdown(
                        validator: true,
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
                        onOpen: controller.getNamesOfAccount,
                      ),
                      action: valSectionInTheTable(
                        controller.listOfValuesController,
                        constraints,
                        'CAR_TRADING_CASH_BANK',
                        'New Account',
                        'Car trading Cash Bank',
                      ),
                    ),
                    const SizedBox(height: 11),
                    _TransferSelectionField(
                      dropdown: CustomDropdown(
                        validator: true,
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
                        onOpen: controller.getNamesOfAccount,
                      ),
                      action: valSectionInTheTable(
                        controller.listOfValuesController,
                        constraints,
                        'CAR_TRADING_CASH_BANK',
                        'New Account',
                        'Car trading Cash Bank',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _TransferFormSection(
                icon: Icons.payments_outlined,
                title: 'Amount',
                subtitle: 'Enter the amount being moved between accounts',
                child: myTextFormFieldWithBorder(
                  controller: controller.transferAmount,
                  labelText: 'Amount',
                  hintText: '0.00',
                  isDouble: true,
                  validate: true,
                ),
              ),
              const SizedBox(height: 14),
              _TransferFormSection(
                icon: Icons.notes_rounded,
                title: 'Comments',
                subtitle: 'Optional details about this transfer',
                child: myTextFormFieldWithBorder(
                  controller: controller.transferComments.value,
                  labelText: 'Comments',
                  hintText: 'Add any useful details...',
                  validate: false,
                  minLines: 3,
                  maxLines: 5,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _TransferFormSection extends StatelessWidget {
  const _TransferFormSection({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F172A),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 18, color: _transferFormSlate),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _transferFormMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _TransferSelectionField extends StatelessWidget {
  const _TransferSelectionField({required this.dropdown, this.action});

  final Widget dropdown;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: dropdown),
        if (action != null)
          Row(
            children: [
              const SizedBox(width: 6),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: action,
              ),
            ],
          ),
      ],
    );
  }
}
