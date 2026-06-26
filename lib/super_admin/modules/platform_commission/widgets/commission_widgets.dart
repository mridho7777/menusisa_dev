import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/platform_commission_models.dart';

class CommissionSectionCard extends StatelessWidget {
  const CommissionSectionCard({super.key, required this.child});
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
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 18, offset: Offset(0, 6))],
      ),
      child: child,
    );
  }
}

class CommissionChartCard extends StatelessWidget {
  const CommissionChartCard({super.key, required this.progress});
  final double progress;

  static const _spots = <FlSpot>[
    FlSpot(0, 2), FlSpot(1, 6), FlSpot(2, 12), FlSpot(3, 8), FlSpot(4, 5),
    FlSpot(5, 9), FlSpot(6, 12), FlSpot(7, 10), FlSpot(8, 18), FlSpot(9, 15), FlSpot(10, 20),
  ];

  @override
  Widget build(BuildContext context) {
    final count = (_spots.length * progress).clamp(2, _spots.length).toInt();
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 10,
        minY: 0,
        maxY: 22,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 5,
          getDrawingHorizontalLine: (v) => const FlLine(color: Color(0xFFE5E7EB), strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              interval: 5,
              getTitlesWidget: (v, m) => Text('${v.toInt()}M', style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 2,
              getTitlesWidget: (v, m) {
                const labels = {
                  0: '21 Apr',
                  2: '26 Apr',
                  4: '1 Mei',
                  6: '10 Mei',
                  8: '16 Mei',
                  10: '20 Mei',
                };
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(labels[v.toInt()] ?? '', style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
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
                'Pendapatan: Rp ${(spot.y * 1000000).toInt()}',
                const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF111827)),
              );
            }).toList(),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: _spots.take(count).toList(),
            isCurved: true,
            color: const Color(0xFF0F8D55),
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (s, p, b, i) => FlDotCirclePainter(radius: 3.2, color: const Color(0xFF0F8D55), strokeWidth: 0),
            ),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 250),
    );
  }
}

class CommissionSettingsCard extends StatefulWidget {
  const CommissionSettingsCard({super.key, this.onSaved});
  final VoidCallback? onSaved;

  @override
  State<CommissionSettingsCard> createState() => _CommissionSettingsCardState();
}

class _CommissionSettingsCardState extends State<CommissionSettingsCard> {
  final controller = TextEditingController(text: '3');

  @override
  Widget build(BuildContext context) {
    final fee = int.tryParse(controller.text) ?? 3;
    const tx = 100000;
    final commission = tx * fee ~/ 100;
    final merchant = tx - commission;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Persentase Komisi (%)', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            suffixText: '%',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        _SimRow(label: 'Nilai Transaksi', value: 'Rp 100.000'),
        _SimRow(label: 'Komisi Platform', value: 'Rp ${commission.toStringAsFixed(0)}'),
        _SimRow(label: 'Pendapatan Merchant', value: 'Rp ${merchant.toStringAsFixed(0)}'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7ED),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFDE68A)),
          ),
          child: const Text(
            'Komisi akan diterapkan untuk semua transaksi baru setelah disimpan.',
            style: TextStyle(fontSize: 11.5, color: Color(0xFF92400E)),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: OutlinedButton(onPressed: () => controller.text = '3', child: const Text('Batal'))),
            const SizedBox(width: 10),
            Expanded(child: FilledButton(onPressed: widget.onSaved, child: const Text('Simpan Perubahan'))),
          ],
        ),
      ],
    );
  }
}

class _SimRow extends StatelessWidget {
  const _SimRow({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),),
          Text(value, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class CommissionSummaryCard extends StatelessWidget {
  const CommissionSummaryCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _SummaryRow(label: 'Total Pendapatan Komisi', value: 'Rp 25.450.000'),
        _SummaryRow(label: 'Rata-rata Komisi per Hari', value: 'Rp 821.000'),
        _SummaryRow(label: 'Komisi Tertinggi (1 Hari)', value: 'Rp 1.450.000'),
        _SummaryRow(label: 'Komisi Terendah (1 Hari)', value: 'Rp 450.000'),
        _SummaryRow(label: 'Transaksi Dikenakan Komisi', value: '2.860'),
        _SummaryRow(label: 'Payout ke Merchant', value: 'Rp 820.150.000'),
        SizedBox(height: 12),
        Text('Rasio Komisi terhadap Penjualan', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
        SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(999)),
          child: LinearProgressIndicator(
            value: 0.03,
            minHeight: 8,
            backgroundColor: Color(0xFFE5E7EB),
            valueColor: AlwaysStoppedAnimation(Color(0xFF0F8D55)),
          ),
        ),
        SizedBox(height: 6),
        Text('3%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 11.5, color: Color(0xFF6B7280))),),
          Text(value, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class CommissionToolbar extends StatelessWidget {
  const CommissionToolbar({super.key, required this.onReset, required this.onExport, required this.onMerchantChanged, required this.onPaymentChanged});
  final VoidCallback onReset;
  final VoidCallback onExport;
  final ValueChanged<String> onMerchantChanged;
  final ValueChanged<String> onPaymentChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _Dd(value: 'Semua Merchant', items: const ['Semua Merchant', 'Kopi Kita', 'Burger Enak'], onChanged: onMerchantChanged),
        _Dd(value: 'Semua Metode', items: const ['Semua Metode', 'QRIS', 'Transfer Bank', 'GoPay'], onChanged: onPaymentChanged),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
          child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.calendar_month_rounded, size: 16), SizedBox(width: 8), Text('01 Mei 2025 - 20 Mei 2025', style: TextStyle(fontSize: 12))]),
        ),
        OutlinedButton.icon(onPressed: onReset, icon: const Icon(Icons.refresh_rounded, size: 18), label: const Text('Reset Filter')),
        ElevatedButton.icon(onPressed: onExport, icon: const Icon(Icons.download_rounded, size: 18), label: const Text('Export Data')),
      ],
    );
  }
}

