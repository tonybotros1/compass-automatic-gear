import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../Controllers/Main screen controllers/job_card_controller.dart';

Future internalNotesDialog(BuildContext context, JobCardController controller,
    BoxConstraints constraints) {
  return Get.dialog(
    Dialog(
        child: Container(
      height: constraints.maxHeight,
      width: 600,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )),
            width: double.infinity,
            height: 70,
            child: Row(
              spacing: 20,
              children: [
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.message_outlined,
                  color: Colors.white,
                  size: 25,
                  weight: 2,
                ),
                Text(
                  'Internal Notes',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: GetX<JobCardController>(
                builder: (controller) {
                  if (controller.internalNotes.isEmpty) {
                    return const Center(
                        child: Text('Empty',
                            style: TextStyle(color: Colors.grey)));
                  }

                  // Auto-scroll to bottom
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (controller.scrollControllerForNotes.hasClients) {
                      controller.scrollControllerForNotes.jumpTo(controller
                          .scrollControllerForNotes.position.maxScrollExtent);
                    }
                  });

                  final combinedItems =
                      controller.buildCombinedItems(controller.sortedNotes);

                  return ListView.builder(
                    controller: controller.scrollControllerForNotes,
                    itemCount: combinedItems.length,
                    itemBuilder: (context, index) {
                      final item = combinedItems[index];

                      if (item is DateTime) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                DateFormat.yMMMd().format(item),
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      final note = item as Map<String, dynamic>;
                      bool isUserNote =
                          controller.userId.value == note['user_id'];

                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.grey[350],
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      textAlign: TextAlign.start,
                                      '${controller.getUserNameByUserId(note['user_id'])}',
                                      style: TextStyle(
                                          color: isUserNote
                                              ? Colors.deepOrangeAccent
                                              : Colors.green),
                                    ),
                                    Text(
                                      textAlign: TextAlign.end,
                                      DateFormat.jm().format(note['time']),
                                      style: TextStyle(
                                        color: mainColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                child: note['type'] == 'Text'
                                    ? Text(
                                        textAlign: TextAlign.start,
                                        note['note'],
                                        style: TextStyle(
                                          color: Colors.grey[800],
                                        ),
                                      )
                                    : note['type'] == 'Image'
                                        ? Image.memory(
                                            note['note'],
                                            fit: BoxFit.contain,
                                            height: 200,
                                          )
                                        : Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              spacing: 10,
                                              children: [
                                                Text('PDF'),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  spacing: 20,
                                                  children: [
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          FilePickerService
                                                              .openPdf(
                                                                 note['note'],
                                                                note['file_type']);
                                                        },
                                                        child: Text('Open')),
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          FilePickerService
                                                              .saveFile(
                                                                 note['note'],
                                                                note['file_type'],
                                                                  '');
                                                        },
                                                        child:
                                                            Text('Save as...')),
                                                  ],
                                                ),
                                              ],
                                            ),
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
          Container(
              constraints: BoxConstraints(minHeight: 70, maxHeight: 140),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )),
              child: GetX<JobCardController>(builder: (controller) {
                return Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 10, 0, 16),
                      child: InkWell(
                          onTap: () {
                            FilePickerService.pickFile(
                                controller.fileBytes, controller.fileType);
                          },
                          child: Icon(
                            Icons.attach_file_rounded,
                            color: Colors.grey,
                          )),
                    ),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 10, 16, 16),
                          child: controller.fileBytes.value != null
                              ? controller.fileType.value.startsWith('image/')
                                  ? Image.memory(controller.fileBytes.value!,
                                      height: 200)
                                  : controller.fileType.value
                                          .startsWith('application/pdf')
                                      ? Text("PDF Selected: Cannot preview",
                                          style: TextStyle(fontSize: 16))
                                      : SizedBox()
                              : KeyboardListener(
                                  autofocus: true,
                                  focusNode: FocusNode(),
                                  onKeyEvent: (KeyEvent event) {
                                    if (event is KeyDownEvent) {
                                      bool shiftPressed = HardwareKeyboard
                                              .instance.logicalKeysPressed
                                              .contains(LogicalKeyboardKey
                                                  .shiftLeft) ||
                                          HardwareKeyboard
                                              .instance.logicalKeysPressed
                                              .contains(LogicalKeyboardKey
                                                  .shiftRight);

                                      if (event.logicalKey ==
                                              LogicalKeyboardKey.enter &&
                                          shiftPressed) {
                                        controller.internalNote.value.text +=
                                            '\n';
                                        controller
                                                .internalNote.value.selection =
                                            TextSelection.fromPosition(
                                                TextPosition(
                                                    offset: controller
                                                        .internalNote
                                                        .value
                                                        .text
                                                        .length));
                                      } else if (event.logicalKey ==
                                          LogicalKeyboardKey.enter) {
                                        if (controller.noteMessage.value
                                            .trim()
                                            .isNotEmpty) {
                                          controller.addNewNote();
                                          controller.internalNote.value.clear();
                                          controller.noteMessage.value = '';
                                          Future.delayed(
                                              Duration(milliseconds: 100), () {
                                            controller.textFieldFocusNode
                                                .requestFocus();
                                          });
                                        }
                                      }
                                    }
                                  },
                                  child: TextFormField(
                                    textInputAction: TextInputAction.none,
                                    onFieldSubmitted: (value) {
                                      Future.delayed(
                                          Duration(milliseconds: 100), () {
                                        controller.textFieldFocusNode
                                            .requestFocus();
                                      });
                                    },
                                    focusNode: controller.textFieldFocusNode,
                                    controller: controller.internalNote.value,
                                    minLines: 1,
                                    maxLines: null,
                                    // keyboardType: TextInputType.multiline,
                                    onChanged: (value) {
                                      controller.noteMessage.value = value;
                                    },
                                    decoration: InputDecoration(
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
                                      hintText: 'Type here...',
                                      labelStyle: TextStyle(
                                          color: Colors.grey.shade700),
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                  ),
                                )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: IconButton(
                          onPressed: controller.noteMessage.value != ''
                              ? () {
                                  controller.internalNote.value.clear();
                                  controller.addNewNote();
                                  controller.noteMessage.value = '';
                                  Future.delayed(Duration(milliseconds: 100),
                                      () {
                                    controller.textFieldFocusNode
                                        .requestFocus();
                                  });
                                }
                              : () async {
                                  if (controller.fileBytes.value != null) {
                                    await controller.addNewMediaNote(
                                        type: controller.fileType.value
                                                .startsWith("image/")
                                            ? 'Image'
                                            : 'PDF');
                                    controller.fileBytes.value = null;
                                    controller.fileType.value = '';
                                  }
                                  Future.delayed(Duration(milliseconds: 100),
                                      () {
                                    controller.textFieldFocusNode
                                        .requestFocus();
                                  });
                                },
                          icon: Icon(
                            Icons.send_rounded,
                            color: mainColor,
                          )),
                    )
                  ],
                );
              }))
        ],
      ),
    )),
  );
}
