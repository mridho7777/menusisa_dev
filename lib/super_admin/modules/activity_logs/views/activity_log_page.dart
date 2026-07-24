import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/activity_log_provider.dart';
import '../../../providers/menu_provider.dart';
import '../../../core/routes/app_routes.dart';

class ActivityLogPage extends StatefulWidget {
  const ActivityLogPage({super.key});

  @override
  State<ActivityLogPage> createState() => _ActivityLogPageState();
}

class _ActivityLogPageState extends State<ActivityLogPage> {
  final TextEditingController _searchController = TextEditingController();
  String _moduleFilter = 'Semua Modul';
  String _activityFilter = 'Semua Aktivitas';
  String _userFilter = 'Semua User';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MenuProvider>().setRoute(AppRoutes.activityLog);
      context.read<ActivityLogProvider>().loadLogs();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ActivityLogProvider>(
      builder: (context, provider, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final padding = constraints.maxWidth < 900
                ? const EdgeInsets.fromLTRB(16, 16, 16, 18)
                : const EdgeInsets.fromLTRB(24, 18, 24, 20);

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
                      _SectionCard(child: _MetricsGrid(provider: provider)),
                      const SizedBox(height: 14),
                      _SectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Daftar Aktivitas',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                SizedBox(
                                  width: 280,
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: provider.setSearchQuery,
                                    decoration: InputDecoration(
                                      hintText: 'Cari aktivitas, user, IP...',
                                      hintStyle: const TextStyle(fontSize: 13),
                                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                      isDense: true,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    ),
                                  ),
                                ),
                                _FilterDropdown(value: _moduleFilter, label: 'Modul', items: _modules(provider), onChanged: (value) => setState(() => _moduleFilter = value)),
                                _FilterDropdown(value: _activityFilter, label: 'Aktivitas', items: provider.uniqueActions, onChanged: (value) => provider.setActionFilter(value)),
                                _FilterDropdown(value: _userFilter, label: 'User', items: provider.uniqueUsers, onChanged: (value) => provider.setUserFilter(value)),
                                SizedBox(
                                  height: 48,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                        _moduleFilter = 'Semua Modul';
                                        _activityFilter = 'Semua Aktivitas';
                                        _userFilter = 'Semua User';
                                      });
                                      provider.setSearchQuery('');
                                      provider.setActionFilter('Semua');
                                      provider.setUserFilter('Semua');
                                    },
                                    icon: const Icon(Icons.refresh, size: 18),
                                    label: const Text('Reset'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (provider.isLoading)
                              const Padding(
                                padding: EdgeInsets.all(24),
                                child: Center(child: CircularProgressIndicator()),
                              )
                            else if (provider.filteredLogs.isEmpty)
                              const Padding(
                                padding: EdgeInsets.all(24),
                                child: Center(child: Text('Tidak ada aktivitas ditemukan')),
                              )
                            else
                              _ActivityTable(logs: provider.filteredLogs),
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
      },
    );
  }

  List<String> _modules(ActivityLogProvider provider) {
    final modules = provider.logs.map((log) => log['module']?.toString() ?? 'Unknown').where((module) => module.isNotEmpty).toSet().toList()..sort();
    return ['Semua Modul', ...modules];
  }
}

