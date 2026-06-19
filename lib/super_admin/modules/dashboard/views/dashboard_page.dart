import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';
import '../controllers/dashboard_controller.dart';
import '../models/dashboard_models.dart';
import '../widgets/dashboard_charts.dart';
import '../widgets/dashboard_header_widgets.dart';
import '../widgets/dashboard_metric_grid.dart';
import '../widgets/dashboard_panels.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  late final AnimationController chartController;

  @override
  void initState() {
    super.initState();
    chartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MenuProvider>().setRoute(AppRoutes.dashboard);
    });
  }

  @override
  void dispose() {
    chartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<DashboardController, MenuProvider>(
      builder: (context, controller, menuProvider, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth = constraints.maxWidth;
            final padding = contentWidth < 900
                ? const EdgeInsets.fromLTRB(16, 16, 16, 18)
                : const EdgeInsets.fromLTRB(24, 18, 24, 20);
            final headerCompact = contentWidth < 560;

            return SingleChildScrollView(
              padding: padding,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1680),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DashboardHeaderBar(
                        value: controller.globalFilter,
                        onChanged: controller.setGlobalFilter,
                        compact: headerCompact,
                      ),
                      const SizedBox(height: 14),
                      _SectionCard(
                        child: DashboardMetricGrid(metrics: dashboardMetrics),
                      ),
                      const SizedBox(height: 14),
                      _SectionCard(
                        child: DashboardTopSummary(
                          items: dashboardPendingItems,
                          sidebarCollapsed: menuProvider.sidebarCollapsed,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _SectionCard(
                        child: _ResponsiveAnalyticsSection(
                          chartProgress: chartController.value,
                          filter: controller.chartFilter,
                          onFilterChanged: controller.setChartFilter,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _SectionCard(
                        child: _ResponsiveInfoPairSection(
                          activityCard: const _ActivityCard(),
                          notices: dashboardNotices,
                          onSeeAllNotices: () {},
                        ),
                      ),
                      const SizedBox(height: 14),
                      _SectionCard(
                        child: _QuickActionGrid(actions: dashboardQuickActions),
                      ),
                      const SizedBox(height: 14),
                      LayoutBuilder(
                        builder: (context, sectionConstraints) {
                          final localNarrow = sectionConstraints.maxWidth < 1250;
                          if (localNarrow) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                DashboardTableCard(
                                  title: 'Transaksi Terbaru',
                                  actionLabel: 'Lihat Semua',
                                  height: 440,
                                  child: DashboardTransactionTable(
                                    items: dashboardTransactions,
                                    onTap: (tx) => controller.setSelectedTransaction(tx.id),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                DashboardTableCard(
                                  title: 'Top Merchant (Berdasarkan Penjualan)',
                                  actionLabel: 'Lihat Semua',
                                  height: 440,
                                  child: DashboardMerchantList(items: dashboardMerchants),
                                ),
                              ],
                            );
                          }

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: DashboardTableCard(
                                  title: 'Transaksi Terbaru',
                                  actionLabel: 'Lihat Semua',
                                  height: 440,
                                  child: DashboardTransactionTable(
                                    items: dashboardTransactions,
                                    onTap: (tx) => controller.setSelectedTransaction(tx.id),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 3,
                                child: DashboardTableCard(
                                  title: 'Top Merchant (Berdasarkan Penjualan)',
                                  actionLabel: 'Lihat Semua',
                                  height: 440,
                                  child: DashboardMerchantList(items: dashboardMerchants),
                                ),
                              ),
                            ],
                          );
                        },
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

class _DashboardHeaderBar extends StatelessWidget {
  const _DashboardHeaderBar({
    required this.value,
    required this.onChanged,
    required this.compact,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Dashboard',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: compact ? 180 : 220,
              child: DashboardFilterBar(value: value, onChanged: onChanged),
            ),
            const _CompactMetaChip(
              label: 'Hari Ini',
              icon: Icons.calendar_today_rounded,
            ),
          ],
        ),
      ],
    );
  }
}


class _ResponsiveAnalyticsSection extends StatelessWidget {
  const _ResponsiveAnalyticsSection({
    required this.chartProgress,
    required this.filter,
    required this.onFilterChanged,
  });

  final double chartProgress;
  final String filter;
  final ValueChanged<String> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final verticalLayout = constraints.maxWidth < 1120;
        final chart = _ChartCard(
          progress: chartProgress,
          filter: filter,
          onChanged: onFilterChanged,
        );
        final donut = _DonutCard(progress: chartProgress);

        if (verticalLayout) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              chart,
              const SizedBox(height: 14),
              donut,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: chart),
            const SizedBox(width: 12),
            Expanded(flex: 2, child: donut),
          ],
        );
      },
    );
  }
}

