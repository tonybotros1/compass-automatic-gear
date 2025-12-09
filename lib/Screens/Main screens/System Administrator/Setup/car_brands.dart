import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/car_brands_controller.dart';
import '../../../../Models/brands/brand_model.dart';
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
                        onChanged: (_) {
                          controller.filterBrands();
                        },
                        onPressedForClearSearch: () {
                          controller.search.value.clear();
                          controller.filterBrands();
                        },
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        title: 'Search for brands',
                        button: newbrandButton(
                          context,
                          constraints,
                          controller,
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<CarBrandsController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return Center(child: loadingProcess);
                        }
                        if (controller.allBrands.isEmpty) {
                          return const Center(child: Text('No Element'));
                        }
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
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

Widget tableOfScreens({
  required BoxConstraints constraints,
  required BuildContext context,
  required CarBrandsController controller,
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
      const DataColumn(label: Text('')),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Name'),
        // onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Logo'),
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Creation Date'),
        // onSort: controller.onSort,
      ),
    ],
    rows:
        controller.filteredBrands.isEmpty &&
            controller.search.value.text.isEmpty
        ? controller.allBrands.map<DataRow>((brand) {
            // final brandData = brand.data() as Map<String, dynamic>;
            final brandData = brand;
            final brandId = brand.id;
            return dataRowForTheTable(
              brandData,
              context,
              constraints,
              brandId,
              controller,
            );
          }).toList()
        : controller.filteredBrands.map<DataRow>((brand) {
            // final brandData = brand.data() as Map<String, dynamic>;
            final brandData = brand;
            final brandId = brand.id;
            return dataRowForTheTable(
              brandData,
              context,
              constraints,
              brandId,
              controller,
            );
          }).toList(),
  );
}

DataRow dataRowForTheTable(
  Brand brandData,
  context,
  constraints,
  brandId,
  CarBrandsController controller,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            deleteSection(controller, brandId, context),
            editSection(context, controller, brandData, constraints, brandId),
            activeInActiveSection(controller, brandData, brandId),
            valSectionInTheTable(
              controller,
              brandId,
              context,
              constraints,
              brandData,
            ),
          ],
        ),
      ),
      DataCell(Text(brandData.name.toString())),
      DataCell(
        Image.network(
          fit: BoxFit.fitWidth,
          brandData.logo.toString().isNotEmpty
              ? cloudinaryThumbnail(brandData.logo.toString(), width: 45)
              : "",
          width: 35,
          errorBuilder: (context, url, error) => const Icon(Icons.error),
        ),
      ),
      DataCell(Text(textToDate(brandData.createdAt))),
    ],
  );
}

IconButton valSectionInTheTable(
  CarBrandsController controller,
  String brandId,
  BuildContext context,
  BoxConstraints constraints,
  brandData,
) {
  return IconButton(
    onPressed: () {
      controller.getModelsValues(brandId);
      controller.brandIdToWorkWith.value = brandId;
      Get.dialog(
        barrierDismissible: false,
        Dialog(
          insetPadding: const EdgeInsets.all(25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth / 2.5,
            child: Column(
              children: [
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
                      Text(
                        '🚗 Models',
                        style: fontStyleForScreenNameUsedInButtons,
                      ),
                      const Spacer(),
                      closeIcon(),
                    ],
                  ),
                ),
                Expanded(child: modelsSection(context: context)),
              ],
            ),
          ),
        ),
      );
    },
    icon: const Icon(Icons.car_repair_outlined),
  );
}

IconButton activeInActiveSection(
  CarBrandsController controller,
  Brand brandData,
  String brandId,
) {
  return IconButton(
    onPressed: () {
      bool status;
      if (brandData.status == false) {
        status = true;
      } else {
        status = false;
      }
      controller.editActiveOrInActiveStatus(brandId, status);
    },
    icon: brandData.status == true ? activeIcon : inActiveIcon,
  );
}

IconButton deleteSection(
  CarBrandsController controller,
  String brandId,
  BuildContext context,
) {
  return IconButton(
    onPressed: () {
      alertDialog(
        context: context,
        content: "The brand will be deleted permanently",
        onPressed: () {
          controller.deleteBrand(brandId);
        },
      );
    },
    icon: deleteIcon,
  );
}

IconButton editSection(
  BuildContext context,
  CarBrandsController controller,
  Brand brandData,
  BoxConstraints constraints,
  String brandId,
) {
  return IconButton(
    onPressed: () {
      controller.brandName.text = brandData.name.toString();
      controller.logoUrl.value = brandData.logo.toString();
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
              },
      );
    },
    icon: editIcon,
  );
}

ElevatedButton newbrandButton(
  BuildContext context,
  BoxConstraints constraints,
  CarBrandsController controller,
) {
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
                  controller.addNewBrand();
                }
              },
      );
    },
    style: newButtonStyle,
    child: const Text('New brand'),
  );
}
