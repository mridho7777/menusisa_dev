import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Reusable Chart Component - Line Chart with responsive container
/// Grafik garis dengan 2 kotak pembungkus (inner box + outer white wrapper)
/// Data 0 semua, grafik 1-7 hari ke depan realtime
class ReusableLineChart extends StatelessWidget {
  const ReusableLineChart({
    super.key,
    required this.title,
    this.filter = '7 Hari Ke Depan',
    this.onFilterChanged,
    this.dataKey = 'transactions',
    this.supabaseTable,
    this.supabaseQuery,
    this.spots,
    this.labels,
  });

  final String title;
  final String filter;
  final ValueChanged<String>? onFilterChanged;
  final String dataKey;
  final String? supabaseTable;
  final String? supabaseQuery;
  final List<FlSpot>? spots;
  final List<String>? labels;

  // Generate 7 hari ke depan dari waktu saat ini
  List<String> _getNext7Days() {
    final now = DateTime.now();
    return List.generate(7, (index) {
      final date = now.add(Duration(days: index));
      return DateFormat('d MMM').format(date);
    });
  }

  @override
  Widget build(BuildContext context) {
    final next7Days = labels ?? _getNext7Days();
    final chartSpots = spots ?? const [
      FlSpot(1, 0),
      FlSpot(2, 0),
      FlSpot(3, 0),
      FlSpot(4, 0),
      FlSpot(5, 0),
      FlSpot(6, 0),
      FlSpot(7, 0),
    ];
    final maxY = chartSpots.isEmpty
        ? 100.0
        : (chartSpots.map((e) => e.y).fold<double>(0, (a, b) => a > b ? a : b) * 1.2)
            .clamp(100.0, 1000000.0);
    
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
              if (onFilterChanged != null)
                _FilterDropdown(
                  value: filter,
                  onChanged: onFilterChanged!,
                ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 170,
            child: LineChart(
              LineChartData(
                minX: 1,
                maxX: 7,
                minY: 0,
                maxY: maxY,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY <= 100 ? 25 : maxY / 4,
                  getDrawingHorizontalLine: (value) => const FlLine(
                    color: Color(0xFFE5E7EB),
                    strokeWidth: 1,
                  ),
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
                      reservedSize: 32,
                      interval: maxY <= 100 ? 25 : maxY / 4,
                      getTitlesWidget: (value, meta) => Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 9,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt() - 1;
                        if (index < 0 || index >= next7Days.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            next7Days[index],
                            style: const TextStyle(
                              fontSize: 9,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (spots) => spots.map((spot) {
                      final index = spot.x.toInt() - 1;
                      final dateLabel = index >= 0 && index < next7Days.length
                          ? next7Days[index]
                          : '';
                      return LineTooltipItem(
                        '$dateLabel\n$dataKey: ${spot.y.toInt()}',
                        const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: chartSpots,
                    isCurved: true,
                    color: const Color(0xFF0F8D55),
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                        radius: 3,
                        color: const Color(0xFF0F8D55),
                        strokeWidth: 0,
                      ),
                    ),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
              duration: const Duration(milliseconds: 300),
            ),
          ),
          if (supabaseTable != null) ...[
            const SizedBox(height: 8),
            Text('Table: $supabaseTable', style: const TextStyle(fontSize: 9, color: Color(0xFF9CA3AF), fontStyle: FontStyle.italic)),
            if (supabaseQuery != null)
              Text(
                '// Query: $supabaseQuery',
                style: const TextStyle(
                  fontSize: 9,
                  color: Color(0xFF9CA3AF),
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

/// Reusable Chart Component - Donut Chart with responsive container
class ReusableDonutChart extends StatelessWidget {
  const ReusableDonutChart({
    super.key,
    required this.title,
    this.legendItems = const [],
    this.supabaseTable,
    this.supabaseQuery,
    this.sections,
  });

  final String title;
  final List<DonutChartLegendItem> legendItems;
  final String? supabaseTable;
  final String? supabaseQuery;
  final List<PieChartSectionData>? sections;

  @override
  Widget build(BuildContext context) {
    final chartSections = sections ??
        (legendItems.isEmpty
            ? [
                PieChartSectionData(
                  color: const Color(0xFF0F8D55),
                  value: 1,
                  radius: 22,
                  titleStyle: const TextStyle(fontSize: 0),
                ),
                PieChartSectionData(
                  color: const Color(0xFFF59E0B),
                  value: 1,
                  radius: 22,
                  titleStyle: const TextStyle(fontSize: 0),
                ),
                PieChartSectionData(
                  color: const Color(0xFFEF4444),
                  value: 1,
                  radius: 22,
                  titleStyle: const TextStyle(fontSize: 0),
                ),
              ]
            : legendItems
                .map((item) => PieChartSectionData(
                      color: item.color,
                      value: 1,
                      radius: 22,
                      titleStyle: const TextStyle(fontSize: 0),
                    ))
                .toList());

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 170,
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 0,
                            centerSpaceRadius: 42,
                            startDegreeOffset: -90,
                            sections: chartSections,
                            borderData: FlBorderData(show: false),
                          ),
                          duration: const Duration(milliseconds: 300),
                        ),
                      ),
                      const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            '0',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 5,
                  child: _LegendColumn(items: legendItems),
                ),
              ],
            ),
          ),
          if (supabaseTable != null) ...[
            const SizedBox(height: 8),
            Text('Table: $supabaseTable', style: const TextStyle(fontSize: 9, color: Color(0xFF9CA3AF), fontStyle: FontStyle.italic)),
            if (supabaseQuery != null)
              Text(
                '// Query: $supabaseQuery',
                style: const TextStyle(
                  fontSize: 9,
                  color: Color(0xFF9CA3AF),
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

/// Wrapper untuk 2 grafik bersebelahan dengan responsive layout
class DualChartWrapper extends StatelessWidget {
  const DualChartWrapper({
    super.key,
    required this.leftChart,
    required this.rightChart,
  });

  final Widget leftChart;
  final Widget rightChart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final shouldStack = constraints.maxWidth < 1;
          if (shouldStack) {
            return Column(
              children: [
                leftChart,
                const SizedBox(height: 14),
                rightChart,
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: leftChart),
              const SizedBox(width: 14),
              Expanded(child: rightChart),
            ],
          );
        },
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onChanged,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, size: 16),
          ],
        ),
      ),
      itemBuilder: (context) => [
        '7 Hari Ke Depan',
        '30 Hari Ke Depan',
        'Hari Ini',
      ].map((opt) => PopupMenuItem(value: opt, child: Text(opt))).toList(),
    );
  }
}

class _LegendColumn extends StatelessWidget {
  const _LegendColumn({this.items = const []});

  final List<DonutChartLegendItem> items;

  @override
  Widget build(BuildContext context) {
    final defaultItems = items.isEmpty
        ? const [
            DonutChartLegendItem(
              color: Color(0xFF0F8D55),
              title: 'QRIS (Barcode)',
              value: '0 (0%)',
            ),
            DonutChartLegendItem(
              color: Color(0xFFF59E0B),
              title: 'Transfer Bank',
              value: '0 (0%)',
            ),
            DonutChartLegendItem(
              color: Color(0xFFEF4444),
              title: 'Bayar di Tempat',
              value: '0 (0%)',
            ),
          ]
        : items;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < defaultItems.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          _LegendItem(item: defaultItems[i]),
        ],
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.item});

  final DonutChartLegendItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 11,
          height: 11,
          decoration: BoxDecoration(
            color: item.color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.value,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DonutChartLegendItem {
  const DonutChartLegendItem({
    required this.color,
    required this.title,
    required this.value,
  });

  final Color color;
  final String title;
  final String value;
}

