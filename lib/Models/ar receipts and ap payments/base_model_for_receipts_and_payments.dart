class BaseModelForReceiptsAndPayments {
  String invoiceNumber;
  bool isSelected;
  String jobId;
  String invoiceDate;
  double invoiceAmount;
  double receiptAmount;
  double outstandingAmount;
  String notes;

  BaseModelForReceiptsAndPayments({
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
