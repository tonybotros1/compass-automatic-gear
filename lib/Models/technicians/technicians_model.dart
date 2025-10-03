class TechnicianModel {
  String? id;
  String? job;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  TechnicianModel({
    this.id,
    this.createdAt,
    this.job,
    this.name,
    this.updatedAt,
  });

  TechnicianModel.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('_id') ? json['_id'] ?? "" : "";
    job = json.containsKey('job') ? json['job'] ?? "" : "";
    name = json.containsKey('name') ? json['name'] ?? "" : "";
    createdAt = DateTime.tryParse(json['createdAt']);
    updatedAt = DateTime.tryParse(json['updatedAt']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['createdAt'] = createdAt;
    data['job'] = job;
    data['name'] = name;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
