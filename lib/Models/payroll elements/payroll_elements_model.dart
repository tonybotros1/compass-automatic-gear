import 'based_elements_model.dart';

class PayrollElementsModel {
  String? id;
  String? key;
  String? name;
  String? type;
  String? priority;
  String? comments;
  bool? isAllowOverride;
  bool? isRecurring;
  bool? isEntryValue;
  bool? isStandardLink;
  String? function;
  bool? isIndirect;
  List<BasedElementsModel>? elementDetails;

  PayrollElementsModel({
    this.id,
    this.key,
    this.name,
    this.type,
    this.priority,
    this.comments,
    this.isAllowOverride,
    this.isRecurring,
    this.isEntryValue,
    this.isStandardLink,
    this.function,
    this.isIndirect,
    this.elementDetails,
  });

  factory PayrollElementsModel.fromJson(Map<String, dynamic> json) {
    return PayrollElementsModel(
      id: json.containsKey('_id') ? json['_id']?.toString() : null,
      key: json.containsKey('key') ? json['key']?.toString() : null,
      name: json.containsKey('name') ? json['name']?.toString() : null,
      type: json.containsKey('type') ? json['type']?.toString() : null,
      priority: json.containsKey('priority')
          ? json['priority']?.toString()
          : null,
      comments: json.containsKey('comments')
          ? json['comments']?.toString()
          : null,
      function: json.containsKey('function')
          ? json['function']?.toString()
          : null,
      isAllowOverride: json.containsKey('is_allow_override')
          ? json['is_allow_override'] == true
          : null,
      isRecurring: json.containsKey('is_recurring')
          ? json['is_recurring'] == true
          : null,
      isEntryValue: json.containsKey('is_entry_value')
          ? json['is_entry_value'] == true
          : null,
      isStandardLink: json.containsKey('is_standard_link')
          ? json['is_standard_link'] == true
          : null,
      isIndirect: json.containsKey('is_indirect')
          ? json['is_indirect'] == true
          : null,
      elementDetails:
          json.containsKey('element_details') && json['element_details'] is List
          ? (json['element_details'] as List)
                .whereType<Map<String, dynamic>>()
                .map((v) => BasedElementsModel.fromJson(v))
                .toList()
          : [],
    );
  }
}
