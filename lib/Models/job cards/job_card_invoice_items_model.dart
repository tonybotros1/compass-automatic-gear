class JobCardInvoiceItemsModel {
  String? id;
  String? uid;
  int? lineNumber;
  String? name;
  String? nameId;
  String? description;
  int? quantity;
  double? price;
  double? amount;
  double? discount;
  double? total;
  double? vat;
  double? net;
  String? companyId;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isModified;
  bool? deleted;
  bool? added;

  JobCardInvoiceItemsModel({
    this.id,
    this.uid,
    this.amount,
    this.nameId,
    this.companyId,
    this.createdAt,
    this.description,
    this.discount,
    this.lineNumber,
    this.name,
    this.net,
    this.price,
    this.quantity,
    this.total,
    this.updatedAt,
    this.vat,
    this.added,
    this.deleted,
    this.isModified,
  });

  JobCardInvoiceItemsModel.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('_id') ? json['_id'] ?? '' : '';
    companyId = json.containsKey('company_id') ? json['company_id'] ?? '' : '';
    name = json.containsKey('name_text') ? json['name_text'] ?? '' : '';
    nameId = json.containsKey('name') ? json['name'] ?? '' : '';
    price = json.containsKey('price') ? json['price'] ?? 0 : 0;
    amount = json.containsKey('amount') ? json['amount'] ?? 0 : 0;
    discount = json.containsKey('discount') ? json['discount'] ?? 0 : 0;
    vat = json.containsKey('vat') ? json['vat'] ?? 0 : 0;
    net = json.containsKey('net') ? json['net'] ?? 0 : 0;
    total = json.containsKey('total') ? json['total'] ?? 0 : 0;
    lineNumber = json.containsKey('line_number') ? json['line_number'] ?? 0 : 0;
    quantity = json.containsKey('quantity') ? json['quantity'] ?? 0 : 0;
    description = json.containsKey('description')
        ? json['description'] ?? ''
        : '';
    createdAt = json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'].toString())
        : null;
    updatedAt = json['updatedAt'] != null
        ? DateTime.tryParse(json['updatedAt'].toString())
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['id'] = id;
    data['name'] = nameId;
    data['quantity'] = quantity;
    data['discount'] = discount;
    data['price'] = price;
    data['description'] = description;
    data['amount'] = amount;
    data['vat'] = vat;
    data['net'] = net;
    data['total'] = total;
    data['line_number'] = lineNumber;
    data['is_modified'] = isModified;
    data['deleted'] = deleted;
    data['added'] = added;
    return data;
  }
}
