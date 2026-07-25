import 'package:menusisa_dev/super_admin/shared/widgets/admin_toast.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';
import '../../../providers/notifications_provider.dart';
import '../models/transaction_management_models.dart';
import '../widgets/transaction_metric_grid.dart';

// TODO: Supabase Integration IDs
// Table: transactions
// Columns: id (uuid), order_id (text), customer_id (uuid), merchant_id (uuid),
//          total (numeric), method (text), status (text), created_at (timestamp)
// RLS: Super Admin sees all, Merchant sees own, Customer sees own

class TransactionManagementPage extends StatefulWidget {
  const TransactionManagementPage({super.key});

  @override
  State<TransactionManagementPage> createState() => _TransactionManagementPageState();
}

class _TransactionManagementPageState extends State<TransactionManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  String _statusFilter = 'Semua';
  List<TransactionItem> _items = List.from(transactionItems);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MenuProvider>().setRoute(AppRoutes.transactions);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _addNotification(String title, String message, String type) {
    // TODO: Supabase Integration - Save notification
    context.read<NotificationsProvider>().addNotification({
      'title': title,
      'message': message,
      'type': type,
      'entity_type': 'transaction',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  List<TransactionItem> get _filteredItems {
    var filtered = List<TransactionItem>.from(_items);
    if (_statusFilter != 'Semua') {
      filtered = filtered.where((item) => item.status == _statusFilter).toList();
    }
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered
          .where((item) =>
              item.orderId.toLowerCase().contains(query) ||
              item.customer.toLowerCase().contains(query) ||
              item.merchant.toLowerCase().contains(query))
          .toList();
    }
    return filtered;
  }

  void _updateStatus(TransactionItem item, String newStatus) {
    setState(() {
      final index = _items.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _items[index] = TransactionItem(
          id: item.id,
          orderId: item.orderId,
          customer: item.customer,
          merchant: item.merchant,
          total: item.total,
          method: item.method,
          status: newStatus,
          time: item.time,
          date: item.date,
          items: item.items,
          notes: item.notes,
        );
      }
    });

    // TODO: Supabase - Update transactions table
    final message = 'Transaksi ${item.orderId} statusnya diubah menjadi $newStatus';
    _addNotification('Update Status Transaksi', message, 'transaction_status');
    AdminToast.show(context, 'Tindakan berhasil', type: AdminToastType.success);
  }

  @override
  Widget build(BuildContext context) {
    final sidebarCollapsed = context.watch<MenuProvider>().sidebarCollapsed;
    final filtered = _filteredItems;

    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = const EdgeInsets.fromLTRB(24, 18, 24, 20);

        return SingleChildScrollView(
          padding: padding,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeaderBar(),
                  const SizedBox(height: 14),

                  // Metric grid dengan data 0
                  _SectionCard(
                    child: TransactionMetricGrid(metrics: _zeroTransactionMetrics),
                  ),
                  const SizedBox(height: 14),

                  // Charts section - Two separate charts in boxes
                  _SectionCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAFAFA),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE5E7EB)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Grafik Transaksi Harian',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  height: 160,
                                  child: LineChart(
                                    LineChartData(
                                      minX: 1, maxX: 7, minY: 0, maxY: 100,
                                      gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 25, getDrawingHorizontalLine: (v) => const FlLine(color: Color(0xFFE5E7EB), strokeWidth: 1)),
                                      titlesData: FlTitlesData(
                                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28, interval: 25, getTitlesWidget: (v, m) => Text(v.toInt().toString(), style: const TextStyle(fontSize: 9, color: Color(0xFF6B7280))))),
                                        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 22, interval: 1, getTitlesWidget: (v, m) => Padding(padding: const EdgeInsets.only(top: 4), child: Text(v.toInt().toString(), style: const TextStyle(fontSize: 9, color: Color(0xFF6B7280)))))),
                                      ),
                                      borderData: FlBorderData(show: false),
                                      lineBarsData: [LineChartBarData(spots: const [FlSpot(1, 0), FlSpot(2, 0), FlSpot(3, 0), FlSpot(4, 0), FlSpot(5, 0), FlSpot(6, 0), FlSpot(7, 0)], isCurved: true, color: const Color(0xFF2563EB), barWidth: 2, isStrokeCapRound: true, dotData: FlDotData(show: true, getDotPainter: (s, p, b, i) => FlDotCirclePainter(radius: 2.5, color: const Color(0xFF2563EB), strokeWidth: 0)), belowBarData: BarAreaData(show: false))],
                                    ),
                                    duration: const Duration(milliseconds: 250),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAFAFA),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE5E7EB)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Metode Pembayaran',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  height: 160,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: PieChart(
                                          PieChartData(
                                            sectionsSpace: 0,
                                            centerSpaceRadius: 32,
                                            startDegreeOffset: -90,
                                            sections: [
                                              PieChartSectionData(color: const Color(0xFF0F8D55), value: 0, radius: 22, titleStyle: const TextStyle(fontSize: 0)),
                                              PieChartSectionData(color: const Color(0xFFF59E0B), value: 0, radius: 22, titleStyle: const TextStyle(fontSize: 0)),
                                              PieChartSectionData(color: const Color(0xFFEF4444), value: 0, radius: 22, titleStyle: const TextStyle(fontSize: 0)),
                                            ],
                                            borderData: FlBorderData(show: false),
                                          ),
                                          duration: const Duration(milliseconds: 250),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _ChartLegendTx(color: Color(0xFF0F8D55), label: 'QRIS', value: '0'),
                                            SizedBox(height: 8),
                                            _ChartLegendTx(color: Color(0xFFF59E0B), label: 'Transfer', value: '0'),
                                            SizedBox(height: 8),
                                            _ChartLegendTx(color: Color(0xFFEF4444), label: 'Tunai', value: '0'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Tabel Daftar Transaksi
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Daftar Transaksi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            SizedBox(
                              width: 260,
                              child: TextField(
                                controller: _searchController,
                                onChanged: (_) => setState(() {}),
                                decoration: InputDecoration(
                                  hintText: 'Cari transaksi...',
                                  hintStyle: const TextStyle(fontSize: 13),
                                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            _FilterButton(
                              currentFilter: _statusFilter,
                              onFilterChanged: (v) => setState(() => _statusFilter = v),
                              options: const [
                                'Semua',
                                'Berhasil',
                                'Pending',
                                'Diproses',
                                'Gagal',
                                'Dibatalkan'
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _TransactionDataTable(
                          items: filtered,
                          onStatusChanged: _updateStatus,
                          sidebarCollapsed: sidebarCollapsed,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HeaderBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Transaction Management',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Kelola semua transaksi yang terjadi pada platform. Pantau status, detail pembayaran, dan selesaikan pesanan.',
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

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

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.currentFilter,
    required this.onFilterChanged,
    required this.options,
  });

  final String currentFilter;
  final ValueChanged<String> onFilterChanged;
  final List<String> options;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.filter_list_rounded, size: 18),
            const SizedBox(width: 8),
            Text(
              currentFilter,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      onSelected: onFilterChanged,
      itemBuilder: (context) =>
          options.map((opt) => PopupMenuItem(value: opt, child: Text(opt))).toList(),
    );
  }
}

class _TransactionDataTable extends StatelessWidget {
  const _TransactionDataTable({
    required this.items,
    required this.onStatusChanged,
    this.sidebarCollapsed = true,
  });

  final List<TransactionItem> items;
  final Function(TransactionItem, String) onStatusChanged;
  final bool sidebarCollapsed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Menampilkan 1 - ${items.length} dari ${items.length} data',
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
              DataColumn(label: Text('Order ID')),
              DataColumn(label: Text('Customer')),
              DataColumn(label: Text('Merchant')),
              DataColumn(label: Text('Total')),
              DataColumn(label: Text('Metode')),
              DataColumn(label: Text('Waktu')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Aksi')),
            ],
            rows: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return DataRow(
                cells: [
                  DataCell(Text('${index + 1}')),
                  DataCell(
                    Text(
                      item.orderId,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  DataCell(Text(item.customer)),
                  DataCell(Text(item.merchant)),
                  DataCell(
                    Text(
                      item.total,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F8D55),
                      ),
                    ),
                  ),
                  DataCell(Text(item.method)),
                  DataCell(Text(item.time)),
                  DataCell(_StatusBadge(status: item.status)),
                  DataCell(
                    _ActionMenu(
                      item: item,
                      onStatusChanged: onStatusChanged,
                    ),
                  ),
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

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final config = switch (status) {
      'Berhasil' => (color: const Color(0xFF0F8D55), bg: const Color(0xFFD1FAE5)),
      'Pending' => (color: const Color(0xFFF59E0B), bg: const Color(0xFFFEF3C7)),
      'Diproses' => (color: const Color(0xFF0891B2), bg: const Color(0xFFE0F2FE)),
      'Gagal' => (color: const Color(0xFFEF4444), bg: const Color(0xFFFEE2E2)),
      'Dibatalkan' => (color: const Color(0xFF7C3AED), bg: const Color(0xFFEDE9FE)),
      _ => (color: const Color(0xFF6B7280), bg: const Color(0xFFF3F4F6)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: config.bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: config.color,
        ),
      ),
    );
  }
}

class _ActionMenu extends StatelessWidget {
  const _ActionMenu({
    required this.item,
    required this.onStatusChanged,
  });

  final TransactionItem item;
  final Function(TransactionItem, String) onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_rounded, size: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      offset: const Offset(0, 40),
      onSelected: (action) {
        switch (action) {
          case 'detail':
            showDialog<void>(
              context: context,
              builder: (_) => _TransactionDetailDialog(transaction: item),
            );
            break;
          case 'berhasil':
            onStatusChanged(item, 'Berhasil');
            break;
          case 'pending':
            onStatusChanged(item, 'Pending');
            break;
          case 'diproses':
            onStatusChanged(item, 'Diproses');
            break;
          case 'gagal':
            onStatusChanged(item, 'Gagal');
            break;
          case 'dibatalkan':
            onStatusChanged(item, 'Dibatalkan');
            break;
        }
      },
      itemBuilder: (context) => [
        _buildMenuItem(Icons.visibility_rounded, 'Detail Transaksi', 'detail'),
        _buildMenuItem(Icons.check_circle_rounded, 'Set Berhasil', 'berhasil'),
        _buildMenuItem(Icons.schedule_rounded, 'Set Pending', 'pending'),
        _buildMenuItem(Icons.sync_rounded, 'Set Diproses', 'diproses'),
        _buildMenuItem(Icons.cancel_rounded, 'Set Gagal', 'gagal'),
        _buildMenuItem(Icons.block_rounded, 'Set Dibatalkan', 'dibatalkan'),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(IconData icon, String label, String value) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF6B7280)),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF111827))),
        ],
      ),
    );
  }
}

