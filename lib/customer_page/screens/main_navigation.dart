// Supabase Integration Reference:
// - customer_id, merchant_id, product_id, order_id, favorite_id, cart_item_id
// - order_code, product_name, merchant_name, category_id, rating, distance_km
// - image_url for product_images, proof_image_url for payment_proofs
// - Use this file as the UI binding layer only; data should come from Supabase tables and joins.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../utils/app_colors.dart';
import 'favorite_screen.dart';
import 'home_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';
import 'shop_screen.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final pages = const [
          HomeScreen(),
          FavoriteScreen(),
          ShopScreen(),
          OrdersScreen(),
          ProfileScreen(),
        ];

        return Scaffold(
          body: SafeArea(
            child: IndexedStack(
              index: state.currentNavIndex,
              children: pages,
            ),
          ),
          bottomNavigationBar: const _BottomNav(),
        );
      },
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
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
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
          border: const Border(top: BorderSide(color: AppColors.border, width: 0.5)),
        ),
        child: Row(
          children: List.generate(items.length, (index) {
            final item = items[index];
            final selected = state.currentNavIndex == item.$4;

            if (index == 2) {
              return Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => context.read<AppState>().changeNavIndex(2),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shopping_bag,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.$3,
                      style: TextStyle(
                        fontSize: 10,
                        color: selected ? AppColors.primary : Colors.grey,
                        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Expanded(
              child: GestureDetector(
                onTap: () => context.read<AppState>().changeNavIndex(item.$4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      selected ? item.$2 : item.$1,
                      color: selected ? AppColors.primary : Colors.grey,
                      size: 22,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.$3,
                      style: TextStyle(
                        fontSize: 10,
                        color: selected ? AppColors.primary : Colors.grey,
                        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

