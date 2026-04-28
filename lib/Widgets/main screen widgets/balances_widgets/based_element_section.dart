import 'package:data_table_2/data_table_2.dart';
import 'package:datahubai/Models/payroll%20elements/based_elements_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../consts.dart';
import '../../../Controllers/Main screen controllers/balances_controller.dart';
import '../auto_size_box.dart';
import 'based_elements_dialog.dart';

Widget basedElementsSection(BoxConstraints constraints) {
  return Container(
    decoration: containerDecor,
    child: GetX<BalancesController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: newElementButton(controller: controller),
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
  required BalancesController controller,
}) {
  return SizedBox(
    // width: constraints.maxWidth - 17,
    child: DataTable2(
      columnSpacing: 5,
      horizontalMargin: horizontalMarginForTable,
      showBottomBorder: true,
      lmRatio: 2,
      columns: [
        const DataColumn2(label: SizedBox(), size: ColumnSize.S),
        DataColumn2(
          label: AutoSizedText(constraints: constraints, text: 'Element Name'),
          size: ColumnSize.L,
        ),
        DataColumn2(
          size: ColumnSize.L,
          label: AutoSizedText(constraints: constraints, text: 'Type'),
        ),
      ],
      rows: controller.basedElementsList.map<DataRow>((invoiceItems) {
        return dataRowForTheTable(invoiceItems, constraints, controller);
      }).toList(),
    ),
  );
}

DataRow dataRowForTheTable(
  BasedElementsModel data,
  BoxConstraints constraints,
  BalancesController controller,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            removeElementButton(controller: controller, id: data.id ?? ''),
            updateElementButton(
              controller: controller,
              data: data,
              id: data.id ?? '',
            ),
          ],
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.elementNameValue.toString(),
          formatDouble: false,
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.type ?? '',
          maxWidth: null,
          formatDouble: false,
        ),
      ),
    ],
  );
}

ElevatedButton newElementButton({required BalancesController controller}) {
  return ElevatedButton(
    onPressed: () {
      if (controller.currentBalanceId.value.isEmpty) {
        alertMessage(context: Get.context!, content: "Please save doc first");
        return;
      }
      controller.basedElementName.clear();
      controller.basedElementType.clear();
      controller.basedElementNameId.value = '';
      basedAlementsDialog(
        controller: controller,
        canEdit: true,
        onPressed: () {
          controller.addNewBasedElements();
        },
      );
    },
    style: newButtonStyle,
    child: const Text('New', style: TextStyle(fontWeight: FontWeight.bold)),
  );
}

IconButton removeElementButton({
  required BalancesController controller,
  required String id,
}) {
  return IconButton(
    onPressed: () {
      alertDialog(
        context: Get.context!,
        content: "Are you sure you want to delete this element?",
        onPressed: () {
          Get.back();
          controller.deleteBasedElement(id);
        },
      );
    },
    icon: deleteIcon,
  );
}

IconButton updateElementButton({
  required BasedElementsModel data,
  required BalancesController controller,
  required String id,
}) {
  return IconButton(
    onPressed: () {
      controller.basedElementName.text = data.elementNameValue ?? '';
      controller.basedElementNameId.value = data.elementName ?? '';
      controller.basedElementType.text = data.type ?? '';
      basedAlementsDialog(
        controller: controller,
        canEdit: true,
        onPressed: () {
          controller.updateBasedElements(id);
        },
      );
    },
    icon: editIcon,
  );
}
