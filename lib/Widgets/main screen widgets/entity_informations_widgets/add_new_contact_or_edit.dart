import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';

Widget addNewEntityOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required EntityInformationsController controller,
  TextEditingController? name,
  TextEditingController? groupName,
  TextEditingController? typrOfBusiness,
  bool? canEdit,
}) {
  return SizedBox(
    height: constraints.maxHeight,
    width: constraints.maxWidth,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildLeftSideMenu(),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xffEAE2C6),
              borderRadius: BorderRadius.circular(5),
            ),
            child:
                GetBuilder<EntityInformationsController>(builder: (controller) {
              return controller.buildRightContent(
                  controller.selectedMenu.value, controller, constraints);
            }),
          ),
        )
      ],
    ),
  );
}

GetBuilder<EntityInformationsController> buildLeftSideMenu() {
  // Declare and initialize ScrollController

  return GetBuilder<EntityInformationsController>(builder: (controller) {
    return Container(
      width: 320,
      height: 400,
      padding: const EdgeInsets.fromLTRB(35, 30, 0, 30),
      decoration: BoxDecoration(
        color: Color(0xffEAE2C6),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: ListView.builder(
          controller: controller.scrollController,
          shrinkWrap: true,
          itemCount: controller.menus.length,
          itemBuilder: (context, i) {
            return Row(
              children: [
                Text(
                  '${i + 1}',
                  style: TextStyle(
                    color: controller.menus[i].isPressed == false
                        ? Colors.grey.shade700
                        : Color(0xff2973B2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: 2,
                    height: controller.menus[i].isPressed == true ? 100 : 70,
                    color: controller.menus[i].isPressed == false
                        ? Colors.white54
                        : Color(0xff2973B2),
                  ),
                ),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  style: TextStyle(
                    color: controller.menus[i].isPressed == false
                        ? Colors.grey.shade700
                        : Color(0xff2973B2),
                    fontSize: controller.menus[i].isPressed == true
                        ? 18
                        : 16, // Font size change
                    fontWeight: controller.menus[i].isPressed == true
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  child: FittedBox(child: Text(controller.menus[i].title)),
                ),
              ],
            );
          },
        ),
      ),
    );
  });
}



// Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   children: [
//                     myTextFormField2(
//                       icon: Icon(
//                         Icons.person,
//                         color: Colors.grey,
//                       ),
//                       obscureText: false,
//                       controller: name ?? controller.contactName,
//                       labelText: 'Name',
//                       hintText: 'Enter Contact Name',
//                       validate: true,
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     myTextFormField2(
//                       icon: Icon(
//                         Icons.apartment,
//                         color: Colors.grey,
//                       ),
//                       obscureText: false,
//                       controller: groupName ?? controller.groupName,
//                       labelText: 'Group Name',
//                       hintText: 'Enter Group Name',
//                       validate: true,
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     GetX<EntityInformationsController>(builder: (controller) {
//                       return dropDownValues(
//                         icon: Icon(
//                           Icons.receipt_long,
//                           color: Colors.grey,
//                         ),
//                         textController:
//                             typrOfBusiness ?? controller.typrOfBusiness.value,
//                         onSelected: (suggestion) {
//                           controller.typrOfBusiness.value.text =
//                               '${suggestion['name']}';
//                           controller.typeOfBusinessMap.entries.where((entry) {
//                             return entry.value['name'] ==
//                                 suggestion['name'].toString();
//                           }).forEach((entry) {
//                             controller.typrOfBusinessId.value = entry.key;
//                           });
//                         },
//                         itemBuilder: (context, suggestion) {
//                           return ListTile(
//                             title: Text('${suggestion['name']}'),
//                           );
//                         },
//                         labelText: 'Type Of Business',
//                         hintText: 'Select Type Of Business',
//                         menus: controller.typeOfBusinessMap.isNotEmpty
//                             ? controller.typeOfBusinessMap
//                             : {},
//                         validate: false,
//                         controller: controller,
//                       );
//                     }),
//                     SizedBox(
//                       height: 10,
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: GetBuilder<EntityInformationsController>(
//                     builder: (controller) {
//                   return imageSection(controller);
//                 }),
//               ),
//             ],
//           ),
//           GetBuilder<EntityInformationsController>(builder: (controller) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 20),
//               child: SizedBox(
//                 height: 60,
//                 child: ListView.separated(
//                   separatorBuilder: (context, index) =>
//                       const SizedBox(width: 100),
//                   scrollDirection: Axis.horizontal,
//                   shrinkWrap: true,
//                   itemCount: controller.menus.length,
//                   itemBuilder: (context, i) {
//                     return Container(
//                       padding: EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                           color: controller.menus[i].isPressed == true
//                               ? Colors.blue
//                               : Colors.grey,
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Center(
//                         child: InkWell(
//                           onTap: () {
//                             controller.selectFrommenus(i);
//                           },
//                           child: AnimatedDefaultTextStyle(
//                             duration: const Duration(milliseconds: 300),
//                             curve: Curves.easeInOut,
//                             style: TextStyle(
//                               color: controller.menus[i].isPressed == false
//                                   ? Colors.grey.shade700
//                                   : Colors.white,
//                               fontSize: controller.menus[i].isPressed == true
//                                   ? 18
//                                   : 16, // Font size change
//                               fontWeight: controller.menus[i].isPressed == true
//                                   ? FontWeight.bold
//                                   : FontWeight.normal,
//                             ),
//                             child: Text(controller.menus[i].title),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             );
//           }),
//           GetBuilder<EntityInformationsController>(
//               builder: (controller) {
//             return controller.buildmenusContent(
//                 controller.selectedTap.value, controller);
//           }),
//         ],
//       ),