import 'package:datahubai/Controllers/Main%20screen%20controllers/converters_controller.dart';
import 'package:datahubai/Models/converters/converter_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../auto_size_box.dart';

Widget itemsSection({
  required BuildContext context,
  required BoxConstraints constraints,
}) {
  return Container(
    decoration: containerDecor,
    child: GetX<ConvertersController>(
      builder: (controller) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: tableOfScreens(
            constraints: constraints,
            context: context,
            controller: controller,
          ),
        );
      },
    ),
  );
}

Widget tableOfScreens({
  required BoxConstraints constraints,
  required BuildContext context,
  required ConvertersController controller,
}) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: SizedBox(
      width: constraints.maxWidth - 17,
      child: DataTable(
        dataRowMaxHeight: 40,
        dataRowMinHeight: 30,
        columnSpacing: 5,
        horizontalMargin: horizontalMarginForTable,
        showBottomBorder: true,
        dataTextStyle: regTextStyle,
        headingTextStyle: fontStyleForTableHeader,
        sortColumnIndex: controller.sortColumnIndex.value,
        sortAscending: controller.isAscending.value,
        headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
        columns: [
          DataColumn(
            columnWidth: const IntrinsicColumnWidth(flex: 1.5),
            label: AutoSizedText(
              constraints: constraints,
              text: 'Issue Number',
            ),
          ),
          DataColumn(
            columnWidth: const IntrinsicColumnWidth(flex: 1.5),
            label: AutoSizedText(constraints: constraints, text: 'Issue Date'),
          ),
          DataColumn(
            columnWidth: const IntrinsicColumnWidth(flex: 1.5),
            label: AutoSizedText(
              constraints: constraints,
              text: 'Issue Status',
            ),
          ),
          DataColumn(
            columnWidth: const IntrinsicColumnWidth(flex: 2),
            label: AutoSizedText(constraints: constraints, text: 'Item Code'),
          ),
          DataColumn(
            columnWidth: const IntrinsicColumnWidth(flex: 1),
            label: AutoSizedText(constraints: constraints, text: 'Item Name'),
          ),
          DataColumn(
            columnWidth: const IntrinsicColumnWidth(flex: 1),
            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'Quantity'),
          ),
          DataColumn(
            columnWidth: const IntrinsicColumnWidth(flex: 1),
            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'Price'),
          ),
          DataColumn(
            columnWidth: const IntrinsicColumnWidth(flex: 1),
            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'Total'),
          ),
        ],
        rows: [
          ...controller.issues.map<DataRow>((invoiceItems) {
            return dataRowForTheTable(
              invoiceItems,
              context,
              constraints,
              controller,
            );
          }),
          DataRow(
            selected: true,
            cells: [
              const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(Text('')),
              DataCell(textForDataRowInTable(text: 'Totals', isBold: true)),
              DataCell(
                textForDataRowInTable(
                  text: '${controller.finalItemsTotal.value}',
                  color: Colors.blue,
                  isBold: true,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

DataRow dataRowForTheTable(
  Issues data,
  BuildContext context,
  BoxConstraints constraints,
  ConvertersController controller,
) {
  return DataRow(
    cells: [
      DataCell(textForDataRowInTable(text: data.issuingNumber ?? '')),
      DataCell(textForDataRowInTable(text: textToDate(data.date))),
      DataCell(
        statusBox(
          data.status ?? '',
          hieght: 35,
          width: 100,
          padding: const EdgeInsets.symmetric(horizontal: 5),
        ),
      ),
      DataCell(textForDataRowInTable(text: data.itemCode ?? '')),
      DataCell(textForDataRowInTable(text: data.itemName ?? '')),
      DataCell(
        textForDataRowInTable(
          text: '${data.quantity ?? ''}',
          color: Colors.green,
          isBold: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: '${data.price ?? ""}',
          color: Colors.red,
          isBold: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: '${data.total ?? ''}',
          color: Colors.blueGrey,
          isBold: true,
        ),
      ),
    ],
  );
}
