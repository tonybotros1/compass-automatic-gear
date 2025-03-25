class CarCardModel {
  String? customerName;
  String? carBrand;
  String? carModel;
  String? plateNumber;
  String? carMileage;
  String? chassisNumber;
  String? phoneNumber;
  String? emailAddress;
  String? color;
  String? date;
  double? fuelAmount;
  String? docID;
  String? vin;
  String? carVideo;
  String? comments;
  String? customerSignature;
  String? advisorSignature;
  List<String>? carImages;
  String? status1;
  String? status2;
  String? year;
  String? code;
  String? engineType;
  String? technician;
  Map? data;

 CarCardModel({
    this.customerName,
    this.carBrand,
    this.code,
    this.vin,
    this.carModel,
    this.plateNumber,
    this.carMileage,
    this.chassisNumber,
    this.phoneNumber,
    this.emailAddress,
    this.color,
    this.date,
    this.fuelAmount,
    this.docID,
    this.carVideo,
    this.engineType,
    this.customerSignature,
    this.advisorSignature,
    this.carImages,
    this.status1,
    this.status2,
    this.comments,
    this.data,
    this.year,
    this.technician,
  });

  CarCardModel.fromJson(Map<String, dynamic> json) {
    customerName = json['customer_name'];
    comments = json['comments'];
    carBrand = json['car_brand'];
    carModel = json['car_model'];
    plateNumber = json['plate_number'];
    carMileage = json['car_mileage'];
    chassisNumber = json['chassis_number'];
    phoneNumber = json['phone_number'];
    emailAddress = json['email_address'];
    color = json['color'];
    date = json['date'];
    fuelAmount = json['fuel_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_name'] = customerName;
    data['car_brand'] = carBrand;
    data['comments'] = comments;
    data['car_model'] = carModel;
    data['plate_number'] = plateNumber;
    data['car_mileage'] = carMileage;
    data['chassis_number'] = chassisNumber;
    data['phone_number'] = phoneNumber;
    data['email_address'] = emailAddress;
    data['color'] = color;
    data['date'] = date;
    data['fuel_amount'] = fuelAmount;
    return data;
  }
}
