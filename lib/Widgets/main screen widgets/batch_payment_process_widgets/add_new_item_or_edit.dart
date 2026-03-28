import 'package:datahubai/Controllers/Main%20screen%20controllers/batch_payment_process_controller.dart';
import 'package:flutter/material.dart';
import '../../../consts.dart';
import '../../menu_dialog.dart';
import '../../my_text_field.dart';

Widget addNewBatchItemOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required BatchPaymentProcessController controller,
  bool? canEdit,
}) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 5),
          MenuWithValues(
            labelText: 'Transaction Type',
            headerLqabel: 'Transaction Types',
            dialogWidth: 600,
            width: double.infinity,
            controller: controller.transactionType,
            displayKeys: const ['type'],
            displaySelectedKeys: const ['type'],
            onOpen: () {
              return controller.getTransactionTypes();
            },
            onDelete: () {
              controller.transactionType.clear();
              controller.transactionTypeId.value = '';
            },
            onSelected: (value) {
              controller.transactionType.text = value['type'];
              controller.transactionTypeId.value = value['_id'];
            },
          ),
          MenuWithValues(
            labelText: 'Received Number',
            headerLqabel: 'Receiving List',
            dialogWidth: double.infinity,
            width: 150,
            controller: controller.receivedNumber,
            displayKeys: const [
              'receiving_number',
              'reference_number',
              'date',
              'vendor_name',
              'branch_name',
              'note',
              'total',
              'vat',
              'net',
            ],
            headerKeys: const [
              'Received #',
              "Reference #",
              'Date',
              "Vendor",
              "Branch",
              "Note",
              "Total",
              "Vat",
              "Net",
            ],
            flexList: const [1, 1, 1, 3, 2, 3, 1, 1, 1],
            displaySelectedKeys: const ['receiving_number'],
            onOpen: () {
              return controller.getReceivedNumbersList();
            },
            onDelete: () {
              controller.receivedNumber.clear();
              controller.receivedNumberId.value = '';
            },
            onSelected: (value) {
              controller.receivedNumber.text = value['receiving_number'] ?? '';
              controller.receivedNumberId.value = value['_id'];
              controller.amount.text = value['total']?.toString() ?? '0';
              controller.vat.text = value['vat']?.toString() ?? '0';
              controller.invoiceNote.text = value['note'] ?? '';
              controller.vendor.text = value['vendor_name'] ?? '';
              controller.vendorId.value = value['vendor'] ?? '';
            },
          ),
          MenuWithValues(
            labelText: 'Vendor',
            headerLqabel: 'Vendors',
            dialogWidth: 600,
            controller: controller.vendor,
            displayKeys: const ['entity_name'],
            displaySelectedKeys: const ['entity_name'],
            onSelected: (value) {
              controller.vendorId.value = value['_id'];
              controller.vendor.text = value['entity_name'];
            },
            onOpen: () {
              return controller.getAllVendors();
            },
            onDelete: () {
              controller.vendorId.value = '';
              controller.vendor.clear();
            },
          ),
          Row(
            spacing: 10,
            children: [
              myTextFormFieldWithBorder(
                width: 150,
                isDouble: true,
                textInputAction: TextInputAction.next,
                labelText: 'Amount',
                controller: controller.amount,
              ),
              myTextFormFieldWithBorder(
                width: 150,
                isDouble: true,
                textInputAction: TextInputAction.next,
                labelText: 'VAT',
                controller: controller.vat,
              ),
            ],
          ),
          Row(
            spacing: 10,
            children: [
              myTextFormFieldWithBorder(
                width: 150,
                textInputAction: TextInputAction.next,
                labelText: 'Invoice Number',
                controller: controller.invoiceNumber,
              ),
              myTextFormFieldWithBorder(
                width: 150,
                isDate: true,
                textInputAction: TextInputAction.next,
                labelText: 'Invoice Date',
                controller: controller.invoiceDate,
                suffixIcon: ExcludeFocus(
                  child: IconButton(
                    onPressed: () {
                      selectDateContext(context, controller.invoiceDate);
                    },
                    icon: const Icon(Icons.date_range),
                  ),
                ),
                onFieldSubmitted: (_) async {
                  normalizeDate(
                    controller.invoiceDate.text,
                    controller.invoiceDate,
                  );
                },
              ),
            ],
          ),

          MenuWithValues(
            labelText: 'Job Number',
            headerLqabel: 'Job Number',
            dialogWidth: double.infinity,
            width: 150,
            controller: controller.jobNumber,
            displayKeys: const [
              'job_number',
              'car_brand_name',
              'car_model_name',
              'plate_number',
              'vehicle_identification_number',
              'customer_name',
            ],
            headerKeys: const [
              'Job Number',
              "Brand",
              'Model',
              "Plate Number",
              "VIN",
              "Customer",
            ],
            flexList: const [1, 1, 1, 1, 1, 2],
            displaySelectedKeys: const ['job_number'],
            onOpen: () {
              return controller.searchEngineForJobCard();
            },
            onDelete: () {
              controller.jobNumber.clear();
              controller.jobNumberId.text = '';
            },
            onSelected: (value) {
              controller.jobNumber.text = value['job_number'] ?? '';
              controller.jobNumberId.text = value['_id'] ?? '';
            },
          ),
          myTextFormFieldWithBorder(
            maxLines: 8,
            labelText: 'Note',
            controller: controller.invoiceNote,
          ),
        ],
      ),
    ),
  );
}
