import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/legislation_controller.dart';
import '../../../consts.dart';
import '../../my_text_field.dart';

Container legislationInformation(LegislationController controller) {
  return Container(
    // height: 245,
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            myTextFormFieldWithBorder(
              labelText: 'Name',
              controller: controller.name,
              width: 310,
            ),
            GetX<LegislationController>(
              builder: (controller) {
                return Row(
                  spacing: 20,
                  children: [
                    const Text('Weekend'),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: controller.weekDays.map((day) {
                        final isSelected = controller.selectedDays.contains(
                          day,
                        );

                        return InkWell(
                          onTap: () {
                            if (isSelected) {
                              controller.selectedDays.remove(day);
                            } else {
                              controller.selectedDays.add(day);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? mainColor : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected ? Colors.white : Colors.grey,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  size: 18,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  day,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ],
    ),
  );
}
