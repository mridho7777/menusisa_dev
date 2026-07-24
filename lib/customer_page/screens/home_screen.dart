// Supabase Integration: products, merchants, product_images, categories, favorites
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../app_state.dart';
import '../utils/app_colors.dart';
import '../widgets/customer_top_header.dart';
import '../widgets/food_card.dart';
import '../services/supabase_service.dart';
import 'detail_produk_screen.dart';
import 'notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _supabase = SupabaseService.instance;
  final TextEditingController _searchController = TextEditingController();
  RealtimeChannel? _productsSub;
  RealtimeChannel? _commissionSub;
  int _currentBannerIndex = 0;
  List<FoodItem> _products = [];
  List<String> _categories = const [
    'Semua',
    'Makanan',
    'Minuman',
    'Snack',
    'Lainnya',
  ];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadProducts();
    _startProductsSubscription();
    _searchController.addListener(() { if (mounted) setState(() {}); });
  }

  Future<void> _loadCategories() async {
    final categories = await _supabase.getCategories();
    if (mounted) setState(() => _categories = categories);
  }

  Future<void> _startProductsSubscription() async {
    _productsSub?.unsubscribe();
    _commissionSub?.unsubscribe();
    _productsSub = Supabase.instance.client
        .channel('public:products')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'products',
          callback: (_) => _loadProducts(),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'products',
          callback: (_) => _loadProducts(),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'products',
          callback: (_) => _loadProducts(),
        )
        .subscribe();

    _commissionSub = Supabase.instance.client
        .channel('public:product_commissions')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'product_commissions',
          callback: (_) => _loadProducts(),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'product_commissions',
          callback: (_) => _loadProducts(),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'product_commissions',
          callback: (_) => _loadProducts(),
        )
        .subscribe();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final state = context.read<AppState>();
      final selectedCategory =
          _categories[state.selectedCategoryIndex.clamp(
            0,
            _categories.length - 1,
          )];

      final data = await _supabase.getProducts(
        category: selectedCategory == 'Semua' ? null : selectedCategory,
      );

      if (mounted) {
        setState(() {
          _products = data.map((item) {
            final merchant = item['merchants'] as Map<String, dynamic>?;
            final category = item['categories'] as Map<String, dynamic>?;

            return FoodItem(
              id: item['id'] as String,
              merchantId: item['merchant_id'] as String? ?? '',
              title: item['name'] as String,
              store: merchant?['shop_name'] as String? ?? 'Merchant',
              merchantLogoUrl: merchant?['shop_logo_url'] as String?,
              imageUrl: item['product_image_url'] as String? ?? (() {
                final images = item['product_images'] as List<dynamic>?;
                if (images == null || images.isEmpty) return null;
                final primary = images.firstWhere((img) => img['is_primary'] == true, orElse: () => images.first);
                return primary['image_url']?.toString();
              })(),
              stockLabel: '${item['stock'] ?? 0} porsi',
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
                  'Lainnya',
            );
          }).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal memuat produk';
          _isLoading = false;
          _products = [];
        });
      }
    }
  }

  @override
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
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
                  const SizedBox(height: 18),
                  _BannerCarousel(
                    currentIndex: _currentBannerIndex,
                    onPageChanged: (index) =>
                        setState(() => _currentBannerIndex = index),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Kategori',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
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
                            _loadProducts();
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Produk Tersedia',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  if (_isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (_errorMessage != null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(_errorMessage!),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadProducts,
                              child: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (_products.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Tidak ada produk tersedia',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: constraints.maxWidth < 600 ? 2 : 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        mainAxisExtent: 340,
                      ),
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final food = _products[index];
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

class _BannerCarousel extends StatelessWidget {
  const _BannerCarousel({
    required this.currentIndex,
    required this.onPageChanged,
  });
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  @override
  Widget build(BuildContext context) {
    final banners = [
      {
        'title': 'Selamatkan Makanan Hari Ini!',
        'color': const Color(0xFFE8F5E9),
      },
      {'title': 'Diskon hingga 70%', 'color': const Color(0xFFFFF3E0)},
      {'title': 'Promo Spesial Blind Bag', 'color': const Color(0xFFE3F2FD)},
    ];

    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PageView.builder(
            itemCount: banners.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              final banner = banners[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: banner['color'] as Color,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      banner['title'] as String,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Nikmati produk segar dengan harga hemat.',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: currentIndex == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: currentIndex == index
                    ? AppColors.primary
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}



