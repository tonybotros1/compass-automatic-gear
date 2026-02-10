class InspectionReportModel {
  final String? id;
  final String? companyId;
  final DateTime? jobDate;
  final String? jobStatus1;
  final String? jobStatus2;
  final String? jobNumber;
  final String? technicianId;
  final String? customerId;
  final String? contactName;
  final String? contactEmail;
  final String? contactNumber;
  final double? creditLimit;
  final String? salesman;
  final String? carBrandId;
  final String? carLogo;
  final String? carModelId;
  final String? plateNumber;
  final String? plateCode;
  final String? colorId;
  final String? colorName;
  final double? mileageIn;
  final String? engineTypeId;
  final int? year;
  final String? transmissionType;
  final double? fuelAmount;
  final String? vehicleIdentificationNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? jobWarrantyEndDate;
  final InspectionReportDetails? inspectionReportDetails;
  final String? carBrandName;
  final String? carModelName;
  final String? technicianName;
  final String? customerName;
  final String? engineTypeName;

  InspectionReportModel({
    this.id,
    this.companyId,
    this.jobDate,
    this.jobStatus1,
    this.jobStatus2,
    this.jobNumber,
    this.technicianId,
    this.customerId,
    this.contactName,
    this.contactEmail,
    this.contactNumber,
    this.creditLimit,
    this.salesman,
    this.carBrandId,
    this.carModelId,
    this.plateNumber,
    this.plateCode,
    this.mileageIn,
    this.engineTypeId,
    this.year,
    this.transmissionType,
    this.fuelAmount,
    this.vehicleIdentificationNumber,
    this.createdAt,
    this.updatedAt,
    this.inspectionReportDetails,
    this.carBrandName,
    this.carModelName,
    this.technicianName,
    this.customerName,
    this.engineTypeName,
    this.carLogo,
    this.colorId,
    this.colorName,
    this.jobWarrantyEndDate,
  });

  InspectionReportModel copyWith({
    String? id,
    String? companyId,
    DateTime? jobDate,
    String? jobStatus1,
    String? jobStatus2,
    String? jobNumber,
    String? technicianId,
    String? customerId,
    String? contactName,
    String? contactEmail,
    String? contactNumber,
    double? creditLimit,
    String? salesman,
    String? carBrandId,
    String? carModelId,
    String? carLogo,
    String? plateNumber,
    String? plateCode,
    double? mileageIn,
    String? engineTypeId,
    int? year,
    String? transmissionType,
    double? fuelAmount,
    String? vehicleIdentificationNumber,
    String? jobNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
    InspectionReportDetails? inspectionReportDetails,
    String? carBrandName,
    String? carModelName,
    String? technicianName,
    String? customerName,
    String? engineTypeName,
  }) {
    return InspectionReportModel(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      carLogo: carLogo ?? this.carLogo,
      jobDate: jobDate ?? this.jobDate,
      jobStatus1: jobStatus1 ?? this.jobStatus1,
      jobStatus2: jobStatus2 ?? this.jobStatus2,
      jobNumber: jobNumber ?? this.jobNumber,
      technicianId: technicianId ?? this.technicianId,
      customerId: customerId ?? this.customerId,
      contactName: contactName ?? this.contactName,
      contactEmail: contactEmail ?? this.contactEmail,
      contactNumber: contactNumber ?? this.contactNumber,
      creditLimit: creditLimit ?? this.creditLimit,
      salesman: salesman ?? this.salesman,
      carBrandId: carBrandId ?? this.carBrandId,
      carModelId: carModelId ?? this.carModelId,
      plateNumber: plateNumber ?? this.plateNumber,
      plateCode: plateCode ?? this.plateCode,
      mileageIn: mileageIn ?? this.mileageIn,
      engineTypeId: engineTypeId ?? this.engineTypeId,
      year: year ?? this.year,
      transmissionType: transmissionType ?? this.transmissionType,
      fuelAmount: fuelAmount ?? this.fuelAmount,
      vehicleIdentificationNumber:
          vehicleIdentificationNumber ?? this.vehicleIdentificationNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      inspectionReportDetails:
          inspectionReportDetails ?? this.inspectionReportDetails,
      carBrandName: carBrandName ?? this.carBrandName,
      carModelName: carModelName ?? this.carModelName,
      technicianName: technicianName ?? this.technicianName,
      customerName: customerName ?? this.customerName,
      engineTypeName: engineTypeName ?? this.engineTypeName,
    );
  }

  factory InspectionReportModel.fromJson(Map<String, dynamic> json) {
    return InspectionReportModel(
      id: json.containsKey('_id') ? json['_id'] : null,
      companyId: json.containsKey('company_id') ? json['company_id'] : null,
      jobDate: json.containsKey('job_date')
          ? DateTime.tryParse(json['job_date'])
          : null,
      jobStatus1: json.containsKey('job_status_1')
          ? json['job_status_1']?.toString()
          : null,
      jobStatus2: json.containsKey('job_status_2')
          ? json['job_status_2']?.toString()
          : null,
      jobNumber: json.containsKey('job_number')
          ? json['job_number']?.toString()
          : null,
      technicianId: json.containsKey('technician') ? json['technician'] : null,
      customerId: json.containsKey('customer') ? json['customer'] : null,
      contactName: json.containsKey('contact_name')
          ? json['contact_name']?.toString()
          : null,
      contactEmail: json.containsKey('contact_email')
          ? json['contact_email']?.toString()
          : null,
      contactNumber: json.containsKey('contact_number')
          ? json['contact_number']?.toString()
          : null,
      creditLimit: json.containsKey('credit_limit')
          ? (json['credit_limit'] is double
                ? json['credit_limit']
                : double.tryParse(json['credit_limit']?.toString() ?? ''))
          : null,
      salesman: json.containsKey('salesman')
          ? json['salesman']?.toString()
          : null,
      carBrandId: json.containsKey('car_brand') ? json['car_brand'] : null,
      carModelId: json.containsKey('car_model') ? json['car_model'] : null,
      carLogo: json.containsKey('car_brand_logo')
          ? json['car_brand_logo']
          : null,
      colorId: json.containsKey('color') ? json['color'] : null,
      colorName: json.containsKey('color_name') ? json['color_name'] : null,
      plateNumber: json.containsKey('plate_number')
          ? json['plate_number']?.toString()
          : null,
      plateCode: json.containsKey('plate_code')
          ? json['plate_code']?.toString()
          : null,
      mileageIn: json.containsKey('mileage_in')
          ? (json['mileage_in'] is double
                ? json['mileage_in']
                : double.tryParse(json['mileage_in']?.toString() ?? ''))
          : null,
      engineTypeId: json.containsKey('engine_type')
          ? json['engine_type']
          : null,
      year: json.containsKey('year')
          ? (json['year'] is int
                ? json['year']
                : int.tryParse(json['year']?.toString() ?? ''))
          : null,
      transmissionType: json.containsKey('transmission_type')
          ? json['transmission_type']?.toString()
          : null,
      fuelAmount: json.containsKey('fuel_amount')
          ? (json['fuel_amount'] is double
                ? json['fuel_amount']
                : double.tryParse(json['fuel_amount']?.toString() ?? ''))
          : null,
      vehicleIdentificationNumber:
          json.containsKey('vehicle_identification_number')
          ? json['vehicle_identification_number']?.toString()
          : null,

      createdAt: json.containsKey('createdAt')
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json.containsKey('updatedAt')
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      jobWarrantyEndDate: json.containsKey('job_warranty_end_date')
          ? json['job_warranty_end_date'] != null
                ? DateTime.tryParse(json['job_warranty_end_date'])
                : null
          : null,
      inspectionReportDetails:
          json.containsKey('inspection_report_details') &&
              json['inspection_report_details'] is Map
          ? InspectionReportDetails.fromJson(
              Map<String, dynamic>.from(json['inspection_report_details']),
            )
          : null,
      carBrandName: json.containsKey('car_brand_name')
          ? json['car_brand_name']?.toString()
          : null,
      carModelName: json.containsKey('car_model_name')
          ? json['car_model_name']?.toString()
          : null,
      technicianName: json.containsKey('technician_name')
          ? json['technician_name']?.toString()
          : null,
      customerName: json.containsKey('customer_name')
          ? json['customer_name']?.toString()
          : null,
      engineTypeName: json.containsKey('engine_type_name')
          ? json['engine_type_name']?.toString()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['_id'] = id;
    if (companyId != null) data['company_id'] = companyId;
    if (jobDate != null) data['job_date'] = jobDate!.toIso8601String();
    if (jobStatus1 != null) data['job_status_1'] = jobStatus1;
    if (jobStatus2 != null) data['job_status_2'] = jobStatus2;
    if (jobNumber != null) data['job_number'] = jobNumber;
    if (technicianId != null) data['technician'] = technicianId;
    if (customerId != null) data['customer'] = customerId;
    if (contactName != null) data['contact_name'] = contactName;
    if (contactEmail != null) data['contact_email'] = contactEmail;
    if (contactNumber != null) data['contact_number'] = contactNumber;
    if (creditLimit != null) data['credit_limit'] = creditLimit;
    if (salesman != null) data['salesman'] = salesman;
    if (carBrandId != null) data['car_brand'] = carBrandId;
    if (carModelId != null) data['car_model'] = carModelId;
    if (plateNumber != null) data['plate_number'] = plateNumber;
    if (plateCode != null) data['plate_code'] = plateCode;
    if (mileageIn != null) data['mileage_in'] = mileageIn;
    if (engineTypeId != null) data['engine_type'] = engineTypeId;
    if (year != null) data['year'] = year;
    if (transmissionType != null) data['transmission_type'] = transmissionType;
    if (fuelAmount != null) data['fuel_amount'] = fuelAmount;
    if (vehicleIdentificationNumber != null) {
      data['vehicle_identification_number'] = vehicleIdentificationNumber;
    }
    if (createdAt != null) data['createdAt'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updatedAt'] = updatedAt!.toIso8601String();
    if (inspectionReportDetails != null) {
      data['inspection_report_details'] = inspectionReportDetails!.toJson();
    }
    if (carBrandName != null) data['car_brand_name'] = carBrandName;
    if (carModelName != null) data['car_model_name'] = carModelName;
    if (technicianName != null) data['technician_name'] = technicianName;
    if (customerName != null) data['customer_name'] = customerName;
    if (engineTypeName != null) data['engine_type_name'] = engineTypeName;
    return data;
  }
}

// -------------------- InspectionReportDetails and nested models --------------------

class InspectionReportDetails {
  final String? id;
  final String? companyId;
  final String? jobCardId;
  final String? customerSugnature;
  final String? advisorSugnature;
  final String? carDialog;
  final WheelCheck? leftFrontWheel;
  final WheelCheck? rightFrontWheel;
  final WheelCheck? leftRearWheel;
  final WheelCheck? rightRearWheel;
  final InteriorExterior? interiorExterior;
  final UnderVehicle? underVehicle;
  final UnderHood? underHood;
  final BatteryPerformance? batteryPerformance;
  final ExtraChecks? extraChecks;
  final List<CarImage>? carImages;
  final String? comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  InspectionReportDetails({
    this.id,
    this.companyId,
    this.jobCardId,
    this.leftFrontWheel,
    this.rightFrontWheel,
    this.leftRearWheel,
    this.rightRearWheel,
    this.interiorExterior,
    this.underVehicle,
    this.underHood,
    this.batteryPerformance,
    this.extraChecks,
    this.carImages,
    this.createdAt,
    this.updatedAt,
    this.advisorSugnature,
    this.carDialog,
    this.customerSugnature,
    this.comment,
  });

  InspectionReportDetails copyWith({
    String? id,
    String? companyId,
    String? jobCardId,
    WheelCheck? leftFrontWheel,
    WheelCheck? rightFrontWheel,
    WheelCheck? leftRearWheel,
    WheelCheck? rightRearWheel,
    InteriorExterior? interiorExterior,
    UnderVehicle? underVehicle,
    UnderHood? underHood,
    BatteryPerformance? batteryPerformance,
    ExtraChecks? extraChecks,
    List<CarImage>? carImages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InspectionReportDetails(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      jobCardId: jobCardId ?? this.jobCardId,
      leftFrontWheel: leftFrontWheel ?? this.leftFrontWheel,
      rightFrontWheel: rightFrontWheel ?? this.rightFrontWheel,
      leftRearWheel: leftRearWheel ?? this.leftRearWheel,
      rightRearWheel: rightRearWheel ?? this.rightRearWheel,
      interiorExterior: interiorExterior ?? this.interiorExterior,
      underVehicle: underVehicle ?? this.underVehicle,
      underHood: underHood ?? this.underHood,
      batteryPerformance: batteryPerformance ?? this.batteryPerformance,
      extraChecks: extraChecks ?? this.extraChecks,
      carImages: carImages ?? this.carImages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory InspectionReportDetails.fromJson(Map<String, dynamic> json) {
    print(json);
    return InspectionReportDetails(
      id: json.containsKey('_id') ? json['_id'] : null,

      customerSugnature: json.containsKey('customer_signature')
          ? json['customer_signature'] ?? ''
          : "",
      advisorSugnature: json.containsKey('advisor_signature')
          ? json['advisor_signature'] ?? ''
          : "",
      carDialog: json.containsKey('car_dialog') ? json['car_dialog'] ?? '' : "",
      companyId: json.containsKey('company_id') ? json['company_id'] : null,
      jobCardId: json.containsKey('job_card_id') ? json['job_card_id'] : null,
      leftFrontWheel:
          json.containsKey('left_front_wheel') &&
              json['left_front_wheel'] is Map
          ? WheelCheck.fromJson(
              Map<String, dynamic>.from(json['left_front_wheel']),
            )
          : null,
      rightFrontWheel:
          json.containsKey('right_front_wheel') &&
              json['right_front_wheel'] is Map
          ? WheelCheck.fromJson(
              Map<String, dynamic>.from(json['right_front_wheel']),
            )
          : null,
      leftRearWheel:
          json.containsKey('left_rear_wheel') && json['left_rear_wheel'] is Map
          ? WheelCheck.fromJson(
              Map<String, dynamic>.from(json['left_rear_wheel']),
            )
          : null,
      rightRearWheel:
          json.containsKey('right_rear_wheel') &&
              json['right_rear_wheel'] is Map
          ? WheelCheck.fromJson(
              Map<String, dynamic>.from(json['right_rear_wheel']),
            )
          : null,
      interiorExterior:
          json.containsKey('interior_exterior') &&
              json['interior_exterior'] is Map
          ? InteriorExterior.fromJson(
              Map<String, dynamic>.from(json['interior_exterior']),
            )
          : null,
      underVehicle:
          json.containsKey('under_vehicle') && json['under_vehicle'] is Map
          ? UnderVehicle.fromJson(
              Map<String, dynamic>.from(json['under_vehicle']),
            )
          : null,
      underHood: json.containsKey('under_hood') && json['under_hood'] is Map
          ? UnderHood.fromJson(Map<String, dynamic>.from(json['under_hood']))
          : null,
      batteryPerformance:
          json.containsKey('battery_performance') &&
              json['battery_performance'] is Map
          ? BatteryPerformance.fromJson(
              Map<String, dynamic>.from(json['battery_performance']),
            )
          : null,
      extraChecks:
          json.containsKey('extra_checks') && json['extra_checks'] is Map
          ? ExtraChecks.fromJson(
              Map<String, dynamic>.from(json['extra_checks']),
            )
          : null,
      carImages: json.containsKey('car_images') && json['car_images'] is List
          ? json['car_images']
                .map<CarImage>(
                  (e) => CarImage.fromJson(Map<String, dynamic>.from(e)),
                )
                .toList()
          : [],

      createdAt: json.containsKey('createdAt')
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json.containsKey('updatedAt')
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      comment: json.containsKey('comment') ? json['comment'] ?? '' : '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['_id'] = id;
    if (companyId != null) data['company_id'] = companyId;
    if (jobCardId != null) data['job_card_id'] = jobCardId;
    if (leftFrontWheel != null) {
      data['left_front_wheel'] = leftFrontWheel!.toJson();
    }
    if (rightFrontWheel != null) {
      data['right_front_wheel'] = rightFrontWheel!.toJson();
    }
    if (leftRearWheel != null) {
      data['left_rear_wheel'] = leftRearWheel!.toJson();
    }
    if (rightRearWheel != null) {
      data['right_rear_wheel'] = rightRearWheel!.toJson();
    }
    if (interiorExterior != null) {
      data['interior_exterior'] = interiorExterior!.toJson();
    }
    if (underVehicle != null) data['under_vehicle'] = underVehicle!.toJson();
    if (underHood != null) data['under_hood'] = underHood!.toJson();
    if (batteryPerformance != null) {
      data['battery_performance'] = batteryPerformance!.toJson();
    }
    if (extraChecks != null) data['extra_checks'] = extraChecks!.toJson();
    if (carImages != null) data['car_images'] = carImages;
    if (createdAt != null) data['createdAt'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updatedAt'] = updatedAt!.toIso8601String();
    return data;
  }
}

class WheelCheck {
  final BrakeItem? brakeLining;
  final BrakeItem? tireTread;
  final BrakeItem? wearPattern;
  final TirePressurePSI? tirePressurePSI;
  final RotorDrum? rotorDrum;

  WheelCheck({
    this.brakeLining,
    this.tireTread,
    this.wearPattern,
    this.tirePressurePSI,
    this.rotorDrum,
  });

  WheelCheck copyWith({
    BrakeItem? brakeLining,
    BrakeItem? tireTread,
    BrakeItem? wearPattern,
    TirePressurePSI? tirePressurePSI,
    RotorDrum? rotorDrum,
  }) {
    return WheelCheck(
      brakeLining: brakeLining ?? this.brakeLining,
      tireTread: tireTread ?? this.tireTread,
      wearPattern: wearPattern ?? this.wearPattern,
      tirePressurePSI: tirePressurePSI ?? this.tirePressurePSI,
      rotorDrum: rotorDrum ?? this.rotorDrum,
    );
  }

  factory WheelCheck.fromJson(Map<String, dynamic> json) {
    return WheelCheck(
      brakeLining:
          json.containsKey('Brake Lining') && json['Brake Lining'] is Map
          ? BrakeItem.fromJson(Map<String, dynamic>.from(json['Brake Lining']))
          : null,
      tireTread: json.containsKey('Tire Tread') && json['Tire Tread'] is Map
          ? BrakeItem.fromJson(Map<String, dynamic>.from(json['Tire Tread']))
          : null,
      wearPattern:
          json.containsKey('Wear Pattern') && json['Wear Pattern'] is Map
          ? BrakeItem.fromJson(Map<String, dynamic>.from(json['Wear Pattern']))
          : null,
      tirePressurePSI:
          json.containsKey('Tire Pressure PSI') &&
              json['Tire Pressure PSI'] is Map
          ? TirePressurePSI.fromJson(
              Map<String, dynamic>.from(json['Tire Pressure PSI']),
            )
          : null,
      rotorDrum: json.containsKey('Rotor / Drum') && json['Rotor / Drum'] is Map
          ? RotorDrum.fromJson(Map<String, dynamic>.from(json['Rotor / Drum']))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (brakeLining != null) data['Brake Lining'] = brakeLining!.toJson();
    if (tireTread != null) data['Tire Tread'] = tireTread!.toJson();
    if (wearPattern != null) data['Wear Pattern'] = wearPattern!.toJson();
    if (tirePressurePSI != null) {
      data['Tire Pressure PSI'] = tirePressurePSI!.toJson();
    }
    if (rotorDrum != null) data['Rotor / Drum'] = rotorDrum!.toJson();
    return data;
  }
}

class BrakeItem {
  final String? value;
  final String? status;

  BrakeItem({this.value, this.status});

  factory BrakeItem.fromJson(Map<String, dynamic> json) => BrakeItem(
    value: json.containsKey('value') ? json['value']?.toString() : null,
    status: json.containsKey('status') ? json['status']?.toString() : null,
  );

  Map<String, dynamic> toJson() => {
    if (value != null) 'value': value,
    if (status != null) 'status': status,
  };
}

class TirePressurePSI {
  final String? before;
  final String? after;

  TirePressurePSI({this.before, this.after});

  factory TirePressurePSI.fromJson(Map<String, dynamic> json) =>
      TirePressurePSI(
        before: json.containsKey('before') ? json['before']?.toString() : null,
        after: json.containsKey('after') ? json['after']?.toString() : null,
      );

  Map<String, dynamic> toJson() => {
    if (before != null) 'before': before,
    if (after != null) 'after': after,
  };
}

class RotorDrum {
  final String? status;
  RotorDrum({this.status});
  factory RotorDrum.fromJson(Map<String, dynamic> json) => RotorDrum(
    status: json.containsKey('status') ? json['status']?.toString() : null,
  );
  Map<String, dynamic> toJson() => {if (status != null) 'status': status};
}

class InteriorExterior {
  final RotorDrum? lights;
  final RotorDrum? windshieldWasher;
  final RotorDrum? windshieldCondition;
  final RotorDrum? mirrorsGlass;
  final RotorDrum? emergencyBrakeAdjustment;
  final RotorDrum? hornOperation;
  final RotorDrum? fuelTankCapGasket;
  final RotorDrum? airConditioningFilter;
  final RotorDrum? clutchOperation;
  final RotorDrum? backUpLights;
  final RotorDrum? dashWarningLights;
  final RotorDrum? carpetUpholstery;

  InteriorExterior({
    this.lights,
    this.windshieldWasher,
    this.windshieldCondition,
    this.mirrorsGlass,
    this.emergencyBrakeAdjustment,
    this.hornOperation,
    this.fuelTankCapGasket,
    this.airConditioningFilter,
    this.clutchOperation,
    this.backUpLights,
    this.dashWarningLights,
    this.carpetUpholstery,
  });

  factory InteriorExterior.fromJson(
    Map<String, dynamic> json,
  ) => InteriorExterior(
    lights:
        json.containsKey(
              'Head Lights, Tail Lights, Turn Signals, Breake Lights, Hazard Lights, Exterioi Lamps, License Plate Lights',
            ) &&
            json['Head Lights, Tail Lights, Turn Signals, Breake Lights, Hazard Lights, Exterioi Lamps, License Plate Lights']
                is Map
        ? RotorDrum.fromJson(
            Map<String, dynamic>.from(
              json['Head Lights, Tail Lights, Turn Signals, Breake Lights, Hazard Lights, Exterioi Lamps, License Plate Lights'],
            ),
          )
        : null,
    windshieldWasher:
        json.containsKey('Windshield Washer/Wiper Operation, Wiper Blades') &&
            json['Windshield Washer/Wiper Operation, Wiper Blades'] is Map
        ? RotorDrum.fromJson(
            Map<String, dynamic>.from(
              json['Windshield Washer/Wiper Operation, Wiper Blades'],
            ),
          )
        : null,
    windshieldCondition:
        json.containsKey('Windshield Condition: Cracks / Chips / Pitting') &&
            json['Windshield Condition: Cracks / Chips / Pitting'] is Map
        ? RotorDrum.fromJson(
            Map<String, dynamic>.from(
              json['Windshield Condition: Cracks / Chips / Pitting'],
            ),
          )
        : null,
    mirrorsGlass:
        json.containsKey('Mirrors / Glass') && json['Mirrors / Glass'] is Map
        ? RotorDrum.fromJson(Map<String, dynamic>.from(json['Mirrors / Glass']))
        : null,
    emergencyBrakeAdjustment:
        json.containsKey('Emergency Brake Adjustment') &&
            json['Emergency Brake Adjustment'] is Map
        ? RotorDrum.fromJson(
            Map<String, dynamic>.from(json['Emergency Brake Adjustment']),
          )
        : null,
    hornOperation:
        json.containsKey('Horn Operation') && json['Horn Operation'] is Map
        ? RotorDrum.fromJson(Map<String, dynamic>.from(json['Horn Operation']))
        : null,
    fuelTankCapGasket:
        json.containsKey('Fuel Tank Cap Gasket') &&
            json['Fuel Tank Cap Gasket'] is Map
        ? RotorDrum.fromJson(
            Map<String, dynamic>.from(json['Fuel Tank Cap Gasket']),
          )
        : null,
    airConditioningFilter:
        json.containsKey('Air Conditioning Filter (if equipped)') &&
            json['Air Conditioning Filter (if equipped)'] is Map
        ? RotorDrum.fromJson(
            Map<String, dynamic>.from(
              json['Air Conditioning Filter (if equipped)'],
            ),
          )
        : null,
    clutchOperation:
        json.containsKey('Clutch Operation (if equipped)') &&
            json['Clutch Operation (if equipped)'] is Map
        ? RotorDrum.fromJson(
            Map<String, dynamic>.from(json['Clutch Operation (if equipped)']),
          )
        : null,
    backUpLights:
        json.containsKey('Back Up Lights Left / Right') &&
            json['Back Up Lights Left / Right'] is Map
        ? RotorDrum.fromJson(
            Map<String, dynamic>.from(json['Back Up Lights Left / Right']),
          )
        : null,
    dashWarningLights:
        json.containsKey('Dash Warning Lights') &&
            json['Dash Warning Lights'] is Map
        ? RotorDrum.fromJson(
            Map<String, dynamic>.from(json['Dash Warning Lights']),
          )
        : null,
    carpetUpholstery:
        json.containsKey('Carpet / Upholstery / Floor Mats') &&
            json['Carpet / Upholstery / Floor Mats'] is Map
        ? RotorDrum.fromJson(
            Map<String, dynamic>.from(json['Carpet / Upholstery / Floor Mats']),
          )
        : null,
  );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (lights != null) {
      data['Head Lights, Tail Lights, Turn Signals, Breake Lights, Hazard Lights, Exterioi Lamps, License Plate Lights'] =
          lights!.toJson();
    }
    if (windshieldWasher != null) {
      data['Windshield Washer/Wiper Operation, Wiper Blades'] =
          windshieldWasher!.toJson();
    }
    if (windshieldCondition != null) {
      data['Windshield Condition: Cracks / Chips / Pitting'] =
          windshieldCondition!.toJson();
    }
    if (mirrorsGlass != null) data['Mirrors / Glass'] = mirrorsGlass!.toJson();
    if (emergencyBrakeAdjustment != null) {
      data['Emergency Brake Adjustment'] = emergencyBrakeAdjustment!.toJson();
    }
    if (hornOperation != null) data['Horn Operation'] = hornOperation!.toJson();
    if (fuelTankCapGasket != null) {
      data['Fuel Tank Cap Gasket'] = fuelTankCapGasket!.toJson();
    }
    if (airConditioningFilter != null) {
      data['Air Conditioning Filter (if equipped)'] = airConditioningFilter!
          .toJson();
    }
    if (clutchOperation != null) {
      data['Clutch Operation (if equipped)'] = clutchOperation!.toJson();
    }
    if (backUpLights != null) {
      data['Back Up Lights Left / Right'] = backUpLights!.toJson();
    }
    if (dashWarningLights != null) {
      data['Dash Warning Lights'] = dashWarningLights!.toJson();
    }
    if (carpetUpholstery != null) {
      data['Carpet / Upholstery / Floor Mats'] = carpetUpholstery!.toJson();
    }
    return data;
  }
}

class UnderVehicle {
  final RotorDrum? shockAbsorbers;
  final RotorDrum? steering;
  final RotorDrum? muffler;
  final RotorDrum? engineOilAndFluidLeaks;
  final RotorDrum? brakesLinesHosesParkingBrakeCable;
  final RotorDrum? driveShaftBoots;
  final RotorDrum? transmissionDifferential;
  final RotorDrum? fluidLinesAndConnections;
  final RotorDrum? inspectNutsAndBolts;

  UnderVehicle({
    this.shockAbsorbers,
    this.steering,
    this.muffler,
    this.engineOilAndFluidLeaks,
    this.brakesLinesHosesParkingBrakeCable,
    this.driveShaftBoots,
    this.transmissionDifferential,
    this.fluidLinesAndConnections,
    this.inspectNutsAndBolts,
  });

  factory UnderVehicle.fromJson(Map<String, dynamic> json) => UnderVehicle(
    shockAbsorbers:
        json.containsKey('Shock Absorbers / Suspension / Struts') &&
            json['Shock Absorbers / Suspension / Struts'] is Map
        ? RotorDrum.fromJson(
            Map<String, dynamic>.from(
              json['Shock Absorbers / Suspension / Struts'],
            ),
          )
        : null,
    steering:
        json.containsKey('Steering Box, Linkage, Ball Joints, Dust Covers') &&
            json['Steering Box, Linkage, Ball Joints, Dust Covers'] is Map
        ? RotorDrum.fromJson(
            Map<String, dynamic>.from(
              json['Steering Box, Linkage, Ball Joints, Dust Covers'],
            ),
          )
        : null,
    muffler:
        json.containsKey(
              'Muffler, Exhaust Pipes/Mounts. Catalytic Converter',
            ) &&
            json['Muffler, Exhaust Pipes/Mounts. Catalytic Converter'] is Map
        ? RotorDrum.fromJson(
            Map<String, dynamic>.from(
              json['Muffler, Exhaust Pipes/Mounts. Catalytic Converter'],
            ),
          )
        : null,
    engineOilAndFluidLeaks:
        json.containsKey('Engine Oil and Fluid Leaks') &&
            json['Engine Oil and Fluid Leaks'] is Map
        ? RotorDrum.fromJson(
            Map<String, dynamic>.from(json['Engine Oil and Fluid Leaks']),
          )
        : null,
    brakesLinesHosesParkingBrakeCable:
        json.containsKey('Brakes Lines, Hoses, Parking Brake Cable') &&
            json['Brakes Lines, Hoses, Parking Brake Cable'] is Map
        ? RotorDrum.fromJson(
            Map<String, dynamic>.from(
              json['Brakes Lines, Hoses, Parking Brake Cable'],
            ),
          )
        : null,
    driveShaftBoots:
        json.containsKey(
              'Drive Shaft Boots, Constant Velocity Boots, U-Joints, Transmission Linkage (if equipped)',
            ) &&
            json['Drive Shaft Boots, Constant Velocity Boots, U-Joints, Transmission Linkage (if equipped)']
                is Map
        ? RotorDrum.fromJson(
            Map<String, dynamic>.from(
              json['Drive Shaft Boots, Constant Velocity Boots, U-Joints, Transmission Linkage (if equipped)'],
            ),
          )
        : null,
    transmissionDifferential:
        json.containsKey(
              'Transmission, Differential, Transfer Case, (Check Fluid Level, Fluid Condition and Fluid Leaks)',
            ) &&
            json['Transmission, Differential, Transfer Case, (Check Fluid Level, Fluid Condition and Fluid Leaks)']
                is Map
        ? RotorDrum.fromJson(
            Map<String, dynamic>.from(
              json['Transmission, Differential, Transfer Case, (Check Fluid Level, Fluid Condition and Fluid Leaks)'],
            ),
          )
        : null,
    fluidLinesAndConnections:
        json.containsKey(
              'Fluid Lines and Connections, Fluid Tank Band, Fuel Tank Vapor Vent Systems Hoses',
            ) &&
            json['Fluid Lines and Connections, Fluid Tank Band, Fuel Tank Vapor Vent Systems Hoses']
                is Map
        ? RotorDrum.fromJson(
            Map<String, dynamic>.from(
              json['Fluid Lines and Connections, Fluid Tank Band, Fuel Tank Vapor Vent Systems Hoses'],
            ),
          )
        : null,
    inspectNutsAndBolts:
        json.containsKey('Inspect Nuts and Blots on Body and Chassis') &&
            json['Inspect Nuts and Blots on Body and Chassis'] is Map
        ? RotorDrum.fromJson(
            Map<String, dynamic>.from(
              json['Inspect Nuts and Blots on Body and Chassis'],
            ),
          )
        : null,
  );

  Map<String, dynamic> toJson() {
    final d = <String, dynamic>{};
    if (shockAbsorbers != null) {
      d['Shock Absorbers / Suspension / Struts'] = shockAbsorbers!.toJson();
    }
    if (steering != null) {
      d['Steering Box, Linkage, Ball Joints, Dust Covers'] = steering!.toJson();
    }
    if (muffler != null) {
      d['Muffler, Exhaust Pipes/Mounts. Catalytic Converter'] = muffler!
          .toJson();
    }
    if (engineOilAndFluidLeaks != null) {
      d['Engine Oil and Fluid Leaks'] = engineOilAndFluidLeaks!.toJson();
    }
    if (brakesLinesHosesParkingBrakeCable != null) {
      d['Brakes Lines, Hoses, Parking Brake Cable'] =
          brakesLinesHosesParkingBrakeCable!.toJson();
    }
    if (driveShaftBoots != null) {
      d['Drive Shaft Boots, Constant Velocity Boots, U-Joints, Transmission Linkage (if equipped)'] =
          driveShaftBoots!.toJson();
    }
    if (transmissionDifferential != null) {
      d['Transmission, Differential, Transfer Case, (Check Fluid Level, Fluid Condition and Fluid Leaks)'] =
          transmissionDifferential!.toJson();
    }
    if (fluidLinesAndConnections != null) {
      d['Fluid Lines and Connections, Fluid Tank Band, Fuel Tank Vapor Vent Systems Hoses'] =
          fluidLinesAndConnections!.toJson();
    }
    if (inspectNutsAndBolts != null) {
      d['Inspect Nuts and Blots on Body and Chassis'] = inspectNutsAndBolts!
          .toJson();
    }
    return d;
  }
}

class UnderHood {
  final RotorDrum? fluidLevels;
  final RotorDrum? engineAirFilter;
  final RotorDrum? driveBelts;
  final RotorDrum? coolingSystemHoses;
  final RotorDrum? clutchReservoir;
  final RotorDrum? radiatorCore;

  UnderHood({
    this.fluidLevels,
    this.engineAirFilter,
    this.driveBelts,
    this.coolingSystemHoses,
    this.clutchReservoir,
    this.radiatorCore,
  });

  factory UnderHood.fromJson(Map<String, dynamic> json) => UnderHood(
    fluidLevels:
        json.containsKey(
              'Fluid Levels: Oil, Coolant, Battery, Power Steering, Brake Fluid, Washer, Automatic Transmission',
            ) &&
            json['Fluid Levels: Oil, Coolant, Battery, Power Steering, Brake Fluid, Washer, Automatic Transmission']
                is Map
        ? RotorDrum.fromJson(
            Map<String, dynamic>.from(
              json['Fluid Levels: Oil, Coolant, Battery, Power Steering, Brake Fluid, Washer, Automatic Transmission'],
            ),
          )
        : null,
    engineAirFilter:
        json.containsKey('Engine Air Filter') &&
            json['Engine Air Filter'] is Map
        ? RotorDrum.fromJson(
            Map<String, dynamic>.from(json['Engine Air Filter']),
          )
        : null,
    driveBelts:
        json.containsKey('Drive Belts (condition and adjustment)') &&
            json['Drive Belts (condition and adjustment)'] is Map
        ? RotorDrum.fromJson(
            Map<String, dynamic>.from(
              json['Drive Belts (condition and adjustment)'],
            ),
          )
        : null,
    coolingSystemHoses:
        json.containsKey(
              'Cooling System Hoses, Heater Hpses, Air Condition, Hoses and Connections',
            ) &&
            json['Cooling System Hoses, Heater Hpses, Air Condition, Hoses and Connections']
                is Map
        ? RotorDrum.fromJson(
            Map<String, dynamic>.from(
              json['Cooling System Hoses, Heater Hpses, Air Condition, Hoses and Connections'],
            ),
          )
        : null,
    clutchReservoir:
        json.containsKey('Clutch Reservoir Fluid / Condition (as equipped)') &&
            json['Clutch Reservoir Fluid / Condition (as equipped)'] is Map
        ? RotorDrum.fromJson(
            Map<String, dynamic>.from(
              json['Clutch Reservoir Fluid / Condition (as equipped)'],
            ),
          )
        : null,
    radiatorCore:
        json.containsKey('Radiator Core, Air Conditioner Condenser') &&
            json['Radiator Core, Air Conditioner Condenser'] is Map
        ? RotorDrum.fromJson(
            Map<String, dynamic>.from(
              json['Radiator Core, Air Conditioner Condenser'],
            ),
          )
        : null,
  );

  Map<String, dynamic> toJson() {
    final d = <String, dynamic>{};
    if (fluidLevels != null) {
      d['Fluid Levels: Oil, Coolant, Battery, Power Steering, Brake Fluid, Washer, Automatic Transmission'] =
          fluidLevels!.toJson();
    }
    if (engineAirFilter != null) {
      d['Engine Air Filter'] = engineAirFilter!.toJson();
    }
    if (driveBelts != null) {
      d['Drive Belts (condition and adjustment)'] = driveBelts!.toJson();
    }
    if (coolingSystemHoses != null) {
      d['Cooling System Hoses, Heater Hpses, Air Condition, Hoses and Connections'] =
          coolingSystemHoses!.toJson();
    }
    if (clutchReservoir != null) {
      d['Clutch Reservoir Fluid / Condition (as equipped)'] = clutchReservoir!
          .toJson();
    }
    if (radiatorCore != null) {
      d['Radiator Core, Air Conditioner Condenser'] = radiatorCore!.toJson();
    }
    return d;
  }
}

class BatteryPerformance {
  final RotorDrum? batteryTerminalCablesMountings;
  final RotorDrum? conditionOfBatteryColdCrankingAmps;
  final BatteryColdCrankingAmps? batteryColdCrankingAmps;

  BatteryPerformance({
    this.batteryTerminalCablesMountings,
    this.conditionOfBatteryColdCrankingAmps,
    this.batteryColdCrankingAmps,
  });

  factory BatteryPerformance.fromJson(Map<String, dynamic> json) =>
      BatteryPerformance(
        batteryTerminalCablesMountings:
            json.containsKey('Battery Terminal / Cables / Mountings') &&
                json['Battery Terminal / Cables / Mountings'] is Map
            ? RotorDrum.fromJson(
                Map<String, dynamic>.from(
                  json['Battery Terminal / Cables / Mountings'],
                ),
              )
            : null,
        conditionOfBatteryColdCrankingAmps:
            json.containsKey('Condition Of Battery / Cold Cranking Amps') &&
                json['Condition Of Battery / Cold Cranking Amps'] is Map
            ? RotorDrum.fromJson(
                Map<String, dynamic>.from(
                  json['Condition Of Battery / Cold Cranking Amps'],
                ),
              )
            : null,
        batteryColdCrankingAmps:
            json.containsKey('Battery Cold Cranking Amps') &&
                json['Battery Cold Cranking Amps'] is Map
            ? BatteryColdCrankingAmps.fromJson(
                Map<String, dynamic>.from(json['Battery Cold Cranking Amps']),
              )
            : null,
      );

  Map<String, dynamic> toJson() {
    final d = <String, dynamic>{};
    if (batteryTerminalCablesMountings != null) {
      d['Battery Terminal / Cables / Mountings'] =
          batteryTerminalCablesMountings!.toJson();
    }
    if (conditionOfBatteryColdCrankingAmps != null) {
      d['Condition Of Battery / Cold Cranking Amps'] =
          conditionOfBatteryColdCrankingAmps!.toJson();
    }
    if (batteryColdCrankingAmps != null) {
      d['Battery Cold Cranking Amps'] = batteryColdCrankingAmps!.toJson();
    }
    return d;
  }
}

class BatteryColdCrankingAmps {
  final String? factorySpecs;
  final String? actual;
  BatteryColdCrankingAmps({this.factorySpecs, this.actual});
  factory BatteryColdCrankingAmps.fromJson(Map<String, dynamic> json) =>
      BatteryColdCrankingAmps(
        factorySpecs: json.containsKey('Factory Specs')
            ? json['Factory Specs']?.toString()
            : null,
        actual: json.containsKey('Actual') ? json['Actual']?.toString() : null,
      );
  Map<String, dynamic> toJson() => {
    if (factorySpecs != null) 'Factory Specs': factorySpecs,
    if (actual != null) 'Actual': actual,
  };
}

class ExtraChecks {
  final RotorDrum? alignmentCheckNeeded;
  final RotorDrum? wheelBallanceNeeded;
  final RotorDrum? brakeInspectionNotPerformedThisVisit;

  ExtraChecks({
    this.alignmentCheckNeeded,
    this.wheelBallanceNeeded,
    this.brakeInspectionNotPerformedThisVisit,
  });

  factory ExtraChecks.fromJson(Map<String, dynamic> json) => ExtraChecks(
    alignmentCheckNeeded:
        json.containsKey('Alignment Check Needed') &&
            json['Alignment Check Needed'] is Map
        ? RotorDrum.fromJson(
            Map<String, dynamic>.from(json['Alignment Check Needed']),
          )
        : null,
    wheelBallanceNeeded:
        json.containsKey('Wheel Ballance Needed') &&
            json['Wheel Ballance Needed'] is Map
        ? RotorDrum.fromJson(
            Map<String, dynamic>.from(json['Wheel Ballance Needed']),
          )
        : null,
    brakeInspectionNotPerformedThisVisit:
        json.containsKey('Brake Inspection Not Performed This Visit') &&
            json['Brake Inspection Not Performed This Visit'] is Map
        ? RotorDrum.fromJson(
            Map<String, dynamic>.from(
              json['Brake Inspection Not Performed This Visit'],
            ),
          )
        : null,
  );

  Map<String, dynamic> toJson() => {
    if (alignmentCheckNeeded != null)
      'Alignment Check Needed': alignmentCheckNeeded!.toJson(),
    if (wheelBallanceNeeded != null)
      'Wheel Ballance Needed': wheelBallanceNeeded!.toJson(),
    if (brakeInspectionNotPerformedThisVisit != null)
      'Brake Inspection Not Performed This Visit':
          brakeInspectionNotPerformedThisVisit!.toJson(),
  };
}

// ----------------------------------------------------------------------------
// End of file
// ----------------------------------------------------------------------------

// Updated for new JSON structure
class CarImage {
  final String? url;
  final String? imagePublicId;
  final DateTime? createdAt;

  CarImage({this.url, this.imagePublicId, this.createdAt});

  factory CarImage.fromJson(Map<String, dynamic> json) {
    return CarImage(
      url: json.containsKey('url') ? json['url'] as String? : null,
      imagePublicId: json.containsKey('image_public_id')
          ? json['image_public_id'] as String?
          : null,
      createdAt: json.containsKey('created_at')
          ? DateTime.tryParse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'url': url,
    'image_public_id': imagePublicId,
  };
}
