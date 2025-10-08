import 'job_card_invoice_items_model.dart';

class JobCardModel {
  String? id;
  String? quotationId;
  String? quotationNumber;
  String? label;
  String? jobStatus1;
  String? jobStatus2;
  String? carBrandLogo;
  String? carBrand;
  String? carModel;
  String? plateNumber;
  String? plateCode;
  String? country;
  String? city;
  String? year;
  String? color;
  String? engineType;
  String? vehicleIdentificationNumber;
  String? transmissionType;
  int? mileageIn;
  int? mileageOut;
  int? mileageInOutDiff;
  int? fuelAmount;
  String? customer;
  String? contactName;
  String? contactEmail;
  String? contactNumber;
  int? creditLimit;
  int? outstanding;
  String? salesman;
  String? branch;
  String? currency;
  int? rate;
  String? paymentMethod;
  String? lpoNumber;
  DateTime? jobApprovalDate;
  DateTime? jobStartDate;
  DateTime? jobCancellationDate;
  DateTime? jobFinishDate;
  DateTime? jobDeliveryDate;
  int? jobWarrantyDays;
  int? jobWarrantyKm;
  DateTime? jobWarrantyEndDate;
  int? jobMinTestKm;
  String? jobReference1;
  String? jobReference2;
  String? deliveryTime;
  String? jobNotes;
  String? jobDeliveryNotes;
  DateTime? jobDate;
  DateTime? invoiceDate;
  String? invoiceNumber;
  String? companyId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? jobNumber;
  List<JobCardInvoiceItemsModel>? invoiceItemsDetails;
  String? carBrandName;
  String? carModelName;
  String? countryName;
  String? cityName;
  String? colorName;
  String? engineTypeName;
  String? customerName;
  String? salesmanName;
  String? branchName;
  String? currencyCode;
  double? totals;
  double? vat;
  double? net;
  String? technician;
  String? technicianName;
  DateTime? date;

  JobCardModel({
    this.id,
    this.quotationId,
    this.quotationNumber,
    this.label,
    this.jobStatus1,
    this.jobStatus2,
    this.carBrandLogo,
    this.carBrand,
    this.carModel,
    this.plateNumber,
    this.plateCode,
    this.country,
    this.city,
    this.year,
    this.color,
    this.engineType,
    this.vehicleIdentificationNumber,
    this.transmissionType,
    this.mileageIn,
    this.mileageOut,
    this.mileageInOutDiff,
    this.fuelAmount,
    this.customer,
    this.contactName,
    this.contactEmail,
    this.contactNumber,
    this.creditLimit,
    this.outstanding,
    this.salesman,
    this.branch,
    this.currency,
    this.rate,
    this.paymentMethod,
    this.lpoNumber,
    this.jobApprovalDate,
    this.jobStartDate,
    this.jobCancellationDate,
    this.jobFinishDate,
    this.jobDeliveryDate,
    this.jobWarrantyDays,
    this.jobWarrantyKm,
    this.jobWarrantyEndDate,
    this.jobMinTestKm,
    this.jobReference1,
    this.jobReference2,
    this.deliveryTime,
    this.jobNotes,
    this.jobDeliveryNotes,
    this.jobDate,
    this.invoiceDate,
    this.companyId,
    this.createdAt,
    this.updatedAt,
    this.jobNumber,
    this.invoiceItemsDetails,
    this.carBrandName,
    this.carModelName,
    this.countryName,
    this.cityName,
    this.colorName,
    this.engineTypeName,
    this.customerName,
    this.salesmanName,
    this.branchName,
    this.invoiceNumber,
    this.currencyCode,
    this.totals,
    this.vat,
    this.net,
    this.technician,
    this.technicianName,
    this.date,
  });
  JobCardModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? '';
    quotationId = json['quotation_id'] ?? '';
    quotationNumber = json['quotation_number'] ?? '';
    label = json['label'] ?? '';
    jobStatus1 = json['job_status_1'] ?? '';
    jobStatus2 = json['job_status_2'] ?? '';
    carBrandLogo = json['car_brand_logo'] ?? '';
    carBrand = json['car_brand'] ?? '';
    carModel = json['car_model'] ?? '';
    plateNumber = json['plate_number'] ?? '';
    plateCode = json['plate_code'] ?? '';
    country = json['country'] ?? '';
    city = json['city'] ?? '';
    year = json['year']?.toString() ?? '';
    color = json['color'] ?? '';
    engineType = json['engine_type'] ?? '';
    vehicleIdentificationNumber = json['vehicle_identification_number'] ?? '';
    transmissionType = json['transmission_type'] ?? '';
    mileageIn = json['mileage_in'] ?? 0;
    mileageOut = json['mileage_out'] ?? 0;
    mileageInOutDiff = json['mileage_in_out_diff'] ?? 0;
    fuelAmount = json['fuel_amount'] ?? 0;
    customer = json['customer'] ?? '';
    contactName = json['contact_name'] ?? '';
    contactEmail = json['contact_email'] ?? '';
    contactNumber = json['contact_number'] ?? '';
    creditLimit = json['credit_limit'] ?? 0;
    outstanding = json['outstanding'] ?? 0;
    salesman = json['salesman'] ?? '';
    branch = json['branch'] ?? '';
    currency = json['currency'] ?? '';
    rate = json['rate'] ?? 0;
    paymentMethod = json['payment_method'] ?? '';
    lpoNumber = json['lpo_number'] ?? '';

