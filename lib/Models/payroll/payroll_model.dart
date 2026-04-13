class PayrollModel {
  final String? id;
  final String? name;
  final String? periodType;
  final DateTime? firstPeriodStartDate;
  final int? numberOfYears;
  final String? apInvoiceType;
  final String? apInvoiceTypeName;
  final String? status;

  PayrollModel({
    this.id,
    this.name,
    this.apInvoiceType,
    this.apInvoiceTypeName,
    this.firstPeriodStartDate,
    this.numberOfYears,
    this.periodType,
    this.status,
  });

  factory PayrollModel.fromJson(Map<String, dynamic> json) {
    return PayrollModel(
      id: json.containsKey('_id') ? json['_id'] ?? '' : '',
      name: json.containsKey('name') ? json['name'] ?? '' : '',
      periodType: json.containsKey('period_type')
          ? json['period_type'] ?? ''
          : '',
      firstPeriodStartDate: json.containsKey('first_period_start_date')
          ? json['first_period_start_date'] != null
                ? DateTime.tryParse(json['first_period_start_date'])
                : null
          : null,
      numberOfYears: json.containsKey('number_of_years')
          ? json['number_of_years'] ?? ''
          : '',
      apInvoiceType: json.containsKey('ap_invoice_type')
          ? json['ap_invoice_type'] ?? ''
          : '',
      apInvoiceTypeName: json.containsKey('ap_invoice_type_name')
          ? json['ap_invoice_type_name'] ?? ""
          : "",
      status: json.containsKey('status') ? json['status'] ?? "" : "",
    );
  }
}
