class ListModel {
  final String id;
  final String name;
  final String code;
  final String masterdBy;
  final bool status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ListModel({
    required this.id,
    required this.name,
    required this.code,
    required this.masterdBy,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ListModel.fromJson(Map<String, dynamic> json) {
    return ListModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      masterdBy: json['mastered_by'] ?? '',
      code: json['code'] ?? '',
      status: json['status'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['mastered_by'] = masterdBy;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
