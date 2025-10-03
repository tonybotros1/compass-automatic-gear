class Model {
  final String id;
  final String name;
  final bool status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Model({
    required this.id,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
