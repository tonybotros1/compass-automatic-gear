class CarTradingItemsModel {
  String? id;
  final String? item;
  final String? itemId;
  final String? tradeId;
  final double? pay;
  final double? receive;
  final String? companyId;
  final String? comment;
  final String? accountName;
  final String? accountNameId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? date;
  bool added = false;
  bool modified = false;
  bool deleted = false;

  CarTradingItemsModel({
    this.id,
    this.item,
    this.itemId,
    this.tradeId,
    this.pay,
    this.receive,
    this.date,
    this.comment,
    this.accountName,
    this.accountNameId,
    this.companyId,
    this.createdAt,
    this.updatedAt,
    this.modified = false,
    this.deleted = false,
    this.added = false,
  });

  Map<String, dynamic> toJson() => {
    "uuid": id,
    "item": item,
    "item_id": itemId,
    "pay": pay,
    "trade_id": tradeId,
    "receive": receive,
    "comment": comment,
    if (date != null) "date": date!.toIso8601String(),
    "deleted": deleted,
    "modified": modified,
  };

  /// Helper to parse doubles safely
  static double? _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    if (value is String && value.trim().isNotEmpty) {
      return double.tryParse(value) ?? 0;
    }
    return 0;
  }

  factory CarTradingItemsModel.fromJson(Map<String, dynamic> json) {
    return CarTradingItemsModel(
      id: json['_id'] ?? '',
      item: json['item'] ?? '',
      itemId: json['item_id'] ?? '',
      pay: _toDouble(json['pay']),
      tradeId: json['trade_id'] ?? '',
      receive: _toDouble(json['receive']),
      accountName: json.containsKey('account_name')
          ? json['account_name'] ?? ''
          : '',
      accountNameId: json.containsKey('account_name_id')
          ? json['account_name_id'] ?? ''
          : '',
      comment: json['comment'] ?? '',
      companyId: json['company_id'] ?? '',
      date: json['date'] != null && json['date'] != ''
          ? DateTime.tryParse(json['date'])
          : null,
      createdAt: json['createdAt'] != null && json['createdAt'] != ''
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null && json['updatedAt'] != ''
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }
}
