import 'package:flutter/material.dart';

import '../models/platform_commission_models.dart';

class CommissionDetailDialog extends StatelessWidget {
  const CommissionDetailDialog({super.key, required this.item});
  final CommissionTransactionItem item;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(child: Text('Detail Transaksi Komisi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
                ],
              ),
              const Divider(height: 24),
              _row('Order ID', item.orderId),
              _row('Merchant', item.merchant),
              _row('Tanggal', item.date.replaceAll('\n', ' ')),
              _row('Total Transaksi', item.totalTransaction),
              _row('Persentase Komisi', item.commissionRate),
              _row('Komisi Platform', item.platformCommission),
              _row('Pendapatan Merchant', item.totalTransaction),
              _row('Metode Pembayaran', item.paymentMethod),
              _row('Status Pembayaran', item.status),
              const SizedBox(height: 14),
              SizedBox(width: double.infinity, child: FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup'))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 140, child: Text(label, style: const TextStyle(fontSize: 12.5, color: Color(0xFF6B7280)))),
          const SizedBox(width: 12),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}

class CommissionHistoryDialog extends StatelessWidget {
  const CommissionHistoryDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Riwayat Perubahan Komisi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 14),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('No')),
                    DataColumn(label: Text('Persentase Lama')),
                    DataColumn(label: Text('Persentase Baru')),
                    DataColumn(label: Text('Diubah Oleh')),
                    DataColumn(label: Text('Tanggal')),
                    DataColumn(label: Text('Keterangan')),
                  ],
                  rows: const [
                    DataRow(cells: [DataCell(Text('1')), DataCell(Text('2.5%')), DataCell(Text('3%')), DataCell(Text('Super Admin')), DataCell(Text('15 Mei 2025')), DataCell(Text('Penyesuaian komisi'))]),
                    DataRow(cells: [DataCell(Text('2')), DataCell(Text('2%')), DataCell(Text('2.5%')), DataCell(Text('Super Admin')), DataCell(Text('10 Apr 2025')), DataCell(Text('Komisi dinaikkan'))]),
                    DataRow(cells: [DataCell(Text('3')), DataCell(Text('1.5%')), DataCell(Text('2%')), DataCell(Text('Super Admin')), DataCell(Text('01 Feb 2025')), DataCell(Text('Promo awal'))]),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(width: double.infinity, child: FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup'))),
            ],
          ),
        ),
      ),
    );
  }
}

class CommissionChangeDialog extends StatefulWidget {
  const CommissionChangeDialog({super.key});
  @override
  State<CommissionChangeDialog> createState() => _CommissionChangeDialogState();
}

class _CommissionChangeDialogState extends State<CommissionChangeDialog> {
  final controller = TextEditingController(text: '3');

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
            children: [
              const Icon(Icons.warning_amber_rounded, size: 56, color: Color(0xFFF59E0B)),
              const SizedBox(height: 12),
              const Text('Apakah Anda yakin ingin mengubah persentase komisi platform menjadi 3%?', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text('Perubahan hanya berlaku untuk transaksi baru.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12.5, color: Color(0xFF6B7280))),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                textAlign: TextAlign.center,
                decoration: InputDecoration(labelText: 'Persentase Komisi (%)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal'))),
                  const SizedBox(width: 10),
                  Expanded(child: FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Ya, Simpan Perubahan'))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommissionSuccessDialog extends StatelessWidget {
  const CommissionSuccessDialog({super.key, required this.newPercentage});
  final String newPercentage;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_rounded, size: 56, color: Color(0xFF16A34A)),
              const SizedBox(height: 12),
              const Text('Persentase komisi berhasil diperbarui.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text('Komisi Baru: $newPercentage', style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 16),
              SizedBox(width: double.infinity, child: FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup'))),
            ],
          ),
        ),
      ),
    );
  }
}
