class EmployeePayrollElementsModel {
  String? id;
  String? name;
  String? nameId;
  double? value;
  DateTime? startDate;
  DateTime? endDate;
  String? note;

  EmployeePayrollElementsModel({
    this.id,
    this.name,
    this.value,
    this.startDate,
    this.endDate,
    this.note,
  });

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  EmployeePayrollElementsModel.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('_id') ? json['_id'] ?? '' : '';
    name = json.containsKey('name_value') ? json['name_value'] ?? '' : '';
    nameId = json.containsKey('name') ? json['name'] ?? '' : '';
    value = json.containsKey('value') ? _toDouble(json['value']) : 0;
    startDate = json.containsKey('start_date')
        ? json['start_date'] != null
              ? DateTime.tryParse(json['start_date'])
              : null
        : null;
    endDate = json.containsKey('end_date')
        ? json['end_date'] != null
              ? DateTime.tryParse(json['end_date'])
              : null
        : null;
    note = json.containsKey('notes') ? json['notes'] ?? '' : '';
  }
}
