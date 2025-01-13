import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/Main screen controllers/company_controller.dart';
import '../../consts.dart';
import '../my_text_field.dart';
import 'drop_down_menu.dart';

Widget addNewCompanyOrView({
  required BoxConstraints constraints,
  required BuildContext context,
  required controller,
  TextEditingController? companyName,
  TextEditingController? typeOfBusiness,
  TextEditingController? userName,
  TextEditingController? address,
  TextEditingController? city,
  TextEditingController? country,
}) {
  return SizedBox(
    width: constraints.maxWidth / 2,
    // height: 100,
    child: ListView(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: myTextFormField2(
                  obscureText: false,
                  controller: companyName ?? controller.companyName,
                  labelText: 'Company Name',
                  hintText: 'Enter company name',
                  keyboardType: TextInputType.name,
                  validate: true,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: myTextFormField2(
                  obscureText: false,
                  controller: typeOfBusiness ?? controller.typeOfBusiness,
                  labelText: 'Type Of Business',
                  hintText: 'Enter type of business',
                  validate: true,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: myTextFormField2(
                  obscureText: false,
                  controller: userName ?? controller.userName,
                  labelText: 'Name',
                  hintText: 'Enter your name',
                  keyboardType: TextInputType.name,
                  validate: true,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: myTextFormField2(
                  obscureText: false,
                  controller: controller.phoneNumber,
                  labelText: 'Phone Number',
                  hintText: 'Enter your phone Number',
                  validate: true,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: myTextFormField2(
                  obscureText: false,
                  controller: controller.email,
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  validate: true,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: myTextFormField2(
                  obscureText: false,
                  controller: controller.password,
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  validate: true,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: myTextFormField2(
            obscureText: false,
            controller: address ?? controller.address,
            labelText: 'Address',
            hintText: 'Enter your address',
            validate: true,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: myTextFormField2(
                  obscureText: false,
                  controller: country ?? controller.country,
                  labelText: 'Country',
                  hintText: 'Enter country',
                  keyboardType: TextInputType.name,
                  validate: true,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: myTextFormField2(
                  obscureText: false,
                  controller: city ?? controller.city,
                  labelText: 'City',
                  hintText: 'Enter city',
                  validate: true,
                ),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GetBuilder<CompanyController>(builder: (controller) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        style: selectButtonStyle,
                        onPressed: () {
                          controller.pickImage();
                        },
                        child: const Text('Select Logo'),
                      ),
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            style: BorderStyle.solid,
                            color: controller.warningForImage.value == false
                                ? Colors.grey
                                : Colors.red,
                          ),
                        ),
                        child: controller.imageBytes == null
                            ? const Center(
                                child: FittedBox(
                                  child: Text(
                                    'No image selected',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              )
                            : Image.memory(
                                controller.imageBytes!,
                                fit: BoxFit.cover,
                              ),
                      )
                    ],
                  );
                }),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: dropDownValues(
                      labelText: 'Responsibilities',
                      hintText: 'Select responsibility',
                      menus: controller.allRoles ?? [],
                      validate: true,
                      ids: controller.roleIDFromList ?? [],
                    ),
                  ),
                  if (controller.roleIDFromList?.isNotEmpty ?? false)
                    ListView(
                      shrinkWrap: true,
                      children: [
                        GetX<CompanyController>(builder: (controller) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Wrap(
                              spacing: 10, // Horizontal spacing between items
                              runSpacing: 10, // Vertical spacing between rows
                              children: List.generate(
                                controller.roleIDFromList.length,
                                (i) {
                                  final roleName = controller.getRoleName(
                                      controller.roleIDFromList[i] ?? 0);
                                  return Stack(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 160, 176, 212),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          roleName,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: InkWell(
                                          onTap: () {
                                            controller.removeMenuFromList(i);
                                          },
                                          child: const Icon(
                                            Icons.remove_circle,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                ],
              ),
            ),
          ],
        )
      ],
    ),
  );
}