    jobApprovalDate = json['job_approval_date'] != null
        ? DateTime.tryParse(json['job_approval_date'].toString())
        : null;
    jobStartDate = json['job_start_date'] != null
        ? DateTime.tryParse(json['job_start_date'].toString())
        : null;
    jobCancellationDate = json['job_cancellation_date'] != null
        ? DateTime.tryParse(json['job_cancellation_date'].toString())
        : null;
    jobFinishDate = json['job_finish_date'] != null
        ? DateTime.tryParse(json['job_finish_date'].toString())
        : null;
    jobDeliveryDate = json['job_delivery_date'] != null
        ? DateTime.tryParse(json['job_delivery_date'].toString())
        : null;

    jobWarrantyDays = json['job_warranty_days'] ?? 0;
    jobWarrantyKm = json['job_warranty_km'] ?? 0;
    jobWarrantyEndDate = json['job_warranty_end_date'] != null
        ? DateTime.tryParse(json['job_warranty_end_date'].toString())
        : null;
    jobMinTestKm = json['job_min_test_km'] ?? 0;
    jobReference1 = json['job_reference_1'] ?? '';
    jobReference2 = json['job_reference_2'] ?? '';
    deliveryTime = json['delivery_time'] ?? '';
    jobNotes = json['job_notes'] ?? '';
    jobDeliveryNotes = json['job_delivery_notes'] ?? '';

    jobDate = json['job_date'] != null
        ? DateTime.tryParse(json['job_date'].toString())
        : null;
    invoiceDate = json['invoice_date'] != null
        ? DateTime.tryParse(json['invoice_date'].toString())
        : null;

    companyId = json['company_id'] ?? '';

    createdAt = json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'].toString())
        : null;
    updatedAt = json['updatedAt'] != null
        ? DateTime.tryParse(json['updatedAt'].toString())
        : null;

    jobNumber = json['job_number'] ?? '';
    invoiceNumber = json['invoice_number'] ?? '';

    // ✅ Parse invoice items list
    if (json['invoice_items_details'] != null) {
      invoiceItemsDetails = (json['invoice_items_details'] as List)
          .map((v) => JobCardInvoiceItemsModel.fromJson(v))
          .toList();
    } else {
      invoiceItemsDetails = [];
    }

    // ✅ Names from lookups
    carBrandName = json['car_brand_name'] ?? '';
    carModelName = json['car_model_name'] ?? '';
    countryName = json['country_name'] ?? '';
    cityName = json['city_name'] ?? '';
    colorName = json['color_name'] ?? '';
    engineTypeName = json['engine_type_name'] ?? '';
    customerName = json['customer_name'] ?? '';
    salesmanName = json['salesman_name'] ?? '';
    branchName = json['branch_name'] ?? '';
    currencyCode = json['currency_code'] ?? '';

    // ✅ Totals (fixed to match backend field names)
    totals = json['total_amount'] ?? 0;
    vat = json['total_vat'] ?? 0;
    net = json['total_net'] ?? 0;

    // ✅ Optional extra fields
    technician = json['technician'] ?? '';
    technicianName = json['technician_name'] ?? '';

    date = json['date'] != null
        ? DateTime.tryParse(json['date'].toString())
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['label'] = label;
    data['job_status_1'] = jobStatus1;
    data['job_status_2'] = jobStatus2;
    data['car_brand_logo'] = carBrandLogo;
    data['car_brand'] = carBrand;
    data['car_model'] = carModel;
    data['plate_number'] = plateNumber;
    data['plate_code'] = plateCode;
    data['country'] = country;
    data['city'] = city;
    data['year'] = year;
    data['color'] = color;
    data['engine_type'] = engineType;
    data['vehicle_identification_number'] = vehicleIdentificationNumber;
    data['transmission_type'] = transmissionType;
    data['mileage_in'] = mileageIn;
    data['mileage_out'] = mileageOut;
    data['mileage_in_out_diff'] = mileageInOutDiff;
    data['fuel_amount'] = fuelAmount;
    data['customer'] = customer;
    data['contact_name'] = contactName;
    data['contact_email'] = contactEmail;
    data['contact_number'] = contactNumber;
    data['credit_limit'] = creditLimit;
    data['outstanding'] = outstanding;
    data['salesman'] = salesman;
    data['branch'] = branch;
    data['currency'] = currency;
    data['rate'] = rate;
    data['payment_method'] = paymentMethod;
    data['lpo_number'] = lpoNumber;
    data['job_approval_date'] = jobApprovalDate;
    data['job_start_date'] = jobStartDate;
    data['job_cancellation_date'] = jobCancellationDate;
    data['job_finish_date'] = jobFinishDate;
    data['job_delivery_date'] = jobDeliveryDate;
    data['job_warranty_days'] = jobWarrantyDays;
    data['job_warranty_km'] = jobWarrantyKm;
    data['job_warranty_end_date'] = jobWarrantyEndDate;
    data['job_min_test_km'] = jobMinTestKm;
    data['job_reference_1'] = jobReference1;
    data['job_reference_2'] = jobReference2;
    data['delivery_time'] = deliveryTime;
    data['job_notes'] = jobNotes;
    data['job_delivery_notes'] = jobDeliveryNotes;
    data['job_date'] = jobDate;
    data['invoice_date'] = invoiceDate;
    data['company_id'] = companyId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['job_number'] = jobNumber;
    if (invoiceItemsDetails != null) {
      data['invoice_items_details'] = invoiceItemsDetails!
          .map((v) => v.toJson())
          .toList();
    }
    data['car_brand_name'] = carBrandName;
    data['car_model_name'] = carModelName;
    data['country_name'] = countryName;
    data['city_name'] = cityName;
    data['color_name'] = colorName;
    data['engine_type_name'] = engineTypeName;
    data['customer_name'] = customerName;
    data['salesman_name'] = salesmanName;
    data['branch_name'] = branchName;
    data['currency_code'] = currencyCode;
    return data;
  }
}
