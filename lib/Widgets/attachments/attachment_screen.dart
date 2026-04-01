import 'package:data_table_2/data_table_2.dart';
import 'package:datahubai/Widgets/text_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/Widgets controllers/attachment_controller.dart';
import '../../Models/attachments/attachments_model.dart';
import '../../consts.dart';
import '../../web_functions.dart';
import 'attachment_dialog.dart';

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
      body: GetX<AttachmentController>(
        init: AttachmentController(code: code, documentId: documentId),
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
              DataColumn2(
                size: ColumnSize.S,
                label: SizedBox(),
                // onSort: controller.onSort,
              ),
              DataColumn2(
                size: ColumnSize.S,
                label: Text('Code'),
                // onSort: controller.onSort,
              ),
              DataColumn2(
                size: ColumnSize.M,
                label: Text('Name'),
                // onSort: controller.onSort,
              ),
              DataColumn2(
                size: ColumnSize.M,
                label: Text('Type'),
                // onSort: controller.onSort,
              ),
              DataColumn2(
                size: ColumnSize.S,
                label: Text('Number'),
                // onSort: controller.onSort,
              ),
              DataColumn2(
                size: ColumnSize.M,
                label: Text('Start Date'),
                // onSort: controller.onSort,
              ),
              DataColumn2(
                size: ColumnSize.M,
                label: Text('End Date'),
                // onSort: controller.onSort,
              ),
              DataColumn2(
                size: ColumnSize.L,
                label: Text('File Name'),
                // onSort: controller.onSort,
              ),
              DataColumn2(
                size: ColumnSize.L,
                label: Text('Note'),
                // onSort: controller.onSort,
              ),

              DataColumn2(
                size: ColumnSize.S,
                label: Text('File'),
                // onSort: controller.onSort,
              ),
            ],
            source: CardDataSource(
              cards: controller.attachesList.isEmpty
                  ? []
                  : controller.attachesList,
              context: context,
              controller: controller,
            ),
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
      DataCell(
        textForDataRowInTable(
          text: data.code ?? '',
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
          text: data.attachmentTypeName ?? '',
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
      DataCell(
        textForDataRowInTable(
          text: data.fileName ?? '',
          maxWidth: null,
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.note ?? '',
          maxWidth: null,
          formatDouble: false,
        ),
      ),
      DataCell(
        InkWell(
          onTap: () {
            if (isTheFileImage(data.fileName ?? '')) {
              openImageViewer([data.fileURL], 1);
            } else {
              var openFile = FilePickerService();
              openFile.openFile(
                data.fileURL ?? '',
                "${data.attachmentTypeName ?? ''} - ${data.name ?? ''}",
              );
            }
          },
          child: returnFileLogo(
            width: 30,
            fileName: data.fileName ?? '',
            filePath: data.fileURL,
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
