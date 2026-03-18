class PostDatedChequesModel {
  DateTime? chequeDate;
  String? source;
  String? counter;
  DateTime? date;
  String? bankAccount;
  double? paid;
  double? received;
  String? beneficiaryName;

  PostDatedChequesModel({
    this.chequeDate,
    this.source,
    this.counter,
    this.date,
    this.bankAccount,
    this.paid,
    this.received,
    this.beneficiaryName,
  });

  PostDatedChequesModel.fromJson(Map<String, dynamic> json) {
    chequeDate = json.containsKey('cheque_date')
        ? DateTime.tryParse(json['cheque_date'])
        : null;
    source = json.containsKey('source') ? json['source'] ?? '' : '';
    counter = json.containsKey('counter') ? json['counter'] ?? '' : '';
    date = json.containsKey('date') ? DateTime.tryParse(json['date']) : null;
    bankAccount = json.containsKey('bank_account')
        ? json['bank_account'] ?? ''
        : '';
    paid = json.containsKey('paid') ? json['paid'] ?? 0 : 0;
    received = json.containsKey('received') ? json['received'] ?? 0 : 0;
    beneficiaryName = json.containsKey('beneficiary_name')
        ? json['beneficiary_name'] ?? ''
        : '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cheque_date'] = chequeDate;
    data['source'] = source;
    data['counter'] = counter;
    data['date'] = date;
    data['bank_account'] = bankAccount;
    data['paid'] = paid;
    data['received'] = received;
    data['beneficiary_name'] = beneficiaryName;
    return data;
  }
}
