class EmployeeAssignmentsBalancesModel {
  String? id;
  String? name;
  double? balance;

  EmployeeAssignmentsBalancesModel({this.id, this.name, this.balance});

  EmployeeAssignmentsBalancesModel.fromJson(Map<String, dynamic> json) {
    id = _stringFromJson(json['_id']);
    name = _stringFromJson(json['name']);
    balance = _doubleFromJson(json['balance']);
  }

  static String _stringFromJson(dynamic value) => value?.toString() ?? '';

  static double _doubleFromJson(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
