import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/balances_controller.dart';
import '../../../consts.dart';
import 'balance_details.dart';
import 'based_element_section.dart';

Widget addNewBalanceOrEdit({
  required BalancesController controller,
  required BoxConstraints constraints,
  required BuildContext context,
}) {
  return Column(
    children: [
      labelContainer(lable: Text('Balance Details', style: fontStyle1)),
      balanceDetails(context, controller),
      const SizedBox(height: 10),
      Expanded(
        child: DefaultTabController(
          length: controller.contactsTabs.length,
          child: Column(
            children: [
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: secColor,
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
                  unselectedLabelColor: Colors.white,
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  indicatorColor: Colors.yellow,
                  labelColor: Colors.yellow,
                  splashBorderRadius: BorderRadius.circular(5),
                  dividerColor: Colors.transparent,

                  tabs: controller.contactsTabs,
                ),
              ),

              Expanded(
                child: TabBarView(
                  children: [basedElementsSection(constraints)],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
