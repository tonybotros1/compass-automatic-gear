import 'package:datahubai/Models/ar%20receipts%20and%20ap%20payments/base_model_for_receipts_and_payments.dart';

class VendorPaymentsModel extends BaseModelForReceiptsAndPayments {
  String paymentId;
  bool? isAdded;
  bool? isModified;
  bool? isDeleted;
  String id;

  VendorPaymentsModel({
    this.paymentId = '',
    this.id = '',
    this.isAdded = false,
    this.isModified = false,
    this.isDeleted = false,
    super.invoiceNumber,
    super.isSelected,
    super.apInvoiceId,
    super.invoiceDate,
    super.invoiceAmount,
    super.paymentAmount,
    super.outstandingAmount,
    super.notes,
  });

  /// Safe fromJson with null checks and defaults
  factory VendorPaymentsModel.fromJson(Map<String, dynamic> json) {
    return VendorPaymentsModel(
      id: json['_id'] ?? '',
      invoiceNumber: json['invoice_number']?.toString() ?? '',
      isSelected: json['is_selected'] == true,
      apInvoiceId: json['ap_invoice_id']?.toString() ?? '',
      invoiceDate: json['invoice_date']?.toString() ?? '',
      invoiceAmount:
          double.tryParse(json['invoice_amount']?.toString() ?? '') ?? 0,
      paymentAmount:
          double.tryParse(json['payment_amount']?.toString() ?? '') ?? 0,
      outstandingAmount:
          double.tryParse(json['outstanding_amount']?.toString() ?? '') ?? 0,
      notes: json['notes']?.toString() ?? '',
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'ap_invoice_id': apInvoiceId,
      'amount': receiptAmount,
      'is_added': isAdded,
      'is_modified': isModified,
      'is_deleted': isDeleted,
      'id': id,
      'payment_id' : paymentId
    };
  }
}
