import 'package:datahubai/Controllers/Main%20screen%20controllers/issue_items_controller.dart';
import 'package:datahubai/Models/converters/converter_model.dart';
import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:datahubai/Widgets/main%20screen%20widgets/auto_size_box.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Models/job cards/job_card_model.dart';
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
                                      controller: controller.issueNumber.value,
                                      isEnabled: false,
                                      width: 150,
                                      labelText: 'Number',
                                    ),
                                    FocusTraversalOrder(
                                      order: const NumericFocusOrder(1),

                                      child: myTextFormFieldWithBorder(
                                        controller: controller.date.value,
                                        onFieldSubmitted: (_) async {
                                          normalizeDate(
                                            controller.date.value.text,
                                            controller.date.value,
                                          );
                                          controller.isIssuingModified.value =
                                              true;
                                        },
                                        suffixIcon: IconButton(
                                          focusNode: FocusNode(
                                            skipTraversal: true,
                                          ),
                                          onPressed: () {
                                            controller.isIssuingModified.value =
                                                true;
                                            selectDateContext(
                                              context,
                                              controller.date.value,
                                            );
                                          },
                                          icon: const Icon(Icons.date_range),
                                        ),
                                        width: 150,
                                        labelText: 'Date',
                                        textInputAction: TextInputAction.next,
                                      ),
                                    ),
                                  ],
                                ),

                                Row(
                                  spacing: 10,
                                  children: [
                                    GetBuilder<IssueItemsController>(
                                      builder: (controller) {
                                        return CustomDropdown(
                                          focusNode: controller.focusNode3,
                                          nextFocusNode: controller.focusNode4,
                                          hintText: 'Issue Types',
                                          showedSelectedName: 'name',
                                          textcontroller:
                                              controller.issueType.value,
                                          width: 150,

                                          onChanged: (key, value) {
                                            controller.issueTypeId.value = key;
                                            controller.issueType.value =
                                                value['name'];
                                            controller.jobDetails.clear();
                                            controller.allJobCards.clear();
                                            controller.allConverters.clear();
                                            controller.isIssuingModified.value =
                                                true;
                                          },
                                          onDelete: () {
                                            controller.issueTypeId.value = '';
                                            controller.issueType.value = '';
                                            controller.jobDetails.clear();
                                            controller.allJobCards.clear();
                                            controller.allConverters.clear();
                                            controller.isIssuingModified.value =
                                                true;
                                          },
                                          onOpen: () {
                                            return controller.getIssueTypes();
                                          },
                                        );
                                      },
                                    ),
                                    GetX<IssueItemsController>(
                                      builder: (controller) {
                                        var selectedType = controller.issueType;
                                        return myTextFormFieldWithBorder(
                                          readOnly: true,
                                          controller: controller.jobDetails,
                                          labelText: selectedType.value == ''
                                              ? 'Not Selected'
                                              : selectedType.value,
                                          width: 400,
                                          onEditingComplete: () {
                                            FocusScope.of(context).requestFocus(
                                              controller.focusNode5,
                                            );
                                          },
                                          textInputAction: TextInputAction.next,
                                          suffixIcon: IconButton(
                                            focusNode: FocusNode(
                                              skipTraversal: true,
                                            ),
                                            onPressed: () {
                                              if (controller
                                                  .issueType
                                                  .isEmpty) {
                                                return;
                                              }
                                              bool isJobSelected =
                                                  selectedType.value ==
                                                  'Job Card';
                                              controller
                                                  .clearSearchFiltersForJobCardsAndConverters();

                                              dialog(
                                                constraints: constraints,
                                                context: context,
                                                dialogName:
                                                    isJobSelected == true
                                                    ? '💳 Job Cards'
                                                    : "🚘 Converters",
                                                searchBar: isJobSelected == true
                                                    ? Row(
                                                        spacing: 10,
                                                        children: [
                                                          myTextFormFieldWithBorder(
                                                            width: 120,
                                                            labelText:
                                                                'Job No.',
                                                            controller: controller
                                                                .jobNumberFilter,
                                                          ),
                                                          CustomDropdown(
                                                            width: 170,
                                                            showedSelectedName:
                                                                'name',
                                                            textcontroller:
                                                                controller
                                                                    .carBrandIdFilterName
                                                                    .text,
                                                            hintText:
                                                                'Car Brand',
                                                            onChanged: (key, value) async {
                                                              controller
                                                                      .carBrandIdFilter
                                                                      .value =
                                                                  key;
                                                              controller
                                                                      .carBrandIdFilterName
                                                                      .text =
                                                                  value['name'];
                                                              controller
                                                                      .carModelIdFilter
                                                                      .value =
                                                                  '';
                                                              controller
                                                                      .carModelIdFilterName
                                                                      .text =
                                                                  '';
                                                            },
                                                            onDelete: () {
                                                              controller
                                                                      .carBrandIdFilter
                                                                      .value =
                                                                  "";
                                                              controller
                                                                  .carBrandIdFilterName
                                                                  .clear();
                                                              controller
                                                                      .carModelIdFilter
                                                                      .value =
                                                                  '';
                                                              controller
                                                                      .carModelIdFilterName
                                                                      .text =
                                                                  '';
                                                            },
                                                            onOpen: () {
                                                              return controller
                                                                  .getCarBrands();
                                                            },
                                                          ),
                                                          CustomDropdown(
                                                            width: 170,
                                                            showedSelectedName:
                                                                'name',
                                                            textcontroller:
                                                                controller
                                                                    .carModelIdFilterName
                                                                    .value
                                                                    .text,
                                                            hintText:
                                                                'Car Model',
                                                            onChanged: (key, value) async {
                                                              controller
                                                                      .carModelIdFilter
                                                                      .value =
                                                                  key;
                                                              controller
                                                                      .carModelIdFilterName
                                                                      .text =
                                                                  value['name'];
                                                            },
                                                            onDelete: () {
                                                              controller
                                                                      .carModelIdFilter
                                                                      .value =
                                                                  "";
                                                              controller
                                                                  .carModelIdFilterName
                                                                  .clear();
                                                            },
                                                            onOpen: () {
                                                              return controller
                                                                  .getModelsByCarBrand(
                                                                    controller
                                                                        .carBrandIdFilter
                                                                        .value,
                                                                  );
                                                            },
                                                          ),
                                                          myTextFormFieldWithBorder(
                                                            width: 90,
                                                            labelText:
                                                                'Plate NO.',
                                                            controller: controller
                                                                .plateNumberFilter,
                                                          ),
                                                          myTextFormFieldWithBorder(
                                                            width: 170,
                                                            labelText: 'VIN',
                                                            controller:
                                                                controller
                                                                    .vinFilter,
                                                          ),
                                                          CustomDropdown(
                                                            width: 300,
                                                            textcontroller:
                                                                controller
                                                                    .customerNameIdFilterName
                                                                    .value
                                                                    .text,
                                                            showedSelectedName:
                                                                'entity_name',
                                                            hintText:
                                                                'Customer Name',
                                                            onChanged: (key, value) async {
                                                              controller
                                                                      .customerNameIdFilterName
                                                                      .text =
                                                                  value['entity_name'];
                                                              controller
                                                                      .customerNameIdFilter
                                                                      .value =
                                                                  key;
                                                            },
                                                            onDelete: () {
                                                              controller
                                                                  .customerNameIdFilterName
                                                                  .clear();
                                                              controller
                                                                      .customerNameIdFilter
                                                                      .value =
                                                                  "";
                                                            },
                                                            onOpen: () {
                                                              return controller
                                                                  .getAllCustomers();
                                                            },
                                                          ),
                                                        ],
                                                      )
                                                    : Row(
                                                        spacing: 10,
                                                        children: [
                                                          myTextFormFieldWithBorder(
                                                            width: 200,
                                                            labelText:
                                                                'Converter Number',
                                                            controller: controller
                                                                .converterNumberFilter,
                                                          ),
                                                          myTextFormFieldWithBorder(
                                                            width: 300,
                                                            labelText:
                                                                'Converter Name',
                                                            controller: controller
                                                                .converterNameFilter,
                                                          ),
                                                        ],
                                                      ),
                                                loading: isJobSelected == true
                                                    ? controller.loadingJobCards
                                                    : controller
                                                          .loadingConverters,
                                                search: () {
                                                  isJobSelected == true
                                                      ? controller
                                                            .filterSearchForJobCards()
                                                      : controller
                                                            .filterSearchForConverters();
                                                },

                                                table: isJobSelected == true
                                                    ? jobCardTable(
                                                        constraints,
                                                        controller,
                                                        context,
                                                      )
                                                    : converterTable(
                                                        constraints,
                                                        controller,
                                                        context,
                                                      ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.more_horiz_rounded,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  spacing: 10,
                                  children: [
                                    FocusTraversalOrder(
                                      order: const NumericFocusOrder(2),
                                      child: GetBuilder<IssueItemsController>(
                                        builder: (controller) {
                                          return CustomDropdown(
                                            focusNode: controller.focusNode2,
                                            nextFocusNode:
                                                controller.focusNode3,
                                            textcontroller:
                                                controller.branch.value.text,
                                            showedSelectedName: 'name',
                                            hintText: 'Branch',
                                            onChanged: (key, value) {
                                              controller.branchId.value = key;
                                              controller.branch.value.text =
                                                  value['name'];
                                              controller
                                                      .isIssuingModified
                                                      .value =
                                                  true;
                                            },
                                            onDelete: () {
                                              controller.branchId.value = '';
                                              controller.branch.value.clear();
                                              controller
                                                      .isIssuingModified
                                                      .value =
                                                  true;
                                            },
                                            onOpen: () {
                                              return controller.getBranches();
                                            },
                                          );
                                        },
                                      ),
                                    ),

                                    GetBuilder<IssueItemsController>(
                                      builder: (controller) {
                                        return CustomDropdown(
                                          textcontroller:
                                              controller.receivedBy.value.text,
                                          hintText: 'Received By',
                                          showedSelectedName: 'name',
                                          width: 400,
                                          onChanged: (key, value) {
                                            controller.receivedBy.value.text =
                                                value['name'];
                                            controller.receivedById.value = key;
                                            controller.isIssuingModified.value =
                                                true;
                                          },
                                          onDelete: () {
                                            controller.receivedBy.value.clear();
                                            controller.receivedById.value = '';
                                            controller.isIssuingModified.value =
                                                true;
                                          },
                                          onOpen: () {
                                            return controller
                                                .getEmployeesByDepartment();
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: myTextFormFieldWithBorder(
                              controller: controller.note.value,
                              focusNode: controller.focusNode5,
                              labelText: 'Note',
                              maxLines: 7,
                              onChanged: (_) {
                                controller.isIssuingModified.value = true;
                              },
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
                newItemsButton(context, constraints, controller, false),
              ],
            ),
          ),
          detailsTableSection(
            context: context,
            constraints: constraints,
            isConverter: false,
          ),
          const SizedBox(height: 10),
          GetX<IssueItemsController>(
            builder: (controller) {
              final showSection =
                  controller.issueType.value != 'Converter' &&
                  controller.issueType.isNotEmpty;

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.1),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: showSection
                    ? Column(
                        key: const ValueKey('converter_section'),
                        children: [
                          labelContainer(
                            lable: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Converter Details', style: fontStyle1),
                                newItemsButton(
                                  context,
                                  constraints,
                                  controller,
                                  true,
                                ),
                              ],
                            ),
                          ),
                          detailsTableSection(
                            context: context,
                            constraints: constraints,
                            isConverter: true,
                          ),
                        ],
                      )
                    : const SizedBox(key: ValueKey('empty')),
              );
            },
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
  required RxBool loading,
  required void Function()? search,
  required Widget searchBar,
  Widget? table,
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        width: constraints.maxWidth / 1.5,
        height: 810,
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
                  closeIcon(),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth / 1.5 - 8,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              searchBar,
                              GetX<IssueItemsController>(
                                builder: (controller) {
                                  return ElevatedButton(
                                    style: findButtonStyle,
                                    onPressed: loading.isFalse ? search : null,
                                    child: loading.isFalse
                                        ? Text(
                                            'Find',
                                            style: fontStyleForElevatedButtons,
                                          )
                                        : loadingProcess,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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

Widget jobCardTable(
  BoxConstraints constraints,
  IssueItemsController controller,
  BuildContext context,
) {
  return GetX<IssueItemsController>(
    builder: (controller) {
      return SizedBox(
        width: constraints.maxWidth,
        child: PaginatedDataTable(
          showCheckboxColumn: false,
          horizontalMargin: horizontalMarginForTable,
          dataRowMaxHeight: 40,
          dataRowMinHeight: 30,
          columnSpacing: 5,
          rowsPerPage: 13,
          columns: [
            DataColumn(
              label: AutoSizedText(
                constraints: constraints,
                text: 'Job Number',
              ),
            ),
            DataColumn(
              label: AutoSizedText(constraints: constraints, text: 'Car Brand'),
            ),
            DataColumn(
              label: AutoSizedText(constraints: constraints, text: 'Car Model'),
            ),
            DataColumn(
              label: AutoSizedText(
                constraints: constraints,
                text: 'Plate Number',
              ),
            ),
            DataColumn(
              label: AutoSizedText(constraints: constraints, text: 'VIN'),
            ),
            DataColumn(
              label: AutoSizedText(constraints: constraints, text: 'Customer'),
            ),
          ],
          source: CardDataSourceForJobCards(
            cards: controller.allJobCards.isEmpty ? [] : controller.allJobCards,
            context: context,
            constraints: constraints,
            controller: controller,
          ),
        ),
      );
    },
  );
}

DataRow dataRowForTheTable(
  JobCardModel jobData,
  BuildContext context,
  BoxConstraints constraints,
  String jobId,
  IssueItemsController controller,
  int index,
) {
  return DataRow(
    onSelectChanged: (_) {
      controller.isIssuingModified.value = true;
      Get.back();
      controller.jobCardId.value = jobId;
      controller.jobDetails.text =
          '${jobData.jobNumber ?? ''} [${jobData.carBrandName ?? ''} ${jobData.carModelName ?? ''}] [${jobData.plateNumber ?? ''}]';
    },
    color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      return index % 2 == 0 ? Colors.grey[200] : Colors.white;
    }),
    cells: [
      DataCell(
        textForDataRowInTable(
          text: jobData.jobNumber ?? '',
          formatDouble: false,
          color: Colors.green,
          isBold: true,
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: jobData.carBrandName ?? '',
          formatDouble: false,
          color: Colors.red,
          isBold: true,
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: jobData.carModelName ?? '',
          formatDouble: false,
          color: Colors.blueGrey,
          isBold: true,
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: jobData.plateNumber ?? '',
          formatDouble: false,
          isBold: true,
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: jobData.vehicleIdentificationNumber ?? '',
          formatDouble: false,
          isBold: true,
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: jobData.customerName ?? '',
          formatDouble: false,
          color: Colors.teal,
          isBold: true,
          maxWidth: null,
        ),
      ),
    ],
  );
}

Widget converterTable(
  BoxConstraints constraints,
  IssueItemsController controller,
  BuildContext context,
) {
  return GetX<IssueItemsController>(
    builder: (controller) {
      return SizedBox(
        width: constraints.maxWidth,
        child: PaginatedDataTable(
          showCheckboxColumn: false,
          horizontalMargin: horizontalMarginForTable,
          dataRowMaxHeight: 40,
          dataRowMinHeight: 30,
          rowsPerPage: 13,
          columnSpacing: 5,
          columns: [
            DataColumn(
              label: AutoSizedText(
                constraints: constraints,
                text: 'Converter Number',
              ),
            ),
            DataColumn(
              label: AutoSizedText(
                constraints: constraints,
                text: 'Converter Name',
              ),
            ),
            DataColumn(
              label: AutoSizedText(
                constraints: constraints,
                text: 'Description',
              ),
            ),
          ],
          source: CardDataSourceForConverters(
            cards: controller.allConverters.isEmpty
                ? []
                : controller.allConverters,
            context: context,
            constraints: constraints,
            controller: controller,
          ),
        ),
      );
    },
  );
}

DataRow dataRowForTheConverterTable(
  ConverterModel converterData,
  BuildContext context,
  BoxConstraints constraints,
  String converterId,
  IssueItemsController controller,
  int index,
) {
  return DataRow(
    onSelectChanged: (_) {
      controller.isIssuingModified.value = true;
      Get.back();
      controller.converterId.value = converterId;
      controller.jobDetails.text =
          '${converterData.converterNumber ?? ''} [${converterData.name ?? ''}]';
    },
    color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      return index % 2 == 0 ? Colors.grey[200] : Colors.white;
    }),
    cells: [
      DataCell(
        textForDataRowInTable(
          text: converterData.converterNumber ?? '',
          formatDouble: false,
          color: Colors.green,
          isBold: true,
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: converterData.name ?? '',
          formatDouble: false,
          color: Colors.red,
          isBold: true,
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: converterData.description ?? '',
          formatDouble: false,
          color: Colors.blueGrey,
          isBold: true,
          maxWidth: null,
        ),
      ),
    ],
  );
}

class CardDataSourceForConverters extends DataTableSource {
  final List<ConverterModel> cards;
  final BuildContext context;
  final BoxConstraints constraints;
  final IssueItemsController controller;

  CardDataSourceForConverters({
    required this.cards,
    required this.context,
    required this.constraints,
    required this.controller,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= cards.length) return null;

    final trade = cards[index];
    final cardId = trade.id ?? '';

    return dataRowForTheConverterTable(
      trade,
      context,
      constraints,
      cardId,
      controller,
      index,
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => cards.length;

  @override
  int get selectedRowCount => 0;
}

class CardDataSourceForJobCards extends DataTableSource {
  final List<JobCardModel> cards;
  final BuildContext context;
  final BoxConstraints constraints;
  final IssueItemsController controller;

  CardDataSourceForJobCards({
    required this.cards,
    required this.context,
    required this.constraints,
    required this.controller,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= cards.length) return null;

    final jobCard = cards[index];
    final cardId = jobCard.id ?? '';

    return dataRowForTheTable(
      jobCard,
      context,
      constraints,
      cardId,
      controller,
      index,
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => cards.length;

  @override
  int get selectedRowCount => 0;
}
