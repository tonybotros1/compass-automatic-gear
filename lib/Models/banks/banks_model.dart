class BanksModel {
  String? id;
  String? accountName;
  String? accountNumber;
  String? accountTypeId;
  String? currencyId;
  String? countryName;
  String? countryCode;
  String? countryId;
  double? rate;
  String? currency;
  String? accountTypeName;
  DateTime? createdAt;
  DateTime? updatedAt;

  BanksModel({
    this.id,
    this.accountName,
    this.accountNumber,
    this.accountTypeId,
    this.currencyId,
    this.countryName,
    this.countryCode,
    this.countryId,
    this.rate,
    this.currency,
    this.accountTypeName,
    this.createdAt,
    this.updatedAt,
  });

  BanksModel.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('_id') ? json['_id'] ?? "" : "";
    accountName = json.containsKey('account_name')
        ? json['account_name'] ?? ""
        : "";
    accountNumber = json.containsKey('account_number')
        ? json['account_number'] ?? ""
        : "";
    accountTypeId = json.containsKey('account_type_id')
        ? json['account_type_id'] ?? ""
        : "";
    currencyId = json.containsKey('currency_id')
        ? json['currency_id'] ?? ""
        : "";
    countryName = json.containsKey('country_name')
        ? json['country_name'] ?? ""
        : "";
    countryCode = json.containsKey('country_code')
        ? json['country_code'] ?? ""
        : "";
    countryId = json.containsKey('country_id') ? json['country_id'] ?? "" : "";
    rate = json.containsKey('rate') ? json['rate'] ?? 0 : 0;
    currency = json.containsKey('currency') ? json['currency'] ?? "" : "";
    accountTypeName = json.containsKey('account_type_name')
        ? json['account_type_name'] ?? ""
        : "";
    createdAt = DateTime.tryParse(json['createdAt']);
    updatedAt = DateTime.tryParse(json['updatedAt']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['account_name'] = accountName;
    data['account_number'] = accountNumber;
    data['account_type_id'] = accountTypeId;
    data['currency_id'] = currencyId;
    data['country_name'] = countryName;
    data['country_code'] = countryCode;
    data['country_id'] = countryId;
    data['rate'] = rate;
    data['currency'] = currency;
    data['account_type_name'] = accountTypeName;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
