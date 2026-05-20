class EmployeeHealthCardModel {
  String? id;
  String? healthCardType;
  String? healthCardTypeId;
  String? healthCardHolder;
  String? healthCardHolderId;
  String? healthCardHolderType;
  String? cardNumber;
  String? insuranceCompany;
  String? insuranceCompanyId;
  DateTime? issueDate;
  DateTime? expiryDate;
  double? cost;
  double? employeeContribution;
  String? employeeId;

  EmployeeHealthCardModel({
    this.id,
    this.healthCardType,
    this.healthCardTypeId,
    this.healthCardHolder,
    this.healthCardHolderId,
    this.healthCardHolderType,
    this.cardNumber,
    this.insuranceCompany,
    this.insuranceCompanyId,
    this.issueDate,
    this.expiryDate,
    this.cost,
    this.employeeContribution,
    this.employeeId,
  });

  static String _toStringValue(dynamic value) => value?.toString() ?? '';

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  static String _firstString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      if (json.containsKey(key)) return _toStringValue(json[key]);
    }
    return '';
  }

  EmployeeHealthCardModel.fromJson(Map<String, dynamic> json) {
    id = _firstString(json, ['_id', 'id']);
    healthCardTypeId = _firstString(json, ['health_card_type', 'type']);
    healthCardType = _firstString(json, [
      'health_card_type_name',
      'health_card_type_value',
      'type_name',
    ]);
    healthCardHolderId = _firstString(json, ['health_card_holder']);
    healthCardHolder = _firstString(json, [
      'health_card_holder_name',
      'health_card_holder_value',
      'holder_name',
    ]);
    healthCardHolderType = _firstString(json, ['health_card_holder_type']);
    cardNumber = _firstString(json, ['card_number', 'number']);
    insuranceCompanyId = _firstString(json, ['insurance_company']);
    insuranceCompany = _firstString(json, [
      'insurance_company_name',
      'insurance_company_value',
      'insurance_co_name',
    ]);
    issueDate = _toDate(
      json.containsKey('issue_date') ? json['issue_date'] : null,
    );
    expiryDate = _toDate(
      json.containsKey('expiry_date') ? json['expiry_date'] : null,
    );
    cost = json.containsKey('cost') ? _toDouble(json['cost']) : 0;
    employeeContribution = json.containsKey('employee_contribution')
        ? _toDouble(json['employee_contribution'])
        : 0;
    employeeId = _firstString(json, ['employee_id']);
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'health_card_type': healthCardTypeId,
      'health_card_type_value': healthCardType,
      'health_card_holder': healthCardHolderId,
      'health_card_holder_value': healthCardHolder,
      'health_card_holder_type': healthCardHolderType,
      'card_number': cardNumber,
      'insurance_company': insuranceCompanyId,
      'insurance_company_value': insuranceCompany,
      'issue_date': issueDate?.toIso8601String(),
      'expiry_date': expiryDate?.toIso8601String(),
      'cost': cost,
      'employee_contribution': employeeContribution,
      'employee_id': employeeId,
    };
  }
}
