import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';
import '../models/transaction_management_models.dart';
import '../widgets/transaction_dialogs_widgets.dart';
import '../widgets/transaction_management_widgets.dart';
import '../widgets/transaction_metric_grid.dart';

class TransactionManagementPage extends StatefulWidget {
  const TransactionManagementPage({super.key});

  @override
  State<TransactionManagementPage> createState() =>
      _TransactionManagementPageState();
}

class _TransactionManagementPageState extends State<TransactionManagementPage>
    with TickerProviderStateMixin {
  late final AnimationController chartController;
  String _chartFilter = '30 Hari Terakhir';
  final List<TransactionNotification> _notifications = [];

  @override
  void initState() {
    super.initState();
    chartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MenuProvider>().setRoute(AppRoutes.transactions);
    });
  }

  @override
  void dispose() {
    chartController.dispose();
    super.dispose();
  }

  void _notify(TransactionNotification notification) {
    setState(() {
      _notifications.insert(0, notification);
    });
  }

  void _clearNotifications() {
    setState(() {
      _notifications.clear();
    });
  }

  void _viewTransaction(TransactionItem transaction) {
    showDialog<void>(
      context: context,
      builder: (_) => TransactionDetailDialog(transaction: transaction),
    );
  }

  void _updateStatus(TransactionItem transaction) {
    showDialog<void>(
      context: context,
      builder: (_) => TransactionUpdateStatusDialog(transaction: transaction),
    ).then((_) {
      _notify(
        TransactionNotification(
          title: 'Status transaksi diupdate!',
          subtitle: ' telah diperbarui.',
          time: 'Baru saja',
          color: 0xFF16A34A,
          icon: 'check',
        ),
      );
    });
  }

  void _refundTransaction(TransactionItem transaction) {
    showDialog<void>(
      context: context,
      builder: (_) => TransactionConfirmDialog(
        title: 'Proses Refund',
        message: 'Anda yakin ingin memproses refund untuk transaksi ini?',
        primaryLabel: 'Proses Refund',
        primaryColor: const Color(0xFFF59E0B),
      ),
    ).then((_) {
      _notify(
        TransactionNotification(
          title: 'Refund diproses!',
          subtitle: ' sedang diproses refund.',
          time: 'Baru saja',
          color: 0xFFF59E0B,
          icon: 'warning',
        ),
      );
    });
  }

  void _printInvoice(TransactionItem transaction) {
    _notify(
      TransactionNotification(
        title: 'Invoice dicetak!',
        subtitle: 'Invoice  siap dicetak.',
        time: 'Baru saja',
        color: 0xFF16A34A,
        icon: 'check',
      ),
    );
  }

  void _handleActionTap(String action) {
    switch (action) {
      case 'Export Laporan':
        _notify(
          const TransactionNotification(
            title: 'Laporan transaksi diexport!',
            subtitle: 'File laporan telah tersedia.',
            time: 'Baru saja',
            color: 0xFF16A34A,
            icon: 'check',
          ),
        );
        break;
      case 'Refresh':
        _notify(
          const TransactionNotification(
            title: 'Data transaksi direfresh!',
            subtitle: 'Semua data telah diperbarui.',
            time: 'Baru saja',
            color: 0xFF16A34A,
            icon: 'check',
          ),
        );
        break;
      case 'Filter':
        _notify(
          const TransactionNotification(
            title: 'Filter diterapkan!',
            subtitle: 'Hasil pencarian telah difilter.',
            time: 'Baru saja',
            color: 0xFF2563EB,
            icon: 'info',
          ),
        );
        break;
      case 'Cetak Invoice':
        _notify(
          const TransactionNotification(
            title: 'Invoice siap dicetak!',
            subtitle: 'Semua invoice telah dibuat.',
            time: 'Baru saja',
            color: 0xFF16A34A,
            icon: 'check',
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuProvider>(
      builder: (context, menuProvider, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth = constraints.maxWidth;
            final padding = contentWidth < 900
                ? const EdgeInsets.fromLTRB(16, 16, 16, 18)
                : const EdgeInsets.fromLTRB(24, 18, 24, 20);

            return SingleChildScrollView(
              padding: padding,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1680),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeaderBar(onActionTap: _handleActionTap),
                      const SizedBox(height: 14),
                      TransactionSectionCard(
                        child: TransactionMetricGrid(
                          metrics: transactionMetrics,
                        ),
                      ),
                      const SizedBox(height: 14),
                      TransactionSectionCard(
                        child: TransactionCombinedChartCard(
                          progress: chartController.value,
                          filter: _chartFilter,
                          sidebarCollapsed: menuProvider.sidebarCollapsed,
                          onFilterChanged: (value) {
                            setState(() {
                              _chartFilter = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 14),
                      TransactionSectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Top Merchant (Berdasarkan Transaksi)',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TransactionTopMerchantList(
                              items: topMerchantTransactions,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      TransactionSectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Daftar Transaksi',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 200,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Cari transaksi...',
                                      prefixIcon: const Icon(
                                        Icons.search_rounded,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TransactionTableCard(
                              items: transactionItems,
                              onView: _viewTransaction,
                              onUpdateStatus: _updateStatus,
                              onRefund: _refundTransaction,
                              onPrint: _printInvoice,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      TransactionSectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Aksi Cepat',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TransactionActionGrid(
                              actions: const [
                                'Export Laporan',
                                'Refresh',
                                'Filter',
                                'Cetak Invoice',
                                'Refund',
                                'Selesaikan',
                              ],
                              onActionTap: _handleActionTap,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      if (_notifications.isNotEmpty)
                        TransactionNotificationTray(
                          items: _notifications,
                          onClearAll: _clearNotifications,
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _HeaderBar extends StatelessWidget {
  const _HeaderBar({required this.onActionTap});

  final ValueChanged<String> onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Transaction Management',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Kelola semua transaksi yang terjadi pada platform. Pantau status, detail pembayaran, dan selesaikan pesanan.',
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () => onActionTap('Export Laporan'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F8D55),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Export Laporan'),
        ),
      ],
    );
  }
}
