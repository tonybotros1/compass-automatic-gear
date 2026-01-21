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
  });

  factory GeneralExpensesModel.fromJson(Map<String, dynamic> json) {
    return GeneralExpensesModel(
      id: json['_id'] ?? '',
      item: json['item'] ?? '',
      itemId: json['item_id'] ?? '',
      pay: json['pay'] ?? '',
      receive: json['receive'] ?? '',
      accountName: json.containsKey('account_name')
          ? json['account_name'] ?? ''
          : '',
      accountNameId: json.containsKey('account_name_id')
          ? json['account_name_id'] ?? ''
          : '',
      comment: json['comment'] ?? '',
      companyId: json['company_id'] ?? '',
      date: DateTime.parse(json['date']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
