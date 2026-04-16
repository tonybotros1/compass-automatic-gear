class BasedElementsModel {
  final String? id;
  final String? elementName;
  final String? type;

  BasedElementsModel({this.id, this.elementName, this.type});

  factory BasedElementsModel.fromJson(Map<String, dynamic> json) {
    return BasedElementsModel(
      id: json.containsKey('_id') ? json['_id'] ?? '' : '',
      elementName: json.containsKey('name') ? json['name'] ?? '' : '',
      type: json.containsKey('type') ? json['type'] ?? '' : '',
    );
  }
}
