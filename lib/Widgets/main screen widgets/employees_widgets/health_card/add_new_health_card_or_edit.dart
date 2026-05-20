import 'package:flutter/material.dart';
import '../../../../Controllers/Main screen controllers/employees_controller.dart';
import '../../../../consts.dart';
import '../../../menu_dialog.dart';
import '../../../my_text_field.dart';

Widget addNewHealthCardOrEdit({
  required EmployeesController controller,
  required BuildContext context,
  required bool canEdit,
}) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        MenuWithValues(
          labelText: 'Health Card Type',
          headerLqabel: 'Health Card Types',
          dialogWidth: 600,
          controller: controller.healthCardType,
          displayKeys: const ['name'],
          displaySelectedKeys: const ['name'],
          onDelete: () {
            controller.healthCardType.clear();
            controller.healthCardTypeId.value = '';
          },
          onSelected: (value) {
            controller.healthCardType.text = value['name'];
            controller.healthCardTypeId.value = value['_id'];
          },
          onOpen: () {
            return controller.getHealthCardTypes();
          },
        ),
        MenuWithValues(
          labelText: 'Health Card Holder',
          headerLqabel: 'Health Card Holders',
          dialogWidth: 600,
          controller: controller.healthCardHolder,
          displayKeys: const ['full_name'],
          displaySelectedKeys: const ['full_name'],
          onDelete: () {
            controller.healthCardHolder.clear();
            controller.healthCardHolderId.value = '';
          },
          onSelected: (value) {
            controller.healthCardHolder.text = value['full_name'];
            controller.healthCardHolderType.text = value['type'];
            controller.healthCardHolderId.value = value['_id'];
          },
          onOpen: () {
            return controller.getAllHealthCardHolders();
          },
        ),
        myTextFormFieldWithBorder(
          obscureText: false,
          controller: controller.healthCardNumber,
          labelText: 'Card Number',
          validate: true,
          isEnabled: canEdit,
        ),
        MenuWithValues(
          labelText: 'Insurance Company',
          headerLqabel: 'Insurance Companies',
          dialogWidth: 600,
          controller: controller.healthCardInsuranceCompany,
          displayKeys: const ['name'],
          displaySelectedKeys: const ['name'],
          onDelete: () {
            controller.healthCardInsuranceCompany.clear();
            controller.healthCardInsuranceCompanyId.value = '';
          },
          onSelected: (value) {
            controller.healthCardInsuranceCompany.text = value['name'];
            controller.healthCardInsuranceCompanyId.value = value['_id'];
          },
          onOpen: () {
            return controller.getInsuranceCompanies();
          },
        ),
        myTextFormFieldWithBorder(
          labelText: 'Issue Date',
          isDate: true,
          controller: controller.healthCardIssueDate,
          width: 200,
          isEnabled: canEdit,
          suffixIcon: IconButton(
            onPressed: canEdit
                ? () async {
                    selectDateContext(context, controller.healthCardIssueDate);
                  }
                : null,
            icon: const Icon(Icons.date_range),
          ),
          onFieldSubmitted: (_) async {
            normalizeDate(
              controller.healthCardIssueDate.text,
              controller.healthCardIssueDate,
            );
          },
          onTapOutside: (_) {
            normalizeDate(
              controller.healthCardIssueDate.text,
              controller.healthCardIssueDate,
            );
          },
        ),
        myTextFormFieldWithBorder(
          labelText: 'Expiry Date',
          isDate: true,
          controller: controller.healthCardExpiryDate,
          width: 200,
          isEnabled: canEdit,
          suffixIcon: IconButton(
            onPressed: canEdit
                ? () async {
                    selectDateContext(context, controller.healthCardExpiryDate);
                  }
                : null,
            icon: const Icon(Icons.date_range),
          ),
          onFieldSubmitted: (_) async {
            normalizeDate(
              controller.healthCardExpiryDate.text,
              controller.healthCardExpiryDate,
            );
          },
          onTapOutside: (_) {
            normalizeDate(
              controller.healthCardExpiryDate.text,
              controller.healthCardExpiryDate,
            );
          },
        ),
        myTextFormFieldWithBorder(
          obscureText: false,
          controller: controller.healthCardCost,
          labelText: 'Cost',
          validate: true,
          isDouble: true,
          width: 200,
          isEnabled: canEdit,
        ),
        myTextFormFieldWithBorder(
          obscureText: false,
          controller: controller.healthCardEmployeeContribution,
          labelText: 'Emp. Contribution',
          validate: true,
          isDouble: true,
          width: 200,
          isEnabled: canEdit,
        ),
      ],
    ),
  );
}
