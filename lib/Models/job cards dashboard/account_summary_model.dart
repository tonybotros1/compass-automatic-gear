class AccountSummary {
  String? accountNumber;
  double? amount;

  AccountSummary({this.accountNumber, this.amount});

  AccountSummary.fromJson(Map<String, dynamic> json) {
    accountNumber = json['account_number'] ?? '';
    amount = json['amount'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['account_number'] = accountNumber;
    data['amount'] = amount;
    return data;
  }
}
