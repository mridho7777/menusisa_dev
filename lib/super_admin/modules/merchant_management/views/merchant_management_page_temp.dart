import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';
import '../../../providers/merchant_provider.dart';
import '../models/merchant_management_models.dart';
import '../widgets/merchant_content_widgets.dart'
    show MerchantDistributionDonut, MerchantRegistrationChart;
import '../widgets/merchant_footer_sections.dart';
import '../widgets/merchant_table_section.dart';

class MerchantManagementPage extends StatefulWidget {
  const MerchantManagementPage({super.key});
  @override
  State<MerchantManagementPage> createState() => _MerchantManagementPageState();
}

class _MerchantManagementPageState extends State<MerchantManagementPage>
    with TickerProviderStateMixin {
  late final AnimationController chartController;
  final TextEditingController _searchController = TextEditingController();
  String _chartFilter = '7 Hari Terakhir';
  String _categoryFilter = 'Semua Kategori';
  String _dateFilter = 'Tanggal Daftar';

  @override
  void initState() {
    super.initState();
    chartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<MenuProvider>().setRoute(AppRoutes.merchants);
    });
  }

  @override
  void dispose() {
    chartController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sidebarCollapsed = context.watch<MenuProvider>().sidebarCollapsed;
    final merchantProvider = context.watch<MerchantProvider>();
    final filtered = merchantProvider.filteredMerchants;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final compact = width < 1180;
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            width < 900 ? 16 : 24,
            18,
            width < 900 ? 16 : 24,
            20,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _HeaderBar(),
                  const SizedBox(height: 14),
                  
                  // Tabel dengan toolbar di dalamnya
                  _SectionShell(
                    child: Column(
                      children: [
                        _ToolbarRow(
                          searchController: _searchController,
                          selectedStatus: merchantProvider.statusFilter,
                          selectedCategory: _categoryFilter,
                          selectedDate: _dateFilter,
                          onSearchChanged: merchantProvider.setSearchQuery,
                          onStatusChanged: merchantProvider.setStatusFilter,
                          onCategoryChanged: (v) {
                            setState(() => _categoryFilter = v);
                            _toast('Filter kategori $v siap digunakan');
                          },
                          onDateChanged: (v) {
                            setState(() => _dateFilter = v);
                            _toast('Filter tanggal $v siap digunakan');
                          },
                          onReset: () {
                            _searchController.clear();
                            merchantProvider.setSearchQuery('');
                            merchantProvider.setStatusFilter('Semua');
                            setState(() {
                              _categoryFilter = 'Semua Kategori';
                              _dateFilter = 'Tanggal Daftar';
                            });
                            _toast('Filter telah direset');
                          },
                        ),
                        const SizedBox(height: 14),
                        MerchantDataTableSection(
                          rows: filtered
                              .map((m) => MerchantRowData(
                                    (filtered.indexOf(m) + 1).toString(),
                                    m.id,
                                    m.shopName,
                                    m.ownerName,
                                    m.email,
                                    m.phone,
                                    m.status,
                                    m.registeredAt,
                                    m.totalProducts,
                                    m.totalSales,
                                  ))
                              .toList(),
                          onAction: (msg) => _toast(msg),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  
                  _MetricsGrid(compact: compact),
                  const SizedBox(height: 14),
                  
                  _ChartsRow(
                    chartFilter: _chartFilter,
                    onChartFilterChanged: (v) {
                      setState(() => _chartFilter = v);
                      chartController.reset();
                      chartController.forward();
                    },
                    chartController: chartController,
                    stacked: compact,
                  ),
                  const SizedBox(height: 14),
                  
                  // Layout footer baru dengan responsive grid
                  _ResponsiveFooterLayout(
                    sidebarCollapsed: sidebarCollapsed,
                    width: width,
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
  Widget build(BuildContext context) => const Row(
        children: [
          Text(
            'Daftar Merchant',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
        ],
      );
}

class _SectionShell extends StatelessWidget {
  const _SectionShell({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              offset: Offset(0, 1),
              blurRadius: 3,
            ),
          ],
        ),
        child: child,
      );
}

// Responsive Footer Layout dengan grid 3-2
class _ResponsiveFooterLayout extends StatelessWidget {
  const _ResponsiveFooterLayout({
    required this.sidebarCollapsed,
    required this.width,
  });
  
  final bool sidebarCollapsed;
  final double width;
  
  @override
  Widget build(BuildContext context) {
    // Jika sidebar terbuka atau layar sempit, tampilkan vertikal
    final showVertical = !sidebarCollapsed || width < 1280;
    
    if (showVertical) {
      return Column(
        children: [
          _CombinedTopMerchantNotification(),
          const SizedBox(height: 14),
          _FooterCardShell(
            title: 'Aktivitas Terbaru Merchant',
            child: const MerchantRecentActivityList(),
          ),
          const SizedBox(height: 14),
          _CombinedVerificationRevenue(),
        ],
      );
    }
    
    // Layout horizontal 3 kolom + 2 kolom
    return Column(
      children: [
        // Baris pertama: 3 kolom
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _FooterCardShell(
                title: 'Top 5 Merchant',
                child: MerchantTopMerchantList(
                  items: _mockTopMerchants,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _FooterCardShell(
                title: 'Notifikasi Merchant',
                child: const MerchantNotificationList(),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _FooterCardShell(
                title: 'Aktivitas Terbaru Merchant',
                child: const MerchantRecentActivityList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        
        // Baris kedua: 2 kolom
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _FooterCardShell(
                title: 'Ringkasan Verifikasi Merchant',
                child: const MerchantVerificationSummary(),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _FooterCardShell(
                title: 'Ringkasan Pendapatan Merchant',
                child: const MerchantRevenueSummary(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Widget gabungan Top Merchant + Notifikasi
class _CombinedTopMerchantNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: MerchantFooterPanel(
              title: 'Top 5 Merchant',
              child: MerchantTopMerchantList(
                items: _mockTopMerchants,
              ),
            ),
          ),
          Container(
            width: 1,
            height: 280,
            margin: const EdgeInsets.symmetric(horizontal: 14),
            color: const Color(0xFFE5E7EB),
          ),
          Expanded(
            child: MerchantFooterPanel(
              title: 'Notifikasi Merchant',
              child: const MerchantNotificationList(),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget gabungan Verifikasi + Pendapatan
class _CombinedVerificationRevenue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: MerchantFooterPanel(
              title: 'Ringkasan Verifikasi Merchant',
              child: const MerchantVerificationSummary(),
            ),
          ),
          Container(
            width: 1,
            height: 280,
            margin: const EdgeInsets.symmetric(horizontal: 14),
            color: const Color(0xFFE5E7EB),
          ),
          Expanded(
            child: MerchantFooterPanel(
              title: 'Ringkasan Pendapatan Merchant',
              child: const MerchantRevenueSummary(),
            ),
          ),
        ],
      ),
    );
  }
}

// Mock data untuk top merchants
final _mockTopMerchants = [
  const MerchantTopMerchant(
    rank: '1',
    name: 'Kopi Kita',
    orders: '142 pesanan',
    revenue: 'Rp 8.2M',
    color: 0xFF0F8D55,
  ),
  const MerchantTopMerchant(
    rank: '2',
    name: 'Burger Enak',
    orders: '118 pesanan',
    revenue: 'Rp 6.8M',
    color: 0xFF3B82F6,
  ),
  const MerchantTopMerchant(
    rank: '3',
    name: 'Ayam Geprek 99',
    orders: '95 pesanan',
    revenue: 'Rp 5.5M',
    color: 0xFFF59E0B,
  ),
  const MerchantTopMerchant(
    rank: '4',
    name: 'Pizza Mantap',
    orders: '87 pesanan',
    revenue: 'Rp 4.9M',
    color: 0xFF7C3AED,
  ),
  const MerchantTopMerchant(
    rank: '5',
    name: 'Sushi Premium',
    orders: '72 pesanan',
    revenue: 'Rp 4.0M',
    color: 0xFFEF4444,
  ),
];

class _ToolbarRow extends StatelessWidget {
  const _ToolbarRow({
    required this.searchController,
    required this.selectedStatus,
    required this.selectedCategory,
    required this.selectedDate,
    required this.onSearchChanged,
    required this.onStatusChanged,
    required this.onCategoryChanged,
    required this.onDateChanged,
    required this.onReset,
  });

  final TextEditingController searchController;
  final String selectedStatus;
  final String selectedCategory;
  final String selectedDate;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onDateChanged;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 1100;
        final children = <Widget>[
          SizedBox(
            width: compact ? double.infinity : 320,
            child: _SearchField(
              controller: searchController,
              onChanged: onSearchChanged,
            ),
          ),
          SizedBox(
            width: compact ? double.infinity : 160,
            child: _DropdownField(
              value: selectedStatus,
              items: const ['Semua', 'Aktif', 'Pending', 'Suspend', 'Nonaktif'],
              onChanged: onStatusChanged,
            ),
          ),
          SizedBox(
            width: compact ? double.infinity : 180,
            child: _DropdownField(
              value: selectedCategory,
              items: const ['Semua Kategori', 'F&B', 'Retail', 'Jasa'],
              onChanged: onCategoryChanged,
            ),
          ),
          SizedBox(
            width: compact ? double.infinity : 160,
            child: _DropdownField(
              value: selectedDate,
              items: const ['Tanggal Daftar', 'Terbaru', 'Terlama'],
              onChanged: onDateChanged,
            ),
          ),
          ElevatedButton.icon(
            onPressed: onReset,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Reset Filter'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF3F4F6),
              foregroundColor: const Color(0xFF374151),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ];

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1) const SizedBox(height: 10),
              ],
            ],
          );
        }

        return Wrap(
          spacing: 12,
          runSpacing: 10,
          children: children,
        );
      },
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
  });
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Cari nama toko, pemilik, email...',
          hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
          prefixIcon: const Icon(Icons.search_rounded, size: 20),
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF0F8D55), width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      );
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.value,
    required this.items,
    required this.onChanged,
  });
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down_rounded, size: 20),
            style: const TextStyle(fontSize: 13, color: Color(0xFF111827)),
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ),
      );
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.compact});
  final bool compact;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final perRow = width >= 1380
              ? 5
              : width >= 1100
                  ? 4
                  : width >= 820
                      ? 3
                      : width >= 540
                          ? 2
                          : 1;
          final cardWidth = perRow == 5
              ? (width - 56) / 5
              : perRow == 4
                  ? (width - 42) / 4
                  : perRow == 3
                      ? (width - 28) / 3
                      : perRow == 2
                          ? (width - 14) / 2
                          : width;
          return Wrap(
            spacing: 14,
            runSpacing: 14,
            children: _metrics
                .map((m) => SizedBox(width: cardWidth, child: _MetricCard(metric: m)))
                .toList(),
          );
        },
      );
}

