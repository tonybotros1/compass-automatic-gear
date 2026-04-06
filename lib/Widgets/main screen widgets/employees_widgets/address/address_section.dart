import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/employees_controller.dart';
import '../../../../Models/employees/address_model.dart';
import '../../../../consts.dart';
import '../../auto_size_box.dart';
import 'address_dialog.dart';

Widget addressSectionFotEmployees({required BoxConstraints constraints}) {
  return Container(
    decoration: containerDecor,
    child: GetX<EmployeesController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: newAddressButton(controller: controller),
            ),
            Expanded(
              child: tableOfScreens(
                constraints: constraints,
                controller: controller,
              ),
            ),
          ],
        );
      },
    ),
  );
}

Widget tableOfScreens({
  required BoxConstraints constraints,
  required EmployeesController controller,
}) {
  return SizedBox(
    // width: constraints.maxWidth - 17,
    child: DataTable2(
      columnSpacing: 5,
      horizontalMargin: horizontalMarginForTable,
      showBottomBorder: true,
      sortColumnIndex: controller.sortColumnIndex.value,
      sortAscending: controller.isAscending.value,
      lmRatio: 2,
      columns: [
        const DataColumn2(label: SizedBox(), size: ColumnSize.S),
        DataColumn2(
          label: AutoSizedText(constraints: constraints, text: 'Line'),
          size: ColumnSize.L,
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(constraints: constraints, text: 'Country'),
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(constraints: constraints, text: 'City'),
        ),
      ],
      rows: controller.addressesList.map<DataRow>((invoiceItems) {
        return dataRowForTheTable(invoiceItems, constraints, controller);
      }).toList(),
    ),
  );
}

DataRow dataRowForTheTable(
  EmployeeAddressModel addressData,
  BoxConstraints constraints,
  EmployeesController controller,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            removeAddressButton(
              controller: controller,
              id: addressData.id ?? '',
            ),
            updateAddressButton(
              controller: controller,
              data: addressData,
              id: addressData.id ?? '',
            ),
          ],
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: addressData.line.toString(),
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: addressData.countryName ?? '',
          maxWidth: null,
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: addressData.cityName ?? '',
          maxWidth: null,
          formatDouble: false,
        ),
      ),
    ],
  );
}

ElevatedButton newAddressButton({required EmployeesController controller}) {
  return ElevatedButton(
    onPressed: () {
      if (controller.currentEmployeeId.value.isEmpty) {
        alertMessage(context: Get.context!, content: "Please save doc first");
        return;
      }
      controller.line.clear();
      controller.country.clear();
      controller.city.clear();
      controller.countryId.value = '';
      controller.cityId.value = '';
      addressDialog(
        controller: controller,
        canEdit: true,
        onPressed: () {
          controller.addNewAddress();
        },
      );
    },
    style: newButtonStyle,
    child: const Text(
      'New Address',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}

IconButton removeAddressButton({
  required EmployeesController controller,
  required String id,
}) {
  return IconButton(
    onPressed: () {
      alertDialog(
        context: Get.context!,
        content: "Are you sure you want to delete this address?",
        onPressed: () {
          Get.back();
          controller.deleteAddress(id);
        },
      );
    },
    icon: deleteIcon,
  );
}

IconButton updateAddressButton({
  required EmployeeAddressModel data,
  required EmployeesController controller,
  required String id,
}) {
  return IconButton(
    onPressed: () {
      controller.line.text = data.line ?? '';
      controller.country.text = data.countryName ?? '';
      controller.city.text = data.cityName ?? '';
      controller.countryId.value = data.country ?? '';
      controller.cityId.value = data.city ?? '';
      addressDialog(
        controller: controller,
        canEdit: true,
        onPressed: () {
          controller.updateAddress(id);
        },
      );
    },
    icon: editIcon,
  );
}
