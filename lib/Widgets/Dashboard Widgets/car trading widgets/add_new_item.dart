import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../consts.dart';
import '../../main screen widgets/add_new_values_button.dart';

const _itemFormSlate = Color(0xFF334155);
const _itemFormMuted = Color(0xFF64748B);

Widget addNewItemOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required CarTradingDashboardController controller,
  required bool canEdit,
  required bool isGeneralExpenses,
  required bool isTrade,
}) {
  return GetBuilder<CarTradingDashboardController>(
    builder: (controller) {
      final usesItemList = isTrade || isGeneralExpenses;

      return Form(
        key: controller.lineItemFormKey,
        child: FocusTraversalGroup(
          policy: WidgetOrderTraversalPolicy(),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 4),
            children: [
              _ItemFormSection(
                icon: Icons.receipt_long_outlined,
                title: 'Entry details',
                subtitle: usesItemList
                    ? 'Choose the item and account for this entry'
                    : 'Choose the person and account for this entry',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    myTextFormFieldWithBorder(
                      width: 200,
                      focusNode: controller.focusNodeForitems1,
                      onFieldSubmitted: (_) {
                        normalizeDate(
                          controller.itemDate.value.text,
                          controller.itemDate.value,
                        );
                      },
                      onTapOutside: (_) {
                        normalizeDate(
                          controller.itemDate.value.text,
                          controller.itemDate.value,
                        );
                      },
                      validate: true,
                      controller: controller.itemDate.value,
                      labelText: 'Date',
                      hintText: 'DD/MM/YYYY',
                      isEnabled: canEdit,
                      suffixIcon: IconButton(
                        focusNode: FocusNode(skipTraversal: true),
                        onPressed: canEdit
                            ? () async {
                                selectDateContext(
                                  context,
                                  controller.itemDate.value,
                                );
                              }
                            : null,
                        icon: const Icon(
                          Icons.calendar_today_outlined,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 11),
                    if (usesItemList)
                      _SelectionField(
                        dropdown: CustomDropdown(
                          validator: true,
                          textcontroller: controller.item.text,
                          showedSelectedName: 'name',
                          hintText: 'Item',
                          enabled: canEdit,
                          onChanged: (key, value) {
                            controller.item.text = value['name'];
                            controller.itemId.value = key;
                          },
                          onDelete: () {
                            controller.item.clear();
                            controller.itemId.value = '';
                          },
                          onOpen: controller.getItems,
                        ),
                        action: valSectionInTheTable(
                          controller.listOfValuesController,
                          constraints,
                          'ITEMS',
                          'New Item',
                          'Items',
                          isEnabled: canEdit,
                        ),
                      )
                    else
                      _SelectionField(
                        dropdown: CustomDropdown(
                          validator: true,
                          textcontroller: controller.name.text,
                          showedSelectedName: 'name',
                          hintText: 'Name',
                          enabled: canEdit,
                          onChanged: (key, value) {
                            controller.name.text = value['name'];
                            controller.nameId.value = key;
                          },
                          onDelete: () {
                            controller.name.clear();
                            controller.nameId.value = '';
                          },
                          onOpen: controller.getNamesOfPeople,
                        ),
                        action: valSectionInTheTable(
                          controller.listOfValuesController,
                          constraints,
                          'NAMES_OF_PEOPLE',
                          'New Name',
                          'Names of People',
                          isEnabled: canEdit,
                        ),
                      ),
                    const SizedBox(height: 11),
                    _SelectionField(
                      dropdown: CustomDropdown(
                        validator: true,
                        textcontroller: controller.accountName.text,
                        hintText: 'Account Name',
                        showedSelectedName: 'name',
                        enabled: canEdit,
                        onChanged: (key, value) {
                          controller.accountNameId.value = key;
                          controller.accountName.text = value['name'];
                        },
                        onDelete: () {
                          controller.accountNameId.value = '';
                          controller.accountName.clear();
                        },
                        onOpen: controller.getNamesOfAccount,
                      ),
                      action: valSectionInTheTable(
                        controller.listOfValuesController,
                        constraints,
                        'CAR_TRADING_CASH_BANK',
                        'New Account',
                        'Car trading Cash Bank',
                        isEnabled: canEdit,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _ItemFormSection(
                icon: Icons.payments_outlined,
                title: 'Amounts',
                subtitle: 'Enter the money paid, received, or both',
                child: _ResponsiveAmountFields(
                  children: [
                    myTextFormFieldWithBorder(
                      focusNode: controller.focusNodeForitems3,
                      controller: controller.pay,
                      labelText: 'Paid',
                      hintText: '0.00',
                      isDouble: true,
                      validate: false,
                      isEnabled: canEdit,
                    ),
                    myTextFormFieldWithBorder(
                      focusNode: controller.focusNodeForitems4,
                      controller: controller.receive,
                      labelText: 'Received',
                      hintText: '0.00',
                      isDouble: true,
                      validate: false,
                      isEnabled: canEdit,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _ItemFormSection(
                icon: Icons.notes_rounded,
                title: 'Comments',
                subtitle: 'Optional details about this entry',
                child: myTextFormFieldWithBorder(
                  focusNode: controller.focusNodeForitems5,
                  controller: controller.comments.value,
                  labelText: 'Comments',
                  hintText: 'Add any useful details...',
                  validate: false,
                  minLines: 3,
                  maxLines: 5,
                  isEnabled: canEdit,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _ItemFormSection extends StatelessWidget {
  const _ItemFormSection({
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
                child: Icon(icon, size: 18, color: _itemFormSlate),
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
                        color: _itemFormMuted,
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

class _SelectionField extends StatelessWidget {
  const _SelectionField({required this.dropdown, required this.action});

  final Widget dropdown;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: dropdown),
        const SizedBox(width: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: action,
        ),
      ],
    );
  }
}

class _ResponsiveAmountFields extends StatelessWidget {
  const _ResponsiveAmountFields({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 360) {
          return Column(
            children: children
                .expand(
                  (field) => [
                    field,
                    if (field != children.last) const SizedBox(height: 11),
                  ],
                )
                .toList(),
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children
              .expand(
                (field) => [
                  Expanded(child: field),
                  if (field != children.last) const SizedBox(width: 12),
                ],
              )
              .toList(),
        );
      },
    );
  }
}
