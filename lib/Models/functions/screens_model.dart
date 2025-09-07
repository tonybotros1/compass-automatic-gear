class FunctionsModel {
  final String id;
  final String name;
  final String routeName;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  FunctionsModel({
    required this.id,
    required this.name,
    required this.routeName,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FunctionsModel.fromJson(Map<String, dynamic> json) {
    return FunctionsModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      routeName: json['route_name'] ?? '',
      description: json['description'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
