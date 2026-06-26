import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';
import '../models/platform_revenue_models.dart';
import '../widgets/revenue_metric_grid.dart';
import '../widgets/revenue_widgets.dart';

class PlatformRevenuePage extends StatefulWidget {
  const PlatformRevenuePage({super.key});

  @override
  State<PlatformRevenuePage> createState() => _PlatformRevenuePageState();
}

class _PlatformRevenuePageState extends State<PlatformRevenuePage>
    with TickerProviderStateMixin {
  late final AnimationController chartController;
  String _chartFilter = '30 Hari Terakhir';
  final List<RevenueNotification> _notifications = [];

  @override
  void initState() {
    super.initState();
    chartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MenuProvider>().setRoute(AppRoutes.platformRevenue);
    });
  }

  @override
  void dispose() {
    chartController.dispose();
    super.dispose();
  }

  void _notify(RevenueNotification notification) {
    setState(() {
      _notifications.insert(0, notification);
    });
  }

  void _clearNotifications() {
    setState(() {
      _notifications.clear();
    });
  }

  void _viewDetail(RevenueItem item) {
    _notify(
      RevenueNotification(
        title: 'Detail revenue dibuka!',
        subtitle: 'Rincian pendapatan .',
        time: 'Baru saja',
        color: 0xFF2563EB,
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
                      _HeaderBar(),
                      const SizedBox(height: 14),
                      RevenueSectionCard(
                        child: RevenueMetricGrid(metrics: revenueMetrics),
                      ),
                      const SizedBox(height: 14),
                      RevenueSectionCard(
                        child: RevenueChartCard(
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
                      const RevenueSummaryCard(),
                      const SizedBox(height: 14),
                      RevenueDistributionCard(progress: chartController.value),
                      const SizedBox(height: 14),
                      const RevenueTopSourceCard(),
                      const SizedBox(height: 14),
                      const RevenueInfoCard(),
                      const SizedBox(height: 14),
                      RevenueSectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Rincian Pendapatan',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            RevenueTableCard(
                              items: revenueItems,
                              onView: _viewDetail,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      if (_notifications.isNotEmpty)
                        RevenueNotificationTray(
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
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Platform Revenue',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Pantau dan kelola seluruh pendapatan platform dari berbagai sumber revenue termasuk komisi, biaya layanan, dan biaya transaksi.',
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {},
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
