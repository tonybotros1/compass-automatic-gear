class ValueModel {
  final String id;
  final String name;
  final String restrictedBy;
  final bool status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ValueModel({
    required this.id,
    required this.name,
    required this.restrictedBy,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ValueModel.fromJson(Map<String, dynamic> json) {
    return ValueModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      restrictedBy: json['restricted_by'] ?? '',
      status: json['status'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
