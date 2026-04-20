class EmployeeLeavesModel {
  String? id;
  String? leaveType;
  String? leaveTypeName;
  String? status;
  DateTime? startDate;
  DateTime? endDate;
  int? numberOdDays;
  String? note;
  bool? payInAdvance;

  EmployeeLeavesModel({
    this.id,
    this.endDate,
    this.leaveType,
    this.leaveTypeName,
    this.note,
    this.numberOdDays,
    this.startDate,
    this.status,
    this.payInAdvance,
  });

  EmployeeLeavesModel.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('_id') ? json['_id'] ?? '' : '';
    leaveType = json.containsKey('leave_type') ? json['leave_type'] ?? '' : '';
    leaveTypeName = json.containsKey('leave_type_name')
        ? json['leave_type_name'] ?? ''
        : '';
    status = json.containsKey('status') ? json['status'] ?? '' : '';
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
    numberOdDays = json.containsKey('number_of_days')
        ? json['number_of_days'] ?? 0
        : 0;
    note = json.containsKey('note') ? json['note'] ?? '' : '';
    payInAdvance = json.containsKey('pay_in_advance')
        ? json['pay_in_advance'] ?? false
        : false;
  }
}
