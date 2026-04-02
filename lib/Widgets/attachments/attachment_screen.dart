import 'package:data_table_2/data_table_2.dart';
import 'package:datahubai/Widgets/text_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/Widgets controllers/attachment_controller.dart';
import '../../Models/attachments/attachments_model.dart';
import '../../consts.dart';
import '../Auth screens widgets/register widgets/search_bar.dart';
import 'attachment_dialog.dart';
import 'documents_screen.dart';

class AttachmentScreen extends StatelessWidget {
  AttachmentScreen({super.key, required this.code, required this.documentId});

  final String code;
  final String documentId;
  late final AttachmentController controller = Get.put(
    AttachmentController(code: code, documentId: documentId),
    tag: documentId,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Attachments', style: TextStyle(color: Colors.white)),
        backgroundColor: mainColor,
        // leading: const SizedBox(),
        actions: [
          GetBuilder<AttachmentController>(
            init: AttachmentController(code: code, documentId: documentId),
            builder: (controller) {
              return newAttachmentButton(context, controller);
            },
          ),
          const SizedBox(width: 10),
          separator(),
          const SizedBox(width: 10),
          closeIcon(),
        ],
        actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              GetBuilder<AttachmentController>(
                init: AttachmentController(code: code, documentId: documentId),
                builder: (controller) {
                  return searchBar(
                    onChanged: (_) {
                      controller.filterAttachments();
                    },
                    onPressedForClearSearch: () {
                      controller.search.value.clear();
                      controller.filterAttachments();
                    },
                    search: controller.search,
                    constraints: constraints,
                    context: context,
                    title: 'Search for attachments',
                  );
                },
              ),
              Expanded(
                child: GetX<AttachmentController>(
                  builder: (controller) {
                    return PaginatedDataTable2(
                      border: TableBorder.symmetric(
                        inside: BorderSide(
                          color: Colors.grey.shade200,
                          width: 0.5,
                        ),
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
                        DataColumn2(size: ColumnSize.M, label: Text('Type')),
                        DataColumn2(size: ColumnSize.M, label: Text('Name')),

                        DataColumn2(size: ColumnSize.S, label: Text('Number')),
                        DataColumn2(
                          size: ColumnSize.M,
                          label: Text('Start Date'),
                        ),
                        DataColumn2(
                          size: ColumnSize.M,
                          label: Text('End Date'),
                        ),
                        DataColumn2(size: ColumnSize.L, label: Text('Note')),

                        DataColumn2(size: ColumnSize.S, label: Text('Files')),
                      ],
                      source: CardDataSource(
                        cards:
                            controller.search.value.text.isEmpty &&
                                controller.filteredAttachesList.isEmpty
                            ? controller.attachesList
                            : controller.filteredAttachesList,
                        context: context,
                        controller: controller,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

DataRow dataRowForTheTable(
  AttachmentsModel data,
  BuildContext context,
  String id,
  AttachmentController controller,
  int index,
) {
  final isEvenRow = index % 2 == 0;
  return DataRow2(
    // onSelectChanged: (_) {},
    // selected: true,
    color: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.yellow;
      }
      return !isEvenRow ? coolColor : Colors.white;
    }),
    cells: [
      DataCell(deleteSection(controller, id, context)),
      // DataCell(
      //   textForDataRowInTable(
      //     text: data.code ?? '',
      //     maxWidth: null,
      //     formatDouble: false,
      //   ),
      // ),
      DataCell(
        textForDataRowInTable(
          text: data.attachmentTypeName ?? '',
          maxWidth: null,
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.name ?? '',
          maxWidth: null,
          formatDouble: false,
        ),
      ),

      DataCell(
        textForDataRowInTable(
          text: data.number ?? '',
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
      // DataCell(
      //   textForDataRowInTable(
      //     text: data.fileName ?? '',
      //     maxWidth: null,
      //     formatDouble: false,
      //   ),
      // ),
      DataCell(
        textForDataRowInTable(
          text: data.note ?? '',
          maxWidth: null,
          formatDouble: false,
        ),
      ),
      DataCell(
        InkWell(
          onTap: () {},
          child: ClickableHoverText(
            text: 'OPEN',
            color2: Colors.grey,
            color1: Colors.blue,
            onTap: () {
              documentsScreen(documents: data.attachments ?? []);
            },
          ),
        ),
      ),
    ],
  );
}

ClickableHoverText newAttachmentButton(
  BuildContext context,
  AttachmentController controller,
) {
  return ClickableHoverText(
    onTap: () {
      controller.name.clear();
      controller.number.clear();
      controller.type.clear();
      controller.typeId.value = '';
      controller.fileName.value = '';
      controller.fileType.value = '';
      controller.fileBytes.value = null;
      controller.startDate.clear();
      controller.endDate.clear();
      controller.fileNameWhenSelectFile.clear();
      controller.note.clear();
      controller.selectedAttachments.clear();
      attachmentDialog(
        context: context,
        controller: controller,
        canEdit: true,
        onPressed: controller.addingNewAttachment.isFalse
            ? () {
                controller.addAttachments();
              }
            : null,
      );
    },
    text: 'New Attachment',
  );
}

IconButton deleteSection(
  AttachmentController controller,
  String id,
  BuildContext context,
) {
  return IconButton(
    onPressed: () {
      alertDialog(
        context: context,
        content: "The file will be deleted permanently",
        onPressed: () {
          controller.deleteattachmenth(id);
        },
      );
    },
    icon: deleteIcon,
  );
}

class CardDataSource extends DataTableSource {
  final List<AttachmentsModel> cards;
  final BuildContext context;
  final AttachmentController controller;

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
