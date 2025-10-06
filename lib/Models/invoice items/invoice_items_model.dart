class InvoiceItemsModel {
  String? id;
  String? companyId;
  String? name;
  double? price;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;

  InvoiceItemsModel({
    this.id,
    this.companyId,
    this.name,
    this.price,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  InvoiceItemsModel.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('_id') ? json['_id'] ?? '' : '';
    companyId = json.containsKey('company_id') ? json['company_id'] ?? '' : '';
    name = json.containsKey('name') ? json['name'] ?? '' : '';
    price = json.containsKey('price') ? json['price'] ?? 0 : 0;
    description = json.containsKey('description')
        ? json['description'] ?? ''
        : '';
    createdAt = DateTime.tryParse(json['createdAt']);
    updatedAt = DateTime.tryParse(json['updatedAt']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['company_id'] = companyId;
    data['name'] = name;
    data['price'] = price;
    data['description'] = description;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
