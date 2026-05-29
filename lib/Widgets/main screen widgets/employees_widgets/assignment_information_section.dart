import 'dart:math' as math;

import 'package:datahubai/Controllers/Main%20screen%20controllers/employees_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../consts.dart';
import '../../menu_dialog.dart';
import '../../my_text_field.dart';
import '../add_new_values_button.dart';
import 'balances_section.dart';

const _sectionBorderColor = Color(0xff8fa9b9);
const _cardBorderColor = Color(0xffd7e0e6);
const _cardHeaderColor = Color(0xfff4f7f9);
const _titleColor = Color(0xff51616b);
const _mutedTextColor = Color(0xff7b8991);
const _accentBlueColor = Color(0xff06699a);
const _positiveColor = Color(0xff35a853);
const _negativeColor = Color(0xffff4d4f);
const _desktopTopGridHeight = 265.0;

Container assignmentInformation(
  BuildContext context,
  BoxConstraints constraints,
  EmployeesController controller, {
  double height = 410,
}) {
  return Container(
    height: height,
    width: double.infinity,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: Colors.white,
      border: const Border(
        left: BorderSide(color: _sectionBorderColor),
        right: BorderSide(color: _sectionBorderColor),
        bottom: BorderSide(color: _sectionBorderColor),
      ),
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(6),
        bottomRight: Radius.circular(6),
      ),
      boxShadow: [
        BoxShadow(
          color: const Color(0xff15374b).withValues(alpha: 0.08),
          blurRadius: 25,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        spacing: 18,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AssignmentTopGrid(
            context: context,
            controller: controller,
            constraints: constraints,
          ),
          balancesSection(constraints),
        ],
      ),
    ),
  );
}

class _AssignmentTopGrid extends StatelessWidget {
  const _AssignmentTopGrid({
    required this.context,
    required this.controller,
    required this.constraints,
  });

