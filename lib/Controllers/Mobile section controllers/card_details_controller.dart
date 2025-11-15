import 'dart:async';
import 'package:datahubai/Models/job%20cards/inspection_report_model.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../../Models/image_with_data_model.dart';
import 'cards_screen_controller.dart';

class CardDetailsController extends GetxController {
  Map<String, List<ImageWithDate>> groupedImages = {};
  OverlayEntry? overlayEntry;
  Timer? hoverTimer;
  bool isOverlayVisible = false;
  late String customerName = '';
  late String carBrand = '';
  late String carModel = '';
  late String plateNumber = '';
  late double carMileage = 0;
  late String vin = '';
  late String engineType = '';
  late String phoneNumber = '';
  late String emailAddress = '';
  late String color = '';
  late String technician = '';
  late String date = '';
  late String jobNumber = '';
  late String id = '';
  late String video = '';
  late String status = '';
  late String comments = '';
  late String code = '';
  late int year = 2020;
  double fuelAmount = 50;
  late String customerSignature = '';
  late String advisorSignature = '';
  List<CarImage> carImages = [];
  InspectionReportModel data = InspectionReportModel();
  CardsScreenController controller = Get.put(CardsScreenController());

  @override
  void onInit() async {
    getDetails();
    super.onInit();
  }

  void clearVariables() {
    controller.clearAllValues();
  }

  void getDetails() {
    if (Get.arguments != null) {
      InspectionReportModel arguments = Get.arguments;
      InspectionReportDetails details =
          arguments.inspectionReportDetails ?? InspectionReportDetails();
      engineType = arguments.engineTypeName ?? '';
      fuelAmount = arguments.fuelAmount ?? 0;
      technician = arguments.technicianName ?? '';
      data = arguments;
      customerSignature = details.customerSugnature ?? '';
      advisorSignature = details.advisorSugnature ?? '';
      customerName = arguments.customerName ?? '';
      carImages = details.carImages ?? [];
      carBrand = arguments.carBrandName ?? '';
      carModel = arguments.carModelName ?? '';
      plateNumber = arguments.plateNumber ?? '';
      carMileage = arguments.mileageIn ?? 0;
      vin = arguments.vehicleIdentificationNumber ?? '';
      comments = details.comment ?? '';
      phoneNumber = arguments.contactNumber ?? '';
      emailAddress = arguments.contactEmail ?? '';
      color = arguments.colorName ?? '';
      date = textToDate(arguments.jobDate);
      id = arguments.id ?? '';
      jobNumber = arguments.jobNumber ?? '';
      status = arguments.jobStatus1 ?? '';
      code = arguments.plateCode ?? '';
      year = arguments.year ?? 2020;
    }
  }

  Map<String, Map<String, String>> wheelCheckToMap(WheelCheck? wheel) {
    if (wheel == null) return {};

    final map = <String, Map<String, String>>{};

    if (wheel.brakeLining != null) {
      map['Brake Lining'] = {
        'value': wheel.brakeLining?.value ?? '',
        'status': wheel.brakeLining?.status ?? '',
      };
    }

    if (wheel.tireTread != null) {
      map['Tire Tread'] = {
        'value': wheel.tireTread?.value ?? '',
        'status': wheel.tireTread?.status ?? '',
      };
    }

    if (wheel.wearPattern != null) {
      map['Wear Pattern'] = {
        'value': wheel.wearPattern?.value ?? '',
        'status': wheel.wearPattern?.status ?? '',
      };
    }

    if (wheel.tirePressurePSI != null) {
      map['Tire Pressure PSI'] = {
        'before': wheel.tirePressurePSI?.before ?? '',
        'after': wheel.tirePressurePSI?.after ?? '',
      };
    }

    if (wheel.rotorDrum != null) {
      map['Rotor / Drum'] = {'status': wheel.rotorDrum?.status ?? ''};
    }
    return map;
  }

