import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../providers/merchant_nav_provider.dart';
import '../../../providers/merchant_workspace_provider.dart';
import '../../notifikasi/controllers/notifikasi_controller.dart';
import '../../produk/controllers/produk_controller.dart';
import '../../produk/models/produk_model.dart';
import '../../produk/moduler/product_form_page.dart';
import '../../produk/moduler/product_view_dialog.dart';

class TokoSayaView extends StatefulWidget {
  const TokoSayaView({super.key});

  @override
  State<TokoSayaView> createState() => _TokoSayaViewState();
}

class _TokoSayaViewState extends State<TokoSayaView> {
  RealtimeChannel? _productsChannel;
  RealtimeChannel? _commissionsChannel;
  String? _boundMerchantId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bindRealtime();
  }

  void _bindRealtime() {
    final workspace = context.read<MerchantWorkspaceProvider>();
    final merchantId = workspace.storeId;
    if (merchantId.isEmpty || _boundMerchantId == merchantId) return;

    _productsChannel?.unsubscribe();
    _commissionsChannel?.unsubscribe();
    _boundMerchantId = merchantId;

    final client = Supabase.instance.client;
    _productsChannel = client
        .channel('merchant-products-$merchantId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'products',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'merchant_id',
            value: merchantId,
          ),
          callback: (_) {
            if (mounted) context.read<MerchantProdukController>().loadData();
          },
        )
        .subscribe();

    _commissionsChannel = client
        .channel('merchant-commissions-$merchantId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'product_commissions',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'merchant_id',
            value: merchantId,
          ),
          callback: (_) {
            if (mounted) context.read<MerchantProdukController>().loadData();
          },
        )
        .subscribe();
  }

  @override
  void dispose() {
    _productsChannel?.unsubscribe();
    _commissionsChannel?.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workspace = context.watch<MerchantWorkspaceProvider>();
    final navProvider = context.watch<MerchantNavProvider>();
    final sidebarOpen = navProvider.isSidebarOpen;

    return Consumer<MerchantProdukController>(
      builder: (context, productController, _) {
        final products = productController.visibleData;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StoreHeader(workspace: workspace),
              const SizedBox(height: 16),
              _StoreBanner(workspace: workspace),
              const SizedBox(height: 16),
              if (products.isEmpty)
                _EmptyStoreState(sidebarOpen: sidebarOpen)
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: sidebarOpen ? 3 : 4,
                    childAspectRatio: sidebarOpen ? 0.52 : 0.55,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _ProductCard(
                      merchantName: workspace.storeName,
                      product: product,
                      onEdit: () => showProductFormPage(context, product: product),
                      onDisable: () {
                        final notifController = context.read<MerchantNotifikasiController>();
                        final newStatus = !product.status;
                        productController.toggleStatus(product.id);
                        notifController.addNotification(
                          title: newStatus ? 'Produk Diaktifkan' : 'Produk Dinonaktifkan',
                          description: 'Status produk "${product.nama}" diubah menjadi ${newStatus ? 'aktif' : 'nonaktif'}.',
                          iconKey: newStatus ? 'check' : 'close',
                        );
                      },
                      onDelete: () {
                        context.read<MerchantNotifikasiController>().addNotification(
                          title: 'Produk Dihapus',
                          description: 'Produk "${product.nama}" telah dihapus dari toko.',
                          iconKey: 'close',
                        );
                        productController.deleteProduct(product.id);
                      },
                      onSubmit: () async {
                        final notifController = context.read<MerchantNotifikasiController>();
                        final ok = await productController.submitForApproval(product.id);
                        if (!ok) return;
                        notifController.addNotification(
                          title: 'Produk Diajukan ke Admin',
                          description: 'Produk "${product.nama}" dikirim ke review admin.',
                          iconKey: 'campaign',
                        );
                        if (context.mounted) {
                          showProductViewDialog(context, productController.getProductById(product.id) ?? product);
                        }
                      },
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _StoreHeader extends StatelessWidget {
  final MerchantWorkspaceProvider workspace;
  const _StoreHeader({required this.workspace});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 56,
            backgroundColor: const Color(0xFFE2E8F0),
            backgroundImage: workspace.profileImageBytes == null ? null : MemoryImage(workspace.profileImageBytes!),
            child: workspace.profileImageBytes == null ? const Icon(Icons.storefront_outlined, size: 38, color: Color(0xFF94A3B8)) : null,
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(workspace.storeName, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                const SizedBox(height: 6),
                Text('ID Toko: ${workspace.storeId}', style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('Email: ${workspace.email}', style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                const SizedBox(height: 10),
                Text(workspace.description, style: const TextStyle(fontSize: 13, color: Color(0xFF334155), height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreBanner extends StatelessWidget {
  final MerchantWorkspaceProvider workspace;
  const _StoreBanner({required this.workspace});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: workspace.bannerImageBytes == null
            ? Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF0F6B43), Color(0xFF34A853)]),
                ),
                child: const Center(
                  child: Text('Banner Toko', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                ),
              )
            : Image.memory(workspace.bannerImageBytes!, fit: BoxFit.cover),
      ),
    );
  }
}

class _EmptyStoreState extends StatelessWidget {
  final bool sidebarOpen;
  const _EmptyStoreState({required this.sidebarOpen});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sidebarOpen ? 3 : 4,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: sidebarOpen ? 3 : 4,
        childAspectRatio: sidebarOpen ? 0.52 : 0.55,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Belum ada produk\nSilakan tambah produk baru',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String merchantName;
  final ProdukModel product;
  final VoidCallback onEdit;
  final VoidCallback onDisable;
  final VoidCallback onDelete;
  final VoidCallback onSubmit;

  const _ProductCard({required this.merchantName, required this.product, required this.onEdit, required this.onDisable, required this.onDelete, required this.onSubmit});

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFF1F5F9),
      child: const Center(
        child: Icon(Icons.fastfood, size: 48, color: Color(0xFF94A3B8)),
      ),
    );
  }

  ButtonStyle _getButtonStyle(Color baseColor) {
    return ButtonStyle(
      minimumSize: WidgetStateProperty.all(const Size.fromHeight(34)),
      padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 8)),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      visualDensity: VisualDensity.standard,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) => states.contains(WidgetState.hovered) ? baseColor : Colors.white),
      foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) => states.contains(WidgetState.hovered) ? Colors.white : baseColor),
      side: WidgetStateProperty.all(BorderSide(color: baseColor, width: 1.2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: product.gambarBytes != null
                  ? Image.memory(product.gambarBytes!, cacheWidth: 512, cacheHeight: 512, fit: BoxFit.cover)
                  : (product.gambar != null && product.gambar!.isNotEmpty)
                      ? Image.network(product.gambar!, cacheWidth: 512, cacheHeight: 512, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => _buildPlaceholder())
                      : _buildPlaceholder(),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.nama, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Text(merchantName, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(product.id, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(product.kategori, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const Spacer(),
                  Text('Rp ${product.harga.toStringAsFixed(0)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F6B43)), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: OutlinedButton(onPressed: onEdit, style: _getButtonStyle(const Color(0xFF0F6B43)), child: const Text('Edit', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)))),
                      const SizedBox(width: 6),
                      Expanded(child: OutlinedButton(onPressed: onDisable, style: _getButtonStyle(product.status ? const Color(0xFFD97706) : const Color(0xFF2563EB)), child: Text(product.status ? 'Nonaktif' : 'Aktif', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(child: OutlinedButton(onPressed: onDelete, style: _getButtonStyle(const Color(0xFFDC2626)), child: const Text('Hapus', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)))),
                      const SizedBox(width: 6),
                      Expanded(child: OutlinedButton(onPressed: onSubmit, style: _getButtonStyle(const Color(0xFF4F46E5)), child: const Text('Ajukan', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
