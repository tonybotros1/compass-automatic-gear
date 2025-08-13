import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/car_brands_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/car_brands_widgets/cars_brand_dialog.dart';
import '../../../../Widgets/main screen widgets/car_brands_widgets/values_section_models.dart';
import '../../../../consts.dart';

class CarBrands extends StatelessWidget {
  const CarBrands({super.key});

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
                  GetX<CarBrandsController>(
                    init: CarBrandsController(),
                    builder: (controller) {
                      return searchBar(
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        // controller: controller,
                        title: 'Search for brands',
                        button:
                            newbrandButton(context, constraints, controller),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<CarBrandsController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (controller.allBrands.isEmpty) {
                          return const Center(
                            child: Text('No Element'),
                          );
                        }
                        return SingleChildScrollView(
                          scrollDirection: Axis
                              .vertical, // Horizontal scrolling for the table
                          child: SizedBox(
                            width: constraints.maxWidth,
                            child: tableOfScreens(
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

Widget tableOfScreens(
    {required constraints,
    required context,
    required CarBrandsController controller}) {
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
          constraints: constraints,
          text: 'Name',
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
          text: 'Creation Date',
        ),
        onSort: controller.onSort,
      ),
      const DataColumn(
        label: Text(''),
      ),
    ],
    rows: controller.filteredBrands.isEmpty &&
            controller.search.value.text.isEmpty
        ? controller.allBrands.map<DataRow>((brand) {
            final brandData = brand.data() as Map<String, dynamic>;
            final brandId = brand.id;
            return dataRowForTheTable(
                brandData, context, constraints, brandId, controller);
          }).toList()
        : controller.filteredBrands.map<DataRow>((brand) {
            final brandData = brand.data() as Map<String, dynamic>;
            final brandId = brand.id;
            return dataRowForTheTable(
                brandData, context, constraints, brandId, controller);
          }).toList(),
  );
}

DataRow dataRowForTheTable(Map<String, dynamic> brandData, context, constraints,
    brandId, CarBrandsController controller) {
  return DataRow(cells: [
    DataCell(
      Text(
        brandData['name'] ?? 'no name',
      ),
    ),
    DataCell(Image.network(
      '${brandData['logo']}',
      width: 40,
      errorBuilder: (context, url, error) => const Icon(Icons.error),
    )),
    DataCell(
      Text(
        brandData['added_date'] != null && brandData['added_date'] != ''
            ? textToDate(brandData['added_date']) //
            : 'N/A',
      ),
    ),
    DataCell(Row(
      spacing: 5,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        valSectionInTheTable(
            controller, brandId, context, constraints, brandData),
        activeInActiveSection(controller, brandData, brandId),
        editSection(context, controller, brandData, constraints, brandId),
        deleteSection(controller, brandId, context),
      ],
    )),
  ]);
}

ElevatedButton valSectionInTheTable(CarBrandsController controller, brandId,
    context, BoxConstraints constraints, brandData) {
  return ElevatedButton(
      style: viewButtonStyle,
      onPressed: () {
        controller.getModelsValues(brandId);
        controller.brandIdToWorkWith.value = brandId;
        Get.dialog(
            barrierDismissible: false,
            Dialog(
              insetPadding: const EdgeInsets.all(25),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: SizedBox(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        color: mainColor,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Text(
                            '🚗 Models',
                            style: fontStyleForScreenNameUsedInButtons,
                          ),
                          const Spacer(),
                          closeButton
                        ],
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: modelsSection(
                        constraints: constraints,
                        context: context,
                      ),
                    ))
                  ],
                ),
              ),
            ));
      },
      child: const Text('Models'));
}

ElevatedButton activeInActiveSection(CarBrandsController controller,
    Map<String, dynamic> brandData, String brandId) {
  return ElevatedButton(
      style: brandData['status'] == false
          ? inActiveButtonStyle
          : activeButtonStyle,
      onPressed: () {
        bool status;
        if (brandData['status'] == false) {
          status = true;
        } else {
          status = false;
        }
        controller.editActiveOrInActiveStatus(brandId, status);
      },
      child: brandData['status'] == true
          ? const Text('Active')
          : const Text('Inactive'));
}

ElevatedButton deleteSection(CarBrandsController controller, brandId, context) {
  return ElevatedButton(
      style: deleteButtonStyle,
      onPressed: () {
        alertDialog(
            context: context,
            content: "The brand will be deleted permanently",
            onPressed: () {
              controller.deletebrand(brandId);
            });
      },
      child: const Text("Delete"));
}

ElevatedButton editSection(context, CarBrandsController controller,
    Map<String, dynamic> brandData, constraints, brandId) {
  return ElevatedButton(
      style: editButtonStyle,
      onPressed: () {
        controller.brandName.text = brandData['name'];
        controller.logoUrl.value = brandData['logo'];
        controller.imageBytes.value = Uint8List(0);
        controller.logoSelectedError.value = false;
        carBrandsDialog(
            constraints: constraints,
            controller: controller,
            onPressed: controller.addingNewValue.value
                ? null
                : () {
                    if (!controller.formKeyForAddingNewvalue.currentState!
                        .validate()) {}
                    if (controller.imageBytes.value.isEmpty &&
                        controller.logoUrl.isEmpty) {
                      controller.logoSelectedError.value = true;
                    } else {
                      controller.editBrand(brandId);
                    }
                  });
      },
      child: const Text('Edit'));
}

ElevatedButton newbrandButton(BuildContext context, BoxConstraints constraints,
    CarBrandsController controller) {
  return ElevatedButton(
    onPressed: () {
      controller.imageBytes.value = Uint8List(0);
      controller.logoUrl.value = '';
      controller.logoSelectedError.value = false;
      controller.brandName.clear();
      carBrandsDialog(
          constraints: constraints,
          controller: controller,
          onPressed: controller.addingNewValue.value
              ? null
              : () {
                  if (!controller.formKeyForAddingNewvalue.currentState!
                      .validate()) {}
                  if (controller.imageBytes.value.isEmpty) {
                    controller.logoSelectedError.value = true;
                  } else {
                    controller.addNewbrand();
                  }
                });
    },
    style: newButtonStyle,
    child: const Text('New brand'),
  );
}
