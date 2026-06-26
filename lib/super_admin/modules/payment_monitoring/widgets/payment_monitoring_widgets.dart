import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/payment_monitoring_models.dart';

class PaymentSectionCard extends StatelessWidget {
  const PaymentSectionCard({super.key, required this.child});

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
      ),
      child: child,
    );
  }
}

class PaymentCombinedChartCard extends StatelessWidget {
  const PaymentCombinedChartCard({
    super.key,
    required this.progress,
    required this.filter,
    required this.onFilterChanged,
    required this.sidebarCollapsed,
  });

  final double progress;
  final String filter;
  final ValueChanged<String> onFilterChanged;
  final bool sidebarCollapsed;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  'Grafik Pembayaran & Distribusi Status',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
              _FilterChip(value: filter, onChanged: onFilterChanged),
            ],
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final stacked = !sidebarCollapsed || constraints.maxWidth < 1180;
              final chartArea = _ChartArea(progress: progress);
              final donutArea = _DonutArea(progress: progress);
              if (stacked) {
                return Column(
                  children: [
                    SizedBox(height: 300, child: chartArea),
                    const SizedBox(height: 16),
                    SizedBox(height: 300, child: donutArea),
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: SizedBox(height: 330, child: chartArea),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: SizedBox(height: 330, child: donutArea),
                  ),
                ],
              );
            },
          ),
        ],
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
}

class _ChartArea extends StatelessWidget {
  const _ChartArea({required this.progress});

  final double progress;

  static const _spots = <FlSpot>[
    FlSpot(0, 100),
    FlSpot(1, 240),
    FlSpot(2, 180),
    FlSpot(3, 320),
    FlSpot(4, 290),
    FlSpot(5, 410),
    FlSpot(6, 370),
    FlSpot(7, 450),
    FlSpot(8, 420),
    FlSpot(9, 530),
    FlSpot(10, 490),
    FlSpot(11, 600),
    FlSpot(12, 570),
    FlSpot(13, 670),
    FlSpot(14, 640),
    FlSpot(15, 730),
    FlSpot(16, 700),
    FlSpot(17, 790),
    FlSpot(18, 820),
    FlSpot(19, 880),
  ];

  @override
  Widget build(BuildContext context) {
    final count = (_spots.length * progress).clamp(2, _spots.length).toInt();
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 19,
        minY: 0,
        maxY: 1000,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 200,
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
              interval: 200,
              getTitlesWidget: (value, meta) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  value == 0 ? '0' : value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF6B7280),
                  ),
                ),
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
                  0: '1 Apr',
                  3: '8 Apr',
                  6: '15 Apr',
                  9: '22 Apr',
                  12: '29 Apr',
                  15: '6 Mei',
                  18: '13 Mei',
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
            color: const Color(0xFF2563EB),
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                    radius: 3.2,
                    color: Color(0xFF2563EB),
                  ),
            ),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 250),
    );
  }
}

class _DonutArea extends StatelessWidget {
  const _DonutArea({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final sections = [
      PieChartSectionData(
        color: const Color(0xFF0F8D55),
        value: 76 * progress,
        radius: 34,
      ),
      PieChartSectionData(
        color: const Color(0xFFF59E0B),
        value: 10 * progress,
        radius: 34,
      ),
      PieChartSectionData(
        color: const Color(0xFFEF4444),
        value: 8 * progress,
        radius: 34,
      ),
      PieChartSectionData(
        color: const Color(0xFF7C3AED),
        value: 6 * progress,
        radius: 34,
      ),
    ];

    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Stack(
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
                    borderData: FlBorderData(show: false),
                  ),
                  duration: const Duration(milliseconds: 250),
                ),
              ),
              const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '2.456',
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
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(flex: 4, child: _LegendColumn()),
      ],
    );
  }
}

class _LegendColumn extends StatelessWidget {
  const _LegendColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _LegendItem(
          color: Color(0xFF0F8D55),
          title: 'Berhasil',
          value: '1.856 (76%)',
        ),
        SizedBox(height: 16),
        _LegendItem(
          color: Color(0xFFF59E0B),
          title: 'Pending',
          value: '246 (10%)',
        ),
        SizedBox(height: 16),
        _LegendItem(
          color: Color(0xFFEF4444),
          title: 'Gagal',
          value: '198 (8%)',
        ),
        SizedBox(height: 16),
        _LegendItem(
          color: Color(0xFF7C3AED),
          title: 'Expired',
          value: '156 (6%)',
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.title,
    required this.value,
  });

  final Color color;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ],
    );
  }
}

class PaymentTopMerchantList extends StatelessWidget {
  const PaymentTopMerchantList({super.key, required this.items});

  final List<TopMerchantPayment> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Color(item.color).withValues(alpha: 0.16),
                child: Text(
                  item.rank,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(item.color),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Total pembayaran ',
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                item.total,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class PaymentNotificationTray extends StatelessWidget {
  const PaymentNotificationTray({
    super.key,
    required this.items,
    required this.onClearAll,
  });

  final List<PaymentNotification> items;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              TextButton(
                onPressed: onClearAll,
                child: const Text('Hapus Semua'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'Belum ada aksi yang memunculkan notifikasi.',
                  style: TextStyle(color: Color(0xFF6B7280)),
                ),
              ),
            )
          else
            Column(
              children: items.map((item) {
                return Padding(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                              'info' => Icons.info_rounded,
                              _ => Icons.notifications_rounded,
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
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

