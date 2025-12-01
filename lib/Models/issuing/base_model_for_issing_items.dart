class BaseModelForIssuingItems {
  String? id;
  String? issueId;
  String? inventoryItemId;
  String? converterId;
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
    this.inventoryItemId,
    this.converterId,
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
    inventoryItemId = json.containsKey('inventory_item_id')
        ? json['inventory_item_id'] ?? ''
        : '';
    lastPrice = json.containsKey('last_price') ? json['last_price'] ?? '' : '';
    issueId = json.containsKey('issue_id') ? json['issue_id'] ?? '' : '';
    total = json.containsKey('total') ? json['total'] ?? 0 : 0;
  }

  BaseModelForIssuingItems.fromJsonForConverters(Map<String, dynamic> json) {
    id = json['_id'];
    name = json.containsKey('name') ? json['name'] ?? '' : '';
    converterId = json.containsKey('converter_id') ? json['converter_id'] ?? '' : '';
    finalQuantity = json.containsKey('final_quantity')
        ? json['final_quantity'] ?? ''
        : '';
    number = json.containsKey('converter_number')
        ? json['converter_number'] ?? ''
        : '';
    lastPrice = json.containsKey('last_price') ? json['last_price'] ?? '' : '';
    issueId = json.containsKey('issue_id') ? json['issue_id'] ?? '' : '';
    total = json.containsKey('total') ? json['total'] ?? 0 : 0;
  }

  Map<String, dynamic> toJsonForinventoryItems() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['issue_id'] = issueId;
    data['inventory_item_id'] = id;
    data['quantity'] = finalQuantity;
    data['price'] = lastPrice;
    data['total'] = total;
    data['is_added'] = isAdded;
    data['is_deleted'] = isDeleted;
    data['is_modified'] = isModified;
    data['is_selected'] = isSelected;
    return data;
  }

  Map<String, dynamic> toJsonForConverters() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['issue_id'] = issueId;
    data['converter_id'] = id;
    data['quantity'] = finalQuantity;
    data['price'] = lastPrice;
    data['total'] = total;
    data['is_added'] = isAdded;
    data['is_deleted'] = isDeleted;
    data['is_modified'] = isModified;
    data['is_selected'] = isSelected;
    return data;
  }
}
