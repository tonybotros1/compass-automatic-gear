// class ApInvoicesModel {
//   ApInvoicesModel({
//     required this.id,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.companyId,
//     required this.description,
//     required this.invoiceDate,
//     required this.invoiceNumber,
//     required this.invoiceType,
//     required this.referenceNumber,
//     required this.status,
//     required this.transactionDate,
//     required this.vendor,
//     required this.items,
//     required this.vendorName,
//     required this.invoiceTypeName,
//     required this.totalAmount,
//     required this.totalVat,
//   });

//   String? id;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   String? companyId;
//   String? description;
//   DateTime? invoiceDate;
//   String? invoiceNumber;
//   String? invoiceType;
//   String? referenceNumber;
//   String? status;
//   DateTime? transactionDate;
//   String? vendor;
//   List<ApInvoicesItem> items;
//   String? vendorName;
//   String? invoiceTypeName;
//   double totalAmount;
//   double totalVat;

//   factory ApInvoicesModel.fromJson(Map<String, dynamic> json) {
//     return ApInvoicesModel(
//       id: json["_id"],
//       createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
//       updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
//       companyId: json["company_id"],
//       description: json["description"],
//       invoiceDate: DateTime.tryParse(json["invoice_date"] ?? ""),
//       invoiceNumber: json["invoice_number"],
//       invoiceType: json["invoice_type"],
//       referenceNumber: json["reference_number"],
//       status: json["status"],
//       transactionDate: DateTime.tryParse(json["transaction_date"] ?? ""),
//       vendor: json["vendor"],
//       items: json["items"] == null
//           ? []
//           : List<ApInvoicesItem>.from(
//               json["items"]!.map((x) => ApInvoicesItem.fromJson(x)),
//             ),
//       vendorName: json["vendor_name"],
//       invoiceTypeName: json["invoice_type_name"],
//       totalAmount: json["total_amounts"] ?? 0,
//       totalVat: json['total_vats'] ?? 0,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "createdAt": createdAt?.toIso8601String(),
//     "updatedAt": updatedAt?.toIso8601String(),
//     "company_id": companyId,
//     "description": description,
//     "invoice_date": invoiceDate?.toIso8601String(),
//     "invoice_number": invoiceNumber,
//     "invoice_type": invoiceType,
//     "reference_number": referenceNumber,
//     "status": status,
//     "transaction_date": transactionDate?.toIso8601String(),
//     "vendor": vendor,
//     "items": items.map((x) => x.toJson()).toList(),
//     "vendor_name": vendorName,
//     "invoice_type_name": invoiceTypeName,
//   };
// }

// class ApInvoicesItem {
//   ApInvoicesItem({
//     this.id,
//     this.uuid,
//     this.ceatedAt,
//     this.updatedAt,
//     required this.amount,
//     required this.jobNumber,
//     required this.jobNumberId,
//     required this.note,
//     required this.transactionType,
//     required this.vat,
//     required this.apInvoiceId,
//     this.transactionTypeName,
//     this.isAdded,
//     this.isDeleted,
//     this.isModified,
//     this.receivedNumber,
//   });

//   String? id;
//   String? uuid;
//   DateTime? ceatedAt;
//   DateTime? updatedAt;
//   double? amount;
//   String? jobNumber;
//   String? jobNumberId;
//   String? note;
//   String? transactionType;
//   double? vat;
//   String? apInvoiceId;
//   String? transactionTypeName;
//   bool? isAdded;
//   bool? isDeleted;
//   bool? isModified;
//   String? receivedNumber;

//   factory ApInvoicesItem.fromJson(Map<String, dynamic> json) {
//     return ApInvoicesItem(
//       id: json["_id"],
//       ceatedAt: DateTime.tryParse(json["ceatedAt"] ?? ""),
//       updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
//       amount: json["amount"] ?? 0,
//       jobNumber: json["job_number"] ?? '',
//       jobNumberId: json["job_number_id"] ?? '',
//       note: json["note"] ?? '',
//       transactionType: json["transaction_type"] ?? '',
//       vat: json["vat"] ?? 0,
//       apInvoiceId: json["ap_invoice_id"] ?? '',
//       transactionTypeName: json["transaction_type_name"] ?? '',
//       receivedNumber: json.containsKey('received_number')
//           ? json['received_number']?.toString() ?? ''
//           : '',
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "uuid": uuid,
//     "amount": amount,
//     "job_number": jobNumber,
//     "job_number_id" : jobNumberId,
//     "note": note,
//     "received_number" : receivedNumber,
//     "transaction_type": transactionType,
//     "vat": vat,
//     "ap_invoice_id": apInvoiceId,
//     "is_added": isAdded,
//     "is_deleted": isDeleted,
//     "is_modified": isModified,
//   };
// }

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
      items:
          (json["items"] as List?)
              ?.map((e) => ApInvoicesItem.fromJson(e))
              .toList() ??
          const [],
      vendorName: json["vendor_name"],
      invoiceTypeName: json["invoice_type_name"],
      totalAmount: (json["total_amounts"] ?? 0).toDouble(),
      totalVat: (json["total_vats"] ?? 0).toDouble(),
    );
  }

  ApInvoicesModel copyWith({List<ApInvoicesItem>? items}) {
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
      totalAmount: totalAmount,
      totalVat: totalVat,
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
      id: json["_id"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      amount: (json["amount"] ?? 0).toDouble(),
      jobNumber: json["job_number"] ?? '',
      jobNumberId: json["job_number_id"] ?? '',
      note: json["note"] ?? '',
      transactionType: json["transaction_type"] ?? '',
      vat: (json["vat"] ?? 0).toDouble(),
      apInvoiceId: json["ap_invoice_id"] ?? '',
      transactionTypeName: json["transaction_type_name"],
      receivedNumber: json["received_number"]?.toString(),
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
