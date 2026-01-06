class ApprovedJobsModel {
  String? id;
  String? brand;
  String? model;
  String? color;
  String? logo;
  String? platNumber;
  String? jobNumber;
  String? plateCode;

  ApprovedJobsModel({
    this.id,
    this.brand,
    this.model,
    this.color,
    this.logo,
    this.platNumber,
    this.jobNumber,
  });

  ApprovedJobsModel.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('_id') ? json['_id'] ?? "" : "";
    model = json.containsKey('car_model_name')
        ? json['car_model_name'] ?? ""
        : "";
    brand = json.containsKey('car_brand_name')
        ? json['car_brand_name'] ?? ""
        : "";
    logo = json.containsKey('car_brand_logo')
        ? json['car_brand_logo'] ?? ""
        : "";
    color = json.containsKey('color_name') ? json['color_name'] ?? "" : "";
    jobNumber = json.containsKey('job_number') ? json['job_number'] ?? "" : "";
    platNumber = json.containsKey('plate_number')
        ? json['plate_number'] ?? ""
        : "";
    plateCode = json.containsKey('plate_code')
        ? json['plate_code']?.toString() ?? ''
        : '';
  }
}
