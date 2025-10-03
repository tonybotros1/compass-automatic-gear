import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/company_controller.dart';
import '../../../consts.dart';
import 'add_new_company_and_view.dart';

Future<dynamic> companyDialog({
  required BoxConstraints constraints,
  required CompanyController controller,
  required void Function()? onPressed,
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: SizedBox(
        height: constraints.maxHeight,
        width: constraints.maxWidth / 1.5,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
                color: mainColor,
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                spacing: 10,
                children: [
                  Text(
                    controller.getScreenName(),
                    style: fontStyleForScreenNameUsedInButtons,
                  ),
                  const Spacer(),
                  GetX<CompanyController>(
                    builder: (controller) => ElevatedButton(
                      onPressed: onPressed,
                      style: new2ButtonStyle,
                      child: controller.addingNewCompanyProcess.value == false
                          ? const Text(
                              'Save',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          : const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                    ),
                  ),
                  closeButton,
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: addNewCompanyOrView(controller: controller),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
