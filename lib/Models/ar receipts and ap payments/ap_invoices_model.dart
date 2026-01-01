class ApInvoicesModel {
  ApInvoicesModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.companyId,
    required this.description,
    required this.invoiceDate,
    required this.invoiceNumber,
    required this.invoiceType,
    required this.referenceNumber,
    required this.status,
    required this.transactionDate,
    required this.vendor,
    required this.items,
    required this.vendorName,
    required this.invoiceTypeName,
    required this.totalAmount,
    required this.totalVat,
  });

  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? companyId;
  String? description;
  DateTime? invoiceDate;
  String? invoiceNumber;
  String? invoiceType;
  String? referenceNumber;
  String? status;
  DateTime? transactionDate;
  String? vendor;
  List<ApInvoicesItem>? items;
  String? vendorName;
  String? invoiceTypeName;
  double totalAmount;
  double totalVat;

  factory ApInvoicesModel.fromJson(Map<String, dynamic> json) {
    return ApInvoicesModel(
      id: json["_id"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      companyId: json["company_id"],
      description: json["description"],
      invoiceDate: DateTime.tryParse(json["invoice_date"] ?? ""),
      invoiceNumber: json["invoice_number"],
      invoiceType: json["invoice_type"],
      referenceNumber: json["reference_number"],
      status: json["status"],
      transactionDate: DateTime.tryParse(json["transaction_date"] ?? ""),
      vendor: json["vendor"],
      items: json["items"] == null
          ? []
          : List<ApInvoicesItem>.from(
              json["items"]!.map((x) => ApInvoicesItem.fromJson(x)),
            ),
      vendorName: json["vendor_name"],
      invoiceTypeName: json["invoice_type_name"],
      totalAmount: json["total_amounts"] ?? 0,
      totalVat: json['total_vats'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "company_id": companyId,
    "description": description,
    "invoice_date": invoiceDate?.toIso8601String(),
    "invoice_number": invoiceNumber,
    "invoice_type": invoiceType,
    "reference_number": referenceNumber,
    "status": status,
    "transaction_date": transactionDate?.toIso8601String(),
    "vendor": vendor,
    "items": items?.map((x) => x.toJson()).toList() ?? [],
    "vendor_name": vendorName,
    "invoice_type_name": invoiceTypeName,
  };
}

class ApInvoicesItem {
  ApInvoicesItem({
    this.id,
    this.uuid,
    this.ceatedAt,
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

  String? id;
  String? uuid;
  DateTime? ceatedAt;
  DateTime? updatedAt;
  double? amount;
  String? jobNumber;
  String? jobNumberId;
  String? note;
  String? transactionType;
  double? vat;
  String? apInvoiceId;
  String? transactionTypeName;
  bool? isAdded;
  bool? isDeleted;
  bool? isModified;
  String? receivedNumber;

  factory ApInvoicesItem.fromJson(Map<String, dynamic> json) {
    return ApInvoicesItem(
      id: json["_id"],
      ceatedAt: DateTime.tryParse(json["ceatedAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      amount: json["amount"] ?? 0,
      jobNumber: json["job_number"] ?? '',
      jobNumberId: json["job_number_id"] ?? '',
      note: json["note"] ?? '',
      transactionType: json["transaction_type"] ?? '',
      vat: json["vat"] ?? 0,
      apInvoiceId: json["ap_invoice_id"] ?? '',
      transactionTypeName: json["transaction_type_name"] ?? '',
      receivedNumber: json.containsKey('received_number')
          ? json['received_number']?.toString() ?? ''
          : '',
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "uuid": uuid,
    "amount": amount,
    "job_number": jobNumber,
    "job_number_id" : jobNumberId,
    "note": note,
    "received_number" : receivedNumber,
    "transaction_type": transactionType,
    "vat": vat,
    "ap_invoice_id": apInvoiceId,
    "is_added": isAdded,
    "is_deleted": isDeleted,
    "is_modified": isModified,
  };
}
