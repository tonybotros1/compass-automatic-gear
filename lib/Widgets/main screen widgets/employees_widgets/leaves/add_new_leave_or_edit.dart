import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/employees_controller.dart';
import '../../../../consts.dart';
import '../../../menu_dialog.dart';

Widget addNewLeaveOrEdit({
  required EmployeesController controller,
  required bool canEdit,
}) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        MenuWithValues(
          labelText: 'Leave Type',
          headerLqabel: 'Leave Types',
          dialogWidth: 600,
          controller: controller.employeeLeaveType,
          displayKeys: const ['name'],
          displaySelectedKeys: const ['name'],
          onOpen: () {
            return controller.getAllLeaveTypes();
          },
          onDelete: () {
            controller.employeeLeaveTypeId.value = "";
            controller.employeeLeaveType.clear();
            controller.employeeLeaveStartTime.clear();
            controller.employeeLeaveEndTime.clear();
            controller.employeeLeaveNumberOfDays.clear();
          },
          onSelected: (value) {
            if (value.containsKey('type')) {
              if (value['type'] != null || value['type'] != '') {
                controller
                        .employeeLeaveTypeTypeToCheckForHowToCalculateTheHolidays
                        .value =
                    value['type'];
              } else {
                alertMessage(
                  context: Get.context!,
                  content:
                      "Selected leave doesn't has a type please check for its type in leave types page",
                );
                return;
              }
            }
            controller.employeeLeaveTypeId.value = value['_id'];
            controller.employeeLeaveType.text = value['name'];
            controller.employeeLeaveStartTime.clear();
            controller.employeeLeaveEndTime.clear();
            controller.employeeLeaveNumberOfDays.clear();
          },
        ),
        myTextFormFieldWithBorder(
          labelText: 'Start Date',
          controller: controller.employeeLeaveStartTime,
          isDate: true,
          width: 200,
          suffixIcon: IconButton(
            focusNode: FocusNode(skipTraversal: true),
            onPressed: () async {
              selectDateContext(
                Get.context!,
                controller.employeeLeaveStartTime,
              );
            },
            icon: const Icon(Icons.date_range),
          ),
          onFieldSubmitted: (_) async {
            normalizeDate(
              controller.employeeLeaveStartTime.text,
              controller.employeeLeaveStartTime,
            );
          },
        ),
        myTextFormFieldWithBorder(
          labelText: 'End Date',
          controller: controller.employeeLeaveEndTime,
          isDate: true,
          width: 200,
          suffixIcon: IconButton(
            focusNode: FocusNode(skipTraversal: true),
            onPressed: () {
              if (controller
                  .employeeLeaveTypeTypeToCheckForHowToCalculateTheHolidays
                  .isEmpty) {
                alertMessage(
                  context: Get.context!,
                  content: "Please select leave type",
                );
                return;
              }
              if (controller.employeeLeaveStartTime.text.isEmpty) {
                alertMessage(
                  context: Get.context!,
                  content: "Please select start date",
                );
                return;
              }
              selectDateContext(
                Get.context!,
                controller.employeeLeaveEndTime,
              ).then((_) async {
                if (controller
                        .employeeLeaveTypeTypeToCheckForHowToCalculateTheHolidays
                        .value
                        .toLowerCase() ==
                    'calendar days') {
                  controller.employeeLeaveNumberOfDays.text =
                      calculateDaysBetweenTwoDates(
                        controller.employeeLeaveStartTime.text,
                        controller.employeeLeaveEndTime.text,
                      ).toString();
                } else {
                  Map workingDays = await controller.getEmployeeWorkingDays(
                    controller.currentEmployeeId.value,
                    {
                      "start_date": convertDateToIson(
                        controller.employeeLeaveStartTime.text,
                      ),
                      "end_date": convertDateToIson(
                        controller.employeeLeaveEndTime.text,
                      ),
                    },
                  );
                  controller.employeeLeaveNumberOfDays.text =
                      workingDays.containsKey('working_days')
                      ? workingDays['working_days'].toString()
                      : '';
                }

                if (controller.employeeLeaveNumberOfDays.text.isEmpty) {
                  controller.employeeLeaveEndTime.clear();
                }
              });
            },
            icon: const Icon(Icons.date_range),
          ),
          onFieldSubmitted: (_) async {
            normalizeDate(
              controller.employeeLeaveEndTime.text,
              controller.employeeLeaveEndTime,
            );
          },
        ),
        myTextFormFieldWithBorder(
          labelText: 'Number of Days',
          controller: controller.employeeLeaveNumberOfDays,
          width: 200,
          isEnabled: false,
        ),

        myTextFormFieldWithBorder(
          labelText: 'Notes',
          maxLines: 7,
          controller: controller.employeeLeaveNote,
        ),
      ],
    ),
  );
}
