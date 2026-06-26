import 'package:flutter/material.dart';

import '../../../shared/widgets/action_feedback.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Informasi Profil',
      subtitle: 'Informasi dasar akun super admin.',
      child: Column(
        children: const [
          SizedBox(height: 8),
          _AvatarHeader(),
          SizedBox(height: 18),
          _InputField(label: 'Nama Lengkap', value: 'Super Admin'),
          _InputField(label: 'Email', value: 'superadmin@menusisa.id'),
          _InputField(label: 'No. Telepon', value: '021-1234-5678'),
          _InputField(label: 'Jabatan', value: 'Super Administrator'),
          _InputField(label: 'Akses Terakhir', value: '20 Mei 2025, 10:20 WIB'),
          _StatusRow(label: 'Status Akun', value: 'Aktif'),
          SizedBox(height: 14),
          _PrimaryButton(label: 'Edit Profil', icon: Icons.edit_outlined),
        ],
      ),
    );
  }
}

class SecurityPreferencesCard extends StatelessWidget {
  const SecurityPreferencesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Pengaturan Keamanan',
      subtitle: 'Kelola keamanan akun Anda.',
      child: Column(
        children: const [
          _ActionRow(
            title: 'Ubah Password',
            description: 'Perbarui password akun secara berkala untuk keamanan akun.',
            buttonLabel: 'Ubah Password',
            icon: Icons.lock_outline,
          ),
          _DividerLine(),
          _ActionRow(
            title: 'Two-Factor Authentication (2FA)',
            description: 'Aktifkan 2FA untuk menambah lapisan keamanan akun Anda.',
            badge: 'Aktif',
            trailingIcon: Icons.chevron_right,
          ),
          _DividerLine(),
          _ActionRow(
            title: 'Login Sessions',
            description: 'Kelola perangkat yang sedang login ke akun Anda.',
            buttonLabel: 'Kelola Session',
            icon: Icons.desktop_windows_outlined,
          ),
          _DividerLine(),
          _ActionRow(
            title: 'Riwayat Login',
            description: 'Lihat riwayat aktivitas login akun Anda.',
            buttonLabel: 'Lihat Riwayat',
            icon: Icons.history,
          ),
        ],
      ),
    );
  }
}

class RecentActivityCard extends StatelessWidget {
  const RecentActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Aktivitas Akun Terbaru',
      subtitle: 'Aktivitas terbaru yang dilakukan pada akun Anda.',
      child: Column(
        children: const [
          _ActivityItem(title: 'Login berhasil', subtitle: 'Login dari IP 192.168.1.10', time: '10:20 WIB', color: Color(0xFF16A34A), icon: Icons.check),
          _ActivityItem(title: 'Update profil', subtitle: 'Informasi profil diperbarui', time: '09:15 WIB', color: Color(0xFF2563EB), icon: Icons.edit_outlined),
          _ActivityItem(title: 'Ubah password', subtitle: 'Password akun berhasil diubah', time: 'Kemarin, 16:45 WIB', color: Color(0xFF7C3AED), icon: Icons.lock_outline),
          _ActivityItem(title: 'Login dari perangkat baru', subtitle: 'Chrome - Windows 11', time: '18 Mei 2025, 14:30 WIB', color: Color(0xFFF97316), icon: Icons.computer_outlined),
          _ActivityItem(title: 'Export laporan', subtitle: 'Export data revenue bulanan', time: '18 Mei 2025, 10:05 WIB', color: Color(0xFF15803D), icon: Icons.download_outlined),
          SizedBox(height: 10),
          _SecondaryButton(label: 'Lihat Semua Aktivitas'),
        ],
      ),
    );
  }
}

class LogoutCard extends StatelessWidget {
  const LogoutCard({super.key});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Logout',
      subtitle: 'Keluar dari sistem dengan aman.',
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF1F2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFCA5A5)),
        ),
        child: Column(
          children: const [
            CircleAvatar(radius: 18, backgroundColor: Color(0xFFEF4444), child: Icon(Icons.logout, color: Colors.white, size: 18)),
            SizedBox(height: 12),
            Text('Logout dari Sistem', style: TextStyle(fontWeight: FontWeight.w700)),
            SizedBox(height: 6),
            Text('Anda akan keluar dari akun dan harus login kembali untuk mengakses sistem.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF64748B))),
            SizedBox(height: 14),
            _DangerButton(label: 'Logout Sekarang'),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.subtitle, required this.child});

  final String title;
  final String subtitle;
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
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12.5)),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _AvatarHeader extends StatelessWidget {
  const _AvatarHeader();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: const [
        CircleAvatar(radius: 46, backgroundColor: Color(0xFFE2E8F0), child: CircleAvatar(radius: 42, backgroundColor: Color(0xFFF8FAFC), child: Icon(Icons.person, size: 44, color: Color(0xFF0F172A)))),
        CircleAvatar(radius: 14, backgroundColor: Color(0xFF15803D), child: Icon(Icons.edit, size: 14, color: Colors.white)),
      ],
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE2E8F0))),
            child: Text(value, style: const TextStyle(fontSize: 13.5)),
          ),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF475569))),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(8)),
              child: Text(value, style: const TextStyle(fontSize: 12, color: Color(0xFF15803D), fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.title, required this.description, this.buttonLabel, this.icon, this.badge, this.trailingIcon});

  final String title;
  final String description;
  final String? buttonLabel;
  final IconData? icon;
  final String? badge;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              ],
            ),
          ),
          if (badge != null) ...[
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(8)), child: Text(badge!, style: const TextStyle(fontSize: 12, color: Color(0xFF15803D), fontWeight: FontWeight.w600))),
            const SizedBox(width: 10),
          ],
          if (buttonLabel != null)
            OutlinedButton.icon(
              onPressed: () {
                showBottomActionMessage(
                  context,
                  title: buttonLabel!,
                  subtitle: 'Aksi $buttonLabel sedang diproses.',
                  icon: icon ?? Icons.info_outline,
                  color: const Color(0xFF2563EB),
                );
              },
              icon: Icon(icon, size: 16),
              label: Text(buttonLabel!),
            )
          else if (trailingIcon != null)
            Icon(trailingIcon, size: 18, color: const Color(0xFF64748B)),
        ],
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) => const Divider(height: 1);
}

class _ActivityItem extends StatelessWidget {
  const _ActivityItem({required this.title, required this.subtitle, required this.time, required this.color, required this.icon});

  final String title;
  final String subtitle;
  final String time;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(radius: 15, backgroundColor: color.withValues(alpha: 0.12), child: Icon(icon, size: 16, color: color)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)), const SizedBox(height: 4), Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)))]),
          ),
          const SizedBox(width: 12),
          Text(time, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) => SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () { showBottomActionMessage(context, title: label, subtitle: 'Perubahan profil berhasil disimpan sementara.', icon: icon); }, icon: Icon(icon, size: 16), label: Text(label)));
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () { showBottomActionMessage(context, title: label, subtitle: 'Data aktivitas berhasil dimuat ulang.', color: const Color(0xFF2563EB), icon: Icons.refresh_outlined); }, child: Text(label)));
}

class _DangerButton extends StatelessWidget {
  const _DangerButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () { showBottomActionMessage(context, title: 'Logout berhasil', subtitle: 'Anda keluar dari sesi ini.', color: const Color(0xFFEF4444), icon: Icons.logout); }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white), child: Text(label)));
}
