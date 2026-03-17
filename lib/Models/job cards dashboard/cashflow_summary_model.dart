class CashflowSummaryModel {
  double? totalReceived;
  double? totalPaid;
  double? totalTransOut;
  double? totalTransIn;
  double? net;
  String? accountNumber;

  CashflowSummaryModel({
    this.totalReceived,
    this.totalPaid,
    this.totalTransOut,
    this.totalTransIn,
    this.net,
    this.accountNumber,
  });

  CashflowSummaryModel.fromJson(Map<String, dynamic> json) {
    totalReceived = json.containsKey('total_received')
        ? json['total_received'] ?? 0
        : 0;
    totalPaid = json.containsKey('total_paid') ? json['total_paid'] ?? 0 : 0;
    totalTransOut = json.containsKey('total_trans_out')
        ? json['total_trans_out'] ?? 0
        : 0;
    totalTransIn = json.containsKey('total_trans_in')
        ? json['total_trans_in'] ?? 0
        : 0;
    net = json.containsKey('net') ? json['net'] ?? 0 : 0;
    accountNumber = json.containsKey('account_number')
        ? json['account_number'] ?? ''
        : '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_received'] = totalReceived;
    data['total_paid'] = totalPaid;
    data['total_trans_out'] = totalTransOut;
    data['total_trans_in'] = totalTransIn;
    data['net'] = net;
    data['account_number'] = accountNumber;
    return data;
  }
}
