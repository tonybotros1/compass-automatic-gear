import 'base_model_for_issing_items.dart';

class IssuingModel {
  String? id;
  DateTime? date;
  String? branch;
  String? issueType;
  String? jobCardId;
  String? converterId;
  String? note;
  String? receivedBy;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? companyId;
  String? issuingNumber;
  String? branchName;
  String? issueTypeName;
  String? receivedByName;
  String? detailsString;
  double? total;
  List<BaseModelForIssuingItems>? itemsDetailsSection;
  List<BaseModelForIssuingItems>? convertersDetailsSection;

  IssuingModel({
    this.id,
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
    this.convertersDetailsSection,
  });
  IssuingModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json.containsKey('_id') ? json['_id'] ?? '' : '';

      date = json.containsKey('date') && json['date'] != null
          ? DateTime.tryParse(json['date'].toString())
          : null;

      branch = json.containsKey('branch') ? json['branch'] ?? '' : '';

      issueType = json.containsKey('issue_type')
          ? json['issue_type'] ?? ''
          : '';

      jobCardId = json.containsKey('job_card_id')
          ? json['job_card_id'] ?? ''
          : '';

      converterId = json.containsKey('converter_id')
          ? json['converter_id'] ?? ''
          : '';

      note = json.containsKey('note') ? json['note'] ?? '' : '';

      receivedBy = json.containsKey('received_by')
          ? json['received_by'] ?? ''
          : '';

      status = json.containsKey('status') ? json['status'] ?? '' : '';

      createdAt = json.containsKey('createdAt') && json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null;

      updatedAt = json.containsKey('updatedAt') && json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null;

      companyId = json.containsKey('company_id')
          ? json['company_id'] ?? ''
          : '';

      issuingNumber = json.containsKey('issuing_number')
          ? json['issuing_number']?.toString() ?? ''
          : '';

      branchName = json.containsKey('branch_name')
          ? json['branch_name'] ?? ''
          : '';

      issueTypeName = json.containsKey('issue_type_name')
          ? json['issue_type_name'] ?? ''
          : '';

      receivedByName = json.containsKey('received_by_name')
          ? json['received_by_name'] ?? ''
          : '';

      detailsString = json.containsKey('details_string')
          ? json['details_string'] ?? ''
          : '';

      total = json.containsKey('totals')
          ? json['totals'] ?? 0.0
          : 0.0;

      if (json.containsKey('items_details_section') &&
          json['items_details_section'] != null) {
        itemsDetailsSection = <BaseModelForIssuingItems>[];
        for (var v in json['items_details_section']) {
          itemsDetailsSection!.add(
            BaseModelForIssuingItems.fromJsonForInventoryItems(v),
          );
        }
      }

      if (json.containsKey('converters_details_section') &&
          json['converters_details_section'] != null) {
        convertersDetailsSection = <BaseModelForIssuingItems>[];
        for (var v in json['converters_details_section']) {
          convertersDetailsSection!.add(
            BaseModelForIssuingItems.fromJsonForConverters(v),
          );
        }
      }
    } catch (e) {
    //   print('❌ Error parsing IssuingModel: $e');
    // print('StackTrace: $stackTrace');
    // print('JSON data: $json');
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
      data['items_details_section'] = itemsDetailsSection!
          .map((v) => v.toJsonForinventoryItems())
          .toList();
    }
    if (convertersDetailsSection != null) {
      data['converters_details_section'] = convertersDetailsSection!
          .map((v) => v.toJsonForConverters())
          .toList();
    }
    return data;
  }
}
