import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/company_controller.dart';
import '../../my_text_field.dart';
import '../drop_down_menu.dart';

Widget addNewCompanyOrView({
  required BoxConstraints constraints,
  required BuildContext context,
  required CompanyController controller,
  TextEditingController? companyName,
  TextEditingController? typeOfBusiness,
  TextEditingController? userName,
  TextEditingController? email,
  TextEditingController? phoneNumber,
  TextEditingController? address,
  TextEditingController? city,
  TextEditingController? country,
  String companyLogo = '',
  List? roleIDFromList,
  bool? canEdit = true,
}) {
  return SizedBox(
    width: constraints.maxWidth / 1.5,
    // height: 100,
    child: ListView(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: myTextFormFieldWithBorder(
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
                child: GetX<CompanyController>(builder: (controller) {
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
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: myTextFormFieldWithBorder(
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
                child: myTextFormFieldWithBorder(
                  obscureText: false,
                  controller: phoneNumber ?? controller.phoneNumber,
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
                child: myTextFormFieldWithBorder(
                  obscureText: false,
                  controller: email ?? controller.email,
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  validate: true,
                  isEnabled: canEdit,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: myTextFormFieldWithBorder(
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
          child: myTextFormFieldWithBorder(
            obscureText: false,
            controller: address ?? controller.address,
            labelText: 'Address',
            hintText: 'Enter your address',
            validate: true,
          ),
        ),
        GetX<CompanyController>(builder: (controller) {
          final isCountriesLoading = controller.allCountries.isEmpty;

          return Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: dropDownValues(
                    listValues: controller.allCountries.values
                        .map((value) => value['name'].toString())
                        .toList(),
                    labelText: 'Country',
                    hintText: 'Enter your country',
                    textController: country ?? controller.country,
                    validate: true,
                    menus: isCountriesLoading ? {} : controller.allCountries,
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text('${suggestion['name']}'),
                      );
                    },
                    onSelected: (suggestion) {
                      controller.country.text = suggestion['name'];
                      controller.allCountries.entries.where((entry) {
                        return entry.value['name'] ==
                            suggestion['name'].toString();
                      }).forEach(
                        (entry) {
                          // controller.onSelect(entry.key);
                          controller.getCitiesByCountryID(entry.key);
                          controller.city.clear();
                          controller.selectedCountryId.value = entry.key;
                        },
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: dropDownValues(
                    listValues: controller.allCities.values
                        .map((value) => value['name'].toString())
                        .toList(),
                    suggestionsController: SuggestionsController(),
                    onTapForTypeAheadField: SuggestionsController().refresh,
                    labelText: 'City',
                    hintText: 'Enter your city',
                    textController: city ?? controller.city,
                    validate: true,
                    menus: controller.allCities.isEmpty
                        ? {}
                        : controller.allCities,
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text('${suggestion['name']}'),
                      );
                    },
                    onSelected: (suggestion) {
                      controller.city.text = suggestion['name'];
                      controller.allCities.entries.where((entry) {
                        return entry.value['name'] ==
                            suggestion['name'].toString();
                      }).forEach((entry) {
                        controller.selectedCityId.value = entry.key;
                      });
                    },
                  ),
                ),
              ),
            ],
          );
        }),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GetX<CompanyController>(builder: (context) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: dropDownValues(
                        listValues: controller.allRoles.values
                            .map((value) => value.toString())
                            .toList(),
                        onSelected: (suggestion) {
                          controller.allRoles.entries.where((entry) {
                            return entry.value == suggestion.toString();
                          }).forEach((entry) {
                            if (!controller.roleIDFromList
                                .contains(entry.key)) {
                              controller.roleIDFromList.add(entry.key);
                            }
                          });
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion.toString()),
                          );
                        },
                        labelText: 'Responsibilities',
                        hintText: 'Select responsibility',
                        menus: controller.allRoles.isEmpty
                            ? {}
                            : controller.allRoles,
                        validate: true,
                      ),
                    ),
                    if (controller.roleIDFromList.isNotEmpty)
                      ListView(
                        shrinkWrap: true,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
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
                          )
                        ],
                      ),
                  ],
                );
              }),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GetBuilder<CompanyController>(builder: (controller) {
                  return InkWell(
                    onTap: () {
                      controller.pickImage();
                    },
                    child: Container(
                      height: 120,
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
                          controller.imageBytes == null && companyLogo.isEmpty
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
                                      fit: BoxFit.fitHeight,
                                    )
                                  : Image.network(
                                      companyLogo,
                                      fit: BoxFit.fitHeight,
                                    ),
                    ),
                  );
                }),
              ),
            ),
          ],
        )
      ],
    ),
  );
}
