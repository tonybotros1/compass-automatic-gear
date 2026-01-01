//
import 'vendor_payments_model.dart';

class APPaymentModel {
  final String? id;
  final String? account;
  final String? chequeNumber;
  final DateTime? chequeDate;
  final String? companyId;
  final String? currency;
  final String? note;
  final DateTime? paymentDate;
  final String? paymentNumber;
  final String? paymentType;
  final int? rate;
  final String? status;
  final String? vendor;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<VendorPaymentsModel> invoicesDetails; // 🔥 non-nullable
  final String? vendorName;
  final String? paymentTypeName;
  final String? accountNumber;
  final double totalGiven;

  APPaymentModel({
    this.id,
    this.account,
    this.chequeNumber,
    this.chequeDate,
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
    required this.invoicesDetails,
    this.vendorName,
    this.paymentTypeName,
    this.accountNumber,
    required this.totalGiven,
  });

  factory APPaymentModel.fromJson(Map<String, dynamic> json) {
    return APPaymentModel(
      id: json['_id'],
      account: json['account'],
      chequeNumber: json['cheque_number'],
      chequeDate: json['cheque_date'] != null
          ? DateTime.tryParse(json['cheque_date'].toString())
          : null,
      companyId: json['company_id'],
      currency: json['currency'],
      note: json['note'],
      paymentDate: json['payment_date'] != null
          ? DateTime.tryParse(json['payment_date'].toString())
          : null,
      paymentNumber: json['payment_number'],
      paymentType: json['payment_type'],
      rate: json['rate'],
      status: json['status'],
      vendor: json['vendor'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      invoicesDetails:
          (json['invoices_details'] as List?)
              ?.map((e) => VendorPaymentsModel.fromJson(e))
              .toList() ??
          const [], // 🔥 always initialized
      vendorName: json['vendor_name'],
      paymentTypeName: json['payment_type_name'],
      accountNumber: json['account_number'],
      totalGiven: (json['total_given'] ?? 0).toDouble(),
    );
  }

  APPaymentModel copyWith({
    List<VendorPaymentsModel>? invoicesDetails,
    final double? totalGiven,
  }) {
    return APPaymentModel(
      id: id,
      account: account,
      chequeNumber: chequeNumber,
      chequeDate: chequeDate,
      companyId: companyId,
      currency: currency,
      note: note,
      paymentDate: paymentDate,
      paymentNumber: paymentNumber,
      paymentType: paymentType,
      rate: rate,
      status: status,
      vendor: vendor,
      createdAt: createdAt,
      updatedAt: updatedAt,
      invoicesDetails:
          invoicesDetails ?? List.from(this.invoicesDetails), // 🔥 preserve
      vendorName: vendorName,
      paymentTypeName: paymentTypeName,
      accountNumber: accountNumber,
      totalGiven: totalGiven ?? this.totalGiven,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "account": account,
    "cheque_number": chequeNumber,
    "cheque_date": chequeDate?.toIso8601String(),
    "company_id": companyId,
    "currency": currency,
    "note": note,
    "payment_date": paymentDate?.toIso8601String(),
    "payment_number": paymentNumber,
    "payment_type": paymentType,
    "rate": rate,
    "status": status,
    "vendor": vendor,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "invoices_details": invoicesDetails.map((e) => e.toJson()).toList(),
    "vendor_name": vendorName,
    "payment_type_name": paymentTypeName,
    "account_number": accountNumber,
    "total_given": totalGiven,
  };
}
