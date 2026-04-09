import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/public_holidays_controllers/holiday_calendar_controller.dart';
import '../../../../Models/public_holidays_models/holiday_entry.dart';
import '../../../../Widgets/menu_dialog.dart';
import '../../../../Widgets/main screen widgets/public_holidays_widgets/calendar_theme.dart';
import '../../../../Widgets/main screen widgets/public_holidays_widgets/holiday_month_card.dart';

class PublicHolidays extends StatefulWidget {
  const PublicHolidays({super.key});

  @override
  State<PublicHolidays> createState() => _PublicHolidaysState();
}

class _PublicHolidaysState extends State<PublicHolidays> {
  final HolidayCalendarController controller = Get.put(
    HolidayCalendarController(),
  );
  late final TextEditingController yearController;

  @override
  void initState() {
    super.initState();
    yearController = TextEditingController(
      text: controller.selectedYear.value.toString(),
    );
  }

  @override
  void dispose() {
    yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: MenuWithValues(
                labelText: 'Year',
                headerLqabel: 'Years',
                dialogWidth: 600,
                width: 200,
                controller: yearController,
                displayKeys: const ['name'],
                displaySelectedKeys: const ['name'],
                onOpen: () {
                  return controller.getAllYears();
                },
                onDelete: () {},
                onSelected: (value) {
                  final int selectedYear =
                      int.tryParse(value['name']) ?? DateTime.now().year;
                  yearController.text = '$selectedYear';
                  controller.changeYear(selectedYear);
                },
              ),
            ),

            Expanded(
              child: Obx(() {
                final int year = controller.selectedYear.value;
                final List<List<DateTime?>> monthGrids = controller
                    .monthGridsForSelectedYear();
                final Map<String, HolidayEntry> holidaysByDateKey =
                    Map<String, HolidayEntry>.from(controller.holidays);

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                  physics: const BouncingScrollPhysics(),
                  itemCount: monthGrids.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 18,
                    crossAxisSpacing: 18,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final int month = index + 1;
                    return HolidayMonthCard(
                      year: year,
                      monthName: controller.monthLabel(month),
                      weekdayLabels:
                          HolidayCalendarController.weekdayShortLabels,
                      days: monthGrids[index],
                      holidaysByDateKey: holidaysByDateKey,
                      onDayTapped: _openHolidayEditor,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openHolidayEditor(DateTime date) async {
    final HolidayEntry? existingHoliday = controller.holidayFor(date);
    final TextEditingController nameController = TextEditingController(
      text: existingHoliday?.name ?? '',
    );

    await Get.dialog<void>(
      AlertDialog(
        title: Text(existingHoliday == null ? 'Add holiday' : 'Edit holiday'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              controller.formattedDate(date),
              style: Get.textTheme.bodySmall?.copyWith(
                color: CalendarTheme.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              autofocus: true,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Holiday name',
                hintText: 'Example: National Day',
              ),
              onSubmitted: (_) => _saveHoliday(date, nameController),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        actions: <Widget>[
          if (existingHoliday != null)
            TextButton(
              onPressed: () {
                controller.removeHoliday(date);
                Get.back<void>();
              },
              child: const Text('Remove'),
            ),
          TextButton(
            onPressed: () => Get.back<void>(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => _saveHoliday(date, nameController),
            child: const Text('Save'),
          ),
        ],
      ),
      barrierDismissible: true,
    );

    nameController.dispose();
  }

  void _saveHoliday(DateTime date, TextEditingController nameController) {
    final String holidayName = nameController.text.trim();

    if (holidayName.isEmpty) {
      Get.snackbar(
        'Holiday name required',
        'Enter a name for this holiday before saving.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(12),
      );
      return;
    }

    controller.saveHoliday(date: date, name: holidayName);
    Get.back<void>();
  }
}
