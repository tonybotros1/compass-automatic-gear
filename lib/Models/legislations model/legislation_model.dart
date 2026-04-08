class LegislationModel {
  final String ?id;
  final String? name;

  LegislationModel({this.id, this.name});

  factory LegislationModel.fromJson(Map<String, dynamic> json) {
    return LegislationModel(id: json['_id'] ?? '', name: json['name'] ?? '');
  }
}