  final BuildContext context;
  final EmployeesController controller;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        if (box.maxWidth <= 1200) {
          return Column(
            spacing: 18,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _EmploymentDetailsCard(
                controller: controller,
                constraints: constraints,
              ),
              _ContractDatesCard(
                context: this.context,
                controller: controller,
                stackService: box.maxWidth <= 650,
              ),
            ],
          );
        }

        return SizedBox(
          height: _desktopTopGridHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 5,
                child: _EmploymentDetailsCard(
                  controller: controller,
                  constraints: constraints,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                flex: 4,
                child: _ContractDatesCard(
                  context: this.context,
                  controller: controller,
                  stackService: false,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EmploymentDetailsCard extends StatelessWidget {
  const _EmploymentDetailsCard({
    required this.controller,
    required this.constraints,
  });

  final EmployeesController controller;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return _AssignmentCard(
      title: 'Employment Details',
      trailing: Obx(
        () => _StatusBadge(
          label: _assignmentBadgeLabel(controller.employeeStatus.value),
          color: _statusColor(controller.employeeStatus.value),
        ),
      ),
      child: _ResponsiveFieldGrid(
        minSingleColumnWidth: 650,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: MenuWithValues(
                  labelText: 'Employer',
                  headerLqabel: 'Employers',
                  dialogWidth: 600,
                  width: double.infinity,
                  controller: controller.jobEmployer,
                  displayKeys: const ['name'],
                  displaySelectedKeys: const ['name'],
                  onOpen: () {
                    return controller.getallJobEmployers();
                  },
                  onDelete: () {
                    controller.jobEmployer.clear();
                    controller.jobEmployerId.value = '';
                  },
                  onSelected: (value) {
                    controller.jobEmployer.text = value['name'];
                    controller.jobEmployerId.value = value['_id'];
                  },
                ),
              ),
              valSectionInTheTable(
                controller.listOfValuesController,
                constraints,
                'EMPLOYERS',
                'New Employer',
                'Employers',
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: MenuWithValues(
                  labelText: 'Department',
                  headerLqabel: 'Departments',
                  dialogWidth: 600,
                  width: double.infinity,
                  controller: controller.jobDepartment,
                  displayKeys: const ['name'],
                  displaySelectedKeys: const ['name'],
                  onOpen: () {
                    return controller.getAllJobDepartments();
                  },
                  onDelete: () {
                    controller.jobDepartment.clear();
                    controller.jobDepartmentId.value = '';
                  },
                  onSelected: (value) {
                    controller.jobDepartment.text = value['name'];
                    controller.jobDepartmentId.value = value['_id'];
                  },
                ),
              ),
              valSectionInTheTable(
                controller.listOfValuesController,
                constraints,
                'DEPARTMENTS',
                'New Department',
                'Departments',
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: MenuWithValues(
                  labelText: 'Job Title',
                  headerLqabel: 'Job Titles',
                  dialogWidth: 600,
                  width: double.infinity,
                  controller: controller.jobTitle,
                  displayKeys: const ['name'],
                  displaySelectedKeys: const ['name'],
                  onOpen: () {
                    return controller.getallJobTitle();
                  },
                  onDelete: () {
                    controller.jobTitle.clear();
                    controller.jobTitleId.value = '';
                  },
                  onSelected: (value) {
                    controller.jobTitle.text = value['name'];
                    controller.jobTitleId.value = value['_id'];
                  },
                ),
              ),
              valSectionInTheTable(
                controller.listOfValuesController,
                constraints,
                'JOBS',
                'New Job',
                'Jobs',
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: MenuWithValues(
                  labelText: 'Location',
                  headerLqabel: 'Locations',
                  dialogWidth: 600,
                  width: double.infinity,
                  controller: controller.jobLocation,
                  displayKeys: const ['name'],
                  displaySelectedKeys: const ['name'],
                  onOpen: () {
                    return controller.getallJobLocations();
                  },
                  onDelete: () {
                    controller.jobLocation.clear();
                    controller.jobLocationId.value = '';
                  },
                  onSelected: (value) {
                    controller.jobLocation.text = value['name'];
                    controller.jobLocationId.value = value['_id'];
                  },
                ),
              ),
              valSectionInTheTable(
                controller.listOfValuesController,
                constraints,
                'LOCATIONS',
                'New Location',
                'Locations',
              ),
            ],
          ),
          MenuWithValues(
            labelText: 'Reporting Manager',
            headerLqabel: 'Reporting Managers',
            dialogWidth: 600,
            width: double.infinity,
            controller: controller.reportingManager,
            displayKeys: const ['full_name'],
            displaySelectedKeys: const ['full_name'],
            onOpen: () {
              return controller.getAllReporingManagers(
                controller.currentEmployeeId.value,
                controller.jobEmployerId.value,
              );
            },
            onDelete: () {
              controller.reportingManager.clear();
              controller.reportingManagerId.value = '';
            },
            onSelected: (value) {
              controller.reportingManager.text = value['full_name'];
              controller.reportingManagerId.value = value['_id'];
            },
          ),
          MenuWithValues(
            labelText: 'Payroll',
            headerLqabel: 'Payrolls',
            dialogWidth: 600,
            width: double.infinity,
            controller: controller.payroll,
            displayKeys: const ['name'],
            displaySelectedKeys: const ['name'],
            onOpen: () {
              return controller.getAllPayrolls();
            },
            onDelete: () {
              controller.payroll.clear();
              controller.payrollId.value = '';
            },
            onSelected: (value) {
              controller.payroll.text = value['name'];
              controller.payrollId.value = value['_id'];
            },
          ),
        ],
      ),
    );
  }
}

class _ContractDatesCard extends StatelessWidget {
  const _ContractDatesCard({
    required this.context,
    required this.controller,
    required this.stackService,
  });

  final BuildContext context;
  final EmployeesController controller;
  final bool stackService;

  @override
  Widget build(BuildContext context) {
    return _AssignmentCard(
      title: 'Contract Dates',
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ResponsiveFieldGrid(
            minSingleColumnWidth: 500,
            horizontalGap: 13,
            children: [
              myTextFormFieldWithBorder(
                labelText: 'Hire Date',
                width: double.infinity,
                isDate: true,
                controller: controller.hireDate,
                suffixIcon: IconButton(
                  onPressed: () async {
                    selectDateContext(this.context, controller.hireDate);
                  },
                  icon: const Icon(
                    Icons.date_range,
                    color: _mutedTextColor,
                    size: 18,
                  ),
                ),
                onFieldSubmitted: (_) async {
                  normalizeDate(controller.hireDate.text, controller.hireDate);
                },
              ),
              myTextFormFieldWithBorder(
                labelText: 'End Date',
                width: double.infinity,
                controller: controller.endDate,
                isDate: true,
                suffixIcon: IconButton(
                  onPressed: () async {
                    selectDateContext(this.context, controller.endDate);
                  },
                  icon: const Icon(
                    Icons.date_range,
                    color: _mutedTextColor,
                    size: 18,
                  ),
                ),
                onFieldSubmitted: (_) async {
                  normalizeDate(controller.endDate.text, controller.endDate);
                },
              ),
            ],
          ),
          _ServiceSummary(controller: controller, stacked: stackService),
          // _ContractSummary(controller: controller, stacked: stackSummary),
        ],
      ),
    );
  }
}

