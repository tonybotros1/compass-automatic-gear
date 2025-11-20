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
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          'Edit Details',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: mainColor,
        actions: [
          GetBuilder<CardsScreenController>(
            builder: (controller) {
              return IconButton(
                onPressed: () {
                  if (controller.formKey.currentState!.validate()) {
                    // All required fields are valid
                    controller.updateInspectionCard();
                  } else {
                    // Show errors
                  }
                },
                icon: const Icon(Icons.done, color: Colors.white),
              );
            },
          ),
        ],
      ),
      body: buildInspectionReportBody(context),
    );
  }
}
