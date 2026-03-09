import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../Controllers/Main screen controllers/to_do_list_controller.dart';
import '../../../Models/to do list/to_do_list_description_model.dart';
import '../../../web_functions.dart';

Widget detailsSection(
  ToDoListController controller,
  BoxConstraints constraints,
) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(15),
        bottomRight: Radius.circular(15),
        topLeft: Radius.circular(2),
        topRight: Radius.circular(2),
      ),
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            padding: const EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            height: 50,
            width: double.infinity,
            color: const Color(0xffE1E5EA),
            child: Text(
              'Details',
              style: GoogleFonts.robotoMono(
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: GetX<ToDoListController>(
              builder: (context) {
                if (controller.isDescriptionNotesLoading.isTrue) {
                  return Center(child: loadingProcess);
                }

                if (controller.allDescriptionNotes.isEmpty &&
                    controller.isDescriptionNotesLoading.isFalse) {
                  return const Center(
                    child: Text("Empty", style: TextStyle(color: Colors.grey)),
                  );
                }

                // Scroll to the bottom once the frame is built.
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (controller.scrollControllerForNotes.hasClients) {
                    controller.scrollControllerForNotes.animateTo(
                      controller
                          .scrollControllerForNotes
                          .position
                          .maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                });

                List<ToDoListDescriptionModel> items =
                    controller.allDescriptionNotes;

                // Filter only valid image URLs from the notes.
                List<String> listOfImages = [
                  for (int i = 0; i < items.length; i++)
                    if (items[i].type.toString().startsWith('image'))
                      items[i].description.toString(),
                ];

                return ListView.builder(
                  controller: controller.scrollControllerForNotes,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    ToDoListDescriptionModel note = items[index];
                    bool isUserNote = note.isThisUserTheCurrentUser ?? false;
                    DateTime noteTime = note.createdAt ?? DateTime.now();
                    bool showHeader = false;
                    if (index == 0) {
                      showHeader = true;
                    } else {
                      var previousNote = items[index - 1];
                      DateTime previousNoteTime =
                          previousNote.createdAt ?? DateTime.now();

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
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
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
                              vertical: 12,
                              horizontal: 12,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: coolColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        textAlign: TextAlign.start,
                                        note.userName ?? '',
                                        style: TextStyle(
                                          color: isUserNote
                                              ? Colors.deepOrangeAccent
                                              : Colors.green,
                                        ),
                                      ),
                                      Text(
                                        textAlign: TextAlign.end,
                                        DateFormat.jm().format(noteTime),
                                        style: TextStyle(color: mainColor),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    8,
                                    8,
                                    8,
                                    0,
                                  ),
                                  child:
                                      note.type.toString().toLowerCase() ==
                                          'text'
                                      ? Text(
                                          textAlign: TextAlign.start,
                                          note.description ?? '',
                                          style: TextStyle(
                                            color: Colors.grey[800],
                                          ),
                                        )
                                      : note.type.toString().startsWith("image")
                                      ? InkWell(
                                          onTap: () {
                                            // Calculate the tapped image index within the filtered list.
                                            final tappedIndex = listOfImages
                                                .indexWhere(
                                                  (url) => url == note.description,
                                                );
                                            openImageViewer(
                                              listOfImages,
                                              tappedIndex,
                                            );
                                          },
                                          child: Image.network(
                                            note.description ?? '',
                                            fit: BoxFit.contain,
                                            height: 200,
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            var openFile = FilePickerService();
                                            openFile.openFile(
                                              note.description ?? '',
                                              note.fileName ?? '',
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                // Using a Builder to compute the asset path dynamically
                                                child: Builder(
                                                  builder: (context) {
                                                    // Retrieve the file name; if null, use an empty string
                                                    String fileName =
                                                        note.fileName ?? "";
                                                    // Check if there's a dot in the filename to extract the extension
                                                    final extension =
                                                        fileName.contains('.')
                                                        ? fileName
                                                              .split('.')
                                                              .last
                                                              .toLowerCase()
                                                        : "";
                                                    // Determine asset path based on extension
                                                    String assetPath;
                                                    switch (extension) {
                                                      case 'pdf':
                                                        assetPath =
                                                            'assets/pdf.png';
                                                        break;
                                                      case 'doc':
                                                      case 'docx':
                                                        assetPath =
                                                            'assets/word.png';
                                                        break;
                                                      case 'xls':
                                                      case 'xlsx':
                                                        assetPath =
                                                            'assets/excel.png';
                                                        break;
                                                      case 'ppt':
                                                      case 'pptx':
                                                        assetPath =
                                                            'assets/powerpoint.png';
                                                        break;
                                                      // Add more cases as needed
                                                      default:
                                                        assetPath =
                                                            'assets/file.png';
                                                    }
                                                    return Image.asset(
                                                      assetPath,
                                                      width: 50,
                                                    );
                                                  },
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  note.fileName ?? 'No Name',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.grey[800],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.fromLTRB(
                                //     8,
                                //     8,
                                //     8,
                                //     0,
                                //   ),
                                //   child: Text(
                                //     textAlign: TextAlign.start,
                                //     note.description ?? '',
                                //     style: TextStyle(color: Colors.grey[800]),
                                //   ),
                                // ),
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
        const Divider(),
        Container(
          constraints: const BoxConstraints(minHeight: 70, maxHeight: 140),
          width: double.infinity,
          child: GetX<ToDoListController>(
            builder: (controller) {
              return Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 10, 0, 16),
                    child: InkWell(
                      onTap: controller.currentTaskId.value.isNotEmpty
                          ? () {
                              FilePickerService.pickFile(
                                controller.fileBytes,
                                controller.fileType,
                                controller.fileName,
                              );
                            }
                          : null,
                      child: const Icon(
                        Icons.attach_file_rounded,
                        color: Colors.grey,
                      ),
                    ),
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
                                        icon: const Icon(Icons.clear),
                                      ),
                                      Image.memory(
                                        controller.fileBytes.value!,
                                        height: 200,
                                      ),
                                    ],
                                  )
                                : controller.fileType.value.startsWith(
                                    'application/pdf',
                                  )
                                ? Row(
                                    spacing: 20,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          controller.fileBytes.value = null;
                                        },
                                        icon: const Icon(Icons.clear),
                                      ),
                                      const Text(
                                        "PDF Selected: Cannot preview",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  )
                                : Row(
                                    spacing: 20,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          controller.fileBytes.value = null;
                                        },
                                        icon: const Icon(Icons.clear),
                                      ),
                                      const Text(
                                        'File selected:  Cannot preview',
                                      ),
                                    ],
                                  )
                          : TextFormField(
                              textInputAction: TextInputAction.newline,
                              onFieldSubmitted: (value) {
                                Future.delayed(
                                  const Duration(milliseconds: 100),
                                  () {
                                    controller.textFieldFocusNode
                                        .requestFocus();
                                  },
                                );
                              },
                              focusNode: controller.textFieldFocusNode,
                              controller: controller.descriptionNote.value,
                              enabled:
                                  controller.currentTaskId.value.isNotEmpty,
                              minLines: 1,
                              maxLines: null,
                              onChanged: (value) {
                                controller.noteMessage.value = value;
                              },
                              decoration: InputDecoration(
                                hintStyle: const TextStyle(color: Colors.grey),
                                hintText: 'Type here...',
                                labelStyle: TextStyle(
                                  color: Colors.grey.shade700,
                                ),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                            ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GetX<ToDoListController>(
                      builder: (controller) {
                        return controller.addingNewDescriptionNotProcess.isFalse
                            ? IconButton(
                                onPressed: () async {
                                  if (controller.noteMessage.value
                                      .trim()
                                      .isNotEmpty) {
                                    controller.descriptionNote.value.clear();
                                    await controller.addNewTaskDescriptionNote(
                                      controller.currentTaskId.value,
                                      {
                                        'note_type': 'text',
                                        'note': controller.noteMessage.value
                                            .trim(),
                                      },
                                    );
                                    controller.noteMessage.value = '';
                                  } else if (controller.fileBytes.value !=
                                      null) {
                                    await controller.addNewTaskDescriptionNote(
                                      controller.currentTaskId.value,
                                      {
                                        'file_name': controller.fileName.value,
                                        'note_type': controller.fileType.value,
                                        'media_note':
                                            controller.fileBytes.value,
                                      },
                                    );
                                    controller.fileBytes.value = null;
                                    controller.fileType.value = '';
                                    controller.fileName.value = '';
                                  }
                                  Future.delayed(
                                    const Duration(milliseconds: 100),
                                    () {
                                      controller.textFieldFocusNode
                                          .requestFocus();
                                    },
                                  );
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
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    ),
  );
}
