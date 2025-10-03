import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/company_variables_controller.dart';
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
                                Row(
                                  spacing: 20,
                                  children: [
                                    labelBox(
                                      label: 'Company Information',
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
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
                                labelBox(
                                  label: 'Owner\'s Information',
                                  onPressed: () {},
                                ),

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
                      labelBox(label: 'Responsibilities', onPressed: () {}),

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
                      labelBox(label: 'Variables', onPressed: () {}),
                      Column(
                        spacing: 2,
                        children: List.generate(
                          controller.companyVariables.length,
                          (i) {
                            final key = controller.companyVariables.keys
                                .elementAt(i);
                            final val = controller.companyVariables[key];
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
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Row labelBox({required String label, required void Function()? onPressed}) {
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
        IconButton(
          iconSize: 20,
          tooltip: 'Edit',
          color: Colors.grey.shade700,
          onPressed: onPressed,
          icon: const Icon(Icons.edit),
        ),
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
