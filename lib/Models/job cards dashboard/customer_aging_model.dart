class CustomerAgingModel {
  double? totalOutstanding;
  DateTime? lastPaymentDate;
  String? groupName;
  double? i0To30Days;
  double? i31To60Days;
  double? i61To90Days;
  double? i0To90Days;
  double? i91To120Days;
  double? i121To150Days;
  double? i151To180Days;
  double? i91To180Days;
  double? d181To360Days;
  double? moreThan360Days;

  CustomerAgingModel({
    this.totalOutstanding,
    this.lastPaymentDate,
    this.groupName,
    this.i0To30Days,
    this.i31To60Days,
    this.i61To90Days,
    this.i0To90Days,
    this.i91To120Days,
    this.i121To150Days,
    this.i151To180Days,
    this.i91To180Days,
    this.d181To360Days,
    this.moreThan360Days,
  });

  CustomerAgingModel.fromJson(Map<String, dynamic> json) {
    totalOutstanding = json.containsKey('total_outstanding')
        ? json['total_outstanding'] ?? 0
        : 0;
   lastPaymentDate = (json['last_payment_date'] as String?) != null
    ? DateTime.tryParse(json['last_payment_date'] as String)
    : null;
    groupName = json.containsKey('group_name') ? json['group_name'] ?? '' : '';
    i0To30Days = json.containsKey('0_to_30_days')
        ? json['0_to_30_days'] ?? 0
        : 0;
    i31To60Days = json.containsKey('31_to_60_days')
        ? json['31_to_60_days'] ?? 0
        : 0;
    i61To90Days = json.containsKey('61_to_90_days')
        ? json['61_to_90_days'] ?? 0
        : 0;
    i0To90Days = json.containsKey('0_to_90_days')
        ? json['0_to_90_days'] ?? 0
        : 0;
    i91To120Days = json.containsKey('91_to_120_days')
        ? json['91_to_120_days'] ?? 0
        : 0;
    i121To150Days = json.containsKey('121_to_150_days')
        ? json['121_to_150_days'] ?? 0
        : 0;
    i151To180Days = json.containsKey('151_to_180_days')
        ? json['151_to_180_days'] ?? 0
        : 0;
    i91To180Days = json.containsKey('91_to_180_days')
        ? json['91_to_180_days'] ?? 0
        : 0;
    d181To360Days = json.containsKey('181_to_360_days')
        ? json['181_to_360_days'] ?? 0
        : 0;
    moreThan360Days = json.containsKey('more_than_360_days')
        ? json['more_than_360_days'] ?? 0
        : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_outstanding'] = totalOutstanding;
    data['last_payment_date'] = lastPaymentDate;
    data['group_name'] = groupName;
    data['0_to_30_days'] = i0To30Days;
    data['31_to_60_days'] = i31To60Days;
    data['61_to_90_days'] = i61To90Days;
    data['0_to_90_days'] = i0To90Days;
    data['91_to_120_days'] = i91To120Days;
    data['121_to_150_days'] = i121To150Days;
    data['151_to_180_days'] = i151To180Days;
    data['91_to_180_days'] = i91To180Days;
    data['181_to_360_days'] = d181To360Days;
    data['more_than_360_days'] = moreThan360Days;
    return data;
  }
}
