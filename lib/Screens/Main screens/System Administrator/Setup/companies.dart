import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/company_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/add_new_company_and_view.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../consts.dart';

class Companies extends StatelessWidget {
  const Companies({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: screenPadding,
            child: Container(
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  GetX<CompanyController>(
                    init: CompanyController(),
                    builder: (controller) {
                      return searchBar(
                        constraints: constraints,
                        context: context,
                        controller: controller,
                        title: 'Search for companies',
                        buttonTitle: 'New Company',
                        button:
                            newCompanyButton(context, constraints, controller),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<CompanyController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (controller.allCompanies.isEmpty) {
                          return const Center(
                            child: Text('No Element'),
                          );
                        }
                        return SingleChildScrollView(
                          scrollDirection: Axis
                              .vertical, // Horizontal scrolling for the table
                          child: SizedBox(
                            width: constraints.maxWidth,
                            child: tableOfCompanies(
                              constraints: constraints,
                              context: context,
                              controller: controller,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget tableOfCompanies(
    {required constraints, required context, required controller}) {
  return DataTable(
    dataRowMaxHeight: 40,
    dataRowMinHeight: 30,
    columnSpacing: 5,
    showBottomBorder: true,
    dataTextStyle: regTextStyle,
    headingTextStyle: fontStyleForTableHeader,
    sortColumnIndex: controller.sortColumnIndex.value,
    sortAscending: controller.isAscending.value,
    headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
    columns: [
      DataColumn(
        label: AutoSizedText(
          text: 'Company name',
          constraints: constraints,
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Logo',
        ),
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Location',
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Phone number',
        ),
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Creation date',
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: AutoSizedText(
          constraints: constraints,
          text: 'Action',
        ),
      ),
    ],
    rows: controller.filteredCompanies.isEmpty &&
            controller.search.value.text.isEmpty
        ? controller.allCompanies.map<DataRow>((company) {
            final companyData = company.data() as Map<String, dynamic>;
            final companyId = company.id;
            return dataRowForTheTable(
                companyData, context, constraints, companyId, controller);
          }).toList()
        : controller.filteredCompanies.map<DataRow>((company) {
            final companyData = company.data() as Map<String, dynamic>;
            final companyId = company.id;
            return dataRowForTheTable(
                companyData, context, constraints, companyId, controller);
          }).toList(),
  );
}

DataRow dataRowForTheTable(Map<String, dynamic> companyData, context,
    constraints, companyId, controller) {
  return DataRow(cells: [
    DataCell(Text(
      companyData['company_name'] ?? 'no name',
    )),
    DataCell(
        companyData['company_logo'] != null && companyData['company_logo'] != ''
            ? Image.network(
                companyData['company_logo'],
                width: 40,
              )
            : const Text('no logo')),
    DataCell(Text(
      '${companyData['contact_details']['country']} | ${companyData['contact_details']['city']}',
    )),
    DataCell(Text(
      companyData['contact_details']['phone'] ?? 'no phone number',
    )),
    DataCell(
      Text(
        companyData['added_date'] != null
            ? controller.textToDate(companyData['added_date']) //
            : 'N/A',
      ),
    ),
    DataCell(Align(
      alignment: Alignment.center,
      child: ElevatedButton(
          style: viewButtonStyle,
          onPressed: () {
            // showDialog(
            //     context: context,
            //     builder: (context) {
            //       controller.screenName.text = screenData['name'];
            //       controller.route.text = screenData['routeName'];

            //       return AlertDialog(
            //         actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
            //         content: addNewScreenOrView(
            //           controller: controller,
            //           constraints: constraints,
            //           context: context,
            //           screenName: controller.screenName,
            //           route: controller.route,
            //         ),
            //         actions: [
            //           Padding(
            //             padding: const EdgeInsets.symmetric(vertical: 16),
            //             child: ElevatedButton(
            //               onPressed: controller.addingNewScreenProcess.value
            //                   ? null
            //                   : () {
            //                       controller.updateScreen(screenId);
            //                       if (controller.addingNewScreenProcess.value ==
            //                           false) {
            //                         Get.back();
            //                       }
            //                     },
            //               style: ElevatedButton.styleFrom(
            //                 backgroundColor: Colors.green,
            //                 shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(5),
            //                 ),
            //               ),
            //               child:
            //                   controller.addingNewScreenProcess.value == false
            //                       ? const Text(
            //                           'Save',
            //                           style: TextStyle(color: Colors.white),
            //                         )
            //                       : const Padding(
            //                           padding: EdgeInsets.all(8.0),
            //                           child: CircularProgressIndicator(
            //                             color: Colors.white,
            //                           ),
            //                         ),
            //             ),
            //           ),
            //           ElevatedButton(
            //             onPressed: () {
            //               Get.back();
            //             },
            //             style: ElevatedButton.styleFrom(
            //               backgroundColor: mainColor,
            //               shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(5),
            //               ),
            //             ),
            //             child: controller.addingNewScreenProcess.value == false
            //                 ? const Text(
            //                     'Cancel',
            //                     style: TextStyle(color: Colors.white),
            //                   )
            //                 : const Padding(
            //                     padding: EdgeInsets.all(8.0),
            //                     child: CircularProgressIndicator(
            //                       color: Colors.white,
            //                     ),
            //                   ),
            //           ),
            //         ],
            //       );
            //     });
          },
          child: const Text('View')),
    )),
  ]);
}

ElevatedButton newCompanyButton(
    BuildContext context, BoxConstraints constraints, controller) {
  return ElevatedButton(
    onPressed: () {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
              content: addNewCompanyOrView(
                controller: controller,
                constraints: constraints,
                context: context,
              ),
              actions: [
                GetX<CompanyController>(
                    builder: (controller) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: ElevatedButton(
                            onPressed: controller.addingNewCompanyProcess.value
                                ? null
                                : () async {
                                    // await controller.addNewScreen();
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: controller.addingNewCompanyProcess.value ==
                                    false
                                ? const Text(
                                    'Save',
                                    style: TextStyle(color: Colors.white),
                                  )
                                : const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        )),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: controller.addingNewCompanyProcess.value == false
                      ? const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        )
                      : const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            );
          });
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 5,
    ),
    child: const Text('New Company'),
  );
}
