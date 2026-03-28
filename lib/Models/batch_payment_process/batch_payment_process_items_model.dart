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
  final String? receivingNumberId;
  final String? jobNumber;
  final String? jobNumberId;
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
    this.receivingNumberId,
    this.vat,
    this.vendorName,
    this.vendor,
    this.jobNumberId,
  });

  factory BatchPaymentProcessItemsModel.fromJson(Map<String, dynamic> json) {
    return BatchPaymentProcessItemsModel(
      id: json['_id'] ?? '',
      transactionTypeName: json.containsKey('transaction_type_name')
          ? json['transaction_type_name']
          : '',
      transactionType: json.containsKey('transaction_type')
          ? json['transaction_type']
          : '',
      amount: json.containsKey('amount') ? json['amount'] ?? 0 : 0,
      vat: json.containsKey('vat') ? json['vat'] ?? 0 : 0,
      invoiceNumber: json.containsKey('invoice_number')
          ? json['invoice_number'] ?? ''
          : '',
      invoiceDate: json.containsKey('invoice_date')
          ? json['invoice_date'] != null
                ? DateTime.tryParse(json['invoice_date'])
                : null
          : null,

      note: json.containsKey('note') ? json['note'] ?? '' : '',
      vendor: json.containsKey('vendor') ? json['vendor'] ?? '' : '',
      vendorName: json.containsKey('vendor_name')
          ? json['vendor_name'] ?? ''
          : '',
      receivingNumber: json.containsKey('receiving_number')
          ? json['receiving_number'] ?? ''
          : '',
      receivingNumberId: json.containsKey('received_number')
          ? json['received_number'] ?? ''
          : '',
      jobNumber: json.containsKey('job_number') ? json['job_number'] ?? '' : '',
      jobNumberId: json.containsKey('job_number_id')
          ? json['job_number_id'] ?? ''
          : '',
      createdAt: json.containsKey('createdAt')
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json.containsKey('updatedAt')
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }
}
