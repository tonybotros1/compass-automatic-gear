class ContactsAndRelativesModel {
  String? id;
  String? fullName;
  String? relationship;
  String? phoneNumber;
  String? gender;
  DateTime? dateOfBirth;
  String? nationality;
  String? emailAddress;
  String? note;
  bool? isEmergency;
  String? companyId;
  String? employeeId;
  String? relationshipName;
  String? genderName;
  String? nationalityName;

  ContactsAndRelativesModel({
    this.id,
    this.fullName,
    this.relationship,
    this.phoneNumber,
    this.gender,
    this.dateOfBirth,
    this.nationality,
    this.emailAddress,
    this.note,
    this.isEmergency,
    this.companyId,
    this.employeeId,
    this.relationshipName,
    this.genderName,
    this.nationalityName,
  });

  ContactsAndRelativesModel.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('_id') ? json['_id'] ?? '' : '';
    fullName = json.containsKey('full_name') ? json['full_name'] ?? '' : '';
    relationship = json.containsKey('relationship')
        ? json['relationship'] ?? ''
        : '';
    phoneNumber = json.containsKey('phone_number')
        ? json['phone_number'] ?? ''
        : '';
    gender = json.containsKey('gender') ? json['gender'] ?? '' : '';
    dateOfBirth = json.containsKey('date_of_birth')
        ? DateTime.tryParse(json['date_of_birth'])
        : null;
    nationality = json.containsKey('nationality')
        ? json['nationality'] ?? ''
        : '';
    emailAddress = json.containsKey('email_address')
        ? json['email_address'] ?? ''
        : '';
    note = json.containsKey('note') ? json['note'] ?? "" : ' ';
    isEmergency = json.containsKey('is_emergency')
        ? json['is_emergency'] ?? false
        : false;
    relationshipName = json.containsKey('relationship_name')
        ? json['relationship_name'] ?? ''
        : ' ';
    genderName = json.containsKey('gender_name')
        ? json['gender_name'] ?? ''
        : ' ';
    nationalityName = json.containsKey('nationality_name')
        ? json['nationality_name'] ?? ''
        : ' ';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['full_name'] = fullName;
    data['relationship'] = relationship;
    data['phone_number'] = phoneNumber;
    data['gender'] = gender;
    data['date_of_birth'] = dateOfBirth;
    data['nationality'] = nationality;
    data['email_address'] = emailAddress;
    data['note'] = note;
    data['is_emergency'] = isEmergency;
    data['company_id'] = companyId;
    data['employee_id'] = employeeId;
    data['relationship_name'] = relationshipName;
    data['gender_name'] = genderName;
    data['nationality_name'] = nationalityName;
    return data;
  }
}
