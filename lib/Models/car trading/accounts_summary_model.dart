class AccountSummaryModel {
  double? totalCarsNet;
  double? totalCapitalsNet;
  double? totalOutstandingNet;
  double? totalExpensesNet;
  double? finalNet;
  String? accountName;
  String? accountId;
  String? accountDisplay;

  AccountSummaryModel({
    this.totalCarsNet,
    this.totalCapitalsNet,
    this.totalOutstandingNet,
    this.totalExpensesNet,
    this.finalNet,
    this.accountName,
    this.accountId,
    this.accountDisplay,
  });

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  AccountSummaryModel.fromJson(Map<String, dynamic> json) {
    totalCarsNet = _toDouble(json['total_cars_net']);
    totalCapitalsNet = _toDouble(json['total_capitals_net']);
    totalOutstandingNet = _toDouble(json['total_outstanding_net']);
    totalExpensesNet = _toDouble(json['total_expenses_net']);
    finalNet = _toDouble(json['final_net']);
    accountName = json['account_name']?.toString() ?? '';
    accountId = json['account_id']?.toString() ?? '';
    accountDisplay = json['account_display']?.toString() ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_cars_net'] = totalCarsNet;
    data['total_capitals_net'] = totalCapitalsNet;
    data['total_outstanding_net'] = totalOutstandingNet;
    data['total_expenses_net'] = totalExpensesNet;
    data['final_net'] = finalNet;
    data['account_name'] = accountName;
    data['account_id'] = accountId;
    data['account_display'] = accountDisplay;
    return data;
  }
}
