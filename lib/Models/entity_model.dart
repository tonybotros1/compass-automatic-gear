// class EntityModel {
//   List<EntitySocial>? entitySocial;
//   List<String>? entityCode;
//   String? entityName;
//   String? companyId;
//   String? groupName;
//   String? entityPicture;
//   String? entityStatus;
//   String? entityType;
//   String? trn;
//   int? creditLimit;
//   String? industry;
//   bool? status;
//   List<EntityPhone>? entityPhone;
//   List<EntityAddress>? entityAddress;
//   String? addedDate;
//   String? salesMan;

//   EntityModel(
//       {this.entitySocial,
//       this.entityCode,
//       this.entityName,
//       this.companyId,
//       this.groupName,
//       this.entityPicture,
//       this.entityStatus,
//       this.entityType,
//       this.trn,
//       this.creditLimit,
//       this.industry,
//       this.status,
//       this.entityPhone,
//       this.entityAddress,
//       this.addedDate,
//       this.salesMan});

//   EntityModel.fromJson(Map<String, dynamic> json) {
//     if (json['entity_social'] != null) {
//       entitySocial = <EntitySocial>[];
//       json['entity_social'].forEach((v) {
//         entitySocial!.add(EntitySocial.fromJson(v));
//       });
//     }
//     entityCode = json['entity_code'].cast<String>();
//     entityName = json['entity_name'];
//     companyId = json['company_id'];
//     groupName = json['group_name'];
//     entityPicture = json['entity_picture'];
//     entityStatus = json['entity_status'];
//     entityType = json['entity_type'];
//     trn = json['trn'];
//     creditLimit = json['credit_limit'];
//     industry = json['industry'];
//     status = json['status'];
//     if (json['entity_phone'] != null) {
//       entityPhone = <EntityPhone>[];
//       json['entity_phone'].forEach((v) {
//         entityPhone!.add(EntityPhone.fromJson(v));
//       });
//     }
//     if (json['entity_address'] != null) {
//       entityAddress = <EntityAddress>[];
//       json['entity_address'].forEach((v) {
//         entityAddress!.add(EntityAddress.fromJson(v));
//       });
//     }
//     addedDate = json['added_date'];
//     salesMan = json['sales_man'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (entitySocial != null) {
//       data['entity_social'] =
//           entitySocial!.map((v) => v.toJson()).toList();
//     }
//     data['entity_code'] = entityCode;
//     data['entity_name'] = entityName;
//     data['company_id'] = companyId;
//     data['group_name'] = groupName;
//     data['entity_picture'] = entityPicture;
//     data['entity_status'] = entityStatus;
//     data['entity_type'] = entityType;
//     data['trn'] = trn;
//     data['credit_limit'] = creditLimit;
//     data['industry'] = industry;
//     data['status'] = status;
//     if (entityPhone != null) {
//       data['entity_phone'] = entityPhone!.map((v) => v.toJson()).toList();
//     }
//     if (entityAddress != null) {
//       data['entity_address'] =
//           entityAddress!.map((v) => v.toJson()).toList();
//     }
//     data['added_date'] = addedDate;
//     data['sales_man'] = salesMan;
//     return data;
//   }
// }

// class EntitySocial {
//   String? type;
//   String? link;

//   EntitySocial({this.type, this.link});

//   EntitySocial.fromJson(Map<String, dynamic> json) {
//     type = json['type'];
//     link = json['link'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['type'] = type;
//     data['link'] = link;
//     return data;
//   }
// }

// class EntityPhone {
//   String? name;
//   String? jobTitle;
//   String? number;
//   String? email;
//   String? type;
//   bool? isPrimary;

//   EntityPhone(
//       {this.name,
//       this.jobTitle,
//       this.number,
//       this.email,
//       this.type,
//       this.isPrimary});

//   EntityPhone.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     jobTitle = json['job_title'];
//     number = json['number'];
//     email = json['email'];
//     type = json['type'];
//     isPrimary = json['isPrimary'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['name'] = name;
//     data['job_title'] = jobTitle;
//     data['number'] = number;
//     data['email'] = email;
//     data['type'] = type;
//     data['isPrimary'] = isPrimary;
//     return data;
//   }
// }

// class EntityAddress {
//   String? city;
//   bool? isPrimary;
//   String? country;
//   String? line;

//   EntityAddress({this.city, this.isPrimary, this.country, this.line});

//   EntityAddress.fromJson(Map<String, dynamic> json) {
//     city = json['city'];
//     isPrimary = json['isPrimary'];
//     country = json['country'];
//     line = json['line'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['city'] = city;
//     data['isPrimary'] = isPrimary;
//     data['country'] = country;
//     data['line'] = line;
//     return data;
//   }
// }
