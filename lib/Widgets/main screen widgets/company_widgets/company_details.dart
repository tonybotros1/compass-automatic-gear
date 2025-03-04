import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/company_controller.dart';
import '../../../consts.dart';
import '../../my_text_field.dart';
import '../drop_down_menu.dart';

Container companyDetails({
  required CompanyController controller,
}) {
  return Container(
    padding: EdgeInsets.all(20),
    decoration: containerDecor,
    child: Row(
      spacing: 10,
      children: [
        Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 10,
              children: [
                myTextFormFieldWithBorder(
                  obscureText: false,
                  controller: controller.companyName,
                  labelText: 'Company Name',
                  hintText: 'Enter company name',
                  keyboardType: TextInputType.name,
                  validate: true,
                ),
                GetX<CompanyController>(builder: (controller) {
                  final isIndustryLoading = controller.industryMap.isEmpty;
                  return dropDownValues(
                    listValues: controller.industryMap.values
                        .map((value) => value['name'].toString())
                        .toList(),
                    textController: controller.industry,
                    labelText: 'Industry',
                    hintText: 'Enter industry',
                    validate: true,
                    menus: isIndustryLoading ? {} : controller.industryMap,
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text('${suggestion['name']}'),
                      );
                    },
                    onSelected: (suggestion) {
                      controller.industry.text = '${suggestion['name']}';
                      controller.industryMap.entries.where((entry) {
                        return entry.value['name'] ==
                            suggestion['name'].toString();
                      }).forEach((entry) {
                        controller.industryId.value = entry.key;
                      });
                    },
                  );
                }),
              ],
            )),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GetBuilder<CompanyController>(builder: (controller) {
              return InkWell(
                onTap: () {
                  controller.pickImage();
                },
                child: Container(
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      style: BorderStyle.solid,
                      color: controller.warningForImage.value == false
                          ? Colors.grey
                          : Colors.red,
                    ),
                  ),
                  child: controller.imageBytes == null &&
                          controller.logoUrl.value.isEmpty
                      ? const Center(
                          child: FittedBox(
                            child: Text(
                              'No image selected',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      : controller.imageBytes != null
                          ? Image.memory(
                              controller.imageBytes!,
                              fit: BoxFit.contain,
                            )
                          : Image.network(
                              controller.logoUrl.value,
                              fit: BoxFit.contain,
                            ),
                ),
              );
            }),
          ),
        ),
      ],
    ),
  );
}
