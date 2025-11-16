import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/company_variables_controller.dart';
import '../../../../Widgets/main screen widgets/company_variables_widgets/variables_dialog.dart';
import '../../../../consts.dart';

class CompanyVariables extends StatelessWidget {
  const CompanyVariables({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: screenPadding,
            child: SingleChildScrollView(
              child: GetX<CompanyVariablesController>(
                init: CompanyVariablesController(),
                builder: (controller) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Row(
                        spacing: 40,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                labelBox('Company Information'),
                                controller.companyLogo.value.isNotEmpty
                                    ? logoBox(
                                        controller.logoSize,
                                        child: Image.network(
                                          fit: BoxFit.fitWidth,
                                          controller.companyLogo.value,
                                        ),
                                      )
                                    : logoBox(controller.logoSize),

                                Column(
                                  spacing: 2,
                                  children: List.generate(
                                    controller.companyInformation.length,
                                    (index) {
                                      final key = controller
                                          .companyInformation
                                          .keys
                                          .elementAt(index);
                                      final val =
                                          controller.companyInformation[key];
                                      return dataLine(
                                        index: index,
                                        constraints: constraints,
                                        title: key,
                                        value: '$val',
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              spacing: 20,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                labelBox('Owner\'s Information'),

                                Column(
                                  spacing: 2,
                                  children: List.generate(
                                    controller.ownerInformation.length,
                                    (index) {
                                      final key = controller
                                          .ownerInformation
                                          .keys
                                          .elementAt(index);
                                      final val =
                                          controller.ownerInformation[key];
                                      return dataLine(
                                        index: index,
                                        constraints: constraints,
                                        title: key,
                                        value: val.toString(),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      labelBox('Responsibilities'),

                      Wrap(
                        spacing: 20,
                        children: List.generate(controller.userRoles.length, (
                          i,
                        ) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey.shade200,
                            ),
                            child: textForDataRowInTable(
                              text: controller.userRoles[i],
                              isBold: true,
                              color: Colors.grey.shade700,
                              maxWidth: null,
                            ),
                          );
                        }),
                      ),
                      const Divider(),
                      Row(
                        spacing: 40,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              spacing: 20,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                labelBox(
                                  'Variables',
                                  onPressed: () {
                                    controller
                                        .incentivePercentage
                                        .text = controller.removePercent(
                                      controller
                                          .companyVariables['Incentive Percentage'],
                                    );
                                    controller
                                        .vatPercentage
                                        .text = controller.removePercent(
                                      controller
                                          .companyVariables['VAT Percentage'],
                                    );
                                    controller.taxNumber.text =
                                        controller
                                            .companyVariables['TAX Number'] ??
                                        '';
                                    variablesDialog(
                                      constraints: constraints,
                                      controller: controller,
                                      onPressed:
                                          controller.updatingVariables.isFalse
                                          ? () {
                                              controller.updateVariables();
                                            }
                                          : null,
                                    );
                                  },
                                ),
                                Column(
                                  spacing: 2,
                                  children: List.generate(
                                    controller.companyVariables.length,
                                    (i) {
                                      final key = controller
                                          .companyVariables
                                          .keys
                                          .elementAt(i);
                                      final val =
                                          controller.companyVariables[key];
                                      return dataLine(
                                        constraints: constraints,
                                        index: i,
                                        title: key,
                                        value: val.toString(),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              spacing: 20,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GetX<CompanyVariablesController>(
                                  builder: (controller) {
                                    return labelBox(
                                      'Inspection Report',
                                      icon:
                                          controller
                                              .updatingInspectionReport
                                              .isFalse
                                          ? const Icon(Icons.save_outlined)
                                          : const SpinKitDoubleBounce(
                                              color: Colors.grey,
                                              size: 20,
                                            ),
                                      onPressed:
                                          controller
                                              .updatingInspectionReport
                                              .isFalse
                                          ? () {
                                              controller
                                                  .updateInspectionReport();
                                            }
                                          : null,
                                      iconToolTip: 'Save',
                                    );
                                  },
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 300,
                                        child: Row(
                                          children: [
                                            GetX<CompanyVariablesController>(
                                              builder: (controller) {
                                                return CupertinoCheckbox(
                                                  checkColor: mainColor,
                                                  activeColor:
                                                      Colors.grey.shade200,
                                                  value: controller
                                                      .isBreakeAndTireSelected
                                                      .value,
                                                  onChanged: (value) {
                                                    controller
                                                        .selectForInspectionReport(
                                                          "Break And Tire",
                                                          value!,
                                                        );
                                                  },
                                                );
                                              },
                                            ),
                                            Text(
                                              'Break And Tire',
                                              style: fontStyleForCheckBoxes,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 300,
                                        child: Row(
                                          children: [
                                            GetX<CompanyVariablesController>(
                                              builder: (controller) {
                                                return CupertinoCheckbox(
                                                  checkColor: mainColor,
                                                  activeColor:
                                                      Colors.grey.shade200,
                                                  value: controller
                                                      .isInteriorExteriorSelected
                                                      .value,
                                                  onChanged: (value) {
                                                    controller
                                                        .selectForInspectionReport(
                                                          "Interior / Exterior",
                                                          value!,
                                                        );
                                                  },
                                                );
                                              },
                                            ),
                                            Text(
                                              'Interior / Exterior',
                                              style: fontStyleForCheckBoxes,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          GetX<CompanyVariablesController>(
                                            builder: (controller) {
                                              return CupertinoCheckbox(
                                                checkColor: mainColor,
                                                activeColor:
                                                    Colors.grey.shade200,
                                                value: controller
                                                    .isUnderVehicleSelected
                                                    .value,
                                                onChanged: (value) {
                                                  controller
                                                      .selectForInspectionReport(
                                                        "Under Vehicle",
                                                        value!,
                                                      );
                                                },
                                              );
                                            },
                                          ),
                                          Text(
                                            'Under Vehicle',
                                            style: fontStyleForCheckBoxes,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 300,
                                        child: Row(
                                          children: [
                                            GetX<CompanyVariablesController>(
                                              builder: (controller) {
                                                return CupertinoCheckbox(
                                                  checkColor: mainColor,
                                                  activeColor:
                                                      Colors.grey.shade200,
                                                  value: controller
                                                      .isUnderHoodSelected
                                                      .value,
                                                  onChanged: (value) {
                                                    controller
                                                        .selectForInspectionReport(
                                                          "Under Hood",
                                                          value!,
                                                        );
                                                  },
                                                );
                                              },
                                            ),
                                            Text(
                                              'Under Hood',
                                              style: fontStyleForCheckBoxes,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 300,
                                        child: Row(
                                          children: [
                                            GetX<CompanyVariablesController>(
                                              builder: (controller) {
                                                return CupertinoCheckbox(
                                                  checkColor: mainColor,
                                                  activeColor:
                                                      Colors.grey.shade200,
                                                  value: controller
                                                      .isBatteryPerformaceSelected
                                                      .value,
                                                  onChanged: (value) {
                                                    controller
                                                        .selectForInspectionReport(
                                                          "Battery Performace",
                                                          value!,
                                                        );
                                                  },
                                                );
                                              },
                                            ),
                                            Text(
                                              'Battery Performace',
                                              style: fontStyleForCheckBoxes,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          GetX<CompanyVariablesController>(
                                            builder: (controller) {
                                              return CupertinoCheckbox(
                                                checkColor: mainColor,
                                                activeColor:
                                                    Colors.grey.shade200,
                                                value: controller
                                                    .isBodyDamageSelected
                                                    .value,
                                                onChanged: (value) {
                                                  controller
                                                      .selectForInspectionReport(
                                                        "Body Damage",
                                                        value!,
                                                      );
                                                },
                                              );
                                            },
                                          ),
                                          Text(
                                            'Body Damage',
                                            style: fontStyleForCheckBoxes,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Row labelBox(
    String label, {
    void Function()? onPressed,
    Widget? icon,
    String? iconToolTip,
  }) {
    return Row(
      spacing: 20,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        onPressed != null
            ? IconButton(
                iconSize: 20,
                tooltip: iconToolTip ?? 'Edit',
                color: Colors.grey.shade700,
                onPressed: onPressed,
                icon: icon ?? const Icon(Icons.edit),
              )
            : const SizedBox(),
      ],
    );
  }

  Container dataLine({
    required BoxConstraints constraints,
    required String title,
    required String value,
    required int index,
    Color? titleColor,
  }) {
    Color color = index % 2 == 0 ? Colors.grey.shade200 : Colors.grey.shade100;
    return Container(
      width: constraints.maxWidth / 3,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color,
      ),
      child: Row(
        spacing: 20,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(
            title,
            style: TextStyle(
              color: titleColor ?? secColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          value != ''
              ? Expanded(
                  child: Text(
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                    value,
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Container logoBox(double size, {Widget? child}) {
    return Container(
      height: size,
      width: size,
      padding: const EdgeInsets.all(8),

      child: child ?? const SizedBox(),
    );
  }
}
