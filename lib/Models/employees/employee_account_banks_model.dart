class EmployeeAccountBanksModel {
  String? bankName;
  String? bankNameId;
  String? accountNumber;
  String? iban;
  String? swiftCode;
  String? id;

  EmployeeAccountBanksModel({
    this.bankName,
    this.accountNumber,
    this.iban,
    this.swiftCode,
    this.id,
  });

  EmployeeAccountBanksModel.fromJson(Map<String, dynamic> json) {
    bankNameId = json.containsKey('bank_name') ? json['bank_name'] ?? '' : '';
    bankName = json.containsKey('bank_name_value')
        ? json['bank_name_value'] ?? ''
        : '';
    accountNumber = json.containsKey('account_number')
        ? json['account_number'] ?? ''
        : '';
    iban = json.containsKey('iban') ? json['iban'] ?? '' : '';
    swiftCode = json.containsKey('swift_code') ? json['swift_code'] ?? '' : '';
    id = json.containsKey('_id') ? json['_id'] ?? '' : '';
  }
}
