class PayrollElementsModel {
  final String? id;
  final String? name;
  final String? key;
  final String? priority;
  final String? type;
  final String? comments;
  final bool? allowOverride;
  final bool? recurring;
  final bool? entryValue;
  final bool? standardLink;
  final bool? indirect;
  final String? functionName;

  PayrollElementsModel({
    this.id,
    this.name,
    this.key,
    this.priority,
    this.type,
    this.comments,
    this.allowOverride,
    this.entryValue,
    this.standardLink,
    this.recurring,
    this.functionName,
    this.indirect,
  });

  factory PayrollElementsModel.fromJson(Map<String, dynamic> json) {
    return PayrollElementsModel(
      id: json.containsKey('_id') ? json['_id'] ?? '' : '',
      name: json.containsKey('name') ? json['name'] ?? '' : '',
      key: json.containsKey('key') ? json['key'] ?? '' : '',
      priority: json.containsKey('priority') ? json['priority'] ?? '' : '',
      type: json.containsKey('type') ? json['type'] ?? '' : '',
      comments: json.containsKey('comments') ? json['comments'] ?? '' : '',
      allowOverride: json.containsKey('is_allow_override')
          ? json['is_allow_override'] ?? false
          : false,
      recurring: json.containsKey('is_recurring')
          ? json['is_recurring'] ?? false
          : false,
      entryValue: json.containsKey('is_entry_value')
          ? json['is_entry_value'] ?? true
          : false,
      standardLink: json.containsKey('is_standard_link')
          ? json['is_standard_link'] ?? false
          : false,
      functionName: json.containsKey('function') ? json['function'] ?? '' : '',
      indirect: json.containsKey('is_indirect')
          ? json['is_indirect'] ?? false
          : false,
    );
  }
}
