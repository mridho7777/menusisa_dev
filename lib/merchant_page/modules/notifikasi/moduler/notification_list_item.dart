import 'package:flutter/material.dart';

import '../models/notifikasi_model.dart';
import 'notification_action_menu.dart';

class NotificationListItem extends StatelessWidget {
  final NotifikasiModel item;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final VoidCallback onMarkRead;
  final VoidCallback onDelete;

  const NotificationListItem({
    super.key,
    required this.item,
    required this.selected,
    required this.onSelected,
    required this.onMarkRead,
    required this.onDelete,
  });

  IconData _iconFor(String key) {
    switch (key) {
      case 'cart':
        return Icons.shopping_cart_outlined;
      case 'payment':
        return Icons.credit_card_outlined;
      case 'bell':
        return Icons.notifications_none_outlined;
      case 'user':
        return Icons.person_add_alt_1_outlined;
      case 'close':
        return Icons.cancel_outlined;
      case 'campaign':
        return Icons.campaign_outlined;
      case 'report':
        return Icons.insert_chart_outlined;
      case 'check':
        return Icons.verified_outlined;
      case 'wallet':
        return Icons.account_balance_wallet_outlined;
      case 'edit':
        return Icons.edit_outlined;
      case 'settings':
        return Icons.settings_outlined;
      default:
        return Icons.shopping_bag_outlined;
    }
  }

  Color _colorFor(String key) {
    switch (key) {
      case 'check':
        return const Color(0xFF10B981);
      case 'close':
        return const Color(0xFFEF4444);
      case 'edit':
        return const Color(0xFFF59E0B);
      case 'payment':
        return const Color(0xFF3B82F6);
      case 'user':
        return const Color(0xFF14B8A6);
      case 'campaign':
        return const Color(0xFF8B5CF6);
      case 'settings':
        return const Color(0xFF607D8B);
      case 'wallet':
        return const Color(0xFF0EA5E9);
      default:
        return const Color(0xFF0F6B43);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Row(
        children: [
          Checkbox(value: selected, onChanged: (value) => onSelected(value ?? false), activeColor: const Color(0xFF0F6B43)),
          const SizedBox(width: 10),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(color: _colorFor(item.iconKey).withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Icon(_iconFor(item.iconKey), color: _colorFor(item.iconKey), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: TextStyle(fontFamily: 'Quicksand', fontSize: 15, fontWeight: item.isRead ? FontWeight.w500 : FontWeight.bold, color: const Color(0xFF1E293B))),
                const SizedBox(height: 4),
                Text(item.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: 'Quicksand', fontSize: 12, color: Color(0xFF64748B))),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(item.timeLabel, style: const TextStyle(fontFamily: 'Quicksand', fontSize: 12, color: Color(0xFF64748B))),
          const SizedBox(width: 8),
          NotificationActionMenu(onMarkRead: onMarkRead, onDelete: onDelete),
        ],
      ),
    );
  }
}
