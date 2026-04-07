import 'package:data_table_2/data_table_2.dart';
import 'package:datahubai/Controllers/Main%20screen%20controllers/employees_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Models/employees/contact_and_relatives_model.dart';
import '../../../consts.dart';
import '../../Auth screens widgets/register widgets/search_bar.dart';
import '../../attachments/attachment_screen.dart';
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
                  controller.filterContactsAndRelatives();
                },
                onPressedForClearSearch: () {
                  controller.contactsAndRelativesSearch.value.clear();
                  controller.filterContactsAndRelatives();
                },
                search: controller.contactsAndRelativesSearch,
                constraints: constraints,
                context: context,
                title: 'Search for contacts',
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
                    cards:
                        controller.filteredContactsAndRelativesList.isEmpty &&
                            controller
                                .contactsAndRelativesSearch
                                .value
                                .text
                                .isEmpty
                        ? controller.contactsAndRelativesList
                        : controller.filteredContactsAndRelativesList,
                    controller: controller,
                    context: context,
                    constraints: constraints,
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
  BoxConstraints constraints,
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
      DataCell(
        Row(
          children: [
            deleteSection(controller, id, context),
            editSection(controller, context, constraints, id, data),
            attachmentSection(id),
          ],
        ),
      ),

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
        content: "The contact will be deleted permanently",
        onPressed: () {
          Get.back();
          controller.deleteContactAndRelative(id);
        },
      );
    },
    icon: deleteIcon,
  );
}

IconButton attachmentSection(String id) {
  return IconButton(
    onPressed: () {
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: AttachmentScreen(
            code: 'EMPLOYEES_CONTACTS_AND_RELATIVES_ATTACHMENT',
            documentId: id,
          ),
        ),
      );
    },
    icon: attachIcon,
  );
}

IconButton editSection(
  EmployeesController controller,
  BuildContext context,
  BoxConstraints constraints,
  String contactId,
  ContactsAndRelativesModel data,
) {
  return IconButton(
    onPressed: () {
      controller.contactAndRelativeFullName.text = data.fullName ?? '';
      controller.contactAndRelativeRelationship.text =
          data.relationshipName ?? '';
      controller.contactAndRelativeRelationshipId.value =
          data.relationship ?? '';
      controller.contactAndRelativePhoneNumber.text = data.phoneNumber ?? '';
      controller.contactAndRelativeGender.text = data.genderName ?? '';
      controller.contactAndRelativeGenderId.value = data.gender ?? '';
      controller.contactAndRelativeDateOfBirth.text = textToDate(
        data.dateOfBirth,
      );
      controller.contactAndRelativeNationality.text =
          data.nationalityName ?? '';
      controller.contactAndRelativeNationalityId.value = data.nationality ?? '';
      controller.contactAndRelativeEmailAddress.text = data.emailAddress ?? '';
      controller.contactAndRelativeNotes.text = data.note ?? '';
      controller.isThisContactAnEmergencyConact.value =
          data.isEmergency ?? false;
      contactsAndRelativesInsertingDialog(
        onPressedForDocumentAndRecord: () {},
        constraints: constraints,
        controller: controller,
        canEdit: true,
        onPressed: controller.addingNewContactAndRelativesValue.isTrue
            ? null
            : () async {
                await controller.updateContactAndRelative(contactId);
              },
      );
    },
    icon: editIcon,
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
  final BoxConstraints constraints;

  CardDataSource({
    required this.cards,
    required this.context,
    required this.controller,
    required this.constraints,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= cards.length) return null;

    final data = cards[index];
    final cardId = data.id ?? '';

    return dataRowForTheTable(
      data,
      context,
      cardId,
      controller,
      index,
      constraints,
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => cards.length;

  @override
  int get selectedRowCount => 0;
}
