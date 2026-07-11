class GeneralExpensesModel {
  final String id;
  final String item;
  final String itemId;
  final double pay;
  final String accountName;
  final String accountNameId;
  final double receive;
  final String companyId;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime date;
  final String car;
  final String trim;
  final String tradeId;

  GeneralExpensesModel({
    required this.id,
    required this.item,
    required this.itemId,
    required this.pay,
    required this.receive,
    required this.accountName,
    required this.accountNameId,
    required this.date,
    required this.comment,
    required this.companyId,
    required this.createdAt,
    required this.updatedAt,
    required this.car,
    required this.trim,
    required this.tradeId,
  });

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime _toDate(dynamic value) {
    return DateTime.tryParse(value?.toString() ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0);
  }

  factory GeneralExpensesModel.fromJson(Map<String, dynamic> json) {
    return GeneralExpensesModel(
      id: json['_id']?.toString() ?? '',
      item: json['item']?.toString() ?? '',
      itemId: json['item_id']?.toString() ?? '',
      pay: _toDouble(json['pay']),
      car: json.containsKey('car') ? json['car'] ?? '' : '',
      trim: json['trim']?.toString() ?? '',
      tradeId: json['trade_id']?.toString() ?? '',
      receive: _toDouble(json['receive']),
      accountName: json.containsKey('account_name')
          ? json['account_name']?.toString() ?? ''
          : '',
      accountNameId: json.containsKey('account_name_id')
          ? json['account_name_id']?.toString() ?? ''
          : '',
      comment: json['comment']?.toString() ?? '',
      companyId: json['company_id']?.toString() ?? '',
      date: _toDate(json['date']),
      createdAt: _toDate(json['createdAt']),
      updatedAt: _toDate(json['updatedAt']),
    );
  }
}