class _ServiceSummary extends StatelessWidget {
  const _ServiceSummary({required this.controller, required this.stacked});

  final EmployeesController controller;
  final bool stacked;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.hireDate,
      builder: (context, _) {
        return AnimatedBuilder(
          animation: controller.endDate,
          builder: (context, _) {
            final duration = _serviceDuration(
              controller.hireDate.text,
              controller.endDate.text,
            );

            return Obx(
              () => _ServiceBox(
                months: duration.months,
                days: duration.days,
                status: _displayOrDash(controller.employeeStatus.value),
                stacked: stacked,
              ),
            );
          },
        );
      },
    );
  }
}

// class _ContractSummary extends StatelessWidget {
//   const _ContractSummary({required this.controller, required this.stacked});

//   final EmployeesController controller;
//   final bool stacked;

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: controller.employeeLegislation,
//       builder: (context, _) {
//         return Obx(
//           () => _SummaryGrid(
//             stacked: stacked,
//             children: [
//               _SummaryBox(
//                 label: 'LEGISLATION',
//                 value: _displayOrDash(controller.employeeLegislation.text),
//               ),
//               _SummaryBox(
//                 label: 'PERSON TYPE',
//                 value: _displayOrDash(controller.personType.value),
//               ),
//               const _SummaryBox(label: 'ASSIGNMENT', value: 'Primary'),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

class _AssignmentCard extends StatelessWidget {
  const _AssignmentCard({
    required this.title,
    required this.child,
    this.trailing,
  });

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _cardBorderColor),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: const BoxDecoration(
              color: _cardHeaderColor,
              border: Border(bottom: BorderSide(color: _cardBorderColor)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _monoStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: _titleColor,
                    ),
                  ),
                ),
                if (trailing != null) ...[const SizedBox(width: 12), trailing!],
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.all(15), child: child),
        ],
      ),
    );
  }
}

class _ResponsiveFieldGrid extends StatelessWidget {
  const _ResponsiveFieldGrid({
    required this.children,
    this.minSingleColumnWidth = 650,
    this.horizontalGap = 16,
  });

  final List<Widget> children;
  final double minSingleColumnWidth;
  final double horizontalGap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final columns = box.maxWidth <= minSingleColumnWidth ? 1 : 2;
        final totalGap = horizontalGap * (columns - 1);
        final childWidth = (box.maxWidth - totalGap) / columns;

        return Wrap(
          spacing: horizontalGap,
          runSpacing: 13,
          children: children
              .map((child) => SizedBox(width: childWidth, child: child))
              .toList(),
        );
      },
    );
  }
}

class _ServiceBox extends StatelessWidget {
  const _ServiceBox({
    required this.months,
    required this.days,
    required this.status,
    required this.stacked,
  });

  final int? months;
  final int? days;
  final String status;
  final bool stacked;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: const _DashedRoundedBorderPainter(
        color: Color(0xffb7c7d0),
        radius: 6,
      ),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: const Color(0xfff8fafb),
          borderRadius: BorderRadius.circular(6),
        ),
        child: LayoutBuilder(
          builder: (context, box) {
            final columns = stacked ? 1 : 3;
            const gap = 10.0;
            final width = columns == 1
                ? box.maxWidth
                : (box.maxWidth - gap * (columns - 1)) / columns;

            return Wrap(
              spacing: gap,
              runSpacing: gap,
              alignment: WrapAlignment.center,
              children: [
                _ServiceItem(value: months?.toString() ?? '--', label: 'MONTH'),
                _ServiceItem(value: days?.toString() ?? '--', label: 'DAYS'),
                _ServiceItem(value: status, label: 'STATUS'),
              ].map((child) => SizedBox(width: width, child: child)).toList(),
            );
          },
        ),
      ),
    );
  }
}

