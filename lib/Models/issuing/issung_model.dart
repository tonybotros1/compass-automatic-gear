import 'base_model_for_issing_items.dart';

class IssuingModel {
  String? id;
  String? date;
  String? branch;
  String? issueType;
  String? jobCardId;
  String? converterId;
  String? note;
  String? receivedBy;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? companyId;
  String? issuingNumber;
  String? branchName;
  String? issueTypeName;
  String? receivedByName;
  String? detailsString;
  double? total;
  List<BaseModelForIssuingItems>? itemsDetailsSection;
  List<BaseModelForIssuingItems>? convertersDetailsSection;

  IssuingModel(
      {this.id,
      this.date,
      this.branch,
      this.issueType,
      this.jobCardId,
      this.converterId,
      this.note,
      this.receivedBy,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.companyId,
      this.issuingNumber,
      this.branchName,
      this.issueTypeName,
      this.receivedByName,
      this.detailsString,
      this.itemsDetailsSection,
      this.total,
      this.convertersDetailsSection});

  IssuingModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    date = json['date'];
    branch = json['branch'];
    issueType = json['issue_type'];
    jobCardId = json['job_card_id'];
    converterId = json['converter_id'];
    note = json['note'];
    receivedBy = json['received_by'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    companyId = json['company_id'];
    issuingNumber = json['issuing_number'];
    branchName = json['branch_name'];
    issueTypeName = json['issue_type_name'];
    receivedByName = json['received_by_name'];
    detailsString = json['details_string'];
    total = json['totals'];
    if (json['items_details_section'] != null) {
      itemsDetailsSection = <BaseModelForIssuingItems>[];
      json['items_details_section'].forEach((v) {
        itemsDetailsSection!.add(BaseModelForIssuingItems.fromJsonForInventoryItems(v));
      });
    }
    if (json['converters_details_section'] != null) {
      convertersDetailsSection = <BaseModelForIssuingItems>[];
      json['converters_details_section'].forEach((v) {
        convertersDetailsSection!.add(BaseModelForIssuingItems.fromJsonForConverters(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['date'] = date;
    data['branch'] = branch;
    data['issue_type'] = issueType;
    data['job_card_id'] = jobCardId;
    data['converter_id'] = converterId;
    data['note'] = note;
    data['received_by'] = receivedBy;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['company_id'] = companyId;
    data['issuing_number'] = issuingNumber;
    data['branch_name'] = branchName;
    data['issue_type_name'] = issueTypeName;
    data['received_by_name'] = receivedByName;
    data['details_string'] = detailsString;
    if (itemsDetailsSection != null) {
      data['items_details_section'] =
          itemsDetailsSection!.map((v) => v.toJsonForinventoryItems()).toList();
    }
    if (convertersDetailsSection != null) {
      data['converters_details_section'] =
          convertersDetailsSection!.map((v) => v.toJsonForConverters()).toList();
    }
    return data;
  }
}