final _metrics = const [
  _MetricData('Total Merchant', '128', '+12', Icons.store_rounded),
  _MetricData('Merchant Aktif', '95', '+8', Icons.check_circle_rounded),
  _MetricData('Menunggu Verifikasi', '10', '+2', Icons.pending_rounded),
  _MetricData('Merchant Suspend', '15', '-3', Icons.block_rounded),
  _MetricData('Merchant Baru (7 Hari)', '12', '+5', Icons.fiber_new_rounded),
];

class _MetricData {
  final String label;
  final String value;
  final String delta;
  final IconData icon;
  const _MetricData(this.label, this.value, this.delta, this.icon);
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});
  final _MetricData metric;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(metric.icon, size: 20, color: const Color(0xFF0F8D55)),
              ),
              Text(
                metric.delta,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF16A34A),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            metric.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Flexible(
                child: Text(
                  metric.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartsRow extends StatelessWidget {
  const _ChartsRow({
    required this.chartFilter,
    required this.onChartFilterChanged,
    required this.chartController,
    required this.stacked,
  });
  final String chartFilter;
  final ValueChanged<String> onChartFilterChanged;
  final AnimationController chartController;
  final bool stacked;
  @override
  Widget build(BuildContext context) {
    final reg = _PanelCard(
      title: 'Grafik Pendaftaran Merchant',
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: _FilterChip(
              value: chartFilter,
              onChanged: onChartFilterChanged,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: MerchantRegistrationChart(progress: chartController.value),
          ),
        ],
      ),
    );
    final don = _PanelCard(
      title: 'Distribusi Status Merchant',
      child: const MerchantDistributionDonut(progress: 1),
    );
    if (stacked) {
      return Column(
        children: [
          SizedBox(height: 330, child: reg),
          const SizedBox(height: 14),
          SizedBox(height: 330, child: don),
        ],
      );
    }

    return Row(
      children: [
        Expanded(flex: 2, child: SizedBox(height: 330, child: reg)),
        const SizedBox(width: 14),
        Expanded(flex: 1, child: SizedBox(height: 330, child: don)),
      ],
    );
  }
}

class _PanelCard extends StatelessWidget {
  const _PanelCard({required this.title, required this.child});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Expanded(child: child),
          ],
        ),
      );
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) => DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: const [
            '1 Hari Terakhir',
            '3 Hari Terakhir',
            '7 Hari Terakhir',
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      );
}

class _FooterCardShell extends StatelessWidget {
  const _FooterCardShell({required this.title, required this.child});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) => _SectionShell(
        child: SizedBox(
          height: 300,
          child: MerchantFooterPanel(title: title, child: child),
        ),
      );
}

