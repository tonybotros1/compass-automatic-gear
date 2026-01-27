class LastCarTradingChangesModel {
  String? brandName;
  String? modelName;
  String? description;
  String? year;
  double? pay;
  double? receive;
  String? type;
  String? id;

  LastCarTradingChangesModel({
    this.brandName,
    this.modelName,
    this.description,
    this.pay,
    this.receive,
    this.id,
    this.type,
    this.year,
  });

  LastCarTradingChangesModel.fromJson(Map<String, dynamic> json) {
    brandName = json.containsKey('brand_name') ? json['brand_name'] ?? '' : '';
    modelName = json.containsKey('model_name') ? json['model_name'] ?? '' : '';
    description = json.containsKey('description')
        ? json['description'] ?? ''
        : '';
    pay = json.containsKey('pay') ? json['pay'] ?? 0 : 0;
    type = json.containsKey('type') ? json['type'] : '';
    receive = json.containsKey('receive') ? json['receive'] ?? 0 : 0;
    year = json.containsKey('year') ? json['year'] ?? '' : '';
    id = json.containsKey('_id') ? json['_id'] ?? '' : '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['brand_name'] = brandName;
    data['model_name'] = modelName;
    data['description'] = description;
    data['pay'] = pay;
    data['receive'] = receive;
    data['_id'] = id;
    data['year'] = year;
    return data;
  }
}
