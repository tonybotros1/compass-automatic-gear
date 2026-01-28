import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../consts.dart';
import 'capital_dialog.dart';
import 'car_trade_dialog.dart';
import 'outstanding_capitals_dialog2.dart';

Widget tableOfSummaryDetails({required BuildContext context}) {
  return GetX<CarTradingDashboardController>(
    builder: (controller) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: DataTable(
            headingTextStyle: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            dataTextStyle: TextStyle(
              color: Colors.grey.shade800,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            headingRowHeight: 35,
            showCheckboxColumn: false,
            horizontalMargin: horizontalMarginForTable,
            dataRowMaxHeight: 40,
            dataRowMinHeight: 30,
            columnSpacing: 5,
            dividerThickness: .3,
            headingRowColor: WidgetStatePropertyAll(coolColor),
            columns: const [
              DataColumn(
                label: Text('CATEGORY'),
                columnWidth: IntrinsicColumnWidth(flex: 3),
              ),
              DataColumn(
                numeric: true,
                label: Text('COUNT'),
                columnWidth: IntrinsicColumnWidth(flex: 1),
              ),
              DataColumn(
                numeric: true,
                label: Text('PAID'),
                columnWidth: IntrinsicColumnWidth(flex: 1),
              ),
              DataColumn(
                numeric: true,
                label: Text('RECEIVED'),
                columnWidth: IntrinsicColumnWidth(flex: 1),
              ),
              DataColumn(
                numeric: true,
                label: Text('NET'),
                columnWidth: IntrinsicColumnWidth(flex: 1),
              ),
              DataColumn(
                label: Text('ACTION'),
                numeric: true,
                columnWidth: IntrinsicColumnWidth(flex: .4),
              ),
            ],
            rows: controller.summaryData.map((data) {
              return dataRowForTheTable(data, controller);
            }).toList(),
          ),
        ),
      );
    },
  );
}

DataRow dataRowForTheTable(
  Map<String, dynamic> data,
  CarTradingDashboardController controller,
) {
  return DataRow(
    cells: [
      DataCell(
        textForDataRowInTable(text: data['category'], formatDouble: false),
      ),

      DataCell(
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey.shade100,
          ),
          child: textForDataRowInTable(
            text: (data['count'] ?? '0').toString(),
            formatDouble: false,
            color:
                data['count'] == 0 ||
                    data['count'] == '' ||
                    data['count'] == null
                ? Colors.grey.shade400
                : Colors.blueGrey,
            isBold: true,
          ),
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: (data['paid'] ?? '0').toString(),
          formatDouble: true,
          color: data['paid'] == 0 || data['paid'] == '' || data['paid'] == null
              ? Colors.grey.shade400
              : Colors.red,
          isBold: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: (data['received'] ?? '0').toString(),
          formatDouble: true,
          color:
              data['received'] == 0 ||
                  data['received'] == '' ||
                  data['received'] == null
              ? Colors.grey.shade400
              : Colors.green,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: (data['net'] ?? '0').toString(),
          formatDouble: true,
          color: data['net'] == 0 || data['net'] == '' || data['net'] == null
              ? Colors.grey.shade400
              : Colors.teal,
        ),
      ),
      DataCell(
        InkWell(
          onTap: () {
            if (data['category'].contains('Cars')) {
              controller.clearValues();
              carTradesDialog(
                tradeID: '',
                controller: controller,
                canEdit: true,
                onPressed: controller.addingNewValue.value
                    ? null
                    : () async {
                        controller.addNewTrade();
                      },
              );
            } else if (data['category'].contains('Capital Docs')) {
              controller.searchForCapitalsOrOutstandingOrGeneralExpenses.value
                  .clear();
              controller.allCapitals.clear();
              controller.getAllCapitalsOROutstanding('capitals');
              capitalOrOutstandingOrGeneralExpensesDialog(
                isGeneralExpenses: false,
                search:
                    controller.searchForCapitalsOrOutstandingOrGeneralExpenses,
                collection: 'capitals',
                filteredMap: controller.filteredCapitals,
                map: controller.allCapitals,
                screenName: 'Capitals',
                controller: controller,
                canEdit: true,
              );
            } else if (data['category'].contains('Outstanding')) {
              controller.searchForCapitalsOrOutstandingOrGeneralExpenses.value
                  .clear();
              controller.allOutstanding.clear();
              controller.getAllCapitalsOROutstanding('outstanding');
              capitalOrOutstanding(
                search:
                    controller.searchForCapitalsOrOutstandingOrGeneralExpenses,
                collection: 'outstanding',
                filteredMap: controller.filteredOutstanding,
                map: controller.allOutstanding,
                screenName: 'Outstanding',
                controller: controller,
                canEdit: true,
              );
            } else {
              controller.searchForCapitalsOrOutstandingOrGeneralExpenses.value
                  .clear();
              controller.allGeneralExpenses.clear();
              controller.getAllGeneralExpenses();
              capitalOrOutstandingOrGeneralExpensesDialog(
                isGeneralExpenses: true,
                search:
                    controller.searchForCapitalsOrOutstandingOrGeneralExpenses,
                collection: 'general_expenses',
                filteredMap: controller.filteredGeneralExpenses,
                map: controller.allGeneralExpenses,
                screenName: 'General Expenses',
                controller: controller,
                canEdit: true,
              );
            }
          },
          child: Icon(
            !data['category'].contains('Cars') ? Icons.more_horiz : Icons.add,
            size: 25,
            color: Colors.grey,
          ),
        ),
      ),
    ],
  );
}
