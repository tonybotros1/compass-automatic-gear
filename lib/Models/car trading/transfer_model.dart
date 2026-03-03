class TransferModel {
  String? id;
  String? date;
  String? fromAccount;
  String? fromAccountName;
  String? toAccount;
  String? toAccountName;
  double? amount;
  String? comment;
  String? createdAt;
  String? updatedAt;

  TransferModel({
    this.id,
    this.date,
    this.fromAccount,
    this.fromAccountName,
    this.toAccount,
    this.toAccountName,
    this.amount,
    this.comment,
    this.createdAt,
    this.updatedAt,
  });

  TransferModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    date = json['date'];
    fromAccount = json['from_account'];
    fromAccountName = json['from_account_name'];
    toAccount = json['to_account'];
    toAccountName = json['to_account_name'];
    amount = json['amount'];
    comment = json['comment'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['date'] = date;
    data['from_account'] = fromAccount;
    data['from_account_name'] = fromAccountName;
    data['to_account'] = toAccount;
    data['to_account_name'] = toAccountName;
    data['amount'] = amount;
    data['comment'] = comment;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
