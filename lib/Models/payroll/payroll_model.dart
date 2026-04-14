import 'period_details_model.dart';

class PayrollModel {
  final String? id;
  final String? name;
  final String? notes;
  List<PeriodDetailsModel>? allParollDetails;

  PayrollModel({this.id, this.name, this.notes, this.allParollDetails});

  factory PayrollModel.fromJson(Map<String, dynamic> json) {
    return PayrollModel(
      id: json.containsKey('_id') ? json['_id'] ?? '' : '',
      name: json.containsKey('name') ? json['name'] ?? '' : '',
      notes: json.containsKey('notes') ? json['notes'] ?? "" : "",
      allParollDetails: json['details'] != null
          ? List<PeriodDetailsModel>.from(
              json['details'].map((det) => PeriodDetailsModel.fromJson(det)),
            )
          : [],
    );
  }
}
