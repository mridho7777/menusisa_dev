import 'package:flutter/material.dart';

import '../models/transaction_management_models.dart';

class TransactionTableCard extends StatelessWidget {
  const TransactionTableCard({
    super.key,
    required this.items,
    required this.onView,
    required this.onUpdateStatus,
    required this.onRefund,
    required this.onPrint,
  });

  final List<TransactionItem> items;
  final ValueChanged<TransactionItem> onView;
  final ValueChanged<TransactionItem> onUpdateStatus;
  final ValueChanged<TransactionItem> onRefund;
  final ValueChanged<TransactionItem> onPrint;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
        final statusColor = switch (item.status) {
          'Berhasil' => const Color(0xFF16A34A),
          'Pending' => const Color(0xFFF59E0B),
          'Diproses' => const Color(0xFF2563EB),
          'Gagal' => const Color(0xFFEF4444),
          _ => const Color(0xFF6B7280),
        };
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              SizedBox(
                width: 28,
                child: Text(item.id, style: const TextStyle(fontSize: 12)),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: Text(
                  item.orderId,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  item.customer,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              Expanded(
                child: Text(
                  item.merchant,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              SizedBox(
                width: 90,
                child: Text(item.total, style: const TextStyle(fontSize: 12)),
              ),
              SizedBox(
                width: 90,
                child: Text(item.method, style: const TextStyle(fontSize: 12)),
              ),
              SizedBox(
                width: 86,
                child: _StatusChip(label: item.status, color: statusColor),
              ),
              SizedBox(
                width: 70,
                child: Text(item.time, style: const TextStyle(fontSize: 12)),
              ),
              SizedBox(
                width: 180,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => onView(item),
                      icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                    ),
                    IconButton(
                      onPressed: () => onUpdateStatus(item),
                      icon: const Icon(Icons.edit_outlined, size: 18),
                    ),
                    IconButton(
                      onPressed: () => onRefund(item),
                      icon: const Icon(
                        Icons.undo_rounded,
                        size: 18,
                        color: Color(0xFFF59E0B),
                      ),
                    ),
                    IconButton(
                      onPressed: () => onPrint(item),
                      icon: const Icon(Icons.print_outlined, size: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class TransactionDetailDialog extends StatelessWidget {
  const TransactionDetailDialog({super.key, required this.transaction});

  final TransactionItem transaction;

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
                  const Expanded(
                    child: Text(
                      'Detail Transaksi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const Divider(height: 24),
              _DetailRow(label: 'Order ID', value: transaction.orderId),
              _DetailRow(label: 'Customer', value: transaction.customer),
              _DetailRow(label: 'Merchant', value: transaction.merchant),
              _DetailRow(label: 'Total', value: transaction.total),
              _DetailRow(label: 'Metode', value: transaction.method),
              _DetailRow(label: 'Status', value: transaction.status),
              _DetailRow(label: 'Tanggal', value: transaction.date),
              _DetailRow(label: 'Waktu', value: transaction.time),
              const SizedBox(height: 8),
              const Text(
                'Item Pesanan',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              ...transaction.items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '• ',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
              ),
              if (transaction.notes.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text(
                  'Catatan',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(
                  transaction.notes,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12.5, color: Color(0xFF6B7280)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionUpdateStatusDialog extends StatelessWidget {
  const TransactionUpdateStatusDialog({super.key, required this.transaction});

  final TransactionItem transaction;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Update Status Transaksi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const Divider(height: 24),
              Text(
                'Order ID: ',
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Pilih Status Baru',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              _StatusOption(label: 'Berhasil', color: const Color(0xFF16A34A)),
              _StatusOption(label: 'Pending', color: const Color(0xFFF59E0B)),
              _StatusOption(label: 'Diproses', color: const Color(0xFF2563EB)),
              _StatusOption(label: 'Gagal', color: const Color(0xFFEF4444)),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Simpan'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusOption extends StatelessWidget {
  const _StatusOption({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.radio_button_unchecked_rounded, size: 18),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionConfirmDialog extends StatelessWidget {
  const TransactionConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.primaryColor,
  });

  final String title;
  final String message;
  final String primaryLabel;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(fontSize: 12.5, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(primaryLabel),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
