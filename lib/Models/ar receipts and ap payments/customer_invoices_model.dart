// import 'package:uuid/uuid.dart';

// class CustomerInvoicesModel {
//   String id;
//   String invoiceNumber;
//   bool isSelected;
//   String jobId;
//   String invoiceDate;
//   double invoiceAmount;
//   double receiptAmount;
//   double outstandingAmount;
//   String notes;

//   CustomerInvoicesModel({
//     this.id = '',
//     this.invoiceNumber = '',
//     this.isSelected = false,
//     this.jobId = '',
//     this.invoiceDate = '',
//     this.invoiceAmount = 0,
//     this.receiptAmount = 0,
//     this.outstandingAmount = 0,
//     this.notes = '',
//   });

//   // Safe fromJson with null checks and defaults
//   factory CustomerInvoicesModel.fromJson(Map<String, dynamic> json) {
//     final Uuid uuid = const Uuid();

//     return CustomerInvoicesModel(
//       id: uuid.v4(),
//       invoiceNumber:
//           json.containsKey('invoice_number') && json['invoice_number'] != null
//           ? json['invoice_number'].toString()
//           : '',
//       isSelected: json.containsKey('is_selected') && json['is_selected'] != null
//           ? json['is_selected'] as bool
//           : false,
//       jobId: json.containsKey('job_id') && json['job_id'] != null
//           ? json['job_id'].toString()
//           : '',
//       invoiceDate:
//           json.containsKey('invoice_date') && json['invoice_date'] != null
//           ? json['invoice_date'].toString()
//           : '',
//       invoiceAmount:
//           json.containsKey('invoice_amount') && json['invoice_amount'] != null
//           ? double.tryParse(json['invoice_amount']) ?? 0
//           : 0,
//       receiptAmount:
//           json.containsKey('receipt_amount') && json['receipt_amount'] != null
//           ? double.tryParse(json['receipt_amount']) ?? 0
//           : 0,
//       outstandingAmount:
//           json.containsKey('outstanding_amount') &&
//               json['outstanding_amount'] != null
//           ? double.tryParse(json['outstanding_amount']) ?? 0
//           : 0,
//       notes: json.containsKey('notes') && json['notes'] != null
//           ? json['notes'].toString()
//           : '',
//     );
//   }

//   // Safe toJson
//   Map<String, dynamic> toJson() {
//     return {
//       'invoice_number': invoiceNumber,
//       'is_selected': isSelected,
//       'job_id': jobId,
//       'invoice_date': invoiceDate,
//       'invoice_amount': invoiceAmount,
//       'receipt_amount': receiptAmount,
//       'outstanding_amount': outstandingAmount,
//       'notes': notes,
//     };
//   }
// }

import 'package:datahubai/Models/ar%20receipts%20and%20ap%20payments/base_model_for_receipts_and_payments.dart';

class CustomerInvoicesModel extends BaseModelForReceiptsAndPayments {
  String receiptId;
  bool? isAdded;
  bool? isModified;
  bool? isDeleted;
  String id;
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

  /// Safe fromJson with null checks and defaults
  factory CustomerInvoicesModel.fromJson(Map<String, dynamic> json) {
    return CustomerInvoicesModel(
      id: json['_id'] ?? '',
      invoiceNumber: json['invoice_number']?.toString() ?? '',
      isSelected: json['is_selected'] == true,
      jobId: json['job_id']?.toString() ?? '',
      invoiceDate: json['invoice_date']?.toString() ?? '',
      invoiceAmount:
          double.tryParse(json['invoice_amount']?.toString() ?? '') ?? 0,
      receiptAmount:
          double.tryParse(json['receipt_amount']?.toString() ?? '') ?? 0,
      outstandingAmount:
          double.tryParse(json['outstanding_amount']?.toString() ?? '') ?? 0,
      notes: json['notes']?.toString() ?? '',
    );
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
      'receipt_id' : receiptId
    };
  }
}
