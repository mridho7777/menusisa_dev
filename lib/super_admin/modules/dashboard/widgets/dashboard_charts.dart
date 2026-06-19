import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardLineChart extends StatelessWidget {
  const DashboardLineChart({super.key, required this.progress});

  final double progress;

  static const _spots = <FlSpot>[
    FlSpot(0, 140),
    FlSpot(1, 430),
    FlSpot(2, 260),
    FlSpot(3, 360),
    FlSpot(4, 520),
    FlSpot(5, 560),
    FlSpot(6, 330),
    FlSpot(7, 260),
    FlSpot(8, 390),
    FlSpot(9, 340),
    FlSpot(10, 460),
    FlSpot(11, 410),
    FlSpot(12, 610),
    FlSpot(13, 580),
    FlSpot(14, 480),
    FlSpot(15, 640),
    FlSpot(16, 820),
    FlSpot(17, 760),
    FlSpot(18, 800),
    FlSpot(19, 780),
  ];

  @override
  Widget build(BuildContext context) {
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
                  0: '20 Apr',
                  3: '25 Apr',
                  6: '30 Apr',
                  9: '5 Mei',
                  12: '10 Mei',
                  15: '15 Mei',
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
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (spots) => spots.map((spot) {
              return LineTooltipItem(
                ' 10 Mei 2025\nTransaksi: 680',
                const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              );
            }).toList(),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: _spots
                .map((spot) {
                  final count = (_spots.length * progress)
                      .clamp(2, _spots.length)
                      .toInt();
                  final index = _spots.indexOf(spot);
                  return index < count ? spot : FlSpot(spot.x, double.nan);
                })
                .where((spot) => !spot.y.isNaN)
                .toList(),
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
                    strokeWidth: 0,
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

class DashboardDonutChart extends StatelessWidget {
  const DashboardDonutChart({super.key, required this.progress});

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
        color: const Color(0xFFEF4444),
        value: 14 * progress,
        radius: 34,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
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
                        centerSpaceRadius: 78,
                        startDegreeOffset: -90,
                        sections: sections,
                        borderData: FlBorderData(show: false),
                      ),
                      duration: const Duration(milliseconds: 250),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '2.386',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            SizedBox(
              width: constraints.maxWidth * 0.32,
              child: const _LegendColumn(),
            ),
          ],
        );
      },
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
          title: 'QRIS (Barcode)',
          value: '1.245 (52%)',
        ),
        SizedBox(height: 18),
        _LegendItem(
          color: Color(0xFFF59E0B),
          title: 'Transfer Bank',
          value: '820 (34%)',
        ),
        SizedBox(height: 18),
        _LegendItem(
          color: Color(0xFFEF4444),
          title: 'Bayar di Tempat',
          value: '321 (14%)',
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
