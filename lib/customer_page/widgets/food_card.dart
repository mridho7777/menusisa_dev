import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../utils/app_colors.dart';

// ============================================================================
// SUPABASE DATABASE INTEGRATION COMMENTS
// ============================================================================
// products table:
// - product_id (UUID, PK) -> food.id
// - product_name (TEXT) -> food.title
// - product_image_url (TEXT) - product image URL
// - merchant_id (UUID, FK) -> merchants.merchant_id
// - price (DECIMAL) -> food.price
// - original_price (DECIMAL) -> food.originalPrice
// - rating (DECIMAL) -> food.rating
// - stock_quantity (INTEGER)
// - tag (TEXT) -> food.tag
// - category (TEXT) -> food.category
//
// merchants table:
// - merchant_id (UUID, PK)
// - merchant_name (TEXT) -> food.store
// - latitude, longitude (DECIMAL)
//
// favorites table:
// - favorite_id (UUID, PK)
// - customer_id (UUID, FK)
// - product_id (UUID, FK)
// - created_at (TIMESTAMP)
// ============================================================================

class FoodCard extends StatelessWidget {
  final FoodItem food;
  final VoidCallback onTap;
  final bool showFavoriteButton;

  const FoodCard({
    super.key,
    required this.food,
    required this.onTap,
    this.showFavoriteButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final isCompact = width < 175;
              final tagStyle = TextStyle(
                color: Colors.white,
                fontSize: isCompact ? 8.5 : 9.5,
                fontWeight: FontWeight.w700,
              );
              final titleStyle = TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: isCompact ? 12.5 : 13.5,
                height: 1.1,
              );
              final metaStyle = TextStyle(
                color: Colors.grey,
                fontSize: isCompact ? 10.5 : 11.5,
              );
              final priceStyle = TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
                fontSize: isCompact ? 13.5 : 14.5,
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 134,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: ColoredBox(
                            color: const Color(0xFFF3F4F6),
                            child: food.imageUrl != null && food.imageUrl!.isNotEmpty
                                ? Image.network(
                                    food.imageUrl!,
                                    fit: BoxFit.cover,
                                    gaplessPlayback: true,
                                    filterQuality: FilterQuality.medium,
                                    errorBuilder: (context, error, stackTrace) => const Center(
                                      child: Icon(Icons.fastfood, size: 42, color: Color(0xFFD1D5DB)),
                                    ),
                                  )
                                : const Center(
                                    child: Icon(Icons.fastfood, size: 42, color: Color(0xFFD1D5DB)),
                                  ),
                          ),
                        ),
                        if (food.tag.isNotEmpty)
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: _getTagColor(food.tag),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(food.tag, style: tagStyle),
                            ),
                          ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.62),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(food.stockLabel, style: tagStyle),
                          ),
                        ),
                        if (showFavoriteButton)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: _FavoriteButton(food: food),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(food.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: titleStyle),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: const Color(0xFFE5E7EB),
                              backgroundImage: food.merchantLogoUrl != null && food.merchantLogoUrl!.isNotEmpty ? NetworkImage(food.merchantLogoUrl!) : null,
                              child: food.merchantLogoUrl == null || food.merchantLogoUrl!.isEmpty ? const Icon(Icons.store, size: 12, color: Color(0xFF6B7280)) : null,
                            ),
                            const SizedBox(width: 6),
                            Expanded(child: Text(food.store, maxLines: 1, overflow: TextOverflow.ellipsis, style: metaStyle.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF374151)))),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(food.category, maxLines: 1, overflow: TextOverflow.ellipsis, style: metaStyle.copyWith(color: const Color(0xFF0F8D55), fontWeight: FontWeight.w600)),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.orange, size: 14),
                            const SizedBox(width: 3),
                            Text(food.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                            const SizedBox(width: 10),
                            const Icon(Icons.location_on_outlined, color: Colors.grey, size: 14),
                            const SizedBox(width: 2),
                            Text('0 km', style: metaStyle),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Flexible(child: Text(_formatRp(food.originalPrice.toInt()), style: metaStyle.copyWith(decoration: TextDecoration.lineThrough), overflow: TextOverflow.ellipsis)),
                            const SizedBox(width: 8),
                            Flexible(child: Text(_formatRp(food.price.toInt()), style: priceStyle, overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 38,
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: onTap,
                                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                  child: const Text('Pesan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                ),
                              ),
                              if (showFavoriteButton) ...[
                                const SizedBox(width: 8),
                                _SecondaryFavoriteButton(food: food),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Color _getTagColor(String tag) {
    return switch (tag.toLowerCase()) {
      'blind bag' => const Color(0xFF4338CA),
      'get pashed' => const Color(0xFF15803D),
      'hemat' => const Color(0xFFF97316),
      'segar' => const Color(0xFF16A34A),
      'sehat' => const Color(0xFF16A34A),
      'baru' => const Color(0xFFF97316),
      'premium' => const Color(0xFF0F766E),
      'fresh' => const Color(0xFF2563EB),
      _ => AppColors.primary,
    };
  }

  String _formatRp(int value) =>
      'Rp${value.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}';
}

class _FavoriteButton extends StatelessWidget {
  final FoodItem food;
  const _FavoriteButton({required this.food});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final isFavorite = state.isFavorite(food.id);
        return Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.68),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => state.toggleFavorite(food),
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: const Color(0xFFEF4444),
              size: 18,
            ),
          ),
        );
      },
    );
  }
}

class _SecondaryFavoriteButton extends StatelessWidget {
  final FoodItem food;
  const _SecondaryFavoriteButton({required this.food});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 38,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Consumer<AppState>(
          builder: (context, state, _) {
            final isFavorite = state.isFavorite(food.id);
            return IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => state.toggleFavorite(food),
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: const Color(0xFFEF4444),
                size: 18,
              ),
            );
          },
        ),
      ),
    );
  }
}

// Supabase Integration Reference:
// - customer_id, merchant_id, product_id, order_id, favorite_id, cart_item_id
// - order_code, product_name, merchant_name, category_id, rating, distance_km
// - image_url for product_images, proof_image_url for payment_proofs
// - Use this file as the UI binding layer only; data should come from Supabase tables and joins.