class _DashedRoundedBorderPainter extends CustomPainter {
  const _DashedRoundedBorderPainter({
    required this.color,
    required this.radius,
  });

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = math.min(distance + 5, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += 9;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedRoundedBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}

class _ServiceItem extends StatelessWidget {
  const _ServiceItem({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: _monoStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: _accentBlueColor,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: _monoStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: const Color(0xff6d7b84),
          ),
        ),
      ],
    );
  }
}

// class _SummaryGrid extends StatelessWidget {
//   const _SummaryGrid({required this.children, required this.stacked});

//   final List<Widget> children;
//   final bool stacked;

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, box) {
//         final columns = stacked ? 1 : 3;
//         const gap = 12.0;
//         final width = columns == 1
//             ? box.maxWidth
//             : (box.maxWidth - gap * (columns - 1)) / columns;

//         return Wrap(
//           spacing: gap,
//           runSpacing: gap,
//           children: children
//               .map((child) => SizedBox(width: width, child: child))
//               .toList(),
//         );
//       },
//     );
//   }
// }

// class _SummaryBox extends StatelessWidget {
//   const _SummaryBox({required this.label, required this.value});

//   final String label;
//   final String value;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       decoration: BoxDecoration(
//         color: const Color(0xfff7fafc),
//         border: Border.all(color: const Color(0xffdce7ed)),
//         borderRadius: BorderRadius.circular(7),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             label,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: _monoStyle(
//               fontSize: 10,
//               fontWeight: FontWeight.w800,
//               color: const Color(0xff7a8991),
//             ),
//           ),
//           const SizedBox(height: 5),
//           Text(
//             value,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: _monoStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w800,
//               color: const Color(0xff32424c),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: _monoStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _ServiceDuration {
  const _ServiceDuration({required this.months, required this.days});

  final int? months;
  final int? days;
}

_ServiceDuration _serviceDuration(String hireDate, String endDate) {
  final start = _parseDate(hireDate);
  if (start == null) {
    return const _ServiceDuration(months: null, days: null);
  }

  final rawEnd = _parseDate(endDate) ?? DateTime.now();
  final normalizedStart = DateTime(start.year, start.month, start.day);
  final normalizedEnd = DateTime(rawEnd.year, rawEnd.month, rawEnd.day);
  if (normalizedEnd.isBefore(normalizedStart)) {
    return const _ServiceDuration(months: 0, days: 0);
  }

  var months =
      (normalizedEnd.year - normalizedStart.year) * 12 +
      normalizedEnd.month -
      normalizedStart.month;
  var anchor = _addMonthsClamped(normalizedStart, months);
  if (anchor.isAfter(normalizedEnd)) {
    months--;
    anchor = _addMonthsClamped(normalizedStart, months);
  }

  final days = normalizedEnd.difference(anchor).inDays;
  return _ServiceDuration(months: months, days: days);
}

DateTime _addMonthsClamped(DateTime date, int months) {
  final targetMonthIndex = date.month + months - 1;
  final targetYear = date.year + targetMonthIndex ~/ 12;
  final targetMonth = targetMonthIndex % 12 + 1;
  final lastDay = DateUtils.getDaysInMonth(targetYear, targetMonth);
  final targetDay = date.day > lastDay ? lastDay : date.day;
  return DateTime(targetYear, targetMonth, targetDay);
}

DateTime? _parseDate(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;

  for (final pattern in const ['dd-MM-yyyy', 'yyyy-MM-dd', 'MM-dd-yyyy']) {
    try {
      return DateFormat(pattern).parseStrict(trimmed);
    } catch (_) {
      //
    }
  }

  return DateTime.tryParse(trimmed);
}

String _assignmentBadgeLabel(String status) {
  final clean = status.trim();
  if (clean.isEmpty) return 'Active Assignment';
  if (clean.toLowerCase().contains('assignment')) return clean;
  return '$clean Assignment';
}

String _displayOrDash(String value) {
  final clean = value.trim();
  return clean.isEmpty ? '-' : clean;
}

Color _statusColor(String status) {
  final normalized = status.trim().toLowerCase();
  if (normalized.contains('inactive') ||
      normalized.contains('ended') ||
      normalized.contains('cancel')) {
    return _negativeColor;
  }
  if (normalized.contains('active') || normalized.isEmpty) {
    return _positiveColor;
  }
  return Colors.blueGrey;
}

TextStyle _monoStyle({
  required double fontSize,
  required FontWeight fontWeight,
  required Color color,
}) {
  return TextStyle(
    fontFamily: 'Courier New',
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
  );
}
