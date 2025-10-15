import '../job cards/job_card_invoice_items_model.dart';

class QuotationCardsModel {
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? branch;
  String? branchId;
  String? carBrand;
  String? carBrandId;
  String? carBrandLogo;
  String? carModel;
  String? carModelId;
  String? city;
  String? cityId;
  String? color;
  String? colorId;
  String? contactEmail;
  String? contactName;
  String? contactNumber;
  String? country;
  String? countryId;
  double? creditLimit;
  String? currency;
  String? currencyId;
  String? customer;
  String? customerId;
  String? deliveryTime;
  String? engineType;
  String? engineTypeId;
  String? jobNumber;
  double? mileageIn;
  double? outstanding;
  String? paymentMethod;
  String? plateCode;
  String? plateNumber;
  DateTime? quotationDate;
  String? quotationNotes;
  String? quotationNumber;
  String? quotationStatus;
  int? quotationWarrentyDays;
  double? quotationWarrentyKm;
  double? rate;
  String? referenceNumber;
  String? salesman;
  String? salesmanId;
  String? transmissionType;
  int? validityDays;
  DateTime? validityEndDate;
  String? vehicleIdentificationNumber;
  String? year;
  List<JobCardInvoiceItemsModel>? invoiceItemsDetails;
  double? totals;
  double? vat;
  double? net;

  QuotationCardsModel({
    this.createdAt,
    this.updatedAt,
    this.branch,
    this.branchId,
    this.id,
    this.carBrand,
    this.carBrandLogo,
    this.carModel,
    this.city,
    this.color,
    this.contactEmail,
    this.contactName,
    this.contactNumber,
    this.country,
    this.creditLimit,
    this.currency,
    this.customer,
    this.deliveryTime,
    this.engineType,
    this.jobNumber,
    this.mileageIn,
    this.outstanding,
    this.paymentMethod,
    this.plateCode,
    this.plateNumber,
    this.quotationDate,
    this.quotationNotes,
    this.quotationNumber,
    this.quotationStatus,
    this.quotationWarrentyDays,
    this.quotationWarrentyKm,
    this.rate,
    this.referenceNumber,
    this.salesman,
    this.transmissionType,
    this.validityDays,
    this.validityEndDate,
    this.vehicleIdentificationNumber,
    this.year,
    this.invoiceItemsDetails,
    this.carBrandId,
    this.carModelId,
    this.cityId,
    this.colorId,
    this.countryId,
    this.currencyId,
    this.customerId,
    this.engineTypeId,
    this.salesmanId,
    this.net,
    this.totals,
    this.vat,
  });
  QuotationCardsModel.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('_id') ? json['_id'].toString() : '';

    createdAt = json.containsKey('createdAt')
        ? DateTime.tryParse(json['createdAt'].toString())
        : null;
    updatedAt = json.containsKey('updatedAt')
        ? DateTime.tryParse(json['updatedAt'].toString())
        : null;

    branch = json['branch'] ?? '';
    branchId = json['branch_id'] ?? '';

    carBrand = json['car_brand'] ?? '';
    carBrandId = json['car_brand_id'] ?? '';
    carBrandLogo = json['car_brand_logo'] ?? '';

    carModel = json['car_model'] ?? '';
    carModelId = json['car_model_id'] ?? '';

    city = json['city'] ?? '';
    cityId = json['city_id'] ?? '';

    color = json['color'] ?? '';
    colorId = json['color_id'] ?? '';

    contactEmail = json['contact_email'] ?? '';
    contactName = json['contact_name'] ?? '';
    contactNumber = json['contact_number'] ?? '';

    country = json['country'] ?? '';
    countryId = json['country_id'] ?? '';

    creditLimit = json['credit_limit'] ?? 0;
    currency = json['currency'] ?? '';
    currencyId = json['currency_id'] ?? '';

    customer = json['customer'] ?? '';
    customerId = json['customer_id'] ?? '';

