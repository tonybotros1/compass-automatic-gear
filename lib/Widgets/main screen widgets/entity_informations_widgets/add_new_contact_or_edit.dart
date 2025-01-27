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
  return GetBuilder<EntityInformationsController>(builder: (controller) {
    return Container(
      width: 220,
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
          itemCount: controller.visibleMenus.length,
          itemBuilder: (context, i) {
            return InkWell(
              onTap: () {
                controller.selectFromLeftMenu(i);
              },
              child: Row(
                children: [
                  Text(
                    '${i + 1}',
                    style: TextStyle(
                      color: controller.visibleMenus[i].isPressed == false
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
                      height: controller.visibleMenus[i].isPressed == true
                          ? 100
                          : 70,
                      color: controller.visibleMenus[i].isPressed == false
                          ? Colors.white54
                          : Color(0xff2973B2),
                    ),
                  ),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    style: TextStyle(
                      color: controller.visibleMenus[i].isPressed == false
                          ? Colors.grey.shade700
                          : Color(0xff2973B2),
                      fontSize: controller.visibleMenus[i].isPressed == true
                          ? 18
                          : 16, // Font size change
                      fontWeight: controller.visibleMenus[i].isPressed == true
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    child: FittedBox(
                        child: Text(controller.visibleMenus[i].title)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  });
}
