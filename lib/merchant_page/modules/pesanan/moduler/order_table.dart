import 'package:flutter/material.dart';
import 'order_action_menu.dart';
import 'order_controller.dart';
import 'order_detail_dialog.dart';
import 'order_model.dart';

class OrderTable extends StatelessWidget {
  final OrderController controller;

  const OrderTable({super.key, required this.controller});

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day $month $year, $hour:$minute';
  }

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
    final orders = controller.filteredOrders;
    if (orders.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada pesanan',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final currentOrders = controller.filteredOrders;
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                columnSpacing: 24,
                horizontalMargin: 24,
                columns: const [
                  DataColumn(label: Text('Order', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Pelanggan', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Produk', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Total', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Status', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Waktu', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Aksi', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold))),
                ],
                rows: currentOrders.map((order) => _buildRow(context, order)).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  DataRow _buildRow(BuildContext context, OrderModel order) {
    final itemName = order.items.isNotEmpty ? order.items.first.productName : '-';
    return DataRow(
      cells: [
        DataCell(GestureDetector(
          onTap: () => _showOrderDetail(context, order),
          child: Text(
            order.orderNumber,
            style: const TextStyle(
              fontFamily: 'Quicksand',
              color: Color(0xFF0F6B43),
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        )),
        DataCell(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(order.customerName, style: const TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w600)),
            Text(order.customerPhone, style: const TextStyle(fontFamily: 'Quicksand', fontSize: 12, color: Color(0xFF64748B))),
          ],
        )),
        DataCell(Text(itemName, style: const TextStyle(fontFamily: 'Quicksand'))),
        DataCell(Text(_formatCurrency(order.totalAmount), style: const TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w600))),
        DataCell(_buildStatusChip(order.status)),
        DataCell(Text(_formatDate(order.orderDate), style: const TextStyle(fontFamily: 'Quicksand'))),
        DataCell(OrderActionMenu(order: order, onChanged: controller.refresh)),
      ],
    );
  }

  Widget _buildStatusChip(OrderStatus status) {
    final color = _parseColor(status.colorHex);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          fontFamily: 'Quicksand',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Color _parseColor(String hex) => Color(int.parse(hex.substring(1), radix: 16) + 0xFF000000);

  void _showOrderDetail(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (_) => OrderDetailDialog(order: order),
    );
  }
}
