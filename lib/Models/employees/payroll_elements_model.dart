class EmployeePayrollElementsModel {
  String? id;
  String? name;
  String? value;
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

  EmployeePayrollElementsModel.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('_id') ? json['_id'] ?? '' : '';
    name = json.containsKey('name') ? json['name'] ?? '' : '';
    value = json.containsKey('value') ? json['value'] ?? '' : '';
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
    note = json.containsKey('note') ? json['note'] ?? '' : '';
  }
}
