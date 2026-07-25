import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/produk_controller.dart';
import 'product_filter.dart';
import 'product_form_page.dart';
import 'product_pagination.dart';
import 'product_search.dart';
import 'product_table.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MerchantProdukController>(
      builder: (context, controller, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Produk', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                    SizedBox(height: 6),
                    Text('Kelola semua produk makanan dan minuman di toko Anda.', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => showProductFormPage(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Tambah Produk'),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F6B43), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(child: ProductSearch(initialValue: controller.searchQuery, onChanged: controller.setSearchQuery)),
                const SizedBox(width: 12),
                ProductFilter(label: 'Semua Kategori', value: controller.selectedKategori, items: controller.kategoriOptions, onChanged: controller.setKategori),
                const SizedBox(width: 12),
                ProductFilter(label: 'Urutkan', value: controller.selectedSort, items: const ['Terbaru', 'Nama A-Z', 'Harga Tertinggi', 'Harga Terendah'], onChanged: controller.setSort),
              ],
            ),
            const SizedBox(height: 18),
            Expanded(child: ProductTable(products: controller.visibleData)),
            const SizedBox(height: 18),
            ProductPagination(currentPage: controller.currentPage, totalPages: controller.totalPages, totalItems: controller.totalData, onPageChanged: controller.goToPage),
          ],
        );
      },
    );
  }
}
