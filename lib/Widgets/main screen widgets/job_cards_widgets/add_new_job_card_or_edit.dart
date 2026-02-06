import 'package:datahubai/Controllers/Main%20screen%20controllers/job_card_controller.dart';
import 'package:datahubai/Widgets/main%20screen%20widgets/job_cards_widgets/invoice_items_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../../my_text_field.dart';
import '../../text_button.dart';
import 'car_details_section.dart';
import 'customer_details_section.dart';
import 'items_summary_table.dart';
import 'job_card_section.dart';
import 'time_sheets_summary_table.dart';

Widget addNewJobCardOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required JobCardController controller,
  bool? canEdit,
  required jobId,
  required isJob,
}) {
  return SingleChildScrollView(
    controller: controller.scrollController,
    child: Column(
      children: [
        Row(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isJob == true
                ? Expanded(
                    child: Column(
                      children: [
                        labelContainer(
                          lable: Text('Car Details', style: fontStyle1),
                        ),
                        carDetailsSection(controller, constraints),
                      ],
                    ),
                  )
                : const SizedBox(),
            Expanded(
              child: Column(
                children: [
                  labelContainer(
                    lable: Text('Customer Details', style: fontStyle1),
                  ),
                  customerDetailsSection(controller, constraints),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  labelContainer(
                    lable: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isJob == true ? 'Job Details' : 'Sales Details',
                          style: fontStyle1,
                        ),
                        GetX<JobCardController>(
                          builder: (controller) {
                            return controller.quotationCounter.value.isNotEmpty
                                ? ClickableHoverText(
                                    color2:
                                        controller
                                            .openingQuotationCardScreen
                                            .isFalse
                                        ? Colors.black
                                        : Colors.yellow,
                                    text:
                                        controller
                                            .openingQuotationCardScreen
                                            .isFalse
                                        ? controller.quotationCounter.value
                                        : 'Loading...',
                                    onTap:
                                        controller
                                            .openingQuotationCardScreen
                                            .isFalse
                                        ? () async {
                                            controller
                                                .openQuotationCardScreenByNumber(
                                                  controller.quotationId.value,
                                                );
                                          }
                                        : null,
                                  )
                                : const SizedBox();
                          },
                        ),
                      ],
                    ),
                  ),
                  jobCardSection(context, controller, isJob),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),
        DefaultTabController(
          length: controller.jobCardTabs.length,
          child: Column(
            // spacing: 10,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: BoxBorder.fromLTRB(
                    left: const BorderSide(color: Colors.grey),
                    right: const BorderSide(color: Colors.grey),
                    top: const BorderSide(color: Colors.grey),
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
                child: TabBar(
                  unselectedLabelColor: Colors.grey,
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  indicatorColor: mainColor,
                  labelColor: mainColor,
                  splashBorderRadius: BorderRadius.circular(5),
                  dividerColor: Colors.transparent,

                  tabs: controller.jobCardTabs,
                ),
              ),

              SizedBox(
                height: 300,
                child: TabBarView(
                  children: [
                    // TAB 1
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Row(
                            children: [
                              newinvoiceItemsButton(
                                context,
                                constraints,
                                controller,
                                jobId,
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                        // labelContainer(
                        //   lable: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text('Invoice Items', style: fontStyle1),
                        //       newinvoiceItemsButton(
                        //         context,
                        //         constraints,
                        //         controller,
                        //         jobId,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Expanded(
                          child: invoiceItemsSection(
                            constraints: constraints,
                            context: context,
                            jobId: jobId,
                          ),
                        ),
                      ],
                    ),

                    myTextFormFieldWithBorder(
                      width: double.infinity,
                      controller: controller.jobNotes,
                      hintText: 'Type here...',
                      maxLines: 10,
                      onChanged: (_) {
                        controller.isJobModified.value = true;
                      },
                    ),
                    myTextFormFieldWithBorder(
                      width: double.infinity,
                      controller: controller.deliveryNotes,
                      hintText: 'Type here...',
                      maxLines: 10,
                      onChanged: (_) {
                        controller.isJobModified.value = true;
                      },
                    ),
                    itemsSummartTableSection(
                      constraints: constraints,
                      context: context,
                      jobId: jobId,
                    ),
                    timeSheetsSummaryTable(
                      constraints: constraints,
                      context: context,
                      jobId: jobId,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
