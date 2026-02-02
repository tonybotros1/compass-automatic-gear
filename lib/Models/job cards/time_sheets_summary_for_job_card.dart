class TimeSheetsSummaryForJobCard {
  DateTime? startDate;
  DateTime? endDate;
  String? taskNameAr;
  String? taskNameEn;
  String? employeeName;
  double? timeInHours;

  TimeSheetsSummaryForJobCard({
    this.startDate,
    this.endDate,
    this.taskNameAr,
    this.taskNameEn,
    this.employeeName,
    this.timeInHours,
  });

  TimeSheetsSummaryForJobCard.fromJson(Map<String, dynamic> json) {
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
    taskNameAr = json.containsKey('task_name_ar')
        ? json['task_name_ar'] ?? ''
        : '';
    taskNameEn = json.containsKey('task_name_en')
        ? json['task_name_en'] ?? ''
        : '';
    employeeName = json.containsKey('employee_name')
        ? json['employee_name'] ?? ''
        : '';
    timeInHours = json.containsKey('time_in_hours')
        ? json['time_in_hours'] ?? ''
        : '';
  }
}
