import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/employees_controller.dart';
import '../../../../Models/employees/email_model.dart';
import '../../../../consts.dart';
import '../../auto_size_box.dart';
import 'email_dialog.dart';

Widget emailSectionFotEmployees({required BoxConstraints constraints}) {
  return Container(
    decoration: containerDecor,
    child: GetX<EmployeesController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: newEmailButton(controller: controller),
            ),
            Expanded(
              child: tableOfScreens(
                constraints: constraints,
                controller: controller,
              ),
            ),
          ],
        );
      },
    ),
  );
}

Widget tableOfScreens({
  required BoxConstraints constraints,
  required EmployeesController controller,
}) {
  return SizedBox(
    // width: constraints.maxWidth - 17,
    child: DataTable2(
      columnSpacing: 5,
      horizontalMargin: horizontalMarginForTable,
      showBottomBorder: true,
      sortColumnIndex: controller.sortColumnIndex.value,
      sortAscending: controller.isAscending.value,
      lmRatio: 2,
      columns: [
        const DataColumn2(label: SizedBox(), size: ColumnSize.S),
        DataColumn2(
          label: AutoSizedText(constraints: constraints, text: 'Type'),
          size: ColumnSize.L,
        ),
        DataColumn2(
          size: ColumnSize.L,
          label: AutoSizedText(constraints: constraints, text: 'Contact Details'),
        ),
      ],
      rows: controller.emailsList.map<DataRow>((invoiceItems) {
        return dataRowForTheTable(invoiceItems, constraints, controller);
      }).toList(),
    ),
  );
}

DataRow dataRowForTheTable(
  EmailModel data,
  BoxConstraints constraints,
  EmployeesController controller,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            removeEmailButton(controller: controller, id: data.id ?? ''),
            updateEmailButton(
              controller: controller,
              data: data,
              id: data.id ?? '',
            ),
          ],
        ),
      ),
      DataCell(
        textForDataRowInTable(text: data.type ?? '', formatDouble: false),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.email ?? '',
          maxWidth: null,
          formatDouble: false,
        ),
      ),
    ],
  );
}

ElevatedButton newEmailButton({required EmployeesController controller}) {
  return ElevatedButton(
    onPressed: () {
      controller.emailType.clear();
      controller.emailTypeId.value = '';
      controller.emailAddress.clear();
      emailDialog(
        controller: controller,
        canEdit: true,
        onPressed: () {
          controller.addNewEmail();
        },
      );
    },
    style: newButtonStyle,
    child: const Text(
      'New Contact',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}

IconButton removeEmailButton({
  required EmployeesController controller,
  required String id,
}) {
  return IconButton(
    onPressed: () {
      controller.deleteEmail(id);
    },
    icon: deleteIcon,
  );
}

IconButton updateEmailButton({
  required EmailModel data,
  required EmployeesController controller,
  required String id,
}) {
  return IconButton(
    onPressed: () {
      controller.emailType.text = data.type ?? '';
      controller.emailTypeId.value = data.typeId ?? '';
      controller.emailAddress.text = data.email ?? '';
      emailDialog(
        controller: controller,
        canEdit: true,
        onPressed: () {
          controller.updateEmail(id);
        },
      );
    },
    icon: editIcon,
  );
}
