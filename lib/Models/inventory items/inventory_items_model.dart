class InventoryItemsModel {
  final String id;
  final String name;
  final String code;
  final double minQuantity;
  final DateTime createdAt;
  final DateTime updatedAt;

  InventoryItemsModel({
    required this.id,
    required this.name,
    required this.code,
    required this.minQuantity,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InventoryItemsModel.fromJson(Map<String, dynamic> json) {
    return InventoryItemsModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      minQuantity: json['min_quantity'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
