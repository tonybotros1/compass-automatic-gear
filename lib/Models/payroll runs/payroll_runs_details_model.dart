double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

String _toStr(dynamic value) => value?.toString() ?? '';

class PayrollRunDetailsModel {
  String? runNumber;
  String? description;
  String? paymentNumber;
  List<PayrollRunsEmployeeModel>? employeesDetails;
  String? id;
  String? payrollName;
  String? periodName;

  PayrollRunDetailsModel({
    this.runNumber,
    this.description,
    this.paymentNumber,
    this.employeesDetails,
    this.id,
    this.payrollName,
    this.periodName,
  });

  factory PayrollRunDetailsModel.fromJson(Map<String, dynamic> json) {
    return PayrollRunDetailsModel(
      runNumber: _toStr(json['run_number']),
      description: _toStr(json['description']),
      paymentNumber: _toStr(json['payment_number']),
      employeesDetails: (json['employees_details'] as List<dynamic>?)
              ?.map((e) => PayrollRunsEmployeeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      id: _toStr(json['_id']),
      payrollName: _toStr(json['payroll_name']),
      periodName: _toStr(json['period_name']),
    );
  }
}

class PayrollRunsEmployeeModel {
  List<PayrollRunsEmployeeElementsModel>? runEmployeeDetails;
  String? employeeName;
  double? totalPayments;
  double? totalDeductions;
  double? netSalary;
  String? id;

  PayrollRunsEmployeeModel({
    this.runEmployeeDetails,
    this.employeeName,
    this.totalPayments,
    this.totalDeductions,
    this.netSalary,
    this.id,
  });

  factory PayrollRunsEmployeeModel.fromJson(Map<String, dynamic> json) {
    return PayrollRunsEmployeeModel(
      runEmployeeDetails: (json['run_employee_details'] as List<dynamic>?)
              ?.map((e) => PayrollRunsEmployeeElementsModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      employeeName: _toStr(json['employee_name']),
      totalPayments: _toDouble(json['total_payments']),
      totalDeductions: _toDouble(json['total_deductions']),
      netSalary: _toDouble(json['net_salary']),
      id: _toStr(json['_id']),
    );
  }
}

class PayrollRunsEmployeeElementsModel {
  double? value;
  String? elementName;
  String? elementType;
  String? id;
  double? payment;
  double? deduction;

  PayrollRunsEmployeeElementsModel({
    this.value,
    this.elementName,
    this.elementType,
    this.id,
    this.payment,
    this.deduction,
  });

  factory PayrollRunsEmployeeElementsModel.fromJson(Map<String, dynamic> json) {
    return PayrollRunsEmployeeElementsModel(
      value: _toDouble(json['value']),
      elementName: _toStr(json['element_name']),
      elementType: _toStr(json['element_type']),
      id: _toStr(json['_id']),
      payment: _toDouble(json['payment']),
      deduction: _toDouble(json['deduction']),
    );
  }
}
