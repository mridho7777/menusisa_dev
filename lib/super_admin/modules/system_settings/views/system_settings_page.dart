import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';
import '../widgets/system_settings_widgets.dart';

class SystemSettingsPage extends StatefulWidget {
  const SystemSettingsPage({super.key});

  @override
  State<SystemSettingsPage> createState() => _SystemSettingsPageState();
}

class _SystemSettingsPageState extends State<SystemSettingsPage> {
  final List<String> _tabs = const [
    'General',
    'Akun',
    'Keamanan',
    'Notifikasi',
    'Integrasi',
    'Backup',
  ];
  int _selectedTab = 0;
  bool _darkMode = false;
  bool _autoBackup = true;
  bool _emailNotification = true;
  bool _smsNotification = false;
  final TextEditingController _siteName = TextEditingController(
    text: 'MenuSisa Admin',
  );
  final TextEditingController _supportEmail = TextEditingController(
    text: 'support@menusisa.id',
  );
  final TextEditingController _timezone = TextEditingController(
    text: 'Asia/Jakarta',
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<MenuProvider>().setRoute(AppRoutes.systemSettings);
  }

  @override
  void dispose() {
    _siteName.dispose();
    _supportEmail.dispose();
    _timezone.dispose();
    super.dispose();
  }

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pengaturan berhasil disimpan')),
    );
  }

  Widget _content() {
    switch (_selectedTab) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pengaturan Umum',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _siteName,
              decoration: const InputDecoration(labelText: 'Nama Aplikasi'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _supportEmail,
              decoration: const InputDecoration(labelText: 'Email Support'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _timezone,
              decoration: const InputDecoration(labelText: 'Timezone'),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: _darkMode,
              onChanged: (v) => setState(() => _darkMode = v),
              title: const Text('Dark Mode'),
            ),
          ],
        );
      case 1:
        return Column(
          children: [
            const Text(
              'Pengaturan Akun',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            _SimpleLine(label: 'Nama Admin', value: 'Super Admin'),
            _SimpleLine(label: 'Role', value: 'Full Access'),
            _SimpleLine(label: 'Status Login', value: 'Aktif'),
          ],
        );
      case 2:
        return Column(
          children: [
            const Text(
              'Keamanan',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: true,
              onChanged: (_) {},
              title: const Text('Two-Factor Authentication'),
            ),
            SwitchListTile(
              value: true,
              onChanged: (_) {},
              title: const Text('Login Device Verification'),
            ),
            SwitchListTile(
              value: false,
              onChanged: (_) {},
              title: const Text('Password Expiration'),
            ),
          ],
        );
      case 3:
        return Column(
          children: [
            const Text(
              'Notifikasi',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: _emailNotification,
              onChanged: (v) => setState(() => _emailNotification = v),
              title: const Text('Email Notification'),
            ),
            SwitchListTile(
              value: _smsNotification,
              onChanged: (v) => setState(() => _smsNotification = v),
              title: const Text('SMS Notification'),
            ),
            SwitchListTile(
              value: true,
              onChanged: (_) {},
              title: const Text('In-App Notification'),
            ),
          ],
        );
      case 4:
        return Column(
          children: [
            const Text(
              'Integrasi',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            _SimpleLine(label: 'Payment Gateway', value: 'Midtrans'),
            _SimpleLine(label: 'Email Provider', value: 'SMTP'),
            _SimpleLine(label: 'Push Service', value: 'Firebase'),
          ],
        );
      default:
        return Column(
          children: [
            const Text(
              'Backup',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: _autoBackup,
              onChanged: (v) => setState(() => _autoBackup = v),
              title: const Text('Auto Backup Harian'),
            ),
            _SimpleLine(label: 'Last Backup', value: '20 Mei 2025 23:00'),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                child: const Text('Jalankan Backup Sekarang'),
              ),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  SettingsSectionCard(
                    child: SettingsTabBar(
                      tabs: _tabs,
                      selectedIndex: _selectedTab,
                      onSelected: (index) =>
                          setState(() => _selectedTab = index),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SettingsSectionCard(
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: _content()),
                        const SizedBox(width: 14),
                        const Expanded(flex: 2, child: SettingsOverviewGrid()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  SettingsSectionCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _siteName.text = 'MenuSisa Admin';
                                _supportEmail.text = 'support@menusisa.id';
                                _timezone.text = 'Asia/Jakarta';
                                _darkMode = false;
                                _autoBackup = true;
                                _emailNotification = true;
                                _smsNotification = false;
                              });
                            },
                            child: const Text('Reset'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: _save,
                            child: const Text('Simpan Perubahan'),
                          ),
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
  const _HeaderBar();
  @override
  Widget build(BuildContext context) => const Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'System Settings',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
            SizedBox(height: 3),
            Text(
              'Kelola seluruh pengaturan sistem secara terpusat dan konsisten.',
              style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
      SizedBox(width: 12),
    ],
  );
}

class _SimpleLine extends StatelessWidget {
  const _SimpleLine({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Expanded(child: Text(label)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    ),
  );
}
