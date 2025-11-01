class APPaymentModel {
  String? id;
  String? account;
  String? chequeNumber;
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
  List<InvoicesDetails>? invoicesDetails;
  String? vendorName;
  String? paymentTypeName;
  String? accountNumber;

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
  });

  APPaymentModel.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('_id') ? json['_id'] : null;
    account = json.containsKey('account') ? json['account'] : null;
    chequeNumber = json.containsKey('cheque_number') ? json['cheque_number'] : null;
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

    paymentNumber = json.containsKey('payment_number') ? json['payment_number'] : null;
    paymentType = json.containsKey('payment_type') ? json['payment_type'] : null;
    rate = json.containsKey('rate') ? json['rate'] : null;
    status = json.containsKey('status') ? json['status'] : null;
    vendor = json.containsKey('vendor') ? json['vendor'] : null;

    if (json.containsKey('invoices_details') && json['invoices_details'] != null) {
      invoicesDetails = <InvoicesDetails>[];
      json['invoices_details'].forEach((v) {
        invoicesDetails!.add(InvoicesDetails.fromJson(v));
      });
    }

    vendorName = json.containsKey('vendor_name') ? json['vendor_name'] : null;
    paymentTypeName =
        json.containsKey('payment_type_name') ? json['payment_type_name'] : null;
    accountNumber = json.containsKey('account_number') ? json['account_number'] : null;
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
      data['invoices_details'] =
          invoicesDetails!.map((v) => v.toJson()).toList();
    }

    data['vendor_name'] = vendorName;
    data['payment_type_name'] = paymentTypeName;
    data['account_number'] = accountNumber;

    return data;
  }
}

class InvoicesDetails {
  String? id;
  int? receiptAmount;
  int? outstandingAmount;
  bool? isSelected;
  String? apInvoiceId;
  String? invoiceNumber;
  String? invoiceDate;
  int? invoiceAmount;
  String? notes;

  InvoicesDetails({
    this.id,
    this.receiptAmount,
    this.outstandingAmount,
    this.isSelected,
    this.apInvoiceId,
    this.invoiceNumber,
    this.invoiceDate,
    this.invoiceAmount,
    this.notes,
  });

  InvoicesDetails.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('_id') ? json['_id'] : null;
    receiptAmount = json.containsKey('receipt_amount') ? json['receipt_amount'] : null;
    outstandingAmount =
        json.containsKey('outstanding_amount') ? json['outstanding_amount'] : null;
    isSelected = json.containsKey('is_selected') ? json['is_selected'] : null;
    apInvoiceId = json.containsKey('ap_invoice_id') ? json['ap_invoice_id'] : null;
    invoiceNumber = json.containsKey('invoice_number') ? json['invoice_number'] : null;
    invoiceDate = json.containsKey('invoice_date') ? json['invoice_date'] : null;
    invoiceAmount = json.containsKey('invoice_amount') ? json['invoice_amount'] : null;
    notes = json.containsKey('notes') ? json['notes'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['_id'] = id;
    data['receipt_amount'] = receiptAmount;
    data['outstanding_amount'] = outstandingAmount;
    data['is_selected'] = isSelected;
    data['ap_invoice_id'] = apInvoiceId;
    data['invoice_number'] = invoiceNumber;
    data['invoice_date'] = invoiceDate;
    data['invoice_amount'] = invoiceAmount;
    data['notes'] = notes;

    return data;
  }
}
