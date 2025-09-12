class ValueModel {
  final String id;
  final String name;
  final String masteredBy;
  final String masteredById;
  final bool status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ValueModel({
    required this.id,
    required this.name,
    required this.masteredBy,
    required this.masteredById,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ValueModel.fromJson(Map<String, dynamic> json) {
    return ValueModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      masteredBy: json['mastered_by'] ?? '',
      masteredById: json['mastered_by_id'] ?? '',
      status: json['status'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
