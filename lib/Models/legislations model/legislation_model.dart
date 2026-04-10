class LegislationModel {
  final String? id;
  final String? name;
  final List<String>? weekend;

  LegislationModel({this.id, this.name, this.weekend});

  factory LegislationModel.fromJson(Map<String, dynamic> json) {
    return LegislationModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      weekend: json.containsKey('weekend') ? json['weekend'].cast<String>() ??[]: [],
    );
  }
}
