// Supabase Integration: products, merchants, product_images, favorites, product_reviews
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../services/supabase_service.dart';
import '../utils/app_colors.dart';
import '../widgets/notification_popup.dart';

Widget _infoRow(IconData icon, String label, String value) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
    decoration: BoxDecoration(
      color: const Color(0xFFF9FAFB),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFE5E7EB)),
    ),
    child: Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade700),
        const SizedBox(width: 10),
        SizedBox(
          width: 84,
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 13, color: Color(0xFF374151)),
          ),
        ),
      ],
    ),
  );
}



Widget _chip(String label, Color backgroundColor, Color textColor) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w700,
        fontSize: 12,
      ),
    ),
  );
}

class DetailProdukScreen extends StatefulWidget {
  const DetailProdukScreen({super.key, required this.food});
  final FoodItem food;

  @override
  State<DetailProdukScreen> createState() => _DetailProdukScreenState();
}

class _DetailProdukScreenState extends State<DetailProdukScreen> {
  final _supabase = SupabaseService.instance;
  int _quantity = 1;
  bool _isLoading = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    if (!_supabase.isAuthenticated) return;
    try {
      final isFav = await _supabase.isFavorite(
        _supabase.userId!,
        widget.food.id,
      );
      if (!mounted) return;
      setState(() => _isFavorite = isFav);
    } catch (_) {}
  }

  Future<void> _toggleFavorite() async {
    final state = context.read<AppState>();
    if (_supabase.isAuthenticated) {
      setState(() => _isLoading = true);
      try {
        await _supabase.toggleFavorite(_supabase.userId!, widget.food.id);
        if (!mounted) return;
        setState(() => _isFavorite = !_isFavorite);
        NotificationPopup.show(
          context,
          title: _isFavorite
              ? 'Ditambahkan ke Favorit'
              : 'Dihapus dari Favorit',
          message: widget.food.title,
          icon: Icons.favorite,
          color: _isFavorite ? const Color(0xFFEF4444) : Colors.grey,
        );
      } catch (_) {
        if (!mounted) return;
        NotificationPopup.show(
          context,
          title: 'Gagal',
          message: 'Tidak dapat mengubah favorit.',
          icon: Icons.error_outline,
          color: Colors.red,
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } else {
      state.toggleFavorite(widget.food);
      NotificationPopup.show(
        context,
        title: state.isFavorite(widget.food.id)
            ? 'Ditambahkan ke Favorit'
            : 'Dihapus dari Favorit',
        message: widget.food.title,
        icon: Icons.favorite,
        color: const Color(0xFFEF4444),
      );
    }
  }

  Future<void> _addToCart() async {
    final state = context.read<AppState>();
    if (_supabase.isAuthenticated) {
      setState(() => _isLoading = true);
      try {
        await _supabase.addToCart(_supabase.userId!, widget.food.id, _quantity);
        if (!mounted) return;
        final added = await state.addToCart(widget.food);
        if (!mounted) return;
        if (added) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('Item ditambahkan ke keranjang')),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      state.changeNavIndex(3);
                    },
                    child: const Text(
                      'LIHAT',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (_) {
        if (!mounted) return;
        NotificationPopup.show(
          context,
          title: 'Gagal',
          message: 'Tidak dapat menambahkan ke keranjang.',
          icon: Icons.error_outline,
          color: Colors.red,
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } else {
      final added = await state.addToCart(widget.food);
      if (!mounted) return;
      if (added) {
        NotificationPopup.show(
          context,
          title: 'Ditambahkan ke Keranjang',
          message: 'Produk berhasil ditambahkan',
          icon: Icons.shopping_cart,
          color: AppColors.primary,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.food.title),
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
            color: _isFavorite ? Colors.red : null,
            onPressed: _isLoading ? null : _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AspectRatio(
                aspectRatio: 1.05,
                child: widget.food.imageUrl != null && widget.food.imageUrl!.isNotEmpty
                    ? Image.network(
                        widget.food.imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, __, ___) => const ColoredBox(
                          color: Color(0xFFF3F4F6),
                          child: Center(child: Icon(Icons.fastfood, size: 64, color: Color(0xFFD1D5DB))),
                        ),
                      )
                    : const ColoredBox(
                        color: Color(0xFFF3F4F6),
                        child: Center(child: Icon(Icons.fastfood, size: 64, color: Color(0xFFD1D5DB))),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _chip(widget.food.category, const Color(0xFFE8F5E9), const Color(0xFF166534)),
                if (widget.food.tag.isNotEmpty)
                  _chip(widget.food.tag, const Color(0xFFEDE9FE), const Color(0xFF4C1D95)),
                _chip(widget.food.store, const Color(0xFFF3F4F6), const Color(0xFF374151)),
              ],
            ),
            const SizedBox(height: 12),
            Text(widget.food.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 18),
                const SizedBox(width: 4),
                Text(widget.food.rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(width: 12),
                const Icon(Icons.location_on_outlined, color: Colors.grey, size: 18),
                const SizedBox(width: 4),
                Text(widget.food.distance, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              state.formatRp(widget.food.price.toInt()),
              style: const TextStyle(fontSize: 24, color: AppColors.primary, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              state.formatRp(widget.food.originalPrice.toInt()),
              style: const TextStyle(fontSize: 14, color: Colors.grey, decoration: TextDecoration.lineThrough),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                children: [
                  _infoRow(Icons.storefront_outlined, 'Toko', widget.food.store),
                  const SizedBox(height: 10),
                  _infoRow(Icons.category_outlined, 'Kategori', widget.food.category),
                  const SizedBox(height: 10),
                  _infoRow(Icons.inventory_2_outlined, 'Stok', widget.food.stockLabel),
                  const SizedBox(height: 10),
                  _infoRow(Icons.sell_outlined, 'Harga', state.formatRp(widget.food.price.toInt())),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Deskripsi',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'Produk dari merchant "${widget.food.store}" siap dipesan sesuai stok dan harga yang ditampilkan di atas.',
              style: const TextStyle(height: 1.5, color: Color(0xFF374151)),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                const Text(
                  'Jumlah:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    if (_quantity > 1) setState(() => _quantity--);
                  },
                ),
                Text(
                  '$_quantity',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => setState(() => _quantity++),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _addToCart,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Tambah ke Keranjang',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ),
    );
  }
}
