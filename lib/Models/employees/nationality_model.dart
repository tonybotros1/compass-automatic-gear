import 'package:datahubai/consts.dart';

class NationalityModel {
  String? id;
  String? nationality;
  String? nationalityId;
  String? startDate;
  String? endDate;

  NationalityModel({
    this.id,
    this.nationality,
    this.nationalityId,
    this.startDate,
    this.endDate,
  });

  NationalityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nationality = json['nationality'];
    nationalityId = json['nationality_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nationality'] = nationality;
    data['nationality_id'] = nationalityId;
    data['start_date'] = convertDateToIson(startDate.toString());
    data['end_date'] = convertDateToIson(endDate.toString());
    return data;
  }
}
