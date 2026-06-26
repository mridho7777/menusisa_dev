import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';
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
                          metrics: productApprovalMetrics,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: const Color(0xFFE5E7EB),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          SizedBox(
                                            width: 200,
                                            child: TextField(
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Cari produk, merchant...',
                                                prefixIcon: const Icon(
                                                  Icons.search_rounded,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                isDense: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      ProductApprovalTable(
                                        items: productApprovalItems,
                                        onView: _openDetail,
                                        onApprove: _approveProduct,
                                        onReject: _rejectProduct,
                                        onInactive: _inactiveProduct,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                ProductSectionCard(
                                  child: ProductApprovalChartCard(
                                    progress: chartController.value,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                ProductSectionCard(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Top Merchant',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      ProductTopMerchantList(
                                        items: topMerchantProducts,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 14),
                                ProductFilterPanel(onReset: () {}),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
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
    return Row(
      children: [
        const Expanded(
          child: Column(
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
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F8D55),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Export Laporan'),
        ),
      ],
    );
  }
}

