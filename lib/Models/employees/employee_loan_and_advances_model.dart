class EmployeeLoanAndAdvancesModel {
  String? id;
  double? totalAmount;
  double? monthlyInstallment;
  DateTime? deductionDate;
  double? paidToDate;
  double? remainingAmount;
  String? note;
  String? type;
  String? typeId;

  EmployeeLoanAndAdvancesModel({
    this.id,
    this.totalAmount,
    this.monthlyInstallment,
    this.deductionDate,
    this.paidToDate,
    this.remainingAmount,
    this.note,
    this.type,
    this.typeId,
  });

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  EmployeeLoanAndAdvancesModel.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('_id') ? json['_id']?.toString() ?? '' : '';

    totalAmount = json.containsKey('total_amount')
        ? _toDouble(json['total_amount'])
        : 0;

    monthlyInstallment = json.containsKey('monthly_installment')
        ? _toDouble(json['monthly_installment'])
        : 0;

    deductionDate = json.containsKey('deduction_date')
        ? json['deduction_date'] != null
              ? DateTime.tryParse(json['deduction_date'].toString())
              : null
        : null;

    paidToDate = json.containsKey('paid_to_date')
        ? _toDouble(json['paid_to_date'])
        : 0;

    remainingAmount = json.containsKey('remaining_amount')
        ? _toDouble(json['remaining_amount'])
        : 0;

    note = json.containsKey('note') ? json['note']?.toString() ?? '' : '';

    type = json.containsKey('type_name')
        ? json['type_name']?.toString() ?? ''
        : '';
    type = json.containsKey('type') ? json['type']?.toString() ?? '' : '';
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'total_amount': totalAmount,
      'monthly_installment': monthlyInstallment,
      'deduction_date': deductionDate?.toIso8601String(),
      'paid_to_date': paidToDate,
      'remaining_amount': remainingAmount,
      'note': note,
      'type': type,
    };
  }
}
