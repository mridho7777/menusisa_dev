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
          SizedBox(height: 280, child: _ChartArea(progress: progress)),
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
        value: 0 * progress,
        radius: 28,
        titleStyle: const TextStyle(fontSize: 0),
      ),
      PieChartSectionData(
        color: const Color(0xFFF59E0B),
        value: 0 * progress,
        radius: 28,
        titleStyle: const TextStyle(fontSize: 0),
      ),
      PieChartSectionData(
        color: const Color(0xFFEF4444),
        value: 0 * progress,
        radius: 28,
        titleStyle: const TextStyle(fontSize: 0),
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
                      centerSpaceRadius: 52,
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
                      'Rp 0',
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
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    item.note,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
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
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F8D55),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Updated: Modern DataTable for Revenue - Hanya aksi Hapus
class RevenueTableCard extends StatelessWidget {
  const RevenueTableCard({
    super.key,
    required this.items,
    required this.onDelete,
  });

  final List<RevenueItem> items;
  final ValueChanged<RevenueItem> onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Menampilkan ${items.length} dari ${items.length} data',
              style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
            headingTextStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF374151),
            ),
            dataTextStyle: const TextStyle(
              fontSize: 13,
              color: Color(0xFF111827),
            ),
            columnSpacing: 24,
            horizontalMargin: 16,
            dataRowMinHeight: 56,
            dataRowMaxHeight: 56,
            columns: const [
              DataColumn(label: Text('No.')),
              DataColumn(label: Text('Tanggal')),
              DataColumn(label: Text('Sumber')),
              DataColumn(label: Text('Kategori')),
              DataColumn(label: Text('Nilai')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Aksi')),
            ],
            rows: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return DataRow(
                cells: [
                  DataCell(Text('${index + 1}')),
                  DataCell(Text(item.date)),
                  DataCell(
                    Text(
                      item.source,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  DataCell(Text(item.category)),
                  DataCell(
                    Text(
                      item.value,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F8D55),
                      ),
                    ),
                  ),
                  DataCell(_StatusBadge(status: item.status)),
                  DataCell(_ActionMenu(
                    item: item,
                    onDelete: onDelete,
                  )),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        _PaginationControls(totalItems: items.length),
      ],
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
                  'Notifikasi Revenue',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
              TextButton(
                onPressed: onClearAll,
                child: const Text('Bersihkan Semua', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...items.map((notif) => _NotificationItem(notification: notif)),
        ],
      ),
    );
  }
}

// Updated _ActionMenu - Hanya tombol Hapus
class _ActionMenu extends StatelessWidget {
  const _ActionMenu({
    required this.item,
    required this.onDelete,
  });

  final RevenueItem item;
  final ValueChanged<RevenueItem> onDelete;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete_rounded, size: 20, color: Color(0xFFEF4444)),
      onPressed: () => onDelete(item),
      tooltip: 'Hapus',
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    switch (status) {
      case 'Terverifikasi':
        bgColor = const Color(0xFFD1FAE5);
        textColor = const Color(0xFF059669);
        break;
      case 'Pending':
        bgColor = const Color(0xFFFEF3C7);
        textColor = const Color(0xFFF59E0B);
        break;
      default:
        bgColor = const Color(0xFFF3F4F6);
        textColor = const Color(0xFF6B7280);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

class _PaginationControls extends StatelessWidget {
  const _PaginationControls({required this.totalItems});

  final int totalItems;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Halaman 1 dari 1',
          style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, size: 20),
              onPressed: null,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, size: 20),
              onPressed: null,
            ),
          ],
        ),
      ],
    );
  }
}

class _NotificationItem extends StatelessWidget {
  const _NotificationItem({required this.notification});

  final RevenueNotification notification;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Color(notification.color).withValues(alpha: 0.16),
            child: Icon(
              notification.icon == 'check' ? Icons.check_rounded : Icons.info_rounded,
              size: 18,
              color: Color(notification.color),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  notification.subtitle,
                  style: const TextStyle(fontSize: 11.5, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          Text(
            notification.time,
            style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
          ),
        ],
      ),
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
          title: 'Komisi Transaksi',
          value: '0 (0%)',
        ),
        SizedBox(height: 14),
        _LegendItem(
          color: Color(0xFFF59E0B),
          title: 'Biaya Langganan',
          value: '0 (0%)',
        ),
        SizedBox(height: 14),
        _LegendItem(
          color: Color(0xFFEF4444),
          title: 'Lainnya',
          value: '0 (0%)',
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
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontSize: 10.5, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChartArea extends StatelessWidget {
  const _ChartArea({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: 1,
        maxX: 7,
        minY: 0,
        maxY: 100,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 20,
          getDrawingHorizontalLine: (value) =>
              const FlLine(color: Color(0xFFE5E7EB), strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 38,
              interval: 20,
              getTitlesWidget: (value, meta) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
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
                  1: 'Sen',
                  2: 'Sel',
                  3: 'Rab',
                  4: 'Kam',
                  5: 'Jum',
                  6: 'Sab',
                  7: 'Min',
                };
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    labels[value.toInt()] ?? '',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(1, 0),
              FlSpot(2, 0),
              FlSpot(3, 0),
              FlSpot(4, 0),
              FlSpot(5, 0),
              FlSpot(6, 0),
              FlSpot(7, 0),
            ],
            isCurved: true,
            color: const Color(0xFF0F8D55),
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(radius: 3.5, color: const Color(0xFF0F8D55)),
            ),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_drop_down, size: 18),
          ],
        ),
      ),
      itemBuilder: (context) => [
        '30 Hari Terakhir',
        '7 Hari Terakhir',
        'Hari Ini',
      ].map((opt) => PopupMenuItem(value: opt, child: Text(opt))).toList(),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        value,
        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
      ),
    );
  }
}
