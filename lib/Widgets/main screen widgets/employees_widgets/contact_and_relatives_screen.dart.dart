import 'package:data_table_2/data_table_2.dart';
import 'package:datahubai/Controllers/Main%20screen%20controllers/employees_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Models/employees/contact_and_relatives_model.dart';
import '../../../consts.dart';
import '../../Auth screens widgets/register widgets/search_bar.dart';
import 'contact_and_relative_inserting_dialog.dart';

Widget contactsAndRelativesScreen({
  required EmployeesController controller,
  required bool canEdit,
  required BoxConstraints constraints,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Column(
        children: [
          GetBuilder<EmployeesController>(
            builder: (controller) {
              return searchBar(
                onChanged: (_) {
                  // controller.filterAttachments();
                },
                onPressedForClearSearch: () {
                  // controller.search.value.clear();
                  // controller.filterAttachments();
                },
                search: controller.search,
                constraints: constraints,
                context: context,
                title: 'Search for attachments',
                button: newContactAndRelativesButton(
                  context,
                  constraints,
                  controller,
                ),
              );
            },
          ),
          Expanded(
            child: GetX<EmployeesController>(
              builder: (controller) {
                return PaginatedDataTable2(
                  border: TableBorder.symmetric(
                    inside: BorderSide(color: Colors.grey.shade200, width: 0.5),
                  ),
                  smRatio: 0.67,
                  lmRatio: 3,
                  autoRowsToHeight: true,
                  showCheckboxColumn: false,
                  headingRowHeight: 60,
                  columnSpacing: 5,
                  showFirstLastButtons: true,
                  horizontalMargin: 5,
                  dataRowHeight: 40,
                  columns: const [
                    DataColumn2(size: ColumnSize.S, label: SizedBox()),
                    DataColumn2(size: ColumnSize.M, label: Text('Full Name')),
                    DataColumn2(
                      size: ColumnSize.M,
                      label: Text('Releationship'),
                    ),

                    DataColumn2(
                      size: ColumnSize.M,
                      label: Text('Phone Number'),
                    ),
                    DataColumn2(size: ColumnSize.M, label: Text('Gender')),
                    DataColumn2(
                      size: ColumnSize.M,
                      label: Text('Date Of Birth'),
                    ),
                    DataColumn2(size: ColumnSize.M, label: Text('Nationality')),

                    DataColumn2(size: ColumnSize.M, label: Text('Type')),
                    DataColumn2(
                      size: ColumnSize.M,
                      label: Text('Email Address'),
                    ),
                  ],
                  source: CardDataSource(
                    cards: controller.contactsAndRelativesList.isEmpty
                        ? []
                        : controller.contactsAndRelativesList,
                    controller: controller,
                    context: context,
                  ),
                );
              },
            ),
          ),
        ],
      );
    },
  );
}

DataRow dataRowForTheTable(
  ContactsAndRelativesModel data,
  BuildContext context,
  String id,
  EmployeesController controller,
  int index,
) {
  final isEvenRow = index % 2 == 0;
  return DataRow2(
    color: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.yellow;
      }
      return !isEvenRow ? coolColor : Colors.white;
    }),
    cells: [
      DataCell(deleteSection(controller, id, context)),

      DataCell(
        textForDataRowInTable(
          text: data.fullName ?? '',
          maxWidth: null,
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.relationshipName ?? '',
          maxWidth: null,
          formatDouble: false,
        ),
      ),

      DataCell(
        textForDataRowInTable(
          text: data.phoneNumber ?? '',
          maxWidth: null,
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.genderName ?? '',
          maxWidth: null,
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: textToDate(data.dateOfBirth),
          maxWidth: null,
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.nationalityName ?? '',
          maxWidth: null,
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.isEmergency == true ? 'EMERGENCY' : '-',
          maxWidth: null,
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.emailAddress ?? '',
          maxWidth: null,
          formatDouble: false,
        ),
      ),
    ],
  );
}

IconButton deleteSection(
  EmployeesController controller,
  String id,
  BuildContext context,
) {
  return IconButton(
    onPressed: () {
      alertDialog(
        context: context,
        content: "The file will be deleted permanently",
        onPressed: () {
          // controller.deleteattachmenth(id);
        },
      );
    },
    icon: deleteIcon,
  );
}

ElevatedButton newContactAndRelativesButton(
  BuildContext context,
  BoxConstraints constraints,
  EmployeesController controller,
) {
  return ElevatedButton(
    onPressed: () {
      controller.contactAndRelativeFullName.clear();
      controller.contactAndRelativeRelationship.clear();
      controller.contactAndRelativeRelationshipId.value = '';
      controller.contactAndRelativePhoneNumber.clear();
      controller.contactAndRelativeGender.clear();
      controller.contactAndRelativeGenderId.value = '';
      controller.contactAndRelativeDateOfBirth.clear();
      controller.contactAndRelativeNationality.clear();
      controller.contactAndRelativeNationalityId.value = '';
      controller.contactAndRelativeEmailAddress.clear();
      controller.contactAndRelativeNotes.clear();
      controller.isThisContactAnEmergencyConact.value = false;
      contactsAndRelativesInsertingDialog(
        onPressedForDocumentAndRecord: () {},
        constraints: constraints,
        controller: controller,
        canEdit: true,
        onPressed: controller.addingNewContactAndRelativesValue.isTrue
            ? null
            : () async {
                await controller.addNewContactAndRelative();
              },
      );
    },
    style: newButtonStyle,
    child: const Text('New Record'),
  );
}

class CardDataSource extends DataTableSource {
  final List<ContactsAndRelativesModel> cards;
  final BuildContext context;
  final EmployeesController controller;

  CardDataSource({
    required this.cards,
    required this.context,
    required this.controller,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= cards.length) return null;

    final data = cards[index];
    final cardId = data.id ?? '';

    return dataRowForTheTable(data, context, cardId, controller, index);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => cards.length;

  @override
  int get selectedRowCount => 0;
}
