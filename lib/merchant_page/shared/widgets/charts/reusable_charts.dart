import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    final maxY = chartSpots.isEmpty ? 100.0 : (chartSpots.map((e) => e.y).fold<double>(0, (a, b) => a > b ? a : b) * 1.2).clamp(100.0, 1000000.0);

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
                child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
              ),
              if (onFilterChanged != null)
                _FilterDropdown(value: filter, onChanged: onFilterChanged!),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 170,
            child: LineChart(
              LineChartData(
                minX: 1,
                maxX: chartSpots.length.toDouble(),
                minY: 0,
                maxY: maxY,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY <= 100 ? 25 : maxY / 4,
                  getDrawingHorizontalLine: (value) => const FlLine(color: Color(0xFFE5E7EB), strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      interval: maxY <= 100 ? 25 : maxY / 4,
                      getTitlesWidget: (value, meta) => Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Text(value.toInt().toString(), style: const TextStyle(fontSize: 9, color: Color(0xFF6B7280))),
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
                        if (index < 0 || index >= next7Days.length) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(next7Days[index], style: const TextStyle(fontSize: 9, color: Color(0xFF6B7280))),
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
                      final dateLabel = index >= 0 && index < next7Days.length ? next7Days[index] : '';
                      return LineTooltipItem('$dateLabel\n$dataKey: ${spot.y.toInt()}', const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white));
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
                      getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(radius: 3, color: const Color(0xFF0F8D55), strokeWidth: 0),
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
            Text('// TODO: Supabase - Table: $supabaseTable', style: const TextStyle(fontSize: 9, color: Color(0xFF9CA3AF), fontStyle: FontStyle.italic)),
            if (supabaseQuery != null)
              Text('// Query: $supabaseQuery', style: const TextStyle(fontSize: 9, color: Color(0xFF9CA3AF), fontStyle: FontStyle.italic)),
          ],
        ],
      ),
    );
  }
}

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
    final chartSections = sections ?? (legendItems.isEmpty
        ? [
            PieChartSectionData(color: const Color(0xFF0F8D55), value: 1, radius: 24, titleStyle: const TextStyle(fontSize: 0)),
            PieChartSectionData(color: const Color(0xFFF59E0B), value: 1, radius: 24, titleStyle: const TextStyle(fontSize: 0)),
            PieChartSectionData(color: const Color(0xFFEF4444), value: 1, radius: 24, titleStyle: const TextStyle(fontSize: 0)),
          ]
        : legendItems.map((item) => PieChartSectionData(color: item.color, value: 1, radius: 24, titleStyle: const TextStyle(fontSize: 0))).toList());

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
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
          const SizedBox(height: 12),
          SizedBox(
            height: 170,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 36,
                sections: chartSections,
                pieTouchData: PieTouchData(enabled: true),
              ),
              duration: const Duration(milliseconds: 300),
            ),
          ),
          if (legendItems.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: legendItems.map((item) => _LegendItem(item: item)).toList(),
            ),
          ],
          if (supabaseTable != null) ...[
            const SizedBox(height: 8),
            Text('// TODO: Supabase - Table: $supabaseTable', style: const TextStyle(fontSize: 9, color: Color(0xFF9CA3AF), fontStyle: FontStyle.italic)),
            if (supabaseQuery != null)
              Text('// Query: $supabaseQuery', style: const TextStyle(fontSize: 9, color: Color(0xFF9CA3AF), fontStyle: FontStyle.italic)),
          ],
        ],
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _FilterDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      underline: const SizedBox.shrink(),
      isDense: true,
      items: const [
        DropdownMenuItem(value: '7 Hari Ke Depan', child: Text('7 Hari Ke Depan')),
        DropdownMenuItem(value: '30 Hari', child: Text('30 Hari')),
      ],
      onChanged: (newValue) {
        if (newValue != null) onChanged(newValue);
      },
    );
  }
}

class DonutChartLegendItem {
  final Color color;
  final String title;
  final String value;

  const DonutChartLegendItem({required this.color, required this.title, required this.value});
}

class _LegendItem extends StatelessWidget {
  final DonutChartLegendItem item;
  const _LegendItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [Container(width: 10, height: 10, decoration: BoxDecoration(color: item.color, shape: BoxShape.circle)), const SizedBox(width: 6), Text('${item.title} ${item.value}', style: const TextStyle(fontSize: 10))]);
  }
}


