import 'vendor_payments_model.dart';

class APPaymentModel {
  String? id;
  String? account;
  String? chequeNumber;
  DateTime? chequeDate;
  String? companyId;
  String? currency;
  String? note;
  DateTime? paymentDate;
  String? paymentNumber;
  String? paymentType;
  int? rate;
  String? status;
  String? vendor;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<VendorPaymentsModel>? invoicesDetails;
  String? vendorName;
  String? paymentTypeName;
  String? accountNumber;
  double? totalGiven;

  APPaymentModel({
    this.id,
    this.account,
    this.chequeNumber,
    this.companyId,
    this.currency,
    this.note,
    this.paymentDate,
    this.paymentNumber,
    this.paymentType,
    this.rate,
    this.status,
    this.vendor,
    this.createdAt,
    this.updatedAt,
    this.invoicesDetails,
    this.vendorName,
    this.paymentTypeName,
    this.accountNumber,
    this.totalGiven,
    this.chequeDate,
  });

  APPaymentModel.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('_id') ? json['_id'] : null;
    account = json.containsKey('account') ? json['account'] : null;
    chequeNumber = json.containsKey('cheque_number')
        ? json['cheque_number']
        : null;
    companyId = json.containsKey('company_id') ? json['company_id'] : null;
    currency = json.containsKey('currency') ? json['currency'] : null;
    note = json.containsKey('note') ? json['note'] : null;

    // ✅ Safe date conversion
    if (json.containsKey('payment_date') && json['payment_date'] != null) {
      paymentDate = DateTime.tryParse(json['payment_date'].toString());
    }

    if (json.containsKey('createdAt') && json['createdAt'] != null) {
      createdAt = DateTime.tryParse(json['createdAt'].toString());
    }

    if (json.containsKey('updatedAt') && json['updatedAt'] != null) {
      updatedAt = DateTime.tryParse(json['updatedAt'].toString());
    }

    if (json.containsKey('cheque_date') && json['cheque_date'] != null) {
      chequeDate = DateTime.tryParse(json['cheque_date'].toString());
    }

    paymentNumber = json.containsKey('payment_number')
        ? json['payment_number']
        : null;
    paymentType = json.containsKey('payment_type')
        ? json['payment_type']
        : null;
    rate = json.containsKey('rate') ? json['rate'] : null;
    status = json.containsKey('status') ? json['status'] : null;
    vendor = json.containsKey('vendor') ? json['vendor'] : null;

    if (json.containsKey('invoices_details') &&
        json['invoices_details'] != null) {
      invoicesDetails = <VendorPaymentsModel>[];
      json['invoices_details'].forEach((v) {
        invoicesDetails!.add(VendorPaymentsModel.fromJson(v));
      });
    }

    vendorName = json.containsKey('vendor_name') ? json['vendor_name'] : null;
    paymentTypeName = json.containsKey('payment_type_name')
        ? json['payment_type_name']
        : null;
    accountNumber = json.containsKey('account_number')
        ? json['account_number']
        : null;
    totalGiven = json.containsKey("total_given") ? json["total_given"] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['_id'] = id;
    data['account'] = account;
    data['cheque_number'] = chequeNumber;
    data['company_id'] = companyId;
    data['currency'] = currency;
    data['note'] = note;
    data['payment_date'] = paymentDate?.toIso8601String();
    data['payment_number'] = paymentNumber;
    data['payment_type'] = paymentType;
    data['rate'] = rate;
    data['status'] = status;
    data['vendor'] = vendor;
    data['createdAt'] = createdAt?.toIso8601String();
    data['updatedAt'] = updatedAt?.toIso8601String();

    if (invoicesDetails != null) {
      data['invoices_details'] = invoicesDetails!
          .map((v) => v.toJson())
          .toList();
    }

    data['vendor_name'] = vendorName;
    data['payment_type_name'] = paymentTypeName;
    data['account_number'] = accountNumber;

    return data;
  }
}
