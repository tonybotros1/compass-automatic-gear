class CompanyModel {
  String? id;
  String? companyName;
  bool? status;
  String? createdAt;
  String? updatedAt;
  String? companyLogoUrl;
  String? companyLogoPublicId;
  String? industry;
  String? industryId;
  String? userId;
  String? userEmail;
  String? userName;
  String? userPhoneNumber;
  String? userAddress;
  String? userExpiryDate;
  String? userCountry;
  String? userCountryId;
  String? userCity;
  String? userCityId;
  List<MainUserRoles>? mainUserRoles;

  CompanyModel({
    this.id,
    this.companyName,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.companyLogoUrl,
    this.companyLogoPublicId,
    this.industry,
    this.industryId,
    this.userId,
    this.userEmail,
    this.userName,
    this.userPhoneNumber,
    this.userAddress,
    this.userExpiryDate,
    this.userCountry,
    this.userCountryId,
    this.userCity,
    this.userCityId,
    this.mainUserRoles,
  });

  CompanyModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? '';
    companyName = json['company_name'] ?? '';
    status = json['status'] ?? false;
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
    companyLogoUrl = json['company_logo_url'] ?? '';
    companyLogoPublicId = json['company_logo_public_id'] ?? '';
    industry = json['industry'] ?? '';
    industryId = json['industry_id'] ?? '';
    userId = json['user_id'] ?? '';
    userEmail = json['user_email'] ?? '';
    userName = json['user_name'] ?? '';
    userPhoneNumber = json['user_phone_number'] ?? '';
    userAddress = json['user_address'] ?? '';
    userExpiryDate = json['user_expiry_date'] ?? '';
    userCountry = json['user_country'] ?? '';
    userCountryId = json['user_country_id'] ?? '';
    userCity = json['user_city'] ?? '';
    userCityId = json['user_city_id'] ?? '';
    if (json['main_user_roles'] != null && json['main_user_roles'] is List) {
      mainUserRoles = <MainUserRoles>[];
      for (var v in json['main_user_roles']) {
        if (v is Map<String, dynamic>) {
          mainUserRoles!.add(MainUserRoles.fromJson(v));
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['company_name'] = companyName;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['company_logo_url'] = companyLogoUrl;
    data['company_logo_public_id'] = companyLogoPublicId;
    data['industry'] = industry;
    data['industry_id'] = industryId;
    data['user_id'] = userId;
    data['user_email'] = userEmail;
    data['user_name'] = userName;
    data['user_phone_number'] = userPhoneNumber;
    data['user_address'] = userAddress;
    data['user_expiry_date'] = userExpiryDate;
    data['user_country'] = userCountry;
    data['user_country_id'] = userCountryId;
    data['user_city'] = userCity;
    data['user_city_id'] = userCityId;
    if (mainUserRoles != null) {
      data['main_user_roles'] = mainUserRoles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MainUserRoles {
  String? sId;
  String? roleName;

  MainUserRoles({this.sId, this.roleName});

  MainUserRoles.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    roleName = json['role_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['role_name'] = roleName;
    return data;
  }
}
