class LegislationModel {
  final String? id;
  final String? name;
  final int? numberOfPaidDays;
  final int? numberOfUnpaidDays;
  final int? numberOfHalfPaidDays;
  final List<String>? weekend;

  LegislationModel({
    this.id,
    this.name,
    this.weekend,
    this.numberOfHalfPaidDays,
    this.numberOfPaidDays,
    this.numberOfUnpaidDays,
  });

  factory LegislationModel.fromJson(Map<String, dynamic> json) {
    return LegislationModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      weekend: json.containsKey('weekend')
          ? json['weekend'].cast<String>() ?? []
          : [],
      numberOfPaidDays: json.containsKey('number_of_paid_days')
          ? json['number_of_paid_days'] ?? 0
          : 0,
      numberOfHalfPaidDays: json.containsKey('number_of_half_paid_days')
          ? json['number_of_half_paid_days'] ?? 0
          : 0,
      numberOfUnpaidDays: json.containsKey('number_of_unpaid_days')
          ? json['number_of_unpaid_days'] ?? 0
          : 0,
    );
  }
}
