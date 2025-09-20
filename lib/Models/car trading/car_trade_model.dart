class CarTradeModel {
  String? id;
  String? boughtFrom;
  String? soldTo;
  String? date;
  String? carBrand;
  String? carModel;
  String? mileage;
  String? specification;
  String? engineSize;
  String? colorIn;
  String? colorOut;
  String? year;
  String? note;
  String? companyId;
  String? status;
  double? pay;
  double? receive;
  double? net;
  DateTime? updatedAt;
  DateTime? createdAt;
  DateTime? buyDate;
  DateTime? sellDate;

  CarTradeModel({
    this.id,
    this.boughtFrom,
    this.soldTo,
    this.date,
    this.carBrand,
    this.carModel,
    this.mileage,
    this.specification,
    this.engineSize,
    this.colorIn,
    this.colorOut,
    this.year,
    this.note,
    this.companyId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  CarTradeModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    boughtFrom = json['bought_from'];
    soldTo = json['sold_to'];
    date = json['date'];
    carBrand = json['car_brand'];
    carModel = json['car_model'];
    mileage = json['mileage'];
    specification = json['specification'];
    engineSize = json['engine_size'];
    colorIn = json['color_in'];
    colorOut = json['color_out'];
    year = json['year'];
    note = json['note'];
    companyId = json['company_id'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}
