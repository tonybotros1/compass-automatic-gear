import 'dart:async';
import 'package:datahubai/Models/job%20cards/inspection_report_model.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../../Models/image_with_data_model.dart';
import '../../Widgets/Mobile widgets/inspection report widgets/inspection_reports_hekpers.dart';
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
  late String year = '';
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
      year = arguments.year?.toString() ?? '';
    }
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
    controller.year.text = data.year?.toString() ?? '';
    controller.mileage.text = data.mileageIn.toString();
    controller.vin.text = data.vehicleIdentificationNumber ?? '';
    controller.comments.text = details.comment ?? '';
    controller.jobNumber.text = data.jobNumber ?? '';

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
      controller.carImagesURLs.assignAll(urls);
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
