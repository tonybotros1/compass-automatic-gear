import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/balances_controller.dart';
import '../../menu_dialog.dart';

Widget addNewBasedElementsOrEdit({
  required BalancesController controller,
  required bool canEdit,
}) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        MenuWithValues(
          labelText: 'Element Type',
          headerLqabel: 'Types',
          dialogWidth: 600,
          controller: controller.basedElementName,
          displayKeys: const ['name'],
          displaySelectedKeys: const ['name'],
          onDelete: () {
            controller.basedElementName.clear();
            controller.basedElementNameId.value = '';
          },
          onSelected: (value) {
            controller.basedElementName.text = value['name'];
            controller.basedElementNameId.value = value['_id'];
          },
          onOpen: () {
            return controller.getAllPayrollElements("");
          },
        ),

        MenuWithValues(
          labelText: 'Type',
          headerLqabel: 'Types',
          dialogWidth: 600,
          controller: controller.basedElementType,
          displayKeys: const ['name'],
          displaySelectedKeys: const ['name'],
          onDelete: () {
            controller.basedElementType.clear();
          },
          data: controller.allBasedElementTypes,
          onSelected: (value) {
            controller.basedElementType.text = value['name'];
          },
        ),
      ],
    ),
  );
}
