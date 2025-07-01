import 'package:datahubai/Controllers/Main%20screen%20controllers/cash_management_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../../drop_down_menu3.dart';
import '../../my_text_field.dart';

Widget miscHeader(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    child: GetX<CashManagementController>(builder: (controller) {
      bool isCustomerLoading = controller.allCustomers.isEmpty;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          Expanded(
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child:
                            CustomDropdown(hintText: 'Misc Type', items: {})),
                    Expanded(
                      flex: 2,
                      child: SizedBox(),
                    ),
                    Expanded(
                        flex: 2,
                        child: CustomDropdown(hintText: 'Type', items: {})),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: myTextFormFieldWithBorder(
                            labelText: 'Reference NO.')),
                    Expanded(
                      flex: 2,
                      child: SizedBox(),
                    ),
                    Expanded(
                        flex: 2,
                        child: CustomDropdown(
                            hintText: 'Bank Account Number', items: {})),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: myTextFormFieldWithBorder(
                        labelText: 'Transaction Date',
                      ),
                    ),
                    Expanded(flex: 2, child: SizedBox()),
                    Expanded(
                        flex: 2,
                        child:
                            CustomDropdown(hintText: 'Bank Name', items: {})),
                  ],
                ),
                Row(
                  children: [
                   
                    Expanded(flex: 3, child: SizedBox()),
                    Expanded(
                        flex: 2,
                        child:
                            CustomDropdown(hintText: 'Cheque Number', items: {})),
                  ],
                ),
                Row(
                  children: [
                   
                    Expanded(flex: 3, child: SizedBox()),
                    Expanded(
                        flex: 2,
                        child:
                            myTextFormFieldWithBorder(labelText: 'Maturity Date')),
                  ],
                ),
                CustomDropdown(
                  hintText: 'Beneficiary',
                  items: {})
              ],
            ),
          ),
          Expanded(
              child: myTextFormFieldWithBorder(labelText: 'Note', maxLines: 16))
        ],
      );
    }),
  );
}
