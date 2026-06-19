import 'package:flutter/material.dart';

import '../models/dashboard_models.dart';

class DashboardNotificationTray extends StatelessWidget {
  const DashboardNotificationTray({
    super.key,
    required this.items,
    required this.onDismiss,
    required this.onOpenAll,
  });

  final List<DashboardNotice> items;
  final ValueChanged<DashboardNotice> onDismiss;
  final VoidCallback onOpenAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...items.map((item) {
          final icon = switch (item.icon) {
            'store' => Icons.store_rounded,
            'inventory_2' => Icons.inventory_2_rounded,
            'receipt_long' => Icons.receipt_long_rounded,
            'payments' => Icons.payments_rounded,
            'warning' => Icons.warning_rounded,
            _ => Icons.notifications_rounded,
          };

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Color(item.color).withValues(alpha: 0.38)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0C000000),
                    blurRadius: 14,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Color(item.color).withValues(alpha: 0.14),
                    child: Icon(icon, size: 16, color: Color(item.color)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.subtitle,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.time,
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.close_rounded, size: 18),
                    onPressed: () => onDismiss(item),
                  ),
                ],
              ),
            ),
          );
        }),
        SizedBox(
          width: double.infinity,
          child: FilledButton.tonal(
            onPressed: onOpenAll,
            child: const Text('Lihat Semua Notifikasi'),
          ),
        ),
      ],
    );
  }
}
