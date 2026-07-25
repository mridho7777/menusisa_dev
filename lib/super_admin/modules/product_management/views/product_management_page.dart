import 'package:menusisa_dev/super_admin/shared/widgets/admin_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';
import '../../../providers/product_provider.dart';
import '../../../providers/notifications_provider.dart';
import '../models/product_management_models.dart';
import '../widgets/product_metric_grid.dart';

// TODO: Supabase Integration IDs
// Table: products
// Columns: id (uuid), name (text), merchant_id (uuid), category (text),
//          price (numeric), stock (int), status (text), sold (int),
//          created_at (timestamp), updated_at (timestamp), image_url (text)

class ProductManagementPage extends StatefulWidget {
  const ProductManagementPage({super.key});

  @override
  State<ProductManagementPage> createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends State<ProductManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  String _statusFilter = 'Semua';
  List<ProductItem> _items = List.from(productItems);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MenuProvider>().setRoute(AppRoutes.productManagement);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _addNotification(String title, String message, String type) {
    // TODO: Supabase Integration - Save notification
    context.read<NotificationsProvider>().addNotification({
      'title': title,
      'message': message,
      'type': type,
      'entity_type': 'product',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  List<ProductItem> get _filteredItems {
    final liveItems = context.watch<ProductProvider>().products.map((p) => ProductItem(
      id: p['id']?.toString() ?? '', 
      name: p['name']?.toString() ?? '', 
      merchant: p['merchant_id']?.toString() ?? 'Toko', 
      category: p['category_id']?.toString() ?? '', 
      price: p['price']?.toString() ?? '0', 
      stock: p['stock'] as int? ?? 0, 
      status: _labelStatus(p['approval_status']?.toString(), p['is_active'] as bool? ?? true), 
      sold: p['sold_count'] as int? ?? 0, 
      createdAt: p['created_at']?.toString() ?? '', 
      imageUrl: p['image_url']?.toString() ?? '', 
      description: p['description']?.toString() ?? ''
    )).toList();
    var filtered = List<ProductItem>.from(liveItems);
    
    if (_statusFilter != 'Semua') {
      filtered = filtered.where((item) => _normalizeStatus(item.status) == _normalizeStatus(_statusFilter)).toList();
    }
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered
          .where((item) =>
              item.name.toLowerCase().contains(query) ||
              item.merchant.toLowerCase().contains(query) ||
              item.category.toLowerCase().contains(query))
          .toList();
    }
    return filtered;
  }

  Future<void> _updateStatus(ProductItem item, String newStatus) async {
    final normalized = _normalizeStatus(newStatus);
    if (normalized == 'approved') {
      await context.read<ProductProvider>().approveProduct(item.id);
    } else if (normalized == 'active') {
      await context.read<ProductProvider>().updateProduct(item.id, {'is_active': true, 'approval_status': 'approved'});
    } else if (normalized == 'inactive') {
      await context.read<ProductProvider>().updateProduct(item.id, {'is_active': false, 'approval_status': 'approved'});
    } else if (normalized == 'pending') {
      await context.read<ProductProvider>().updateProduct(item.id, {'approval_status': 'pending'});
    } else {
      await context.read<ProductProvider>().updateProduct(item.id, {'approval_status': normalized});
    }
    setState(() {
      final index = _items.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _items[index] = ProductItem(
          id: item.id,
          name: item.name,
          merchant: item.merchant,
          category: item.category,
          price: item.price,
          stock: item.stock,
          status: newStatus,
          sold: item.sold,
          createdAt: item.createdAt,
          imageUrl: item.imageUrl,
          description: item.description,
        );
      }
    });

    // TODO: Supabase - Update products table
    if (!mounted) return;
    final message = 'Produk ${item.name} statusnya diubah menjadi $newStatus';
    _addNotification('Update Status Produk', message, 'product_status');
    AdminToast.show(context, 'Tindakan berhasil', type: AdminToastType.success);
  }

  Future<void> _publishToCustomer(ProductItem item) async {
    final ok = await context.read<ProductProvider>().publishProduct(item.id);
    if (!mounted) return;
    if (ok) {
      _addNotification('Produk Ditampilkan ke Customer', 'Produk ${item.name} sekarang tampil di customer_page.', 'product_publish');
      AdminToast.show(context, 'Tindakan berhasil', type: AdminToastType.success);
    }
  }

  void _deleteProduct(ProductItem item) {
    context.read<ProductProvider>().deleteProduct(item.id);
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Produk'),
        content: Text('Hapus produk ${item.name}? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _items.removeWhere((i) => i.id == item.id);
              });
              _addNotification('Produk Dihapus', 'Produk ${item.name} telah dihapus', 'product_delete');
              AdminToast.show(context, 'Produk ${item.name} berhasil dihapus');
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sidebarCollapsed = context.watch<MenuProvider>().sidebarCollapsed;
    final filtered = _filteredItems;

    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = const EdgeInsets.fromLTRB(24, 18, 24, 20);

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

                  // Metric grid dengan data 0
                  _SectionCard(
                    child: ProductMetricGrid(metrics: _zeroProductMetrics),
                  ),
                  const SizedBox(height: 14),

                  // Tabel Daftar Produk
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Daftar Produk',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            SizedBox(
                              width: 260,
                              child: TextField(
                                controller: _searchController,
                                onChanged: (_) => setState(() {}),
                                decoration: InputDecoration(
                                  hintText: 'Cari produk...',
                                  hintStyle: const TextStyle(fontSize: 13),
                                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            _FilterButton(
                              currentFilter: _statusFilter,
                              onFilterChanged: (v) => setState(() => _statusFilter = v),
                              options: const ['Semua', 'Aktif', 'Nonaktif', 'Pending', 'Habis'],
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _ProductDataTable(
                          items: filtered,
                          onStatusChanged: _updateStatus,
                          onDelete: _deleteProduct,
                          onPublish: _publishToCustomer,
                          sidebarCollapsed: sidebarCollapsed,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


String _normalizeStatus(String value) {
  final lower = value.trim().toLowerCase();
  return switch (lower) {
    'aktif' => 'active',
    'nonaktif' => 'inactive',
    'pending' => 'pending',
    'approved' => 'approved',
    'rejected' => 'rejected',
    _ => lower,
  };
}

String _labelStatus(String? value, bool isActive) {
  final normalized = _normalizeStatus(value ?? 'pending');
  if (!isActive) return 'Nonaktif';
  return switch (normalized) {
    'pending' => 'Pending',
    'approved' => 'Approved',
    'rejected' => 'Rejected',
    _ => value ?? 'Pending',
  };
}

class _HeaderBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
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
                'Kelola seluruh produk yang tersedia di platform. Monitor stok, status, dan performa produk.',
                style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: child,
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.currentFilter,
    required this.onFilterChanged,
    required this.options,
  });

  final String currentFilter;
  final ValueChanged<String> onFilterChanged;
  final List<String> options;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.filter_list_rounded, size: 18),
            const SizedBox(width: 8),
            Text(
              currentFilter,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      onSelected: onFilterChanged,
      itemBuilder: (context) =>
          options.map((opt) => PopupMenuItem(value: opt, child: Text(opt))).toList(),
    );
  }
}

class _ProductDataTable extends StatelessWidget {
  const _ProductDataTable({
    required this.items,
    required this.onStatusChanged,
    required this.onDelete,
    required this.onPublish,
    this.sidebarCollapsed = true,
  });

