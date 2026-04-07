import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/Widgets controllers/attachment_controller.dart';
import '../../Models/attachments/selected_attachments_model.dart';
import '../../web_functions.dart';
import '../main screen widgets/auto_size_box.dart';
import '../menu_dialog.dart';
import '../my_text_field.dart';

Widget addNewAttachment({
  required AttachmentController controller,
  required bool canEdit,
  required BuildContext context,
}) {
  return IntrinsicHeight(
    child: Form(
      key: controller.formKey,
      child: Row(
        spacing: 10,
        children: [
          Expanded(
            child: ScrollConfiguration(
              behavior: const MaterialScrollBehavior().copyWith(
                scrollbars: false,
              ),
              child: Scrollbar(
                controller: controller.scrollController,
                thumbVisibility: true,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: SingleChildScrollView(
                    controller: controller.scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        myTextFormFieldWithBorder(
                          obscureText: false,
                          controller: controller.name,
                          labelText: 'Name',
                          validate: true,
                        ),
                        Row(
                          spacing: 10,
                          children: [
                            Expanded(
                              child: MenuWithValues(
                                validate: true,
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
                                    selectDateContext(
                                      context,
                                      controller.startDate,
                                    );
                                  },
                                  icon: const Icon(Icons.date_range),
                                ),
                                validate: false,
                              ),
                            ),
                            Expanded(
                              child: myTextFormFieldWithBorder(
                                controller: controller.endDate,
                                labelText: 'End Date',
                                onFieldSubmitted: (_) async {
                                  normalizeDate(
                                    controller.endDate.text,
                                    controller.endDate,
                                  );
                                },
                                onTapOutside: (_) {
                                  normalizeDate(
                                    controller.endDate.text,
                                    controller.endDate,
                                  );
                                },
                                suffixIcon: IconButton(
                                  focusNode: FocusNode(skipTraversal: true),
                                  onPressed: () async {
                                    selectDateContext(
                                      context,
                                      controller.endDate,
                                    );
                                  },
                                  icon: const Icon(Icons.date_range),
                                ),
                                validate: false,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        myTextFormFieldWithBorder(
                          labelText: 'Notes',
                          controller: controller.note,
                          maxLines: 8,
                          validate: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              spacing: 1,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Attachments', style: textFieldLabelStyle),
                    InkWell(
                      onTap: () {
                        FilePickerService.pickFile(
                          controller.fileBytes,
                          controller.fileType,
                          controller.fileName,
                        ).then(
                          (value) => controller.selectedAttachments.add(
                            SelectedAttachmentsModel(
                              fileBytes: controller.fileBytes.value,
                              fileName: controller.fileName.value,
                              fileType: controller.fileType.value,
                            ),
                          ),
                        );
                      },
                      child: const Row(
                        spacing: 5,
                        children: [
                          Icon(
                            Icons.attach_file_outlined,
                            size: 17,
                            color: Colors.blueGrey,
                          ),
                          Text(
                            'Add New',
                            style: TextStyle(color: Colors.blueGrey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: BoxBorder.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                      // color: Colors.white,
                    ),
                    child: GetX<AttachmentController>(
                      builder: (controller) {
                        return ListView.builder(
                          // padding: const EdgeInsets.all(5),
                          shrinkWrap: true,
                          itemCount: controller.selectedAttachments.length,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(
                                5,
                                5,
                                5,
                                i == controller.selectedAttachments.length - 1
                                    ? 5
                                    : 0,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Row(
                                  spacing: 10,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        controller.selectedAttachments.removeAt(
                                          i,
                                        );
                                      },
                                      child: const Icon(
                                        Icons.remove_circle_outline_sharp,
                                        color: Colors.red,
                                      ),
                                    ),
                                    returnFileLogo(
                                      width: 30,
                                      fileName:
                                          controller
                                              .selectedAttachments[i]
                                              .fileName ??
                                          '',
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        spacing: 2,
                                        children: [
                                          AutoSizedText(
                                            text:
                                                controller
                                                    .selectedAttachments[i]
                                                    .fileName ??
                                                '',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                            constraints: const BoxConstraints(),
                                          ),
                                          AutoSizedText(
                                            text:
                                                controller
                                                    .selectedAttachments[i]
                                                    .fileType ??
                                                '',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                            ),
                                            constraints: const BoxConstraints(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
