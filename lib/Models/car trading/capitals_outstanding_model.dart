class CapitalsAndOutstandingModel {
  final String id;
  final String name;
  final String nameId;
  final double pay;
  final double receive;
  final String companyId;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime date;

  CapitalsAndOutstandingModel({
    required this.id,
    required this.name,
    required this.nameId,
    required this.pay,
    required this.receive,
    required this.date,
    required this.comment,
    required this.companyId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CapitalsAndOutstandingModel.fromJson(Map<String, dynamic> json) {
    return CapitalsAndOutstandingModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      nameId: json['name_id'] ?? '',
      pay: json['pay'] ?? '',
      receive: json['receive'] ?? '',
      comment: json['comment'] ?? '',
      companyId: json['company_id'] ?? '',
      date: DateTime.parse(json['date']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
  double get net => receive - pay;
}
