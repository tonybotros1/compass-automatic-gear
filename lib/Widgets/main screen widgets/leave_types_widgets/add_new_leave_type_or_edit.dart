import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/leave_types_controller.dart';
import '../../../consts.dart';
import '../../menu_dialog.dart';

Widget addNewLeaveTypeOrEdit({
  required LeaveTypesController controller,
  required BoxConstraints constraints,
}) {
  return SingleChildScrollView(
    child: Column(
      spacing: 20,
      children: [
        myTextFormFieldWithBorder(
          labelText: 'Name',
          controller: controller.name,
        ),
        myTextFormFieldWithBorder(
          labelText: 'Code',
          controller: controller.code,
        ),
        MenuWithValues(
          labelText: 'Based Element',
          headerLqabel: 'ModeBased Elements',
          dialogWidth: 600,
          controller: controller.basedElement,
          displayKeys: const ['name'],
          displaySelectedKeys: const ['name'],
          onOpen: () {
            return controller.getAllPayrollElements();
          },
          onDelete: () {
            controller.basedElementId.value = "";
            controller.basedElement.clear();
          },
          onSelected: (value) {
            controller.basedElementId.value = value['_id'];
            controller.basedElement.text = value['name'];
          },
        ),

        GetX<LeaveTypesController>(
          builder: (controller) {
            return RadioGroup<bool>(
              groupValue: controller.isCalendarDaysSelected.value,
              onChanged: (bool? value) {
                if (value != null) {
                  controller.selectCalenderOrWorkingDays(
                    value ? 'calendar_days' : 'working_days',
                    value,
                  );
                }
              },
              child: Row(
                children: [
                  Row(
                    children: [
                      Radio<bool>(value: true, activeColor: mainColor),
                      const Text('Calendar Days'),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Row(
                    children: [
                      Radio<bool>(value: false, activeColor: mainColor),
                      const Text('Working Days'),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
}
