import 'package:data_table_2/data_table_2.dart';
import 'package:datahubai/Widgets/text_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../Models/car trading/accounts_summary_model.dart';
import '../../../consts.dart';
import 'transfers_dialog.dart';

Widget tableOfAccountsDetails() {
  return GetX<CarTradingDashboardController>(
    builder: (controller) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: DataTable2(
            headingRowHeight: 35,
            showCheckboxColumn: false,
            dataRowHeight: 40,
            horizontalMargin: horizontalMarginForTable,
            columnSpacing: 5,
            dividerThickness: .3,
            lmRatio: 3,
            headingRowColor: WidgetStatePropertyAll(coolColor),
            columns: [
              DataColumn2(
                label: Row(
                  spacing: 30,
                  children: [
                    const Text('ACCOUNT NAME'),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        color: Colors.blue.shade400,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ClickableHoverText(
                        text: 'TRANSFERS',
                        color1: Colors.yellow,
                        color2: Colors.white,
                        onTap: () {
                          controller.searchForTransfers.value.clear();
                          controller.filterTransfers();
                          controller.alltransfers.clear();
                          controller.getAllTransferes();
                          transfersDialog(
                            controller: controller,
                            screenName: 'Transfers',
                          );
                        },
                      ),
                    ),
                  ],
                ),
                size: ColumnSize.L,
              ),
              const DataColumn2(
                numeric: true,
                label: Text('NET'),
                size: ColumnSize.M,
              ),
            ],
            rows: controller.accountsSummary.map((data) {
              return dataRowForTheTable(data, controller);
            }).toList(),
          ),
        ),
      );
    },
  );
}

DataRow dataRowForTheTable(
  AccountSummaryModel data,
  CarTradingDashboardController controller,
) {
  return DataRow(
    cells: [
      DataCell(
        textForDataRowInTable(
          text: data.accountDisplay ?? '',
          maxWidth: null,
          formatDouble: false,
        ),
      ),

      DataCell(
        textForDataRowInTable(
          text: (data.finalNet ?? '0').toString(),
          formatDouble: true,
          color: data.finalNet == 0 || data.finalNet == null
              ? Colors.grey.shade400
              : data.finalNet! < 0
              ? Colors.redAccent
              : Colors.green.shade300,
          isBold: true,
        ),
      ),
    ],
  );
}
