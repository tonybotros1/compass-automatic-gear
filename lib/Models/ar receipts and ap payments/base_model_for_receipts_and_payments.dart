class BaseModelForReceiptsAndPayments {
  // receipts
  String jobId;
  double receiptAmount;
  // payments
  String apInvoiceId;
  double paymentAmount;

  // common
  String invoiceNumber;
  String invoiceDate;
  double invoiceAmount;
  double outstandingAmount;
  String notes;
  bool isSelected;

  BaseModelForReceiptsAndPayments({
    this.apInvoiceId = '',
    this.paymentAmount = 0,
    this.invoiceNumber = '',
    this.isSelected = false,
    this.jobId = '',
    this.invoiceDate = '',
    this.invoiceAmount = 0,
    this.receiptAmount = 0,
    this.outstandingAmount = 0,
    this.notes = '',
  });
}
