class ApInvoicesModel {
  ApInvoicesModel({
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.companyId,
    this.description,
    this.invoiceDate,
    this.invoiceNumber,
    this.invoiceType,
    this.referenceNumber,
    this.status,
    this.transactionDate,
    this.vendor,
    required this.items,
    this.vendorName,
    this.invoiceTypeName,
    required this.totalAmount,
    required this.totalVat,
  });

  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? companyId;
  final String? description;
  final DateTime? invoiceDate;
  final String? invoiceNumber;
  final String? invoiceType;
  final String? referenceNumber;
  final String? status;
  final DateTime? transactionDate;
  final String? vendor;
  final List<ApInvoicesItem> items; // 🔥 non-nullable
  final String? vendorName;
  final String? invoiceTypeName;
  final double totalAmount;
  final double totalVat;

  factory ApInvoicesModel.fromJson(Map<String, dynamic> json) {
    return ApInvoicesModel(
      id: json.containsKey('_id') ? json["_id"] : '',
      createdAt: json.containsKey('createdAt')
          ? DateTime.tryParse(json["createdAt"] ?? "")
          : null,
      updatedAt: json.containsKey('updatedAt')
          ? DateTime.tryParse(json["updatedAt"] ?? "")
          : null,
      companyId: json.containsKey('company_id') ? json["company_id"] : '',
      description: json.containsKey('description') ? json["description"] : '',
      invoiceDate: json.containsKey('invoice_date')
          ? DateTime.tryParse(json["invoice_date"] ?? "")
          : null,
      invoiceNumber: json.containsKey('invoice_number')
          ? json["invoice_number"]
          : '',
      invoiceType: json.containsKey('invoice_type') ? json["invoice_type"] : '',
      referenceNumber: json.containsKey('reference_number')
          ? json["reference_number"]
          : '',
      status: json.containsKey('status') ? json["status"] : '',
      transactionDate: json.containsKey('transaction_date')
          ? DateTime.tryParse(json["transaction_date"] ?? "")
          : null,
      vendor: json.containsKey('vendor') ? json["vendor"] : '',
      items:
          (json["items"] as List?)
              ?.map((e) => ApInvoicesItem.fromJson(e))
              .toList() ??
          const [],
      vendorName: json.containsKey('vendor_name') ? json["vendor_name"] : '',
      invoiceTypeName: json.containsKey('invoice_type_name')
          ? json["invoice_type_name"]
          : '',
      totalAmount: json.containsKey('total_amounts')
          ? (json["total_amounts"] ?? 0).toDouble()
          : 0,
      totalVat: json.containsKey('total_vats')
          ? (json["total_vats"] ?? 0).toDouble()
          : 0,
    );
  }

  ApInvoicesModel copyWith({
    List<ApInvoicesItem>? items,
    double? totalAmount,
    double? totalVat,
  }) {
    return ApInvoicesModel(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      companyId: companyId,
      description: description,
      invoiceDate: invoiceDate,
      invoiceNumber: invoiceNumber,
      invoiceType: invoiceType,
      referenceNumber: referenceNumber,
      status: status,
      transactionDate: transactionDate,
      vendor: vendor,
      items: items ?? List.from(this.items), // 🔥 preserve
      vendorName: vendorName,
      invoiceTypeName: invoiceTypeName,
      totalAmount: totalAmount ?? this.totalAmount,
      totalVat: totalVat ?? this.totalVat,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "company_id": companyId,
    "description": description,
    "invoice_date": invoiceDate?.toIso8601String(),
    "invoice_number": invoiceNumber,
    "invoice_type": invoiceType,
    "reference_number": referenceNumber,
    "status": status,
    "transaction_date": transactionDate?.toIso8601String(),
    "vendor": vendor,
    "items": items.map((x) => x.toJson()).toList(),
  };
}

class ApInvoicesItem {
  ApInvoicesItem({
    this.id,
    this.uuid,
    this.createdAt,
    this.updatedAt,
    required this.amount,
    required this.jobNumber,
    required this.jobNumberId,
    required this.note,
    required this.transactionType,
    required this.vat,
    required this.apInvoiceId,
    this.transactionTypeName,
    this.isAdded,
    this.isDeleted,
    this.isModified,
    this.receivedNumber,
  });

  final String? id;
  final String? uuid;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final double amount;
  final String jobNumber;
  final String jobNumberId;
  final String note;
  final String transactionType;
  final double vat;
  final String apInvoiceId;
  final String? transactionTypeName;
  final bool? isAdded;
  bool? isDeleted;
  bool? isModified;
  String? receivedNumber;

  factory ApInvoicesItem.fromJson(Map<String, dynamic> json) {
    return ApInvoicesItem(
      id: json.containsKey('_id') ? json["_id"] : '',
      createdAt: json.containsKey('createdAt')
          ? DateTime.tryParse(json["createdAt"] ?? "")
          : null,
      updatedAt: json.containsKey('updatedAt')
          ? DateTime.tryParse(json["updatedAt"] ?? "")
          : null,
      amount: json.containsKey('amount') ? (json["amount"] ?? 0).toDouble() : 0,
      jobNumber: json.containsKey('job_number') ? json["job_number"] ?? '' : '',
      jobNumberId: json.containsKey('job_number_id')
          ? json["job_number_id"] ?? ''
          : null,
      note: json.containsKey('note') ? json["note"] ?? '' : null,
      transactionType: json.containsKey('transaction_type')
          ? json["transaction_type"] ?? ''
          : null,
      vat: json.containsKey('vat') ? (json["vat"] ?? 0).toDouble() : 0,
      apInvoiceId: json.containsKey('ap_invoice_id')
          ? json["ap_invoice_id"] ?? ''
          : '',
      transactionTypeName: json.containsKey('transaction_type_name')
          ? json["transaction_type_name"]
          : '',
      receivedNumber: json.containsKey('received_number')
          ? json["received_number"]?.toString()
          : '',
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "uuid": uuid,
    "amount": amount,
    "job_number": jobNumber,
    "job_number_id": jobNumberId,
    "note": note,
    "received_number": receivedNumber,
    "transaction_type": transactionType,
    "vat": vat,
    "ap_invoice_id": apInvoiceId,
    "is_added": isAdded,
    "is_deleted": isDeleted,
    "is_modified": isModified,
  };
}
