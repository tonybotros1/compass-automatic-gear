import 'package:flutter/material.dart';

import '../../../Models/public_holidays_models/holiday_entry.dart';
import 'calendar_theme.dart';

class HolidayMonthCard extends StatelessWidget {
  static const BorderRadius _cardRadius = BorderRadius.all(Radius.circular(28));
  static const BorderRadius _badgeRadius = BorderRadius.all(
    Radius.circular(16),
  );
  static const BorderRadius _dayRadius = BorderRadius.all(Radius.circular(18));

  const HolidayMonthCard({
    super.key,
    required this.year,
    required this.monthName,
    required this.weekdayLabels,
    required this.days,
    required this.holidaysByDateKey,
    required this.onDayTapped,
  });

  final int year;
  final String monthName;
  final List<String> weekdayLabels;
  final List<DateTime?> days;
  final Map<String, HolidayEntry> holidaysByDateKey;
  final ValueChanged<DateTime> onDayTapped;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final DateTime today = DateUtils.dateOnly(DateTime.now());

    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: _cardRadius,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color(0x120B1F33),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    monthName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5EFE5),
                    borderRadius: _badgeRadius,
                  ),
                  child: Text(
                    '$year',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: CalendarTheme.textMuted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: weekdayLabels.map((String label) {
                return Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: CalendarTheme.textMuted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            _MonthDaysGrid(
              days: days,
              today: today,
              holidaysByDateKey: holidaysByDateKey,
              onDayTapped: onDayTapped,
            ),
          ],
        ),
      ),
    );
  }

  static String dayKey(DateTime date) {
    final String year = date.year.toString().padLeft(4, '0');
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}

class _MonthDaysGrid extends StatelessWidget {
  const _MonthDaysGrid({
    required this.days,
    required this.today,
    required this.holidaysByDateKey,
    required this.onDayTapped,
  });

  final List<DateTime?> days;
  final DateTime today;
  final Map<String, HolidayEntry> holidaysByDateKey;
  final ValueChanged<DateTime> onDayTapped;

  @override
  Widget build(BuildContext context) {
    final int rowCount = (days.length / 7).ceil();
    final List<Widget> rows = <Widget>[];

    for (int rowIndex = 0; rowIndex < rowCount; rowIndex++) {
      final int start = rowIndex * 7;
      final List<Widget> weekChildren = <Widget>[];

      for (int columnIndex = 0; columnIndex < 7; columnIndex++) {
        final int dayIndex = start + columnIndex;
        final DateTime? date = dayIndex < days.length ? days[dayIndex] : null;

        if (columnIndex > 0) {
          weekChildren.add(const SizedBox(width: 8));
        }

        weekChildren.add(
          Expanded(
            child: AspectRatio(
              aspectRatio: 0.92,
              child: date == null
                  ? const SizedBox.shrink()
                  : _DayTile(
                      date: date,
                      holiday: holidaysByDateKey[HolidayMonthCard.dayKey(date)],
                      isToday: DateUtils.isSameDay(date, today),
                      onTap: () => onDayTapped(date),
                    ),
            ),
          ),
        );
      }

      if (rowIndex > 0) {
        rows.add(const SizedBox(height: 8));
      }

      rows.add(Row(children: weekChildren));
    }

    return Column(children: rows);
  }
}

class _DayTile extends StatelessWidget {
  const _DayTile({
    required this.date,
    required this.holiday,
    required this.isToday,
    required this.onTap,
  });

  final DateTime date;
  final HolidayEntry? holiday;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isHoliday = holiday != null;

    final Color fillColor = isHoliday
        ? CalendarTheme.accent
        : const Color(0xFFF9F6F0);
    final Color borderColor = isToday
        ? CalendarTheme.today
        : (isHoliday ? Colors.transparent : CalendarTheme.border);
    final Color textColor = isHoliday
        ? Colors.white
        : CalendarTheme.textPrimary;

    return Material(
      color: fillColor,
      borderRadius: HolidayMonthCard._dayRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: HolidayMonthCard._dayRadius,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: HolidayMonthCard._dayRadius,
            border: Border.all(color: borderColor, width: isToday ? 1.6 : 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${date.day}',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
