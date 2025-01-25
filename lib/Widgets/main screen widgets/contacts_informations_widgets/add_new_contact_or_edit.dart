import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/contact_informations_controller.dart';
import '../../my_text_field.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';

import '../drop_down_menu.dart';
import 'contacts_card.dart';
import 'image_section.dart';
import 'social_card.dart';

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
          DefaultTabController(
            length: 3,
            child: Column(
              children: <Widget>[
                ButtonsTabBar(
                  buttonMargin: EdgeInsets.symmetric(horizontal: 60),
                  contentPadding: EdgeInsets.symmetric(horizontal: 60),
                  backgroundColor: Colors.blue[400],
                  unselectedBackgroundColor: Colors.grey[300],
                  unselectedLabelStyle: TextStyle(
                    color: Colors.black87,
                  ),
                  labelStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(icon: Icon(Icons.home), text: 'Address Card'),
                    Tab(icon: Icon(Icons.contacts), text: 'Contact Card'),
                    Tab(icon: Icon(Icons.alternate_email), text: 'Social Card'),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 600,
                  child: TabBarView(
                    children: <Widget>[
                      Center(
                        child: Icon(Icons.directions_car),
                      ),
                      GetX<ContactInformationsController>(
                          builder: (controller) {
                        return contactsCardSection(controller);
                      }),
                      GetX<ContactInformationsController>(
                          builder: (controller) {
                        return socialCardSection(controller);
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
