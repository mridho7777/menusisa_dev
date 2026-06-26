import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/platform_revenue_models.dart';

class RevenueSectionCard extends StatelessWidget {
  const RevenueSectionCard({super.key, required this.child});

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

class RevenueChartCard extends StatelessWidget {
  const RevenueChartCard({
    super.key,
    required this.progress,
    required this.filter,
    required this.onFilterChanged,
  });

  final double progress;
  final String filter;
  final ValueChanged<String> onFilterChanged;

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
                  'Grafik Pendapatan Platform',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
              _FilterChip(value: filter, onChanged: onFilterChanged),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(height: 330, child: _ChartArea(progress: progress)),
        ],
      ),
    );
  }
}

class RevenueDistributionCard extends StatelessWidget {
  const RevenueDistributionCard({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final sections = [
      PieChartSectionData(
        color: const Color(0xFF0F8D55),
        value: 60 * progress,
        radius: 34,
      ),
      PieChartSectionData(
        color: const Color(0xFFF59E0B),
        value: 28 * progress,
        radius: 34,
      ),
      PieChartSectionData(
        color: const Color(0xFFEF4444),
        value: 12 * progress,
        radius: 34,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
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
                      'Rp 245.680.000',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
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
      ),
    );
  }
}

class RevenueSummaryCard extends StatelessWidget {
  const RevenueSummaryCard({super.key});

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
                  'Ringkasan Pendapatan',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
              _Chip(value: 'Bulan Ini'),
            ],
          ),
          const SizedBox(height: 12),
          ...revenueSummaryItems.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.value,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Pertumbuhan Bulanan',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Text(
                      '+18.7%',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF16A34A),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(999)),
                  child: LinearProgressIndicator(
                    value: 0.78,
                    minHeight: 8,
                    backgroundColor: Color(0xFFE5E7EB),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF0F8D55),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RevenueTopSourceCard extends StatelessWidget {
  const RevenueTopSourceCard({super.key});

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
                  'Top Sumber Pendapatan',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
              _Chip(value: 'Bulan Ini'),
            ],
          ),
          const SizedBox(height: 12),
          ...revenueTopItems.map(
            (item) => Padding(
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
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    item.amount,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              child: const Text('Lihat Semua'),
            ),
          ),
        ],
      ),
    );
  }
}

class RevenueInfoCard extends StatelessWidget {
  const RevenueInfoCard({super.key});

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
        children: const [
          Text(
            'Informasi Cepat',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 12),
          _InfoRow(label: 'Total Merchant Aktif', value: '2.145'),
          _InfoRow(label: 'Total Transaksi', value: '48.650'),
          _InfoRow(label: 'Rata-rata Komisi per Transaksi', value: 'Rp 3.810'),
          _InfoRow(label: 'Rasio Pendapatan terhadap GMV', value: '3.00%'),
        ],
      ),
    );
  }
}

class RevenueTableCard extends StatelessWidget {
  const RevenueTableCard({
    super.key,
    required this.items,
    required this.onView,
  });

  final List<RevenueItem> items;
  final ValueChanged<RevenueItem> onView;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              SizedBox(
                width: 28,
                child: Text(item.id, style: const TextStyle(fontSize: 12)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(item.date, style: const TextStyle(fontSize: 12)),
              ),
              Expanded(
                child: Text(item.source, style: const TextStyle(fontSize: 12)),
              ),
              Expanded(
                child: Text(
                  item.category,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Deskripsi revenue',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              SizedBox(
                width: 90,
                child: Text(item.value, style: const TextStyle(fontSize: 12)),
              ),
              SizedBox(
                width: 70,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16A34A).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    item.status,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF16A34A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 50,
                child: IconButton(
                  onPressed: () => onView(item),
                  icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class RevenueNotificationTray extends StatelessWidget {
  const RevenueNotificationTray({
    super.key,
    required this.items,
    required this.onClearAll,
  });

  final List<RevenueNotification> items;
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
                );
              }).toList(),
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
    FlSpot(0, 20),
    FlSpot(1, 80),
    FlSpot(2, 60),
    FlSpot(3, 130),
    FlSpot(4, 120),
    FlSpot(5, 160),
    FlSpot(6, 120),
    FlSpot(7, 100),
    FlSpot(8, 140),
    FlSpot(9, 130),
    FlSpot(10, 170),
    FlSpot(11, 160),
    FlSpot(12, 180),
    FlSpot(13, 200),
    FlSpot(14, 190),
    FlSpot(15, 210),
    FlSpot(16, 240),
    FlSpot(17, 220),
    FlSpot(18, 230),
    FlSpot(19, 260),
  ];

  @override
  Widget build(BuildContext context) {
    final count = (_spots.length * progress).clamp(2, _spots.length).toInt();
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 19,
        minY: 0,
        maxY: 300,
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
                'M',
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
                  0: '21 Apr',
                  3: '28 Apr',
                  6: '5 Mei',
                  9: '12 Mei',
                  12: '19 Mei',
                  15: '26 Mei',
                  18: '2 Jun',
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
                  FlDotCirclePainter(
                    radius: 3.2,
                    color: Color(0xFF0F8D55),
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

class _LegendColumn extends StatelessWidget {
  const _LegendColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: revenueSources.map((item) {
        return Padding(
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
        );
      }).toList(),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        value,
        style: const TextStyle(fontSize: 11.5, color: Color(0xFF6B7280)),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 12.5, color: Color(0xFF374151)),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

