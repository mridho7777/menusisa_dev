import 'package:menusisa_dev/super_admin/shared/widgets/admin_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';
import '../../../providers/merchant_provider.dart';
import '../../../providers/notifications_provider.dart';
import '../models/merchant_management_models.dart';
import '../widgets/merchant_content_widgets.dart'
    show MerchantDistributionDonut, MerchantRegistrationChart;
import '../widgets/merchant_footer_sections.dart' as footer;
import '../widgets/merchant_lists_and_actions.dart';
import '../widgets/merchant_table_section.dart';
import '../widgets/merchant_metric_grid_new.dart';

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
      if (mounted) {
        context.read<MenuProvider>().setRoute(AppRoutes.merchants);
        context.read<MerchantProvider>().loadMerchants();
      }
    });
  }

  @override
  void dispose() {
    chartController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toast(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    AdminToast.show(
      context, 
      message, 
      type: error ? AdminToastType.error : AdminToastType.success
    );
  }

  void _addNotification(String title, String message, String type) {
    context.read<NotificationsProvider>().addNotification({
      'title': title,
      'message': message,
      'type': type,
      'entity_type': 'merchant',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> _handleApprove(String merchantId, String shopName) async {
    final merchantProvider = context.read<MerchantProvider>();
    final success = await merchantProvider.approveMerchant(merchantId);
    if (!mounted) return;
    if (success) {
      _toast('Merchant "$shopName" berhasil disetujui');
      _addNotification(
        'Merchant Disetujui',
        'Toko "$shopName" telah aktif dan dapat mulai berjualan.',
        'merchant_approved',
      );
    } else {
      _toast('Gagal menyetujui merchant', error: true);
    }
  }

  Future<void> _handleReject(String merchantId, String shopName) async {
    final reasonController = TextEditingController();
    final merchantProvider = context.read<MerchantProvider>();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tolak Pendaftaran Toko'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Apakah Anda yakin ingin menolak toko "$shopName"?'),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Alasan Penolakan',
                border: OutlineInputBorder(),
                hintText: 'Contoh: Dokumen tidak valid / toko palsu',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Tolak', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (result == true) {
      final reason = reasonController.text.trim().isEmpty ? 'Alasan tidak spesifik' : reasonController.text.trim();
      final success = await merchantProvider.rejectMerchant(merchantId, reason);
      if (!mounted) return;
      if (success) {
        // ignore: use_build_context_synchronously
        _toast('Pendaftaran Toko "$shopName" telah ditolak');
        _addNotification(
          'Merchant Ditolak',
          'Pendaftaran toko "$shopName" ditolak. Alasan: $reason',
          'merchant_rejected',
        );
      } else {
        _toast('Gagal menolak merchant', error: true);
      }
    }
    reasonController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sidebarCollapsed = context.watch<MenuProvider>().sidebarCollapsed;
    final merchantProvider = context.watch<MerchantProvider>();
    final filtered = merchantProvider.filteredMerchants;

    // Hitung metrics dynamic
    final metrics = [
      MerchantMetric(
        title: 'Total Merchant',
        value: merchantProvider.totalMerchants.toString(),
        delta: '+0%',
        icon: 'storefront',
        color: 0xFF16A34A,
      ),
      MerchantMetric(
        title: 'Merchant Aktif',
        value: merchantProvider.approvedMerchants.toString(),
        delta: '+0%',
        icon: 'check_circle',
        color: 0xFF0F8D55,
      ),
      MerchantMetric(
        title: 'Menunggu Persetujuan',
        value: merchantProvider.pendingMerchants.toString(),
        delta: '+0%',
        icon: 'pending',
        color: 0xFFF59E0B,
      ),
      MerchantMetric(
        title: 'Ditolak/Nonaktif',
        value: merchantProvider.rejectedMerchants.toString(),
        delta: '+0%',
        icon: 'cancel',
        color: 0xFFEF4444,
      ),
      MerchantMetric(
        title: 'Pendaftar Baru',
        value: '12',
        delta: '+5%',
        icon: 'person_add',
        color: 0xFF3B82F6,
      ),
      MerchantMetric(
        title: 'Toko Dibekukan',
        value: '0',
        delta: '0%',
        icon: 'lock',
        color: 0xFF6B7280,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const compact = false;
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _HeaderBar(),
                  const SizedBox(height: 14),
                  
                  _SectionShell(
                    child: MerchantMetricGrid(
                      metrics: metrics,
                      sidebarCollapsed: sidebarCollapsed,
                    ),
                  ),
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
                            _toast('Filter kategori siap digunakan');
                          },
                          onDateChanged: (v) {
                            setState(() => _dateFilter = v);
                            _toast('Filter tanggal siap digunakan');
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
                        
                        if (merchantProvider.isLoading)
                          const Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Center(child: CircularProgressIndicator(color: Color(0xFF16A34A))),
                          )
                        else if (filtered.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Center(child: Text('Tidak ada merchant ditemukan')),
                          )
                        else
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
                            onAction: (action, id) {
                              final merchant = filtered.firstWhere((m) => m.id == id);
                              if (action == 'approve') {
                                _handleApprove(id, merchant.shopName);
                              } else if (action == 'reject') {
                                _handleReject(id, merchant.shopName);
                              } else if (action == 'delete') {
                                () async {
                                  final merchantProvider = context.read<MerchantProvider>();
                                  await merchantProvider.deleteMerchant(id);
                                  if (!mounted) return;
                                  _toast('Merchant "${merchant.shopName}" berhasil dihapus');
                                }();
                              } else {
                                _toast('Aksi: $action');
                              }
                            },
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  
                  // Charts section
                  _ChartsRow(
                    chartFilter: _chartFilter,
                    onChartFilterChanged: (v) => setState(() => _chartFilter = v),
                    chartController: chartController,
                    stacked: compact,
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
  Widget build(BuildContext context) => Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Merchant Management',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 4),
                Text(
                  'Kelola semua merchant yang terdaftar',
                  style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Color(0xFF4B5563)),
                SizedBox(width: 8),
                Text(
                  '19 Juli 2026',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}

class _SectionShell extends StatelessWidget {
  const _SectionShell({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        padding: const EdgeInsets.all(16),
        child: child,
      );
}

class _FooterCardShell extends StatelessWidget {
  const _FooterCardShell({required this.title, required this.child});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      );
}

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
  final Function(String) onSearchChanged;
  final Function(String) onStatusChanged;
  final Function(String) onCategoryChanged;
  final Function(String) onDateChanged;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Cari nama toko, pemilik, atau email...',
                prefixIcon: Icon(Icons.search, size: 18),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        _DropdownFilter(
          value: selectedStatus,
          items: const ['Semua', 'pending', 'approved', 'rejected'],
          onChanged: (v) {
            if (v != null) onStatusChanged(v);
          },
        ),
        const SizedBox(width: 12),
        Flexible(
          child: ElevatedButton(
            onPressed: onReset,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade100,
              foregroundColor: Colors.black87,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            child: const Text('Reset', overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
    );
  }
}

class _DropdownFilter extends StatelessWidget {
  const _DropdownFilter({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          items: items.map((item) {
            String label = item;
            if (item == 'approved') label = 'Aktif';
            if (item == 'pending') label = 'Pending';
            if (item == 'rejected') label = 'Ditolak';
            if (item == 'Semua') label = 'Semua Status';
            
            return DropdownMenuItem(
              value: item,
              child: Text(label, style: const TextStyle(fontSize: 13)),
            );
          }).toList(),
        ),
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
    if (stacked) {
      return Column(
        children: [
          _SectionShell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pendaftaran Merchant',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    _DropdownFilter(
                      value: chartFilter,
                      items: const ['7 Hari Terakhir', '30 Hari Terakhir', 'Tahun Ini'],
                      onChanged: (v) {
                        if (v != null) onChartFilterChanged(v);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 320,
                  child: MerchantRegistrationChart(progress: chartController.value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _SectionShell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Distribusi Merchant per Kategori',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 320,
                  child: MerchantDistributionDonut(progress: chartController.value),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _SectionShell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pendaftaran Merchant',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    _DropdownFilter(
                      value: chartFilter,
                      items: const ['7 Hari Terakhir', '30 Hari Terakhir', 'Tahun Ini'],
                      onChanged: (v) {
                        if (v != null) onChartFilterChanged(v);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 320,
                  child: MerchantRegistrationChart(progress: chartController.value),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          flex: 1,
          child: _SectionShell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Distribusi Merchant per Kategori',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 320,
                  child: MerchantDistributionDonut(progress: chartController.value),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
