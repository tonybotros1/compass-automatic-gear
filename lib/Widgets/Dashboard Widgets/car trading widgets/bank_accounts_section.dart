import 'dart:math' as math;

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../Models/car trading/accounts_summary_model.dart';
import '../../../Models/car trading/transfer_model.dart';
import '../../../consts.dart';
import 'transfer_item_dialog.dart';

const _pageBackground = Color(0xFFF7F9FC);
const _surface = Colors.white;
const _surfaceSoft = Color(0xFFF8FAFC);
const _line = Color(0xFFDCE6EE);
const _lineStrong = Color(0xFFC9D8E3);
const _text = Color(0xFF233247);
const _muted = Color(0xFF78879A);
const _primary = Color(0xFF006CA8);
const _primaryDark = Color(0xFF005988);
const _primarySoft = Color(0xFFE8F6FB);
const _green = Color(0xFF149447);
const _greenSoft = Color(0xFFEAF8EF);
const _red = Color(0xFFE34D59);
const _redSoft = Color(0xFFFFF0F2);
const _orange = Color(0xFFC98212);
const _orangeSoft = Color(0xFFFFF6DF);
const _shadow = Color(0x121A3753);

String? _nonEmpty(String? value) {
  final normalized = value?.trim();
  return normalized == null || normalized.isEmpty ? null : normalized;
}

bool _accountMatches({
  required String? selectedId,
  required String? candidateId,
}) {
  final selectedIdValue = _nonEmpty(selectedId)?.toLowerCase();
  final candidateIdValue = _nonEmpty(candidateId)?.toLowerCase();
  return selectedIdValue != null &&
      candidateIdValue != null &&
      selectedIdValue == candidateIdValue;
}

String? _resolveAccountId({
  required AccountSummaryModel account,
  required Iterable<TransferModel> transfers,
}) {
  final summaryId = _nonEmpty(account.accountId);
  if (summaryId != null) return summaryId;

  final accountName = _nonEmpty(account.accountName)?.toLowerCase();
  if (accountName == null) return null;

  for (final transfer in transfers) {
    if (_nonEmpty(transfer.fromAccountName)?.toLowerCase() == accountName) {
      final fromAccountId = _nonEmpty(transfer.fromAccount);
      if (fromAccountId != null) return fromAccountId;
    }
    if (_nonEmpty(transfer.toAccountName)?.toLowerCase() == accountName) {
      final toAccountId = _nonEmpty(transfer.toAccount);
      if (toAccountId != null) return toAccountId;
    }
  }
  return null;
}

class BankAccountsSection extends StatefulWidget {
  const BankAccountsSection({super.key});

  @override
  State<BankAccountsSection> createState() => _BankAccountsSectionState();
}

class _BankAccountsSectionState extends State<BankAccountsSection> {
  final TextEditingController _accountSearch = TextEditingController();
  final TextEditingController _transferSearch = TextEditingController();

