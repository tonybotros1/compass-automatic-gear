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
    id = json['_id'] as String?;
    fullName = json['full_name'] as String?;
    relationship = json['relationship'] as String?;
    phoneNumber = json['phone_number'] as String?;
    gender = json['gender'] as String?;

    /// SAFE Date Parsing
    final dob = json['date_of_birth'];
    if (dob != null && dob is String && dob.isNotEmpty) {
      dateOfBirth = DateTime.tryParse(dob);
    } else {
      dateOfBirth = null;
    }

    nationality = json['nationality'] as String?;
    emailAddress = json['email_address'] as String?;
    note = json['note'] as String?;

    /// SAFE BOOL
    isEmergency = json['is_emergency'] is bool
        ? json['is_emergency']
        : false;

    companyId = json['company_id'] as String?;
    employeeId = json['employee_id'] as String?;
    relationshipName = json['relationship_name'] as String?;
    genderName = json['gender_name'] as String?;
    nationalityName = json['nationality_name'] as String?;
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'full_name': fullName,
      'relationship': relationship,
      'phone_number': phoneNumber,
      'gender': gender,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'nationality': nationality,
      'email_address': emailAddress,
      'note': note,
      'is_emergency': isEmergency,
      'company_id': companyId,
      'employee_id': employeeId,
      'relationship_name': relationshipName,
      'gender_name': genderName,
      'nationality_name': nationalityName,
    };
  }
}