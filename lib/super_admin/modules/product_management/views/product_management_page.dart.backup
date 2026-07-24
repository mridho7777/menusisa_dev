import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';
import '../models/product_management_models.dart';
import '../widgets/product_dialogs_widgets.dart';
import '../widgets/product_management_widgets.dart';
import '../widgets/product_metric_grid.dart';

class ProductManagementPage extends StatefulWidget {
  const ProductManagementPage({super.key});

  @override
  State<ProductManagementPage> createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends State<ProductManagementPage>
    with TickerProviderStateMixin {
  late final AnimationController chartController;
  String _chartFilter = '30 Hari Terakhir';
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
      context.read<MenuProvider>().setRoute(AppRoutes.productManagement);
    });
  }

  @override
  void dispose() {
    chartController.dispose();
    super.dispose();
  }

  void _notify(ProductNotification notification) {
    setState(() {
      _notifications.insert(0, notification);
    });
  }

  void _clearNotifications() {
    setState(() {
      _notifications.clear();
    });
  }

  void _viewProduct(ProductItem product) {
    showDialog<void>(
      context: context,
      builder: (_) => ProductDetailDialog(product: product),
    );
  }

  void _editProduct(ProductItem product) {
    showDialog<void>(
      context: context,
      builder: (_) => ProductEditDialog(product: product),
    ).then((_) {
      _notify(
        ProductNotification(
          title: 'Produk berhasil diupdate!',
          subtitle: ' telah disimpan.',
          time: 'Baru saja',
          color: 0xFF16A34A,
          icon: 'check',
        ),
      );
    });
  }

  void _toggleProduct(ProductItem product) {
    final isActive = product.status == 'Aktif';
    showDialog<void>(
      context: context,
      builder: (_) => ProductConfirmDialog(
        title: isActive ? 'Nonaktifkan Produk' : 'Aktifkan Produk',
        message: isActive
            ? 'Anda yakin ingin menonaktifkan produk ini?'
            : 'Anda yakin ingin mengaktifkan produk ini?',
        primaryLabel: isActive ? 'Nonaktifkan' : 'Aktifkan',
        primaryColor: isActive
            ? const Color(0xFFF59E0B)
            : const Color(0xFF16A34A),
      ),
    ).then((_) {
      _notify(
        ProductNotification(
          title: isActive ? 'Produk dinonaktifkan!' : 'Produk diaktifkan!',
          subtitle: product.name,
          time: 'Baru saja',
          color: isActive ? 0xFFF59E0B : 0xFF16A34A,
          icon: isActive ? 'warning' : 'check',
        ),
      );
    });
  }

  void _deleteProduct(ProductItem product) {
    showDialog<void>(
      context: context,
      builder: (_) => ProductConfirmDialog(
        title: 'Hapus Produk',
        message:
            'Anda yakin ingin menghapus produk ini? Tindakan ini tidak dapat dibatalkan.',
        primaryLabel: 'Hapus',
        primaryColor: const Color(0xFFEF4444),
      ),
    ).then((_) {
      _notify(
        ProductNotification(
          title: 'Produk dihapus!',
          subtitle: product.name,
          time: 'Baru saja',
          color: 0xFFEF4444,
          icon: 'cancel',
        ),
      );
    });
  }

  void _handleActionTap(String action) {
    switch (action) {
      case 'Tambah Produk':
        _notify(
          const ProductNotification(
            title: 'Form tambah produk dibuka!',
            subtitle: 'Silakan isi data produk baru.',
            time: 'Baru saja',
            color: 0xFF16A34A,
            icon: 'check',
          ),
        );
        break;
      case 'Export Data':
        _notify(
          const ProductNotification(
            title: 'Data produk diexport!',
            subtitle: 'File berhasil dibuat.',
            time: 'Baru saja',
            color: 0xFF16A34A,
            icon: 'check',
          ),
        );
        break;
      case 'Import Data':
        _notify(
          const ProductNotification(
            title: 'Import produk dimulai!',
            subtitle: 'File produk sedang diproses.',
            time: 'Baru saja',
            color: 0xFFF59E0B,
            icon: 'warning',
          ),
        );
        break;
      case 'Refresh':
        _notify(
          const ProductNotification(
            title: 'Data diperbarui!',
            subtitle: 'Semua produk telah disinkronkan.',
            time: 'Baru saja',
            color: 0xFF16A34A,
            icon: 'check',
          ),
        );
        break;
      case 'Filter Lanjutan':
        _notify(
          const ProductNotification(
            title: 'Filter lanjutan dibuka!',
            subtitle: 'Silakan pilih filter tambahan.',
            time: 'Baru saja',
            color: 0xFFF59E0B,
            icon: 'info',
          ),
        );
        break;
      case 'Laporan':
        _notify(
          const ProductNotification(
            title: 'Laporan produk siap!',
            subtitle: 'Ringkasan produk telah tersedia.',
            time: 'Baru saja',
            color: 0xFF16A34A,
            icon: 'check',
          ),
        );
        break;
    }
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
                      _HeaderBar(onActionTap: _handleActionTap),
                      const SizedBox(height: 14),
                      ProductSectionCard(
                        child: ProductMetricGrid(metrics: productMetrics),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4,
                            child: ProductSectionCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Daftar Produk',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  ProductTableCard(
                                    items: productItems,
                                    onView: _viewProduct,
                                    onEdit: _editProduct,
                                    onToggle: _toggleProduct,
                                    onDelete: _deleteProduct,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                ProductSectionCard(
                                  child: ProductCombinedChartCard(
                                    progress: chartController.value,
                                    filter: _chartFilter,
                                    sidebarCollapsed:
                                        menuProvider.sidebarCollapsed,
                                    onFilterChanged: (value) {
                                      setState(() {
                                        _chartFilter = value;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 14),
                                ProductSectionCard(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Expanded(
                                            child: Text(
                                              'Stok Produk Rendah',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {},
                                            child: const Text('Lihat Semua'),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      ProductLowStockList(
                                        items: lowStockProducts,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 14),
                                ProductSectionCard(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Aktivitas Terbaru',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Column(
                                        children: productActivities.map((
                                          activity,
                                        ) {
                                          final icon = switch (activity.icon) {
                                            'edit' => Icons.edit_rounded,
                                            'check' =>
                                              Icons.check_circle_rounded,
                                            'add' => Icons.add_circle_rounded,
                                            'inventory' =>
                                              Icons.inventory_2_rounded,
                                            _ => Icons.circle,
                                          };
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                  radius: 12,
                                                  backgroundColor: Color(
                                                    activity.color,
                                                  ).withValues(alpha: 0.14),
                                                  child: Icon(
                                                    icon,
                                                    size: 14,
                                                    color: Color(
                                                      activity.color,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        activity.title,
                                                        style: const TextStyle(
                                                          fontSize: 12.5,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 2),
                                                      Text(
                                                        activity.subtitle,
                                                        style: const TextStyle(
                                                          fontSize: 10.5,
                                                          color: Color(
                                                            0xFF6B7280,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  activity.time,
                                                  style: const TextStyle(
                                                    fontSize: 10.5,
                                                    color: Color(0xFF9CA3AF),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
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
  const _HeaderBar({required this.onActionTap});

  final ValueChanged<String> onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Product Management',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Kelola semua produk pada platform. Aktifkan, nonaktifkan, edit atau hapus produk sesuai kebutuhan.',
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () => onActionTap('Tambah Produk'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F8D55),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Tambah Produk'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => onActionTap('Export Data'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Export Data'),
            ),
          ],
        ),
      ],
    );
  }
}
