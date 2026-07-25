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

const systemSettingsOverview = <SettingsOverviewItem>[];
