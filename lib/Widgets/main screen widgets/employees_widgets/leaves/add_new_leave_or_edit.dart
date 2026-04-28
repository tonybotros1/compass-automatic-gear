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
          onTapOutside: (_) {
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
                await controller.onSelectLeaveEndDate();
              });
            },
            icon: const Icon(Icons.date_range),
          ),
          onFieldSubmitted: (_) async {
            normalizeDate(
              controller.employeeLeaveEndTime.text,
              controller.employeeLeaveEndTime,
            );
            await controller.onSelectLeaveEndDate();
          },
          onTapOutside: (_) async {
            normalizeDate(
              controller.employeeLeaveEndTime.text,
              controller.employeeLeaveEndTime,
            );
            await controller.onSelectLeaveEndDate();
          },
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            myTextFormFieldWithBorder(
              labelText: 'Number of Days',
              controller: controller.employeeLeaveNumberOfDays,
              width: 200,
              isEnabled: false,
            ),
            // Container(
            //   height: 35,
            //   width: 200,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(4),
            //     border: Border.all(color: Colors.grey),
            //     color: Colors.white,
            //   ),
            //   child: Row(
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 8),
            //         child: GetX<EmployeesController>(
            //           builder: (controller) {
            //             return CupertinoCheckbox(
            //               value: controller.employeeLeavePayInAdvance.value,
            //               onChanged: (value) {
            //                 controller.employeeLeavePayInAdvance.value = value!;
            //               },
            //               fillColor: WidgetStateProperty.resolveWith<Color?>((
            //                 Set<WidgetState> states,
            //               ) {
            //                 if (!states.contains(WidgetState.selected)) {
            //                   return Colors.grey.shade300;
            //                 }
            //                 return Colors.red;
            //               }),
            //             );
            //           },
            //         ),
            //       ),

            //       Text('Pay in Advance ?', style: textFieldFontStyle),
            //     ],
            //   ),
            // ),
          ],
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
