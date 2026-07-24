import 'package:menusisa_dev/super_admin/shared/widgets/admin_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';

// TODO: Supabase Integration
// Table: system_settings
// Columns: id (uuid), key (text), value (text), category (text), 
//          updated_by (uuid), updated_at (timestamp)
// Query: SELECT * FROM system_settings ORDER BY category, key

class SystemSettingsPage extends StatefulWidget {
  const SystemSettingsPage({super.key});

  @override
  State<SystemSettingsPage> createState() => _SystemSettingsPageState();
}

class _SystemSettingsPageState extends State<SystemSettingsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // General Settings
  final TextEditingController _siteNameController = TextEditingController(text: 'MenuSisa Admin');
  final TextEditingController _supportEmailController = TextEditingController(text: 'support@menusisa.id');
  final TextEditingController _timezoneController = TextEditingController(text: 'Asia/Jakarta');
  final TextEditingController _languageController = TextEditingController(text: 'Bahasa Indonesia');
  bool _maintenanceMode = false;
  
  // Security Settings
  bool _twoFactorAuth = false;
  bool _loginVerification = true;
  bool _passwordExpiration = false;
  int _sessionTimeout = 30;
  
  // Notification Settings
  bool _emailNotification = true;
  bool _smsNotification = false;
  bool _pushNotification = true;
  bool _systemAlerts = true;
  
  // Backup Settings
  bool _autoBackup = true;
  String _backupFrequency = 'Harian';
  String _lastBackup = '10 Jul 2026 00:00 WIB';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MenuProvider>().setRoute(AppRoutes.systemSettings);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _siteNameController.dispose();
    _supportEmailController.dispose();
    _timezoneController.dispose();
    _languageController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    // TODO: Save to Supabase
    AdminToast.show(context, 'Tindakan berhasil', type: AdminToastType.success);
  }

  void _resetSettings() {
    setState(() {
      _siteNameController.text = 'MenuSisa Admin';
      _supportEmailController.text = 'support@menusisa.id';
      _timezoneController.text = 'Asia/Jakarta';
      _languageController.text = 'Bahasa Indonesia';
      _maintenanceMode = false;
      _twoFactorAuth = false;
      _loginVerification = true;
      _passwordExpiration = false;
      _sessionTimeout = 30;
      _emailNotification = true;
      _smsNotification = false;
      _pushNotification = true;
      _systemAlerts = true;
      _autoBackup = true;
      _backupFrequency = 'Harian';
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const padding = EdgeInsets.fromLTRB(24, 18, 24, 20);

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
                  
                  // Tabs
                  _SectionCard(
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      labelColor: Colors.white,
                      unselectedLabelColor: const Color(0xFF6B7280),
                      indicator: BoxDecoration(
                        color: const Color(0xFF0F8D55),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(text: 'Umum'),
                        Tab(text: 'Keamanan'),
                        Tab(text: 'Notifikasi'),
                        Tab(text: 'Integrasi'),
                        Tab(text: 'Backup'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  
                  // Content
                  _SectionCard(
                    child: SizedBox(
                      height: 500,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildGeneralTab(),
                          _buildSecurityTab(),
                          _buildNotificationTab(),
                          _buildIntegrationTab(),
                          _buildBackupTab(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  
                  // Action Buttons
                  _SectionCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _resetSettings,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Reset ke Default'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: _saveSettings,
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF0F8D55),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
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

  Widget _buildGeneralTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pengaturan Umum',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          
          TextField(
            controller: _siteNameController,
            decoration: const InputDecoration(
              labelText: 'Nama Aplikasi',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.business_outlined),
            ),
          ),
          const SizedBox(height: 16),
          
          TextField(
            controller: _supportEmailController,
            decoration: const InputDecoration(
              labelText: 'Email Support',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 16),
          
          TextField(
            controller: _timezoneController,
            decoration: const InputDecoration(
              labelText: 'Timezone',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.schedule_outlined),
            ),
          ),
          const SizedBox(height: 16),
          
          TextField(
            controller: _languageController,
            decoration: const InputDecoration(
              labelText: 'Bahasa',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.language_outlined),
            ),
          ),
          const SizedBox(height: 16),
          
          SwitchListTile(
            value: _maintenanceMode,
            onChanged: (value) => setState(() => _maintenanceMode = value),
            title: const Text('Mode Maintenance'),
            subtitle: const Text('Nonaktifkan akses publik ke sistem'),
            secondary: const Icon(Icons.construction_outlined),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pengaturan Keamanan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          
          SwitchListTile(
            value: _twoFactorAuth,
            onChanged: (value) => setState(() => _twoFactorAuth = value),
            title: const Text('Two-Factor Authentication (2FA)'),
            subtitle: const Text('Tambahan lapisan keamanan untuk login'),
            secondary: const Icon(Icons.security_outlined),
          ),
          
          SwitchListTile(
            value: _loginVerification,
            onChanged: (value) => setState(() => _loginVerification = value),
            title: const Text('Verifikasi Perangkat Login'),
            subtitle: const Text('Verifikasi perangkat baru yang login'),
            secondary: const Icon(Icons.devices_outlined),
          ),
          
          SwitchListTile(
            value: _passwordExpiration,
            onChanged: (value) => setState(() => _passwordExpiration = value),
            title: const Text('Password Expiration'),
            subtitle: const Text('Wajib ganti password setiap 90 hari'),
            secondary: const Icon(Icons.lock_clock_outlined),
          ),
          const SizedBox(height: 16),
          
          const Text(
            'Session Timeout (menit)',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Slider(
            value: _sessionTimeout.toDouble(),
            min: 15,
            max: 120,
            divisions: 7,
            label: '$_sessionTimeout menit',
            onChanged: (value) => setState(() => _sessionTimeout = value.toInt()),
          ),
          Text(
            'Session akan berakhir setelah $_sessionTimeout menit tidak aktif',
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pengaturan Notifikasi',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          
          SwitchListTile(
            value: _emailNotification,
            onChanged: (value) => setState(() => _emailNotification = value),
            title: const Text('Notifikasi Email'),
            subtitle: const Text('Kirim notifikasi via email'),
            secondary: const Icon(Icons.email_outlined),
          ),
          
          SwitchListTile(
            value: _smsNotification,
            onChanged: (value) => setState(() => _smsNotification = value),
            title: const Text('Notifikasi SMS'),
            subtitle: const Text('Kirim notifikasi via SMS'),
            secondary: const Icon(Icons.sms_outlined),
          ),
          
          SwitchListTile(
            value: _pushNotification,
            onChanged: (value) => setState(() => _pushNotification = value),
            title: const Text('Push Notification'),
            subtitle: const Text('Notifikasi langsung di aplikasi'),
            secondary: const Icon(Icons.notifications_outlined),
          ),
          
          SwitchListTile(
            value: _systemAlerts,
            onChanged: (value) => setState(() => _systemAlerts = value),
            title: const Text('System Alerts'),
            subtitle: const Text('Peringatan sistem penting'),
            secondary: const Icon(Icons.warning_amber_outlined),
          ),
        ],
      ),
    );
  }

  Widget _buildIntegrationTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Integrasi Pihak Ketiga',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          
          _IntegrationCard(
            icon: Icons.payment_outlined,
            title: 'Payment Gateway',
            status: 'Aktif - Midtrans',
            color: const Color(0xFF0F8D55),
          ),
          const SizedBox(height: 12),
          
          _IntegrationCard(
            icon: Icons.mail_outline,
            title: 'Email Service',
            status: 'Aktif - SMTP Gmail',
            color: const Color(0xFF2563EB),
          ),
          const SizedBox(height: 12),
          
          _IntegrationCard(
            icon: Icons.cloud_outlined,
            title: 'Cloud Storage',
            status: 'Aktif - Supabase Storage',
            color: const Color(0xFF7C3AED),
          ),
          const SizedBox(height: 12),
          
          _IntegrationCard(
            icon: Icons.message_outlined,
            title: 'SMS Gateway',
            status: 'Tidak Aktif',
            color: const Color(0xFF6B7280),
          ),
          const SizedBox(height: 12),
          
          _IntegrationCard(
            icon: Icons.analytics_outlined,
            title: 'Analytics',
            status: 'Aktif - Google Analytics',
            color: const Color(0xFFF59E0B),
          ),
        ],
      ),
    );
  }

  Widget _buildBackupTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pengaturan Backup',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          
          SwitchListTile(
            value: _autoBackup,
            onChanged: (value) => setState(() => _autoBackup = value),
            title: const Text('Auto Backup'),
            subtitle: const Text('Backup otomatis sesuai jadwal'),
            secondary: const Icon(Icons.backup_outlined),
          ),
          const SizedBox(height: 16),
          
          DropdownButtonFormField<String>(
            initialValue: _backupFrequency,
            decoration: const InputDecoration(
              labelText: 'Frekuensi Backup',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.schedule_outlined),
            ),
            items: ['Harian', 'Mingguan', 'Bulanan']
                .map((freq) => DropdownMenuItem(value: freq, child: Text(freq)))
                .toList(),
            onChanged: (value) {
              if (value != null) setState(() => _backupFrequency = value);
            },
          ),
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informasi Backup Terakhir',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.access_time_outlined, size: 20, color: Color(0xFF6B7280)),
                    const SizedBox(width: 8),
                    Text(
                      _lastBackup,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(Icons.storage_outlined, size: 20, color: Color(0xFF6B7280)),
                    SizedBox(width: 8),
                    Text(
                      'Ukuran: 2.5 GB',
                      style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(Icons.check_circle_outline, size: 20, color: Color(0xFF15803D)),
                    SizedBox(width: 8),
                    Text(
                      'Status: Berhasil',
                      style: TextStyle(fontSize: 13, color: Color(0xFF15803D)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                AdminToast.show(context, 'Tindakan berhasil', type: AdminToastType.success);
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              icon: const Icon(Icons.backup_outlined),
              label: const Text('Jalankan Backup Sekarang'),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderBar extends StatelessWidget {
  const _HeaderBar();

  @override
  Widget build(BuildContext context) {
    return const Column(
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
          'Kelola seluruh pengaturan sistem secara terpusat dan konsisten',
          style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
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

class _IntegrationCard extends StatelessWidget {
  const _IntegrationCard({
    required this.icon,
    required this.title,
    required this.status,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    color: status.contains('Aktif') ? const Color(0xFF15803D) : const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined, size: 20),
            tooltip: 'Konfigurasi',
          ),
        ],
      ),
    );
  }
}
