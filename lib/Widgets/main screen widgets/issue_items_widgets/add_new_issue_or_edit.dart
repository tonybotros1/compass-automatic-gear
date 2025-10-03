import 'package:datahubai/Controllers/Main%20screen%20controllers/issue_items_controller.dart';
import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:datahubai/Widgets/main%20screen%20widgets/auto_size_box.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import 'details_table.dart';

Widget addNewIssueOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required IssueItemsController controller,
  bool? canEdit,
  required String id,
}) {
  return SingleChildScrollView(
    child: FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth - 16),
              child: IntrinsicWidth(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    labelContainer(
                      lable: Text('Main Infos', style: fontStyle1),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: containerDecor,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  spacing: 10,
                                  children: [
                                    myTextFormFieldWithBorder(
                                      isEnabled: false,
                                      width: 150,
                                      labelText: 'Number',
                                    ),
                                    FocusTraversalOrder(
                                      order: const NumericFocusOrder(1),

                                      child: myTextFormFieldWithBorder(
                                        controller: controller.date.value,
                                        suffixIcon: IconButton(
                                          focusNode: FocusNode(
                                            skipTraversal: true,
                                          ),
                                          onPressed: () {
                                            selectDateContext(
                                              context,
                                              controller.date.value,
                                            );
                                          },
                                          icon: const Icon(Icons.date_range),
                                        ),
                                        width: 150,
                                        labelText: 'Date',
                                        // focusNode: controller.focusNode1,
                                        // onEditingComplete: () {
                                        //   FocusScope.of(
                                        //     context,
                                        //   ).requestFocus(controller.focusNode2);
                                        // },
                                        textInputAction: TextInputAction.next,
                                      ),
                                    ),
                                  ],
                                ),
                                FocusTraversalOrder(
                                  order: const NumericFocusOrder(2),

                                  child: GetX<IssueItemsController>(
                                    builder: (controller) {
                                      bool isAllBranchesLoading =
                                          controller.allBranches.isEmpty;
                                      return CustomDropdown(
                                        focusNode: controller.focusNode2,
                                        nextFocusNode: controller.focusNode3,
                                        textcontroller:
                                            controller.branch.value.text,
                                        showedSelectedName: 'name',
                                        hintText: 'Branch',
                                        items: isAllBranchesLoading
                                            ? {}
                                            : controller.allBranches,
                                        onChanged: (key, value) {
                                          controller.branchId.value = key;
                                          controller.branch.value.text =
                                              value['name'];
                                        },
                                      );
                                    },
                                  ),
                                ),
                                GetX<IssueItemsController>(
                                  builder: (controller) {
                                    bool isIssueTypesLoading =
                                        controller.allIssueTypes.isEmpty;
                                    return CustomDropdown(
                                      focusNode: controller.focusNode3,
                                      nextFocusNode: controller.focusNode4,
                                      hintText: 'Issue Types',
                                      showedSelectedName: 'name',
                                      textcontroller:
                                          controller.issueType.value,
                                      width: 150,
                                      items: isIssueTypesLoading
                                          ? {}
                                          : controller.allIssueTypes,
                                      onChanged: (key, value) {
                                        controller.issueTypeId.value = key;
                                        controller.issueType.value =
                                            value['name'];
                                        controller.jobDetails.clear();
                                        controller.allJobCards.clear();
                                      },
                                    );
                                  },
                                ),
                                GetX<IssueItemsController>(
                                  builder: (controller) {
                                    var selectedType = controller.issueType;
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        myTextFormFieldWithBorder(
                                          controller: controller.jobDetails,
                                          labelText: selectedType.value == ''
                                              ? 'Not Selected'
                                              : selectedType.value,
                                          width: 310,
                                          focusNode: controller.focusNode4,
                                          onEditingComplete: () {
                                            FocusScope.of(context).requestFocus(
                                              controller.focusNode5,
                                            );
                                          },
                                          textInputAction: TextInputAction.next,
                                        ),
                                        IconButton(
                                          focusNode: FocusNode(
                                            skipTraversal: true,
                                          ),
                                          onPressed: () {
                                            controller.selectedJobOrConverter(
                                              selectedType.value,
                                            );
                                            dialog(
                                              constraints: constraints,
                                              context: context,
                                              dialogName: '💳 Job Cards',
                                              onPressedForClearSearch: () {
                                                controller.searchForJobCards
                                                    .clear();
                                                controller
                                                    .searchEngineForJobCards();
                                              },
                                              hintText: 'Search for jobs',
                                              controllerForSearchField:
                                                  controller.searchForJobCards,
                                              onChangedForSearchField: (_) {
                                                controller
                                                    .searchEngineForJobCards();
                                              },

                                              table: jobCardTable(
                                                constraints,
                                                controller,
                                                context,
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.more_vert_rounded,
                                            color: mainColor,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                GetX<IssueItemsController>(
                                  builder: (controller) {
                                    bool isAllTechsLoading =
                                        controller.allTechs.isEmpty;
                                    return CustomDropdown(
                                      textcontroller:
                                          controller.receivedBy.value.text,
                                      hintText: 'Received By',
                                      showedSelectedName: 'name',
                                      width: 310,
                                      items: isAllTechsLoading
                                          ? {}
                                          : controller.allTechs,
                                      onChanged: (key, value) {
                                        controller.receivedBy.value.text =
                                            value['name'];
                                        controller.receivedById.value = key;
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: myTextFormFieldWithBorder(
                              focusNode: controller.focusNode5,
                              labelText: 'Note',
                              maxLines: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          labelContainer(
            lable: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Item Details', style: fontStyle1),
                newItemsButton(context, constraints, controller, id),
              ],
            ),
          ),
          detailsTableSection(
            context: context,
            constraints: constraints,
            id: id,
            firstColumnName: 'Item Details',
            allItems: controller.allItems,
            loadingItems: controller.loadingItems,
          ),
          const SizedBox(height: 10),
          labelContainer(
            lable: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Converter Details', style: fontStyle1),
                // newItemButton(context, constraints, controller, id),
              ],
            ),
          ),
          detailsTableSection(
            context: context,
            constraints: constraints,
            id: id,
            firstColumnName: 'Converter Details',
            allItems: controller.allConverters,
            loadingItems: controller.loadingConverters,
          ),
        ],
      ),
    ),
  );
}

Future<dynamic> dialog({
  required BoxConstraints constraints,
  required BuildContext context,
  required String dialogName,
  required void Function()? onPressedForClearSearch,
  required String hintText,
  required TextEditingController? controllerForSearchField,
  required void Function(String)? onChangedForSearchField,
  Widget? table,
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        width: constraints.maxWidth / 1.5,
        height: 500,
        child: Column(
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                color: mainColor,
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(dialogName, style: fontStyleForScreenNameUsedInButtons),
                  const Spacer(),
                  closeButton,
                ],
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 400,
                      height: 50,
                      child: SearchBar(
                        trailing: [
                          IconButton(
                            onPressed: onPressedForClearSearch,
                            icon: const Icon(Icons.close, color: Colors.grey),
                          ),
                        ],
                        leading: const Icon(Icons.search, color: Colors.grey),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        hintText: hintText,
                        hintStyle: WidgetStateProperty.all(
                          const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        controller: controllerForSearchField,
                        onChanged: onChangedForSearchField,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Full-width Scrollable Table
                    table ?? const SizedBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Expanded jobCardTable(
  BoxConstraints constraints,
  IssueItemsController controller,
  BuildContext context,
) {
  return Expanded(
    child: GetX<IssueItemsController>(
      builder: (controller) {
        return controller.loadingJobCards.value
            ? Center(child: loadingProcess)
            : controller.loadingJobCards.isFalse && controller.allJobCards.isEmpty
            ? const Center(child: Text('No Data'))
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth / 1.5 - 20,
                    ),
                    child: DataTable(
                      showCheckboxColumn: false,
                      horizontalMargin: horizontalMarginForTable,
                      dataRowMaxHeight: 40,
                      dataRowMinHeight: 30,
                      columnSpacing: 5,
                      showBottomBorder: true,
                      dataTextStyle: regTextStyle,
                      headingTextStyle: fontStyleForTableHeader,
                      headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
                      columns: [
                        DataColumn(
                          label: AutoSizedText(
                            constraints: constraints,
                            text: 'Job Number',
                          ),
                        ),
                        DataColumn(
                          label: AutoSizedText(
                            constraints: constraints,
                            text: 'Car Brand',
                          ),
                        ),
                        DataColumn(
                          label: AutoSizedText(
                            constraints: constraints,
                            text: 'Plate Number',
                          ),
                        ),
                        DataColumn(
                          label: AutoSizedText(
                            constraints: constraints,
                            text: 'VIN',
                          ),
                        ),
                        DataColumn(
                          label: AutoSizedText(
                            constraints: constraints,
                            text: 'Customer',
                          ),
                        ),
                      ],
                      rows:
                          (controller.filteredJobCards.isEmpty &&
                              controller.searchForJobCards.value.text.isEmpty)
                          ? List<DataRow>.generate(controller.allJobCards.length, (
                              index,
                            ) {
                              final job = controller.allJobCards[index];
                              final jobData = job.data() as Map<String, dynamic>;
                              final jobId = job.id;
        
                              return dataRowForTheTable(
                                jobData,
                                context,
                                constraints,
                                jobId,
                                controller,
                                index,
                              );
                            })
                          : List<DataRow>.generate(
                              controller.filteredJobCards.length,
                              (index) {
                                final job = controller.filteredJobCards[index];
                                final jobData = job.data() as Map<String, dynamic>;
                                final jobId = job.id;
        
                                return dataRowForTheTable(
                                  jobData,
                                  context,
                                  constraints,
                                  jobId,
                                  controller,
                                  index,
                                );
                              },
                            ),
                    ),
                  ),
                ),
              );
      }
    ),
  );
}

DataRow dataRowForTheTable(
  Map<String, dynamic> jobData,
  context,
  constraints,
  jobId,
  IssueItemsController controller,
  int index,
) {
  return DataRow(
    onSelectChanged: (_) {
      Get.back();
      controller.jobDetails.text =
          '${jobData['job_number']} [${getdataName(jobData['car_brand'], controller.allBrands)}] [${jobData['plate_number']}]';
    },
    color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      // Alternate row colors
      return index % 2 == 0 ? Colors.grey[200] : Colors.white;
    }),
    cells: [
      DataCell(Text(jobData['job_number'] ?? '')),
      DataCell(Text((getdataName(jobData['car_brand'], controller.allBrands)))),
      DataCell(Text(jobData['plate_number'] ?? '')),
      DataCell(Text(jobData['vehicle_identification_number'] ?? '')),
      DataCell(
        Text(
          getdataName(
            jobData['customer'],
            controller.allCustomers,
            title: 'entity_name',
          ),
        ),
      ),
    ],
  );
}
