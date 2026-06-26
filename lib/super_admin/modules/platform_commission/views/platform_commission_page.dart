import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';
import '../models/platform_commission_models.dart';
import '../widgets/commission_dialogs_widgets.dart';
import '../widgets/commission_metric_grid.dart';
import '../widgets/commission_widgets.dart';

class PlatformCommissionPage extends StatefulWidget {
  const PlatformCommissionPage({super.key});

  @override
  State<PlatformCommissionPage> createState() => _PlatformCommissionPageState();
}

class _PlatformCommissionPageState extends State<PlatformCommissionPage>
    with TickerProviderStateMixin {
  late final AnimationController _chartController;
  String _filter = '30 Hari Terakhir';
  final List<CommissionNotification> _notifications = [];

  @override
  void initState() {
    super.initState();
    _chartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MenuProvider>().setRoute(AppRoutes.platformCommission);
    });
  }

  @override
  void dispose() {
    _chartController.dispose();
    super.dispose();
  }

  void _notify(CommissionNotification item) {
    setState(() => _notifications.insert(0, item));
  }

  void _openHistory() {
    showDialog<void>(context: context, builder: (_) => const CommissionHistoryDialog());
  }

  void _openChange() {
    showDialog<bool>(context: context, builder: (_) => const CommissionChangeDialog()).then((ok) {
      if (ok == true) {
        _notify(const CommissionNotification(
          title: 'Komisi platform berhasil diperbarui.',
          subtitle: 'Persentase komisi kini 3%.',
          time: 'Baru saja',
          color: 0xFF16A34A,
          icon: 'check',
        ));
        showDialog<void>(context: context, builder: (_) => const CommissionSuccessDialog(newPercentage: '3%'));
      }
    });
  }

  void _openDetail(CommissionTransactionItem item) {
    showDialog<void>(context: context, builder: (_) => CommissionDetailDialog(item: item));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuProvider>(
      builder: (context, menuProvider, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final padding = w < 900
                ? const EdgeInsets.fromLTRB(16, 16, 16, 18)
                : const EdgeInsets.fromLTRB(24, 18, 24, 20);
            final stackPanels = w < 1200 || !menuProvider.sidebarCollapsed;

            return SingleChildScrollView(
              padding: padding,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1680),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeaderBar(onHistory: _openHistory, onChangeCommission: _openChange),
                      const SizedBox(height: 14),
                      CommissionSectionCard(child: CommissionMetricGrid(metrics: commissionMetrics)),
                      const SizedBox(height: 14),
                      if (stackPanels) ...[
                        _PanelCard(title: 'Pengaturan Persentase Komisi Platform', height: 290, child: CommissionSettingsCard(onSaved: _openChange)),
                        const SizedBox(height: 14),
                        _PanelCard(title: 'Grafik Pendapatan Komisi Platform', height: 330, trailing: _FilterChip(value: _filter, onChanged: (v) => setState(() => _filter = v)), child: CommissionChartCard(progress: _chartController.value)),
                        const SizedBox(height: 14),
                        _PanelCard(title: 'Ringkasan Komisi', height: 290, child: const CommissionSummaryCard()),
                        const SizedBox(height: 14),
                        CommissionSectionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Daftar Transaksi Komisi Platform', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 12),
                              CommissionToolbar(onReset: () {}, onExport: () {}, onMerchantChanged: (_) {}, onPaymentChanged: (_) {}),
                              const SizedBox(height: 12),
                              CommissionTableCard(items: commissionTransactions, onView: _openDetail),
                              const SizedBox(height: 8),
                              const _PaginationBar(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        CommissionSectionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommissionTopMerchantCard(items: commissionTopMerchants),
                              const SizedBox(height: 14),
                              const _QuickInfoCard(),
                              const SizedBox(height: 14),
                              CommissionNotificationTray(items: _notifications, onClearAll: () => setState(_notifications.clear)),
                            ],
                          ),
                        ),
                      ] else ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: _PanelCard(title: 'Pengaturan Persentase Komisi Platform', height: 330, child: CommissionSettingsCard(onSaved: _openChange))),
                            const SizedBox(width: 14),
                            Expanded(flex: 6, child: _PanelCard(title: 'Grafik Pendapatan Komisi Platform', height: 330, trailing: _FilterChip(value: _filter, onChanged: (v) => setState(() => _filter = v)), child: CommissionChartCard(progress: _chartController.value))),
                            const SizedBox(width: 14),
                            Expanded(flex: 3, child: _PanelCard(title: 'Ringkasan Komisi', height: 330, child: const CommissionSummaryCard())),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 9, child: CommissionSectionCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Daftar Transaksi Komisi Platform', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)), const SizedBox(height: 12), CommissionToolbar(onReset: () {}, onExport: () {}, onMerchantChanged: (_) {}, onPaymentChanged: (_) {}), const SizedBox(height: 12), CommissionTableCard(items: commissionTransactions, onView: _openDetail), const SizedBox(height: 8), const _PaginationBar()]))),
                            const SizedBox(width: 14),
                            Expanded(flex: 3, child: Column(children: [CommissionTopMerchantCard(items: commissionTopMerchants), const SizedBox(height: 14), const _QuickInfoCard(), const SizedBox(height: 14), CommissionNotificationTray(items: _notifications, onClearAll: () => setState(_notifications.clear))])),
                          ],
                        ),
                      ],
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
  const _HeaderBar({required this.onHistory, required this.onChangeCommission});
  final VoidCallback onHistory;
  final VoidCallback onChangeCommission;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Platform Commission', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
              SizedBox(height: 4),
              Text('Beranda > Platform Commission', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              SizedBox(height: 4),
              Text('Kelola persentase komisi platform dan pantau pendapatan komisi dari setiap transaksi yang berhasil.', style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
            ],
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: onHistory,
          icon: const Icon(Icons.history_rounded, size: 18),
          label: const Text('Riwayat Perubahan Komisi'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F8D55),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}

class _PanelCard extends StatelessWidget {
  const _PanelCard({required this.title, required this.height, required this.child, this.trailing});
  final String title;
  final double height;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 18, offset: Offset(0, 6))],
      ),
      child: SizedBox(
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Expanded(child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700))), if (trailing != null) trailing!]),
            const SizedBox(height: 12),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        items: const ['30 Hari Terakhir', '7 Hari Terakhir', 'Hari Ini']
            .map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontSize: 12))))
            .toList(),
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
    );
  }
}

class _PaginationBar extends StatelessWidget {
  const _PaginationBar();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Menampilkan 1 - 5 dari 2456 data', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
        Row(
          children: [
            const Text('Rows Per Page'),
            const SizedBox(width: 8),
            DropdownButton<String>(value: '5', items: const [DropdownMenuItem(value: '5', child: Text('5')), DropdownMenuItem(value: '10', child: Text('10')), DropdownMenuItem(value: '20', child: Text('20'))], onChanged: (_) {}),
          ],
        ),
      ],
    );
  }
}

class _QuickInfoCard extends StatelessWidget {
  const _QuickInfoCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Informasi Cepat', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          SizedBox(height: 12),
          _InfoRow(label: 'Persentase komisi saat ini', value: '3%'),
          _InfoRow(label: 'Berlaku untuk transaksi baru', value: 'Ya'),
          _InfoRow(label: 'Terakhir diubah oleh', value: 'Super Admin'),
          _InfoRow(label: 'Terakhir diubah pada', value: '15 Mei 2025\n14:30 WIB'),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 11.5, color: Color(0xFF6B7280)))),
          const SizedBox(width: 12),
          Text(value, textAlign: TextAlign.end, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