  final List<ProductItem> items;
  final Function(ProductItem, String) onStatusChanged;
  final Function(ProductItem) onDelete;
  final Function(ProductItem) onPublish;
  final bool sidebarCollapsed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Menampilkan 1 - ${items.length} dari ${items.length} data',
              style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
            headingTextStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF374151),
            ),
            dataTextStyle: const TextStyle(
              fontSize: 13,
              color: Color(0xFF111827),
            ),
            columnSpacing: 24,
            horizontalMargin: 16,
            dataRowMinHeight: 56,
            dataRowMaxHeight: 56,
            columns: const [
              DataColumn(label: Text('No.')),
              DataColumn(label: Text('Nama Produk')),
              DataColumn(label: Text('Merchant')),
              DataColumn(label: Text('Kategori')),
              DataColumn(label: Text('Harga')),
              DataColumn(label: Text('Stok')),
              DataColumn(label: Text('Terjual')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Tgl. Dibuat')),
              DataColumn(label: Text('Aksi')),
            ],
            rows: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return DataRow(
                cells: [
                  DataCell(Text('${index + 1}')),
                  DataCell(
                    Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  DataCell(Text(item.merchant)),
                  DataCell(Text(item.category)),
                  DataCell(Text(item.price)),
                  DataCell(Text('${item.stock}')),
                  DataCell(
                    Text(
                      '${item.sold}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F8D55),
                      ),
                    ),
                  ),
                  DataCell(_StatusBadge(status: item.status)),
                  DataCell(Text(item.createdAt)),
                  DataCell(
                    _ActionMenu(
                      item: item,
                      onStatusChanged: onStatusChanged,
                      onDelete: onDelete,
                      onPublish: onPublish,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        _PaginationControls(totalItems: items.length),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final config = switch (status) {
      'Aktif' => (color: const Color(0xFF0F8D55), bg: const Color(0xFFD1FAE5)),
      'Nonaktif' => (color: const Color(0xFFEF4444), bg: const Color(0xFFFEE2E2)),
      'Pending' => (color: const Color(0xFFF59E0B), bg: const Color(0xFFFEF3C7)),
      'Habis' => (color: const Color(0xFF7C3AED), bg: const Color(0xFFEDE9FE)),
      _ => (color: const Color(0xFF6B7280), bg: const Color(0xFFF3F4F6)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: config.bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: config.color,
        ),
      ),
    );
  }
}

class _ActionMenu extends StatelessWidget {
  const _ActionMenu({
    required this.item,
    required this.onStatusChanged,
    required this.onDelete,
    required this.onPublish,
  });

  final ProductItem item;
  final Function(ProductItem, String) onStatusChanged;
  final Function(ProductItem) onDelete;
  final Function(ProductItem) onPublish;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_rounded, size: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      offset: const Offset(0, 40),
      onSelected: (action) {
        switch (action) {
          case 'detail':
            showDialog<void>(
              context: context,
              builder: (_) => _ProductDetailDialog(product: item),
            );
            break;
          case 'aktif':
            onStatusChanged(item, 'Aktif');
            break;
          case 'nonaktif':
            onStatusChanged(item, 'Nonaktif');
            break;
          case 'pending':
            onStatusChanged(item, 'Pending');
            break;
          case 'publish':
            onPublish(item);
            break;
          case 'delete':
            onDelete(item);
            break;
        }
      },
      itemBuilder: (context) => [
        _buildMenuItem(Icons.visibility_rounded, 'Detail Produk', 'detail'),
        _buildMenuItem(Icons.check_circle_rounded, 'Set Aktif', 'aktif'),
        _buildMenuItem(Icons.cancel_rounded, 'Set Nonaktif', 'nonaktif'),
        _buildMenuItem(Icons.hourglass_top_rounded, 'Set Pending', 'pending'),
        if (item.status == 'Approved' || item.status == 'approved')
          _buildMenuItem(Icons.rocket_launch_rounded, 'Tampilkan ke Customer', 'publish'),
        const PopupMenuDivider(),
        _buildMenuItem(Icons.delete_rounded, 'Hapus Produk', 'delete', isDestructive: true),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(
    IconData icon,
    String label,
    String value, {
    bool isDestructive = false,
  }) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isDestructive ? const Color(0xFFEF4444) : const Color(0xFF6B7280),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isDestructive ? const Color(0xFFEF4444) : const Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductDetailDialog extends StatelessWidget {
  const _ProductDetailDialog({required this.product});

  final ProductItem product;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Detail Produk',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, size: 20),
                  ),
                ],
              ),
              const Divider(height: 24),
              _DetailRow(label: 'Nama Produk', value: product.name),
              _DetailRow(label: 'Merchant', value: product.merchant),
              _DetailRow(label: 'Kategori', value: product.category),
              _DetailRow(label: 'Harga', value: product.price),
              _DetailRow(label: 'Stok', value: '${product.stock} unit'),
              _DetailRow(label: 'Terjual', value: '${product.sold} unit'),
              _DetailRow(label: 'Status', value: product.status),
              _DetailRow(label: 'Dibuat', value: product.createdAt),
              const SizedBox(height: 8),
              const Text('Deskripsi', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(product.description, style: const TextStyle(fontSize: 12.5, color: Color(0xFF6B7280))),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Tutup'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: const TextStyle(fontSize: 12.5, color: Color(0xFF6B7280))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _PaginationControls extends StatelessWidget {
  const _PaginationControls({required this.totalItems});

  final int totalItems;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text(
              '10 / halaman',
              style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.arrow_drop_down, size: 18),
            ),
          ],
        ),
        Row(
          children: [
            _PageButton(icon: Icons.chevron_left_rounded, onPressed: () {}),
            ...[1, 2, 3].map(
              (page) => _PageButton(label: '$page', isActive: page == 1, onPressed: () {}),
            ),
            _PageButton(icon: Icons.chevron_right_rounded, onPressed: () {}),
          ],
        ),
      ],
    );
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({
    this.label,
    this.icon,
    this.isActive = false,
    required this.onPressed,
  });

  final String? label;
  final IconData? icon;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: isActive ? const Color(0xFF0F8D55) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: isActive ? null : Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: icon != null
                ? Icon(icon, size: 18,
                    color: isActive ? Colors.white : const Color(0xFF6B7280))
                : Text(
                    label!,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.white : const Color(0xFF374151),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// Zero metrics data
const _zeroProductMetrics = [
  ProductMetric(
    title: 'Total Produk',
    value: '0',
    delta: '+0 dari minggu lalu',
    icon: 'inventory',
    color: 0xFF2563EB,
  ),
  ProductMetric(
    title: 'Produk Aktif',
    value: '0',
    delta: '+0 dari minggu lalu',
    icon: 'check',
    color: 0xFF0F8D55,
  ),
  ProductMetric(
    title: 'Produk Nonaktif',
    value: '0',
    delta: '+0 dari minggu lalu',
    icon: 'close',
    color: 0xFFF59E0B,
  ),
  ProductMetric(
    title: 'Stok Rendah',
    value: '0',
    delta: '+0 dari minggu lalu',
    icon: 'low_stock',
    color: 0xFF7C3AED,
  ),
  ProductMetric(
    title: 'Produk Terjual',
    value: '0',
    delta: '+0 dari minggu lalu',
    icon: 'sell',
    color: 0xFFEF4444,
  ),
  ProductMetric(
    title: 'Produk Baru',
    value: '0',
    delta: '+0 minggu ini',
    icon: 'new',
    color: 0xFF14B8A6,
  ),
];






