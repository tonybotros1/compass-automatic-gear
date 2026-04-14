class PayrollRunsModel {
  final String? id;
  final String? runNumber;
  final String? payrollName;
  final String? periodName;
  final String? description;
  final String? paymentNumber;

  PayrollRunsModel({
    this.id,
    this.runNumber,
    this.payrollName,
    this.periodName,
    this.description,
    this.paymentNumber,
  });

  factory PayrollRunsModel.fromJson(Map<String, dynamic> json) {
    return PayrollRunsModel(
      id: json.containsKey('_id') ? json['_id'] ?? '' : '',
      runNumber: json.containsKey('run_number') ? json['run_number'] ?? '' : '',
      payrollName: json.containsKey('payroll_name')
          ? json['payroll_name'] ?? ""
          : "",
      periodName: json.containsKey('period_name')
          ? json['period_name'] ?? ""
          : "",
      description: json.containsKey('description')
          ? json['description'] ?? ""
          : "",
      paymentNumber: json.containsKey('payment_number')
          ? json['payment_number'] ?? ''
          : '',
    );
  }
}
