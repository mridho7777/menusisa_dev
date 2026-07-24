import 'package:flutter/material.dart';

import '../controllers/pelanggan_controller.dart';
import '../moduler/customer_pagination.dart';
import '../moduler/customer_search_bar.dart';
import '../moduler/customer_table.dart';
import '../models/pelanggan_model.dart';

class PelangganWidget extends StatelessWidget {
  final PelangganModel? data;
  final MerchantPelangganController controller;

  const PelangganWidget({super.key, required this.controller, this.data});

  @override
  Widget build(BuildContext context) {
    if (!controller.showCustomerList) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F6B43).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.people_outline, color: Color(0xFF0F6B43), size: 24),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halaman Pelanggan',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Kelola modul pelanggan Anda di sini',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(color: Color(0xFFE2E8F0)),
            const SizedBox(height: 16),
            Text(
              data?.description ?? 'Daftar riwayat dan informasi pelanggan setia toko Anda.',
              style: const TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 15,
                color: Color(0xFF334155),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: controller.openCustomerList,
              icon: const Icon(Icons.add, size: 18),
              label: const Text(
                'Tambah Data Pelanggan',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F6B43),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final customers = controller.paginatedData;
    final startItem = controller.totalItems == 0 ? 0 : ((controller.currentPage - 1) * controller.rowsPerPage) + 1;
    final endItem = controller.totalItems == 0 ? 0 : ((controller.currentPage - 1) * controller.rowsPerPage + customers.length);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pelanggan',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              TextButton.icon(
                onPressed: controller.backToOverview,
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('Kembali'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CustomerSearchBar(
                controller: controller.searchController,
                onChanged: controller.updateSearch,
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomerTable(customers: customers, controller: controller),
          const SizedBox(height: 16),
          CustomerPagination(
            currentPage: controller.currentPage,
            totalPages: controller.totalPages,
            totalItems: controller.totalItems,
            startItem: startItem,
            endItem: endItem,
            onPrevious: controller.previousPage,
            onNext: controller.nextPage,
          ),
        ],
      ),
    );
  }
}
