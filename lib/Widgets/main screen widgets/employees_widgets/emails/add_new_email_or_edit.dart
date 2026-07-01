import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/employees_controller.dart';
import '../../../../consts.dart';
import '../../../menu_dialog.dart';
import '../../../my_text_field.dart';

Widget addNewEmailOrEdit({
  required EmployeesController controller,
  required bool canEdit,
}) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        MenuWithValues(
          labelText: 'Type',
          headerLqabel: 'Types',
          dialogWidth: 600,
          controller: controller.emailType,
          displayKeys: const ['name'],
          displaySelectedKeys: const ['name'],
          onDelete: () {
            controller.emailType.clear();
            controller.emailTypeId.value = '';
          },
          onSelected: (value) {
            controller.emailType.text = value['name'];
            controller.emailTypeId.value = value['_id'];
          },
          onOpen: () {
            return controller.getTypeOfSocial();
          },
        ),
        myTextFormFieldWithBorder(
          obscureText: false,
          controller: controller.emailAddress,
          labelText: 'Email Address',
          keyboardType: TextInputType.emailAddress,
          validate: true,
        ),
        Obx(
          () => Container(
            decoration: BoxDecoration(
              color: controller.emailUseForPayslips.value
                  ? mainColor.withValues(alpha: 0.07)
                  : Colors.blueGrey.withValues(alpha: 0.04),
              border: Border.all(
                color: controller.emailUseForPayslips.value
                    ? mainColor.withValues(alpha: 0.4)
                    : Colors.blueGrey.shade200,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CheckboxListTile(
              value: controller.emailUseForPayslips.value,
              activeColor: mainColor,
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              title: const Text(
                'Use for Payslips',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text(
                'Payslips will be sent to this email address',
                style: TextStyle(fontSize: 11),
              ),
              onChanged: canEdit
                  ? (value) {
                      controller.emailUseForPayslips.value = value ?? false;
                    }
                  : null,
            ),
          ),
        ),
      ],
    ),
  );
}
