class LegislationModel {
  final String? id;
  final String? name;
  final int? numberOfPaidDaysForSickLEave;
  final int? numberOfUnpaidDaysForSickLEave;
  final int? numberOfHalfPaidDaysForSickLEave;
  final int? numberOfHalfPaidDaysForMaternityLEave;
  final int? numberOfHalfPaidDaysForCompassionateLEave;
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
      numberOfHalfPaidDaysForCompassionateLEave:
          json.containsKey('number_of_paid_days_for_compassionate_leave')
          ? json['number_of_paid_days_for_compassionate_leave'] ?? 0
          : 0,
    );
  }
}
