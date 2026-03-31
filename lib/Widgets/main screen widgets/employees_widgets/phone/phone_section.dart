import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/employees_controller.dart';
import '../../../../Models/employees/phone_model.dart';
import '../../../../consts.dart';
import '../../auto_size_box.dart';
import 'phone_dialog.dart';

Widget phoneSectionFotEmployees({
  required BoxConstraints constraints,
  required bool canEdit,
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
              child: newAddressButton(controller: controller),
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
          label: AutoSizedText(constraints: constraints, text: 'Phone'),
        ),
      ],
      rows: controller.phonesList.map<DataRow>((invoiceItems) {
        return dataRowForTheTable(invoiceItems, constraints, controller);
      }).toList(),
    ),
  );
}

DataRow dataRowForTheTable(
  PhoneModel data,
  BoxConstraints constraints,
  EmployeesController controller,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            removeAddressButton(controller: controller, id: data.id ?? ''),
            updateAddressButton(
              controller: controller,
              data: data,
              id: data.id ?? '',
            ),
          ],
        ),
      ),
      DataCell(
        textForDataRowInTable(text: data.type.toString(), formatDouble: false),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.phone ?? '',
          maxWidth: null,
          formatDouble: false,
        ),
      ),
    ],
  );
}

ElevatedButton newAddressButton({required EmployeesController controller}) {
  return ElevatedButton(
    onPressed: () {
      controller.phoneType.clear();
      controller.phoneTypeId.value = '';
      controller.phoneNumber.clear();
      phoneDialog(
        controller: controller,
        canEdit: true,
        onPressed: () {
          controller.addNewPhone();
        },
      );
    },
    style: newButtonStyle,
    child: const Text(
      'New Phone',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}

IconButton removeAddressButton({
  required EmployeesController controller,
  required String id,
}) {
  return IconButton(
    onPressed: () {
      controller.deletePhone(id);
    },
    icon: deleteIcon,
  );
}

IconButton updateAddressButton({
  required PhoneModel data,
  required EmployeesController controller,
  required String id,
}) {
  return IconButton(
    onPressed: () {
      controller.phoneType.text = data.type ?? '';
      controller.phoneTypeId.value = data.typeId ?? '';
      controller.phoneNumber.text = data.phone ?? '';
      phoneDialog(
        controller: controller,
        canEdit: true,
        onPressed: () {
          controller.updatePhone(id);
        },
      );
    },
    icon: editIcon,
  );
}
