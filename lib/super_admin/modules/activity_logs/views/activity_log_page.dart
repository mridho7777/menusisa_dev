import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';
import '../../../shared/widgets/action_feedback.dart';

class ActivityLogPage extends StatefulWidget {
  const ActivityLogPage({super.key});

  @override
  State<ActivityLogPage> createState() => _ActivityLogPageState();
}

class _ActivityLogPageState extends State<ActivityLogPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<MenuProvider>().setRoute(AppRoutes.activityLog);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = constraints.maxWidth < 900
            ? const EdgeInsets.fromLTRB(16, 18, 16, 18)
            : const EdgeInsets.fromLTRB(24, 18, 24, 20);

        return SingleChildScrollView(
          padding: padding,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _ActivityHeader(),
                  SizedBox(height: 14),
                  _SummaryGrid(),
                  SizedBox(height: 14),
                  _FilterRow(),
                  SizedBox(height: 14),
                  _MainLayout(),
                  SizedBox(height: 14),
                  _BottomGrid(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ActivityHeader extends StatelessWidget {
  const _ActivityHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Activity Log', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
              SizedBox(height: 6),
              Text(
                'Pantau semua aktivitas yang terjadi di dalam sistem untuk keamanan dan audit trail.',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            showBottomActionMessage(
              context,
              title: 'Export Log',
              subtitle: 'Log aktivitas berhasil diexport ke file dummy.',
              color: const Color(0xFF15803D),
              icon: Icons.download_outlined,
            );
          },
          icon: const Icon(Icons.download_outlined, size: 16),
          label: const Text('Export Log'),
        ),
      ],
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid();

  @override
  Widget build(BuildContext context) {
    final cards = [
      _SummaryCard(color: const Color(0xFF2563EB), icon: Icons.description_outlined, title: 'Total Aktivitas', value: '12.456', trend: '+18.6% dari minggu lalu'),
      _SummaryCard(color: const Color(0xFF15803D), icon: Icons.check_circle_outline, title: 'Login Berhasil', value: '2.845', trend: '+12.4% dari minggu lalu'),
      _SummaryCard(color: const Color(0xFFF59E0B), icon: Icons.edit_outlined, title: 'Perubahan Data', value: '4.320', trend: '+22.7% dari minggu lalu'),
      _SummaryCard(color: const Color(0xFFEF4444), icon: Icons.delete_outline, title: 'Penghapusan Data', value: '356', trend: '-8.3% dari minggu lalu'),
      _SummaryCard(color: const Color(0xFF7C3AED), icon: Icons.lock_outline, title: 'Login Gagal', value: '89', trend: '-5.1% dari minggu lalu'),
      _SummaryCard(color: const Color(0xFF166534), icon: Icons.download_outlined, title: 'Ekspor Data', value: '124', trend: '+10.2% dari minggu lalu'),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 1150;
        if (narrow) {
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: cards
                .map((card) => SizedBox(width: (constraints.maxWidth - 12) / 2, child: card))
                .toList(),
          );
        }

        return Row(
          children: [
            for (var i = 0; i < cards.length; i++) ...[
              Expanded(child: cards[i]),
              if (i != cards.length - 1) const SizedBox(width: 12),
            ],
          ],
        );
      },
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: const [
        _SearchField(),
        _FilterChipField(label: 'Semua Modul'),
        _FilterChipField(label: 'Semua Aktivitas'),
        _FilterChipField(label: 'Semua User'),
        _DateField(),
        _ResetButton(),
      ],
    );
  }
}

class _MainLayout extends StatelessWidget {
  const _MainLayout();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 1250;
        final main = _SectionCard(title: 'Daftar Aktivitas', child: _ActivityTable());
        final right = Column(
          children: const [
            _DonutCard(),
            SizedBox(height: 14),
            _TopActivityCard(),
            SizedBox(height: 14),
            _QuickInfoCard(),
            SizedBox(height: 14),
            _AlertsCard(),
          ],
        );

