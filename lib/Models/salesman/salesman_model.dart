class SalesmanModel {
  final String id;
  final String? name;
  final double? target;
  final DateTime createdAt;
  final DateTime updatedAt;

  SalesmanModel({
    required this.id,
    this.name,
    this.target,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SalesmanModel.fromJson(Map<String, dynamic> json) {
    return SalesmanModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      target: json['target'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
