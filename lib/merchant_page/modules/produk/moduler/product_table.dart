import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../notifikasi/controllers/notifikasi_controller.dart';
import '../controllers/produk_controller.dart';
import '../models/produk_model.dart';
import 'product_action.dart';
import '../../../providers/merchant_nav_provider.dart';

class ProductTable extends StatelessWidget {
  final List<ProdukModel> products;

  const ProductTable({super.key, required this.products});

  String _formatCurrency(double value) {
    final raw = value.toStringAsFixed(0);
    final buffer = StringBuffer();
    for (int index = 0; index < raw.length; index++) {
      final reverseIndex = raw.length - index;
      buffer.write(raw[index]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write('.');
      }
    }
    return 'Rp $buffer';
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<MerchantProdukController>();
    final notifController = context.read<MerchantNotifikasiController>();
    final navProvider = context.watch<MerchantNavProvider>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final hasSidebar = isDesktop && navProvider.isSidebarOpen;

    if (products.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inventory_2_outlined, size: 64, color: Color(0xFFCBD5E1)),
              SizedBox(height: 16),
              Text('Tabel masih kosong', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
              SizedBox(height: 8),
              Text('Belum ada produk yang ditambahkan', style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Jika ada sidebar, gunakan horizontal scroll
            // Jika tidak ada sidebar, tabel melebar penuh
            return SingleChildScrollView(
              scrollDirection: hasSidebar ? Axis.horizontal : Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: hasSidebar ? Axis.vertical : Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: hasSidebar ? 1400 : constraints.maxWidth,
                  ),
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                    columnSpacing: 20,
                    horizontalMargin: 24,
                    dataRowMinHeight: 72,
                    dataRowMaxHeight: 72,
                    columns: const [
                      DataColumn(label: Text('Produk', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold, fontSize: 13))),
                      DataColumn(label: Text('ID Produk', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold, fontSize: 13))),
                      DataColumn(label: Text('Kategori', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold, fontSize: 13))),
                      DataColumn(label: Text('Harga Asli', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold, fontSize: 13))),
                      DataColumn(label: Text('Harga Diskon', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold, fontSize: 13))),
                      DataColumn(label: Text('Diskon', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold, fontSize: 13))),
                      DataColumn(label: Text('Stok', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold, fontSize: 13))),
                      DataColumn(label: Text('Satuan', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold, fontSize: 13))),
                      DataColumn(label: Text('Terjual', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold, fontSize: 13))),
                      DataColumn(label: Text('Deskripsi', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold, fontSize: 13))),
                      DataColumn(label: Text('Status', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold, fontSize: 13))),
                      DataColumn(label: Text('Aksi', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold, fontSize: 13))),
                    ],
                    rows: products.map((product) {
                      final hasBytes = product.gambarBytes != null;
                      final hasImage = product.gambar != null && product.gambar!.isNotEmpty;
                      final hargaAsli = product.hargaAsli ?? product.harga;
                      final hargaDiskon = product.hargaDiskon ?? product.harga;
                      final diskonPersen = hargaAsli > 0 && hargaDiskon < hargaAsli
                          ? ((hargaAsli - hargaDiskon) / hargaAsli * 100).toStringAsFixed(0)
                          : '0';

                      return DataRow(
                        cells: [
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: hasBytes
                                      ? Image.memory(product.gambarBytes!, fit: BoxFit.cover)
                                      : hasImage
                                          ? (product.gambar!.startsWith('data:image/')
                                              ? Image.memory(
                                                  base64Decode(product.gambar!.split(',').last),
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  product.gambar!,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) =>
                                                      const Icon(Icons.fastfood, color: Color(0xFF64748B), size: 24),
                                                ))
                                          : const Icon(Icons.fastfood, color: Color(0xFF64748B), size: 24),
                                ),
                                const SizedBox(width: 12),
                                SizedBox(
                                  width: 140,
                                  child: Text(
                                    product.nama,
                                    style: const TextStyle(
                                      fontFamily: 'Quicksand',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 180,
                              child: Text(
                                product.id,
                                style: const TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 11,
                                  color: Color(0xFF64748B),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              product.kategori,
                              style: const TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 13,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              _formatCurrency(hargaAsli),
                              style: const TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 12,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              _formatCurrency(hargaDiskon),
                              style: const TextStyle(
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: diskonPersen != '0' ? const Color(0xFFFEF3C7) : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                diskonPersen != '0' ? '$diskonPersen%' : '-',
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: diskonPersen != '0' ? const Color(0xFF92400E) : const Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: product.stok > 10 
                                    ? const Color(0xFFD1FAE5)
                                    : product.stok > 0 
                                        ? const Color(0xFFFEF3C7)
                                        : const Color(0xFFFEE2E2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${product.stok}',
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: product.stok > 10
                                      ? const Color(0xFF065F46)
                                      : product.stok > 0
                                          ? const Color(0xFF92400E)
                                          : const Color(0xFF991B1B),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              product.satuan ?? 'Porsi',
                              style: const TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 13,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              '${product.terjual}',
                              style: const TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 13,
                              ),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 180,
                              child: Text(
                                product.deskripsi ?? '-',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            GestureDetector(
                              onTap: () {
                                final before = product.status;
                                controller.toggleStatus(product.id);
                                notifController.addNotification(
                                  title: before ? 'Produk Dinonaktifkan' : 'Produk Diaktifkan',
                                  description: 'Produk ${product.nama} sudah ${before ? 'dinonaktifkan' : 'diaktifkan'}.',
                                  iconKey: before ? 'close' : 'check',
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: product.status ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  product.status ? 'Aktif' : 'Nonaktif',
                                  style: TextStyle(
                                    fontFamily: 'Quicksand',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: product.status ? const Color(0xFF065F46) : const Color(0xFF991B1B),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          DataCell(ProductAction(productId: product.id, productName: product.nama)),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
