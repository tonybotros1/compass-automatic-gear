import 'job_card_invoice_items_model.dart';

class JobCardModel {
  String? id;
  String? type;
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
  String? jobReference3;
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
  double? paid;
  double? finlOutstanding;

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
    this.finlOutstanding,
    this.paid,
    this.type,
  });

  JobCardModel.fromJson(Map<String, dynamic> json) {
    T? tryGet<T>(String key) {
      try {
        if (json.containsKey(key) && json[key] != null && json[key] != '') {
          return json[key] as T;
        }
      } catch (_) {}
      return null;
    }

    DateTime? tryParseDate(String key) {
      final value = json[key];
      if (value == null || value == '') return null;
      return DateTime.tryParse(value.toString());
    }

    id = tryGet<String>('_id');
    quotationId = tryGet<String>('quotation_id');
    quotationNumber = tryGet<String>('quotation_number');
    label = tryGet<String>('label');
    type = tryGet<String>('type');
    jobStatus1 = tryGet<String>('job_status_1');
    jobStatus2 = tryGet<String>('job_status_2');
    carBrandLogo = tryGet<String>('car_brand_logo');
    carBrand = tryGet<String>('car_brand');
    carModel = tryGet<String>('car_model');
    plateNumber = tryGet<String>('plate_number');
    plateCode = tryGet<String>('plate_code');
    country = tryGet<String>('country');
    city = tryGet<String>('city');
    year = json['year']?.toString();
    color = tryGet<String>('color');
    engineType = tryGet<String>('engine_type');
    vehicleIdentificationNumber = tryGet<String>(
      'vehicle_identification_number',
    );
    transmissionType = tryGet<String>('transmission_type');
    mileageIn = (tryGet<num>('mileage_in') ?? 0).toInt();
    mileageOut = (tryGet<num>('mileage_out') ?? 0).toInt();
    mileageInOutDiff = (tryGet<num>('mileage_in_out_diff') ?? 0).toInt();
    fuelAmount = (tryGet<num>('fuel_amount') ?? 0).toInt();
    customer = tryGet<String>('customer');
    contactName = tryGet<String>('contact_name');
    contactEmail = tryGet<String>('contact_email');
    contactNumber = tryGet<String>('contact_number');
    creditLimit = (tryGet<num>('credit_limit') ?? 0).toInt();
    outstanding = (tryGet<num>('outstanding') ?? 0).toInt();
    salesman = tryGet<String>('salesman');
    branch = tryGet<String>('branch');
    currency = tryGet<String>('currency');
    rate = (tryGet<num>('rate') ?? 0).toInt();
    paymentMethod = tryGet<String>('payment_method');
    lpoNumber = tryGet<String>('lpo_number');

    jobApprovalDate = tryParseDate('job_approval_date');
    jobStartDate = tryParseDate('job_start_date');
    jobCancellationDate = tryParseDate('job_cancellation_date');
    jobFinishDate = tryParseDate('job_finish_date');
    jobDeliveryDate = tryParseDate('job_delivery_date');
    jobWarrantyDays = (tryGet<num>('job_warranty_days') ?? 0).toInt();
    jobWarrantyKm = (tryGet<num>('job_warranty_km') ?? 0).toInt();
    jobWarrantyEndDate = tryParseDate('job_warranty_end_date');
    jobMinTestKm = (tryGet<num>('job_min_test_km') ?? 0).toInt();
    jobReference1 = tryGet<String>('job_reference_1');
    jobReference2 = tryGet<String>('job_reference_2');
    jobReference3 = tryGet<String>('job_reference_3');
    deliveryTime = tryGet<String>('delivery_time');
    jobNotes = tryGet<String>('job_notes');
    jobDeliveryNotes = tryGet<String>('job_delivery_notes');
    jobDate = tryParseDate('job_date');
    invoiceDate = tryParseDate('invoice_date');
    companyId = tryGet<String>('company_id');
    createdAt = tryParseDate('createdAt');
    updatedAt = tryParseDate('updatedAt');
    jobNumber = tryGet<String>('job_number');
    invoiceNumber = tryGet<String>('invoice_number');

    // ✅ invoice items
    final items = json['invoice_items_details'];
    if (items is List) {
      invoiceItemsDetails = items
          .map((v) => JobCardInvoiceItemsModel.fromJson(v))
          .toList();
    } else {
      invoiceItemsDetails = [];
    }
    // ✅ invoice items
    // invoiceItemsDetails = [];

    // try {
    //   final items = json['invoice_items_details'];

    //   if (items is List) {
    //     for (int i = 0; i < items.length; i++) {
    //       try {
    //         invoiceItemsDetails!.add(
    //           JobCardInvoiceItemsModel.fromJson(items[i]),
    //         );
    //       } catch (e, stack) {
    //         // 🔴 Error in a specific item
    //         debugPrint(
    //           '❌ Failed to parse invoice item at index $i\n'
    //           'Item data: ${items[i]}\n'
    //           'Error: $e',
    //         );

    //         // Optional: send to crash reporting
    //         // FirebaseCrashlytics.instance.recordError(e, stack);
    //       }
    //     }
    //   } else {
    //     debugPrint(
    //       '❌ invoice_items_details is not a List. '
    //       'Actual type: ${items.runtimeType}',
    //     );
    //   }
    // } catch (e, stack) {
    //   // 🔴 Critical error (JSON shape problem)
    //   debugPrint(
    //     '🔥 Failed to parse invoice_items_details\n'
    //     'Error: $e',
    //   );

    //   // Optional crash reporting
    //   // FirebaseCrashlytics.instance.recordError(e, stack);
    // }

    carBrandName = tryGet<String>('car_brand_name');
    carModelName = tryGet<String>('car_model_name');
    countryName = tryGet<String>('country_name');
    cityName = tryGet<String>('city_name');
    colorName = tryGet<String>('color_name');
    engineTypeName = tryGet<String>('engine_type_name');
    customerName = tryGet<String>('customer_name');
    salesmanName = tryGet<String>('salesman_name');
    branchName = tryGet<String>('branch_name');
    currencyCode = tryGet<String>('currency_code');

    totals = (tryGet<num>('total_amount') ?? 0).toDouble();
    vat = (tryGet<num>('total_vat') ?? 0).toDouble();
    net = (tryGet<num>('total_net') ?? 0).toDouble();
    paid = (tryGet<num>('paid') ?? 0).toDouble();
    finlOutstanding = (tryGet<num>('final_outstanding') ?? 0).toDouble();

    technician = tryGet<String>('technician');
    technicianName = tryGet<String>('technician_name');
    date = tryParseDate('date');
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
    data['job_reference_3'] = jobReference3;
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
