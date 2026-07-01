import 'package:flutter/material.dart';

import '../models/merchant_management_models.dart';

class MerchantTopMerchantList extends StatelessWidget {
  const MerchantTopMerchantList({super.key, required this.items});

  final List<MerchantTopMerchant> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Color(item.color).withOpacity(0.16),
                child: Text(
                  item.rank,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(item.color),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.orders,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                item.revenue,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class MerchantActionGrid extends StatelessWidget {
  const MerchantActionGrid({
    super.key,
    required this.actions,
    required this.onActionTap,
  });

  final List<MerchantQuickAction> actions;
  final ValueChanged<MerchantQuickAction> onActionTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 700 ? 2 : 3;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 3.4,
          ),
          itemBuilder: (context, index) {
            final action = actions[index];
            final icon = switch (action.icon) {
              'add' => Icons.add_rounded,
              'person_add' => Icons.person_add_rounded,
              'campaign' => Icons.campaign_rounded,
              'description' => Icons.description_rounded,
              'summarize' => Icons.summarize_rounded,
              'settings' => Icons.settings_rounded,
              'local_offer' => Icons.local_offer_rounded,
              'dashboard_customize' => Icons.dashboard_customize_rounded,
              _ => Icons.circle,
            };
            return OutlinedButton.icon(
              onPressed: () => onActionTap(action),
              icon: Icon(icon, size: 18),
              label: Text(action.label),
            );
          },
        );
      },
    );
  }
}

class MerchantNotificationTray extends StatelessWidget {
  const MerchantNotificationTray({
    super.key,
    required this.items,
    required this.onClearAll,
  });

  final List<MerchantNotification> items;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Notifikasi Aksi',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
              TextButton(
                onPressed: onClearAll,
                child: const Text('Hapus Semua'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'Belum ada aksi yang memunculkan notifikasi.',
                  style: TextStyle(color: Color(0xFF6B7280)),
                ),
              ),
            )
          else
            Column(
              children: items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(item.color).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Color(item.color).withOpacity(0.24),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 13,
                          backgroundColor: Color(
                            item.color,
                          ).withOpacity(0.16),
                          child: Icon(
                            switch (item.subtitle.contains('ditolak') ||
                                item.icon == 'cancel') {
                              true => Icons.cancel_rounded,
                              _ when item.icon == 'warning' =>
                                Icons.warning_rounded,
                              _ => Icons.check_rounded,
                            },
                            size: 15,
                            color: Color(item.color),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.subtitle,
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
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
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
