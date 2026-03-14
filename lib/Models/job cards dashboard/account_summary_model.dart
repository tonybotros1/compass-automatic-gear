class AccountSummary {
  String? sId;
  double? amount;

  AccountSummary({this.sId, this.amount});

  AccountSummary.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? '';
    amount = json['amount'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['amount'] = amount;
    return data;
  }
}
