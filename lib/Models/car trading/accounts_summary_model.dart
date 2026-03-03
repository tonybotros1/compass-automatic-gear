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

  AccountSummaryModel.fromJson(Map<String, dynamic> json) {
    totalCarsNet = json['total_cars_net'];
    totalCapitalsNet = json['total_capitals_net'];
    totalOutstandingNet = json['total_outstanding_net'];
    totalExpensesNet = json['total_expenses_net'];
    finalNet = json['final_net'];
    accountName = json['account_name'];
    accountId = json['account_id'];
    accountDisplay = json['account_display'];
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