  Map<String, Map<String, String>> batteryPerformanceToMap(
    BatteryPerformance? battery,
  ) {
    if (battery == null) return {};

    final map = <String, Map<String, String>>{};

    if (battery.batteryTerminalCablesMountings != null) {
      map['Battery Terminal / Cables / Mountings'] = {
        'status': battery.batteryTerminalCablesMountings?.status ?? '',
      };
    }

    if (battery.batteryColdCrankingAmps != null) {
      map['Battery Cold Cranking Amps'] = {
        'Factory Specs': battery.batteryColdCrankingAmps?.factorySpecs ?? '',
        'Actual': battery.batteryColdCrankingAmps?.actual ?? '',
      };
    }

    if (battery.conditionOfBatteryColdCrankingAmps != null) {
      map['Condition Of Battery / Cold Cranking Amps'] = {
        'status': battery.conditionOfBatteryColdCrankingAmps?.status ?? '',
      };
    }

    return map;
  }

  Map<String, Map<String, String>> extraChecksToMap(ExtraChecks? checks) {
    if (checks == null) return {};

    final map = <String, Map<String, String>>{};

    if (checks.alignmentCheckNeeded != null) {
      map['Alignment Check Needed'] = {
        'status': checks.alignmentCheckNeeded?.status ?? '',
      };
    }

    if (checks.brakeInspectionNotPerformedThisVisit != null) {
      map['Brake Inspection Not Performed This Visit'] = {
        'status': checks.brakeInspectionNotPerformedThisVisit?.status ?? '',
      };
    }

    if (checks.wheelBallanceNeeded != null) {
      map['Wheel Ballance Needed'] = {
        'status': checks.wheelBallanceNeeded?.status ?? '',
      };
    }

    return map;
  }

  Map<String, Map<String, String>> underHoodToMap(UnderHood? underHood) {
    if (underHood == null) return {};

    final map = <String, Map<String, String>>{};

    if (underHood.fluidLevels != null) {
      map['Fluid Levels: Oil, Coolant, Battery, Power Steering, Brake Fluid, Washer, Automatic Transmission'] =
          {'status': underHood.fluidLevels?.status ?? ''};
    }

    if (underHood.engineAirFilter != null) {
      map['Engine Air Filter'] = {
        'status': underHood.engineAirFilter?.status ?? '',
      };
    }

    if (underHood.driveBelts != null) {
      map['Drive Belts (condition and adjustment)'] = {
        'status': underHood.driveBelts?.status ?? '',
      };
    }

    if (underHood.coolingSystemHoses != null) {
      map['Cooling System Hoses, Heater Hpses, Air Condition, Hoses and Connections'] =
          {'status': underHood.coolingSystemHoses?.status ?? ''};
    }

    if (underHood.radiatorCore != null) {
      map['Radiator Core, Air Conditioner Condenser'] = {
        'status': underHood.radiatorCore?.status ?? '',
      };
    }

    if (underHood.clutchReservoir != null) {
      map['Clutch Reservoir Fluid / Condition (as equipped)'] = {
        'status': underHood.clutchReservoir?.status ?? '',
      };
    }

    return map;
  }

