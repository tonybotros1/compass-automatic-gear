import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/holiday_calendar_controller.dart';
import '../../../../Models/public_holidays_models/holiday_entry.dart';
import '../../../../Widgets/menu_dialog.dart';
import '../../../../Widgets/main screen widgets/public_holidays_widgets/calendar_theme.dart';
import '../../../../Widgets/main screen widgets/public_holidays_widgets/holiday_month_card.dart';

class PublicHolidays extends StatelessWidget {
  const PublicHolidays({super.key});

  // final HolidayCalendarController controller = Get.put(
  //   HolidayCalendarController(),
  // );

  int _calendarColumnCount(double width) {
    if (width < 560) return 1;
    if (width < 900) return 2;
    if (width < 1220) return 3;
    return 4;
  }

  double _calendarAspectRatio(double width, int columns) {
    if (columns == 1) return width < 420 ? 0.9 : 1.02;
    if (columns == 2) return 0.9;
    if (columns == 3) return 0.84;
    return 0.8;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GetBuilder<HolidayCalendarController>(
              init: HolidayCalendarController(),
              builder: (controller) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final bool compact = constraints.maxWidth < 560;
                    final double sidePadding = compact ? 12 : 20;
                    final double availableWidth =
                        constraints.maxWidth - (sidePadding * 2);
                    final double yearWidth = compact ? availableWidth : 200;
                    final double legislationWidth = compact
                        ? availableWidth
                        : (availableWidth - yearWidth - 10)
                              .clamp(240.0, 360.0)
                              .toDouble();

                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                        sidePadding,
                        0,
                        sidePadding,
                        10,
                      ),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          MenuWithValues(
                            labelText: 'Year',
                            headerLqabel: 'Years',
                            dialogWidth: 600,
                            width: yearWidth,
                            controller: controller.yearController,
                            displayKeys: const ['name'],
                            displaySelectedKeys: const ['name'],
                            onOpen: () {
                              return controller.getAllYears();
                            },
                            onSelected: (value) {
                              final int selectedYear =
                                  int.tryParse(
                                    value['name']?.toString() ?? '',
                                  ) ??
                                  DateTime.now().year;
                              controller.yearController.text = '$selectedYear';
                              controller.changeYear(selectedYear);
                            },
                            onDelete: controller.resetYear,
                          ),
                          MenuWithValues(
                            labelText: 'Legislation',
                            headerLqabel: 'Legislations',
                            dialogWidth: 600,
                            width: legislationWidth,
                            controller: controller.legislationNameController,
                            displayKeys: const ['name'],
                            displaySelectedKeys: const ['name'],
                            onOpen: () {
                              return controller.getAllLegislations();
                            },
                            onDelete: controller.clearLegislation,
                            onSelected: (value) {
                              controller.changeLegislation(
                                id: value['_id']?.toString() ?? '',
                                name: value['name']?.toString() ?? '',
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),

            Expanded(
              child: GetX<HolidayCalendarController>(
                builder: (controller) {
                  final int year = controller.selectedYear.value;
                  final List<List<DateTime?>> monthGrids = controller
                      .monthGridsForSelectedYear();
                  final Map<int, Set<int>> holidayDaysByMonth =
                      <int, Set<int>>{};
                  for (final HolidayEntry holiday
                      in controller.holidays.values) {
                    final DateTime? date = holiday.date;
                    if (date == null || date.year != year) continue;
                    holidayDaysByMonth
                        .putIfAbsent(date.month, () => <int>{})
                        .add(date.day);
                  }

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final int columns = _calendarColumnCount(
                        constraints.maxWidth,
                      );
                      final double spacing = constraints.maxWidth < 560
                          ? 12
                          : 18;
                      final double sidePadding = constraints.maxWidth < 560
                          ? 12
                          : 20;

                      return GridView.builder(
                        padding: EdgeInsets.fromLTRB(
                          sidePadding,
                          0,
                          sidePadding,
                          28,
                        ),
                        physics: const BouncingScrollPhysics(),
                        itemCount: monthGrids.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          mainAxisSpacing: spacing,
                          crossAxisSpacing: spacing,
                          childAspectRatio: _calendarAspectRatio(
                            constraints.maxWidth,
                            columns,
                          ),
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          final int month = index + 1;
                          return HolidayMonthCard(
                            year: year,
                            monthName: controller.monthLabel(month),
                            weekdayLabels:
                                HolidayCalendarController.weekdayShortLabels,
                            days: monthGrids[index],
                            holidayDays:
                                holidayDaysByMonth[month] ?? const <int>{},
                            onDayTapped: (date) =>
                                _openHolidayEditor(context, controller, date),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openHolidayEditor(
    BuildContext context,
    HolidayCalendarController controller,
    DateTime date,
  ) async {
    if (controller.legislationID.value.trim().isEmpty) {
      alertMessage(
        context: context,
        content: 'Select a legislation before adding a holiday',
      );
      return;
    }

    final HolidayEntry? existingHoliday = controller.holidayFor(date);
    final TextEditingController nameController = TextEditingController(
      text: existingHoliday?.name ?? '',
    );
    if (nameController.text.isNotEmpty) {
      nameController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: nameController.text.length,
      );
    }
    final bool isEditing = existingHoliday != null;

    await Get.dialog<void>(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: CalendarTheme.accentSoft,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.event_available_rounded,
                        color: CalendarTheme.accent,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            isEditing ? 'Edit holiday' : 'Add holiday',
                            style: Get.textTheme.titleMedium?.copyWith(
                              color: CalendarTheme.textPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            controller.formattedDate(date),
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: CalendarTheme.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Close',
                      onPressed: () => Get.back<void>(),
                      icon: const Icon(Icons.close_rounded, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                TextField(
                  controller: nameController,
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: CalendarTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Holiday name',
                    hintText: 'National Day',
                    prefixIcon: const Icon(Icons.celebration_rounded, size: 20),
                    filled: true,
                    fillColor: const Color(0xFFF9F6F0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: CalendarTheme.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: CalendarTheme.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: CalendarTheme.accent,
                        width: 1.4,
                      ),
                    ),
                  ),
                  onSubmitted: (_) =>
                      _saveHoliday(date, nameController, controller, context),
                ),
                const SizedBox(height: 22),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.end,
                  children: <Widget>[
                    if (isEditing)
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red.shade700,
                          side: BorderSide(color: Colors.red.shade200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          controller.removeHoliday(date);
                          Get.back<void>();
                        },
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                        ),
                        label: const Text('Remove'),
                      ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: CalendarTheme.textMuted,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Get.back<void>(),
                      child: const Text('Cancel'),
                    ),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: CalendarTheme.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _saveHoliday(
                        date,
                        nameController,
                        controller,
                        context,
                      ),
                      icon: const Icon(Icons.check_rounded, size: 18),
                      label: Text(isEditing ? 'Update' : 'Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    );

    nameController.dispose();
  }

  void _saveHoliday(
    DateTime date,
    TextEditingController nameController,
    HolidayCalendarController controller,
    BuildContext context,
  ) {
    final String holidayName = nameController.text.trim();

    if (controller.legislationID.value.trim().isEmpty) {
      alertMessage(
        context: context,
        content: 'Select a legislation before adding a holiday',
      );
      return;
    }

    if (holidayName.isEmpty) {
      alertMessage(
        context: context,
        content: 'Enter a name for this holiday before saving',
      );
      return;
    }

    controller.saveHoliday(date: date, name: holidayName);
    Get.back<void>();
  }
}
