import 'package:flutter/material.dart';

import '../models/payment_monitoring_models.dart';

class PaymentTableCard extends StatelessWidget {
  const PaymentTableCard({
    super.key,
    required this.items,
    required this.onView,
    required this.onUpdate,
    required this.onCancel,
    required this.onRefund,
  });

  final List<PaymentItem> items;
  final ValueChanged<PaymentItem> onView;
  final ValueChanged<PaymentItem> onUpdate;
  final ValueChanged<PaymentItem> onCancel;
  final ValueChanged<PaymentItem> onRefund;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Daftar Pembayaran',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
            Text(
              'Menampilkan 1 - ${items.length} dari ${items.length} data',
              style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
            headingTextStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF374151),
            ),
            dataTextStyle: const TextStyle(
              fontSize: 13,
              color: Color(0xFF111827),
            ),
            columnSpacing: 24,
            horizontalMargin: 16,
            dataRowMinHeight: 56,
            dataRowMaxHeight: 56,
            columns: const [
              DataColumn(label: Text('No.')),
              DataColumn(label: Text('Order ID')),
              DataColumn(label: Text('Transaction ID')),
              DataColumn(label: Text('Customer')),
              DataColumn(label: Text('Merchant')),
              DataColumn(label: Text('Metode')),
              DataColumn(label: Text('Jumlah')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Waktu')),
              DataColumn(label: Text('Aksi')),
            ],
            rows: items.map((item) {
              final statusColor = switch (item.status) {
                'Berhasil' => const Color(0xFF16A34A),
                'Pending' => const Color(0xFFF59E0B),
                'Gagal' => const Color(0xFFEF4444),
                'Expired' => const Color(0xFF7C3AED),
                _ => const Color(0xFF6B7280),
              };

              return DataRow(
                cells: [
                  DataCell(Text(item.id)),
                  DataCell(Text(item.orderId, style: const TextStyle(fontWeight: FontWeight.w600))),
                  DataCell(Text(item.transactionId)),
                  DataCell(Text(item.customer)),
                  DataCell(Text(item.merchant)),
                  DataCell(Text(item.method)),
                  DataCell(Text(item.amount, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0F8D55)))),
                  DataCell(_StatusChip(label: item.status, color: statusColor)),
                  DataCell(Text(item.time)),
                  DataCell(_ActionMenu(item: item, onView: onView, onUpdate: onUpdate, onCancel: onCancel, onRefund: onRefund)),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        const _PaginationControls(),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
    child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
  );
}

class _ActionMenu extends StatelessWidget {
  const _ActionMenu({required this.item, required this.onView, required this.onUpdate, required this.onCancel, required this.onRefund});
  final PaymentItem item;
  final ValueChanged<PaymentItem> onView;
  final ValueChanged<PaymentItem> onUpdate;
  final ValueChanged<PaymentItem> onCancel;
  final ValueChanged<PaymentItem> onRefund;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_rounded, size: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      offset: const Offset(0, 40),
      onSelected: (action) {
        switch (action) {
          case 'view': onView(item); break;
          case 'update': onUpdate(item); break;
          case 'cancel': onCancel(item); break;
          case 'refund': onRefund(item); break;
        }
      },
      itemBuilder: (context) => [
        _buildMenuItem(Icons.visibility_rounded, 'Detail Pembayaran', 'view'),
        _buildMenuItem(Icons.edit_rounded, 'Update Status', 'update'),
        _buildMenuItem(Icons.close_rounded, 'Batalkan', 'cancel'),
        _buildMenuItem(Icons.undo_rounded, 'Refund', 'refund'),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(IconData icon, String label, String value) => PopupMenuItem(value: value, child: Row(children: [Icon(icon, size: 18, color: const Color(0xFF6B7280)), const SizedBox(width: 10), Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF111827)))]));
}

class _PaginationControls extends StatelessWidget {
  const _PaginationControls();
  @override
  Widget build(BuildContext context) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [const Text('10 / halaman', style: TextStyle(fontSize: 13, color: Color(0xFF6B7280))), const SizedBox(width: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE5E7EB)), borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.arrow_drop_down, size: 18))]), Row(children: [_PageButton(icon: Icons.chevron_left_rounded, onPressed: () {}), ...[1, 2, 3].map((page) => _PageButton(label: '$page', isActive: page == 1, onPressed: () {})), _PageButton(icon: Icons.chevron_right_rounded, onPressed: () {})])]);
}

class _PageButton extends StatelessWidget {
  const _PageButton({this.label, this.icon, this.isActive = false, required this.onPressed});
  final String? label; final IconData? icon; final bool isActive; final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2),
    child: Material(
      color: isActive ? const Color(0xFF0F8D55) : Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 32, height: 32, alignment: Alignment.center,
          decoration: BoxDecoration(border: isActive ? null : Border.all(color: const Color(0xFFE5E7EB)), borderRadius: BorderRadius.circular(6)),
          child: icon != null ? Icon(icon, size: 18, color: isActive ? Colors.white : const Color(0xFF6B7280)) : Text(label!, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isActive ? Colors.white : const Color(0xFF374151))),
        ),
      ),
    ),
  );
}

class PaymentDetailDialog extends StatelessWidget {
  const PaymentDetailDialog({super.key, required this.payment});

  final PaymentItem payment;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Detail Pembayaran'),
      content: Text('Detail untuk ${payment.orderId}'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tutup'),
        ),
      ],
    );
  }
}

class PaymentUpdateDialog extends StatelessWidget {
  const PaymentUpdateDialog({super.key, required this.payment});

  final PaymentItem payment;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Status Pembayaran'),
      content: Text('Update status untuk ${payment.orderId}'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}

class PaymentConfirmDialog extends StatelessWidget {
  const PaymentConfirmDialog({
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
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          style: FilledButton.styleFrom(backgroundColor: primaryColor),
          child: Text(primaryLabel),
        ),
      ],
    );
  }
}
