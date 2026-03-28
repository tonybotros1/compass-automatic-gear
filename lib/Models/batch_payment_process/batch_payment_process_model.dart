import 'batch_payment_process_items_model.dart';

class BatchPaymentProcessModel {
  String? id;
  String? companyId;
  DateTime? batchDate;
  String? note;
  String? paymentType;
  String? chequeNumber;
  DateTime? chequeDate;
  String? account;
  String? currency;
  double? rate;
  String? status;
  String? batchNumber;
  List<BatchPaymentProcessItemsModel>? itemsDetails;
  String? accountName;
  String? paymentTypeName;

  BatchPaymentProcessModel({
    this.id,
    this.companyId,
    this.batchDate,
    this.note,
    this.paymentType,
    this.chequeNumber,
    this.chequeDate,
    this.account,
    this.currency,
    this.rate,
    this.status,
    this.batchNumber,
    this.itemsDetails,
    this.accountName,
    this.paymentTypeName,
  });

  BatchPaymentProcessModel.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('_id') ? json['_id'] ?? '' : '';
    companyId = json.containsKey('company_id') ? json['company_id'] ?? '' : '';
    batchDate = json.containsKey('batch_date')
        ? json['batch_date'] != null
              ? DateTime.tryParse(json['batch_date'])
              : null
        : null;

    note = json.containsKey('note') ? json['note'] ?? '' : '';
    paymentType = json.containsKey('payment_type')
        ? json['payment_type'] ?? ''
        : '';
    chequeNumber = json.containsKey('cheque_number')
        ? json['cheque_number'] ?? ''
        : '';
    chequeDate = json.containsKey('cheque_date')
        ? json['cheque_date'] != null
              ? DateTime.tryParse(json['cheque_date'])
              : null
        : null;
    account = json.containsKey('account') ? json['account'] ?? '' : '';
    currency = json.containsKey('currency') ? json['currency'] ?? '' : '';
    rate = json.containsKey('rate') ? json['rate'] ?? 0 : 0;
    status = json.containsKey('status') ? json['status'] ?? '' : '';
    batchNumber = json.containsKey('batch_number')
        ? json['batch_number'] ?? ''
        : '';
    if (json['items_details'] != null && json.containsKey('items_details')) {
      itemsDetails = <BatchPaymentProcessItemsModel>[];
      json['items_details'].forEach((v) {
        itemsDetails!.add(BatchPaymentProcessItemsModel.fromJson(v));
      });
    }
    accountName = json.containsKey('account_name')
        ? json['account_name'] ?? ''
        : '';
    paymentTypeName = json.containsKey('payment_type_name')
        ? json['payment_type_name'] ?? ''
        : '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['company_id'] = companyId;
    data['batch_date'] = batchDate;
    data['note'] = note;
    data['payment_type'] = paymentType;
    data['cheque_number'] = chequeNumber;
    data['cheque_date'] = chequeDate;
    data['account'] = account;
    data['currency'] = currency;
    data['rate'] = rate;
    data['status'] = status;
    data['batch_number'] = batchNumber;
    // if (itemsDetails != null) {
    //   data['items_details'] = itemsDetails!.map((v) => v.toJson()).toList();
    // }
    data['account_name'] = accountName;
    data['payment_type_name'] = paymentTypeName;
    return data;
  }
}
