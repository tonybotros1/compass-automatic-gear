class BaseModelForIssuingItems {
  String? id;
  String? issueId;
  String? name;
  String? code;
  String? number;
  int? finalQuantity;
  double? lastPrice;
  double? total;
  bool? isAdded;
  bool? isModified;
  bool? isDeleted;
  bool? isSelected;

  BaseModelForIssuingItems({
    this.id,
    this.issueId,
    this.name,
    this.code,
    this.finalQuantity,
    this.lastPrice,
    this.isAdded,
    this.isDeleted,
    this.isModified,
    this.total,
    this.isSelected,
    this.number,
  });

  BaseModelForIssuingItems.fromJsonForInventoryItems(
    Map<String, dynamic> json,
  ) {
    id = json['_id'];
    name = json.containsKey('name') ? json['name'] ?? '' : '';
    code = json.containsKey('code') ? json['code'] ?? '' : '';
    finalQuantity = json.containsKey('final_quantity')
        ? json['final_quantity'] ?? ''
        : '';
    lastPrice = json.containsKey('last_price') ? json['last_price'] ?? '' : '';
    total = json.containsKey('total') ? json['total'] ?? 0 : 0;
  }

  BaseModelForIssuingItems.fromJsonForConverters(Map<String, dynamic> json) {
    id = json['_id'];
    name = json.containsKey('name') ? json['name'] ?? '' : '';
    code = json.containsKey('code') ? json['code'] ?? '' : '';
    finalQuantity = json.containsKey('final_quantity')
        ? json['final_quantity'] ?? ''
        : '';
    number = json.containsKey('converter_number')
        ? json['converter_number'] ?? ''
        : '';
    lastPrice = json.containsKey('last_price') ? json['last_price'] ?? '' : '';
    total = json.containsKey('total') ? json['total'] ?? 0 : 0;
  }

  Map<String, dynamic> toJsonForinventoryItems() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['issue_id'] = issueId;
    data['name'] = name;
    data['code'] = code;
    data['final_quantity'] = finalQuantity;
    data['last_price'] = lastPrice;
    data['total'] = total;
    data['is_added'] = isAdded;
    data['is_deleted'] = isDeleted;
    data['is_midified'] = isModified;
    data['is_selected'] = isSelected;
    return data;
  }

  Map<String, dynamic> toJsonForConverters() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['issue_id'] = issueId;
    data['name'] = name;
    data['code'] = code;
    data['final_quantity'] = finalQuantity;
    data['last_price'] = lastPrice;
    data['total'] = total;
    data['is_added'] = isAdded;
    data['is_deleted'] = isDeleted;
    data['is_midified'] = isModified;
    data['is_selected'] = isSelected;
    return data;
  }
}
