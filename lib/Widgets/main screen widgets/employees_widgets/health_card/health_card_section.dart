import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/employees_controller.dart';
import '../../../../Models/employees/employee_health_card_model.dart';
import '../../../../consts.dart';
import '../../auto_size_box.dart';
import 'health_card_dialog.dart';

Widget healthCardSection({
  required BoxConstraints constraints,
  required BuildContext context,
}) {
  return Container(
    decoration: containerDecor,
    child: GetX<EmployeesController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: newHealthCardButton(
                controller: controller,
                context: context,
              ),
            ),
            Expanded(
              child: healthCardTable(
                constraints: constraints,
                controller: controller,
                context: context,
              ),
            ),
          ],
        );
      },
    ),
  );
}

Widget healthCardTable({
  required BoxConstraints constraints,
  required EmployeesController controller,
  required BuildContext context,
}) {
  return SizedBox(
    child: DataTable2(
      columnSpacing: 5,
      horizontalMargin: horizontalMarginForTable,
      showBottomBorder: true,
      sortColumnIndex: controller.sortColumnIndex.value,
      sortAscending: controller.isAscending.value,
      lmRatio: 2,
      columns: [
        const DataColumn2(label: SizedBox(), size: ColumnSize.M),
        DataColumn2(
          label: AutoSizedText(
            constraints: constraints,
            text: 'Health Card Type',
          ),
          size: ColumnSize.L,
        ),
        DataColumn2(
          label: AutoSizedText(
            constraints: constraints,
            text: 'Health Card Holder',
          ),
          size: ColumnSize.L,
        ),
      ],
      rows: controller.healthCardsList.map<DataRow>((healthCard) {
        return healthCardDataRow(healthCard, constraints, controller, context);
      }).toList(),
    ),
  );
}

DataRow healthCardDataRow(
  EmployeeHealthCardModel data,
  BoxConstraints constraints,
  EmployeesController controller,
  BuildContext context,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            removeHealthCardButton(
              controller: controller,
              id: data.id ?? '',
              context: context,
            ),
            updateHealthCardButton(
              controller: controller,
              data: data,
              id: data.id ?? '',
              context: context,
            ),
          ],
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.healthCardType ?? '',
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.healthCardHolder ?? '',
          formatDouble: false,
        ),
      ),
    ],
  );
}

ElevatedButton newHealthCardButton({
  required EmployeesController controller,
  required BuildContext context,
}) {
  return ElevatedButton(
    onPressed: () {
      if (controller.currentEmployeeId.value.isEmpty) {
        alertMessage(context: Get.context!, content: "Please save doc first");
        return;
      }
      controller.clearHealthCardFields();
      healthCardDialog(
        controller: controller,
        canEdit: true,
        context: context,
        onPressed: controller.addingNewEmployeeHealthCard.isTrue
            ? null
            : () {
                controller.addNewEmployeeHealthCard();
              },
      );
    },
    style: newButtonStyle,
    child: const Text('New', style: TextStyle(fontWeight: FontWeight.bold)),
  );
}

IconButton removeHealthCardButton({
  required EmployeesController controller,
  required String id,
  required BuildContext context,
}) {
  return IconButton(
    onPressed: () {
      alertDialog(
        context: context,
        content: "Are you sure you want to delete this document?",
        onPressed: () {
          Get.back();
          controller.deleteEmployeeHealthCard(id);
        },
      );
    },
    icon: deleteIcon,
  );
}

IconButton updateHealthCardButton({
  required EmployeeHealthCardModel data,
  required EmployeesController controller,
  required String id,
  required BuildContext context,
}) {
  return IconButton(
    onPressed: () {
      controller.healthCardType.text = data.healthCardType ?? '';
      controller.healthCardTypeId.value = data.healthCardTypeId ?? '';
      controller.healthCardHolder.text = data.healthCardHolder ?? '';
      controller.healthCardHolderId.value = data.healthCardHolderId ?? '';
      controller.healthCardHolderType.text = data.healthCardHolderType ?? '';
      controller.healthCardNumber.text = data.cardNumber ?? '';
      controller.healthCardInsuranceCompany.text = data.insuranceCompany ?? '';
      controller.healthCardInsuranceCompanyId.value =
          data.insuranceCompanyId ?? '';
      controller.healthCardIssueDate.text = textToDate(data.issueDate);
      controller.healthCardExpiryDate.text = textToDate(data.expiryDate);
      controller.healthCardCost.text = data.cost?.toString() ?? '';
      controller.healthCardEmployeeContribution.text =
          data.employeeContribution?.toString() ?? '';
      healthCardDialog(
        context: context,
        controller: controller,
        canEdit: true,
        onPressed: controller.addingNewEmployeeHealthCard.isTrue
            ? null
            : () {
                controller.updateEmployeeHealthCard(id);
              },
      );
    },
    icon: editIcon,
  );
}
