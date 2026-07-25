import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';
import '../../../providers/product_provider.dart';
import '../models/product_approval_models.dart';
import '../widgets/product_approval_widgets.dart';
import '../widgets/product_notification_widgets.dart';

class ProductApprovalPage extends StatefulWidget {
  const ProductApprovalPage({super.key});

  @override
  State<ProductApprovalPage> createState() => _ProductApprovalPageState();
}

class _ProductApprovalPageState extends State<ProductApprovalPage>
    with TickerProviderStateMixin {
  late final AnimationController chartController;
  final List<ProductNotification> _notifications = [];

  @override
  void initState() {
    super.initState();
    chartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MenuProvider>().setRoute(AppRoutes.productApproval);
    });
  }

  @override
  void dispose() {
    chartController.dispose();
    super.dispose();
  }

  void _pushNotification(ProductNotification notification) {
    setState(() {
      _notifications.insert(0, notification);
    });
  }

  List<ProductApprovalMetric> _buildMetrics(ProductProvider productProvider) {
    return [
      ProductApprovalMetric(
        title: 'Menunggu',
        value: '${productProvider.pendingProducts}',
        delta: '+${productProvider.pendingProducts} pending',
        icon: 'hourglass_empty',
        color: 0xFFF59E0B,
      ),
      ProductApprovalMetric(
        title: 'Approved',
        value: '${productProvider.approvedProducts}',
        delta: '${productProvider.activeProducts} aktif',
        icon: 'check_circle',
        color: 0xFF16A34A,
      ),
      ProductApprovalMetric(
        title: 'Rejected',
        value: '${productProvider.rejectedProducts}',
        delta: 'Perlu revisi',
        icon: 'cancel',
        color: 0xFFEF4444,
      ),
      ProductApprovalMetric(
        title: 'Total Produk',
        value: '${productProvider.totalProducts}',
        delta: 'Semua data tersimpan',
        icon: 'inventory_2',
        color: 0xFF0F766E,
      ),
    ];
  }

  void _clearNotifications() {
    setState(() {
      _notifications.clear();
    });
  }

  void _openDetail(ProductApprovalItem product) {
    showDialog<void>(
      context: context,
      builder: (_) => ProductDetailDialog(product: product),
    );
  }

  void _approveProduct(ProductApprovalItem product) {
    context.read<ProductProvider>().approveProduct(product.id);
    _pushNotification(
      ProductNotification(
        title: 'Produk berhasil di-approve!',
        subtitle: ' telah disetujui.',
        time: 'Baru saja',
        color: 0xFF16A34A,
        icon: 'check',
      ),
    );
  }

  void _rejectProduct(ProductApprovalItem product) {
    context.read<ProductProvider>().rejectProduct(product.id, 'Ditolak admin');
    _pushNotification(
      ProductNotification(
        title: 'Produk ditolak!',
        subtitle: ' ditolak.',
        time: 'Baru saja',
        color: 0xFFEF4444,
        icon: 'cancel',
      ),
    );
  }

  void _inactiveProduct(ProductApprovalItem product) {
    _pushNotification(
      ProductNotification(
        title: 'Produk dinonaktifkan!',
        subtitle: ' statusnya kini inactive.',
        time: 'Baru saja',
        color: 0xFFF59E0B,
        icon: 'warning',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuProvider>(
      builder: (context, menuProvider, _) {
        final productProvider = context.watch<ProductProvider>();
        final metrics = _buildMetrics(productProvider);
        final pendingProducts = productProvider.products
            .where((p) => p['approval_status'] == 'pending')
            .map(
              (p) => ProductApprovalItem(
                id: p['id']?.toString() ?? '',
                name: p['name']?.toString() ?? '',
                productId: p['product_code']?.toString() ?? '',
                merchant: p['merchant_id']?.toString() ?? 'Toko',
                category: p['category_id']?.toString() ?? '',
                price: p['price']?.toString() ?? '0',
                stock: p['stock'] as int? ?? 0,
                submittedAt: p['created_at']?.toString() ?? '',
                status: p['approval_status']?.toString() ?? '',
                imageUrl: p['image_url']?.toString() ?? '',
                description: p['description']?.toString() ?? '',
              ),
            )
            .toList();
        return LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth = constraints.maxWidth;
            final padding = contentWidth < 900
                ? const EdgeInsets.fromLTRB(16, 16, 16, 18)
                : const EdgeInsets.fromLTRB(24, 18, 24, 20);
            return SingleChildScrollView(
              padding: padding,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1680),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeaderBar(),
                      const SizedBox(height: 14),
                      ProductSectionCard(
                        child: ProductMetricGrid(
                          metrics: metrics,
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Tabel Daftar Produk - full width
                      Container(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Daftar Produk Menunggu Persetujuan',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                SizedBox(
                                  width: 280,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Cari produk...',
                                      hintStyle: const TextStyle(fontSize: 13),
                                      prefixIcon: const Icon(
                                        Icons.search_rounded,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ProductApprovalTable(
                              items: pendingProducts,
                              onView: _openDetail,
                              onApprove: _approveProduct,
                              onReject: _rejectProduct,
                              onInactive: _inactiveProduct,
                              onPublish: (product) async {
                                final ok = await context
                                    .read<ProductProvider>()
                                    .publishProduct(product.id);
                                if (ok) {
                                  _pushNotification(
                                    ProductNotification(
                                      title: 'Produk tampil ke customer!',
                                      subtitle:
                                          ' sudah muncul di customer_page.',
                                      time: 'Baru saja',
                                      color: 0xFF0F8D55,
                                      icon: 'check',
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Grafik Donut - full width melebar
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
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
                        child: ProductApprovalChartCard(
                          progress: chartController.value,
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Top Merchant section removed
                      if (_notifications.isNotEmpty)
                        ProductNotificationTray(
                          items: _notifications,
                          onClearAll: _clearNotifications,
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _HeaderBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Approval',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        SizedBox(height: 3),
        Text(
          'Kelola dan tinjau produk yang diajukan oleh merchant sebelum ditampilkan ke customer.',
          style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }
}
