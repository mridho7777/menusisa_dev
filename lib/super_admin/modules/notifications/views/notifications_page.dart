import 'package:menusisa_dev/super_admin/shared/widgets/admin_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';
import '../../../providers/notifications_provider.dart';
import '../models/notifications_models.dart';

// TODO: Supabase Integration IDs
// Table: notifications
// Columns: id (uuid), title (text), type (text), recipient (text), channel (text),
//          sender (text), sent_at (timestamp), status (text), is_read (bool),
//          created_at (timestamp), updated_at (timestamp)
// RLS: Super Admin can see all, Merchant/Customer see own

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _statusFilter = 'Semua';
  Set<String> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MenuProvider>().setRoute(AppRoutes.notifications);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

    List<NotificationItem> get _filteredItems {
    final providerItems = context.read<NotificationsProvider>().notifications
        .map((item) => NotificationItem.fromJson(item))
        .toList();
    var filtered = providerItems;

    if (_statusFilter != 'Semua') {
      filtered = filtered.where((item) => item.status == _statusFilter).toList();
    }

    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered
          .where((item) =>
              item.title.toLowerCase().contains(query) ||
              item.recipient.toLowerCase().contains(query) ||
              item.type.toLowerCase().contains(query))
          .toList();
    }

    return filtered;
  }

  Future<void> _deleteItem(String id) async {
    final notificationsProvider = context.read<NotificationsProvider>();
    await notificationsProvider.deleteNotification(id);
    if (!mounted) return;
    AdminToast.show(context, 'Tindakan berhasil', type: AdminToastType.success);
  }

  Future<void> _deleteSelected() async {
    final notificationsProvider = context.read<NotificationsProvider>();
    for (final id in _selectedIds) {
      await notificationsProvider.deleteNotification(id);
    }
    setState(() => _selectedIds.clear());
    if (!mounted) return;
    AdminToast.show(context, 'Tindakan berhasil', type: AdminToastType.success);
  }

  void _toggleSelect(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _selectAll() {
    setState(() {
      if (_selectedIds.length == _filteredItems.length) {
        _selectedIds.clear();
      } else {
        _selectedIds = _filteredItems.map((item) => item.id).toSet();
      }
    });
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
                    child: _MetricGrid(metrics: _zeroNotifMetrics),
                  ),
                  const SizedBox(height: 14),

                  // Tabel notifikasi
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Daftar Notifikasi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextField(
                                controller: _searchController,
                                onChanged: (_) => setState(() {}),
                                decoration: InputDecoration(
                                  hintText: 'Cari notifikasi...',
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
                              options: const ['Semua', 'Terkirim', 'Dijadwalkan', 'Gagal'],
                            ),
                            if (_selectedIds.isNotEmpty) ...[
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                onPressed: _deleteSelected,
                                icon: const Icon(Icons.delete_rounded, size: 16),
                                label: Text('Hapus (${_selectedIds.length})'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFEF4444),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 14),
                        _NotificationsDataTable(
                          items: filtered,
                          selectedIds: _selectedIds,
                          onToggleSelect: _toggleSelect,
                          onSelectAll: _selectAll,
                          onDelete: _deleteItem,
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
                'Notifications',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Kelola dan monitor semua notifikasi yang dikirimkan pada platform.',
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

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.metrics});

  final List<NotificationMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = 3;
        final childAspectRatio = constraints.maxWidth >= 1500
            ? 3.2
            : constraints.maxWidth >= 1180
                ? 3.0
                : 3.8;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: metrics.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) => _MetricCard(metric: metrics[index]),
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final NotificationMetric metric;

  @override
  Widget build(BuildContext context) {
    final icon = switch (metric.icon) {
      'bell' => Icons.notifications_rounded,
      'send' => Icons.send_rounded,
      'read' => Icons.mark_email_read_rounded,
      'unread' => Icons.mark_email_unread_rounded,
      'failed' => Icons.cancel_rounded,
      'percent' => Icons.percent_rounded,
      _ => Icons.notifications_rounded,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color: Color(metric.color),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 34),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        metric.title,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF374151),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        metric.value,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F8EC),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    metric.delta,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF0F8D55),
                      fontWeight: FontWeight.w600,
                    ),
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
      onSelected: onFilterChanged,
      itemBuilder: (context) =>
          options.map((opt) => PopupMenuItem(value: opt, child: Text(opt))).toList(),
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
    );
  }
}

class _NotificationsDataTable extends StatelessWidget {
  const _NotificationsDataTable({
    required this.items,
    required this.selectedIds,
    required this.onToggleSelect,
    required this.onSelectAll,
    required this.onDelete,
    this.sidebarCollapsed = true,
  });

  final List<NotificationItem> items;
  final Set<String> selectedIds;
  final Function(String) onToggleSelect;
  final VoidCallback onSelectAll;
  final Function(String) onDelete;
  final bool sidebarCollapsed;

