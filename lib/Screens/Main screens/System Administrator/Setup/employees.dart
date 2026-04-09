import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:datahubai/Models/employees/employees_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/employees_controller.dart';
import '../../../../Widgets/attachments/attachment_screen.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/employees_widgets/contacts_and_relatives_Dialog.dart';
import '../../../../Widgets/main screen widgets/employees_widgets/employee_dialog.dart';
import '../../../../Widgets/menu_dialog.dart';
import '../../../../Widgets/my_text_field.dart';
import '../../../../consts.dart';

class Employees extends StatelessWidget {
  const Employees({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: screenPadding,
            child: Column(
              children: [
                GetBuilder<EmployeesController>(
                  init: EmployeesController(),
                  builder: (controller) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth - 28,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          spacing: 10,
                          children: [
                            Row(
                              spacing: 10,
                              children: [
                                myTextFormFieldWithBorder(
                                  width: 250,
                                  labelText: 'Name',
                                  controller: controller.employeeNameFilter,
                                ),

                                MenuWithValues(
                                  labelText: 'Employer',
                                  headerLqabel: 'Employers',
                                  dialogWidth: 600,
                                  width: 250,
                                  controller: controller.employerFilter,
                                  displayKeys: const ['name'],
                                  displaySelectedKeys: const ['name'],
                                  onOpen: () {
                                    return controller.getallJobEmployers();
                                  },
                                  onDelete: () {
                                    controller.employerIdFilter.value = "";
                                    controller.employerFilter.clear();
                                  },
                                  onSelected: (value) {
                                    controller.employerIdFilter.value =
                                        value['_id'];
                                    controller.employerFilter.text =
                                        value['name'];
                                  },
                                ),
                                MenuWithValues(
                                  labelText: 'Department',
                                  headerLqabel: 'Departments',
                                  dialogWidth: 600,
                                  width: 250,
                                  controller: controller.departmentFilter,
                                  displayKeys: const ['name'],
                                  displaySelectedKeys: const ['name'],
                                  onOpen: () {
                                    return controller.getAllJobDepartments();
                                  },
                                  onDelete: () {
                                    controller.departmentIdFilter.value = "";
                                    controller.departmentFilter.clear();
                                  },
                                  onSelected: (value) {
                                    controller.departmentIdFilter.value =
                                        value['_id'];
                                    controller.departmentFilter.text =
                                        value['name'];
                                  },
                                ),
                                MenuWithValues(
                                  labelText: 'Job Title',
                                  headerLqabel: 'Jobs Titles',
                                  dialogWidth: 600,
                                  width: 250,
                                  controller: controller.jobTitleFilter,
                                  displayKeys: const ['name'],
                                  displaySelectedKeys: const ['name'],
                                  onOpen: () {
                                    return controller.getallJobTitle();
                                  },
                                  onDelete: () {
                                    controller.jobTitleIdFilter.value = "";
                                    controller.jobTitleFilter.clear();
                                  },
                                  onSelected: (value) {
                                    controller.jobTitleIdFilter.value =
                                        value['_id'];
                                    controller.jobTitleFilter.text =
                                        value['name'];
                                  },
                                ),
                                MenuWithValues(
                                  labelText: 'Location',
                                  headerLqabel: 'Locations',
                                  dialogWidth: 600,
                                  width: 250,
                                  controller: controller.locationFilter,
                                  displayKeys: const ['name'],
                                  displaySelectedKeys: const ['name'],
                                  onOpen: () {
                                    return controller.getallJobLocations();
                                  },
                                  onDelete: () {
                                    controller.locationIdFilter.value = "";
                                    controller.locationFilter.clear();
                                  },
                                  onSelected: (value) {
                                    controller.locationIdFilter.value =
                                        value['_id'];
                                    controller.locationFilter.text =
                                        value['name'];
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                GetX<EmployeesController>(
                  builder: (controller) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth - 28,
                        ),
                        child: Row(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,

                          children: [
                            Row(
                              spacing: 10,
                              children: [
                                newEmployeeButton(
                                  context,
                                  constraints,
                                  controller,
                                  true,
                                  'New Employee',
                                ),
                                newEmployeeButton(
                                  context,
                                  constraints,
                                  controller,
                                  false,
                                  'New Applicant',
                                ),
                              ],
                            ),
                            Row(
                              spacing: 10,
                              children: [
                                CustomSlidingSegmentedControl<int>(
                                  height: 30,
                                  initialValue:
                                      controller.initTypePickersValue.value,
                                  children: const {
                                    1: Text('ALL'),
                                    2: Text('EMPLOYEE'),
                                    3: Text('APPLICANT'),
                                    4: Text('EX-EMPLOYEE'),
                                  },
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.lightBackgroundGray,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  thumbDecoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(1),
                                        blurRadius: 4.0,
                                        spreadRadius: 1.0,
                                        offset: const Offset(0.0, 2.0),
                                      ),
                                    ],
                                  ),
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInToLinear,
                                  onValueChanged: (v) {
                                    controller.onChooseForTypePicker(v);
                                  },
                                ),
                              ],
                            ),
                            Row(
                              spacing: 10,
                              children: [
                                ElevatedButton(
                                  style: findButtonStyle,
                                  onPressed: controller.isScreenLoding.isFalse
                                      ? () async {
                                          controller.filterSearch();
                                        }
                                      : null,
                                  child: controller.isScreenLoding.isFalse
                                      ? Text(
                                          'Find',
                                          style: fontStyleForElevatedButtons,
                                        )
                                      : loadingProcess,
                                ),
                                ElevatedButton(
                                  style: clearVariablesButtonStyle,
                                  onPressed: () {
                                    // controller.clearAllFilters();
                                    // controller.update();
                                  },
                                  child: Text(
                                    'Clear',
                                    style: fontStyleForElevatedButtons,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GetX<EmployeesController>(
                      builder: (controller) {
                        return SizedBox(
                          width: constraints.maxWidth,
                          child: tableOfScreens(
                            constraints: constraints,
                            context: context,
                            controller: controller,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
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
  required EmployeesController controller,
}) {
  return PaginatedDataTable2(
    horizontalMargin: horizontalMarginForTable,
    columnSpacing: 5,
    sortColumnIndex: controller.sortColumnIndex.value,
    sortAscending: controller.isAscending.value,
    autoRowsToHeight: true,
    renderEmptyRowsInTheEnd: true,
    columns: [
      const DataColumn2(label: Text(''), size: ColumnSize.S),
      DataColumn2(
        label: AutoSizedText(text: 'Full Name', constraints: constraints),
        size: ColumnSize.M,
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Type'),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Status'),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Employer'),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Department'),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Job Title'),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Location'),
      ),
    ],
    source: CardDataSourceForEmployees(
      cards: controller.allEmployees.isEmpty ? [] : controller.allEmployees,
      context: context,
      constraints: constraints,
      controller: controller,
    ),
  );
}

DataRow dataRowForTheTable(
  EmployeesModel data,
  BuildContext context,
  BoxConstraints constraints,
  String employeeId,
  EmployeesController controller,
  int index,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            deleteSection(controller, employeeId, context),
            editSection(context, controller, data, constraints, employeeId),
          ],
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.fullName ?? '',
          color: Colors.blueGrey,
          isBold: true,
        ),
      ),
      DataCell(textForDataRowInTable(text: data.personType ?? '')),
      DataCell(textForDataRowInTable(text: data.status ?? '')),
      DataCell(textForDataRowInTable(text: data.employerName ?? '')),
      DataCell(textForDataRowInTable(text: data.departmentName ?? '')),
      DataCell(
        textForDataRowInTable(isBold: true, text: data.jobTitleName ?? ''),
      ),
      DataCell(
        textForDataRowInTable(isBold: true, text: data.locationName ?? ''),
      ),
    ],
  );
}

IconButton deleteSection(
  EmployeesController controller,
  String employeeId,
  BuildContext context,
) {
  return IconButton(
    onPressed: () {
      alertDialog(
        context: context,
        content: "The technicians will be deleted permanently",
        onPressed: () {
          // controller.deleteEmployee(employeeId);
        },
      );
    },
    icon: deleteIcon,
  );
}

IconButton editSection(
  BuildContext context,
  EmployeesController controller,
  EmployeesModel data,
  BoxConstraints constraints,
  String employeeId,
) {
  return IconButton(
    onPressed: () async {
      await controller.loadValues(employeeId);
      employeeDialog(
        onPressedForAttachment: () {
          Get.dialog(
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: AttachmentScreen(
                code: 'EMPLOYEES_ATTACHMENT',
                documentId: employeeId,
              ),
            ),
          );
        },
        constraints: constraints,
        controller: controller,
        onPressedForContactsAndRelatives: () async {
          controller.contactsAndRelativesSearch.value.clear();
          controller.filteredContactsAndRelativesList.clear();
          await controller.getContactAndRelative();

          contactsAndRelativesDialog(
            constraints: constraints,
            controller: controller,
            canEdit: true,
          );
        },

        onPressed: controller.addingNewValue.value
            ? null
            : () {
                controller.addNewEmployee();
              },
      );
    },
    icon: editIcon,
  );
}

ElevatedButton newEmployeeButton(
  BuildContext context,
  BoxConstraints constraints,
  EmployeesController controller,
  bool isEmployee,
  String buttonName,
) {
  return ElevatedButton(
    onPressed: () {
      controller.clearValues(isEmployee);

      employeeDialog(
        onPressedForContactsAndRelatives: () async {
          if (controller.currentEmployeeId.value.isEmpty) {
            alertMessage(context: context, content: "Please save doc first");
            return;
          }
          controller.contactsAndRelativesSearch.value.clear();
          contactsAndRelativesDialog(
            constraints: constraints,
            controller: controller,
            canEdit: true,
          );
        },
        onPressedForAttachment: () {
          if (controller.currentEmployeeId.isEmpty) {
            alertMessage(context: context, content: " Please save doc first");
            return;
          }
          Get.dialog(
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: AttachmentScreen(
                code: 'EMPLOYEES_ATTACHMENT',
                documentId: controller.currentEmployeeId.value,
              ),
            ),
          );
        },
        constraints: constraints,
        controller: controller,
        onPressed: controller.addingNewValue.value
            ? null
            : () async {
                await controller.addNewEmployee();
              },
      );
    },
    style: isEmployee == true ? newButtonStyle : newApplicantButtonStyle,
    child: Text(buttonName),
  );
}

class CardDataSourceForEmployees extends DataTableSource {
  final List<EmployeesModel> cards;
  final BuildContext context;
  final BoxConstraints constraints;
  final EmployeesController controller;

  CardDataSourceForEmployees({
    required this.cards,
    required this.context,
    required this.constraints,
    required this.controller,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= cards.length) return null;

    final card = cards[index];
    final cardId = card.id ?? '';

    return dataRowForTheTable(
      card,
      context,
      constraints,
      cardId,
      controller,
      index,
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => cards.length;

  @override
  int get selectedRowCount => 0;
}