  Map<String, Map<String, String>> underVehicleToMap(
    UnderVehicle? underVehicle,
  ) {
    if (underVehicle == null) return {};

    final map = <String, Map<String, String>>{};

    if (underVehicle.shockAbsorbers != null) {
      map['Shock Absorbers / Suspension / Struts'] = {
        'status': underVehicle.shockAbsorbers?.status ?? '',
      };
    }

    if (underVehicle.steering != null) {
      map['Steering Box, Linkage, Ball Joints, Dust Covers'] = {
        'status': underVehicle.steering?.status ?? '',
      };
    }

    if (underVehicle.muffler != null) {
      map['Muffler, Exhaust Pipes/Mounts. Catalytic Converter'] = {
        'status': underVehicle.muffler?.status ?? '',
      };
    }

    if (underVehicle.engineOilAndFluidLeaks != null) {
      map['Engine Oil and Fluid Leaks'] = {
        'status': underVehicle.engineOilAndFluidLeaks?.status ?? '',
      };
    }

    if (underVehicle.brakesLinesHosesParkingBrakeCable != null) {
      map['Brakes Lines, Hoses, Parking Brake Cable'] = {
        'status': underVehicle.brakesLinesHosesParkingBrakeCable?.status ?? '',
      };
    }

    if (underVehicle.driveShaftBoots != null) {
      map['Drive Shaft Boots, Constant Velocity Boots, U-Joints, Transmission Linkage (if equipped)'] =
          {'status': underVehicle.driveShaftBoots?.status ?? ''};
    }

    if (underVehicle.transmissionDifferential != null) {
      map['Transmission, Differential, Transfer Case, (Check Fluid Level, Fluid Condition and Fluid Leaks)'] =
          {'status': underVehicle.transmissionDifferential?.status ?? ''};
    }

    if (underVehicle.fluidLinesAndConnections != null) {
      map['Fluid Lines and Connections, Fluid Tank Band, Fuel Tank Vapor Vent Systems Hoses'] =
          {'status': underVehicle.fluidLinesAndConnections?.status ?? ''};
    }

    if (underVehicle.inspectNutsAndBolts != null) {
      map['Inspect Nuts and Blots on Body and Chassis'] = {
        'status': underVehicle.inspectNutsAndBolts?.status ?? '',
      };
    }

    return map;
  }

  Map<String, Map<String, String>> interiorExteriorToMap(
    InteriorExterior? interiorExterior,
  ) {
    if (interiorExterior == null) return {};

    final map = <String, Map<String, String>>{};

    if (interiorExterior.lights != null) {
      map['Head Lights, Tail Lights, Turn Signals, Breake Lights, Hazard Lights, Exterioi Lamps, License Plate Lights'] =
          {'status': interiorExterior.lights?.status ?? ''};
    }

    if (interiorExterior.windshieldWasher != null) {
      map['Windshield Washer/Wiper Operation, Wiper Blades'] = {
        'status': interiorExterior.windshieldWasher?.status ?? '',
      };
    }

    if (interiorExterior.windshieldCondition != null) {
      map['Windshield Condition: Cracks / Chips / Pitting'] = {
        'status': interiorExterior.windshieldCondition?.status ?? '',
      };
    }

    if (interiorExterior.mirrorsGlass != null) {
      map['Mirrors / Glass'] = {
        'status': interiorExterior.mirrorsGlass?.status ?? '',
      };
    }

    if (interiorExterior.emergencyBrakeAdjustment != null) {
      map['Emergency Brake Adjustment'] = {
        'status': interiorExterior.emergencyBrakeAdjustment?.status ?? '',
      };
    }

    if (interiorExterior.hornOperation != null) {
      map['Horn Operation'] = {
        'status': interiorExterior.hornOperation?.status ?? '',
      };
    }

    if (interiorExterior.fuelTankCapGasket != null) {
      map['Fuel Tank Cap Gasket'] = {
        'status': interiorExterior.fuelTankCapGasket?.status ?? '',
      };
    }

    if (interiorExterior.airConditioningFilter != null) {
      map['Air Conditioning Filter (if equipped)'] = {
        'status': interiorExterior.airConditioningFilter?.status ?? '',
      };
    }

    if (interiorExterior.clutchOperation != null) {
      map['Clutch Operation (if equipped)'] = {
        'status': interiorExterior.clutchOperation?.status ?? '',
      };
    }

    if (interiorExterior.backUpLights != null) {
      map['Back Up Lights Left / Right'] = {
        'status': interiorExterior.backUpLights?.status ?? '',
      };
    }

    if (interiorExterior.dashWarningLights != null) {
      map['Dash Warning Lights'] = {
        'status': interiorExterior.dashWarningLights?.status ?? '',
      };
    }

    if (interiorExterior.carpetUpholstery != null) {
      map['Carpet / Upholstery / Floor Mats'] = {
        'status': interiorExterior.carpetUpholstery?.status ?? '',
      };
    }

    return map;
  }

