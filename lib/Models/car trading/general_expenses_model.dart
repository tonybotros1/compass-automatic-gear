class GeneralExpensesModel {
  final String id;
  final String item;
  final String itemId;
  final double pay;
  final double receive;
  final String companyId;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime date;

  GeneralExpensesModel({
    required this.id,
    required this.item,
    required this.itemId,
    required this.pay,
    required this.receive,
    required this.date,
    required this.comment,
    required this.companyId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GeneralExpensesModel.fromJson(Map<String, dynamic> json) {
    return GeneralExpensesModel(
      id: json['_id'] ?? '',
      item: json['item'] ?? '',
      itemId: json['item_id'] ?? '',
      pay: json['pay'] ?? '',
      receive: json['receive'] ?? '',
      comment: json['comment'] ?? '',
      companyId: json['company_id'] ?? '',
      date: DateTime.parse(json['date']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
