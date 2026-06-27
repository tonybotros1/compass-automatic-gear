import 'package:datahubai/Controllers/Main%20screen%20controllers/employees_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import 'bank_accounts/bank_accounts_section.dart';
import 'emails/email_section.dart';
import 'health_card/health_card_section.dart';
import 'loan_and_advances/loan_and_advances_section.dart';
import 'payroll_elements/payroll_elements_section.dart';
import 'phone/phone_section.dart';
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
      final contentWidth = constraints.maxWidth - 16;
      const topSectionHeight = 295.0;
      const sectionSpacing = 20.0;
      const tabHeaderHeight = 50.0;
      const minimumEmploymentTabHeight = 410.0;
      final availableEmploymentTabHeight = constraints.hasBoundedHeight
          ? constraints.maxHeight -
                topSectionHeight -
                sectionSpacing -
                tabHeaderHeight
          : minimumEmploymentTabHeight;
      final employmentTabHeight =
          availableEmploymentTabHeight < minimumEmploymentTabHeight
          ? minimumEmploymentTabHeight
          : availableEmploymentTabHeight;

      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: contentWidth),
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
                                  GetBuilder<EmployeesController>(
                                    builder: (controller) {
                                      return statusBox(
                                        controller.getPersonType(
                                          controller.hireDate.text,
                                          controller.endDate.text,
                                        ),
                                        hieght: 35,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                      );
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
                                        context: context,
                                      ),
                                      bankAccountsSection(
                                        constraints: constraints,
                                        context: context,
                                      ),
                                      healthCardSection(
                                        constraints: constraints,
                                        context: context,
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
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: contentWidth,
                          child: DefaultTabController(
                            length: controller.assignmentsTabs.length,
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

                                    tabs: controller.assignmentsTabs,
                                  ),
                                ),

                                SizedBox(
                                  height: employmentTabHeight,
                                  child: TabBarView(
                                    children: [
                                      assignmentInformation(
                                        context,
                                        constraints,
                                        controller,
                                        height: employmentTabHeight,
                                      ),
                                      // balancesSection(constraints),
                                      payrollElementsSection(
                                        constraints,
                                        context,
                                        height: employmentTabHeight,
                                      ),
                                      loanAndAdvancesSection(
                                        constraints,
                                        context,
                                        height: employmentTabHeight,
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
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
