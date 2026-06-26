import "package:flutter/material.dart";
import "package:provider/provider.dart";

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';
import '../models/customer_models.dart';
import '../widgets/customer_status_chip.dart';

class CustomerManagementPage extends StatefulWidget {
  const CustomerManagementPage({super.key});

  @override
  State<CustomerManagementPage> createState() => _CustomerManagementPageState();
}

class _CustomerManagementPageState extends State<CustomerManagementPage> {
  late List<CustomerRecord> _records;
  String _query = '';
  String _filter = 'Semua';

  @override
  void initState() {
    super.initState();
    _records = List.of(customerRecords);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MenuProvider>().setRoute(AppRoutes.customers);
    });
  }

  @override
  Widget build(BuildContext context) {
    final sidebarCollapsed = context.watch<MenuProvider>().sidebarCollapsed;
    final filtered = _records.where((record) {
      final matchesQuery = _query.isEmpty ||
          record.name.toLowerCase().contains(_query.toLowerCase()) ||
          record.email.toLowerCase().contains(_query.toLowerCase()) ||
          record.phone.contains(_query);
      final matchesFilter = _filter == 'Semua' || record.accountStatus == _filter;
      return matchesQuery && matchesFilter;
    }).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 1100;
        final statsColumns = sidebarCollapsed ? 4 : 2;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(compact ? 16 : 24, compact ? 16 : 18, compact ? 16 : 24, 20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeaderBar(onAdd: () => _openEditor(context, null)),
                  const SizedBox(height: 16),
                  Container(
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
                    child: GridView.builder(
                      shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: customerStats.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: statsColumns,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: compact ? 3.2 : 4.2,
                    ),
                    itemBuilder: (context, index) => _StatCard(stat: customerStats[index]),
                  ),
                  ),
                  const SizedBox(height: 16),
                  _Toolbar(
                    query: _query,
                    onQueryChanged: (value) => setState(() => _query = value),
                    filter: _filter,
                    onFilterChanged: (value) => setState(() => _filter = value),
                  ),
                  const SizedBox(height: 16),
                  _CustomerTable(
                    records: filtered,
                    onEdit: (record) => _openEditor(context, record),
                    onDetail: (record) => _openDetail(context, record),
                    onToggleStatus: (record) => _toggleStatus(record),
                    onActionToast: (title, message, color) => _showToast(context, title, message, color),
                  ),
                  if (compact) ...[
                    const SizedBox(height: 16),
                    _CompactList(
                      records: filtered,
                      onEdit: (record) => _openEditor(context, record),
                      onDetail: (record) => _openDetail(context, record),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _toggleStatus(CustomerRecord record) {
    setState(() {
      final index = _records.indexWhere((item) => item.id == record.id);
      if (index < 0) return;
      final nextStatus = record.accountStatus == 'Aktif' ? 'Nonaktif' : 'Aktif';
      _records[index] = record.copyWith(accountStatus: nextStatus);
    });
    final nextStatus = record.accountStatus == 'Aktif' ? 'Nonaktif' : 'Aktif';
    _showToast(context, 'Status diperbarui', '${record.name} kini $nextStatus.', const Color(0xFF16A34A));
  }

  void _showToast(BuildContext context, String title, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        content: Text('$title ? $message'),
      ),
    );
  }

  Future<void> _openDetail(BuildContext context, CustomerRecord record) async {
    final compact = MediaQuery.of(context).size.width < 1100;
    final content = _CustomerDetailPanel(
      record: record,
      onClose: () => Navigator.pop(context),
      onEdit: () {
        Navigator.pop(context);
        _openEditor(context, record);
      },
      onToggleStatus: () {
        Navigator.pop(context);
        _toggleStatus(record);
      },
    );

    if (compact) {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => content,
      );
    } else {
      await showDialog<void>(
        context: context,
        barrierColor: Colors.black26,
        builder: (_) => Dialog(
          insetPadding: const EdgeInsets.all(18),
          child: SizedBox(width: 560, child: content),
        ),
      );
    }
  }

  Future<void> _openEditor(BuildContext context, CustomerRecord? record) async {
    final compact = MediaQuery.of(context).size.width < 1100;
    final content = _CustomerEditPanel(
      record: record,
      onClose: () => Navigator.pop(context),
      onSave: (updated) => Navigator.pop(context, updated),
    );

    final CustomerRecord? result = compact
        ? await showModalBottomSheet<CustomerRecord>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => content,
          )
        : await showDialog<CustomerRecord>(
            context: context,
            barrierColor: Colors.black26,
            builder: (_) => Dialog(
              insetPadding: const EdgeInsets.all(18),
              child: SizedBox(width: 580, child: content),
            ),
          );

    if (result == null) return;
    setState(() {
      final index = _records.indexWhere((item) => item.id == result.id);
      if (index >= 0) {
        _records[index] = result;
      }
    });
    _showToast(context, 'Berhasil', 'Data customer diperbarui.', const Color(0xFF16A34A));
  }
}

