import 'package:menusisa_dev/merchant_page/shared/widgets/merchant_toast.dart';
import 'package:flutter/material.dart';

import '../controllers/notifikasi_controller.dart';
import '../moduler/notification_list_item.dart';
import '../moduler/notification_pagination.dart';
import '../moduler/notification_search_bar.dart';
import '../models/notifikasi_model.dart';

class NotifikasiWidget extends StatelessWidget {
  final NotifikasiModel? data;
  final MerchantNotifikasiController controller;

  const NotifikasiWidget({super.key, required this.controller, this.data});

  void _showDeleteConfirmation(BuildContext context, NotifikasiModel item) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Hapus Notifikasi', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold)),
        content: Text('Apakah Anda yakin ingin menghapus notifikasi "${item.title}"?', style: const TextStyle(fontFamily: 'Quicksand')),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Batal', style: TextStyle(fontFamily: 'Quicksand', color: Colors.grey))),
          ElevatedButton(
            onPressed: () {
              controller.deleteNotification(item.id);
              Navigator.of(dialogContext).pop();
              MerchantToast.show(context, 'Notifikasi ${item.title} dihapus', type: ToastType.success);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Hapus', style: TextStyle(fontFamily: 'Quicksand')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.showListView) {
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
                  child: const Icon(Icons.notifications_outlined, color: Color(0xFF0F6B43), size: 24),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data?.title ?? 'Notifikasi', style: const TextStyle(fontFamily: 'Quicksand', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                    const SizedBox(height: 4),
                    const Text('Kelola notifikasi toko Anda di sini', style: TextStyle(fontFamily: 'Quicksand', fontSize: 12, color: Color(0xFF64748B))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(color: Color(0xFFE2E8F0)),
            const SizedBox(height: 16),
            Text(data?.description ?? 'Pantau semua notifikasi masuk dari sistem dan aktivitas toko secara real-time.', style: const TextStyle(fontFamily: 'Quicksand', fontSize: 15, color: Color(0xFF334155), height: 1.5)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: controller.showNotificationList,
              icon: const Icon(Icons.mark_email_read_outlined, size: 18),
              label: const Text('Tandai Semua Dibaca', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F6B43), foregroundColor: Colors.white, elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            ),
          ],
        ),
      );
    }

    final visibleItems = controller.visibleData;

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
          const Text('Notifikasi', style: TextStyle(fontFamily: 'Quicksand', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          const SizedBox(height: 18),
          Row(
            children: [
              NotificationSearchBar(controller: controller.searchController, onChanged: controller.updateSearch),
              const Spacer(),
              SizedBox(
                height: 20,
                child: Checkbox(
                  value: controller.isAllSelected,
                  tristate: controller.isIndeterminate,
                  onChanged: (value) => controller.toggleSelectAll(value ?? false),
                  activeColor: const Color(0xFF0F6B43),
                ),
              ),
              const Text('Pilih Semua', style: TextStyle(fontFamily: 'Quicksand', fontSize: 13, color: Color(0xFF1E293B))),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: controller.selectedIds.isEmpty ? null : () => controller.deleteSelected(),
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('Hapus Dipilih'),
                style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFD14343), side: const BorderSide(color: Color(0xFFD9A1A1)), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: controller.totalData == 0 ? null : () => controller.deleteAll(),
                icon: const Icon(Icons.delete_forever_outlined, size: 18),
                label: const Text('Hapus Semua'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD14343), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
            child: Column(
              children: [
                for (final item in visibleItems)
                  NotificationListItem(
                    item: item,
                    selected: controller.selectedIds.contains(item.id),
                    onSelected: (selected) => controller.toggleSelection(item.id, selected),
                    onMarkRead: () {
                      controller.markRead(item.id);
                      MerchantToast.show(context, 'Notifikasi ditandai dibaca', type: ToastType.success);
                    },
                    onDelete: () => _showDeleteConfirmation(context, item),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          NotificationPagination(
            currentPage: controller.currentPage,
            totalPages: controller.totalPages,
            totalItems: controller.totalData,
            onPrevious: controller.previousPage,
            onNext: controller.nextPage,
          ),
        ],
      ),
    );
  }
}

