class TransferModel {
  String? id;
  String? date;
  String? status;
  String? transferCounter;
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
    this.status,
    this.transferCounter,
  });

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  TransferModel.fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString() ?? '';
    date = json['date']?.toString() ?? '';
    fromAccount = json['from_account']?.toString() ?? '';
    fromAccountName = json['from_account_name']?.toString() ?? '';
    toAccount = json['to_account']?.toString() ?? '';
    toAccountName = json['to_account_name']?.toString() ?? '';
    amount = _toDouble(json['amount']);
    status = json.containsKey('status') ? json['status']?.toString() ?? '' : '';
    transferCounter = json.containsKey('transfer_number')
        ? json['transfer_number']?.toString() ?? ''
        : '';
    comment = json['comment']?.toString() ?? '';
    createdAt = json['createdAt']?.toString() ?? '';
    updatedAt = json['updatedAt']?.toString() ?? '';
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
