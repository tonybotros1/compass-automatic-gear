class PeriodDetailsModel {
  final String? id;
  final String? period;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status;

  PeriodDetailsModel({
    this.id,
    this.period,
    this.startDate,
    this.endDate,
    this.status,
  });

  factory PeriodDetailsModel.fromJson(Map<String, dynamic> json) {
    return PeriodDetailsModel(
      id: json.containsKey('_id') ? json['_id'] ?? '' : '',
      period: json.containsKey('period_name') ? json['period_name'] ?? '' : '',

      startDate: json.containsKey('start_date')
          ? json['start_date'] != null
                ? DateTime.tryParse(json['start_date'])
                : null
          : null,
      endDate: json.containsKey('end_date')
          ? json['end_date'] != null
                ? DateTime.tryParse(json['end_date'])
                : null
          : null,

      status: json.containsKey('status') ? json['status'] ?? "" : "",
    );
  }
}