class _Dd extends StatelessWidget {
  const _Dd({required this.value, required this.items, required this.onChanged});
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12)))).toList(),
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
    );
  }
}

class CommissionTableCard extends StatelessWidget {
  const CommissionTableCard({super.key, required this.items, required this.onView});
  final List<CommissionTransactionItem> items;
  final ValueChanged<CommissionTransactionItem> onView;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: const WidgetStatePropertyAll(Color(0xFFF8FAFC)),
        columns: const [
          DataColumn(label: Text('No')),
          DataColumn(label: Text('Order ID')),
          DataColumn(label: Text('Tanggal')),
          DataColumn(label: Text('Merchant')),
          DataColumn(label: Text('Total Transaksi')),
          DataColumn(label: Text('Persentase Komisi')),
          DataColumn(label: Text('Komisi Platform')),
          DataColumn(label: Text('Metode Pembayaran')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Aksi')),
        ],
        rows: items.asMap().entries.map((e) {
          final i = e.key;
          final item = e.value;
          return DataRow(cells: [
            DataCell(Text('${i + 1}')),
            DataCell(Text(item.orderId)),
            DataCell(Text(item.date.replaceAll('\n', ' '))),
            DataCell(Text(item.merchant)),
            DataCell(Text(item.totalTransaction)),
            DataCell(Text(item.commissionRate)),
            DataCell(Text(item.platformCommission)),
            DataCell(Text(item.paymentMethod)),
            DataCell(_StatusBadge(status: item.status)),
            DataCell(IconButton(onPressed: () => onView(item), icon: const Icon(Icons.visibility_outlined, size: 18))),
          ]);
        }).toList(),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;
  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      'Sukses' => (const Color(0xFFD1FAE5), const Color(0xFF166534)),
      'Pending' => (const Color(0xFFFEF3C7), const Color(0xFF92400E)),
      'Gagal' => (const Color(0xFFFEE2E2), const Color(0xFFB91C1C)),
      _ => (const Color(0xFFE5E7EB), const Color(0xFF374151)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg)),
    );
  }
}

class CommissionTopMerchantCard extends StatelessWidget {
  const CommissionTopMerchantCard({super.key, required this.items});
  final List<CommissionTopMerchant> items;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [const Expanded(child: Text('Top Merchant (Berdasarkan Komisi)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700))), TextButton(onPressed: () {}, child: const Text('Lihat Semua'))]),
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    CircleAvatar(radius: 14, backgroundColor: Color(item.color).withValues(alpha: 0.16), child: Text(item.rank, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(item.color)))),
                    const SizedBox(width: 10),
                    Expanded(child: Text(item.name, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600))),
                    Text(item.commission, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class CommissionNotificationTray extends StatelessWidget {
  const CommissionNotificationTray({super.key, required this.items, required this.onClearAll});
  final List<CommissionNotification> items;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [const Expanded(child: Text('Notifikasi', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700))), TextButton(onPressed: onClearAll, child: const Text('Hapus Semua'))]),
          if (items.isEmpty)
            const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Center(child: Text('Belum ada notifikasi.')))
          else
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Color(item.color).withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: Color(item.color).withValues(alpha: 0.2))),
                    child: Row(
                      children: [
                        Icon(
                          switch (item.icon) {
                            'check' => Icons.check_circle_rounded,
                            'warning' => Icons.warning_rounded,
                            'cancel' => Icons.error_rounded,
                            _ => Icons.info_rounded,
                          },
                          color: Color(item.color),
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.title, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 2),
                              Text(item.subtitle, style: const TextStyle(fontSize: 10.5, color: Color(0xFF6B7280))),
                              const SizedBox(height: 4),
                              Text(item.time, style: const TextStyle(fontSize: 9.5, color: Color(0xFF9CA3AF))),
                            ],
                          ),
                        ),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.close, size: 16)),
                      ],
                    ),
                  ),
                )),
        ],
      ),
    );
  }
}
