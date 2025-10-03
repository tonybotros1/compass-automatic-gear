import 'package:datahubai/Models/companies/company_model.dart';
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
                        onChanged: (_) {
                          controller.filterCompanies();
                        },
                        onPressedForClearSearch: () {
                          controller.search.value.clear();
                          controller.filterCompanies();
                        },
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        title: 'Search for companies',
                        button: newCompanyButton(
                          context,
                          constraints,
                          controller,
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<CompanyController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return Center(child: loadingProcess);
                        }
                        if (controller.allCompanies.isEmpty) {
                          return const Center(child: Text('No Element'));
                        }
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
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

Widget tableOfCompanies({
  required BoxConstraints constraints,
  required BuildContext context,
  required CompanyController controller,
}) {
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
        label: AutoSizedText(text: 'Company name', constraints: constraints),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Logo'),
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Location'),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Owner Name'),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Expiry Date'),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Phone number'),
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Creation date'),
        onSort: controller.onSort,
      ),
      const DataColumn(label: Text('')),
    ],
    rows:
        controller.filteredCompanies.isEmpty &&
            controller.search.value.text.isEmpty
        ? controller.allCompanies.map<DataRow>((company) {
            final companyId = company.id;
            return dataRowForTheTable(
              company,
              context,
              constraints,
              companyId,
              controller,
            );
          }).toList()
        : controller.filteredCompanies.map<DataRow>((company) {
            final companyId = company.id;
            return dataRowForTheTable(
              company,
              context,
              constraints,
              companyId,
              controller,
            );
          }).toList(),
  );
}

DataRow dataRowForTheTable(
  CompanyModel companyData,
  context,
  constraints,
  companyId,
  CompanyController controller,
) {
  return DataRow(
    cells: [
      DataCell(
        textForDataRowInTable(
          text: companyData.companyName ?? '',
          color: mainColor,
          isBold: true,
          formatDouble: false,
          maxWidth: null,
        ),
      ),
      DataCell(
        companyData.companyLogoUrl != null && companyData.companyLogoUrl != ''
            ? Image.network(
                cloudinaryThumbnail(
                  companyData.companyLogoUrl.toString(),
                  width: 30,
                ),
                width: 40,
                errorBuilder: (context, url, error) => const Icon(Icons.error),
              )
            : const Text('no logo'),
      ),
      DataCell(Text(companyData.userCountry ?? '')),
      DataCell(
        textForDataRowInTable(
          formatDouble: false,
          text: companyData.userName ?? '',
          color: secColor,
          isBold: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: textToDate(companyData.userExpiryDate),
          color: !isBeforeToday(textToDate(companyData.userExpiryDate))
              ? Colors.green
              : Colors.red,
          isBold: true,
          formatDouble: false,
        ),
      ),
      DataCell(Text(companyData.userPhoneNumber ?? 'no phone number')),
      DataCell(Text(textToDate(companyData.createdAt))),
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            activeInActiveSection(companyData, controller, companyId),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: editEction(
                context,
                controller,
                companyData,
                constraints,
                companyId,
              ),
            ),
            deleteSection(controller, companyData, context),
          ],
        ),
      ),
    ],
  );
}

ElevatedButton deleteSection(
  CompanyController controller,
  CompanyModel companyData,
  context,
) {
  return ElevatedButton(
    style: deleteButtonStyle,
    onPressed: () {
      alertDialog(
        context: context,
        content: "The Company and its users will be deleted permanently",
        onPressed: () {
          if (companyData.id != '' && companyData.userId != '') {
            controller.deleteCompany(
              companyData.id.toString(),
              companyData.userId.toString(),
            );
          } else {
            showSnackBar('Alert', 'can\'t proceed');
          }
        },
      );
    },
    child: const Text("Delete"),
  );
}

ElevatedButton activeInActiveSection(
  CompanyModel companyData,
  CompanyController controller,
  String companyId,
) {
  return ElevatedButton(
    style: companyData.status == false
        ? inActiveButtonStyle
        : activeButtonStyle,
    onPressed: () {
      bool status;
      if (companyData.status == false) {
        status = true;
      } else {
        status = false;
      }
      controller.changeCompanyStatus(companyId, status);
    },
    child: companyData.status == true
        ? const Text('Active')
        : const Text('Inactive'),
  );
}

ElevatedButton editEction(
  BuildContext context,
  CompanyController controller,
  CompanyModel companyData,
  constraints,
  companyID,
) {
  return ElevatedButton(
    style: editButtonStyle,
    onPressed: () async {
      if (companyData.userCountryId != '' &&
          companyData.userCountryId != null) {
        controller.getCitiesByCountryId(companyData.userCountryId ?? '');
      }
      controller.companyName.text = companyData.companyName ?? '';
      controller.industry.value.text = companyData.industry ?? '';
      controller.industryId.value = companyData.industryId ?? '';
      controller.userName.text = companyData.userName ?? '';

      controller.phoneNumber.text = companyData.userPhoneNumber ?? '';
      controller.email.text = companyData.userEmail ?? '';

      controller.address.text = companyData.userAddress ?? '';
      controller.country.text = companyData.userCountry ?? '';
      controller.selectedCountryId.value = companyData.userCountryId ?? '';
      controller.city.text = companyData.userCity ?? '';
      controller.selectedCityId.value = companyData.userCityId ?? '';
      controller.imageBytes = null;
      controller.roleIDFromList.assignAll(companyData.mainUserRoles ?? []);
      controller.logoUrl.value = companyData.companyLogoUrl ?? '';
      companyDialog(
        constraints: constraints,
        controller: controller,
        onPressed: controller.addingNewCompanyProcess.value
            ? null
            : () {
                controller.updateCompany(
                  companyID,
                  companyData.userId.toString(),
                );
              },
      );
    },
    child: const Text('Edit'),
  );
}

ElevatedButton newCompanyButton(
  BuildContext context,
  BoxConstraints constraints,
  CompanyController controller,
) {
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
        onPressed: controller.addingNewCompanyProcess.isTrue
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
              },
      );
    },
    style: newButtonStyle,
    child: const Text('New Company'),
  );
}
