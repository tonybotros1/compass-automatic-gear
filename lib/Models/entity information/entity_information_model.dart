class EntityInformationModel {
  String? id;
  double? creditLimit;
  int? warrantyDays;
  List<EntityAddress>? entityAddress;
  List<String>? entityCode;
  String? entityName;
  List<EntityPhone>? entityPhone;
  String? entityPicture;
  List<EntitySocial>? entitySocial;
  String? entityStatus;
  String? entityType;
  String? groupName;
  String? industry;
  bool? status;
  String? trn;
  String? salesmanId;
  String? salesman;
  String? industryId;
  String? entityTypeId;
  DateTime? createdAt;
  DateTime? updatedAt;

  EntityInformationModel({
    this.id,
    this.creditLimit,
    this.entityAddress,
    this.entityCode,
    this.entityName,
    this.entityPhone,
    this.entityPicture,
    this.entitySocial,
    this.entityStatus,
    this.entityType,
    this.groupName,
    this.industry,
    this.status,
    this.trn,
    this.salesmanId,
    this.salesman,
    this.industryId,
    this.entityTypeId,
    this.createdAt,
    this.updatedAt,
    this.warrantyDays,
  });
  EntityInformationModel.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('_id') ? json['_id'] ?? '' : '';
    creditLimit = (json['credit_limit'] as num?)?.toDouble() ?? 0;
    warrantyDays = json.containsKey('warranty_days')
        ? (json['warranty_days'] != null
              ? int.tryParse(json['warranty_days'].toString()) ?? 0
              : 0)
        : 0;
    if (json.containsKey('entity_address') &&
        json['entity_address'] is List &&
        (json['entity_address'] as List).isNotEmpty) {
      entityAddress = <EntityAddress>[];
      for (var v in json['entity_address']) {
        entityAddress!.add(EntityAddress.fromJson(v));
      }
    } else {
      entityAddress = <EntityAddress>[];
    }

    entityCode = json.containsKey('entity_code') && json['entity_code'] is List
        ? List<String>.from(json['entity_code'])
        : <String>[];

    entityName = json.containsKey('entity_name')
        ? json['entity_name'] ?? ''
        : '';
    if (json.containsKey('entity_phone') &&
        json['entity_phone'] is List &&
        (json['entity_phone'] as List).isNotEmpty) {
      entityPhone = <EntityPhone>[];
      for (var v in json['entity_phone']) {
        entityPhone!.add(EntityPhone.fromJson(v));
      }
    } else {
      entityPhone = <EntityPhone>[];
    }
    entityPicture = json.containsKey('entity_picture')
        ? json['entity_picture'] ?? ''
        : '';
    if (json.containsKey('entity_social') &&
        json['entity_social'] is List &&
        (json['entity_social'] as List).isNotEmpty) {
      entitySocial = <EntitySocial>[];
      for (var v in json['entity_social']) {
        entitySocial!.add(EntitySocial.fromJson(v));
      }
    } else {
      entitySocial = <EntitySocial>[];
    }
    entityStatus = json.containsKey('entity_status')
        ? json['entity_status'] ?? ''
        : '';
    entityType = json.containsKey('entity_type')
        ? json['entity_type'] ?? ''
        : '';
    groupName = json.containsKey('group_name') ? json['group_name'] ?? '' : '';
    industry = json.containsKey('industry') ? json['industry'] ?? '' : '';
    status = json.containsKey('status') ? json['status'] ?? '' : '';
    trn = json.containsKey('trn') ? json['trn']?.toString() ?? '' : '';
    createdAt =
        DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now();
    updatedAt =
        DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now();
    salesmanId = json.containsKey('salesman_id')
        ? json['salesman_id'] ?? ''
        : '';
    salesman = json.containsKey('salesman') ? json['salesman'] ?? '' : '';
    industryId = json.containsKey('industry_id')
        ? json['industry_id'] ?? ''
        : '';
    entityTypeId = json.containsKey('entity_type_id')
        ? json['entity_type_id'] ?? ''
        : '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['credit_limit'] = creditLimit;
    if (entityAddress != null) {
      data['entity_address'] = entityAddress!.map((v) => v.toJson()).toList();
    }
    data['entity_code'] = entityCode;
    data['entity_name'] = entityName;
    if (entityPhone != null) {
      data['entity_phone'] = entityPhone!.map((v) => v.toJson()).toList();
    }
    data['entity_picture'] = entityPicture;
    if (entitySocial != null) {
      data['entity_social'] = entitySocial!.map((v) => v.toJson()).toList();
    }
    data['entity_status'] = entityStatus;
    data['entity_type'] = entityType;
    data['group_name'] = groupName;
    data['industry'] = industry;
    data['status'] = status;
    data['trn'] = trn;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['salesman_id'] = salesmanId;
    data['salesman'] = salesman;
    data['industry_id'] = industryId;
    data['entity_type_id'] = entityTypeId;
    return data;
  }
}

