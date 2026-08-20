import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/legislation_controller.dart';
import '../../../consts.dart';

Widget addNewLegistlationOrEdit({
  required LegislationController controller,
  required BoxConstraints constraints,
}) {
  return Form(
    key: controller.legislationFormKey,
    child: LayoutBuilder(
      builder: (context, bodyConstraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            bodyConstraints.maxWidth < 680 ? 14 : 28,
            24,
            bodyConstraints.maxWidth < 680 ? 14 : 28,
            36,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PolicyOverview(controller: controller),
                  const SizedBox(height: 32),
                  const _SectionHeading(),
                  const SizedBox(height: 14),
                  _PolicyCardGrid(
                    children: [
                      _PolicyCard(
                        icon: Icons.medical_services_outlined,
                        title: 'Sick Leave',
                        description: 'Annual medical leave entitlement',
                        child: _ResponsiveFields(
                          children: [
                            _PolicyField(
                              label: 'Paid days',
                              controller: controller.numberOfPaidDays,
                              type: _PolicyFieldType.integer,
                            ),
                            _PolicyField(
                              label: 'Half-paid days',
                              controller: controller.numberOfHalfPaidDays,
                              type: _PolicyFieldType.integer,
                            ),
                            _PolicyField(
                              label: 'Unpaid days',
                              controller: controller.numberOfUnPaidDays,
                              type: _PolicyFieldType.integer,
                            ),
                          ],
                        ),
                      ),
                      _PolicyCard(
                        icon: Icons.family_restroom_outlined,
                        title: 'Family Leave',
                        description:
                            'Maternity, paternity, and compassionate leave',
                        child: _ResponsiveFields(
                          children: [
                            _PolicyField(
                              label: 'Maternity paid days',
                              controller: controller.meternityNumberOfPaidDays,
                              type: _PolicyFieldType.integer,
                            ),
                            _PolicyField(
                              label: 'Paternity paid days',
                              controller: controller.paternityNumberOfPaidDays,
                              type: _PolicyFieldType.integer,
                            ),
                            _PolicyField(
                              label: 'Compassionate paid days',
                              controller:
                                  controller.compassionateLeaveNumberOfPaidDays,
                              type: _PolicyFieldType.integer,
                            ),
                          ],
                        ),
                      ),
                      _PolicyCard(
                        icon: Icons.schedule_outlined,
                        title: 'Overtime',
                        description:
                            'Working hours used for overtime calculations',
                        child: _ResponsiveFields(
                          children: [
                            _PolicyField(
                              label: 'Normal working hours',
                              controller: controller
                                  .numberOfWorkingHoursForOvertimeNormal,
                              type: _PolicyFieldType.decimal,
                            ),
                            _PolicyField(
                              label: 'Holiday working hours',
                              controller: controller
                                  .numberOfWorkingHoursForOvertimeHolidays,
                              type: _PolicyFieldType.decimal,
                            ),
                          ],
                        ),
                      ),
                      _PolicyCard(
                        icon: Icons.workspace_premium_outlined,
                        title: 'Gratuity',
                        description: 'End-of-service days per completed year',
                        child: _ResponsiveFields(
                          children: [
                            _PolicyField(
                              label: 'First 5 years',
                              controller: controller.gratuityFirst5Years,
                              type: _PolicyFieldType.integer,
                            ),
                            _PolicyField(
                              label: 'After 5 years',
                              controller: controller.gratuityAfter5Years,
                              type: _PolicyFieldType.integer,
                            ),
                          ],
                        ),
                      ),
                      _PolicyCard(
                        icon: Icons.receipt_long_outlined,
                        title: 'Service Tax',
                        description: 'Flat tax applied to eligible earnings',
                        child: _ResponsiveFields(
                          children: [
                            _PolicyField(
                              label: 'Service tax percentage',
                              controller: controller.serviceTax,
                              type: _PolicyFieldType.decimal,
                              suffix: '%',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _SocialSecurityCard(controller: controller),
                  const SizedBox(height: 16),
                  _IncomeTaxCard(controller: controller),
                  const SizedBox(height: 22),
                  const Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 15,
                        color: Color(0xff7b8c91),
                      ),
                      SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          'Changes are applied after the legislation is saved.',
                          style: TextStyle(
                            color: Color(0xff7b8c91),
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

class _PolicyOverview extends StatelessWidget {
  const _PolicyOverview({required this.controller});

  final LegislationController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffd8e3e6)),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0f12373d),
            blurRadius: 34,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, overviewConstraints) {
          final wide = overviewConstraints.maxWidth >= 1040;
          final introduction = const _OverviewIntroduction();
          final nameField = _PolicyField(
            label: 'Policy name',
            controller: controller.name,
            isRequired: true,
            hintText: 'e.g. UAE legislation',
          );
          final weekend = _WeekendSelector(controller: controller);

          if (!wide) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                introduction,
                const SizedBox(height: 22),
                nameField,
                const SizedBox(height: 20),
                weekend,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Expanded(flex: 3, child: _OverviewIntroduction()),
              const SizedBox(width: 28),
              Expanded(flex: 3, child: nameField),
              const SizedBox(width: 28),
              Expanded(flex: 7, child: weekend),
            ],
          );
        },
      ),
    );
  }
}

class _OverviewIntroduction extends StatelessWidget {
  const _OverviewIntroduction();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xfffff4dd),
            border: Border.all(color: const Color(0xffefd6a8)),
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(
            Icons.policy_outlined,
            color: Color(0xff8d5e12),
            size: 23,
          ),
        ),
        const SizedBox(width: 13),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Policy details',
                style: TextStyle(
                  color: Color(0xff183138),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'General information and the standard weekly schedule.',
                style: TextStyle(
                  color: Color(0xff687a7f),
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WeekendSelector extends StatelessWidget {
  const _WeekendSelector({required this.controller});

  final LegislationController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weekend days',
          style: TextStyle(
            color: Color(0xff536568),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        Obx(
          () => Wrap(
            spacing: 7,
            runSpacing: 7,
            children: controller.weekDays.map((day) {
              final selected = controller.selectedDays.contains(day);
              return Tooltip(
                message: day,
                child: InkWell(
                  onTap: () {
                    if (selected) {
                      controller.selectedDays.remove(day);
                    } else {
                      controller.selectedDays.add(day);
                    }
                  },
                  borderRadius: BorderRadius.circular(7),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 140),
                    height: 42,
                    constraints: const BoxConstraints(minWidth: 68),
                    padding: const EdgeInsets.symmetric(horizontal: 11),
                    decoration: BoxDecoration(
                      color: selected
                          ? mainColor.withValues(alpha: 0.09)
                          : const Color(0xfffafcfc),
                      border: Border.all(
                        color: selected ? mainColor : const Color(0xffc8d6d9),
                      ),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          selected
                              ? Icons.check_box_rounded
                              : Icons.check_box_outline_blank_rounded,
                          size: 16,
                          color: selected ? mainColor : const Color(0xff7a898d),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          day.substring(0, 3),
                          style: TextStyle(
                            color: selected
                                ? mainColor
                                : const Color(0xff586a6f),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'STATUTORY RULES',
                style: TextStyle(
                  color: Color(0xff005f95),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 7),
              Text(
                'Employment entitlements',
                style: TextStyle(
                  color: Color(0xff183138),
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        Text(
          '10 policy areas',
          style: TextStyle(color: Color(0xff74868b), fontSize: 11),
        ),
      ],
    );
  }
}

class _PolicyCardGrid extends StatelessWidget {
  const _PolicyCardGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, gridConstraints) {
        const gap = 16.0;
        final columns = gridConstraints.maxWidth >= 980 ? 2 : 1;
        final width = columns == 2
            ? (gridConstraints.maxWidth - gap) / 2
            : gridConstraints.maxWidth;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: children
              .map((child) => SizedBox(width: width, child: child))
              .toList(),
        );
      },
    );
  }
}

class _PolicyCard extends StatelessWidget {
  const _PolicyCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.child,
  });

  final IconData icon;
  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffd8e3e6)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0b12373d),
            blurRadius: 26,
            offset: Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            constraints: const BoxConstraints(minHeight: 76),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffe3ebed))),
            ),
            child: Row(
              children: [
                Container(
                  width: 39,
                  height: 39,
                  decoration: BoxDecoration(
                    color: mainColor.withValues(alpha: 0.08),
                    border: Border.all(
                      color: mainColor.withValues(alpha: 0.18),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 20, color: mainColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xff183138),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        description,
                        style: const TextStyle(
                          color: Color(0xff6b7d82),
                          fontSize: 11,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.all(20), child: child),
        ],
      ),
    );
  }
}

