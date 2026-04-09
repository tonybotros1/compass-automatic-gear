import 'package:datahubai/Controllers/Main%20screen%20controllers/employees_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import 'emails/email_section.dart';
import 'payroll_elements/payroll_elements_section.dart';
import 'phone/phone_Section.dart';
import 'address/address_section.dart';
import 'assignment_information_section.dart';
import 'nationality/nationality_section.dart';
import 'personal_information_section.dart';

Widget addNewEmployeeOrEdit({
  required EmployeesController controller,
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
                              lable: Row(
                                spacing: 10,
                                children: [
                                  Text(
                                    'Personal Information',
                                    style: fontStyle1,
                                  ),
                                  const Spacer(),
                                  GetX<EmployeesController>(
                                    builder: (controller) {
                                      if (controller
                                          .personType
                                          .value
                                          .isNotEmpty) {
                                        return statusBox(
                                          controller.personType.value,
                                          hieght: 35,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 5,
                                          ),
                                        );
                                      }
                                      return const SizedBox();
                                    },
                                  ),
                                  GetX<EmployeesController>(
                                    builder: (controller) {
                                      if (controller
                                          .employeeStatus
                                          .value
                                          .isNotEmpty) {
                                        return statusBox(
                                          controller.employeeStatus.value,
                                          hieght: 35,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 5,
                                          ),
                                        );
                                      }
                                      return const SizedBox();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            personalInformation(context, controller),
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
                                        constraints: constraints,
                                      ),
                                      nationalitySectionFotEmployees(
                                        constraints: constraints,
                                        context: context,
                                      ),
                                      phoneSectionFotEmployees(constraints),
                                      emailSectionFotEmployees(
                                        constraints: constraints,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 20,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            labelContainer(
                              lable: Text(
                                'Assignment Information',
                                style: fontStyle1,
                              ),
                            ),
                            assignmentInformation(context, controller),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 600,
                          child: Column(
                            children: [
                              labelContainer(
                                lable: Text(
                                  'Payroll Elements',
                                  style: fontStyle1,
                                ),
                              ),
                              payrollElementsSection(constraints, context),
                            ],
                          ),
                        ),
                      ),
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
