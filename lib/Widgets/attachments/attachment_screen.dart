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
  AttachmentScreen({
    super.key,
    required this.screenName,
    required this.documentId,
  });

  final String screenName;
  final String documentId;
  late final AttachmentController controller = Get.put(
    AttachmentController(screenName: screenName, documentId: documentId),
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
            init: AttachmentController(
              screenName: screenName,
              documentId: documentId,
            ),
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
        init: AttachmentController(
          screenName: screenName,
          documentId: documentId,
        ),
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
                size: ColumnSize.L,
                label: Text('Type'),
                // onSort: controller.onSort,
              ),
              DataColumn2(
                size: ColumnSize.L,

                label: Text('Number'),
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

ClickableHoverText newAttachmentButton(
  BuildContext context,
  AttachmentController controller,
) {
  return ClickableHoverText(
    onTap: () {
      attachmentDialog(
        controller: controller,
        canEdit: true,
        onPressed: () {
          controller.addAttachments();
        },
      );
    },
    text: 'New Attachment',
  );
}

DataRow dataRowForTheTable(
  AttachmentsModel data,
  BuildContext context,
  String jobId,
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
      DataCell(textForDataRowInTable(text: data.name ?? '', maxWidth: null)),
      DataCell(
        InkWell(
          onTap: () {
            var openFile = FilePickerService();
            openFile.openFile(data.file ?? '', data.name ?? '');
          },
          child: textForDataRowInTable(
            text: data.file ?? '',
            maxWidth: null,
            isSelectable: false,
          ),
        ),
      ),
    ],
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