class _ResponsiveFields extends StatelessWidget {
  const _ResponsiveFields({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, fieldConstraints) {
        const gap = 14.0;
        final maxColumns = fieldConstraints.maxWidth >= 590
            ? 3
            : fieldConstraints.maxWidth >= 360
            ? 2
            : 1;
        final columns = children.length < maxColumns
            ? children.length
            : maxColumns;
        final width =
            (fieldConstraints.maxWidth - (gap * (columns - 1))) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: 14,
          children: children
              .map((child) => SizedBox(width: width, child: child))
              .toList(),
        );
      },
    );
  }
}

class _SocialSecurityCard extends StatelessWidget {
  const _SocialSecurityCard({required this.controller});

  final LegislationController controller;

  @override
  Widget build(BuildContext context) {
    return _PolicyCard(
      icon: Icons.percent_rounded,
      title: 'Social Security',
      description: 'Dated ceiling lines with their employee and employer rates',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, headingConstraints) {
              final compact = headingConstraints.maxWidth < 560;
              final heading = const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ceiling lines',
                    style: TextStyle(
                      color: Color(0xff203a41),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Add a separate effective period for every ceiling amount.',
                    style: TextStyle(color: Color(0xff73858a), fontSize: 11),
                  ),
                ],
              );
              final addButton = OutlinedButton.icon(
                onPressed: () => controller.addSocialSecurityCeiling(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: mainColor,
                  minimumSize: const Size(140, 40),
                  side: const BorderSide(color: Color(0xffc8d7db)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text(
                  'Add new line',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              );

              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [heading, const SizedBox(height: 12), addButton],
                );
              }
              return Row(
                children: [
                  Expanded(child: heading),
                  const SizedBox(width: 16),
                  addButton,
                ],
              );
            },
          ),
          const SizedBox(height: 14),
          Obx(
            () => Column(
              children: controller.socialSecurityCeilings.asMap().entries.map((
                entry,
              ) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _SocialSecurityCeilingRow(
                    index: entry.key,
                    line: entry.value,
                    onDelete: () =>
                        controller.removeSocialSecurityCeiling(entry.key),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialSecurityCeilingRow extends StatelessWidget {
  const _SocialSecurityCeilingRow({
    required this.index,
    required this.line,
    required this.onDelete,
  });

  final int index;
  final SocialSecurityCeilingController line;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: index.isEven ? const Color(0xfff7fafb) : const Color(0xfffbfcfc),
        border: Border.all(color: const Color(0xffdce6e8)),
        borderRadius: BorderRadius.circular(9),
      ),
      child: LayoutBuilder(
        builder: (context, rowConstraints) {
          final fields = <Widget>[
            _PolicyField(
              label: 'Employee percentage',
              controller: line.employeePercentage,
              type: _PolicyFieldType.decimal,
              suffix: '%',
            ),
            _PolicyField(
              label: 'Employer percentage',
              controller: line.employerPercentage,
              type: _PolicyFieldType.decimal,
              suffix: '%',
            ),
            _PolicyField(
              label: 'Ceiling',
              controller: line.ceiling,
              type: _PolicyFieldType.decimal,
            ),
            _PolicyDateField(label: 'Start date', controller: line.startDate),
            _PolicyDateField(
              label: 'End date',
              controller: line.endDate,
              hintText: 'No end date',
            ),
          ];
          final deleteButton = IconButton(
            onPressed: onDelete,
            tooltip: 'Remove ceiling line',
            style: IconButton.styleFrom(
              foregroundColor: const Color(0xff7f9095),
              hoverColor: const Color(0xffffebee),
            ),
            icon: const Icon(Icons.delete_outline_rounded, size: 20),
          );
          final lineNumber = Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: mainColor.withValues(alpha: 0.08),
              border: Border.all(color: mainColor.withValues(alpha: 0.18)),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: mainColor,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          );

          if (rowConstraints.maxWidth < 1050) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(children: [lineNumber, const Spacer(), deleteButton]),
                const SizedBox(height: 8),
                _ResponsiveFields(children: fields),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: lineNumber,
              ),
              const SizedBox(width: 12),
              for (
                var fieldIndex = 0;
                fieldIndex < fields.length;
                fieldIndex++
              ) ...[
                Expanded(child: fields[fieldIndex]),
                if (fieldIndex < fields.length - 1) const SizedBox(width: 12),
              ],
              const SizedBox(width: 6),
              deleteButton,
            ],
          );
        },
      ),
    );
  }
}

