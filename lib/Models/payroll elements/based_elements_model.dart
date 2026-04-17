class BasedElementsModel {
  final String? id;
  final String? elementName;
  final String? elementNameValue;
  final String? type;

  BasedElementsModel({
    this.id,
    this.elementName,
    this.type,
    this.elementNameValue,
  });

  factory BasedElementsModel.fromJson(Map<String, dynamic> json) {
    return BasedElementsModel(
      id: json.containsKey('_id') ? json['_id'] ?? '' : '',
      elementNameValue: json.containsKey('name_value')
          ? json['name_value'] ?? ''
          : '',
      elementName: json.containsKey('name') ? json['name'] ?? '' : '',
      type: json.containsKey('type') ? json['type'] ?? '' : '',
    );
  }
}
