import 'package:datahubai/Controllers/Mobile%20section%20controllers/cards_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/Mobile widgets/inspection report widgets/inspection_report_body.dart';
import '../../consts.dart';

class InspectionReposrt extends StatelessWidget {
  const InspectionReposrt({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: FittedBox(
          child: GetBuilder<CardsScreenController>(builder: (controller) {
            return TextButton(
                onPressed: () {
                  controller.clearAllValues();
                },
                child: const Text(
                  'Clear',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ));
          }),
        ),
        title: const Text(
          'Inspection Report',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: mainColor,
        actions: [
          GetBuilder<CardsScreenController>(builder: (controller) {
            return IconButton(
                onPressed: () {
                  controller.addInspectionCard(context);
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
