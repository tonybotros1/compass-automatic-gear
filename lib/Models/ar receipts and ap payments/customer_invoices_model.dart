import 'package:datahubai/Models/ar%20receipts%20and%20ap%20payments/base_model_for_receipts_and_payments.dart';

class CustomerInvoicesModel extends BaseModelForReceiptsAndPayments {
  String receiptId;
  bool? isAdded;
  bool? isModified;
  bool? isDeleted;
  String? id;
  // String jobId;
  // String invoiceDate;

  CustomerInvoicesModel({
    this.receiptId = '',
    this.id = '',
    this.isAdded = false,
    this.isModified = false,
    this.isDeleted = false,
    super.invoiceNumber,
    super.isSelected,
    super.jobId,
    super.invoiceDate,
    super.invoiceAmount,
    super.receiptAmount,
    super.outstandingAmount,
    super.notes,
  });

  // /// Safe fromJson with null checks and defaults
  // factory CustomerInvoicesModel.fromJson(Map<String, dynamic> json) {
  //   return CustomerInvoicesModel(
  //     id: json['_id'] ?? '',
  //     invoiceNumber: json['invoice_number']?.toString() ?? '',
  //     isSelected: json['is_selected'] == true,
  //     jobId: json['job_id']?.toString() ?? '',
  //     invoiceDate: json['invoice_date']?.toString() ?? '',
  //     receiptId:json.containsKey('receipt_id') ? json['receipt_id'] ?? '' : "",
  //     invoiceAmount:
  //         double.tryParse(json['invoice_amount']?.toString() ?? '') ?? 0,
  //     receiptAmount:
  //         double.tryParse(json['receipt_amount']?.toString() ?? '') ?? 0,
  //     outstandingAmount:
  //         double.tryParse(json['outstanding_amount']?.toString() ?? '') ?? 0,
  //     notes: json['notes']?.toString() ?? '',
  //   );
  // }

  /// Safe fromJson with detailed error reporting
  factory CustomerInvoicesModel.fromJson(Map<String, dynamic> json) {
    try {
      return CustomerInvoicesModel(
        id: json['_id'] ?? '',
        invoiceNumber: json['invoice_number']?.toString() ?? '',
        isSelected: json['is_selected'] == true,
        jobId: json['job_id']?.toString() ?? '',
        invoiceDate: json['invoice_date']?.toString() ?? '',
        receiptId: json.containsKey('receipt_id')
            ? json['receipt_id']?.toString() ?? ''
            : '',
        invoiceAmount:
            double.tryParse(json['invoice_amount']?.toString() ?? '') ?? 0,
        receiptAmount:
            double.tryParse(json['receipt_amount']?.toString() ?? '') ?? 0,
        outstandingAmount:
            double.tryParse(json['outstanding_amount']?.toString() ?? '') ?? 0,
        notes: json['notes']?.toString() ?? '',
      );
    } catch (e, stackTrace) {
      throw FormatException(
        'CustomerInvoicesModel.fromJson failed.\n'
        'Error: $e\n'
        'JSON: $json\n'
        'StackTrace: $stackTrace',
      );
    }
  }

  CustomerInvoicesModel clone() {
    return CustomerInvoicesModel(
      id: id,
      isAdded: isAdded,
      isModified: isModified,
      isDeleted: isDeleted,
      invoiceNumber: invoiceNumber,
      isSelected: isSelected,
      jobId: jobId,
      invoiceDate: invoiceDate,
      invoiceAmount: invoiceAmount,
      receiptAmount: receiptAmount,
      outstandingAmount: outstandingAmount,
      notes: notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'job_id': jobId,
      'amount': receiptAmount,
      'is_added': isAdded,
      'is_modified': isModified,
      'is_deleted': isDeleted,
      'id': id,
      'receipt_id': receiptId,
    };
  }
}
