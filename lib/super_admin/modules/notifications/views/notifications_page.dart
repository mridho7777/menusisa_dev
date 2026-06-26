import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';
import 'package:provider/provider.dart';
import '../models/notifications_models.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with TickerProviderStateMixin {
  late final AnimationController chartController;
  String _chartFilter = '30 Hari Terakhir';
  final List<NotificationActionItem> _actions = [];

  @override
  void initState() {
    super.initState();
    chartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MenuProvider>().setRoute(AppRoutes.notifications);
    });
  }

  @override
  void dispose() {
    chartController.dispose();
    super.dispose();
  }

  void _notify(NotificationActionItem action) {
    setState(() {
      _actions.insert(0, action);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = constraints.maxWidth < 900
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
                  _SectionCard(
                    child: _MetricGrid(metrics: notificationMetrics),
                  ),
                  const SizedBox(height: 14),
                  _SectionCard(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: _DonutArea(progress: chartController.value),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(flex: 4, child: _SendStatColumn()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Grafik Pengiriman Notifikasi',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            _FilterChip(
                              value: _chartFilter,
                              onChanged: (v) =>
                                  setState(() => _chartFilter = v),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 330,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: _ChartArea(
                                  progress: chartController.value,
                                ),
                              ),
                              const SizedBox(width: 14),
                              const Expanded(flex: 2, child: _BestTimeColumn()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Daftar Notifikasi',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Column(
                          children: notificationItems
                              .map(
                                (item) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 28,
                                        child: Text(
                                          item.id,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          item.title,
                                          style: const TextStyle(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          item.type,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          item.recipient,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          item.channel,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          item.sentAt,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 86,
                                        child: _StatusChip(label: item.status),
                                      ),
                                      SizedBox(
                                        width: 120,
                                        child: Text(
                                          item.readProgress,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 120,
                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: () => _notify(
                                                NotificationActionItem(
                                                  title: 'Detail dibuka',
                                                  subtitle: item.title,
                                                  time: 'Baru saja',
                                                  color: 0xFF2563EB,
                                                  icon: 'check',
                                                ),
                                              ),
                                              icon: const Icon(
                                                Icons.remove_red_eye_outlined,
                                                size: 18,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () => _notify(
                                                NotificationActionItem(
                                                  title:
                                                      'Notifikasi dikirim ulang',
                                                  subtitle: item.title,
                                                  time: 'Baru saja',
                                                  color: 0xFF16A34A,
                                                  icon: 'check',
                                                ),
                                              ),
                                              icon: const Icon(
                                                Icons.send_outlined,
                                                size: 18,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () => _notify(
                                                NotificationActionItem(
                                                  title: 'Notifikasi dihapus',
                                                  subtitle: item.title,
                                                  time: 'Baru saja',
                                                  color: 0xFFEF4444,
                                                  icon: 'cancel',
                                                ),
                                              ),
                                              icon: const Icon(
                                                Icons.delete_outline_rounded,
                                                size: 18,
                                                color: Color(0xFFEF4444),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (_actions.isNotEmpty)
                    _NotificationTray(
                      items: _actions,
                      onClearAll: () => setState(() => _actions.clear()),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HeaderBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
            SizedBox(height: 3),
            Text(
              'Kelola dan pantau semua notifikasi yang dikirim ke customer dan merchant.',
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
        child: const Text('Kirim Notifikasi'),
      ),
    ],
  );
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFE5E7EB)),
    ),
    child: child,
  );
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.metrics});
  final List<NotificationMetric> metrics;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final crossAxisCount = constraints.maxWidth >= 1180 ? 3 : 2;
      final childAspectRatio = constraints.maxWidth >= 1500
          ? 3.6
          : constraints.maxWidth >= 1180
          ? 3.2
          : 4.2;
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: metrics.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: childAspectRatio,
        ),
        itemBuilder: (context, index) {
          final metric = metrics[index];
          final icon = switch (metric.icon) {
            'bell' => Icons.notifications_rounded,
            'send' => Icons.send_rounded,
            'read' => Icons.mark_email_read_rounded,
            'unread' => Icons.mark_email_unread_rounded,
            'failed' => Icons.error_outline_rounded,
            'percent' => Icons.percent_rounded,
            _ => Icons.notifications_rounded,
          };
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                Container(
                  width: 66,
                  height: 66,
                  decoration: BoxDecoration(
                    color: Color(metric.color),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: Colors.white, size: 36),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        metric.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              metric.value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              metric.delta,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF16A34A),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

class _DonutArea extends StatelessWidget {
  const _DonutArea({required this.progress});
  final double progress;
  @override
  Widget build(BuildContext context) {
    final sections = [
      PieChartSectionData(
        color: const Color(0xFF0F8D55),
        value: 49.8 * progress,
        radius: 34,
      ),
      PieChartSectionData(
        color: const Color(0xFFF59E0B),
        value: 30.5 * progress,
        radius: 34,
      ),
      PieChartSectionData(
        color: const Color(0xFFEF4444),
        value: 14.5 * progress,
        radius: 34,
      ),
      PieChartSectionData(
        color: const Color(0xFF7C3AED),
        value: 5.2 * progress,
        radius: 34,
      ),
    ];
    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 74,
              startDegreeOffset: -90,
              sections: sections,
            ),
            duration: const Duration(milliseconds: 250),
          ),
        ),
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '1.245',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 4),
            Text(
              'Total',
              style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ],
    );
  }
}

