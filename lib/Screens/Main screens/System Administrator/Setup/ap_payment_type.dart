import 'package:datahubai/Controllers/Main%20screen%20controllers/ap_payment_type_controller.dart';
import 'package:datahubai/Models/ap%20payment%20types/ap_payment_types_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart'
    show searchBar;
import '../../../../Widgets/main screen widgets/ap_payment_type_widgets/ap_payment_dialog.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../consts.dart';

class ApPaymentType extends StatelessWidget {
  const ApPaymentType({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: screenPadding,
            child: Container(
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  GetX<ApPaymentTypeController>(
                    init: ApPaymentTypeController(),
                    builder: (controller) {
                      return searchBar(
                        onChanged: (_) {
                          controller.filterTypes();
                        },
                        onPressedForClearSearch: () {
                          controller.search.value.clear();
                          controller.filterTypes();
                        },
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        title: 'Search for Types',
                        button: newTypeButton(context, constraints, controller),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<ApPaymentTypeController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return Center(child: loadingProcess);
                        }
                        if (controller.allApPaymentTypes.isEmpty) {
                          return const Center(child: Text('No Element'));
                        }
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SizedBox(
                            width: constraints.maxWidth,
                            child: tableOfScreens(
                              constraints: constraints,
                              context: context,
                              controller: controller,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget tableOfScreens({
  required BoxConstraints constraints,
  required BuildContext context,
  required ApPaymentTypeController controller,
}) {
  return DataTable(
    horizontalMargin: horizontalMarginForTable,
    dataRowMaxHeight: 40,
    dataRowMinHeight: 30,
    columnSpacing: 5,
    showBottomBorder: true,
    dataTextStyle: regTextStyle,
    headingTextStyle: fontStyleForTableHeader,
    sortColumnIndex: controller.sortColumnIndex.value,
    sortAscending: controller.isAscending.value,
    headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
    columns: [
      const DataColumn(label: Text('')),
      DataColumn(
        label: AutoSizedText(text: 'Type', constraints: constraints),
        // onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Creation Date'),
        // onSort: controller.onS ort,
      ),
    ],
    rows:
        controller.filteredApPaymentTypes.isEmpty &&
            controller.search.value.text.isEmpty
        ? controller.allApPaymentTypes.map<DataRow>((type) {
            final typeId = type.id;
            return dataRowForTheTable(
              type,
              context,
              constraints,
              typeId,
              controller,
            );
          }).toList()
        : controller.filteredApPaymentTypes.map<DataRow>((type) {
            final typeId = type.id;
            return dataRowForTheTable(
              type,
              context,
              constraints,
              typeId,
              controller,
            );
          }).toList(),
  );
}

DataRow dataRowForTheTable(
  APPaymentTypesModel typeData,
  context,
  constraints,
  typeId,
  ApPaymentTypeController controller,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            deleteSection(controller, typeId, context),
            editSection(context, controller, typeData, constraints, typeId),
          ],
        ),
      ),
      DataCell(Text(typeData.type ?? '')),
      DataCell(Text(textToDate(typeData.createdAt))),
    ],
  );
}

IconButton deleteSection(ApPaymentTypeController controller, typeId, context) {
  return IconButton(
    onPressed: () {
      alertDialog(
        context: context,
        content: "The type will be deleted permanently",
        onPressed: () {
          controller.deleteType(typeId);
        },
      );
    },
    icon: deleteIcon,
  );
}

IconButton editSection(
  BuildContext context,
  ApPaymentTypeController controller,
  APPaymentTypesModel typeData,
  constraints,
  typeId,
) {
  return IconButton(
    onPressed: () async {
      controller.type.text = typeData.type ?? '';
      apPaymentTypeDialog(
        constraints: constraints,
        controller: controller,
        canEdit: true,
        onPressed: controller.addingNewValue.value
            ? null
            : () {
                controller.updateType(typeId);
              },
      );
    },
    icon: editIcon,
  );
}

ElevatedButton newTypeButton(
  BuildContext context,
  BoxConstraints constraints,
  ApPaymentTypeController controller,
) {
  return ElevatedButton(
    onPressed: () {
      controller.type.clear();
      apPaymentTypeDialog(
        constraints: constraints,
        controller: controller,
        canEdit: true,
        onPressed: controller.addingNewValue.value
            ? null
            : () async {
                controller.addNewType();
              },
      );
    },
    style: newButtonStyle,
    child: const Text('New Type'),
  );
}