        if (compact) {
          return Column(
            children: [
              main,
              const SizedBox(height: 14),
              right,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 4, child: main),
            const SizedBox(width: 14),
            Expanded(flex: 2, child: right),
          ],
        );
      },
    );
  }
}

class _BottomGrid extends StatelessWidget {
  const _BottomGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 1100) {
          return const Column(
            children: [
              _DetailCard(),
              SizedBox(height: 14),
              _TrendCard(),
            ],
          );
        }

        return const Row(
          children: [
            Expanded(child: _DetailCard()),
            SizedBox(width: 14),
            Expanded(child: _TrendCard()),
          ],
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 20, offset: Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.color, required this.icon, required this.title, required this.value, required this.trend});

  final Color color;
  final IconData icon;
  final String title;
  final String value;
  final String trend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 16, offset: Offset(0, 6))],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12.5, color: Color(0xFF475569))),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(trend, style: const TextStyle(fontSize: 11.5, color: Color(0xFF15803D))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Cari aktivitas, user, IP address, atau modul...',
          prefixIcon: const Icon(Icons.search, size: 18),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
      ),
    );
  }
}

class _FilterChipField extends StatelessWidget {
  const _FilterChipField({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: DropdownButtonFormField<String>(
        items: [DropdownMenuItem(value: label, child: Text(label))],
        onChanged: (_) {},
        initialValue: label,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: TextFormField(
        initialValue: '01 Mei 2025 - 20 Mei 2025',
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
      ),
    );
  }
}

class _ResetButton extends StatelessWidget {
  const _ResetButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: OutlinedButton(
        onPressed: () {
          showBottomActionMessage(
            context,
            title: 'Filter direset',
            subtitle: 'Semua filter aktivitas kembali ke default.',
            color: const Color(0xFF2563EB),
            icon: Icons.restart_alt,
          );
        },
        child: const Text('Reset Filter'),
      ),
    );
  }
}

