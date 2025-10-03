import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/company_controller.dart';
import '../../../consts.dart';
import '../../my_text_field.dart';

Container companyDetails({required CompanyController controller}) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    child: Row(
      spacing: 10,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
              GetX<CompanyController>(
                builder: (controller) {
                  final isIndustryLoading = controller.industryMap.isEmpty;
                  return CustomDropdown(
                    width: 300,
                    textcontroller: controller.industry.value.text,
                    hintText: 'Industry',
                    showedSelectedName: 'name',
                    items: isIndustryLoading ? {} : controller.industryMap,
                    onChanged: (key, value) {
                      controller.industry.value.text = value['name'];
                      controller.industryId.value = key;
                    },
                  );
                },
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GetBuilder<CompanyController>(
              builder: (controller) {
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
                    child:
                        controller.imageBytes == null &&
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
                            errorBuilder: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    ),
  );
}
