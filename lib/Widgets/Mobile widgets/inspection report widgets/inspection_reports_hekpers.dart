 import '../../../Models/job cards/inspection_report_model.dart';

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