  @override
  Widget build(BuildContext context) {
    final allSelected = items.isNotEmpty && selectedIds.length == items.length;

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
            columns: [
              DataColumn(
                label: Checkbox(
                  value: allSelected,
                  onChanged: (_) => onSelectAll(),
                  activeColor: const Color(0xFF0F8D55),
                ),
              ),
              const DataColumn(label: Text('No.')),
              const DataColumn(label: Text('Judul')),
              const DataColumn(label: Text('Tipe')),
              const DataColumn(label: Text('Penerima')),
              const DataColumn(label: Text('Channel')),
              const DataColumn(label: Text('Pengirim')),
              const DataColumn(label: Text('Waktu Kirim')),
              const DataColumn(label: Text('Status')),
              const DataColumn(label: Text('Aksi')),
            ],
            rows: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = selectedIds.contains(item.id);

              return DataRow(
                selected: isSelected,
                cells: [
                  DataCell(
                    Checkbox(
                      value: isSelected,
                      onChanged: (_) => onToggleSelect(item.id),
                      activeColor: const Color(0xFF0F8D55),
                    ),
                  ),
                  DataCell(Text('${index + 1}')),
                  DataCell(
                    Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  DataCell(Text(item.type)),
                  DataCell(Text(item.recipient)),
                  DataCell(Text(item.channel)),
                  DataCell(Text(item.sender)),
                  DataCell(Text(item.sentAt.replaceAll('\n', ' '))),
                  DataCell(_StatusChip(label: item.status)),
                  DataCell(
                    _ActionMenu(
                      item: item,
                      onDelete: onDelete,
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

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final config = switch (label) {
      'Terkirim' => (color: const Color(0xFF0F8D55), bg: const Color(0xFFD1FAE5)),
      'Dijadwalkan' => (color: const Color(0xFFF59E0B), bg: const Color(0xFFFEF3C7)),
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
        label,
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
    required this.onDelete,
  });

  final NotificationItem item;
  final Function(String) onDelete;

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
              builder: (_) => _NotifDetailDialog(item: item),
            );
            break;
          case 'delete':
            onDelete(item.id);
            break;
          case 'mark_read':
            AdminToast.show(context, 'Tindakan berhasil', type: AdminToastType.success);
            break;
          case 'resend':
            AdminToast.show(context, 'Tindakan berhasil', type: AdminToastType.success);
            break;
        }
      },
      itemBuilder: (context) => [
        _buildMenuItem(Icons.visibility_rounded, 'Lihat Detail', 'detail'),
        _buildMenuItem(Icons.mark_email_read_rounded, 'Tandai Dibaca', 'mark_read'),
        _buildMenuItem(Icons.send_rounded, 'Kirim Ulang', 'resend'),
        const PopupMenuDivider(),
        _buildMenuItem(Icons.delete_rounded, 'Hapus', 'delete', isDestructive: true),
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

class _NotifDetailDialog extends StatelessWidget {
  const _NotifDetailDialog({required this.item});

  final NotificationItem item;

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
                      'Detail Notifikasi',
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
              _DetailRow(label: 'Judul', value: item.title),
              _DetailRow(label: 'Tipe', value: item.type),
              _DetailRow(label: 'Penerima', value: item.recipient),
              _DetailRow(label: 'Channel', value: item.channel),
              _DetailRow(label: 'Pengirim', value: item.sender),
              _DetailRow(label: 'Waktu Kirim', value: item.sentAt.replaceAll('\n', ' ')),
              _DetailRow(label: 'Status', value: item.status),
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
                ? Icon(icon, size: 18,
                    color: isActive ? Colors.white : const Color(0xFF6B7280))
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
const _zeroNotifMetrics = [
  NotificationMetric(
    title: 'Total Notifikasi',
    value: '0',
    delta: '+0 dari minggu lalu',
    icon: 'bell',
    color: 0xFF0F8D55,
  ),
  NotificationMetric(
    title: 'Terkirim',
    value: '0',
    delta: '+0 dari minggu lalu',
    icon: 'send',
    color: 0xFF2563EB,
  ),
  NotificationMetric(
    title: 'Dibaca',
    value: '0',
    delta: '+0 dari minggu lalu',
    icon: 'read',
    color: 0xFFF59E0B,
  ),
  NotificationMetric(
    title: 'Belum Dibaca',
    value: '0',
    delta: '+0 dari minggu lalu',
    icon: 'unread',
    color: 0xFF7C3AED,
  ),
  NotificationMetric(
    title: 'Gagal Terkirim',
    value: '0',
    delta: '+0 dari minggu lalu',
    icon: 'failed',
    color: 0xFFEF4444,
  ),
  NotificationMetric(
    title: 'Tingkat Dibaca',
    value: '0%',
    delta: '+0% dari minggu lalu',
    icon: 'percent',
    color: 0xFF14B8A6,
  ),
];



