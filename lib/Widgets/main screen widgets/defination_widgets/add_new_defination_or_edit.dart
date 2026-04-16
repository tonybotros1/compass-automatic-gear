import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/payroll_elements_controller.dart';
import '../../../consts.dart';
import 'based_elements_sections.dart';
import 'element_details_section.dart';

Widget addNewDefinationOrEdit({
  required PayrollElementsController controller,
  required BoxConstraints constraints,
  required BuildContext context,
}) {
  return Column(
    children: [
      labelContainer(lable: Text('Element Details', style: fontStyle1)),
      elementDetails(context, controller),
      const SizedBox(height: 10),
      Expanded(
        child: DefaultTabController(
          length: controller.contactsTabs.length,
          child: Column(
            children: [
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: secColor,
                  border: BoxBorder.fromLTRB(
                    left: const BorderSide(color: Colors.grey),
                    right: const BorderSide(color: Colors.grey),
                    top: const BorderSide(color: Colors.grey),
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
                child: TabBar(
                  unselectedLabelColor: Colors.white,
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  indicatorColor: Colors.yellow,
                  labelColor: Colors.yellow,
                  splashBorderRadius: BorderRadius.circular(5),
                  dividerColor: Colors.transparent,
        
                  tabs: controller.contactsTabs,
                ),
              ),
        
              Expanded(
                child: TabBarView(
                  children: [basedElementsSection(constraints)],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
