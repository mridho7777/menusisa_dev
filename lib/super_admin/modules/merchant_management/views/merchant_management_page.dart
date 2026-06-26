import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';
import '../models/merchant_management_models.dart';
import '../widgets/merchant_content_widgets.dart';

class MerchantManagementPage extends StatefulWidget {
  const MerchantManagementPage({super.key});

  @override
  State<MerchantManagementPage> createState() => _MerchantManagementPageState();
}

class _MerchantManagementPageState extends State<MerchantManagementPage>
    with TickerProviderStateMixin {
  late final AnimationController chartController;
  String _search = '';
  String _chartFilter = '30 Hari Terakhir';

  final _rows = const [
    _MerchantRow('1', 'M-001', 'Kopi Kita', 'Andi', 'andi@kopikita.id', '0812-1111-1111', 'Aktif', '12 Mei 2025', '18', 'Rp 8.250.000'),
    _MerchantRow('2', 'M-002', 'Burger Enak', 'Budi', 'budi@burgerenak.id', '0813-2222-2222', 'Pending', '11 Mei 2025', '12', 'Rp 6.750.000'),
    _MerchantRow('3', 'M-003', 'Ayam Geprek 99', 'Siti', 'siti@geprek99.id', '0814-3333-3333', 'Suspend', '10 Mei 2025', '11', 'Rp 5.450.000'),
    _MerchantRow('4', 'M-004', 'Pizza Mantap', 'Dina', 'dina@pizzamantap.id', '0815-4444-4444', 'Nonaktif', '9 Mei 2025', '9', 'Rp 4.850.000'),
    _MerchantRow('5', 'M-005', 'Sushi Premium', 'Raka', 'raka@sushipremium.id', '0816-5555-5555', 'Aktif', '8 Mei 2025', '7', 'Rp 3.950.000'),
  ];

  @override
  void initState() {
    super.initState();
    chartController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MenuProvider>().setRoute(AppRoutes.merchants);
    });
  }

  @override
  void dispose() {
    chartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sidebarCollapsed = context.watch<MenuProvider>().sidebarCollapsed;
    final filteredRows = _rows.where((row) {
      final q = _search.toLowerCase();
      return q.isEmpty ||
          row.shop.toLowerCase().contains(q) ||
          row.owner.toLowerCase().contains(q) ||
          row.email.toLowerCase().contains(q);
    }).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = constraints.maxWidth;
        final padding = contentWidth < 900
            ? const EdgeInsets.fromLTRB(16, 16, 16, 18)
            : const EdgeInsets.fromLTRB(24, 18, 24, 20);
        final statsColumns = sidebarCollapsed ? 3 : 2;
        final tableCompact = contentWidth < 1280;

        return SingleChildScrollView(
          padding: padding,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _HeaderBar(),
                  const SizedBox(height: 14),
                  _SectionShell(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: merchantMetrics.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: statsColumns,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: sidebarCollapsed ? 4.2 : 4.0,
                      ),
                      itemBuilder: (context, index) => _MetricCard(metric: merchantMetrics[index]),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _SectionShell(
                    child: LayoutBuilder(
                      builder: (context, sectionConstraints) {
                        final stacked = !sidebarCollapsed || sectionConstraints.maxWidth < 1180;
                        if (stacked) {
                          return Column(
                            children: [
                              _PanelCard(
                                title: 'Grafik Pendaftaran Merchant',
                                trailing: _FilterChip(value: _chartFilter, onChanged: (value) => setState(() => _chartFilter = value)),
                                height: 320,
                                child: MerchantRegistrationChart(progress: chartController.value),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(child: _PanelCard(title: 'Distribusi Status Merchant', height: 320, child: MerchantDistributionDonut(progress: chartController.value))),
                                  const SizedBox(width: 14),
                                  Expanded(child: _PanelCard(title: 'Merchant Terlaris', actionLabel: 'Lihat Semua', height: 320, child: MerchantTopList(items: merchantTopMerchants))),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(child: _PanelCard(title: 'Daftar Notifikasi Merchant', height: 300, child: const MerchantNotificationList())),
                                  const SizedBox(width: 14),
                                  Expanded(child: _PanelCard(title: 'Aktivitas Terbaru Merchant', height: 300, child: const MerchantActivityTimeline())),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(child: _PanelCard(title: 'Ringkasan Verifikasi Merchant', height: 240, child: const MerchantVerificationSummary())),
                                  const SizedBox(width: 14),
                                  Expanded(child: _PanelCard(title: 'Ringkasan Pendapatan Merchant', height: 240, child: const MerchantRevenueSummary())),
                                ],
                              ),
                            ],
                          );
                        }
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(flex: 6, child: _PanelCard(title: 'Grafik Pendaftaran Merchant', trailing: _FilterChip(value: _chartFilter, onChanged: (value) => setState(() => _chartFilter = value)), height: 320, child: MerchantRegistrationChart(progress: chartController.value))),
                                const SizedBox(width: 14),
                                Expanded(flex: 3, child: _PanelCard(title: 'Distribusi Status Merchant', height: 320, child: MerchantDistributionDonut(progress: chartController.value))),
                                const SizedBox(width: 14),
                                Expanded(flex: 3, child: _PanelCard(title: 'Merchant Terlaris', actionLabel: 'Lihat Semua', height: 320, child: MerchantTopList(items: merchantTopMerchants))),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(child: _PanelCard(title: 'Daftar Notifikasi Merchant', height: 300, child: const MerchantNotificationList())),
                                const SizedBox(width: 14),
                                Expanded(child: _PanelCard(title: 'Aktivitas Terbaru Merchant', height: 300, child: const MerchantActivityTimeline())),
                                const SizedBox(width: 14),
                                Expanded(child: _PanelCard(title: 'Ringkasan Verifikasi Merchant', height: 300, child: const MerchantVerificationSummary())),
                                const SizedBox(width: 14),
                                Expanded(child: _PanelCard(title: 'Ringkasan Pendapatan Merchant', height: 300, child: const MerchantRevenueSummary())),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 14),
                  _ActionBar(
                    search: _search,
                    onSearchChanged: (value) => setState(() => _search = value),
                  ),
                  const SizedBox(height: 14),
                  _SectionShell(
                    child: _MerchantTable(rows: filteredRows, compact: tableCompact),
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
  const _HeaderBar();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Merchant Management', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
              SizedBox(height: 3),
              Text('Kelola seluruh merchant dan status verifikasi', style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
            ],
          ),
        ),
        SizedBox(width: 12),
      ],
    );
  }
}

