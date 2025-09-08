import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/company_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/company_widgets/company_dialog.dart';
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
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        // controller: controller,
                        title: 'Search for companies',
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
    {required BoxConstraints constraints,
    required BuildContext context,
    required CompanyController controller}) {
  return DataTable(
    dataRowMaxHeight: 40,
    dataRowMinHeight: 30,
    columnSpacing: 5,
    horizontalMargin: horizontalMarginForTable,
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
      const DataColumn(label:  Text('')),
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
    constraints, companyId, CompanyController controller) {
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
      '${controller.getCountryName(companyData['contact_details']['country'])}',
    )),
    DataCell(Text(
      companyData['contact_details']['phone'] ?? 'no phone number',
    )),
    DataCell(
      Text(
        companyData['added_date'] != null
            ? textToDate(companyData['added_date']) //
            : 'N/A',
      ),
    ),
    DataCell(Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        activeInActiveSection(companyData, controller, companyId),
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: editEction(
              context, controller, companyData, constraints, companyId),
        ),
        deleteSection(controller, companyId, context),
      ],
    )),
  ]);
}

ElevatedButton deleteSection(CompanyController controller, companyId, context) {
  return ElevatedButton(
      style: deleteButtonStyle,
      onPressed: () {
        alertDialog(
            context: context,
            content: "The Company and its users will be deleted permanently",
            onPressed: () {
              controller.deletCompany(companyId);
            });
      },
      child: const Text("Delete"));
}

ElevatedButton activeInActiveSection(Map<String, dynamic> companyData,
    CompanyController controller, String companyId) {
  return ElevatedButton(
      style: companyData['status'] == false
          ? inActiveButtonStyle
          : activeButtonStyle,
      onPressed: () {
        bool status;
        if (companyData['status'] == false) {
          status = true;
        } else {
          status = false;
        }
        controller.editActiveOrInActiveStatus(companyId, status);
      },
      child: companyData['status'] == true
          ? const Text('Active')
          : const Text('Inactive'));
}

ElevatedButton editEction(BuildContext context, CompanyController controller,
    Map<String, dynamic> companyData, constraints, companyID) {
  return ElevatedButton(
      style: editButtonStyle,
      onPressed: () async {
        controller
            .getCitiesByCountryID(companyData['contact_details']['country']);
        controller.companyName.text = companyData['company_name'] ?? '';
        controller.industry.value.text =
            controller.getIndustryName(companyData['industry']) ?? '';
        controller.industryId.value = companyData['industry'] ?? '';
        controller.userName.text =
            controller.userDetails[companyData['contact_details']['user_id']]
                    ['user_name'] ??
                '';
        controller.phoneNumber.text =
            companyData['contact_details']['phone'] ?? '';
        controller.email.text =
            controller.userDetails[companyData['contact_details']['user_id']]
                    ['email'] ??
                '';
        controller.address.text =
            companyData['contact_details']['address'] ?? '';
        controller.country.text = controller
            .getCountryName(companyData['contact_details']['country'])!;
        controller.city.text = await controller.getCityName(
                companyData['contact_details']['country'],
                companyData['contact_details']['city']) ??
            '';
        controller.imageBytes = null;
        controller.roleIDFromList.assignAll(controller
            .userDetails[companyData['contact_details']['user_id']]['roles']);
        controller.logoUrl.value = companyData['company_logo'] ?? '';
        controller.selectedCountryId.value =
            companyData['contact_details']['country'] ?? '';
        controller.selectedCityId.value =
            companyData['contact_details']['city'] ?? '';
        companyDialog(
            constraints: constraints,
            controller: controller,
            onPressed: controller.addingNewCompanyProcess.value
                ? null
                : () {
                    controller.updateCompany(
                        companyID, companyData['contact_details']['user_id']);
                  });
      },
      child: const Text('Edit'));
}

ElevatedButton newCompanyButton(BuildContext context,
    BoxConstraints constraints, CompanyController controller) {
  return ElevatedButton(
    onPressed: () {
      controller.allCities.clear();
      controller.companyName.clear();
      controller.industry.value.clear();
      controller.industryId.value = '';
      controller.userName.clear();
      controller.password.clear();
      controller.phoneNumber.clear();
      controller.email.clear();
      controller.address.clear();
      controller.country.clear();
      controller.city.clear();
      controller.roleIDFromList.clear();
      controller.logoUrl.value = '';
      controller.imageBytes = null;
      companyDialog(
          constraints: constraints,
          controller: controller,
          onPressed: controller.addingNewCompanyProcess.value
              ? null
              : () async {
                  if (controller.userName.text.isNotEmpty &&
                      controller.companyName.text.isNotEmpty &&
                      controller.industry.value.text.isNotEmpty &&
                      controller.password.text.isNotEmpty &&
                      controller.phoneNumber.text.isNotEmpty &&
                      controller.email.text.isNotEmpty &&
                      controller.address.text.isNotEmpty &&
                      controller.country.text.isNotEmpty &&
                      controller.city.text.isNotEmpty &&
                      controller.imageBytes!.isNotEmpty &&
                      controller.roleIDFromList.isNotEmpty) {
                    controller.addNewCompany();
                  } else {
                    showSnackBar('Note', 'Please fill all fields');
                  }
                });
    },
    style: newButtonStyle,
    child: const Text('New Company'),
  );
}