class _TransactionDetailDialog extends StatelessWidget {
  const _TransactionDetailDialog({required this.transaction});

  final TransactionItem transaction;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Detail Transaksi',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, size: 20),
                  ),
                ],
              ),
              const Divider(height: 24),
              _DetailRow(label: 'Order ID', value: transaction.orderId),
              _DetailRow(label: 'Customer', value: transaction.customer),
              _DetailRow(label: 'Merchant', value: transaction.merchant),
              _DetailRow(label: 'Total', value: transaction.total),
              _DetailRow(label: 'Metode', value: transaction.method),
              _DetailRow(label: 'Status', value: transaction.status),
              _DetailRow(label: 'Tanggal', value: transaction.date),
              _DetailRow(label: 'Waktu', value: transaction.time),
              const SizedBox(height: 8),
              const Text('Item Pesanan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(transaction.items.join(', '), style: const TextStyle(fontSize: 12.5, color: Color(0xFF6B7280))),
              if (transaction.notes.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text('Catatan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(transaction.notes, style: const TextStyle(fontSize: 12.5, color: Color(0xFF6B7280))),
              ],
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Tutup'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontSize: 12.5, color: Color(0xFF6B7280))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
          ),
        ],
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
        Row(
          children: [
            const Text(
              '10 / halaman',
              style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.arrow_drop_down, size: 18),
            ),
          ],
        ),
        Row(
          children: [
            _PageButton(icon: Icons.chevron_left_rounded, onPressed: () {}),
            ...[1, 2, 3].map(
              (page) => _PageButton(label: '$page', isActive: page == 1, onPressed: () {}),
            ),
            _PageButton(icon: Icons.chevron_right_rounded, onPressed: () {}),
          ],
        ),
      ],
    );
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({
    this.label,
    this.icon,
    this.isActive = false,
    required this.onPressed,
  });

  final String? label;
  final IconData? icon;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: isActive ? const Color(0xFF0F8D55) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: isActive ? null : Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: icon != null
                ? Icon(icon, size: 18, color: isActive ? Colors.white : const Color(0xFF6B7280))
                : Text(
                    label!,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.white : const Color(0xFF374151),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// Zero metrics data
const _zeroTransactionMetrics = [
  TransactionMetric(
    title: 'Total Transaksi',
    value: '0',
    delta: '+0 dari kemarin',
    icon: 'payments',
    color: 0xFF2563EB,
  ),
  TransactionMetric(
    title: 'Transaksi Berhasil',
    value: '0',
    delta: '+0 dari kemarin',
    icon: 'check',
    color: 0xFF0F8D55,
  ),
  TransactionMetric(
    title: 'Transaksi Pending',
    value: '0',
    delta: '+0 dari kemarin',
    icon: 'hourglass',
    color: 0xFFF59E0B,
  ),
  TransactionMetric(
    title: 'Transaksi Gagal',
    value: '0',
    delta: '+0 dari kemarin',
    icon: 'close',
    color: 0xFFEF4444,
  ),
  TransactionMetric(
    title: 'Total Pendapatan',
    value: 'Rp 0',
    delta: '+0% dari kemarin',
    icon: 'money',
    color: 0xFF14B8A6,
  ),
  TransactionMetric(
    title: 'Refund Request',
    value: '0',
    delta: '+0 dari kemarin',
    icon: 'refund',
    color: 0xFF7C3AED,
  ),
];



class _ChartLegendTx extends StatelessWidget {
  const _ChartLegendTx({
    required this.color,
    required this.label,
    required this.value,
  });
  
  final Color color;
  final String label;
  final String value;
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}