class _ResponsiveInfoPairSection extends StatelessWidget {
  const _ResponsiveInfoPairSection({
    required this.activityCard,
    required this.notices,
    required this.onSeeAllNotices,
  });

  final Widget activityCard;
  final List<DashboardNotice> notices;
  final VoidCallback onSeeAllNotices;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked = constraints.maxWidth < 1120;
        final quickInfo = DashboardTableCard(
          title: 'Informasi Cepat',
          actionLabel: '',
          height: 360,
          child: DashboardNoticeList(
            items: notices,
            onSeeAll: onSeeAllNotices,
          ),
        );

        if (stacked) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              activityCard,
              const SizedBox(height: 14),
              quickInfo,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: activityCard),
            const SizedBox(width: 12),
            Expanded(flex: 2, child: quickInfo),
          ],
        );
      },
    );
  }
}


class _QuickActionGrid extends StatelessWidget {
  const _QuickActionGrid({required this.actions});

  final List<DashboardQuickAction> actions;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 1200 ? 4 : 2;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Aksi Cepat',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: actions.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: constraints.maxWidth >= 1200 ? 4.8 : 4.0,
              ),
              itemBuilder: (context, index) {
                final action = actions[index];
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F8D55).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(_quickActionIcon(action.icon), color: const Color(0xFF0F8D55), size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          action.label,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

IconData _quickActionIcon(String icon) {
  return switch (icon) {
    'add' => Icons.add_rounded,
    'person_add' => Icons.person_add_alt_1_rounded,
    'campaign' => Icons.campaign_rounded,
    'description' => Icons.description_rounded,
    'summarize' => Icons.summarize_rounded,
    'settings' => Icons.settings_rounded,
    'local_offer' => Icons.local_offer_rounded,
    'dashboard_customize' => Icons.dashboard_customize_rounded,
    _ => Icons.flash_on_rounded,
  };
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CompactMetaChip extends StatelessWidget {
  const _CompactMetaChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(width: 12),
          Icon(icon, size: 16, color: Color(0xFF334155)),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.progress,
    required this.filter,
    required this.onChanged,
  });

  final double progress;
  final String filter;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Grafik Transaksi',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade900,
                  ),
                ),
              ),
              DashboardFilterChip(
                value: filter,
                items: const [
                  '30 Hari Terakhir',
                  '7 Hari Terakhir',
                  'Hari Ini',
                ],
                onChanged: onChanged,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: AnimatedOpacity(
              opacity: progress.clamp(0.2, 1),
              duration: const Duration(milliseconds: 250),
              child: DashboardLineChart(progress: progress),
            ),
          ),
        ],
      ),
    );
  }
}

class _DonutCard extends StatelessWidget {
  const _DonutCard({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Distribusi Metode Pembayaran',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Expanded(child: DashboardDonutChart(progress: progress)),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aktivitas Terbaru',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: DashboardActivityList(
              items: dashboardActivities,
              onSeeAll: () {},
            ),
          ),
        ],
      ),
    );
  }
}
