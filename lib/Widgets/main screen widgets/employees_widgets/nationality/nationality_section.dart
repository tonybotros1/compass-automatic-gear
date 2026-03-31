import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/employees_controller.dart';
import '../../../../Models/employees/nationality_model.dart';
import '../../../../consts.dart';
import '../../auto_size_box.dart';
import 'nationality_dialog.dart';

Widget nationalitySectionFotEmployees({
  required BoxConstraints constraints,
  required BuildContext context,
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
              child: newNationalityButton(
                controller: controller,
                context: context,
              ),
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
          label: AutoSizedText(constraints: constraints, text: 'Nationality'),
          size: ColumnSize.L,
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(constraints: constraints, text: 'Start Date'),
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(constraints: constraints, text: 'End Date'),
        ),
      ],
      rows: controller.nationalityList.map<DataRow>((invoiceItems) {
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
  NationalityModel addressData,
  BoxConstraints constraints,
  EmployeesController controller,
  BuildContext context,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            removeNationalityButton(
              controller: controller,
              id: addressData.id ?? '',
            ),
            updateNationalityButton(
              controller: controller,
              data: addressData,
              id: addressData.id ?? '',
              context: context,
            ),
          ],
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: addressData.nationality.toString(),
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: textToDate(addressData.startDate),
          maxWidth: null,
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: textToDate(addressData.endDate),
          maxWidth: null,
          formatDouble: false,
        ),
      ),
    ],
  );
}

ElevatedButton newNationalityButton({
  required EmployeesController controller,
  required BuildContext context,
}) {
  return ElevatedButton(
    onPressed: () {
      controller.nationality.clear();
      controller.nationalityStartDate.clear();
      controller.nationalityEndDate.clear();
      nationalityDialog(
        controller: controller,
        canEdit: true,
        context: context,
        onPressed: () {
          controller.addNewNationality();
        },
      );
    },
    style: newButtonStyle,
    child: const Text(
      'New Nationality',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}

IconButton removeNationalityButton({
  required EmployeesController controller,
  required String id,
}) {
  return IconButton(
    onPressed: () {
      controller.deleteNationality(id);
    },
    icon: deleteIcon,
  );
}

IconButton updateNationalityButton({
  required NationalityModel data,
  required EmployeesController controller,
  required String id,
  required BuildContext context,
}) {
  return IconButton(
    onPressed: () {
      controller.nationality.text = data.nationality ?? '';
      controller.nationalityStartDate.text = textToDate(data.startDate);
      controller.nationalityEndDate.text = textToDate(data.endDate);
      nationalityDialog(
        controller: controller,
        canEdit: true,
        context: context,
        onPressed: () {
          controller.updateNationality(id);
        },
      );
    },
    icon: editIcon,
  );
}
