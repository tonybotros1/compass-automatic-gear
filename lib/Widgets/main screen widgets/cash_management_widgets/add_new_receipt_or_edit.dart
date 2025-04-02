import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';

import '../../../Controllers/Main screen controllers/cash_management_controller.dart';
import '../../drop_down_menu3.dart';
import '../../my_text_field.dart';

Widget addNewReceiptOrEdit({
  required CashManagementController controller,
  required bool canEdit,
}) {
  return Form(
    key: controller.formKeyForAddingNewvalue,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              physics: NeverScrollableScrollPhysics(),
              slivers: [
                // Sliver for the upper portion of your form
                SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomDropdown(
                              hintText: 'Customer Name',
                              items: {},
                              itemBuilder: (context, key, value) {
                                return ListTile();
                              },
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: myTextFormFieldWithBorder(
                                              labelText: 'Receipt Number',
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: myTextFormFieldWithBorder(
                                              labelText: 'Status',
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: myTextFormFieldWithBorder(
                                              labelText: 'Receipt Date',
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: myTextFormFieldWithBorder(
                                              labelText: 'Outstanding',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: myTextFormFieldWithBorder(
                                    labelText: 'Notes',
                                    maxLines: 4,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: CustomDropdown(
                                    hintText: 'Receipt Type',
                                    items: {},
                                    itemBuilder: (context, key, value) {
                                      return ListTile();
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 2,
                                  child: const SizedBox(),
                                ),
                                ElevatedButton(
                                  style: historyButtonStyle,
                                  onPressed: (){}, child: Text('Customer Invoices'))
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: myTextFormFieldWithBorder(
                                    labelText: 'Cheque Number',
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: myTextFormFieldWithBorder(
                                    labelText: 'Bank Name',
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: myTextFormFieldWithBorder(
                                    labelText: 'Cheque Date',
                                    isDate: true,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomDropdown(
                                    hintText: 'Account',
                                    items: {},
                                    itemBuilder: (context, key, value) {
                                      return ListTile();
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: myTextFormFieldWithBorder(
                                    labelText: 'Currency',
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: myTextFormFieldWithBorder(
                                    labelText: 'Rate',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Divider
                SliverToBoxAdapter(
                  child: Divider(color: Colors.black),
                ),
                // Container that fills the remaining space
                SliverToBoxAdapter(
                  child: tableHeader(),
                ),
                SliverFillRemaining(
                  hasScrollBody: true,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: secColor,width: 2),
                      // color: Color.fromARGB(255, 202, 204, 202),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        spacing: 2,
                        children: [
                          receiptTableRowLine(),
                          receiptTableRowLine(),
                          receiptTableRowLine(),
                          receiptTableRowLine(),
                          receiptTableRowLine(),
                          receiptTableRowLine(),
                          receiptTableRowLine(),
                          receiptTableRowLine(),
                          receiptTableRowLine(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 2,
          ),
          tableFooter()
        ],
      ),
    ),
  );
}

Widget tableFooter() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Row(
      spacing: 2,
      children: [
        SizedBox(width: 15, height: 30),
        tabelCell(label: ''),
        tabelCell(label: ''),
        tabelCell(label: 'Total', hasBorder: true),
        tabelCell(label: '5000', hasBorder: true),
        tabelCell(label: '', flex: 5),
        TextButton(onPressed: null, child: SizedBox())
      ],
    ),
  );
}

Widget tableHeader() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Row(
      spacing: 2,
      children: [
        SizedBox(width: 15, height: 30),
        tabelCell(label: 'Invoice Number'),
        tabelCell(label: 'Total'),
        tabelCell(label: 'Outstanding'),
        tabelCell(label: 'Amount'),
        tabelCell(label: 'Notes', flex: 5),
        TextButton(onPressed: null, child: SizedBox())
      ],
    ),
  );
}

Expanded tabelCell({
  int flex = 1,
  required String label,
  bool hasBorder = false,
}) {
  return Expanded(
      flex: flex,
      child: Container(
        decoration: hasBorder
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey))
            : null,
        padding: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.centerLeft,
        height: textFieldHeight,
        child: Text(
          overflow: TextOverflow.ellipsis,
          label,
          style: textFieldLabelStyle,
        ),
      ));
}

Row receiptTableRowLine() {
  return Row(
    spacing: 2,
    children: [
      Container(
        height: 30,
        width: 15,
        color: Colors.yellow,
      ),
      Expanded(
          child: myTextFormFieldWithBorder(
              isEnabled: false,
              controller: null,
              initialValue: 'Tony',
              onChanged: (value) {
                print(value);
              })),
      Expanded(
          child: myTextFormFieldWithBorder(
              isEnabled: false,
              controller: null,
              initialValue: 'Tony',
              onChanged: (value) {
                print(value);
              })),
      Expanded(
          child: myTextFormFieldWithBorder(
              isEnabled: false,
              controller: null,
              initialValue: 'Tony',
              onChanged: (value) {
                print(value);
              })),
      Expanded(
          child: myTextFormFieldWithBorder(
              controller: null,
              initialValue: 'Tony',
              onChanged: (value) {
                print(value);
              })),
      Expanded(
          flex: 5,
          child: myTextFormFieldWithBorder(
              isEnabled: false,
              controller: null,
              initialValue: 'Tony',
              onChanged: (value) {
                print(value);
              })),
      TextButton(onPressed: () {}, child: Text('Delete'))
    ],
  );
}