  String? _selectedAccountId;
  String? _selectedAccountName;
  String _accountQuery = '';
  String _transferQuery = '';
  double? _leftPanelWidth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final controller = Get.find<CarTradingDashboardController>();
      Future.wait([
        controller.getCashOnHandOrBankBalance(),
        controller.getAllTransferes(),
      ]);
    });
  }

  @override
  void dispose() {
    _accountSearch.dispose();
    _transferSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _pageBackground,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 850;

            return GetX<CarTradingDashboardController>(
              builder: (controller) {
                final accounts = _visibleAccounts(controller.accountsSummary);
                final selectedAccount = _selectedAccount(controller);
                final transfers = _visibleTransfers(controller.alltransfers);
                final filteredTotal = transfers.fold<double>(
                  0,
                  (total, transfer) => total + (transfer.amount ?? 0),
                );

                final accountsPanel = _AccountsPanel(
                  accounts: accounts,
                  totalAccounts: controller.accountsSummary.length,
                  totalNet: controller.totalMoneyForAccounts.value,
                  transfers: controller.alltransfers,
                  selectedAccountId: _selectedAccountId,
                  searchController: _accountSearch,
                  onSearchChanged: (query) {
                    setState(() => _accountQuery = query);
                  },
                  onAccountSelected: (accountId, accountName) {
                    setState(() {
                      _selectedAccountId = _nonEmpty(accountId);
                      _selectedAccountName = _nonEmpty(accountName);
                    });
                  },
                );

                final transfersPanel = _TransfersPanel(
                  controller: controller,
                  transfers: transfers,
                  allTransfersCount: controller.alltransfers.length,
                  selectedAccountId: _selectedAccountId,
                  selectedAccountName:
                      selectedAccount?.accountDisplay?.trim().isNotEmpty == true
                      ? selectedAccount!.accountDisplay!.trim()
                      : selectedAccount?.accountName?.trim().isNotEmpty == true
                      ? selectedAccount!.accountName!.trim()
                      : _selectedAccountName ?? 'All Accounts',
                  total: filteredTotal,
                  searchController: _transferSearch,
                  onSearchChanged: (query) {
                    setState(() => _transferQuery = query);
                  },
                  onClearAccount: () {
                    setState(() {
                      _selectedAccountId = null;
                      _selectedAccountName = null;
                    });
                  },
                  onNewTransfer: () => _openNewTransfer(controller),
                  onEditTransfer: (transfer) =>
                      _openEditTransfer(controller, transfer),
                  onDeleteTransfer: (transfer) =>
                      _deleteTransfer(controller, transfer),
                );

                if (isCompact) {
                  final accountsHeight = math.min(
                    300.0,
                    math.max(205.0, constraints.maxHeight * .35),
                  );
                  return Column(
                    children: [
                      SizedBox(height: accountsHeight, child: accountsPanel),
                      const SizedBox(height: 10),
                      Expanded(child: transfersPanel),
                    ],
                  );
                }

                final maxLeftWidth = constraints.maxWidth * .30;
                final minLeftWidth = math.min(260.0, maxLeftWidth);
                final defaultLeftWidth = math.min(340.0, maxLeftWidth);
                final leftWidth = (_leftPanelWidth ?? defaultLeftWidth).clamp(
                  minLeftWidth,
                  maxLeftWidth,
                );

                return Row(
                  children: [
                    SizedBox(width: leftWidth, child: accountsPanel),
                    _PanelSplitter(
                      onDrag: (delta) {
                        setState(() {
                          _leftPanelWidth = (leftWidth + delta).clamp(
                            minLeftWidth,
                            maxLeftWidth,
                          );
                        });
                      },
                    ),
                    Expanded(child: transfersPanel),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  List<AccountSummaryModel> _visibleAccounts(
    List<AccountSummaryModel> accounts,
  ) {
    final query = _accountQuery.trim().toLowerCase();
    if (query.isEmpty) return accounts;

    return accounts
        .where((account) {
          return [
            account.accountDisplay,
            account.accountName,
            account.finalNet,
          ].join(' ').toLowerCase().contains(query);
        })
        .toList(growable: false);
  }

  AccountSummaryModel? _selectedAccount(
    CarTradingDashboardController controller,
  ) {
    if (_selectedAccountId == null) return null;
    for (final account in controller.accountsSummary) {
      if (_accountMatches(
        selectedId: _selectedAccountId,
        candidateId: _resolveAccountId(
          account: account,
          transfers: controller.alltransfers,
        ),
      )) {
        return account;
      }
    }
    return null;
  }

  List<TransferModel> _visibleTransfers(List<TransferModel> transfers) {
    final query = _transferQuery.trim().toLowerCase();
    final hasAccountFilter = _selectedAccountId != null;

    return transfers
        .where((transfer) {
          final matchesAccount =
              !hasAccountFilter ||
              _accountMatches(
                selectedId: _selectedAccountId,
                candidateId: transfer.fromAccount,
              ) ||
              _accountMatches(
                selectedId: _selectedAccountId,
                candidateId: transfer.toAccount,
              );
          if (!matchesAccount) return false;
          if (query.isEmpty) return true;

          return [
            transfer.date,
            transfer.fromAccountName,
            transfer.toAccountName,
            transfer.comment,
            transfer.amount,
            transfer.transferCounter,
          ].join(' ').toLowerCase().contains(query);
        })
        .toList(growable: false);
  }

  void _openNewTransfer(CarTradingDashboardController controller) {
    controller.transferComments.value.clear();
    controller.transferAmount.clear();
    controller.fromAccount.clear();
    controller.toAccount.clear();
    controller.fromAccountId.value = '';
    controller.toAccountId.value = '';
    controller.transferDate.value.text = textToDate(DateTime.now());
    transferItemDialog(
      controller: controller,
      onPressed: controller.addNewTransfer,
    );
  }

  void _openEditTransfer(
    CarTradingDashboardController controller,
    TransferModel transfer,
  ) {
    controller.transferComments.value.text = transfer.comment ?? '';
    controller.transferAmount.text = transfer.amount?.toString() ?? '0';
    controller.fromAccount.text = transfer.fromAccountName ?? '';
    controller.toAccount.text = transfer.toAccountName ?? '';
    controller.fromAccountId.value = transfer.fromAccount ?? '';
    controller.toAccountId.value = transfer.toAccount ?? '';
    controller.transferDate.value.text = textToDate(transfer.date);
    transferItemDialog(
      controller: controller,
      onPressed: () => controller.updateTransfer(transfer.id ?? ''),
    );
  }

  void _deleteTransfer(
    CarTradingDashboardController controller,
    TransferModel transfer,
  ) {
    final transferId = transfer.id ?? '';
    if (transferId.isEmpty) return;
    alertDialog(
      context: context,
      content: 'This transfer will be deleted permanently.',
      onPressed: () async {
        await controller.deleteTransfer(transferId);
      },
    );
  }
}

class _AccountsPanel extends StatelessWidget {
  const _AccountsPanel({
    required this.accounts,
    required this.totalAccounts,
    required this.totalNet,
    required this.transfers,
    required this.selectedAccountId,
    required this.searchController,
    required this.onSearchChanged,
    required this.onAccountSelected,
  });

  final List<AccountSummaryModel> accounts;
  final int totalAccounts;
  final double totalNet;
  final List<TransferModel> transfers;
  final String? selectedAccountId;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final void Function(String? accountId, String? accountName) onAccountSelected;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        children: [
          _PanelHeader(
            title: 'Accounts',
            caption: 'Click an account to filter transfers',
            trailing: _CountPill(
              text:
                  '$totalAccounts ${totalAccounts == 1 ? 'ACCOUNT' : 'ACCOUNTS'}',
            ),
          ),
          _Toolbar(
            child: _SearchField(
              controller: searchController,
              hintText: 'Search accounts',
              onChanged: onSearchChanged,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: accounts.length + 1,
              itemExtent: 76,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _AccountRow(
                    indexLabel: 'ALL',
                    name: 'All Accounts',
                    type: 'Show every transfer',
                    net: totalNet,
                    isSelected: selectedAccountId == null,
                    icon: Icons.all_inclusive_rounded,
                    onTap: () => onAccountSelected(null, null),
                  );
                }

                final account = accounts[index - 1];
                final accountId = _resolveAccountId(
                  account: account,
                  transfers: transfers,
                );
                final name = account.accountDisplay?.trim().isNotEmpty == true
                    ? account.accountDisplay!.trim()
                    : account.accountName?.trim() ?? '';
                final isCash =
                    name.toLowerCase().contains('cash') ||
                    name.toLowerCase().contains('petty');
                return _AccountRow(
                  indexLabel: index.toString().padLeft(2, '0'),
                  name: name.isEmpty ? 'Unnamed Account' : name,
                  type: isCash ? 'Cash account' : 'Bank account',
                  net: account.finalNet ?? 0,
                  isSelected: _accountMatches(
                    selectedId: selectedAccountId,
                    candidateId: accountId,
                  ),
                  icon: isCash
                      ? Icons.account_balance_wallet_outlined
                      : Icons.account_balance_outlined,
                  onTap: () =>
                      onAccountSelected(accountId, account.accountName),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TransfersPanel extends StatelessWidget {
  const _TransfersPanel({
    required this.controller,
    required this.transfers,
    required this.allTransfersCount,
    required this.selectedAccountId,
    required this.selectedAccountName,
    required this.total,
    required this.searchController,
    required this.onSearchChanged,
    required this.onClearAccount,
    required this.onNewTransfer,
    required this.onEditTransfer,
    required this.onDeleteTransfer,
  });

  final CarTradingDashboardController controller;
  final List<TransferModel> transfers;
  final int allTransfersCount;
  final String? selectedAccountId;
  final String selectedAccountName;
  final double total;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearAccount;
  final VoidCallback onNewTransfer;
  final ValueChanged<TransferModel> onEditTransfer;
  final ValueChanged<TransferModel> onDeleteTransfer;

  bool get _hasAccountFilter => selectedAccountId != null;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 650;
              final title = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Transfers',
                    style: TextStyle(
                      color: _text,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    !_hasAccountFilter
                        ? 'Showing transfers for all accounts'
                        : 'Showing transfers related to $selectedAccountName',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
              final actions = Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: _SelectedAccountPill(
                      text: selectedAccountName,
                      canClear: _hasAccountFilter,
                      onClear: onClearAccount,
                    ),
                  ),
                  const SizedBox(width: 9),
                  _NewTransferButton(onPressed: onNewTransfer),
                ],
              );

              return Container(
                constraints: const BoxConstraints(minHeight: 62),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: _line)),
                ),
                child: compact
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [title, const SizedBox(height: 10), actions],
                      )
                    : Row(
                        children: [
                          Expanded(child: title),
                          const SizedBox(width: 12),
                          actions,
                        ],
                      ),
              );
            },
          ),
          _Toolbar(
            child: Row(
              children: [
                Expanded(
                  child: _SearchField(
                    controller: searchController,
                    hintText: 'Search date, account, or comment',
                    onChanged: onSearchChanged,
                  ),
                ),
                const SizedBox(width: 10),
                _CountPill(
                  text:
                      '${transfers.length} ${transfers.length == 1 ? 'TRANSFER' : 'TRANSFERS'}',
                ),
              ],
            ),
          ),
          Expanded(child: _buildTableBody()),
          _TransfersFooter(
            visibleCount: transfers.length,
            allCount: allTransfersCount,
            total: total,
          ),
        ],
      ),
    );
  }

  Widget _buildTableBody() {
    if (controller.isTransfersLoading.isTrue &&
        controller.alltransfers.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: _primary, strokeWidth: 2.5),
      );
    }

    if (transfers.isEmpty) {
      return const _EmptyTransfers();
    }

    return DataTable2(
      minWidth: 940,
      headingRowHeight: 42,
      dataRowHeight: 56,
      horizontalMargin: 12,
      columnSpacing: 10,
      dividerThickness: .7,
      showCheckboxColumn: false,
      headingRowColor: const WidgetStatePropertyAll(Color(0xFFF4F7FA)),
      columns: const [
        DataColumn2(label: Text('ACTION'), fixedWidth: 72),
        DataColumn2(label: Text('DATE'), fixedWidth: 105),
        DataColumn2(label: Center(child: Text('FLOW')), fixedWidth: 66),
        DataColumn2(label: Text('FROM ACCOUNT'), size: ColumnSize.L),
        DataColumn2(label: Text('TO ACCOUNT'), size: ColumnSize.L),
        DataColumn2(label: Text('COMMENTS'), size: ColumnSize.L),
        DataColumn2(
          label: Align(alignment: Alignment.centerRight, child: Text('AMOUNT')),
          numeric: true,
          fixedWidth: 130,
        ),
      ],
      rows: transfers.map(_buildRow).toList(growable: false),
    );
  }

  DataRow _buildRow(TransferModel transfer) {
    final flow = _flowFor(transfer);
    final comment = transfer.comment?.trim() ?? '';
    final amountColor = !_hasAccountFilter
        ? _red
        : _matchesSelectedAccount(accountId: transfer.toAccount)
        ? _green
        : _red;

    return DataRow2(
      color: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return const Color(0xFFF8FBFD);
        }
        return Colors.transparent;
      }),
      cells: [
        DataCell(
          Row(
            children: [
              _RowActionButton(
                tooltip: 'Edit transfer',
                icon: Icons.edit_note_rounded,
                color: _primary,
                background: _primarySoft,
                onPressed: () => onEditTransfer(transfer),
              ),
              const SizedBox(width: 3),
              _RowActionButton(
                tooltip: 'Delete transfer',
                icon: Icons.delete_outline_rounded,
                color: _red,
                background: _redSoft,
                onPressed: () => onDeleteTransfer(transfer),
              ),
            ],
          ),
        ),
        DataCell(Text(textToDate(transfer.date))),
        DataCell(Center(child: _FlowBadge(flow: flow))),
        DataCell(_AccountCell(name: transfer.fromAccountName ?? '')),
        DataCell(_AccountCell(name: transfer.toAccountName ?? '')),
        DataCell(
          Text(
            comment.isEmpty ? '—' : comment,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: comment.isEmpty ? const Color(0xFF8996A7) : null,
              fontStyle: comment.isEmpty ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              priceFormat.format(transfer.amount ?? 0),
              style: TextStyle(color: amountColor, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }

  _TransferFlow _flowFor(TransferModel transfer) {
    if (!_hasAccountFilter) return _TransferFlow.move;
    if (_matchesSelectedAccount(accountId: transfer.toAccount)) {
      return _TransferFlow.incoming;
    }
    return _TransferFlow.outgoing;
  }

  bool _matchesSelectedAccount({String? accountId}) {
    return _accountMatches(
      selectedId: selectedAccountId,
      candidateId: accountId,
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: _surface,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: _shadow, blurRadius: 30, offset: Offset(0, 12)),
        ],
      ),
      child: child,
    );
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({
    required this.title,
    required this.caption,
    required this.trailing,
  });

  final String title;
  final String caption;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 62),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _line)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          trailing,
        ],
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFFBFDFF),
        border: Border(bottom: BorderSide(color: _line)),
      ),
      child: child,
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(
          color: _text,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF9AA7B7),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 18,
            color: Color(0xFF91A0B2),
          ),
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Clear search',
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                  icon: const Icon(Icons.close_rounded, size: 16),
                  color: _muted,
                  splashRadius: 16,
                ),
          contentPadding: const EdgeInsets.symmetric(vertical: 9),
          filled: true,
          fillColor: _surface,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: _lineStrong),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(color: Color(0xFF75B7D5)),
          ),
        ),
      ),
    );
  }
}

