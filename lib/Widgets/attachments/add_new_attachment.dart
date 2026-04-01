import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import '../../Controllers/Widgets controllers/attachment_controller.dart';
import '../../web_functions.dart';
import '../menu_dialog.dart';
import '../my_text_field.dart';

Widget addNewAttachment({
  required AttachmentController controller,
  required bool canEdit,
  required BuildContext context,
}) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: myTextFormFieldWithBorder(
                obscureText: false,
                controller: controller.name,
                labelText: 'Name',
                validate: true,
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                obscureText: false,
                controller: controller.attachmentCode,
                labelText: 'Code',
                validate: true,
              ),
            ),
          ],
        ),
        Row(spacing: 10,
          children: [
            Expanded(
              child: MenuWithValues(
                labelText: 'Type',
                headerLqabel: 'Attachment Types',
                dialogWidth: 600,
                controller: controller.type,
                displayKeys: const ['name'],
                displaySelectedKeys: const ['name'],
                onOpen: () {
                  return controller.getAttachmentTypes();
                },
                onDelete: () {
                  controller.typeId.value = "";
                  controller.type.clear();
                },
                onSelected: (value) {
                  controller.typeId.value = value['_id'];
                  controller.type.text = value['name'];
                },
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                obscureText: false,
                controller: controller.number,
                labelText: 'Number',
                validate: true,
              ),
            ),
          ],
        ),
        Row(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: myTextFormFieldWithBorder(
                controller: controller.startDate,
                labelText: 'Start Date',
                onFieldSubmitted: (_) async {
                  normalizeDate(
                    controller.startDate.text,
                    controller.startDate,
                  );
                },
                onTapOutside: (_) {
                  normalizeDate(
                    controller.startDate.text,
                    controller.startDate,
                  );
                },
                suffixIcon: IconButton(
                  focusNode: FocusNode(skipTraversal: true),
                  onPressed: () async {
                    selectDateContext(context, controller.startDate);
                  },
                  icon: const Icon(Icons.date_range),
                ),
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                controller: controller.endDate,
                labelText: 'End Date',
                onFieldSubmitted: (_) async {
                  normalizeDate(controller.endDate.text, controller.endDate);
                },
                onTapOutside: (_) {
                  normalizeDate(controller.endDate.text, controller.endDate);
                },
                suffixIcon: IconButton(
                  focusNode: FocusNode(skipTraversal: true),
                  onPressed: () async {
                    selectDateContext(context, controller.endDate);
                  },
                  icon: const Icon(Icons.date_range),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: () {
                FilePickerService.pickFile(
                  controller.fileBytes,
                  controller.fileType,
                  controller.fileName,
                ).then(
                  (value) => controller.fileNameWhenSelectFile.text =
                      controller.fileName.value,
                );
              },
              label: const Text(
                'Attachment',
                style: TextStyle(color: Colors.blueGrey),
              ),
              icon: attachIcon,
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                controller: controller.fileNameWhenSelectFile,
              ),
            ),
          ],
        ),
        myTextFormFieldWithBorder(
          labelText: 'Notes',
          controller: controller.note,
          maxLines: 4,
        ),
      ],
    ),
  );
}
