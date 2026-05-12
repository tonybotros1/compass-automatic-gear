class CapitalsAndOutstandingModel {
  final String id;
  final String name;
  final String nameId;
  final double pay;
  final double receive;
  final String accountName;
  final String accountNameId;
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
    required this.accountName,
    required this.accountNameId,
  });

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime _toDate(dynamic value) {
    return DateTime.tryParse(value?.toString() ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0);
  }

  factory CapitalsAndOutstandingModel.fromJson(Map<String, dynamic> json) {
    return CapitalsAndOutstandingModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      nameId: json['name_id']?.toString() ?? '',
      pay: _toDouble(json['pay']),
      receive: _toDouble(json['receive']),
      comment: json['comment']?.toString() ?? '',
      accountName: json.containsKey('account_name')
          ? json['account_name']?.toString() ?? ''
          : '',
      accountNameId: json.containsKey('account_name_id')
          ? json['account_name_id']?.toString() ?? ''
          : '',
      companyId: json['company_id']?.toString() ?? '',
      date: _toDate(json['date']),
      createdAt: _toDate(json['createdAt']),
      updatedAt: _toDate(json['updatedAt']),
    );
  }
  double get net => receive - pay;
}
