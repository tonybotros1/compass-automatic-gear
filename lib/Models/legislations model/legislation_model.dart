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
  final double? socialSecurityEmployee;
  final double? socialSecurityEmployer;
  final double? socialSecurityCeiling;
  final int? gratuityFirst5Years;
  final int? gratuityAfter5Years;
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
    this.socialSecurityCeiling,
    this.socialSecurityEmployee,
    this.socialSecurityEmployer,
    this.gratuityAfter5Years,
    this.gratuityFirst5Years,
  });

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ??
        double.tryParse(value?.toString() ?? '')?.toInt() ??
        0;
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static List<String> _toStringList(dynamic value) {
    if (value is List) {
      return value.map((day) => day.toString()).toList();
    }
    return [];
  }

  factory LegislationModel.fromJson(Map<String, dynamic> json) {
    return LegislationModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      weekend: _toStringList(json['weekend']),
      numberOfPaidDaysForSickLEave: _toInt(
        json['number_of_paid_days_for_sick_leave'],
      ),
      numberOfHalfPaidDaysForSickLEave: _toInt(
        json['number_of_half_paid_days_for_sick_leave'],
      ),
      numberOfUnpaidDaysForSickLEave: _toInt(
        json['number_of_unpaid_days_for_sick_leave'],
      ),
      numberOfHalfPaidDaysForMaternityLEave: _toInt(
        json['number_of_paid_days_for_maternity_leave'],
      ),
      numberOfHalfPaidDaysForPaternityLEave: _toInt(
        json['number_of_paid_days_for_paternity_leave'],
      ),
      numberOfHalfPaidDaysForCompassionateLEave: _toInt(
        json['number_of_paid_days_for_compassionate_leave'],
      ),
      numberOfWorkingHoursForOvertimeNormal: _toDouble(
        json['number_of_working_hours_for_overtime_normal'],
      ),
      numberOfWorkingHoursForOvertimeHolidays: _toDouble(
        json['number_of_working_hours_for_overtime_holidays'],
      ),
      socialSecurityEmployee: _toDouble(
        json['social_security_employee_percentage'],
      ),
      socialSecurityEmployer: _toDouble(
        json['social_security_employer_percentage'],
      ),
      socialSecurityCeiling: _toDouble(json['social_security_ceiling']),
      gratuityFirst5Years: _toInt(json['gratuity_first_5_years']),
      gratuityAfter5Years: _toInt(json['gratuity_after_5_years']),
    );
  }
}
