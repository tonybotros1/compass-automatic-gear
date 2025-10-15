import 'package:datahubai/Controllers/Main%20screen%20controllers/job_card_controller.dart';
import 'package:flutter/material.dart';
import '../../../consts.dart';
import '../../my_text_field.dart';

Container jobCardSection(BuildContext context, JobCardController controller) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    child: Column(
      spacing: 10,
      children: [
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: myTextFormFieldWithBorder(
                isEnabled: false,
                controller: controller.jobCardCounter.value,
                labelText: 'Job No.',
                onChanged: (_) {
                  controller.isJobModified.value = true;
                },
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                isEnabled: false,
                controller: controller.invoiceCounter.value,
                labelText: 'Invoice No.',
                onChanged: (_) {
                  controller.isJobModified.value = true;
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: myTextFormFieldWithBorder(
                controller: controller.lpoCounter.value,
                labelText: 'LPO No.',
                onChanged: (_) {
                  controller.isJobModified.value = true;
                },
              ),
            ),
          ],
        ),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: myTextFormFieldWithBorder(
                suffixIcon: dateRange(
                  context: context,
                  date: controller.jobCardDate.value,
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
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                suffixIcon: dateRange(
                  context: context,
                  date: controller.invoiceDate.value,
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
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                suffixIcon: dateRange(
                  context: context,
                  date: controller.approvalDate.value,
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
            ),
          ],
        ),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: myTextFormFieldWithBorder(
                suffixIcon: dateRange(
                  context: context,
                  date: controller.startDate.value,
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
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                suffixIcon: dateRange(
                  context: context,
                  date: controller.finishDate.value,
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
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                suffixIcon: dateRange(
                  context: context,
                  date: controller.deliveryDate.value,
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
            ),
          ],
        ),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: myTextFormFieldWithBorder(
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
                  ),
                  Expanded(
                    child: myTextFormFieldWithBorder(
                      isnumber: true,
                      controller: controller.jobWarrentyKM.value,
                      labelText: 'Warrenty KM',
                      onChanged: (_) {
                        controller.isJobModified.value = true;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                suffixIcon: dateRange(
                  context: context,
                  date: controller.jobWarrentyEndDate.value,
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
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                suffixIcon: dateRange(
                  context: context,
                  date: controller.jobCancelationDate.value,
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
            ),
          ],
        ),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: myTextFormFieldWithBorder(
                      controller: controller.reference1.value,
                      labelText: 'Reference 1',
                      onChanged: (_) {
                        controller.isJobModified.value = true;
                      },
                    ),
                  ),
                  Expanded(
                    child: myTextFormFieldWithBorder(
                      controller: controller.reference2.value,
                      labelText: 'Reference 2',
                      onChanged: (_) {
                        controller.isJobModified.value = true;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                controller: controller.deliveryTime.value,
                labelText: 'Delivery Time',
                hintText: 'Enter Delivery Time',
                onChanged: (_) {
                  controller.isJobModified.value = true;
                },
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                isnumber: true,
                controller: controller.minTestKms.value,
                labelText: 'Required KMs For Test',
                onChanged: (_) {
                  controller.isJobModified.value = true;
                },
              ),
            ),
          ],
        ),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: myTextFormFieldWithBorder(
                labelText: 'Job Notes',
                controller: controller.jobNotes,
                maxLines: 7,
                onChanged: (_) {
                  controller.isJobModified.value = true;
                },
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                labelText: 'Delivery Notes',
                controller: controller.deliveryNotes,
                maxLines: 7,
                onChanged: (_) {
                  controller.isJobModified.value = true;
                },
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
