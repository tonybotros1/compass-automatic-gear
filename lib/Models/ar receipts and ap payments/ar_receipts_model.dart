import 'customer_invoices_model.dart';

class ARReceiptsModel {
  String? id;
  String? status;
  DateTime? receiptDate;
  String? customer;
  String? note;
  String? receiptType;
  String? chequeNumber;
  String? bankName;
  String? bankNameId;
  String? account;
  String? currency;
  double? rate;
  double? totalReceived;
  String? companyId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? receiptNumber;
  DateTime? chequeDate;
  List<CustomerInvoicesModel>? invoicesDetails;
  String? customerName;
  String? receiptTypeName;
  String? accountNumber;

  ARReceiptsModel({
    this.id,
    this.status,
    this.receiptDate,
    this.customer,
    this.note,
    this.receiptType,
    this.chequeNumber,
    this.bankName,
    this.account,
    this.currency,
    this.rate,
    this.companyId,
    this.createdAt,
    this.updatedAt,
    this.receiptNumber,
    this.chequeDate,
    this.invoicesDetails,
    this.customerName,
    this.receiptTypeName,
    this.accountNumber,
    this.totalReceived,
    this.bankNameId,
  });

  ARReceiptsModel.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('_id') ? json['_id']?.toString() : null;
    status = json.containsKey('status') ? json['status']?.toString() : null;
    receiptDate =
        json.containsKey('receipt_date') && json['receipt_date'] != null
        ? DateTime.tryParse(json['receipt_date'].toString())
        : null;
    customer = json.containsKey('customer')
        ? json['customer']?.toString()
        : null;
    totalReceived = json.containsKey('total_received')
        ? json['total_received']
        : null;
    note = json.containsKey('note') ? json['note']?.toString() : null;
    receiptType = json.containsKey('receipt_type')
        ? json['receipt_type']?.toString()
        : null;
    chequeNumber = json.containsKey('cheque_number')
        ? json['cheque_number']?.toString()
        : null;
    bankName = json.containsKey('bank_name')
        ? json['bank_name']?.toString()
        : null;
    bankNameId = json.containsKey('bank_name_id')
        ? json['bank_name_id']?.toString()
        : null;
    account = json.containsKey('account') ? json['account']?.toString() : null;
    currency = json.containsKey('currency')
        ? json['currency']?.toString()
        : null;
    rate = json.containsKey('rate') ? json['rate'] : 1;
    companyId = json.containsKey('company_id')
        ? json['company_id']?.toString()
        : null;
    createdAt = json.containsKey('createdAt') && json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'].toString())
        : null;
    updatedAt = json.containsKey('updatedAt') && json['updatedAt'] != null
        ? DateTime.tryParse(json['updatedAt'].toString())
        : null;
    receiptNumber = json.containsKey('receipt_number')
        ? json['receipt_number']?.toString()
        : null;
    chequeDate = json.containsKey('cheque_date') && json['cheque_date'] != null
        ? DateTime.tryParse(json['cheque_date'].toString())
        : null;

    if (json.containsKey('invoices_details') &&
        json['invoices_details'] is List) {
      invoicesDetails = json['invoices_details']
          .map<CustomerInvoicesModel>((v) => CustomerInvoicesModel.fromJson(v))
          .toList();
    } else {
      invoicesDetails = [];
    }

    //  try {
    //   final items = json['invoices_details'];

    //   if (items is List) {
    //     for (int i = 0; i < items.length; i++) {
    //       try {
    //         invoicesDetails!.add(
    //           CustomerInvoicesModel.fromJson(items[i]),
    //         );
    //       } catch (e, stack) {
    //         // 🔴 Error in a specific item
    //         debugPrint(
    //           '❌ Failed to parse invoice item at index $i\n'
    //           'Item data: ${items[i]}\n'
    //           'Error: $e',
    //         );
    //         return;

    //         // Optional: send to crash reporting
    //         // FirebaseCrashlytics.instance.recordError(e, stack);
    //       }
    //     }
    //   } else {
    //     debugPrint(
    //       '❌ invoice_items_details is not a List. '
    //       'Actual type: ${items.runtimeType}',
    //     );
    //   }
    // } catch (e, stack) {
    //   // 🔴 Critical error (JSON shape problem)
    //   debugPrint(
    //     '🔥 Failed to parse invoice_items_details\n'
    //     'Error: $e',
    //   );

    //   // Optional crash reporting
    //   // FirebaseCrashlytics.instance.recordError(e, stack);
    // }

    customerName = json.containsKey('customer_name')
        ? json['customer_name']?.toString()
        : null;
    receiptTypeName = json.containsKey('receipt_type_name')
        ? json['receipt_type_name']?.toString()
        : null;
    accountNumber = json.containsKey('account_number')
        ? json['account_number']?.toString()
        : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['status'] = status;
    data['receipt_date'] = receiptDate;
    data['customer'] = customer;
    data['note'] = note;
    data['receipt_type'] = receiptType;
    data['cheque_number'] = chequeNumber;
    data['bank_name'] = bankName;
    data['account'] = account;
    data['currency'] = currency;
    data['rate'] = rate;
    data['company_id'] = companyId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['receipt_number'] = receiptNumber;
    data['cheque_date'] = chequeDate;
    if (invoicesDetails != null) {
      data['invoices_details'] = invoicesDetails!
          .map((v) => v.toJson())
          .toList();
    }
    data['customer_name'] = customerName;
    data['receipt_type_name'] = receiptTypeName;
    data['account_number'] = accountNumber;
    return data;
  }
}