class _HeaderBar extends StatelessWidget {
  const _HeaderBar();
  @override
  Widget build(BuildContext context) => const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Activity Log', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF111827))), SizedBox(height: 3), Text('Pantau semua aktivitas yang terjadi di dalam sistem untuk keamanan dan audit trail', style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)))]);
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(width: double.infinity, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE5E7EB)), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 18, offset: Offset(0, 6))]), child: child);
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.provider});
  final ActivityLogProvider provider;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      _MetricData(icon: Icons.description_outlined, color: const Color(0xFF2563EB), title: 'Total Aktivitas', value: provider.totalActivities.toString(), trend: 'hari ini '),
      _MetricData(icon: Icons.check_circle_outline, color: const Color(0xFF15803D), title: 'User Aktif Hari Ini', value: provider.uniqueUsersToday.toString(), trend: 'unik'),
      _MetricData(icon: Icons.edit_outlined, color: const Color(0xFFF59E0B), title: 'Update', value: provider.countByActivityType('Update').toString(), trend: 'aktivitas'),
      _MetricData(icon: Icons.delete_outline, color: const Color(0xFFEF4444), title: 'Delete', value: provider.countByActivityType('Delete').toString(), trend: 'aktivitas'),
      _MetricData(icon: Icons.lock_outline, color: const Color(0xFF7C3AED), title: 'Login', value: provider.countByActivityType('Login').toString(), trend: 'aktivitas'),
      _MetricData(icon: Icons.download_outlined, color: const Color(0xFF166534), title: 'Export', value: provider.countByActivityType('Export').toString(), trend: 'aktivitas'),
    ];
    return LayoutBuilder(builder: (context, constraints) {
      int crossAxisCount = 6;
      if (constraints.maxWidth < 1400) crossAxisCount = 3;
      if (constraints.maxWidth < 900) crossAxisCount = 2;
      if (constraints.maxWidth < 600) crossAxisCount = 1;
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: crossAxisCount, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 2.8),
        itemCount: metrics.length,
        itemBuilder: (context, index) => _MetricCard(data: metrics[index]),
      );
    });
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.data});
  final _MetricData data;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFFAFAFA), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))), child: Row(children: [Container(width: 66, height: 66, decoration: BoxDecoration(color: data.color, borderRadius: BorderRadius.circular(16)), child: Icon(data.icon, color: Colors.white, size: 34)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(data.title, style: const TextStyle(fontSize: 11.5, color: Color(0xFF6B7280), fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis), const SizedBox(height: 4), Text(data.value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF111827))), const SizedBox(height: 2), Text(data.trend, style: const TextStyle(fontSize: 10, color: Color(0xFF15803D)), maxLines: 1, overflow: TextOverflow.ellipsis)]))]));
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({required this.value, required this.label, required this.items, required this.onChanged});
  final String value; final String label; final List<String> items; final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) => SizedBox(width: 180, child: DropdownButtonFormField<String>(initialValue: value, decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), isDense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10)), items: items.map((item) => DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(fontSize: 13)))).toList(), onChanged: (value) { if (value != null) onChanged(value); }));
}

class _ActivityTable extends StatelessWidget {
  const _ActivityTable({required this.logs});
  final List<Map<String, dynamic>> logs;

  @override
  Widget build(BuildContext context) {
    final data = logs.take(50).toList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
        headingTextStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF374151)),
        dataTextStyle: const TextStyle(fontSize: 13, color: Color(0xFF111827)),
        columnSpacing: 24,
        horizontalMargin: 16,
        dataRowMinHeight: 56,
        dataRowMaxHeight: 72,
        columns: const [DataColumn(label: Text('No.')), DataColumn(label: Text('Waktu')), DataColumn(label: Text('User')), DataColumn(label: Text('Modul')), DataColumn(label: Text('Aktivitas')), DataColumn(label: Text('Deskripsi')), DataColumn(label: Text('IP Address')), DataColumn(label: Text('Perangkat')), DataColumn(label: Text('Lokasi'))],
        rows: data.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final row = entry.value;
          final activity = row['activity_type']?.toString() ?? '-';
          final color = switch (activity) { 'Create' => const Color(0xFF15803D), 'Update' => const Color(0xFF2563EB), 'Delete' => const Color(0xFFEF4444), 'Approve' => const Color(0xFF0F766E), 'Reject' => const Color(0xFFF59E0B), _ => const Color(0xFF6B7280) };
          return DataRow(cells: [
            DataCell(Text(index.toString())),
            DataCell(Text(_formatTime(row['created_at']?.toString() ?? ''))),
            DataCell(Text(row['user_name']?.toString() ?? '-', style: const TextStyle(fontWeight: FontWeight.w600))),
            DataCell(Text(row['module']?.toString() ?? '-')),
            DataCell(Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: Text(activity, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)))),
            DataCell(SizedBox(width: 200, child: Text(row['description']?.toString() ?? '-', maxLines: 2, overflow: TextOverflow.ellipsis))),
            DataCell(Text(row['ip_address']?.toString() ?? '-')),
            DataCell(Text(row['device']?.toString() ?? '-', style: const TextStyle(fontSize: 11.5))),
            DataCell(Text(row['location']?.toString() ?? '-')),
          ]);
        }).toList(),
      ),
    );
  }

  String _formatTime(String value) {
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;
    return '  \n:';
  }

  String _month(int month) => const ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'][month - 1];
}

class _MetricData { const _MetricData({required this.icon, required this.color, required this.title, required this.value, required this.trend}); final IconData icon; final Color color; final String title; final String value; final String trend; }
