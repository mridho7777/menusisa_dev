// Supabase Integration Reference:
// - customer_id, merchant_id, product_id, order_id, favorite_id, cart_item_id
// - order_code, product_name, merchant_name, category_id, rating, distance_km
// - image_url for product_images, proof_image_url for payment_proofs
// - Use this file as the UI binding layer only; data should come from Supabase tables and joins.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../utils/app_colors.dart';
import '../widgets/customer_top_header.dart';
import '../widgets/food_card.dart';
import '../services/supabase_service.dart';
import 'detail_produk_screen.dart';
import 'notification_screen.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final TextEditingController _searchController = TextEditingController();
  final _supabase = SupabaseService.instance;
  List<FoodItem> _products = [];
  List<String> _categories = const [
    'Semua',
    'Makanan',
    'Minuman',
    'Snack',
    'Lainnya',
  ];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadProducts();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadCategories() async {
    final categories = await _supabase.getCategories();
    if (mounted) setState(() => _categories = categories);
  }

  void _onSearchChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await _supabase.getProducts();
      final loaded = data.map((item) {
        final merchant = item['merchants'] as Map<String, dynamic>?;
        final category = item['categories'] as Map<String, dynamic>?;
        return FoodItem(
          id: item['id'] as String,
          merchantId: item['merchant_id'] as String? ?? '',
          title: item['name'] as String,
          store: merchant?['shop_name'] as String? ?? 'Merchant',
          merchantLogoUrl: merchant?['shop_logo_url'] as String?,
          imageUrl:
              item['product_image_url'] as String? ??
              (() {
                final images = item['product_images'] as List<dynamic>?;
                if (images == null || images.isEmpty) return null;
                final primary = images.firstWhere(
                  (entry) => entry['is_primary'] == true,
                  orElse: () => images.first,
                );
                return primary['image_url'] as String?;
              })(),
          price: (item['price'] as num).toDouble(),
          originalPrice:
              (item['original_price'] as num?)?.toDouble() ??
              (item['price'] as num).toDouble(),
          tag: item['tag'] as String? ?? '',
          rating: (item['rating'] as num?)?.toDouble() ?? 4.5,
          distance: '${(item['distance_km'] as num?)?.toDouble() ?? 0} km',
          category:
              category?['name'] as String? ??
              item['category_name'] as String? ??
              'Makanan',
        );
      }).toList();

      if (mounted) {
        setState(() {
          _products = loaded;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    // Filter products locally by search and category chip selection
    final selectedCategory =
        _categories[state.selectedCategoryIndex.clamp(
          0,
          _categories.length - 1,
        )];
    final searchText = _searchController.text.toLowerCase();

    final filteredProducts = _products.where((p) {
      final matchesCategory =
          selectedCategory == 'Semua' ||
          p.category.toLowerCase() == selectedCategory.toLowerCase();
      final matchesSearch =
          p.title.toLowerCase().contains(searchText) ||
          p.store.toLowerCase().contains(searchText);
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth < 600 ? 16.0 : 24.0;
            return RefreshIndicator(
              onRefresh: _loadProducts,
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  18,
                  horizontalPadding,
                  24,
                ),
                children: [
                  CustomerTopHeader(
                    onNotificationTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Belanja',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pilih produk yang ingin kamu beli',
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari produk...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (context, _) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final selected = index == state.selectedCategoryIndex;
                        return ChoiceChip(
                          label: Text(_categories[index]),
                          selected: selected,
                          onSelected: (_) {
                            context.read<AppState>().setCategoryIndex(index);
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _isLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : filteredProducts.isEmpty
                      ? Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 32,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0A000000),
                                blurRadius: 16,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 52,
                                color: Color(0xFF9CA3AF),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Tidak ada produk tersedia',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Coba ganti kategori atau tunggu merchant menambahkan produk baru.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF6B7280),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredProducts.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: constraints.maxWidth >= 1200
                                    ? 4
                                    : constraints.maxWidth >= 900
                                    ? 3
                                    : 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                mainAxisExtent: 340,
                              ),
                          itemBuilder: (context, index) {
                            final food = filteredProducts[index];
                            return FoodCard(
                              food: food,
                              onTap: () => showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => FractionallySizedBox(
                                  heightFactor: 0.96,
                                  child: DetailProdukScreen(food: food),
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