class _HeaderBar extends StatelessWidget {
  const _HeaderBar({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Customer Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
              SizedBox(height: 6),
              Text('Kelola data customer secara responsif dan interaktif', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
            ],
          ),
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(onPressed: onAdd, icon: const Icon(Icons.person_add_alt_1_rounded), label: const Text('Tambah Customer')),
            OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.file_download_outlined), label: const Text('Export Data')),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.stat});

  final CustomerStat stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: Color(stat.color), borderRadius: BorderRadius.circular(15)),
            child: Icon(stat.icon, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(stat.title, style: const TextStyle(fontSize: 12.5, color: Color(0xFF4B5563))),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(stat.value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(stat.delta, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11.5, color: Color(0xFF16A34A), fontWeight: FontWeight.w600)),
                    ),
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

class _Toolbar extends StatelessWidget {
  const _Toolbar({required this.query, required this.onQueryChanged, required this.filter, required this.onFilterChanged});

  final String query;
  final ValueChanged<String> onQueryChanged;
  final String filter;
  final ValueChanged<String> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 390,
          child: TextField(
            onChanged: onQueryChanged,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Cari nama, email, no. HP customer...',
            ),
          ),
        ),
        DropdownButton<String>(
          value: filter,
          items: const [
            DropdownMenuItem(value: 'Semua', child: Text('Semua')),
            DropdownMenuItem(value: 'Aktif', child: Text('Aktif')),
            DropdownMenuItem(value: 'Nonaktif', child: Text('Nonaktif')),
          ],
          onChanged: (value) {
            if (value != null) onFilterChanged(value);
          },
        ),
      ],
    );
  }
}

class _CustomerTable extends StatelessWidget {
  const _CustomerTable({
    required this.records,
    required this.onEdit,
    required this.onDetail,
    required this.onToggleStatus,
    required this.onActionToast,
  });

