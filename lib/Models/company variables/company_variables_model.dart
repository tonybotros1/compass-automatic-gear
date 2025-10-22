class CompanyVariablesModel {
  String? sId;
  String? companyName;
  String? ownerId;
  bool? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? industry;
  String? companyLogoUrl;
  String? companyLogoPublicId;
  List<RolesDetails>? rolesDetails;
  String? industryName;
  String? countryName;
  String? cityName;
  String? ownerName;
  String? ownerEmail;
  String? ownerPhone;
  String? ownerAddress;
  double? vatPercentage;
  double? incentivePercentage;
  String? taxNumber;

  CompanyVariablesModel({
    this.sId,
    this.companyName,
    this.ownerId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.industry,
    this.companyLogoUrl,
    this.companyLogoPublicId,
    this.rolesDetails,
    this.industryName,
    this.countryName,
    this.cityName,
    this.ownerName,
    this.ownerEmail,
    this.ownerPhone,
    this.ownerAddress,
    this.vatPercentage,
    this.incentivePercentage,
    this.taxNumber,
  });

  CompanyVariablesModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id']?.toString();
    companyName = json['company_name']?.toString();
    ownerId = json['owner_id']?.toString();

    // Normalize boolean
    status = json['status'] == true || json['status'] == 1 || json['status'] == 'true';

    // Parse date fields safely
    createdAt = _parseDate(json['createdAt']);
    updatedAt = _parseDate(json['updatedAt']);

    industry = json['industry']?.toString();
    companyLogoUrl = json['company_logo_url']?.toString();
    companyLogoPublicId = json['company_logo_public_id']?.toString();

    vatPercentage = (json['vat_percentage'] != null)
        ? (json['vat_percentage'] as num).toDouble()
        : null;

    incentivePercentage = (json['incentive_percentage'] != null)
        ? (json['incentive_percentage'] as num).toDouble()
        : null;

    taxNumber = json['tax_number']?.toString();

    // Parse roles list
    if (json['roles_details'] != null) {
      rolesDetails = <RolesDetails>[];
      for (var v in json['roles_details']) {
        rolesDetails!.add(RolesDetails.fromJson(v));
      }
    }

    industryName = json['industry_name']?.toString();
    countryName = json['country_name']?.toString();
    cityName = json['city_name']?.toString();
    ownerName = json['owner_name']?.toString();
    ownerEmail = json['owner_email']?.toString();
    ownerPhone = json['owner_phone']?.toString();
    ownerAddress = json['owner_address']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['_id'] = sId;
    data['company_name'] = companyName;
    data['owner_id'] = ownerId;
    data['status'] = status;
    data['createdAt'] = createdAt?.toIso8601String();
    data['updatedAt'] = updatedAt?.toIso8601String();
    data['industry'] = industry;
    data['company_logo_url'] = companyLogoUrl;
    data['company_logo_public_id'] = companyLogoPublicId;
    data['vat_percentage'] = vatPercentage;
    data['incentive_percentage'] = incentivePercentage;
    data['tax_number'] = taxNumber;

    if (rolesDetails != null) {
      data['roles_details'] = rolesDetails!.map((v) => v.toJson()).toList();
    }

    data['industry_name'] = industryName;
    data['country_name'] = countryName;
    data['city_name'] = cityName;
    data['owner_name'] = ownerName;
    data['owner_email'] = ownerEmail;
    data['owner_phone'] = ownerPhone;
    data['owner_address'] = ownerAddress;

    return data;
  }

  /// Utility to safely parse DateTime from different formats
  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    try {
      return DateTime.tryParse(value.toString());
    } catch (_) {
      return null;
    }
  }
}

class RolesDetails {
  String? sId;
  String? roleName;

  RolesDetails({this.sId, this.roleName});

  RolesDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id']?.toString();
    roleName = json['role_name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['role_name'] = roleName;
    return data;
  }
}
