import 'package:datahubai/Controllers/Main%20screen%20controllers/car_brands_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../my_text_field.dart';

Widget addNewBrandOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required CarBrandsController controller,
  bool? canEdit,
}) {
  return SizedBox(
    width: constraints.maxWidth / 2.5,
    height: 250,
    child: ListView(
      children: [
        SizedBox(
          height: 5,
        ),
        myTextFormFieldWithBorder(
          obscureText: false,
          controller: controller.brandName,
          labelText: 'Name',
          hintText: 'Enter Name',
          validate: true,
        ),
        SizedBox(
          height: 10,
        ),
        GetBuilder<CarBrandsController>(builder: (controller) {
          return InkWell(
            onTap: () {
              controller.pickImage();
            },
            child: Container(
              height: 155,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border:
                    Border.all(style: BorderStyle.solid, color: Colors.grey),
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
      ],
    ),
  );
}