    deliveryTime = json['delivery_time'] ?? '';
    engineType = json['engine_type'] ?? '';
    engineTypeId = json['engine_type_id'] ?? '';

    jobNumber = json['job_number'] ?? '';
    mileageIn = json.containsKey('mileage_in')
        ? double.tryParse(json['mileage_in'].toString()) ?? 0.0
        : 0.0;
    outstanding = json.containsKey('outstanding')
        ? double.tryParse(json['outstanding'].toString()) ?? 0.0
        : 0.0;

    paymentMethod = json['payment_method'] ?? '';
    plateCode = json['plate_code'] ?? '';
    plateNumber = json['plate_number'] ?? '';

    quotationDate = json.containsKey('quotation_date')
        ? DateTime.tryParse(json['quotation_date'].toString())
        : null;
    quotationNotes = json['quotation_notes'] ?? '';
    quotationNumber = json['quotation_number'] ?? '';
    quotationStatus = json['quotation_status'] ?? '';

    quotationWarrentyDays = json.containsKey('quotation_warrenty_days')
        ? int.tryParse(json['quotation_warrenty_days'].toString()) ?? 0
        : 0;
    quotationWarrentyKm = json.containsKey('quotation_warrenty_km')
        ? double.tryParse(json['quotation_warrenty_km'].toString()) ?? 0.0
        : 0.0;
    rate = json.containsKey('rate')
        ? double.tryParse(json['rate'].toString()) ?? 0.0
        : 0.0;

    referenceNumber = json['reference_number'] ?? '';

    salesman = json['salesman'] ?? '';
    salesmanId = json['salesman_id'] ?? '';

    transmissionType = json['transmission_type'] ?? '';
    validityDays = json['validity_days'] ?? '';
    validityEndDate = json.containsKey('validity_end_date')
        ? DateTime.tryParse(json['validity_end_date'].toString())
        : null;

    vehicleIdentificationNumber = json['vehicle_identification_number'] ?? '';
    year = json['year'] ?? '';
    totals = json['total_amount'] ?? 0;
    vat = json['total_vat'] ?? 0;
    net = json['total_net'] ?? 0;

    // ✅ Parse invoice items list safely
    if (json.containsKey('invoice_items_details') &&
        json['invoice_items_details'] is List) {
      invoiceItemsDetails = (json['invoice_items_details'] as List)
          .map((v) => JobCardInvoiceItemsModel.fromJson(v))
          .toList();
    } else {
      invoiceItemsDetails = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['branch'] = branch;
    data['car_brand'] = carBrand;
    data['car_brand_logo'] = carBrandLogo;
    data['car_model'] = carModel;
    data['city'] = city;
    data['color'] = color;
    data['contact_email'] = contactEmail;
    data['contact_name'] = contactName;
    data['contact_number'] = contactNumber;
    data['country'] = country;
    data['credit_limit'] = creditLimit;
    data['currency'] = currency;
    data['customer'] = customer;
    data['delivery_time'] = deliveryTime;
    data['engine_type'] = engineType;
    data['job_number'] = jobNumber;
    data['mileage_in'] = mileageIn;
    data['outstanding'] = outstanding;
    data['payment_method'] = paymentMethod;
    data['plate_code'] = plateCode;
    data['plate_number'] = plateNumber;
    data['quotation_date'] = quotationDate;
    data['quotation_notes'] = quotationNotes;
    data['quotation_number'] = quotationNumber;
    data['quotation_status'] = quotationStatus;
    data['quotation_warrenty_days'] = quotationWarrentyDays;
    data['quotation_warrenty_km'] = quotationWarrentyKm;
    data['rate'] = rate;
    data['reference_number'] = referenceNumber;
    data['salesman'] = salesman;
    data['transmission_type'] = transmissionType;
    data['validity_days'] = validityDays;
    data['validity_end_date'] = validityEndDate;
    data['vehicle_identification_number'] = vehicleIdentificationNumber;
    data['year'] = year;
    return data;
  }
}
