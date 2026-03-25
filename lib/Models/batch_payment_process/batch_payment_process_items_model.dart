class BatchPaymentProcessItemsModel {
  final String? id;
  final String? transactionTypeName;
  final String? transactionType;
  final String? invoiceNumber;
  final DateTime? invoiceDate;
  final double? amount;
  final double? vat;
  final String? vendorName;
  final String? vendor;
  final String? note;
  final String? receivingNumber;
  final String? jobNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BatchPaymentProcessItemsModel({
    this.id,
    this.transactionType,
    this.transactionTypeName,
    this.note,
    this.invoiceNumber,
    this.invoiceDate,
    this.createdAt,
    this.updatedAt,
    this.amount,
    this.jobNumber,
    this.receivingNumber,
    this.vat,
    this.vendorName,
    this.vendor,
  });

  factory BatchPaymentProcessItemsModel.fromJson(Map<String, dynamic> json) {
    return BatchPaymentProcessItemsModel(
      id: json['_id'] ?? '',
      amount: json.containsKey('amount') ? json['amount'] ?? 0 : 0,
      vat: json.containsKey('vat') ? json['vat'] ?? 0 : 0,
      invoiceNumber: json.containsKey('invoice_number')
          ? json['invoice_number'] ?? ''
          : '',
      invoiceDate: json.containsKey('invoice_date')
          ? DateTime.tryParse(json['invoice_date'])
          : null,
      note: json.containsKey('note') ? json['note'] ?? '' : '',
      vendor: json.containsKey('vendor') ? json['vendor'] ?? '' : '',
      vendorName: json.containsKey('vendor_name')
          ? json['vendor_name'] ?? ''
          : '',
      receivingNumber: json.containsKey('receiving_number')
          ? json['receiving_number'] ?? ''
          : '',
      jobNumber: json.containsKey('job_number') ? json['job_number'] ?? '' : '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
