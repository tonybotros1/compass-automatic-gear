import '../payroll elements/based_elements_model.dart';

class BalancesModel {
  String? id;
  String? name;
  String? type;
  String? description;
  bool? showInAssignment;
  bool? showInPayroll;
  bool? showInLeave;
  List<BasedElementsModel>? elementDetails;
  // List<BasedElementsModel>? elementDetails;

  BalancesModel({
    this.id,
    this.name,
    this.type,
    this.description,
    this.showInAssignment,
    this.showInPayroll,
    this.showInLeave,
    this.elementDetails,
    // this.elementDetails,
  });

  factory BalancesModel.fromJson(Map<String, dynamic> json) {
    return BalancesModel(
      id: json.containsKey('_id') ? json['_id']?.toString() : null,
      description: json.containsKey('description')
          ? json['description']?.toString()
          : null,
      name: json.containsKey('name') ? json['name']?.toString() : null,
      type: json.containsKey('type') ? json['type']?.toString() : null,
      showInAssignment: json.containsKey('show_on_assignment')
          ? json['show_on_assignment']
          : false,
      showInPayroll: json.containsKey('show_on_payroll')
          ? json['show_on_payroll']
          : false,
      showInLeave: json.containsKey('show_on_leave')
          ? json['show_on_leave']
          : false,

      elementDetails:
          json.containsKey('element_details') && json['element_details'] is List
          ? (json['element_details'] as List)
                .whereType<Map<String, dynamic>>()
                .map((v) => BasedElementsModel.fromJson(v))
                .toList()
          : [],

      // elementDetails:
      //     json.containsKey('element_details') && json['element_details'] is List
      //     ? (json['element_details'] as List)
      //           .whereType<Map<String, dynamic>>()
      //           .map((v) => BasedElementsModel.fromJson(v))
      //           .toList()
      //     : [],
    );
  }
}
