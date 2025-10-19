class JobTasksModel {
  final String id;
  final String? nameAR;
  final String? nameEN;
  final String? category;
  final double? points;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  JobTasksModel({
    required this.id,
    required this.nameAR,
    required this.nameEN,
    required this.category,
    required this.points,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JobTasksModel.fromJson(Map<String, dynamic> json) {
    return JobTasksModel(
      id: json['_id'] ?? '',
      nameAR: json['name_ar'] ?? '',
      nameEN: json['name_en'] ?? '',
      category: json['category'] ?? '',
      points: json['points'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
