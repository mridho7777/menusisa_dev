import 'package:menusisa_dev/super_admin/shared/widgets/admin_toast.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';
import '../../../shared/widgets/charts/reusable_charts.dart';
import '../controllers/dashboard_controller.dart';
import '../models/dashboard_models.dart';
import '../widgets/dashboard_metric_grid.dart';

// Dashboard aggregates data from multiple tables:
// - transactions (untuk recent transactions)
// - merchants (untuk top merchants)
// - products (untuk pending approvals)
// - notifications (untuk activity feed)
// Real-time subscriptions untuk auto-update metrics

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final String _statusFilter = 'Semua';
  String _chartFilter = '7 Hari Ke Depan';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MenuProvider>().setRoute(AppRoutes.dashboard);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DashboardTransaction> get _filteredTransactions {
    var filtered = List<DashboardTransaction>.from(dashboardTransactions);
    if (_statusFilter != 'Semua') {
      filtered = filtered.where((tx) => tx.status == _statusFilter).toList();
    }
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered
          .where((tx) =>
              tx.id.toLowerCase().contains(query) ||
              tx.customer.toLowerCase().contains(query) ||
              tx.merchant.toLowerCase().contains(query))
          .toList();
    }
    return filtered;
  }

  void _handleAction(String action, String transactionId) {
    AdminToast.show(context, 'Aksi $action untuk transaksi $transactionId');
  }

  List<DashboardMetric> _buildMetrics(Map<String, dynamic> dashboardData) {
    final merchants = Map<String, dynamic>.from(dashboardData['merchants'] ?? const {});
    final products = Map<String, dynamic>.from(dashboardData['products'] ?? const {});
    final transactions = Map<String, dynamic>.from(dashboardData['transactions'] ?? const {});
    return [
      DashboardMetric(title: 'Total Customer', value: '0', delta: '+0 hari ini', icon: 'people', color: 0xFF0F8D55),
      DashboardMetric(title: 'Total Merchant', value: '${merchants['total'] ?? 0}', delta: '+${merchants['active'] ?? 0} aktif', icon: 'store', color: 0xFFF59E0B),
      DashboardMetric(title: 'Total Produk', value: '${products['total'] ?? 0}', delta: '+${products['approved'] ?? 0} approved', icon: 'inventory_2', color: 0xFF1D4ED8),
      DashboardMetric(title: 'Total Pesanan', value: '${transactions['total'] ?? 0}', delta: '+${transactions['today'] ?? 0} hari ini', icon: 'shopping_cart', color: 0xFF7C3AED),
      DashboardMetric(title: 'Total Transaksi', value: '${transactions['total'] ?? 0}', delta: '+${transactions['today'] ?? 0} hari ini', icon: 'payments', color: 0xFF0F766E),
      DashboardMetric(title: 'Pendapatan Platform', value: 'Rp 0', delta: '+0% dari kemarin', icon: 'savings', color: 0xFFEF4444),
    ];
  }

  List<FlSpot> _buildTransactionSpots(Map<String, dynamic> dashboardData) {
    final daily = List<Map<String, dynamic>>.from((dashboardData['transactions']?['daily'] as List<dynamic>?) ?? const []);
    return daily.asMap().entries.map((entry) => FlSpot((entry.key + 1).toDouble(), (entry.value['count'] as num?)?.toDouble() ?? 0)).toList();
  }

  List<String> _buildTransactionLabels(Map<String, dynamic> dashboardData) {
    final daily = List<Map<String, dynamic>>.from((dashboardData['transactions']?['daily'] as List<dynamic>?) ?? const []);
    return daily.map((item) {
      final parsed = DateTime.tryParse(item['date']?.toString() ?? '');
      return parsed == null ? '-' : '${parsed.day.toString().padLeft(2, '0')} ${_monthName(parsed.month)}';
    }).toList();
  }

  List<PieChartSectionData> _buildPaymentSections(Map<String, dynamic> dashboardData) {
    final paymentMethods = Map<String, dynamic>.from((dashboardData['transactions']?['payment_methods'] as Map?) ?? const {});
    final qris = (paymentMethods['QRIS'] as num?)?.toDouble() ?? 0;
    final bank = (paymentMethods['Transfer Bank'] as num?)?.toDouble() ?? 0;
    final cod = (paymentMethods['Cash'] as num?)?.toDouble() ?? (paymentMethods['Bayar di Tempat'] as num?)?.toDouble() ?? 0;
    return [
      PieChartSectionData(color: const Color(0xFF0F8D55), value: qris, radius: 24, titleStyle: const TextStyle(fontSize: 0)),
      PieChartSectionData(color: const Color(0xFFF59E0B), value: bank, radius: 24, titleStyle: const TextStyle(fontSize: 0)),
      PieChartSectionData(color: const Color(0xFFEF4444), value: cod, radius: 24, titleStyle: const TextStyle(fontSize: 0)),
    ];
  }

  String _monthName(int month) => const ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'][month - 1];

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DashboardController>();
    final filtered = _filteredTransactions;
    final dashboardData = controller.dashboardData;
    final metrics = _buildMetrics(dashboardData);
    final transactionSpots = _buildTransactionSpots(dashboardData);
    final transactionLabels = _buildTransactionLabels(dashboardData);
    final paymentSections = _buildPaymentSections(dashboardData);
    final paymentMethods = Map<String, dynamic>.from((dashboardData['transactions']?['payment_methods'] as Map?) ?? const {});

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
                  _HeaderBar(
                    value: controller.globalFilter,
                    onChanged: controller.setGlobalFilter,
                  ),
                  const SizedBox(height: 14),

                  // Metrics dari Supabase
                  _SectionCard(
                    child: DashboardMetricGrid(
                      metrics: metrics,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Charts section dengan komponen baru
                  DualChartWrapper(
                    leftChart: ReusableLineChart(
                      title: 'Grafik Transaksi',
                      filter: _chartFilter,
                      onFilterChanged: (value) {
                        setState(() => _chartFilter = value);
                      },
                      dataKey: 'Transaksi',
                      spots: transactionSpots,
                      labels: transactionLabels,
                      supabaseTable: 'transactions',
                      supabaseQuery: 'SELECT DATE(created_at) as date, COUNT(*) as count FROM transactions WHERE created_at >= NOW() AND created_at <= NOW() + INTERVAL \'7 days\' GROUP BY date ORDER BY date',
                    ),
                    rightChart: ReusableDonutChart(
                      title: 'Metode Pembayaran',
                      legendItems: [
                        DonutChartLegendItem(
                          color: Color(0xFF0F8D55),
                          title: 'QRIS (Barcode)',
                          value: '${paymentMethods['QRIS'] ?? 0} (${paymentMethods['QRIS'] ?? 0}%)',
                        ),
                        DonutChartLegendItem(
                          color: Color(0xFFF59E0B),
                          title: 'Transfer Bank',
                          value: '${paymentMethods['Transfer Bank'] ?? 0} (${paymentMethods['Transfer Bank'] ?? 0}%)',
                        ),
                        DonutChartLegendItem(
                          color: Color(0xFFEF4444),
                          title: 'Bayar di Tempat',
                          value: '${paymentMethods['Cash'] ?? paymentMethods['Bayar di Tempat'] ?? 0} (${paymentMethods['Cash'] ?? paymentMethods['Bayar di Tempat'] ?? 0}%)',
                        ),
                      ],
                      sections: paymentSections,
                      supabaseTable: 'transactions',
                      supabaseQuery: 'SELECT payment_method, COUNT(*) as count FROM transactions GROUP BY payment_method',
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Tabel Transaksi Terbaru - Desain seperti Merchant Management
                  _SectionCard(
                    child: _TransactionDataTable(
                      items: filtered,
                      onAction: _handleAction,
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
  const _HeaderBar({
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Ringkasan aktivitas dan performa platform secara real-time',
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        PopupMenuButton<String>(
          onSelected: onChanged,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_drop_down, size: 18),
              ],
            ),
          ),
          itemBuilder: (context) => [
            'Hari Ini',
            '7 Hari Terakhir',
            '30 Hari Terakhir',
            'Bulan Ini',
          ].map((opt) => PopupMenuItem(value: opt, child: Text(opt))).toList(),
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
      child: child,
    );
  }
}

class _TransactionDataTable extends StatelessWidget {
  const _TransactionDataTable({
    required this.items,
    required this.onAction,
  });

  final List<DashboardTransaction> items;
  final Function(String action, String transactionId) onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Transaksi Terbaru',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
            Text(
              'Menampilkan 1 - ${items.length} dari ${items.length} data',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: items.isEmpty
                    ? Container(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            const Icon(Icons.receipt_long_outlined, size: 64, color: Colors.black12),
                            const SizedBox(height: 16),
                            const Text('Belum ada transaksi', style: TextStyle(color: Colors.black38, fontSize: 16, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      )
                    : DataTable(
                        headingRowColor: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
                        headingTextStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF374151)),
                        dataTextStyle: const TextStyle(fontSize: 13, color: Color(0xFF111827)),
                        columnSpacing: 24,
                        horizontalMargin: 16,
                        dataRowMinHeight: 56,
                        dataRowMaxHeight: 56,
                        columns: const [
                          DataColumn(label: Text('ID Transaksi')),
                          DataColumn(label: Text('Customer')),
                          DataColumn(label: Text('Merchant')),
                          DataColumn(label: Text('Jumlah')),
                          DataColumn(label: Text('Metode')),
                          DataColumn(label: Text('Waktu')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Aksi')),
                        ],
                        rows: items.map((tx) {
                          return DataRow(
                            cells: [
                              DataCell(Text(tx.id)),
                              DataCell(Text(tx.customer)),
                              DataCell(Text(tx.merchant, style: const TextStyle(fontWeight: FontWeight.w600))),
                              DataCell(Text(tx.total, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0F8D55)))),
                              DataCell(Text(tx.method)),
                              DataCell(Text(tx.time)),
                              DataCell(_StatusBadge(status: tx.status)),
                              DataCell(_ActionMenu(transactionId: tx.id, onAction: onAction)),
                            ],
                          );
                        }).toList(),
                      ),
              ),
            );
          }
        ),
        const SizedBox(height: 16),
        const _PaginationControls(),
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
      'Selesai' => (color: const Color(0xFF0F8D55), bg: const Color(0xFFD1FAE5)),
      'Pending' => (color: const Color(0xFFF59E0B), bg: const Color(0xFFFEF3C7)),
      'Gagal' => (color: const Color(0xFFEF4444), bg: const Color(0xFFFEE2E2)),
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
    required this.transactionId,
    required this.onAction,
  });

  final String transactionId;
  final Function(String action, String transactionId) onAction;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_rounded, size: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      offset: const Offset(0, 40),
      onSelected: (action) => onAction(action, transactionId),
      itemBuilder: (context) => [
        _buildMenuItem(Icons.visibility_rounded, 'Detail Transaksi', 'detail'),
        _buildMenuItem(Icons.receipt_rounded, 'Cetak Struk', 'print'),
        _buildMenuItem(Icons.check_circle_rounded, 'Konfirmasi', 'confirm'),
        _buildMenuItem(Icons.cancel_rounded, 'Batalkan', 'cancel'),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(
    IconData icon,
    String label,
    String value, {
    bool isDestructive = false,
  }) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isDestructive ? const Color(0xFFEF4444) : const Color(0xFF6B7280),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isDestructive ? const Color(0xFFEF4444) : const Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaginationControls extends StatelessWidget {
  const _PaginationControls();

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
            ...[1, 2, 3].map((page) {
              return _PageButton(
                label: '$page',
                isActive: page == 1,
                onPressed: () {},
              );
            }),
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


