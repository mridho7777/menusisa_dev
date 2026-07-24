import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/produk_model.dart';

Future<void> showProductViewDialog(BuildContext context, ProdukModel product) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      backgroundColor: Colors.transparent,
      child: ProductViewPage(product: product),
    ),
  );
}

class ProductViewPage extends StatelessWidget {
  final ProdukModel product;

  const ProductViewPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 920),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Detail Produk', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                  InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.close, color: Color(0xFF64748B))),
                ],
              ),
              const SizedBox(height: 20),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Foto Produk', style: TextStyle(fontSize: 12, color: Color(0xFF475569), fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
                                ),
                                child: product.gambar != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: product.gambarBytes != null
                                            ? Image.memory(product.gambarBytes!, fit: BoxFit.cover)
                                            : (product.gambar != null && product.gambar!.startsWith('assets/')
                                                ? Image.asset(product.gambar!, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 48, color: Color(0xFFCBD5E1)))
                                                : Image.network(product.gambar ?? '', fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 48, color: Color(0xFFCBD5E1)))),
                                      )
                                    : const Center(child: Icon(Icons.image, size: 48, color: Color(0xFFCBD5E1))),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 660,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: _infoField('Nama Produk', product.nama)),
                                    const SizedBox(width: 16),
                                    Expanded(child: _infoField('Kategori', product.kategori)),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                _infoField('Deskripsi', product.deskripsi ?? '-'),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(child: _infoField('Harga Asli', 'Rp ${product.hargaAsli?.toStringAsFixed(0) ?? '-'}')),
                                    const SizedBox(width: 16),
                                    Expanded(child: _infoField('Harga Diskon', 'Rp ${product.hargaDiskon?.toStringAsFixed(0) ?? product.harga.toStringAsFixed(0)}')),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(child: _infoField('Stok', '${product.stok}')),
                                    const SizedBox(width: 16),
                                    Expanded(child: _infoField('Satuan', product.satuan ?? 'Porsi')),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(child: _infoField('Terjual', '${product.terjual}')),
                                    const SizedBox(width: 16),
                                    Expanded(child: _infoField('Status', product.status ? 'Aktif' : 'Tidak Aktif')),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F6B43), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          child: const Text('Tutup', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF475569), fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Text(value, style: const TextStyle(fontSize: 14, color: Color(0xFF334155))),
        ),
      ],
    );
  }
}

