import 'package:flutter/material.dart';
import 'order_model.dart';

class OrderDetailDialog extends StatelessWidget {
  final OrderModel order;

  const OrderDetailDialog({super.key, required this.order});

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
    return AlertDialog(
      title: Text(order.orderNumber),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Pelanggan: ${order.customerName}'),
              Text('Telepon: ${order.customerPhone}'),
              Text('Status: ${order.status.displayName}'),
              Text('Total: ${_formatCurrency(order.totalAmount)}'),
              const SizedBox(height: 12),
              const Text('Items:'),
              const SizedBox(height: 8),
              ...order.items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 52,
                          height: 52,
                          color: const Color(0xFFF3F4F6),
                          child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                              ? Image.network(
                                  item.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => const Icon(Icons.fastfood, color: Color(0xFFD1D5DB)),
                                )
                              : const Icon(Icons.fastfood, color: Color(0xFFD1D5DB)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.productName, style: const TextStyle(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 2),
                            Text('Qty ${item.quantity} • ${_formatCurrency(item.price)}', style: const TextStyle(color: Color(0xFF64748B))),
                          ],
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
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
      ],
    );
  }
}
