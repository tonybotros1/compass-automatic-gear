import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
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
                        alignment: isUserNote
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 12),
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 280),
                            decoration: BoxDecoration(
                              color: isUserNote ? mainColor : secColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  controller
                                      .getUserNameByUserId(note['user_id']),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: isUserNote
                                          ? Colors.yellow
                                          : Colors.deepOrange),
                                ),
                                Text(
                                  note['note'],
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  DateFormat.jm().format(note['time']),
                                  style: TextStyle(
                                    color: Colors.grey[300],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
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
              height: 70,
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
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                          child: TextFormField(
                            onFieldSubmitted: controller.noteMessage.value != ''
                                ? (value) {
                                    if (value.trim().isNotEmpty) {
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
                                : (value) {
                                    Future.delayed(Duration(milliseconds: 100),
                                        () {
                                      controller.textFieldFocusNode
                                          .requestFocus();
                                    });
                                  },
                            focusNode: controller.textFieldFocusNode,
                            onChanged: (value) {
                              controller.noteMessage.value = value;
                            },
                            controller: controller.internalNote.value,
                            decoration: InputDecoration(
                              hintStyle: const TextStyle(color: Colors.grey),
                              hintText: 'Type here...',
                              labelStyle:
                                  TextStyle(color: Colors.grey.shade700),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
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
                              : () {
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
