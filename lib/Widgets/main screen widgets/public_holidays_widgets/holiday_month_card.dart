import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'calendar_theme.dart';

class HolidayMonthCard extends StatefulWidget {
  const HolidayMonthCard({
    super.key,
    required this.year,
    required this.monthName,
    required this.weekdayLabels,
    required this.days,
    required this.holidayDays,
    required this.onDayTapped,
  });

  final int year;
  final String monthName;
  final List<String> weekdayLabels;
  final List<DateTime?> days;
  final Set<int> holidayDays;
  final ValueChanged<DateTime> onDayTapped;

  @override
  State<HolidayMonthCard> createState() => _HolidayMonthCardState();
}

class _HolidayMonthCardState extends State<HolidayMonthCard> {
  DateTime? _hoveredDate;

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateUtils.dateOnly(DateTime.now());

    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final Size size = Size(constraints.maxWidth, constraints.maxHeight);

          return MouseRegion(
            cursor: _hoveredDate == null
                ? MouseCursor.defer
                : SystemMouseCursors.click,
            onHover: (PointerHoverEvent event) {
              _setHoveredDate(_dateForOffset(event.localPosition, size));
            },
            onExit: (_) => _setHoveredDate(null),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: (TapUpDetails details) {
                final DateTime? date = _dateForOffset(
                  details.localPosition,
                  size,
                );
                if (date != null) {
                  widget.onDayTapped(date);
                }
              },
              child: CustomPaint(
                size: size,
                painter: _HolidayMonthPainter(
                  year: widget.year,
                  monthName: widget.monthName,
                  weekdayLabels: widget.weekdayLabels,
                  days: widget.days,
                  holidayDays: widget.holidayDays,
                  today: today,
                  hoveredDay: _hoveredDate?.day,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _setHoveredDate(DateTime? date) {
    if (DateUtils.isSameDay(_hoveredDate, date)) return;
    setState(() {
      _hoveredDate = date;
    });
  }

  DateTime? _dateForOffset(Offset offset, Size size) {
    final _MonthCardLayout layout = _MonthCardLayout(
      size: size,
      dayCount: widget.days.length,
    );

    final double localX = offset.dx - _MonthCardLayout.padding;
    final double localY = offset.dy - layout.gridTop;

    if (localX < 0 || localY < 0) return null;

    final double columnStride = layout.cellWidth + _MonthCardLayout.columnGap;
    final double rowStride = layout.cellHeight + _MonthCardLayout.rowGap;
    if (columnStride <= 0 || rowStride <= 0) return null;

    final int column = (localX / columnStride).floor();
    final int row = (localY / rowStride).floor();
    if (column < 0 || column > 6 || row < 0 || row >= layout.rowCount) {
      return null;
    }

    final double xInCell = localX - (column * columnStride);
    final double yInCell = localY - (row * rowStride);
    if (xInCell > layout.cellWidth || yInCell > layout.cellHeight) {
      return null;
    }

    final int dayIndex = row * 7 + column;
    if (dayIndex < 0 || dayIndex >= widget.days.length) return null;
    return widget.days[dayIndex];
  }
}

class _HolidayMonthPainter extends CustomPainter {
  _HolidayMonthPainter({
    required this.year,
    required this.monthName,
    required this.weekdayLabels,
    required this.days,
    required this.holidayDays,
    required this.today,
    required this.hoveredDay,
  });

  static const Radius _cardRadius = Radius.circular(18);
  static const Radius _badgeRadius = Radius.circular(14);
  static const Radius _dayRadius = Radius.circular(12);
  static const Color _dayFill = Color(0xFFF9F6F0);
  static const Color _badgeFill = Color(0xFFF5EFE5);

  static const TextStyle _monthStyle = TextStyle(
    color: CalendarTheme.textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.w800,
  );
  static const TextStyle _yearStyle = TextStyle(
    color: CalendarTheme.textMuted,
    fontSize: 13,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle _weekdayStyle = TextStyle(
    color: CalendarTheme.textMuted,
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle _dayStyle = TextStyle(
    color: CalendarTheme.textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w800,
  );
  static const TextStyle _holidayDayStyle = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w800,
  );

  final int year;
  final String monthName;
  final List<String> weekdayLabels;
  final List<DateTime?> days;
  final Set<int> holidayDays;
  final DateTime today;
  final int? hoveredDay;

  @override
  void paint(Canvas canvas, Size size) {
    final _MonthCardLayout layout = _MonthCardLayout(
      size: size,
      dayCount: days.length,
    );

    final RRect cardRect = RRect.fromRectAndRadius(
      Offset.zero & size,
      _cardRadius,
    );
    canvas.drawRRect(cardRect, Paint()..color = Colors.white);
    canvas.drawRRect(
      cardRect,
      Paint()
        ..color = CalendarTheme.border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    final TextPainter yearPainter = _textPainter('$year', _yearStyle);
    final double badgeWidth = yearPainter.width + 24;
    final Rect badgeRect = Rect.fromLTWH(
      size.width - _MonthCardLayout.padding - badgeWidth,
      _MonthCardLayout.padding,
      badgeWidth,
      30,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(badgeRect, _badgeRadius),
      Paint()..color = _badgeFill,
    );
    yearPainter.paint(
      canvas,
      Offset(
        badgeRect.left + (badgeRect.width - yearPainter.width) / 2,
        badgeRect.top + (badgeRect.height - yearPainter.height) / 2,
      ),
    );

    _paintText(
      canvas,
      monthName,
      _monthStyle,
      const Offset(_MonthCardLayout.padding, _MonthCardLayout.padding + 2),
      maxWidth: badgeRect.left - (_MonthCardLayout.padding * 2),
    );

    for (int index = 0; index < weekdayLabels.length && index < 7; index++) {
      final Rect cellRect = layout.cellRect(index);
      final TextPainter weekdayPainter = _textPainter(
        weekdayLabels[index],
        _weekdayStyle,
      );
      weekdayPainter.paint(
        canvas,
        Offset(
          cellRect.center.dx - (weekdayPainter.width / 2),
          layout.weekdayTop,
        ),
      );
    }

    for (int index = 0; index < days.length; index++) {
      final DateTime? date = days[index];
      if (date == null) continue;

      final Rect rect = layout.cellRect(index);
      final bool isHoliday = holidayDays.contains(date.day);
      final bool isToday = DateUtils.isSameDay(date, today);
      final bool isHovered = hoveredDay == date.day;
      final Color fillColor = isHoliday ? CalendarTheme.accent : _dayFill;
      final Color borderColor = isToday
          ? CalendarTheme.today
          : (isHovered ? CalendarTheme.accent : CalendarTheme.border);

      final RRect dayRect = RRect.fromRectAndRadius(rect, _dayRadius);
      canvas.drawRRect(dayRect, Paint()..color = fillColor);
      canvas.drawRRect(
        dayRect,
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = isToday || isHovered ? 1.6 : 1,
      );

      _paintText(
        canvas,
        '${date.day}',
        isHoliday ? _holidayDayStyle : _dayStyle,
        Offset(rect.left + 8, rect.top + 6),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HolidayMonthPainter oldDelegate) {
    return oldDelegate.year != year ||
        oldDelegate.monthName != monthName ||
        oldDelegate.today != today ||
        oldDelegate.hoveredDay != hoveredDay ||
        !listEquals(oldDelegate.weekdayLabels, weekdayLabels) ||
        !listEquals(oldDelegate.days, days) ||
        !setEquals(oldDelegate.holidayDays, holidayDays);
  }

  TextPainter _textPainter(String text, TextStyle style, {double? maxWidth}) {
    final TextPainter painter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      ellipsis: maxWidth == null ? null : '',
      textDirection: TextDirection.ltr,
    );
    painter.layout(maxWidth: maxWidth ?? double.infinity);
    return painter;
  }

  void _paintText(
    Canvas canvas,
    String text,
    TextStyle style,
    Offset offset, {
    double? maxWidth,
  }) {
    _textPainter(text, style, maxWidth: maxWidth).paint(canvas, offset);
  }
}

class _MonthCardLayout {
  const _MonthCardLayout({required this.size, required this.dayCount});

  static const double padding = 18;
  static const double columnGap = 8;
  static const double rowGap = 8;
  static const double headerHeight = 32;
  static const double weekdayHeight = 16;
  static const int monthRowCount = 6;

  final Size size;
  final int dayCount;

  int get rowCount => monthRowCount;
  double get weekdayTop => padding + headerHeight + 18;
  double get gridTop => weekdayTop + weekdayHeight + 10;
  double get cellWidth {
    return (size.width - (padding * 2) - (columnGap * 6)) / 7;
  }

  double get cellHeight {
    if (rowCount <= 0) return 0;
    return (size.height - gridTop - padding - (rowGap * (rowCount - 1))) /
        rowCount;
  }

  Rect cellRect(int index) {
    final int row = index ~/ 7;
    final int column = index % 7;
    return Rect.fromLTWH(
      padding + (column * (cellWidth + columnGap)),
      gridTop + (row * (cellHeight + rowGap)),
      cellWidth,
      cellHeight,
    );
  }
}
