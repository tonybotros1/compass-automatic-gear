import 'package:datahubai/Controllers/Main%20screen%20controllers/ap_payment_type_controller.dart';
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
                          return Center(
                            child: loadingProcess,
                          );
                        }
                        if (controller.allApPaymentTypes.isEmpty) {
                          return const Center(
                            child: Text('No Element'),
                          );
                        }
                        return SingleChildScrollView(
                          scrollDirection: Axis
                              .vertical, // Horizontal scrolling for the table
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

Widget tableOfScreens(
    {required constraints,
    required context,
    required ApPaymentTypeController controller}) {
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
      DataColumn(
        label: AutoSizedText(
          text: 'Type',
          constraints: constraints,
        ),
        // onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Creation Date',
        ),
        // onSort: controller.onS ort,
      ),
      const DataColumn(
        label: Text(''),
      ),
    ],
    rows: controller.filteredApPaymentTypes.isEmpty &&
            controller.search.value.text.isEmpty
        ? controller.allApPaymentTypes.map<DataRow>((type) {
            final typeData = type.data() as Map<String, dynamic>;
            final typeId = type.id;
            return dataRowForTheTable(
                typeData, context, constraints, typeId, controller);
          }).toList()
        : controller.filteredApPaymentTypes.map<DataRow>((type) {
            final typeData = type.data() as Map<String, dynamic>;
            final typeId = type.id;
            return dataRowForTheTable(
                typeData, context, constraints, typeId, controller);
          }).toList(),
  );
}

DataRow dataRowForTheTable(Map<String, dynamic> typeData, context,
    constraints, typeId, ApPaymentTypeController controller) {
  return DataRow(cells: [
    DataCell(Text(
      typeData['type'] ?? 'no type',
    )),
    DataCell(
      Text(
        typeData['added_date'] != null && typeData['added_date'] != ''
            ? textToDate(typeData['added_date']) //
            : 'N/A',
      ),
    ),
    DataCell(Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 5, left: 5),
          child: editSection(
              context, controller, typeData, constraints, typeId),
        ),
        deleteSection(controller, typeId, context),
      ],
    )),
  ]);
}

ElevatedButton deleteSection(
    ApPaymentTypeController controller, typeId, context) {
  return ElevatedButton(
      style: deleteButtonStyle,
      onPressed: () {
        alertDialog(
            context: context,
            controller: controller,
            content: "The type will be deleted permanently",
            onPressed: () {
              controller.deleteType(typeId);
            });
      },
      child: const Text("Delete"));
}

ElevatedButton editSection(context, ApPaymentTypeController controller,
    Map<String, dynamic> typeData, constraints, typeId) {
  return ElevatedButton(
      style: editButtonStyle,
      onPressed: () async {
       
        controller.type.text = typeData['type'];
        apPaymentTypeDialog(
            constraints: constraints,
            controller: controller,
            canEdit: true,
            onPressed: controller.addingNewValue.value
                ? null
                : () {
                    controller.editType(typeId);
                  });
      },
      child: const Text('Edit'));
}

ElevatedButton newTypeButton(BuildContext context, BoxConstraints constraints,
    ApPaymentTypeController controller) {
  return ElevatedButton(
    onPressed: () {
      controller.type.clear();
      apPaymentTypeDialog(
          constraints: constraints,
          controller: controller,
          canEdit: true,
          onPressed:
       controller.addingNewValue.value
          ? null
          : () async {
              await controller.addNewType();
            });
    },
    style: newButtonStyle,
    child: const Text('New Type'),
  );
}
