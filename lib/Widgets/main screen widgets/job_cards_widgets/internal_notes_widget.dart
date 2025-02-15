import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../Controllers/Main screen controllers/job_card_controller.dart';

Future internalNotesDialog(
    JobCardController controller, BoxConstraints constraints, String jobId) {
  return Get.dialog(
    barrierDismissible: false,
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
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Icon(
                    Icons.message_outlined,
                    color: Colors.white,
                    size: 25,
                    weight: 2,
                  ),
                ),
                Text(
                  'Internal Notes',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.red,
                      )),
                )
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: controller.getJobCardInternalNotes(jobId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        "Empty",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  // Scroll to the bottom once the frame is built.
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (controller.scrollControllerForNotes.hasClients) {
                      controller.scrollControllerForNotes.animateTo(
                        controller
                            .scrollControllerForNotes.position.maxScrollExtent,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  });

                  var items = snapshot.data!;

                  // Filter only valid image URLs from the notes.
                  List<String> listOfImages = [
                    for (int i = 0; i < items.length; i++)
                      if (items[i]['type'].startsWith('image'))
                        items[i]['note'].toString()
                  ];

                  return ListView.builder(
                    controller: controller.scrollControllerForNotes,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var note = items[index];
                      bool isUserNote =
                          controller.userId.value == note['user_id'];

                      DateTime noteTime;
                      if (note['time'] is Timestamp) {
                        noteTime = (note['time'] as Timestamp).toDate();
                      } else if (note['time'] is DateTime) {
                        noteTime = note['time'] as DateTime;
                      } else {
                        noteTime = DateTime.now();
                      }

                      bool showHeader = false;
                      if (index == 0) {
                        showHeader = true;
                      } else {
                        var previousNote = items[index - 1];
                        DateTime previousNoteTime;
                        if (previousNote['time'] is Timestamp) {
                          previousNoteTime =
                              (previousNote['time'] as Timestamp).toDate();
                        } else if (previousNote['time'] is DateTime) {
                          previousNoteTime = previousNote['time'] as DateTime;
                        } else {
                          previousNoteTime = DateTime.now();
                        }
                        if (noteTime.year != previousNoteTime.year ||
                            noteTime.month != previousNoteTime.month ||
                            noteTime.day != previousNoteTime.day) {
                          showHeader = true;
                        }
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showHeader)
                            Padding(
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
                                    DateFormat.yMMMd().format(noteTime),
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Align(
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
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          textAlign: TextAlign.start,
                                          '${controller.getdataName(note['user_id'], controller.allUsers, title: 'user_name')}',
                                          style: TextStyle(
                                            color: isUserNote
                                                ? Colors.deepOrangeAccent
                                                : Colors.green,
                                          ),
                                        ),
                                        Text(
                                          textAlign: TextAlign.end,
                                          DateFormat.jm().format(noteTime),
                                          style: TextStyle(
                                            color: mainColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                    child: note['type'] == 'Text'
                                        ? Text(
                                            textAlign: TextAlign.start,
                                            note['note'],
                                            style: TextStyle(
                                              color: Colors.grey[800],
                                            ),
                                          )
                                        : note['type']
                                                .toString()
                                                .startsWith("image")
                                            ? InkWell(
                                                onTap: () {
                                                  // Calculate the tapped image index within the filtered list.
                                                  final tappedIndex =
                                                      listOfImages.indexWhere(
                                                    (url) =>
                                                        url == note['note'],
                                                  );
                                                  controller.openImageViewer(
                                                      listOfImages,
                                                      tappedIndex);
                                                },
                                                child: Image.network(
                                                  note['note'],
                                                  fit: BoxFit.contain,
                                                  height: 200,
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  FilePickerService.openFile(
                                                    note['note'],
                                                  );
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Image.asset(
                                                        'assets/file.png',
                                                        width: 50,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        note['file_name'] ??
                                                            'No Name',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[800],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
                            FilePickerService.pickFile(controller.fileBytes,
                                controller.fileType, controller.fileName);
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
                                  ? Row(
                                      spacing: 20,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              controller.fileBytes.value = null;
                                            },
                                            icon: Icon(Icons.clear)),
                                        Image.memory(
                                            controller.fileBytes.value!,
                                            height: 200),
                                      ],
                                    )
                                  : controller.fileType.value
                                          .startsWith('application/pdf')
                                      ? Row(
                                          spacing: 20,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  controller.fileBytes.value =
                                                      null;
                                                },
                                                icon: Icon(Icons.clear)),
                                            Text("PDF Selected: Cannot preview",
                                                style: TextStyle(fontSize: 16)),
                                          ],
                                        )
                                      : Row(
                                          spacing: 20,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  controller.fileBytes.value =
                                                      null;
                                                },
                                                icon: Icon(Icons.clear)),
                                            Text(
                                                'File selected:  Cannot preview'),
                                          ],
                                        )
                              : TextFormField(
                                  textInputAction: TextInputAction.newline,
                                  onFieldSubmitted: (value) {
                                    Future.delayed(Duration(milliseconds: 100),
                                        () {
                                      controller.textFieldFocusNode
                                          .requestFocus();
                                    });
                                  },
                                  focusNode: controller.textFieldFocusNode,
                                  controller: controller.internalNote.value,
                                  minLines: 1,
                                  maxLines: null,
                                  onChanged: (value) {
                                    controller.noteMessage.value = value;
                                  },
                                  decoration: InputDecoration(
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
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
                      child: GetX<JobCardController>(builder: (controller) {
                        return controller.addingNewInternalNotProcess.isFalse
                            ? IconButton(
                                onPressed: () async {
                                  if (controller.noteMessage.value
                                      .trim()
                                      .isNotEmpty) {
                                    controller.internalNote.value.clear();
                                    await controller.addNewInternalNote(jobId, {
                                      'type': 'Text',
                                      'note':
                                          controller.noteMessage.value.trim(),
                                      'user_id': controller.userId.value,
                                      'time': DateTime.now(),
                                    });
                                    controller.noteMessage.value = '';
                                  } else if (controller.fileBytes.value !=
                                      null) {
                                    await controller.addNewInternalNote(jobId, {
                                      'file_name': controller.fileName.value,
                                      'type': controller.fileType.value,
                                      'note': controller.fileBytes.value,
                                      'user_id': controller.userId.value,
                                      'time': DateTime.now(),
                                    });
                                    controller.fileBytes.value = null;
                                    controller.fileType.value = '';
                                    controller.fileName.value = '';
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
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: mainColor,
                                  ),
                                ),
                              );
                      }),
                    )
                  ],
                );
              }))
        ],
      ),
    )),
  );
}
