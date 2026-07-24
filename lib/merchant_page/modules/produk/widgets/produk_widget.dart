import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/produk_controller.dart';

class ProdukWidget extends StatelessWidget {
  final dynamic data;

  const ProdukWidget({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<MerchantProdukController>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), spreadRadius: 2, blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFF0F6B43).withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.inventory_2_outlined, color: Color(0xFF0F6B43), size: 24),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Produk', style: TextStyle(fontFamily: 'Quicksand', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                    SizedBox(height: 4),
                    Text('Kelola modul produk Anda di sini', style: TextStyle(fontFamily: 'Quicksand', fontSize: 12, color: Color(0xFF64748B))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: Color(0xFFE2E8F0)),
          const SizedBox(height: 16),
          Text(data?.description ?? 'Memuat informasi...', style: const TextStyle(fontFamily: 'Quicksand', fontSize: 15, color: Color(0xFF334155), height: 1.5)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: controller.showProductList,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Tambah Data Produk', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F6B43), foregroundColor: Colors.white, elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          ),
        ],
      ),
    );
  }
}
