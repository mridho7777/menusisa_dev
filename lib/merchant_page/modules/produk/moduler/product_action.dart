import 'package:menusisa_dev/merchant_page/shared/widgets/merchant_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../notifikasi/controllers/notifikasi_controller.dart';
import '../controllers/produk_controller.dart';
import 'product_form_page.dart';
import 'product_view_dialog.dart';

class ProductAction extends StatelessWidget {
  final String productId;
  final String productName;

  const ProductAction({super.key, required this.productId, required this.productName});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<MerchantProdukController>();
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Color(0xFF64748B), size: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onSelected: (value) {
        if (value == 'view') {
          final product = controller.getProductById(productId);
          if (product != null) {
            showProductViewDialog(context, product);
          }
        } else if (value == 'edit') {
          final product = controller.getProductById(productId);
          if (product != null) {
            showProductFormPage(context, product: product);
          }
        } else if (value == 'delete') {
          _showDeleteDialog(context, controller);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'view', child: Row(children: [Icon(Icons.visibility_outlined, size: 18, color: Color(0xFF64748B)), SizedBox(width: 12), Text('Lihat')])),
        const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_outlined, size: 18, color: Color(0xFF64748B)), SizedBox(width: 12), Text('Edit')])),
        const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_outline, size: 18, color: Color(0xFFDC2626)), SizedBox(width: 12), Text('Hapus', style: TextStyle(color: Color(0xFFDC2626)))])),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, MerchantProdukController controller) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Produk', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text('Apakah Anda yakin ingin menghapus "$productName"?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () {
                controller.deleteProduct(productId);
                context.read<MerchantNotifikasiController>().addNotification(
                  title: 'Produk Dihapus',
                  description: 'Produk "$productName" (ID: $productId) telah dihapus dari toko.',
                  iconKey: 'close',
                );
                Navigator.pop(dialogContext);
                MerchantToast.show(context, 'Produk berhasil dihapus', type: ToastType.success);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626)),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}

