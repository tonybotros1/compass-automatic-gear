import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/data_migration_controller.dart';
import '../../../../web_functions.dart';

class DataMigration extends StatelessWidget {
  const DataMigration({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            GetBuilder<DataMigrationController>(
              init: DataMigrationController(),
              builder: (controller) {
                return CustomDropdown(
                  width: 300,
                  hintText: 'Screen',
                  textcontroller: controller.screenName.value,
                  items: controller.screens,
                  showedSelectedName: 'name',
                  onChanged: (key, value) {
                    controller.screenName.value = value['name'];
                  },
                  onDelete: () {
                    controller.screenName.value = '';
                  },
                );
              },
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                spacing: 20,
                children: [
                  GetX<DataMigrationController>(
                    builder: (controller) {
                      return Row(
                        spacing: 10,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.centerLeft,
                            height: 35,
                            width: 400,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              controller.fileName.value,
                              style: coolTextStyle,
                            ),
                          ),
                          ElevatedButton(
                            style: findButtonStyle,
                            onPressed: () {
                              FilePickerService.pickFile(
                                controller.fileBytes,
                                controller.fileType,
                                controller.fileName,
                                isExcel: true,
                              );
                            },
                            child: const Text('UPLOAD FILE'),
                          ),
                        ],
                      );
                    },
                  ),
                  Row(
                    children: [
                      GetX<DataMigrationController>(
                        builder: (controller) {
                          return CupertinoCheckbox(
                            value: controller.deleteEveryThing.value,
                            onChanged: (val) {
                              controller.deleteEveryThing.value = val ?? false;
                            },
                          );
                        },
                      ),
                      Text('Delete old data', style: coolTextStyle),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GetX<DataMigrationController>(
                        builder: (controller) {
                          return ElevatedButton(
                            style: newButtonStyle,
                            onPressed: controller.uploadingFile.isFalse
                                ? () {
                                    if (controller.deleteEveryThing.value) {
                                      alertDialog(
                                        context: context,
                                        content:
                                            'Are you sure you want to delete every thing?',
                                        onPressed: () {
                                          if (controller
                                                  .screenName
                                                  .value
                                                  .isEmpty ||
                                              controller
                                                  .fileName
                                                  .value
                                                  .isEmpty) {
                                            Get.back();
                                            alertMessage(
                                              context: context,
                                              content:
                                                  'Select screen and file first',
                                            );
                                            return;
                                          }
                                          Get.back();
                                          controller.uploadFile();
                                        },
                                      );
                                    } else {
                                      if (controller.screenName.value.isEmpty ||
                                          controller.fileName.value.isEmpty) {
                                        alertMessage(
                                          context: context,
                                          content:
                                              'Select screen and file first',
                                        );
                                        return;
                                      }
                                      controller.uploadFile();
                                    }
                                  }
                                : null,
                            child: controller.uploadingFile.isFalse
                                ? const Text('EXECUTE')
                                : loadingIndecator(color: Colors.white),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
