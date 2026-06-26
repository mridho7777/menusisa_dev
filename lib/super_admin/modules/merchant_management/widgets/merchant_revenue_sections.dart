import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/merchant_management_models.dart';

class MerchantSectionCard extends StatelessWidget {
  const MerchantSectionCard({super.key, required this.child});

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

class MerchantCombinedChartCard extends StatelessWidget {
  const MerchantCombinedChartCard({
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
                  'Grafik & Distribusi Merchant',
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
    FlSpot(0, 120),
    FlSpot(1, 220),
    FlSpot(2, 180),
    FlSpot(3, 280),
    FlSpot(4, 260),
    FlSpot(5, 300),
    FlSpot(6, 240),
    FlSpot(7, 260),
    FlSpot(8, 330),
    FlSpot(9, 290),
    FlSpot(10, 350),
    FlSpot(11, 320),
    FlSpot(12, 400),
    FlSpot(13, 390),
    FlSpot(14, 420),
    FlSpot(15, 460),
    FlSpot(16, 520),
    FlSpot(17, 490),
    FlSpot(18, 540),
    FlSpot(19, 560),
  ];

  @override
  Widget build(BuildContext context) {
    final count = (_spots.length * progress).clamp(2, _spots.length).toInt();
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 19,
        minY: 0,
        maxY: 620,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 100,
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
              interval: 100,
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
                  0: '21 Apr',
                  3: '26 Apr',
                  6: '1 Mei',
                  9: '6 Mei',
                  12: '11 Mei',
                  15: '16 Mei',
                  18: '20 Mei',
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
                    color: const Color(0xFF0F8D55),
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
        value: 52 * progress,
        radius: 34,
      ),
      PieChartSectionData(
        color: const Color(0xFFF59E0B),
        value: 34 * progress,
        radius: 34,
      ),
      PieChartSectionData(
        color: const Color(0xFF7C3AED),
        value: 10 * progress,
        radius: 34,
      ),
      PieChartSectionData(
        color: const Color(0xFFEF4444),
        value: 4 * progress,
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
                    '128',
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
      children: merchantDistributionLegend
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
                        item.title,
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
}
