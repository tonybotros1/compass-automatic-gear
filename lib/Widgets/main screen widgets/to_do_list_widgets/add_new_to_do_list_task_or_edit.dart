import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/to_do_list_controller.dart';
import '../../../consts.dart';
import '../../menu_dialog.dart';
import '../../my_text_field.dart';

Widget addNewToDoListTaskOrEdit({
  required ToDoListController controller,
  required BuildContext context,
}) {
  return SingleChildScrollView(
    child: Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        myTextFormFieldWithBorder(
          labelText: 'Number',
          width: 150,
          isEnabled: false,
          controller: controller.number,
        ),
        myTextFormFieldWithBorder(
          width: 150,
          labelText: 'Date',
          controller: controller.date,
          suffixIcon: IconButton(
            focusNode: FocusNode(skipTraversal: true),
            onPressed: () async {
              selectDateContext(context, controller.date);
            },
            icon: const Icon(Icons.date_range),
          ),
          onFieldSubmitted: (_) async {
            normalizeDate(controller.date.text, controller.date);
          },
          onTapOutside: (_) {
            normalizeDate(controller.date.text, controller.date);
          },
        ),
        myTextFormFieldWithBorder(
          width: 150,
          labelText: 'Due Date',
          isEnabled: controller.whoCanEdit(),
          controller: controller.dueDate,
          suffixIcon: IconButton(
            focusNode: FocusNode(skipTraversal: true),
            onPressed: () async {
              selectDateContext(context, controller.dueDate);
            },
            icon: const Icon(Icons.date_range),
          ),
          onFieldSubmitted: (_) async {
            normalizeDate(controller.dueDate.text, controller.dueDate);
          },
          onTapOutside: (_) {
            normalizeDate(controller.dueDate.text, controller.dueDate);
          },
        ),
        MenuWithValues(
          labelText: 'Created By',
          headerLqabel: 'Users',
          isEnabled: controller.companyDetails['is_admin'],
          dialogWidth: 600,
          width: 310,
          controller: controller.createdBy,
          displayKeys: const ['user_name'],
          displaySelectedKeys: const ['user_name'],
          onOpen: () {
            return controller.getSysUsersForLOV();
          },
          onDelete: () {
            controller.createdById.value = "";
            controller.createdBy.clear();
          },
          onSelected: (value) {
            controller.createdById.value = value['_id'];
            controller.createdBy.text = value['user_name'];
          },
        ),
        MenuWithValues(
          labelText: 'Assigned To',
          headerLqabel: 'Employees',
          isEnabled: controller.whoCanEdit(),
          dialogWidth: 600,
          width: 310,
          controller: controller.assignedTo,
          displayKeys: const ['user_name'],
          displaySelectedKeys: const ['user_name'],
          onOpen: () {
            return controller.getSysUsersForLOV();
          },
          onDelete: () {
            controller.assignedToId.value = "";
            controller.assignedTo.clear();
          },
          onSelected: (value) {
            controller.assignedToId.value = value['_id'];
            controller.assignedTo.text = value['user_name'];
          },
        ),
        myTextFormFieldWithBorder(
          labelText: 'Description',
          width: double.infinity,
          controller: controller.description,
          maxLines: 7,
        ),
      ],
    ),
  );
}
