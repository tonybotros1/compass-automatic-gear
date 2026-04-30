class LegislationModel {
  final String? id;
  final String? name;
  final int? numberOfPaidDaysForSickLEave;
  final int? numberOfUnpaidDaysForSickLEave;
  final int? numberOfHalfPaidDaysForSickLEave;
  final int? numberOfHalfPaidDaysForMaternityLEave;
  final int? numberOfHalfPaidDaysForPaternityLEave;
  final int? numberOfHalfPaidDaysForCompassionateLEave;
  final double? numberOfWorkingHoursForOvertimeNormal;
  final double? numberOfWorkingHoursForOvertimeHolidays;
  final List<String>? weekend;

  LegislationModel({
    this.id,
    this.name,
    this.weekend,
    this.numberOfHalfPaidDaysForSickLEave,
    this.numberOfPaidDaysForSickLEave,
    this.numberOfUnpaidDaysForSickLEave,
    this.numberOfHalfPaidDaysForCompassionateLEave,
    this.numberOfHalfPaidDaysForMaternityLEave,
    this.numberOfHalfPaidDaysForPaternityLEave,
    this.numberOfWorkingHoursForOvertimeNormal,
    this.numberOfWorkingHoursForOvertimeHolidays,
  });

  factory LegislationModel.fromJson(Map<String, dynamic> json) {
    return LegislationModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      weekend: json.containsKey('weekend')
          ? json['weekend'].cast<String>() ?? []
          : [],
      numberOfPaidDaysForSickLEave:
          json.containsKey('number_of_paid_days_for_sick_leave')
          ? json['number_of_paid_days_for_sick_leave'] ?? 0
          : 0,
      numberOfHalfPaidDaysForSickLEave:
          json.containsKey('number_of_half_paid_days_for_sick_leave')
          ? json['number_of_half_paid_days_for_sick_leave'] ?? 0
          : 0,
      numberOfUnpaidDaysForSickLEave:
          json.containsKey('number_of_unpaid_days_for_sick_leave')
          ? json['number_of_unpaid_days_for_sick_leave'] ?? 0
          : 0,
      numberOfHalfPaidDaysForMaternityLEave:
          json.containsKey('number_of_paid_days_for_maternity_leave')
          ? json['number_of_paid_days_for_maternity_leave'] ?? 0
          : 0,
      numberOfHalfPaidDaysForPaternityLEave:
          json.containsKey('number_of_paid_days_for_paternity_leave')
          ? json['number_of_paid_days_for_paternity_leave'] ?? 0
          : 0,
      numberOfHalfPaidDaysForCompassionateLEave:
          json.containsKey('number_of_paid_days_for_compassionate_leave')
          ? json['number_of_paid_days_for_compassionate_leave'] ?? 0
          : 0,
      numberOfWorkingHoursForOvertimeNormal:
          json.containsKey('number_of_working_hours_for_overtime_normal')
          ? json['number_of_working_hours_for_overtime_normal'] ?? 0
          : 0,
        numberOfWorkingHoursForOvertimeHolidays:
          json.containsKey('number_of_working_hours_for_overtime_holidays')
          ? json['number_of_working_hours_for_overtime_holidays'] ?? 0
          : 0,
    );
  }
}
