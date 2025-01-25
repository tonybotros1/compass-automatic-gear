import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/contact_informations_controller.dart';
import '../../my_text_field.dart';
import '../drop_down_menu.dart';
import 'image_section.dart';

Widget addNewContactOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required ContactInformationsController controller,
  TextEditingController? name,
  TextEditingController? groupName,
  TextEditingController? typrOfBusiness,
  bool? canEdit,
}) {
  return SizedBox(
    height: constraints.maxHeight,
    width: constraints.maxWidth,
    child: SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    myTextFormField2(
                      icon: Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                      obscureText: false,
                      controller: name ?? controller.contactName,
                      labelText: 'Name',
                      hintText: 'Enter Contact Name',
                      validate: true,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    myTextFormField2(
                      icon: Icon(
                        Icons.apartment,
                        color: Colors.grey,
                      ),
                      obscureText: false,
                      controller: groupName ?? controller.groupName,
                      labelText: 'Group Name',
                      hintText: 'Enter Group Name',
                      validate: true,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GetX<ContactInformationsController>(builder: (controller) {
                      return dropDownValues(
                        icon: Icon(
                          Icons.receipt_long,
                          color: Colors.grey,
                        ),
                        textController:
                            typrOfBusiness ?? controller.typrOfBusiness.value,
                        onSelected: (suggestion) {
                          controller.typrOfBusiness.value.text =
                              '${suggestion['name']}';
                          controller.typeOfBusinessMap.entries.where((entry) {
                            return entry.value['name'] ==
                                suggestion['name'].toString();
                          }).forEach((entry) {
                            controller.typrOfBusinessId.value = entry.key;
                          });
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text('${suggestion['name']}'),
                          );
                        },
                        labelText: 'Type Of Business',
                        hintText: 'Select Type Of Business',
                        menus: controller.typeOfBusinessMap.isNotEmpty
                            ? controller.typeOfBusinessMap
                            : {},
                        validate: false,
                        controller: controller,
                      );
                    }),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GetBuilder<ContactInformationsController>(
                    builder: (controller) {
                  return imageSection(controller);
                }),
              ),
            ],
          ),
          GetBuilder<ContactInformationsController>(builder: (controller) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SizedBox(
                height: 60,
                child: ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 100),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: controller.taps.length,
                  itemBuilder: (context, i) {
                    return Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: controller.taps[i].isPressed == true
                              ? Colors.blue
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            controller.selectFromTaps(i);
                          },
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            style: TextStyle(
                              color: controller.taps[i].isPressed == false
                                  ? Colors.grey.shade700
                                  : Colors.white,
                              fontSize: controller.taps[i].isPressed == true
                                  ? 18
                                  : 16, // Font size change
                              fontWeight: controller.taps[i].isPressed == true
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            child: Text(controller.taps[i].title),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
          GetBuilder<ContactInformationsController>(
              builder: (controller) {
            return controller.buildTapsContent(
                controller.selectedTap.value, controller);
          }),
        ],
      ),
    ),
  );
}


