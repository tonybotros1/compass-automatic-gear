import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';

const _slate = Color(0xFF334155);
const _muted = Color(0xFF64748B);

Widget addNewSalesAgreementItemOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required CarTradingDashboardController controller,
  required bool canEdit,
}) {
  return GetBuilder<CarTradingDashboardController>(
    builder: (controller) {
      return Form(
        key: controller.salesAgreementFormKey,
        child: FocusTraversalGroup(
          policy: WidgetOrderTraversalPolicy(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 4),
            child: Column(
              spacing: 14,
              children: [
                _AgreementSection(
                  icon: Icons.description_outlined,
                  title: 'Agreement details',
                  subtitle: 'Reference and effective date',
                  child: _ResponsiveFieldRow(
                    children: [
                      myTextFormFieldWithBorder(
                        labelText: 'Agreement Number',
                        hintText: 'Generated automatically',
                        isEnabled: false,
                        controller: controller.agreementNumber,
                        validate: false,
                      ),
                      myTextFormFieldWithBorder(
                        labelText: 'Agreement Date',
                        hintText: 'DD/MM/YYYY',
                        controller: controller.agreementdate,
                        isEnabled: canEdit,
                      ),
                    ],
                  ),
                ),
                _AgreementSection(
                  icon: Icons.people_alt_outlined,
                  title: 'Parties',
                  subtitle: 'Seller and buyer contact information',
                  child: _ResponsiveFieldRow(
                    breakpoint: 720,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PartyCard(
                        icon: Icons.person_outline_rounded,
                        title: 'Seller',
                        color: const Color(0xFF2563EB),
                        children: [
                          myTextFormFieldWithBorder(
                            labelText: 'Seller Name',
                            hintText: 'Enter full name',
                            controller: controller.sellerName,
                            isEnabled: canEdit,
                          ),
                          myTextFormFieldWithBorder(
                            labelText: 'Seller ID',
                            hintText: 'ID or passport number',
                            controller: controller.sellerID,
                            validate: false,
                            isEnabled: canEdit,
                          ),
                          myTextFormFieldWithBorder(
                            labelText: 'Seller Phone',
                            hintText: 'Phone number',
                            controller: controller.sellerPhone,
                            validate: false,
                            isEnabled: canEdit,
                          ),
                          myTextFormFieldWithBorder(
                            labelText: 'Seller Email',
                            hintText: 'Email address',
                            controller: controller.sellerEmail,
                            validate: false,
                            isEnabled: canEdit,
                          ),
                        ],
                      ),
                      _PartyCard(
                        icon: Icons.person_outline_rounded,
                        title: 'Buyer',
                        color: const Color(0xFF059669),
                        children: [
                          myTextFormFieldWithBorder(
                            labelText: 'Buyer Name',
                            hintText: 'Enter full name',
                            controller: controller.buyerName,
                            isEnabled: canEdit,
                          ),
                          myTextFormFieldWithBorder(
                            labelText: 'Buyer ID',
                            hintText: 'ID or passport number',
                            controller: controller.buyerID,
                            validate: false,
                            isEnabled: canEdit,
                          ),
                          myTextFormFieldWithBorder(
                            labelText: 'Buyer Phone',
                            hintText: 'Phone number',
                            controller: controller.buyerPhone,
                            validate: false,
                            isEnabled: canEdit,
                          ),
                          myTextFormFieldWithBorder(
                            labelText: 'Buyer Email',
                            hintText: 'Email address',
                            controller: controller.buyerEmail,
                            validate: false,
                            isEnabled: canEdit,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _AgreementSection(
                  icon: Icons.payments_outlined,
                  title: 'Payment details',
                  subtitle: 'Agreed sale value and initial payment',
                  child: _ResponsiveFieldRow(
                    children: [
                      myTextFormFieldWithBorder(
                        isDouble: true,
                        labelText: 'Total Amount',
                        hintText: '0.00',
                        controller: controller.agreementTotal,
                        isEnabled: canEdit,
                      ),
                      myTextFormFieldWithBorder(
                        isDouble: true,
                        labelText: 'Down Payment',
                        hintText: '0.00',
                        controller: controller.agreementdownpayment,
                        validate: false,
                        isEnabled: canEdit,
                      ),
                    ],
                  ),
                ),
                _AgreementSection(
                  icon: Icons.notes_rounded,
                  title: 'Additional notes',
                  subtitle: 'Optional terms or information for this agreement',
                  child: myTextFormFieldWithBorder(
                    labelText: 'Notes',
                    hintText: 'Add any relevant terms or comments...',
                    minLines: 4,
                    maxLines: 6,
                    controller: controller.agreementNote,
                    validate: false,
                    isEnabled: canEdit,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _AgreementSection extends StatelessWidget {
  const _AgreementSection({
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
      padding: const EdgeInsets.all(16),
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
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 19, color: _slate),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _PartyCard extends StatelessWidget {
  const _PartyCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.children,
  });

  final IconData icon;
  final String title;
  final Color color;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 29,
                height: 29,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 17, color: color),
              ),
              const SizedBox(width: 9),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          ...children.expand(
            (field) => [
              field,
              if (field != children.last) const SizedBox(height: 11),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResponsiveFieldRow extends StatelessWidget {
  const _ResponsiveFieldRow({
    required this.children,
    this.breakpoint = 560,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final List<Widget> children;
  final double breakpoint;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < breakpoint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children
                .expand(
                  (field) => [
                    field,
                    if (field != children.last) const SizedBox(height: 12),
                  ],
                )
                .toList(),
          );
        }

        return Row(
          crossAxisAlignment: crossAxisAlignment,
          children: children
              .expand(
                (field) => [
                  Expanded(child: field),
                  if (field != children.last) const SizedBox(width: 14),
                ],
              )
              .toList(),
        );
      },
    );
  }
}
