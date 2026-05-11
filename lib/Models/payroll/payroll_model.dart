import 'period_details_model.dart';

class PayrollModel {
  final String? id;
  final String? name;
  final String? notes;
  final String? paymentType;
  final String? paymentTypeId;
  List<PeriodDetailsModel>? allParollDetails;

  PayrollModel({
    this.id,
    this.name,
    this.notes,
    this.allParollDetails,
    this.paymentType,
    this.paymentTypeId,
  });

  factory PayrollModel.fromJson(Map<String, dynamic> json) {
    return PayrollModel(
      id: json.containsKey('_id') ? json['_id']?.toString() ?? '' : '',
      name: json.containsKey('name') ? json['name']?.toString() ?? '' : '',
      notes: json.containsKey('notes') ? json['notes']?.toString() ?? "" : "",
      paymentTypeId: json.containsKey('payment_type')
          ? json['payment_type']?.toString() ?? ""
          : "",
      paymentType: json.containsKey('payment_type_name')
          ? json['payment_type_name']?.toString() ?? ""
          : "",
      allParollDetails: json['details'] is List
          ? List<PeriodDetailsModel>.from(
              (json['details'] as List).whereType<Map<String, dynamic>>().map(
                (det) => PeriodDetailsModel.fromJson(det),
              ),
            )
          : [],
    );
  }
}
