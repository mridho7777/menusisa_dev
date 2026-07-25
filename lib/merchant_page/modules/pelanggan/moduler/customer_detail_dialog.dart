import 'package:flutter/material.dart';

import '../models/pelanggan_model.dart';

class CustomerDetailDialog extends StatelessWidget {
  final PelangganModel customer;

  const CustomerDetailDialog({super.key, required this.customer});

  String _currency(double value) {
    final formatted = value.toInt().toString().replaceAllMapped(RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (match) => '${match[1]}.');
    return 'Rp$formatted';
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: customer.avatarUrl != null && customer.avatarUrl!.isNotEmpty
                ? NetworkImage(customer.avatarUrl!)
                : null,
            backgroundColor: const Color(0xFFE2E8F0),
            radius: 20,
            child: customer.avatarUrl == null || customer.avatarUrl!.isEmpty
                ? const Icon(Icons.person, size: 20, color: Color(0xFF94A3B8))
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              customer.name,
              style: const TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Email', customer.email),
            const SizedBox(height: 12),
            _buildDetailRow('No. Telepon', customer.phone),
            const SizedBox(height: 12),
            _buildDetailRow('Total Pesanan', '${customer.totalOrders} pesanan'),
            const SizedBox(height: 12),
            _buildDetailRow('Total Belanja', _currency(customer.totalSpent)),
            const SizedBox(height: 12),
            _buildDetailRow('Terakhir Order', _formatDate(customer.lastOrderDate)),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Tutup', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontFamily: 'Quicksand', fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontFamily: 'Quicksand', fontSize: 14, color: Color(0xFF1E293B), fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
