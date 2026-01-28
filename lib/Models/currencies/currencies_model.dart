class CurrenciesModel {
  String? id;
  String? countryId;
  String? code;
  String? name;
  double? rate;
  bool? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  CurrenciesModel({
    this.id,
    this.countryId,
    this.code,
    this.name,
    this.status,
    this.rate,
    this.createdAt,
    this.updatedAt,
  });

  CurrenciesModel.fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString() ?? '';
    createdAt = json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'].toString())
        : null;
    code = json['currency_code']?.toString() ?? '';
    updatedAt = json['updatedAt'] != null
        ? DateTime.tryParse(json['updatedAt'].toString())
        : null;
    name = json['country_name']?.toString() ?? '';
    rate = json['rate'] ?? 0;
    status = json['status'];
    countryId = json["country_id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['country_name'] = name;
    data['country_code'] = code;
    data['rate'] = rate;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['status'] = status;
    data["country_id"] = countryId;
    return data;
  }
}
