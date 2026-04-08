import 'package:data_table_2/data_table_2.dart';
import 'package:datahubai/Controllers/Main%20screen%20controllers/employees_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Models/employees/payroll_elements_model.dart';
import '../../../../consts.dart';
import '../../auto_size_box.dart';
import 'payroll_elements_dialog.dart';

Widget payrollElementsSection(
  BoxConstraints constraints,
  BuildContext context,
) {
  return Container(
    decoration: containerDecor,
    height: 410,
    child: GetX<EmployeesController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: newPhoneButton(controller: controller, context: context),
            ),
            Expanded(
              child: tableOfScreens(
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

Widget tableOfScreens({
  required BoxConstraints constraints,
  required EmployeesController controller,
  required BuildContext context,
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
          label: AutoSizedText(constraints: constraints, text: 'Name'),
          size: ColumnSize.M,
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(constraints: constraints, text: 'Value'),
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(constraints: constraints, text: 'Start Date'),
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(constraints: constraints, text: 'End Date'),
        ),
        DataColumn2(
          size: ColumnSize.L,
          label: AutoSizedText(constraints: constraints, text: 'Note'),
        ),
      ],
      rows: controller.payrollElementsList.map<DataRow>((invoiceItems) {
        return dataRowForTheTable(
          invoiceItems,
          constraints,
          controller,
          context,
        );
      }).toList(),
    ),
  );
}

DataRow dataRowForTheTable(
  PayrollElementsModel data,
  BoxConstraints constraints,
  EmployeesController controller,
  BuildContext context,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            removePhoneButton(controller: controller, id: data.id ?? ''),
            updatephoneButton(
              controller: controller,
              data: data,
              id: data.id ?? '',
              context: context,
            ),
          ],
        ),
      ),
      DataCell(
        textForDataRowInTable(text: data.name.toString(), formatDouble: false),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.value ?? '',
          maxWidth: null,
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: textToDate(data.startDate),
          maxWidth: null,
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: textToDate(data.endDate),
          maxWidth: null,
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.note ?? '',
          maxWidth: null,
          formatDouble: false,
        ),
      ),
    ],
  );
}

ElevatedButton newPhoneButton({
  required EmployeesController controller,
  required BuildContext context,
}) {
  return ElevatedButton(
    onPressed: () {
      if (controller.currentEmployeeId.value.isEmpty) {
        alertMessage(context: Get.context!, content: "Please save doc first");
        return;
      }
      // controller.phoneType.clear();
      // controller.phoneTypeId.value = '';
      // controller.phoneNumber.clear();
      payrollElementsDialog(
        controller: controller,
        canEdit: true,
        onPressed: () {
          // controller.addNewPhone();
        },
        context: context,
      );
    },
    style: newButtonStyle,
    child: const Text(
      'New Line',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}

IconButton removePhoneButton({
  required EmployeesController controller,
  required String id,
}) {
  return IconButton(
    onPressed: () {
      // controller.deletePhone(id);
    },
    icon: deleteIcon,
  );
}

IconButton updatephoneButton({
  required PayrollElementsModel data,
  required EmployeesController controller,
  required String id,
  required BuildContext context,
}) {
  return IconButton(
    onPressed: () {
      // controller.phoneType.text = data.typeName ?? '';
      // controller.phoneTypeId.value = data.type ?? '';
      // controller.phoneNumber.text = data.phone ?? '';
      payrollElementsDialog(
        controller: controller,
        canEdit: true,
        onPressed: () {
          // controller.updatePhone(id);
        },
        context: context,
      );
    },
    icon: editIcon,
  );
}
