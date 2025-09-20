class CarTradingItemsModel {
  String? id;
  final String? item;
  final String? itemId;
  final String? tradeId;
  final double? pay;
  final double? receive;
  final String? companyId;
  final String? comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? date;
  bool added =false;
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
    "modified": modified
  };

  factory CarTradingItemsModel.fromJson(Map<String, dynamic> json) {
    return CarTradingItemsModel(
      id: json['_id'] ?? '',
      item: json['item'] ?? '',
      itemId: json['item_id'] ?? '',
      pay: json['pay'] ?? '',
      tradeId: json['trade_id'],
      receive: json['receive'] ?? '',
      comment: json['comment'] ?? '',
      companyId: json['company_id'] ?? '',
      date: DateTime.parse(json['date']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
