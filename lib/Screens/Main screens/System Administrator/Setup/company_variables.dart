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
                                Text(
                                  'Company Information',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
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
                                        value: val,
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
                                Text(
                                  'Owner\'s Information',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
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
                                        value: val,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          Column(
                            spacing: 20,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Responsibilities',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Column(
                                spacing: 2,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  controller.userRoles.length,
                                  (i) {
                                    return dataLine(
                                      title: controller.userRoles[i],
                                      value: '',
                                      index: i,
                                      constraints: constraints,
                                      titleColor: Colors.grey.shade800,
                                    );
                                    //  Text(
                                    //   controller.userRoles[i],
                                    //   style: TextStyle(
                                    //     color: Colors.blueGrey,
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    // );
                                  },
                                ),
                              ),
                            ],
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

  Container dataLine({
    required BoxConstraints constraints,
    required String title,
    required String value,
    required int index,
    Color? titleColor,
  }) {
    Color color = index % 2 == 0 ? Colors.grey.shade300 : Colors.grey.shade200;
    return Container(
      width: constraints.maxWidth / 3,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color,
      ),
      child: Row(
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
              ? Text(
                  value,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Container logoBox(double size, {Widget? child}) {
    return Container(
      height: size,
      width: size,
      padding: EdgeInsets.all(8),

      child: child ?? SizedBox(),
    );
  }
}


// Row(spacing: 10,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           controller.companyLogo.value.isNotEmpty
//                               ? logoBox(
//                                   controller.logoSize,
//                                   child: Image.network(
//                                     fit: BoxFit.fitWidth,
//                                     controller.companyLogo.value,
//                                   ),
//                                 )
//                               : logoBox(controller.logoSize),

//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Text(controller.companyName.value,style: TextStyle(
//                                     color: Colors.grey.shade700,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 25
//                                   ),)
//                                 ],
//                               )
//                         ],
//                       ),