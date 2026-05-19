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

  static String _toStringValue(dynamic value) => value?.toString() ?? '';

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  EmployeePayrollElementsModel.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('_id') ? _toStringValue(json['_id']) : '';
    name = json.containsKey('name_value')
        ? _toStringValue(json['name_value'])
        : '';
    nameId = json.containsKey('name') ? _toStringValue(json['name']) : '';
    value = json.containsKey('value') ? _toDouble(json['value']) : 0;
    startDate = json.containsKey('start_date')
        ? _toDate(json['start_date'])
        : null;
    endDate = json.containsKey('end_date') ? _toDate(json['end_date']) : null;
    note = json.containsKey('notes') ? _toStringValue(json['notes']) : '';
  }
}
