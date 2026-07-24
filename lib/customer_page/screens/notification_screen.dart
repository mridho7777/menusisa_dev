// Supabase Integration Reference:
// - customer_id, merchant_id, product_id, order_id, favorite_id, cart_item_id
// - order_code, product_name, merchant_name, category_id, rating, distance_km
// - image_url for product_images, proof_image_url for payment_proofs
// - Use this file as the UI binding layer only; data should come from Supabase tables and joins.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../utils/app_colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final Set<int> _selectedIndexes = {};

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final notifications = state.notifications;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 4),
                  const Expanded(
                    child: Text(
                      'Notifikasi',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                  ),
                  TextButton(
                    onPressed: notifications.isEmpty ? null : _toggleSelectAll,
                    child: Text(_selectedIndexes.length == notifications.length && notifications.isNotEmpty ? 'Batal Pilih' : 'Select All'),
                  ),
                  TextButton(
                    onPressed: _selectedIndexes.isEmpty ? null : _deleteSelected,
                    child: const Text('Hapus'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: notifications.isEmpty
                  ? const _EmptyNotificationState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      itemCount: notifications.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = notifications[index];
                        final selected = _selectedIndexes.contains(index);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selected) {
                                _selectedIndexes.remove(index);
                              } else {
                                _selectedIndexes.add(index);
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: selected ? AppColors.primary : AppColors.border),
                            ),
                            child: Row(
                              children: [
                                Checkbox(value: selected, onChanged: (_) => setState(() => selected ? _selectedIndexes.remove(index) : _selectedIndexes.add(index))),
                                Container(width: 42, height: 42, decoration: BoxDecoration(color: item.color.withValues(alpha: 0.12), shape: BoxShape.circle), child: Icon(item.icon, color: item.color, size: 22)),
                                const SizedBox(width: 12),
                                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item.title, style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 4), Text(item.body, style: const TextStyle(color: Colors.black54, height: 1.35))])),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(currentIndex: context.watch<AppState>().currentNavIndex),
    );
  }

  void _toggleSelectAll() {
    setState(() {
      if (_selectedIndexes.length == context.read<AppState>().notifications.length) {
        _selectedIndexes.clear();
      } else {
        _selectedIndexes
          ..clear()
          ..addAll(List.generate(context.read<AppState>().notifications.length, (index) => index));
      }
    });
  }

  void _deleteSelected() {
    final indexes = _selectedIndexes.toList()..sort((a, b) => b.compareTo(a));
    for (final index in indexes) {
      context.read<AppState>().removeNotificationAt(index);
    }
    setState(() => _selectedIndexes.clear());
  }
}

class _EmptyNotificationState extends StatelessWidget {
  const _EmptyNotificationState();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 16, offset: Offset(0, 6))],
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.notifications_none_outlined, size: 52, color: Color(0xFF9CA3AF)),
          SizedBox(height: 16),
          Text('Belum ada notifikasi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
          SizedBox(height: 8),
          Text('Semua update pesanan dan favorit akan muncul di sini.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF6B7280), height: 1.4)),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentIndex});
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home_outlined, Icons.home, 'Beranda', 0),
      (Icons.favorite_border, Icons.favorite, 'Favorit', 1),
      (Icons.shopping_bag_outlined, Icons.shopping_bag, 'Belanja', 2),
      (Icons.receipt_long_outlined, Icons.receipt_long, 'Pesanan', 3),
      (Icons.person_outline, Icons.person, 'Profil', 4),
    ];
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, -4))], border: const Border(top: BorderSide(color: AppColors.border, width: 0.5))),
        child: Row(children: List.generate(items.length, (index) {
          final item = items[index];
          final selected = currentIndex == item.$4;
          return Expanded(child: GestureDetector(onTap: () => context.read<AppState>().changeNavIndex(item.$4), child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(selected ? item.$2 : item.$1, color: selected ? AppColors.primary : Colors.grey, size: 22), const SizedBox(height: 4), Text(item.$3, style: TextStyle(fontSize: 10, color: selected ? AppColors.primary : Colors.grey, fontWeight: selected ? FontWeight.bold : FontWeight.normal))])));
        })),
      ),
    );
  }
}


