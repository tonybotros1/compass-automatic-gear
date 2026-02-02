class LastCarTradingChangesModel {
  String? brandName;
  String? modelName;
  String? description;
  String? year;
  double? pay;
  double? receive;
  String? type;
  DateTime? updatedAt;
  String? itemName;
  String? accountName;
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
    this.accountName,
    this.itemName,
    this.updatedAt,
  });

  LastCarTradingChangesModel.fromJson(Map<String, dynamic> json) {
    brandName = json.containsKey('brand_name')
        ? json['brand_name']?.toString() ?? ''
        : '';
    modelName = json.containsKey('model_name')
        ? json['model_name']?.toString() ?? ''
        : '';
    description = json.containsKey('description')
        ? json['description']?.toString() ?? ''
        : '';
    pay = json.containsKey('pay') ? json['pay'] ?? 0 : 0;
    type = json.containsKey('type') ? json['type']?.toString() : '';
    receive = json.containsKey('receive') ? json['receive'] ?? 0 : 0;
    year = json.containsKey('year') ? json['year']?.toString() ?? '' : '';
    id = json.containsKey('_id') ? json['_id']?.toString() ?? '' : '';
    accountName = json.containsKey('account_name')
        ? json['account_name']?.toString() ?? ''
        : '';
    itemName = json.containsKey('item_name')
        ? json['item_name']?.toString() ?? ''
        : '';
    updatedAt = DateTime.tryParse(json['updatedAt']);
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
