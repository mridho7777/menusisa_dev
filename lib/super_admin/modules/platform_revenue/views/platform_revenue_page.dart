import 'package:menusisa_dev/super_admin/shared/widgets/admin_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';
import '../../../providers/notifications_provider.dart';
import '../../../shared/widgets/charts/reusable_charts.dart';
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
  String _chartFilter = '7 Hari Ke Depan';
  final List<RevenueNotification> _notifications = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MenuProvider>().setRoute(AppRoutes.platformRevenue);
    });
  }

  void _addNotification(String title, String message, String type) {
    context.read<NotificationsProvider>().addNotification({
      'title': title,
      'message': message,
      'type': type,
      'entity_type': 'platform_revenue',
      'created_at': DateTime.now().toIso8601String(),
    });
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

  void _deleteRevenue(RevenueItem item) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Data Revenue"),
        content: const Text("Hapus data revenue dari sumber ini? Tindakan ini tidak dapat dibatalkan."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _addNotification("Revenue Dihapus", "Data revenue telah dihapus", "revenue_delete");
              AdminToast.show(context, 'Tindakan berhasil', type: AdminToastType.success);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
            child: const Text("Hapus"),
          ),
        ],
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
                      const _HeaderBar(),
                      const SizedBox(height: 14),
                      RevenueSectionCard(
                        child: RevenueMetricGrid(metrics: revenueMetrics),
                      ),
                      const SizedBox(height: 14),
                      
                      // Update dengan komponen grafik baru
                      DualChartWrapper(
                        leftChart: ReusableLineChart(
                          title: 'Grafik Pendapatan Platform',
                          filter: _chartFilter,
                          onFilterChanged: (value) {
                            setState(() => _chartFilter = value);
                          },
                          dataKey: 'Pendapatan',
                          supabaseTable: 'platform_revenue',
                          supabaseQuery: 'SELECT DATE(created_at) as date, SUM(amount) as total FROM platform_revenue WHERE created_at >= NOW() AND created_at <= NOW() + INTERVAL \'7 days\' GROUP BY date ORDER BY date',
                        ),
                        rightChart: const ReusableDonutChart(
                          title: 'Distribusi Revenue',
                          legendItems: [
                            DonutChartLegendItem(
                              color: Color(0xFF0F8D55),
                              title: 'Komisi Transaksi',
                              value: '0 (0%)',
                            ),
                            DonutChartLegendItem(
                              color: Color(0xFFF59E0B),
                              title: 'Biaya Langganan',
                              value: '0 (0%)',
                            ),
                            DonutChartLegendItem(
                              color: Color(0xFFEF4444),
                              title: 'Lainnya',
                              value: '0 (0%)',
                            ),
                          ],
                          supabaseTable: 'platform_revenue',
                          supabaseQuery: 'SELECT revenue_type, SUM(amount) as total FROM platform_revenue GROUP BY revenue_type',
                        ),
                      ),
                      const SizedBox(height: 14),
                      const RevenueSummaryCard(),
                      const SizedBox(height: 14),
                      const RevenueTopSourceCard(),
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
                              onDelete: _deleteRevenue,
                            ),
                          ],
                        ),
                      ),
                      if (_notifications.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        RevenueNotificationTray(
                          items: _notifications,
                          onClearAll: _clearNotifications,
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
  const _HeaderBar();

  @override
  Widget build(BuildContext context) {
    return const Column(
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
          'Pantau dan kelola pendapatan platform secara menyeluruh',
          style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }
}
