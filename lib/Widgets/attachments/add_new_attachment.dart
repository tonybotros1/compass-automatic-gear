import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/Widgets controllers/attachment_controller.dart';
import '../../web_functions.dart';
import '../my_text_field.dart';

Widget addNewAttachment({
  required AttachmentController controller,
  required bool canEdit,
}) {
  return ListView(
    children: [
      const SizedBox(height: 5),
      myTextFormFieldWithBorder(
        obscureText: false,
        controller: controller.name,
        labelText: 'Name',
        validate: true,
      ),
      const SizedBox(height: 10),

      IconButton(
        onPressed: () {
          FilePickerService.pickFile(
            controller.fileBytes,
            controller.fileType,
            controller.fileName,
          );
        },
        icon: attachIcon,
      ),
      GetX<AttachmentController>(
        builder: (controller) {
          return Text(controller.fileName.value);
        },
      ),
    ],
  );
}
