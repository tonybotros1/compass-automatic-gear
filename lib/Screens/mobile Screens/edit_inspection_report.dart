import 'package:datahubai/Widgets/Mobile%20widgets/inspection%20report%20widgets/inspection_report_body.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/Mobile section controllers/cards_screen_controller.dart';
import '../../consts.dart';

class EditInspectionReport extends StatelessWidget {
  const EditInspectionReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: FittedBox(
          child: GetBuilder<CardsScreenController>(builder: (controller) {
            return IconButton(
                onPressed: () {
                  controller.inEditMode.value = false;
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ));
          }),
        ),
        title: const Text(
          'Edit Details',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: mainColor,
        actions: [
          GetBuilder<CardsScreenController>(builder: (controller) {
            return IconButton(
                onPressed: () {
                  controller.editInspectionCard(
                      context, controller.currenyJobId.value);
                },
                icon: const Icon(
                  Icons.done_outline_rounded,
                  color: Colors.white,
                ));
          })
        ],
      ),
      body: buildInspectionReportBody(context),
    );
  }
}
