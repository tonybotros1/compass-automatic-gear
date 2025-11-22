import 'package:datahubai/Controllers/Mobile%20section%20controllers/cards_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../../Widgets/Mobile widgets/inspection report widgets/inspection_report_body.dart';
import '../../consts.dart';

class InspectionReposrt extends StatelessWidget {
  const InspectionReposrt({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomBarController = Get.find<PersistentTabController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GetBuilder<CardsScreenController>(
          builder: (controller) {
            return IconButton(
              onPressed: () {
                bottomBarController.index = 0;
                controller.clearAllValues();
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            );
          },
        ),
        title: const Text(
          'Inspection Report',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: mainColor,
        actions: [
          GetBuilder<CardsScreenController>(
            builder: (controller) {
              return IconButton(
                onPressed: () {
                  if (controller.brand.text.isEmpty ||
                      controller.model.text.isEmpty ||
                      controller.plateNumber.text.isEmpty) {
                    showSnackBar(
                      'Alert',
                      'Make sure to fill brand, model and plate number',
                    );
                  } else {
                    controller.addInspectionCard();
                  }
                  // if (controller.formKey.currentState!.validate()) {
                  //   // All required fields are valid
                  //   controller.addInspectionCard();
                  // } else {
                  //   // Show errors
                  // }
                },
                icon: const Icon(Icons.done_rounded, color: Colors.white),
              );
            },
          ),
        ],
      ),
      body: buildInspectionReportBody(context),
    );
  }
}
