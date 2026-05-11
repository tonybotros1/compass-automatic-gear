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
      id: json.containsKey('_id') ? json['_id']?.toString() ?? '' : '',
      period: json.containsKey('period_name')
          ? json['period_name']?.toString() ?? ''
          : '',

      startDate: json.containsKey('start_date')
          ? json['start_date'] != null
                ? DateTime.tryParse(json['start_date'].toString())
                : null
          : null,
      endDate: json.containsKey('end_date')
          ? json['end_date'] != null
                ? DateTime.tryParse(json['end_date'].toString())
                : null
          : null,

      status: json.containsKey('status')
          ? json['status']?.toString() ?? ""
          : "",
    );
  }
}