  void loadVariables() {
    InspectionReportDetails details =
        data.inspectionReportDetails ?? InspectionReportDetails();
    controller.imagesList.clear();
    controller.currenyJobId.value = id;
    controller.inEditMode.value = true;
    data.technicianId != '' && data.technicianId != null
        ? controller.technicianName.value.text = data.technicianName ?? ''
        : '';
    controller.technicianId.value =
        data.technicianId != '' && data.technicianId != null
        ? data.technicianId ?? ''
        : '';
    controller.date.text = textToDate(data.jobDate);
    controller.transmissionType.text = data.transmissionType ?? '';
    controller.fuelAmount.text = data.fuelAmount.toString();
    controller.customer.text = customerName;
    controller.customerId.value = data.customerId ?? '';
    controller.brand.text = carBrand;
    controller.brandId.value = data.carBrandId ?? '';
    controller.model.text = carModel;
    controller.modelId.value = data.carModelId ?? '';
    controller.color.text = color;
    controller.colorId.value = data.colorId ?? '';
    controller.plateNumber.text = plateNumber;
    controller.code.text = data.plateCode ?? '';
    controller.engineTypeId.value = data.engineTypeId ?? '';
    controller.engineType.text = data.engineTypeName ?? '';
    controller.year.text = data.year.toString();
    controller.mileage.text = data.mileageIn.toString();
    controller.vin.text = data.vehicleIdentificationNumber ?? '';
    controller.comments.text = details.comment ?? '';

    // left front inside break and tire
    controller.selectedCheckBoxIndicesForLeftFront.assignAll(
      wheelCheckToMap(details.leftFrontWheel),
    );
    controller.leftFrontBrakeLining.text =
        controller
            .selectedCheckBoxIndicesForLeftFront['Brake Lining']?['value'] ??
        '';
    controller.leftFrontTireTread.text =
        controller
            .selectedCheckBoxIndicesForLeftFront['Tire Tread']?['value'] ??
        '';

    controller.leftFrontWearPattern.text =
        controller
            .selectedCheckBoxIndicesForLeftFront['Wear Pattern']?['value'] ??
        '';
    controller.leftFrontTirePressureBefore.text =
        controller
            .selectedCheckBoxIndicesForLeftFront['Tire Pressure PSI']?['before'] ??
        '';
    controller.leftFrontTirePressureAfter.text =
        controller
            .selectedCheckBoxIndicesForLeftFront['Tire Pressure PSI']?['after'] ??
        '';

    // right front inside break and tire
    controller.selectedCheckBoxIndicesForRightFront.assignAll(
      wheelCheckToMap(details.rightFrontWheel),
    );
    controller.rightFrontBrakeLining.text =
        controller
            .selectedCheckBoxIndicesForRightFront['Brake Lining']?['value'] ??
        '';
    controller.rightFrontTireTread.text =
        controller
            .selectedCheckBoxIndicesForRightFront['Tire Tread']?['value'] ??
        '';

    controller.rightFrontWearPattern.text =
        controller
            .selectedCheckBoxIndicesForRightFront['Wear Pattern']?['value'] ??
        '';
    controller.rightFrontTirePressureBefore.text =
        controller
            .selectedCheckBoxIndicesForRightFront['Tire Pressure PSI']?['before'] ??
        '';
    controller.rightFrontTirePressureAfter.text =
        controller
            .selectedCheckBoxIndicesForRightFront['Tire Pressure PSI']?['after'] ??
        '';

    // left rear inside break and tire
    controller.selectedCheckBoxIndicesForLeftRear.assignAll(
      wheelCheckToMap(details.leftRearWheel),
    );

    controller.leftRearBrakeLining.text =
        controller
            .selectedCheckBoxIndicesForLeftRear['Brake Lining']?['value'] ??
        '';
    controller.leftRearTireTread.text =
        controller.selectedCheckBoxIndicesForLeftRear['Tire Tread']?['value'] ??
        '';

    controller.leftRearWearPattern.text =
        controller
            .selectedCheckBoxIndicesForLeftRear['Wear Pattern']?['value'] ??
        '';
    controller.leftRearTirePressureBefore.text =
        controller
            .selectedCheckBoxIndicesForLeftRear['Tire Pressure PSI']?['before'] ??
        '';
    controller.leftRearTirePressureAfter.text =
        controller
            .selectedCheckBoxIndicesForLeftRear['Tire Pressure PSI']?['after'] ??
        '';

    // right rear inside break and tire
    controller.selectedCheckBoxIndicesForRightRear.assignAll(
      wheelCheckToMap(details.rightRearWheel),
    );

    controller.rightRearBrakeLining.text =
        controller
            .selectedCheckBoxIndicesForRightRear['Brake Lining']?['value'] ??
        '';
    controller.rightRearTireTread.text =
        controller
            .selectedCheckBoxIndicesForRightRear['Tire Tread']?['value'] ??
        '';

    controller.rightRearWearPattern.text =
        controller
            .selectedCheckBoxIndicesForRightRear['Wear Pattern']?['value'] ??
        '';
    controller.rightRearTirePressureBefore.text =
        controller
            .selectedCheckBoxIndicesForRightRear['Tire Pressure PSI']?['before'] ??
        '';
    controller.rightRearTirePressureAfter.text =
        controller
            .selectedCheckBoxIndicesForRightRear['Tire Pressure PSI']?['after'] ??
        '';

    controller.selectedCheckBoxIndicesForInteriorExterior.assignAll(
      interiorExteriorToMap(details.interiorExterior),
    );

    controller.selectedCheckBoxIndicesForUnderVehicle.assignAll(
      underVehicleToMap(details.underVehicle),
    );

    controller.selectedCheckBoxIndicesForUnderHood.assignAll(
      underHoodToMap(details.underHood),
    );

    controller.selectedCheckBoxIndicesForBatteryPerformance.assignAll(
      batteryPerformanceToMap(details.batteryPerformance),
    );
    controller.batteryColdCrankingAmpsFactorySpecs.text =
        controller
            .selectedCheckBoxIndicesForBatteryPerformance['Battery Cold Cranking Amps']?['Factory Specs'] ??
        '';
    controller.batteryColdCrankingAmpsActual.text =
        controller
            .selectedCheckBoxIndicesForBatteryPerformance['Battery Cold Cranking Amps']?['Actual'] ??
        '';

    controller.selectedCheckBoxIndicesForSingleCheckBoxForBrakeAndTire
        .assignAll(extraChecksToMap(details.extraChecks));

    List<CarImage> urls = details.carImages ?? [];

    if (urls.isNotEmpty) {
      controller.carImagesURLs.assignAll(urls.map((img) => img.url ?? ''));
    }

    controller.customerSignatureURL.value = details.customerSugnature ?? '';
    controller.advisorSignatureURL.value = details.advisorSugnature ?? '';
    controller.carDialogImageURL.value = details.carDialog ?? '';
    controller.carBrandLogo.value = data.carLogo ?? '';
  }

