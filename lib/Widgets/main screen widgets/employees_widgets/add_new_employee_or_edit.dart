import 'package:datahubai/Controllers/Main%20screen%20controllers/employees_controller.dart';
import 'package:flutter/material.dart';
import '../../../consts.dart';
import 'emails/email_section.dart';
import 'phone/phone_Section.dart';
import 'address/address_section.dart';
import 'job_information_section.dart';
import 'nationality/nationality_section.dart';
import 'personal_information_section.dart';

Widget addNewEmployeeOrEdit({
  required EmployeesController controller,
  required bool canEdit,
  required BoxConstraints constraints,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth - 16),
            child: IntrinsicWidth(
              child: Column(
                spacing: 20,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 20,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            labelContainer(
                              lable: Text(
                                'Personal Information',
                                style: fontStyle1,
                              ),
                            ),
                            personalInformation(context, controller, canEdit),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 600,
                          child: DefaultTabController(
                            length: controller.contactsTabs.length,
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: secColor,
                                    border: BoxBorder.fromLTRB(
                                      left: const BorderSide(
                                        color: Colors.grey,
                                      ),
                                      right: const BorderSide(
                                        color: Colors.grey,
                                      ),
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
                                    splashBorderRadius: BorderRadius.circular(
                                      5,
                                    ),
                                    dividerColor: Colors.transparent,

                                    tabs: controller.contactsTabs,
                                  ),
                                ),

                                SizedBox(
                                  height: 245,
                                  child: TabBarView(
                                    children: [
                                      // TAB 1
                                      addressSectionFotEmployees(
                                        canEdit: canEdit,
                                        constraints: constraints,
                                      ),
                                      nationalitySectionFotEmployees(
                                        canEdit: canEdit,
                                        constraints: constraints,
                                        context: context,
                                      ),
                                      phoneSectionFotEmployees(
                                        canEdit: canEdit,
                                        constraints: constraints,
                                      ),
                                      emailSectionFotEmployees(
                                        canEdit: canEdit,
                                        constraints: constraints,
                                      ),
                                      const Text('4'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Column(
                        //   children: [
                        //     labelContainer(
                        //       lable: Text(
                        //         'Contact Information',
                        //         style: fontStyle1,
                        //       ),
                        //     ),
                        //     contactInformation(context, controller),
                        //   ],
                        // ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      labelContainer(
                        lable: Text('Job Information', style: fontStyle1),
                      ),
                      jobInformation(context, controller),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