class _AccountRow extends StatelessWidget {
  const _AccountRow({
    required this.indexLabel,
    required this.name,
    required this.type,
    required this.net,
    required this.isSelected,
    required this.icon,
    required this.onTap,
  });

  final String indexLabel;
  final String name;
  final String type;
  final double net;
  final bool isSelected;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final netColor = net == 0
        ? _text
        : net > 0
        ? _green
        : _red;

    return Material(
      color: isSelected ? const Color(0xFFF2F8FB) : _surface,
      child: InkWell(
        onTap: onTap,
        hoverColor: const Color(0xFFF8FBFD),
        child: Stack(
          children: [
            if (isSelected)
              Positioned(
                left: 0,
                top: 8,
                bottom: 8,
                child: Container(
                  width: 3,
                  decoration: const BoxDecoration(
                    color: _primary,
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(4),
                    ),
                  ),
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: _line)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: isSelected ? _primarySoft : _surface,
                      border: Border.all(
                        color: isSelected ? const Color(0xFFB9DCE9) : _line,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, size: 18, color: _primary),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          indexLabel,
                          style: const TextStyle(
                            color: _muted,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF26364B),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          type,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _muted,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        indexLabel == 'ALL' ? 'TOTAL NET' : 'NET',
                        style: const TextStyle(
                          color: _muted,
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          letterSpacing: .45,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        priceFormat.format(net),
                        style: TextStyle(
                          color: netColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountCell extends StatelessWidget {
  const _AccountCell({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final isCash =
        name.toLowerCase().contains('cash') ||
        name.toLowerCase().contains('petty');
    return Row(
      children: [
        Container(
          width: 27,
          height: 27,
          decoration: BoxDecoration(
            color: _surface,
            border: Border.all(color: _line),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(
            isCash
                ? Icons.account_balance_wallet_outlined
                : Icons.account_balance_outlined,
            color: _primary,
            size: 13,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            name.isEmpty ? '—' : name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _CountPill extends StatelessWidget {
  const _CountPill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFECF8FA),
        border: Border.all(color: const Color(0xFFCCE6EE)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        maxLines: 1,
        style: const TextStyle(
          color: Color(0xFF176B7C),
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _SelectedAccountPill extends StatelessWidget {
  const _SelectedAccountPill({
    required this.text,
    required this.canClear,
    required this.onClear,
  });

  final String text;
  final bool canClear;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 280),
      padding: EdgeInsets.only(
        left: 10,
        right: canClear ? 5 : 10,
        top: 6,
        bottom: 6,
      ),
      decoration: BoxDecoration(
        color: _primarySoft,
        border: Border.all(color: const Color(0xFFC9E4EF)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.filter_alt_outlined, size: 13, color: _primaryDark),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: _primaryDark,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          if (canClear) ...[
            const SizedBox(width: 5),
            InkWell(
              onTap: onClear,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 19,
                height: 19,
                decoration: const BoxDecoration(
                  color: Color(0x1F005988),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 13,
                  color: _primaryDark,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NewTransferButton extends StatelessWidget {
  const _NewTransferButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add_rounded, size: 17),
        label: const Text('New Transfer'),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFF47AD59),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color(0xFF3BA652)),
          ),
        ),
      ),
    );
  }
}

class _RowActionButton extends StatelessWidget {
  const _RowActionButton({
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.background,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final Color color;
  final Color background;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(7),
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
      ),
    );
  }
}

enum _TransferFlow { incoming, outgoing, move }

class _FlowBadge extends StatelessWidget {
  const _FlowBadge({required this.flow});

  final _TransferFlow flow;

  @override
  Widget build(BuildContext context) {
    final (label, color, background) = switch (flow) {
      _TransferFlow.incoming => ('IN', _green, _greenSoft),
      _TransferFlow.outgoing => ('OUT', _red, _redSoft),
      _TransferFlow.move => ('MOVE', _orange, _orangeSoft),
    };

    return Container(
      constraints: const BoxConstraints(minWidth: 46),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: .35,
        ),
      ),
    );
  }
}

class _TransfersFooter extends StatelessWidget {
  const _TransfersFooter({
    required this.visibleCount,
    required this.allCount,
    required this.total,
  });

  final int visibleCount;
  final int allCount;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFFFBFDFF),
        border: Border(top: BorderSide(color: _line)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Showing $visibleCount of $allCount transfers',
              style: const TextStyle(
                color: _muted,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(
            'Total Amount:',
            style: TextStyle(
              color: Color(0xFF49586D),
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            priceFormat.format(total),
            style: const TextStyle(
              color: _primary,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTransfers extends StatelessWidget {
  const _EmptyTransfers();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: _surfaceSoft,
                border: Border.all(color: _line),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.swap_horiz_rounded,
                color: _muted,
                size: 25,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'No transfers found',
              style: TextStyle(
                color: _text,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Try another account or change your search text.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _PanelSplitter extends StatefulWidget {
  const _PanelSplitter({required this.onDrag});

  final ValueChanged<double> onDrag;

  @override
  State<_PanelSplitter> createState() => _PanelSplitterState();
}

class _PanelSplitterState extends State<_PanelSplitter> {
  bool _hovered = false;
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    final active = _hovered || _dragging;
    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragStart: (_) => setState(() => _dragging = true),
        onHorizontalDragUpdate: (details) => widget.onDrag(details.delta.dx),
        onHorizontalDragEnd: (_) => setState(() => _dragging = false),
        child: SizedBox(
          width: 16,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 4,
              margin: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: active ? _primary : const Color(0xFFD7E2EA),
                borderRadius: BorderRadius.circular(999),
                boxShadow: active
                    ? const [
                        BoxShadow(
                          color: Color(0x1A006CA8),
                          blurRadius: 0,
                          spreadRadius: 4,
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
