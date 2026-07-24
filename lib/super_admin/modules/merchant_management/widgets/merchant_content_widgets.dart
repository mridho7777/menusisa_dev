import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/merchant_management_models.dart';

class MerchantRegistrationChart extends StatelessWidget {
  const MerchantRegistrationChart({super.key, required this.progress});

  final double progress;

  static const _spots = <FlSpot>[
    FlSpot(1, 0),
    FlSpot(2, 0),
    FlSpot(3, 0),
    FlSpot(4, 0),
    FlSpot(5, 0),
    FlSpot(6, 0),
    FlSpot(7, 0),
  ];

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 45,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 10,
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
              reservedSize: 30,
              interval: 10,
              getTitlesWidget: (value, meta) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Text(
                  value.toInt().toString(),
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
                const labels = <int, String>{
                  1: '1',
                  2: '2',
                  3: '3',
                  4: '4',
                  5: '5',
                  6: '6',
                  7: '7',
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
            spots: _spots
                .take(
                  (_spots.length * progress).clamp(2, _spots.length).toInt(),
                )
                .toList(),
            isCurved: true,
            color: const Color(0xFF0F8D55),
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                    radius: 3.5,
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

class MerchantDistributionDonut extends StatelessWidget {
  const MerchantDistributionDonut({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final sections = [
      PieChartSectionData(
        color: const Color(0xFF0F8D55),
        value: 0 * progress,
        radius: 28,
        showTitle: false,
      ),
      PieChartSectionData(
        color: const Color(0xFFF59E0B),
        value: 0 * progress,
        radius: 28,
        showTitle: false,
      ),
      PieChartSectionData(
        color: const Color(0xFF7C3AED),
        value: 0 * progress,
        radius: 28,
        showTitle: false,
      ),
      PieChartSectionData(
        color: const Color(0xFFEF4444),
        value: 0 * progress,
        radius: 28,
        showTitle: false,
      ),
    ];

    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 50,
                  startDegreeOffset: -90,
                  sections: sections,
                  borderData: FlBorderData(show: false),
                ),
                duration: const Duration(milliseconds: 250),
              ),
              const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '0',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Column(
          children: merchantDistributionLegend.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Color(item.color),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    item.value,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class MerchantNotificationList extends StatelessWidget {
  const MerchantNotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _NotificationItem(
          icon: Icons.check_circle,
          iconColor: const Color(0xFF16A34A),
          title: 'Merchant berhasil disetujui',
          subtitle: 'Kopi Nusantara telah aktif',
          time: '2 menit lalu',
        ),
        const SizedBox(height: 10),
        _NotificationItem(
          icon: Icons.warning_amber_rounded,
          iconColor: const Color(0xFFF59E0B),
          title: 'Merchant menunggu verifikasi',
          subtitle: 'Burger Jaya perlu dokumen tambahan',
          time: '15 menit lalu',
        ),
        const SizedBox(height: 10),
        _NotificationItem(
          icon: Icons.block,
          iconColor: const Color(0xFFEF4444),
          title: 'Merchant berhasil disuspend',
          subtitle: 'Ayam Bakar ID disuspend oleh admin',
          time: '1 jam lalu',
        ),
      ],
    );
  }
}

class _NotificationItem extends StatelessWidget {
  const _NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 9.5,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            iconSize: 16,
            onPressed: () {},
            icon: const Icon(Icons.close, color: Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }
}

class MerchantActivityTimeline extends StatelessWidget {
  const MerchantActivityTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TimelineItem(
          icon: Icons.check_circle,
          color: const Color(0xFF16A34A),
          title: 'Merchant Kopi Nusantara disetujui',
          time: '10 menit lalu',
        ),
        _TimelineItem(
          icon: Icons.edit,
          color: const Color(0xFF2563EB),
          title: 'Merchant Burger Jaya melakukan update profil',
          time: '25 menit lalu',
        ),
        _TimelineItem(
          icon: Icons.block,
          color: const Color(0xFFEF4444),
          title: 'Merchant Ayam Bakar ID disuspend',
          time: '1 jam lalu',
        ),
        _TimelineItem(
          icon: Icons.add_box,
          color: const Color(0xFF7C3AED),
          title: 'Merchant Pizza Mantap menambah produk baru',
          time: '2 jam lalu',
        ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.time,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF9CA3AF),
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

class MerchantVerificationSummary extends StatelessWidget {
  const MerchantVerificationSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _VerificationRow(
          label: 'Menunggu Verifikasi',
          value: '10',
          color: const Color(0xFFF59E0B),
          progress: 0.3,
        ),
        const SizedBox(height: 16),
        _VerificationRow(
          label: 'Disetujui Hari Ini',
          value: '8',
          color: const Color(0xFF16A34A),
          progress: 0.8,
        ),
        const SizedBox(height: 16),
        _VerificationRow(
          label: 'Ditolak Hari Ini',
          value: '2',
          color: const Color(0xFFEF4444),
          progress: 0.2,
        ),
      ],
    );
  }
}

class _VerificationRow extends StatelessWidget {
  const _VerificationRow({
    required this.label,
    required this.value,
    required this.color,
    required this.progress,
  });

  final String label;
  final String value;
  final Color color;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: const Color(0xFFE5E7EB),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class MerchantRevenueSummary extends StatelessWidget {
  const MerchantRevenueSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Total Pendapatan Merchant',
          style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
        ),
        const SizedBox(height: 6),
        const Text(
          'Rp 45.500.000',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        const Divider(height: 1),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Bulan Ini',
                    style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Rp 12.750.000',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.trending_up, size: 14, color: Color(0xFF16A34A)),
                  SizedBox(width: 4),
                  Text(
                    '+18%',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF16A34A),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 40,
          child: CustomPaint(painter: _MiniChartPainter(), child: Container()),
        ),
      ],
    );
  }
}

class _MiniChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0F8D55)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final points = [0.2, 0.5, 0.3, 0.7, 0.4, 0.8, 0.9];

    path.moveTo(0, size.height * (1 - points[0]));
    for (int i = 1; i < points.length; i++) {
      path.lineTo(
        size.width * i / (points.length - 1),
        size.height * (1 - points[i]),
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
