import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';
import '../models/merchant_revenue_models.dart';
import '../widgets/merchant_revenue_metric_grid.dart';
import '../widgets/merchant_revenue_widgets.dart';

class MerchantRevenuePage extends StatefulWidget {
  const MerchantRevenuePage({super.key});

  @override
  State<MerchantRevenuePage> createState() => _MerchantRevenuePageState();
}

class _MerchantRevenuePageState extends State<MerchantRevenuePage>
    with TickerProviderStateMixin {
  late final AnimationController chartController;
  String _chartFilter = '30 Hari Terakhir';
  final List<MerchantRevenueNotification> _notifications = [];

  @override
  void initState() {
    super.initState();
    chartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MenuProvider>().setRoute(AppRoutes.merchantRevenue);
    });
  }

  @override
  void dispose() {
    chartController.dispose();
    super.dispose();
  }

  void _notify(MerchantRevenueNotification notification) {
    setState(() {
      _notifications.insert(0, notification);
    });
  }

  void _clearNotifications() {
    setState(() {
      _notifications.clear();
    });
  }

  void _viewItem(MerchantRevenueItem item) {
    _notify(
      MerchantRevenueNotification(
        title: 'Detail pendapatan dibuka!',
        subtitle: ' - ',
        time: 'Baru saja',
        color: 0xFF2563EB,
        icon: 'check',
      ),
    );
  }

  void _exportLaporan() {
    _notify(
      const MerchantRevenueNotification(
        title: 'Laporan merchant diexport!',
        subtitle: 'File laporan berhasil dibuat.',
        time: 'Baru saja',
        color: 0xFF16A34A,
        icon: 'check',
      ),
    );
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
                      _HeaderBar(onExport: _exportLaporan),
                      const SizedBox(height: 14),
                      MerchantRevenueSectionCard(
                        child: MerchantRevenueMetricGrid(
                          metrics: merchantRevenueMetrics,
                        ),
                      ),
                      const SizedBox(height: 14),
                      MerchantRevenueSectionCard(
                        child: MerchantRevenueChartCard(
                          progress: chartController.value,
                          filter: _chartFilter,
                          onFilterChanged: (value) {
                            setState(() {
                              _chartFilter = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 14),
                      MerchantRevenueSectionCard(
                        child: MerchantRevenueDistributionCard(
                          progress: chartController.value,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const MerchantRevenueSummaryCard(),
                      const SizedBox(height: 14),
                      const MerchantRevenueTopCard(),
                      const SizedBox(height: 14),
                      const MerchantRevenueInfoCard(),
                      const SizedBox(height: 14),
                      MerchantRevenueSectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Daftar Pendapatan Merchant',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            MerchantRevenueTableCard(
                              items: merchantRevenueItems,
                              onView: _viewItem,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      if (_notifications.isNotEmpty)
                        MerchantRevenueNotificationTray(
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
  const _HeaderBar({required this.onExport});
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Merchant Revenue',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Pantau pendapatan, komisi, dan performa masing-masing merchant secara detail.',
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: onExport,
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
