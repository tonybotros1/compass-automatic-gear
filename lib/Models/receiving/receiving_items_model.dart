class ReceivingItemsModel {
  String? id;
  final String? uuid;
  final String? inventoryItemId;
  final String? itemName;
  final String? itemCode;
  final String? receivingId;
  final double? quantity;
  final double? originalPrice;
  final double? discount;
  final double? addCost;
  final double? addDisc;
  final double? localPrice;
  final double? total;
  final double? vat;
  final double? net;
  final double? totalForAllItems;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  bool? isModified;
  bool? isDeleted;
  bool? isAdded;

  ReceivingItemsModel({
    this.id,
    this.uuid,
    this.inventoryItemId,
    this.itemCode,
    this.itemName,
    this.quantity,
    this.originalPrice,
    this.discount,
    this.addCost,
    this.addDisc,
    this.localPrice,
    this.total,
    this.vat,
    this.net,
    this.totalForAllItems,
    this.createdAt,
    this.updatedAt,
    this.isDeleted,
    this.isModified,
    this.isAdded,
    this.receivingId,
  });

  factory ReceivingItemsModel.fromJson(Map<String, dynamic> json) {
    return ReceivingItemsModel(
      id: json['_id'] ?? '',
      uuid: json['uuid'],
      inventoryItemId: json['inventory_item_id'] ?? '',
      itemCode: json['inventory_item_code'] ?? '',
      itemName: json['inventory_item_name'] ?? '',
      quantity: json['quantity'] ?? 0,
      originalPrice: json['original_price'],
      discount: json['discount'],
      vat: json['vat'] ?? 0,
      addCost: json['add_cost'],
      addDisc: json['add_disc'],
      localPrice: json['local_price'],
      net: json['net'],
      total: json['total'],
      receivingId: json['receiving_id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uuid'] = uuid;
    data['id'] = id;
    data['inventory_item_id'] = inventoryItemId;
    data['quantity'] = quantity;
    data['discount'] = discount;
    data['vat'] = vat;
    data['original_price'] = originalPrice;
    data['receiving_id'] = receivingId;
    data["is_added"] = isAdded;
    data['is_deleted'] = isDeleted;
    data['is_modified'] = isModified;
    return data;
  }

  ReceivingItemsModel copyJson() {
    return ReceivingItemsModel(
      id: id,
      uuid: uuid,
      inventoryItemId: inventoryItemId,
      itemCode: itemCode,
      itemName: itemName,
      quantity: quantity,
      originalPrice: originalPrice,
      discount: discount,
      addCost: addCost,
      addDisc: addDisc,
      localPrice: localPrice,
      total: total,
      vat: vat,
      net: net,
      totalForAllItems: totalForAllItems,
      createdAt: createdAt != null
          ? DateTime.fromMillisecondsSinceEpoch(
              createdAt!.millisecondsSinceEpoch,
            )
          : null,
      updatedAt: updatedAt != null
          ? DateTime.fromMillisecondsSinceEpoch(
              updatedAt!.millisecondsSinceEpoch,
            )
          : null,
      isDeleted: isDeleted,
      isModified: isModified,
      isAdded: isAdded,
      receivingId: receivingId,
    );
  }

}
