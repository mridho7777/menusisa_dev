import 'package:flutter/material.dart';
import '../models/system_settings_models.dart';

class SettingsSectionCard extends StatelessWidget {
  const SettingsSectionCard({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
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

class SettingsTabBar extends StatelessWidget {
  const SettingsTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onSelected,
  });
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFE5E7EB)),
    ),
    child: Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(tabs.length, (index) {
        final selected = index == selectedIndex;
        return ChoiceChip(
          label: Text(tabs[index]),
          selected: selected,
          onSelected: (_) => onSelected(index),
          selectedColor: const Color(0xFF0F8D55).withValues(alpha: 0.12),
          labelStyle: TextStyle(
            color: selected ? const Color(0xFF0F8D55) : const Color(0xFF374151),
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    ),
  );
}

class SettingsOverviewGrid extends StatelessWidget {
  const SettingsOverviewGrid({super.key});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      ...systemSettingsOverview.map(
        (item) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Color(item.color).withValues(alpha: 0.14),
                child: Icon(
                  _icon(item.icon),
                  size: 14,
                  color: Color(item.color),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.label,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
              Text(
                item.value,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 8),
      SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () {},
          child: const Text('Cek Status Sistem'),
        ),
      ),
    ],
  );
}

IconData _icon(String name) => switch (name) {
  'info' => Icons.info_outline_rounded,
  'database' => Icons.storage_rounded,
  'server' => Icons.dns_rounded,
  'php' => Icons.code_rounded,
  'admin' => Icons.person_rounded,
  'store' => Icons.store_rounded,
  'users' => Icons.people_alt_rounded,
  _ => Icons.settings_rounded,
};