class _ActivityTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('No.')),
          DataColumn(label: Text('Waktu')),
          DataColumn(label: Text('User')),
          DataColumn(label: Text('Modul')),
          DataColumn(label: Text('Aktivitas')),
          DataColumn(label: Text('Deskripsi')),
          DataColumn(label: Text('IP Address')),
          DataColumn(label: Text('Perangkat')),
          DataColumn(label: Text('Lokasi')),
          DataColumn(label: Text('Aksi')),
        ],
        rows: List.generate(10, (index) {
          const modules = [
            'Merchant Management',
            'Product Management',
            'Transaction Management',
            'Payment Monitoring',
            'Product Approval',
            'User Management',
            'System Settings',
            'Platform Revenue',
            'Authentication',
            'Authentication',
          ];
          const activities = ['Update', 'Create', 'Update', 'Approve', 'Reject', 'Create', 'Update', 'Export', 'Login Success', 'Login Failed'];
          const descriptions = [
            'Mengupdate data merchant',
            'Menambahkan produk baru',
            'Mengupdate status transaksi',
            'Menyetujui pembayaran',
            'Menolak produk',
            'Menambahkan user baru',
            'Mengubah pengaturan komisi',
            'Mengekspor laporan pendapatan',
            'Login berhasil ke sistem',
            'Login gagal - password salah',
          ];
          const ips = ['192.168.1.10', '192.168.1.25', '192.168.1.18', '192.168.1.30', '192.168.1.22', '192.168.1.15', '192.168.1.10', '192.168.1.27', '192.168.1.10', '192.168.1.55'];
          const devices = ['Chrome 124\nWindows 11', 'Chrome 124\nWindows 11', 'Firefox 125\nWindows 10', 'Edge 124\nWindows 11', 'Chrome 124\nWindows 11', 'Chrome 124\nWindows 11', 'Chrome 124\nWindows 11', 'Edge 124\nWindows 11', 'Chrome 124\nWindows 11', 'Chrome 124\nWindows 11'];
          const locations = ['Jakarta, ID', 'Bandung, ID', 'Surabaya, ID', 'Yogyakarta, ID', 'Jakarta, ID', 'Medan, ID', 'Jakarta, ID', 'Semarang, ID', 'Jakarta, ID', 'Unknown'];

          return DataRow(
            cells: [
              DataCell(Text('${index + 1}')),
              DataCell(Text('20 Mei 2025\n10:2$index WIB')),
              DataCell(Text(index == 0 ? 'Super Admin' : 'Admin')),
              DataCell(Text(modules[index])),
              DataCell(Text(activities[index])),
              DataCell(Text(descriptions[index])),
              DataCell(Text(ips[index])),
              DataCell(Text(devices[index])),
              DataCell(Text(locations[index])),
              DataCell(
                OutlinedButton(
                  onPressed: () {
                    showBottomActionMessage(
                      context,
                      title: 'Detail aktivitas',
                      subtitle: 'Menampilkan detail baris ${index + 1}.',
                      color: const Color(0xFF7C3AED),
                      icon: Icons.visibility_outlined,
                    );
                  },
                  child: const Icon(Icons.remove_red_eye_outlined, size: 16),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _DonutCard extends StatelessWidget {
  const _DonutCard();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Aktivitas per Modul',
      child: Container(height: 220, alignment: Alignment.center, child: const Text('Donut Chart')),
    );
  }
}

class _TopActivityCard extends StatelessWidget {
  const _TopActivityCard();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Aktivitas Teratas',
      child: Column(
        children: const [
          _RankRow(rank: '1', title: 'Update Data Merchant', value: '1.245'),
          _RankRow(rank: '2', title: 'Update Status Transaksi', value: '1.102'),
          _RankRow(rank: '3', title: 'Approve Payment', value: '876'),
          _RankRow(rank: '4', title: 'Create Product', value: '642'),
          _RankRow(rank: '5', title: 'Export Laporan', value: '518'),
        ],
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  const _RankRow({required this.rank, required this.title, required this.value});

  final String rank;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 20, child: Text(rank)),
          const SizedBox(width: 12),
          Expanded(child: Text(title)),
          Text(value),
        ],
      ),
    );
  }
}

class _QuickInfoCard extends StatelessWidget {
  const _QuickInfoCard();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Informasi Cepat',
      child: const Column(
        children: [
          _InfoRow(label: 'Rata-rata Aktivitas per Hari', value: '1.780'),
          _InfoRow(label: 'Aktivitas Hari Ini', value: '256'),
          _InfoRow(label: 'User Aktif Hari Ini', value: '18'),
          _InfoRow(label: 'Waktu Aktivitas Terakhir', value: '10:29 WIB'),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.circle, size: 10, color: Color(0xFF16A34A)),
      title: Text(label, style: const TextStyle(fontSize: 13)),
      trailing: Text(value),
    );
  }
}

class _AlertsCard extends StatelessWidget {
  const _AlertsCard();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Notifikasi',
      child: const Column(
        children: [
          _AlertRow(
            icon: Icons.check_circle,
            color: Color(0xFF16A34A),
            title: 'Log aktivitas berhasil dimuat!',
            subtitle: 'Total 12.456 aktivitas pada periode ini.',
          ),
          _AlertRow(
            icon: Icons.warning_amber_rounded,
            color: Color(0xFFF59E0B),
            title: 'Login gagal terdeteksi!',
            subtitle: 'Terdapat 37 percobaan login gagal.',
          ),
        ],
      ),
    );
  }
}

class _AlertRow extends StatelessWidget {
  const _AlertRow({required this.icon, required this.color, required this.title, required this.subtitle});

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Detail Aktivitas',
      child: const Text('Detail aktivitas terpilih ditampilkan di sini.'),
    );
  }
}

class _TrendCard extends StatelessWidget {
  const _TrendCard();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Ringkasan Aktivitas Harian',
      child: Container(height: 180, alignment: Alignment.center, child: const Text('Line Chart')),
    );
  }
}