class _IncomeTaxCard extends StatelessWidget {
  const _IncomeTaxCard({required this.controller});

  final LegislationController controller;

  @override
  Widget build(BuildContext context) {
    return _PolicyCard(
      icon: Icons.account_balance_outlined,
      title: 'Income Tax',
      description: 'Fallback values and progressive income tax brackets',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ResponsiveFields(
            children: [
              _PolicyField(
                label: 'Fallback percentage',
                controller: controller.incomeTaxPercentage,
                type: _PolicyFieldType.decimal,
                suffix: '%',
              ),
              _PolicyField(
                label: 'Fallback ceiling',
                controller: controller.incomeTaxCeiling,
                type: _PolicyFieldType.decimal,
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(height: 1, color: Color(0xffe2eaec)),
          ),
          LayoutBuilder(
            builder: (context, headingConstraints) {
              final compact = headingConstraints.maxWidth < 560;
              final copy = const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tax brackets',
                    style: TextStyle(
                      color: Color(0xff203a41),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Progressive rates are applied from the lowest band upward.',
                    style: TextStyle(color: Color(0xff73858a), fontSize: 11),
                  ),
                ],
              );
              final addButton = OutlinedButton.icon(
                onPressed: () => controller.addIncomeTaxBracket(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: mainColor,
                  minimumSize: const Size(130, 40),
                  side: const BorderSide(color: Color(0xffc8d7db)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text(
                  'Add bracket',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              );

              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [copy, const SizedBox(height: 12), addButton],
                );
              }
              return Row(
                children: [
                  Expanded(child: copy),
                  const SizedBox(width: 16),
                  addButton,
                ],
              );
            },
          ),
          const SizedBox(height: 14),
          Obx(
            () => Column(
              children: controller.incomeTaxBrackets.asMap().entries.map((
                entry,
              ) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _TaxBracketRow(
                    index: entry.key,
                    bracket: entry.value,
                    onDelete: () =>
                        controller.removeIncomeTaxBracket(entry.key),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaxBracketRow extends StatelessWidget {
  const _TaxBracketRow({
    required this.index,
    required this.bracket,
    required this.onDelete,
  });

  final int index;
  final IncomeTaxBracketController bracket;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: index.isEven ? const Color(0xfff7fafb) : const Color(0xfffbfcfc),
        border: Border.all(color: const Color(0xffdce6e8)),
        borderRadius: BorderRadius.circular(9),
      ),
      child: LayoutBuilder(
        builder: (context, rowConstraints) {
          final fields = [
            _PolicyField(
              label: 'From',
              controller: bracket.fromAmount,
              type: _PolicyFieldType.decimal,
            ),
            _PolicyField(
              label: 'To',
              controller: bracket.toAmount,
              type: _PolicyFieldType.decimal,
              hintText: 'No limit',
            ),
            _PolicyField(
              label: 'Percentage',
              controller: bracket.percentage,
              type: _PolicyFieldType.decimal,
              suffix: '%',
            ),
          ];

          final deleteButton = IconButton(
            onPressed: onDelete,
            tooltip: 'Remove bracket',
            style: IconButton.styleFrom(
              foregroundColor: const Color(0xff7f9095),
              hoverColor: const Color(0xffffebee),
            ),
            icon: const Icon(Icons.delete_outline_rounded, size: 20),
          );

          if (rowConstraints.maxWidth < 650) {
            return Column(
              children: [
                _ResponsiveFields(children: fields),
                const SizedBox(height: 5),
                Align(alignment: Alignment.centerRight, child: deleteButton),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < fields.length; i++) ...[
                Expanded(child: fields[i]),
                if (i < fields.length - 1) const SizedBox(width: 12),
              ],
              const SizedBox(width: 6),
              deleteButton,
            ],
          );
        },
      ),
    );
  }
}

class _PolicyDateField extends StatelessWidget {
  const _PolicyDateField({
    required this.label,
    required this.controller,
    this.hintText = 'dd-mm-yyyy',
  });

  final String label;
  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xff536568),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, child) {
            return TextFormField(
              controller: controller,
              readOnly: true,
              onTap: () => selectDateContext(context, controller),
              style: const TextStyle(
                color: Color(0xff183138),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Color(0xff9aa7aa),
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
                suffixIcon: value.text.isEmpty
                    ? const Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: Color(0xff718388),
                      )
                    : IconButton(
                        tooltip: 'Clear date',
                        onPressed: controller.clear,
                        icon: const Icon(Icons.close_rounded, size: 17),
                      ),
                filled: true,
                fillColor: const Color(0xfffbfcfc),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 13,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: const BorderSide(color: Color(0xffc7d5d8)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: BorderSide(color: mainColor, width: 1.4),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: const BorderSide(color: Color(0xffc74b50)),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: const BorderSide(
                    color: Color(0xffc74b50),
                    width: 1.4,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

enum _PolicyFieldType { text, integer, decimal }

class _PolicyField extends StatelessWidget {
  const _PolicyField({
    required this.label,
    required this.controller,
    this.type = _PolicyFieldType.text,
    this.suffix,
    this.hintText,
    this.isRequired = false,
  });

  final String label;
  final TextEditingController controller;
  final _PolicyFieldType type;
  final String? suffix;
  final String? hintText;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final numeric = type != _PolicyFieldType.text;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xff536568),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          keyboardType: numeric
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          inputFormatters: numeric
              ? [
                  _PolicyNumberFormatter(
                    allowDecimal: type == _PolicyFieldType.decimal,
                  ),
                ]
              : null,
          validator: (value) {
            final text = value?.trim() ?? '';
            if (isRequired && text.isEmpty) {
              return 'Policy name is required';
            }
            if (numeric && text.isNotEmpty && double.tryParse(text) == null) {
              return 'Enter a valid number';
            }
            return null;
          },
          style: const TextStyle(
            color: Color(0xff183138),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color(0xff9aa7aa),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            suffixText: suffix,
            suffixStyle: const TextStyle(
              color: Color(0xff617378),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
            filled: true,
            fillColor: const Color(0xfffbfcfc),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 13,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: Color(0xffc7d5d8)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: BorderSide(color: mainColor, width: 1.4),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(color: Color(0xffc74b50)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7),
              borderSide: const BorderSide(
                color: Color(0xffc74b50),
                width: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PolicyNumberFormatter extends TextInputFormatter {
  const _PolicyNumberFormatter({required this.allowDecimal});

  final bool allowDecimal;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    final pattern = allowDecimal ? r'^\d*\.?\d*$' : r'^\d+$';
    return RegExp(pattern).hasMatch(newValue.text) ? newValue : oldValue;
  }
}
