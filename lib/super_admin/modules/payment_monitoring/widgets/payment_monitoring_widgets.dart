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
    return Column(
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                height: 280,
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
                      'Grafik Produk Masuk',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(child: _ChartArea(progress: progress)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              flex: 2,
              child: Container(
                height: 280,
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
                      'Status Produk',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(child: _DonutArea(progress: progress)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
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
        items: const ['7 Hari Terakhir', 'Hari Ini']
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
    FlSpot(0, 0),
    FlSpot(1, 0),
    FlSpot(2, 0),
    FlSpot(3, 0),
    FlSpot(4, 0),
    FlSpot(5, 0),
    FlSpot(6, 0),
  ];

  @override
  Widget build(BuildContext context) {
    final count = (_spots.length * progress).clamp(2, _spots.length).toInt();
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 100,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25,
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
              interval: 25,
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
              interval: 1,
              getTitlesWidget: (value, meta) {
                final labels = <int, String>{
                  0: '10 Jul',
                  1: '11 Jul',
                  2: '12 Jul',
                  3: '13 Jul',
                  4: '14 Jul',
                  5: '15 Jul',
                  6: '16 Jul',
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
        radius: 28,
      ),
      PieChartSectionData(
        color: const Color(0xFFF59E0B),
        value: 10 * progress,
        radius: 28,
      ),
      PieChartSectionData(
        color: const Color(0xFFEF4444),
        value: 8 * progress,
        radius: 28,
      ),
      PieChartSectionData(
        color: const Color(0xFF7C3AED),
        value: 6 * progress,
        radius: 28,
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
                    centerSpaceRadius: 50,
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
        const SizedBox(width: 12),
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
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _LegendItem(
          color: Color(0xFF0F8D55),
          title: 'Berhasil',
          value: '1.856 (76%)',
        ),
        SizedBox(height: 8),
        _LegendItem(
          color: Color(0xFFF59E0B),
          title: 'Pending',
          value: '246 (10%)',
        ),
        SizedBox(height: 8),
        _LegendItem(
          color: Color(0xFFEF4444),
          title: 'Gagal',
          value: '198 (8%)',
        ),
        SizedBox(height: 8),
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
          width: 10,
          height: 10,
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
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
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
      padding: const EdgeInsets.all(12),
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

