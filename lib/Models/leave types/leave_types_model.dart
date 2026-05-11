class LeaveTypesModel {
  final String? id;
  final String? name;
  final String? code;
  final String? type;
  final String? basedElement;
  final String? basedElementId;

  LeaveTypesModel({
    this.id,
    this.basedElement,
    this.code,
    this.name,
    this.type,
    this.basedElementId,
  });

  factory LeaveTypesModel.fromJson(Map<String, dynamic> json) {
    return LeaveTypesModel(
      id: json['_id']?.toString() ?? '',
      name: json.containsKey('name') ? json['name']?.toString() ?? '' : '',
      code: json.containsKey('code') ? json['code']?.toString() ?? '' : '',
      type: json.containsKey('type') ? json['type']?.toString() ?? '' : '',
      basedElement: json.containsKey('based_element_name')
          ? json['based_element_name']?.toString() ?? ''
          : '',
      basedElementId: json.containsKey('based_element')
          ? json['based_element']?.toString() ?? ''
          : '',
    );
  }
}