  void openImageViewer(List imageUrls, int index) {
    Get.toNamed(
      '/imageViewer',
      arguments: {'images': imageUrls, 'index': index},
    );
  }

  // this is for cached images
  final customCachedManeger = CacheManager(
    Config('customCacheKey', stalePeriod: const Duration(days: 3)),
  );

  void showFullScreen(BuildContext context, String imageUrl) {
    // تجنب عرض الصورة مجددًا إذا كانت موجودة بالفعل
    if (isOverlayVisible) return;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: GestureDetector(
          onTap: () => removeOverlay(),
          child: Container(
            color: Colors.black,
            child: Center(child: Image.network(imageUrl, fit: BoxFit.contain)),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry!);
    isOverlayVisible = true; // يتم عرض الصورة
  }

  void removeOverlay() {
    hoverTimer?.cancel(); // تأكد من إلغاء المؤقت
    overlayEntry?.remove();
    overlayEntry = null;
    isOverlayVisible = false; // تم إزالة الصورة
  }

  // this fuction is the get the path of the image from url
  String getFilePathFromUrl(String url) {
    final uri = Uri.parse(url);
    final encodedPath = uri.pathSegments[4]; // path segment after /o/
    return Uri.decodeComponent(encodedPath); // decode %2F back to /
  }

  
}