class _SendStatColumn extends StatelessWidget {
  const _SendStatColumn();
  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: notificationChannelStats
        .map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Color(item.color),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.value,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
        .toList(),
  );
}

class _ChartArea extends StatelessWidget {
  const _ChartArea({required this.progress});
  final double progress;
  static const _spots = <FlSpot>[
    FlSpot(0, 80),
    FlSpot(1, 120),
    FlSpot(2, 100),
    FlSpot(3, 150),
    FlSpot(4, 140),
    FlSpot(5, 180),
    FlSpot(6, 160),
    FlSpot(7, 140),
    FlSpot(8, 190),
    FlSpot(9, 170),
    FlSpot(10, 210),
    FlSpot(11, 200),
    FlSpot(12, 230),
    FlSpot(13, 250),
    FlSpot(14, 240),
    FlSpot(15, 260),
    FlSpot(16, 290),
    FlSpot(17, 280),
    FlSpot(18, 300),
    FlSpot(19, 320),
  ];
  @override
  Widget build(BuildContext context) {
    final count = (_spots.length * progress).clamp(2, _spots.length).toInt();
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 19,
        minY: 0,
        maxY: 350,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 50,
          getDrawingHorizontalLine: (value) =>
              const FlLine(color: Color(0xFFE5E7EB), strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 34,
              interval: 50,
              getTitlesWidget: (value, meta) => Text(
                '',
                style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 3,
              getTitlesWidget: (value, meta) {
                final labels = <int, String>{
                  0: '00:00',
                  3: '03:00',
                  6: '06:00',
                  9: '09:00',
                  12: '12:00',
                  15: '15:00',
                  18: '18:00',
                };
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    labels[value.toInt()] ?? '',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: _spots.take(count).toList(),
            isCurved: true,
            color: const Color(0xFF0F8D55),
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(radius: 3.2, color: Color(0xFF0F8D55)),
            ),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 250),
    );
  }
}

class _BestTimeColumn extends StatelessWidget {
  const _BestTimeColumn();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFF9FAFB),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFE5E7EB)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Waktu Terbaik Mengirim',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 14),
        const _TimeRow(label: 'Pagi (06:00 - 12:00)', value: '320 notif'),
        const _TimeRow(label: 'Siang (12:00 - 18:00)', value: '520 notif'),
        const _TimeRow(label: 'Malam (18:00 - 00:00)', value: '280 notif'),
        const _TimeRow(label: 'Dini Hari (00:00 - 06:00)', value: '125 notif'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF0F8D55).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline_rounded,
                    size: 18,
                    color: Color(0xFF0F8D55),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Rekomendasi',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F8D55),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Kirim notifikasi penting pada pukul 12:00-18:00 untuk tingkat baca terbaik.',
                style: TextStyle(fontSize: 11, color: Color(0xFF374151)),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _TimeRow extends StatelessWidget {
  const _TimeRow({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF374151)),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ],
    ),
  );
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    final color = switch (label) {
      'Terkirim' => const Color(0xFF16A34A),
      'Dijadwalkan' => const Color(0xFFF59E0B),
      'Gagal' => const Color(0xFFEF4444),
      _ => const Color(0xFF6B7280),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
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
  Widget build(BuildContext context) => DropdownButtonHideUnderline(
    child: DropdownButton<String>(
      value: value,
      items: const ['30 Hari Terakhir', '7 Hari Terakhir', 'Hari Ini']
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 12)),
            ),
          )
          .toList(),
      onChanged: (item) {
        if (item != null) onChanged(item);
      },
    ),
  );
}

class _NotificationTray extends StatelessWidget {
  const _NotificationTray({required this.items, required this.onClearAll});
  final List<NotificationActionItem> items;
  final VoidCallback onClearAll;
  @override
  Widget build(BuildContext context) => Container(
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
            const Expanded(
              child: Text(
                'Notifikasi Aksi',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
            TextButton(onPressed: onClearAll, child: const Text('Hapus Semua')),
          ],
        ),
        const SizedBox(height: 8),
        Column(
          children: items
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(item.color).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Color(item.color).withValues(alpha: 0.24),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 13,
                          backgroundColor: Color(
                            item.color,
                          ).withValues(alpha: 0.16),
                          child: Icon(
                            switch (item.icon) {
                              'check' => Icons.check_rounded,
                              'warning' => Icons.warning_rounded,
                              'cancel' => Icons.cancel_rounded,
                              _ => Icons.info_rounded,
                            },
                            size: 15,
                            color: Color(item.color),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.subtitle,
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          item.time,
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    ),
  );
}