  final List<CustomerRecord> records;
  final ValueChanged<CustomerRecord> onEdit;
  final ValueChanged<CustomerRecord> onDetail;
  final ValueChanged<CustomerRecord> onToggleStatus;
  final void Function(String, String, Color) onActionToast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 44,
          dataRowMinHeight: 58,
          dataRowMaxHeight: 64,
          columns: const [
            DataColumn(label: Text('No.')),
            DataColumn(label: Text('Foto')),
            DataColumn(label: Text('Nama Customer')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('No. HP')),
            DataColumn(label: Text('Tanggal Daftar')),
            DataColumn(label: Text('Total Pesanan')),
            DataColumn(label: Text('Total Belanja')),
            DataColumn(label: Text('Status Akun')),
            DataColumn(label: Text('Aksi')),
          ],
          rows: records.map((record) {
            final active = record.accountStatus == 'Aktif';
            return DataRow(
              cells: [
                DataCell(Text(record.id.split('-').last)),
                DataCell(_CustomerAvatar(name: record.name, active: active)),
                DataCell(_NameCell(record: record)),
                DataCell(Text(record.email)),
                DataCell(Text(record.phone)),
                DataCell(Text(record.registeredAt)),
                DataCell(Text(record.totalOrders)),
                DataCell(Text(record.totalSpent)),
                DataCell(CustomerStatusChip(label: record.accountStatus, active: active)),
                DataCell(_ActionButtons(
                  onDetail: () => onDetail(record),
                  onEdit: () => onEdit(record),
                  onToggleStatus: () => onToggleStatus(record),
                  onToast: onActionToast,
                  record: record,
                )),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _CustomerAvatar extends StatelessWidget {
  const _CustomerAvatar({required this.name, required this.active});

  final String name;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isEmpty
        ? '?'
        : name.trim().split(' ').map((part) => part.isNotEmpty ? part[0] : '').take(2).join();
    return Stack(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: active ? const Color(0xFFE7F8EC) : const Color(0xFFFEE2E2),
          child: Text(initials, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: active ? const Color(0xFF0F8D55) : const Color(0xFFB91C1C))),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: active ? const Color(0xFF16A34A) : const Color(0xFFEF4444), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5)),
          ),
        ),
      ],
    );
  }
}

class _NameCell extends StatelessWidget {
  const _NameCell({required this.record});

  final CustomerRecord record;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(child: Text(record.name, overflow: TextOverflow.ellipsis)),
        if (record.customerTag.isNotEmpty) ...[
          const SizedBox(width: 8),
          _MiniBadge(label: record.customerTag),
        ],
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.onDetail, required this.onEdit, required this.onToggleStatus, required this.onToast, required this.record});

  final VoidCallback onDetail;
  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;
  final void Function(String, String, Color) onToast;
  final CustomerRecord record;

  @override
  Widget build(BuildContext context) {
    final active = record.accountStatus == 'Aktif';
    return Row(
      children: [
        IconButton(onPressed: onDetail, icon: const Icon(Icons.visibility_outlined)),
        IconButton(onPressed: onEdit, icon: const Icon(Icons.edit_outlined)),
        TextButton(onPressed: onToggleStatus, child: Text(active ? 'Nonaktifkan' : 'Aktifkan')),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'notify') {
              onToast('Notifikasi', 'Aksi untuk ${record.name} dijalankan.', const Color(0xFFF59E0B));
            } else if (value == 'hapus') {
              onToast('Dihapus', '${record.name} dihapus dari tampilan dummy.', const Color(0xFFEF4444));
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'notify', child: Text('Kirim Notif')),
            PopupMenuItem(value: 'hapus', child: Text('Hapus')),
          ],
        ),
      ],
    );
  }
}

class _CompactList extends StatelessWidget {
  const _CompactList({required this.records, required this.onEdit, required this.onDetail});