class _SectionShell extends StatelessWidget {
  const _SectionShell({required this.child});
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

class _PanelCard extends StatelessWidget {
  const _PanelCard({required this.title, required this.child, this.height, this.trailing, this.actionLabel});
  final String title;
  final Widget child;
  final double? height;
  final Widget? trailing;
  final String? actionLabel;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: SizedBox(
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700))),
                if (actionLabel != null) TextButton(onPressed: () {}, child: Text(actionLabel!)),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 12),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});
  final MerchantMetric metric;
  @override
  Widget build(BuildContext context) {
    final icon = switch (metric.icon) {
      'people' => Icons.person_rounded,
      'store' => Icons.store_rounded,
      'pending' => Icons.pending_actions_rounded,
      'lock' => Icons.lock_rounded,
      'close' => Icons.cancel_rounded,
      'verified' => Icons.verified_rounded,
      'trending' => Icons.trending_up_rounded,
      _ => Icons.store_rounded,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(color: Color(metric.color), borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(metric.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, color: Color(0xFF374151))),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Flexible(child: Text(metric.value, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
                    const SizedBox(width: 12),
                    Flexible(child: Text(metric.delta, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF16A34A)))),
                  ],
                ),
              ],
            ),
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
            .map((item) => DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(fontSize: 12))))
            .toList(),
        onChanged: (item) { if (item != null) onChanged(item); },
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.search, required this.onSearchChanged});
  final String search;
  final ValueChanged<String> onSearchChanged;
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
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onSearchChanged,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search_rounded),
                hintText: 'Cari nama toko, email, pemilik...',
                border: OutlineInputBorder(borderSide: BorderSide.none),
                filled: true,
                fillColor: Color(0xFFF8FAFC),
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.add_rounded), label: const Text('Tambah Merchant')),
          const SizedBox(width: 10),
          OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.download_rounded), label: const Text('Export Data')),
        ],
      ),
    );
  }
}

class _MerchantTable extends StatelessWidget {
  const _MerchantTable({required this.rows, required this.compact});
  final List<_MerchantRow> rows;
  final bool compact;
  @override
  Widget build(BuildContext context) {
    final columns = const ['No', 'ID Merchant', 'Nama Toko', 'Pemilik', 'Email', 'No HP', 'Status', 'Tanggal Daftar', 'Total Produk', 'Total Penjualan', 'Aksi'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: const WidgetStatePropertyAll(Color(0xFFF8FAFC)),
        columns: columns.map((e) => DataColumn(label: Text(e))).toList(),
        rows: rows.map((row) {
          return DataRow(cells: [
            DataCell(Text(row.no)),
            DataCell(Text(row.id)),
            DataCell(Text(row.shop)),
            DataCell(Text(row.owner)),
            DataCell(Text(row.email)),
            DataCell(Text(row.phone)),
            DataCell(_StatusBadge(status: row.status)),
            DataCell(Text(row.date)),
            DataCell(Text(row.products)),
            DataCell(Text(row.sales)),
            DataCell(
              Row(
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.visibility_outlined)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.edit_outlined)),
                  PopupMenuButton<String>(
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'detail', child: Text('Detail Merchant')),
                      PopupMenuItem(value: 'edit', child: Text('Edit Merchant')),
                      PopupMenuItem(value: 'products', child: Text('Lihat Produk')),
                      PopupMenuItem(value: 'approve', child: Text('Approve Merchant')),
                      PopupMenuItem(value: 'suspend', child: Text('Suspend Merchant')),
                      PopupMenuItem(value: 'inactive', child: Text('Nonaktifkan Merchant')),
                      PopupMenuItem(value: 'delete', child: Text('Hapus Merchant')),
                    ],
                  ),
                ],
              ),
            ),
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
      'Aktif' => (const Color(0xFFDCFCE7), const Color(0xFF166534)),
      'Pending' => (const Color(0xFFFEF3C7), const Color(0xFF92400E)),
      'Suspend' => (const Color(0xFFFEE2E2), const Color(0xFFB91C1C)),
      _ => (const Color(0xFFE5E7EB), const Color(0xFF374151)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg)),
    );
  }
}

class _MerchantRow {
  const _MerchantRow(this.no, this.id, this.shop, this.owner, this.email, this.phone, this.status, this.date, this.products, this.sales);
  final String no, id, shop, owner, email, phone, status, date, products, sales;
}

class MerchantTopList extends StatelessWidget {
  const MerchantTopList({super.key, required this.items});
  final List<MerchantTopMerchant> items;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              CircleAvatar(radius: 14, backgroundColor: Color(item.color).withOpacity(0.16), child: Text(item.rank, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(item.color)))),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item.name, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)), const SizedBox(height: 2), Text(item.orders, style: const TextStyle(fontSize: 10.5, color: Color(0xFF6B7280)))])),
              Text(item.revenue, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

