class SettingsOverviewItem {
  final String label;
  final String value;
  final String icon;
  final int color;

  const SettingsOverviewItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}

const systemSettingsOverview = [
  SettingsOverviewItem(
    label: 'Versi Sistem',
    value: '1.0.0',
    icon: 'info',
    color: 0xFF0F8D55,
  ),
  SettingsOverviewItem(
    label: 'Database',
    value: 'MySQL 8.0',
    icon: 'database',
    color: 0xFF2563EB,
  ),
  SettingsOverviewItem(
    label: 'Server',
    value: 'Nginx 1.24',
    icon: 'server',
    color: 0xFFF59E0B,
  ),
  SettingsOverviewItem(
    label: 'PHP Version',
    value: '8.2.10',
    icon: 'php',
    color: 0xFF7C3AED,
  ),
  SettingsOverviewItem(
    label: 'Total Admin',
    value: '5',
    icon: 'admin',
    color: 0xFFEF4444,
  ),
  SettingsOverviewItem(
    label: 'Total Merchant',
    value: '1.245',
    icon: 'store',
    color: 0xFF14B8A6,
  ),
  SettingsOverviewItem(
    label: 'Total User Aktif',
    value: '3.462',
    icon: 'users',
    color: 0xFF0F8D55,
  ),
];
