import 'package:datahubai/Controllers/Main%20screen%20controllers/job_card_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../../my_text_field.dart';

Container jobCardSection(BuildContext context, JobCardController controller) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 10,
          children: [
            myTextFormFieldWithBorder(
              width: 150,
              isEnabled: false,
              controller: controller.jobCardCounter.value,
              labelText: 'Job No.',
              onChanged: (_) {
                controller.isJobModified.value = true;
              },
            ),
            myTextFormFieldWithBorder(
              width: 150,
              suffixIcon: IconButton(
                focusNode: FocusNode(skipTraversal: true),
                onPressed: () async {
                  selectDateContext(context, controller.jobCardDate.value);
                  controller.isJobModified.value = true;
                },
                icon: const Icon(Icons.date_range),
              ),
              onFieldSubmitted: (_) async {
                normalizeDate(
                  controller.jobCardDate.value.text,
                  controller.jobCardDate.value,
                );
              },
              controller: controller.jobCardDate.value,
              labelText: 'Job Date',
              onChanged: (_) {
                controller.isJobModified.value = true;
              },
            ),
            Container(
              height: 35,
              width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  GetX<JobCardController>(
                    builder: (controller) {
                      return CupertinoCheckbox(
                        value: controller.isReturned.value,
                        onChanged: (value) {
                          controller.isReturned.value = value!;
                          controller.isJobModified.value = true;
                        },
                        fillColor: WidgetStateProperty.resolveWith<Color?>((
                          Set<WidgetState> states,
                        ) {
                          if (!states.contains(WidgetState.selected)) {
                            return Colors.grey.shade300;
                          }
                          return mainColor;
                        }),
                      );
                    },
                  ),

                  Text('Returned', style: textFieldFontStyle),
                ],
              ),
            ),
          ],
        ),
        Row(
          spacing: 10,
          children: [
            myTextFormFieldWithBorder(
              width: 150,
              isEnabled: false,
              controller: controller.invoiceCounter.value,
              labelText: 'Invoice No.',
              onChanged: (_) {
                controller.isJobModified.value = true;
              },
            ),
            myTextFormFieldWithBorder(
              width: 150,
              suffixIcon: IconButton(
                focusNode: FocusNode(skipTraversal: true),
                onPressed: () async {
                  selectDateContext(context, controller.invoiceDate.value);
                  controller.isJobModified.value = true;
                },
                icon: const Icon(Icons.date_range),
              ),
              onFieldSubmitted: (_) async {
                normalizeDate(
                  controller.invoiceDate.value.text,
                  controller.invoiceDate.value,
                );
              },
              controller: controller.invoiceDate.value,
              labelText: 'Invoice Date',
              onChanged: (_) {
                controller.isJobModified.value = true;
              },
            ),
          ],
        ),
        myTextFormFieldWithBorder(
          width: 470,
          controller: controller.lpoCounter.value,
          labelText: 'LPO No.',
          onChanged: (_) {
            controller.isJobModified.value = true;
          },
        ),
        myTextFormFieldWithBorder(
          width: 150,
          suffixIcon: IconButton(
            focusNode: FocusNode(skipTraversal: true),
            onPressed: () async {
              selectDateContext(context, controller.approvalDate.value);
              controller.isJobModified.value = true;
            },
            icon: const Icon(Icons.date_range),
          ),
          onFieldSubmitted: (_) async {
            normalizeDate(
              controller.approvalDate.value.text,
              controller.approvalDate.value,
            );
          },
          controller: controller.approvalDate.value,
          labelText: 'Approval Date',
          onChanged: (_) {
            controller.isJobModified.value = true;
          },
        ),

        Row(
          spacing: 10,
          children: [
            myTextFormFieldWithBorder(
              width: 150,
              suffixIcon: IconButton(
                focusNode: FocusNode(skipTraversal: true),
                onPressed: () async {
                  selectDateContext(context, controller.startDate.value);
                  controller.isJobModified.value = true;
                },
                icon: const Icon(Icons.date_range),
              ),
              onFieldSubmitted: (_) async {
                normalizeDate(
                  controller.startDate.value.text,
                  controller.startDate.value,
                );
              },
              controller: controller.startDate.value,
              labelText: 'Start Date',
              onChanged: (_) {
                controller.isJobModified.value = true;
              },
            ),
            myTextFormFieldWithBorder(
              width: 150,
              suffixIcon: IconButton(
                focusNode: FocusNode(skipTraversal: true),
                onPressed: () async {
                  selectDateContext(context, controller.finishDate.value);
                  controller.isJobModified.value = true;
                },
                icon: const Icon(Icons.date_range),
              ),
              onFieldSubmitted: (_) async {
                normalizeDate(
                  controller.finishDate.value.text,
                  controller.finishDate.value,
                );
              },
              controller: controller.finishDate.value,
              labelText: 'Finish Date',
              onChanged: (_) {
                controller.isJobModified.value = true;
              },
            ),
          ],
        ),
        Row(
          spacing: 10,
          children: [
            myTextFormFieldWithBorder(
              width: 150,
              suffixIcon: IconButton(
                focusNode: FocusNode(skipTraversal: true),
                onPressed: () async {
                  selectDateContext(context, controller.deliveryDate.value);
                  controller.isJobModified.value = true;
                },
                icon: const Icon(Icons.date_range),
              ),
              onFieldSubmitted: (_) async {
                normalizeDate(
                  controller.deliveryDate.value.text,
                  controller.deliveryDate.value,
                );
              },
              controller: controller.deliveryDate.value,
              labelText: 'Delivery Date',
              onChanged: (_) {
                controller.isJobModified.value = true;
              },
            ),
            // myTextFormFieldWithBorder(
            //   width: 150,
            //   controller: controller.deliveryTime.value,
            //   labelText: 'Delivery Time',
            //   hintText: 'Enter Delivery Time',
            //   onChanged: (_) {
            //     controller.isJobModified.value = true;
            //   },
            // ),
            myTextFormFieldWithBorder(
              width: 150,
              suffixIcon: IconButton(
                focusNode: FocusNode(skipTraversal: true),
                onPressed: () async {
                  selectDateContext(
                    context,
                    controller.jobCancelationDate.value,
                  );
                  controller.isJobModified.value = true;
                },
                icon: const Icon(Icons.date_range),
              ),
              onFieldSubmitted: (_) async {
                normalizeDate(
                  controller.jobCancelationDate.value.text,
                  controller.jobCancelationDate.value,
                );
              },
              controller: controller.jobCancelationDate.value,
              labelText: 'Cancelation Date',
              onChanged: (_) {
                controller.isJobModified.value = true;
              },
            ),
          ],
        ),
        Row(
          spacing: 10,
          children: [
            myTextFormFieldWithBorder(
              width: 150,
              isnumber: true,
              controller: controller.jobWarrentyDays.value,
              labelText: 'Warrenty Days',
              onChanged: (value) {
                if (controller.jobWarrentyDays.value.text.isEmpty) {
                  controller.jobWarrentyEndDate.value.clear();
                } else {
                  if (int.parse(value) < 3000) {
                    controller
                        .changejobWarrentyEndDateDependingOnWarrentyDays();
                  }
                }
                controller.isJobModified.value = true;
              },
            ),
            myTextFormFieldWithBorder(
              width: 150,
              isnumber: true,
              controller: controller.jobWarrentyKM.value,
              labelText: 'Warrenty KM',
              onChanged: (_) {
                controller.isJobModified.value = true;
              },
            ),
            myTextFormFieldWithBorder(
              width: 150,
              suffixIcon: IconButton(
                focusNode: FocusNode(skipTraversal: true),
                onPressed: () async {
                  selectDateContext(
                    context,
                    controller.jobWarrentyEndDate.value,
                  );
                  controller.isJobModified.value = true;
                },
                icon: const Icon(Icons.date_range),
              ),
              onFieldSubmitted: (_) async {
                normalizeDate(
                  controller.jobWarrentyEndDate.value.text,
                  controller.jobWarrentyEndDate.value,
                );
              },
              controller: controller.jobWarrentyEndDate.value,
              labelText: 'Warrenty End Date',
              onChanged: (_) {
                controller.isJobModified.value = true;
              },
            ),
          ],
        ),
        Row(
          spacing: 10,
          children: [
            myTextFormFieldWithBorder(
              width: 150,
              controller: controller.reference1.value,
              labelText: 'Reference 1',
              onChanged: (_) {
                controller.isJobModified.value = true;
              },
            ),
            myTextFormFieldWithBorder(
              width: 150,
              controller: controller.reference2.value,
              labelText: 'Reference 2',
              onChanged: (_) {
                controller.isJobModified.value = true;
              },
            ),
            // myTextFormFieldWithBorder(
            //   width: 150,
            //   isnumber: true,
            //   controller: controller.minTestKms.value,
            //   labelText: 'Required KMs For Test',
            //   onChanged: (_) {
            //     controller.isJobModified.value = true;
            //   },
            // ),
          ],
        ),
      ],
    ),
  );
}