class EntityAddress {
  String? line;
  bool? isPrimary;
  String? countryId;
  String? country;
  String? cityId;
  String? city;

  EntityAddress({
    this.line,
    this.isPrimary,
    this.countryId,
    this.country,
    this.cityId,
    this.city,
  });

  EntityAddress.fromJson(Map<String, dynamic> json) {
    line = json.containsKey('line') ? json['line']?.toString() ?? '' : '';
    isPrimary = json.containsKey('isPrimary')
        ? json['isPrimary'] ?? false
        : false;
    countryId = json.containsKey('country_id')
        ? json['country_id']?.toString() ?? ''
        : '';
    country = json.containsKey('country')
        ? json['country']?.toString() ?? ''
        : '';
    cityId = json.containsKey('city_id')
        ? json['city_id']?.toString() ?? ''
        : '';
    city = json.containsKey('city') ? json['city']?.toString() ?? '' : '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['line'] = line;
    data['isPrimary'] = isPrimary;
    data['country_id'] = countryId;
    data['country'] = country;
    data['city_id'] = cityId;
    data['city'] = city;
    return data;
  }
}

class EntityPhone {
  String? number;
  String? name;
  String? jobTitle;
  String? email;
  bool? isPrimary;
  String? typeId;
  String? type;

  EntityPhone({
    this.number,
    this.name,
    this.jobTitle,
    this.email,
    this.isPrimary,
    this.typeId,
    this.type,
  });

  EntityPhone.fromJson(Map<String, dynamic> json) {
    number = json.containsKey('number') ? json['number'] ?? '' : '';
    name = json.containsKey('name') ? json['name'] ?? '' : '';
    jobTitle = json.containsKey('job_title') ? json['job_title'] ?? '' : '';
    email = json.containsKey('email') ? json['email'] ?? '' : '';
    isPrimary = json.containsKey('isPrimary')
        ? json['isPrimary'] ?? false
        : false;
    typeId = json.containsKey('type_id') ? json['type_id'] ?? '' : '';
    type = json.containsKey('type') ? json['type'] ?? '' : '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['number'] = number;
    data['name'] = name;
    data['job_title'] = jobTitle;
    data['email'] = email;
    data['isPrimary'] = isPrimary;
    data['type_id'] = typeId;
    data['type'] = type;
    return data;
  }
}

class EntitySocial {
  String? link;
  String? typeId;
  String? type;

  EntitySocial({this.link, this.typeId, this.type});

  EntitySocial.fromJson(Map<String, dynamic> json) {
    link = json.containsKey('link') ? json['link'] ?? '' : '';
    typeId = json.containsKey('type_id') ? json['type_id'] ?? '' : '';
    type = json.containsKey('type') ? json['type'] ?? '' : '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['link'] = link;
    data['type_id'] = typeId;
    data['type'] = type;
    return data;
  }
}
