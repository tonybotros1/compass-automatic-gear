import 'package:datahubai/Controllers/Main%20screen%20controllers/employees_controller.dart';
import 'package:datahubai/Models/employees/employee_assignments_balances_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

const _cardBorderColor = Color(0xffd7e0e6);
const _cardHeaderColor = Color(0xffeef4f7);
const _titleColor = Color(0xff51616b);
const _nameColor = Color(0xff43515a);
const _mutedTextColor = Color(0xff7b8991);
const _neutralAccentColor = Color(0xff8fa9b9);
const _positiveColor = Color(0xff35a853);
const _negativeColor = Color(0xffff4d4f);

Widget balancesSection(BoxConstraints constraints) {
  return GetX<EmployeesController>(
    builder: (controller) {
      final balances = List<EmployeeAssignmentsBalancesModel>.generate(
        controller.balancesList.length,
        (index) => controller.balancesList[index],
        growable: false,
      );
      return _AssignmentBalancesCard(balances: balances);
    },
  );
}

class _AssignmentBalancesCard extends StatelessWidget {
  const _AssignmentBalancesCard({required this.balances});

  final List<EmployeeAssignmentsBalancesModel> balances;

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
                    'Assignment Balances',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _monoStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: _titleColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  DateFormat('MMMM yyyy').format(DateTime.now()),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _monoStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: _titleColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: balances.isEmpty
                ? const _EmptyBalancesBox()
                : _BalancesGrid(balances: balances),
          ),
        ],
      ),
    );
  }
}

class _BalancesGrid extends StatelessWidget {
  const _BalancesGrid({required this.balances});

  final List<EmployeeAssignmentsBalancesModel> balances;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final availableWidth = box.maxWidth.isFinite ? box.maxWidth : 900.0;
        final columns = availableWidth <= 650
            ? 1
            : availableWidth <= 1100
            ? 2
            : 4;
        const gap = 14.0;
        final itemWidth = columns == 1
            ? availableWidth
            : (availableWidth - gap * (columns - 1)) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: balances
              .map(
                (balance) => SizedBox(
                  width: itemWidth,
                  height: 118,
                  child: _BalanceTile(balance: balance),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _BalanceTile extends StatelessWidget {
  const _BalanceTile({required this.balance});

  final EmployeeAssignmentsBalancesModel balance;

  @override
  Widget build(BuildContext context) {
    final value = balance.balance ?? 0;
    final accentColor = value > 0
        ? _positiveColor
        : value < 0
        ? _negativeColor
        : _neutralAccentColor;
    final valueBackground = value > 0
        ? const Color(0xffeefaf1)
        : value < 0
        ? const Color(0xfffff2f2)
        : const Color(0xfff3f5f6);
    final valueColor = value > 0
        ? const Color(0xff2ca64d)
        : value < 0
        ? const Color(0xffff3030)
        : const Color(0xff59666d);

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 18, 14, 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Color(0xfff9fbfc)],
              ),
              border: Border.all(color: const Color(0xffdfe8ed)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _displayOrDash(balance.name),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: _monoStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: _nameColor,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _displayOrDash(balance.dimension),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _monoStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: _mutedTextColor,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: valueBackground,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    NumberFormat('#,##0.00').format(value),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _monoStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: valueColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyBalancesBox extends StatelessWidget {
  const _EmptyBalancesBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 118,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xfff7fafc),
        border: Border.all(color: const Color(0xffdce7ed)),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        'No assignment balances',
        style: _monoStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: _mutedTextColor,
        ),
      ),
    );
  }
}

String _displayOrDash(String? value) {
  final clean = value?.trim() ?? '';
  return clean.isEmpty ? '-' : clean;
}

TextStyle _monoStyle({
  required double fontSize,
  required FontWeight fontWeight,
  required Color color,
  double? height,
}) {
  return TextStyle(
    fontFamily: 'Courier New',
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: height,
  );
}
