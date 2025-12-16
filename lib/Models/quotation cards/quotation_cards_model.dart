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
  String? jobCardId;
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
    this.jobCardId,
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
    T? tryGet<T>(String key, [T? defaultValue]) {
      try {
        if (!json.containsKey(key) || json[key] == null) return defaultValue;
        final value = json[key];
        if (T == String) return value.toString() as T;
        if (T == double) return double.tryParse(value.toString()) as T?;
        if (T == int) return int.tryParse(value.toString()) as T?;
        if (T == DateTime) return DateTime.tryParse(value.toString()) as T?;
        return value as T;
      } catch (_) {
        return defaultValue;
      }
    }

    id = tryGet<String>('_id', '');
    createdAt = tryGet<DateTime>('createdAt');
    updatedAt = tryGet<DateTime>('updatedAt');

    branch = tryGet<String>('branch_name', '');
    branchId = tryGet<String>('branch', '');

    carBrand = tryGet<String>('car_brand_name', '');
    carBrandId = tryGet<String>('car_brand', '');
    carBrandLogo = tryGet<String>('car_brand_logo', '');

    carModel = tryGet<String>('car_model_name', '');
    carModelId = tryGet<String>('car_model', '');

    city = tryGet<String>('city_name', '');
    cityId = tryGet<String>('city', '');

    color = tryGet<String>('color_name', '');
    colorId = tryGet<String>('color', '');

    contactEmail = tryGet<String>('contact_email', '');
    contactName = tryGet<String>('contact_name', '');
    contactNumber = tryGet<String>('contact_number', '');

    country = tryGet<String>('country_name', '');
    countryId = tryGet<String>('country', '');

    creditLimit = tryGet<double>('credit_limit', 0.0);
    currency = tryGet<String>('currency_code', '');
    currencyId = tryGet<String>('currency', '');

    customer = tryGet<String>('customer_name', '');
    customerId = tryGet<String>('customer', '');

    deliveryTime = tryGet<String>('delivery_time', '');
    engineType = tryGet<String>('engine_type_name', '');
    engineTypeId = tryGet<String>('engine_type', '');

    jobNumber = tryGet<String>('job_number', '');
    jobCardId = tryGet<String>('job_card_id', '');
    mileageIn = tryGet<double>('mileage_in', 0.0);
    outstanding = tryGet<double>('outstanding', 0.0);

    paymentMethod = tryGet<String>('payment_method', '');
    plateCode = tryGet<String>('plate_code', '');
    plateNumber = tryGet<String>('plate_number', '');

    quotationDate = tryGet<DateTime>('quotation_date');
    quotationNotes = tryGet<String>('quotation_notes', '');
    quotationNumber = tryGet<String>('quotation_number', '');
    quotationStatus = tryGet<String>('quotation_status', '');

    quotationWarrentyDays = tryGet<int>('quotation_warranty_days', 0);
    quotationWarrentyKm = tryGet<double>('quotation_warranty_km', 0.0);
    rate = tryGet<double>('rate', 0.0);

    referenceNumber = tryGet<String>('reference_number', '');
    salesman = tryGet<String>('salesman_name', '');
    salesmanId = tryGet<String>('salesman', '');

    transmissionType = tryGet<String>('transmission_type', '');
    validityDays = tryGet<int>('validity_days', 0);
    validityEndDate = tryGet<DateTime>('validity_end_date');

    vehicleIdentificationNumber = tryGet<String>(
      'vehicle_identification_number',
      '',
    );
    year = tryGet<String>('year', '');

    totals = tryGet<double>('total_amount', 0.0);
    vat = tryGet<double>('total_vat', 0.0);
    net = tryGet<double>('total_net', 0.0);

    // ✅ Safely parse invoice items
    final items = json['invoice_items_details'];
    if (items is List) {
      invoiceItemsDetails = items
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