  final List<CustomerRecord> records;
  final ValueChanged<CustomerRecord> onEdit;
  final ValueChanged<CustomerRecord> onDetail;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: records.take(4).map((record) {
        return Card(
          child: ListTile(
            leading: CircleAvatar(child: Text(record.name.substring(0, 1))),
            title: Text(record.name),
            subtitle: Text('${record.email} ? ${record.accountStatus}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: () => onDetail(record), icon: const Icon(Icons.visibility_outlined)),
                IconButton(onPressed: () => onEdit(record), icon: const Icon(Icons.edit_outlined)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _CustomerDetailPanel extends StatelessWidget {
  const _CustomerDetailPanel({
    required this.record,
    required this.onClose,
    required this.onEdit,
    required this.onToggleStatus,
  });

  final CustomerRecord record;
  final VoidCallback onClose;
  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;

  @override
  Widget build(BuildContext context) {
    final active = record.accountStatus == 'Aktif';
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAF8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PanelHandle(onClose: onClose),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Row(
                  children: [
                    CircleAvatar(radius: 24, child: Text(record.name.substring(0, 1))),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Detail Customer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text(record.name, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                        ],
                      ),
                    ),
                    IconButton(onPressed: onClose, icon: const Icon(Icons.close_rounded)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(radius: 34, child: Text(record.name.substring(0, 1))),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: active ? const Color(0xFF16A34A) : const Color(0xFFEF4444),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(record.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    CustomerStatusChip(label: record.accountStatus, active: active),
                                    _MiniBadge(label: record.customerTag),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _DetailRow(label: 'Email', value: record.email),
                      _DetailRow(label: 'No. HP', value: record.phone),
                      _DetailRow(label: 'Tanggal Daftar', value: record.registeredAt),
                      _DetailRow(label: 'Total Pesanan', value: record.totalOrders),
                      _DetailRow(label: 'Total Belanja', value: record.totalSpent),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  children: [
                    Expanded(child: OutlinedButton(onPressed: onClose, child: const Text('Tutup'))),
                    const SizedBox(width: 12),
                    Expanded(child: FilledButton(onPressed: onEdit, child: const Text('Edit'))),
                    const SizedBox(width: 12),
                    Expanded(child: FilledButton.tonal(onPressed: onToggleStatus, child: Text(active ? 'Nonaktifkan' : 'Aktifkan'))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomerEditPanel extends StatefulWidget {
  const _CustomerEditPanel({required this.record, required this.onClose, required this.onSave});

  final CustomerRecord? record;
  final VoidCallback onClose;
  final ValueChanged<CustomerRecord> onSave;

  @override
  State<_CustomerEditPanel> createState() => _CustomerEditPanelState();
}

class _CustomerEditPanelState extends State<_CustomerEditPanel> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController statusController;
  late final TextEditingController tagController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.record?.name ?? '');
    emailController = TextEditingController(text: widget.record?.email ?? '');
    phoneController = TextEditingController(text: widget.record?.phone ?? '');
    statusController = TextEditingController(text: widget.record?.accountStatus ?? 'Aktif');
    tagController = TextEditingController(text: widget.record?.customerTag ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    statusController.dispose();
    tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final record = widget.record ?? customerRecords.first;
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAF8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PanelHandle(onClose: widget.onClose),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Row(
                  children: [
                    CircleAvatar(radius: 24, child: Text(record.name.substring(0, 1))),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Edit Customer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                          SizedBox(height: 4),
                          Text('Ubah data customer secara realtime', style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
                        ],
                      ),
                    ),
                    IconButton(onPressed: widget.onClose, icon: const Icon(Icons.close_rounded)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    children: [
                      _FormField(controller: nameController, label: 'Nama Lengkap'),
                      _FormField(controller: emailController, label: 'Email'),
                      _FormField(controller: phoneController, label: 'No. HP'),
                      _FormField(controller: statusController, label: 'Status Akun'),
                      _FormField(controller: tagController, label: 'Tag Customer'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: OutlinedButton(onPressed: widget.onClose, child: const Text('Batal'))),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton(
                              onPressed: () {
                                widget.onSave(
                                  record.copyWith(
                                    name: nameController.text.isEmpty ? record.name : nameController.text,
                                    email: emailController.text.isEmpty ? record.email : emailController.text,
                                    phone: phoneController.text.isEmpty ? record.phone : phoneController.text,
                                    accountStatus: statusController.text.isEmpty ? record.accountStatus : statusController.text,
                                    customerTag: tagController.text.isEmpty ? record.customerTag : tagController.text,
                                  ),
                                );
                              },
                              child: const Text('Simpan Perubahan'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PanelHandle extends StatelessWidget {
  const _PanelHandle({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 12),
      child: Center(
        child: Container(width: 48, height: 5, decoration: BoxDecoration(color: const Color(0xFFD1D5DB), borderRadius: BorderRadius.circular(999))),
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFFE7F8EC), borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF0F8D55))),
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
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(': $value')),
        ],
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({required this.controller, required this.label});
  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(controller: controller, decoration: InputDecoration(labelText: label)),
    );
  }
}




