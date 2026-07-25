import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../notifikasi/controllers/notifikasi_controller.dart';
import 'order_model.dart';
import 'order_service.dart';

class OrderActionMenu extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onChanged;

  const OrderActionMenu({super.key, required this.order, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Color(0xFF64748B)),
      onSelected: (value) {
        final notifController = context.read<MerchantNotifikasiController>();
        String shortId(String v) => v.length > 8 ? v.substring(v.length - 8) : v;
        final service = OrderService();
        switch (value) {
          case 'detail':
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(order.orderNumber),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pelanggan: ${order.customerName}'),
                    Text('Telepon: ${order.customerPhone}'),
                    Text('Status: ${order.status.displayName}'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Tutup'),
                  ),
                ],
              ),
            );
            break;
          case 'edit':
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => OrderEditDialog(
                order: order,
                service: service,
                onSaved: onChanged,
              ),
            );
            break;
          case 'baru':
            service.changeStatus(order.id, OrderStatus.baru);
            notifController.addNotification(title: 'Status Pesanan Baru', description: 'Pesanan ${order.orderNumber} (ID ${shortId(order.id)}) diubah ke status Baru.', iconKey: 'check');
            onChanged?.call();
            break;
          case 'diproses':
            service.changeStatus(order.id, OrderStatus.diproses);
            notifController.addNotification(title: 'Pesanan Diproses', description: 'Pesanan ${order.orderNumber} (ID ${shortId(order.id)}) sedang diproses.', iconKey: 'edit');
            onChanged?.call();
            break;
          case 'siap':
            service.changeStatus(order.id, OrderStatus.siapDiambil);
            notifController.addNotification(title: 'Pesanan Siap Diambil', description: 'Pesanan ${order.orderNumber} (ID ${shortId(order.id)}) siap diambil pelanggan.', iconKey: 'payment');
            onChanged?.call();
            break;
          case 'selesai':
            service.changeStatus(order.id, OrderStatus.selesai);
            notifController.addNotification(title: 'Pesanan Selesai', description: 'Pesanan ${order.orderNumber} (ID ${shortId(order.id)}) telah selesai.', iconKey: 'campaign');
            onChanged?.call();
            break;
          case 'batal':
            service.changeStatus(order.id, OrderStatus.dibatalkan);
            notifController.addNotification(title: 'Pesanan Dibatalkan', description: 'Pesanan ${order.orderNumber} (ID ${shortId(order.id)}) dibatalkan.', iconKey: 'close');
            onChanged?.call();
            break;
          case 'hapus':
            service.deleteOrder(order.id);
            notifController.addNotification(title: 'Pesanan Dihapus', description: 'Pesanan ${order.orderNumber} (ID ${shortId(order.id)}) telah dihapus.', iconKey: 'close');
            onChanged?.call();
            break;
        }
      },
      itemBuilder: (_) => [
        const PopupMenuItem(value: 'detail', child: Text('Lihat Detail')),
        const PopupMenuItem(value: 'edit', child: Text('Edit Pesanan')),
        const PopupMenuDivider(),
        const PopupMenuItem(value: 'baru', child: Text('Ubah ke Baru')),
        const PopupMenuItem(value: 'diproses', child: Text('Ubah ke Diproses')),
        const PopupMenuItem(value: 'siap', child: Text('Ubah ke Siap Diambil')),
        const PopupMenuItem(value: 'selesai', child: Text('Ubah ke Selesai')),
        const PopupMenuItem(value: 'batal', child: Text('Ubah ke Dibatalkan')),
        const PopupMenuDivider(),
        const PopupMenuItem(value: 'hapus', child: Text('Hapus', style: TextStyle(color: Colors.red))),
      ],
    );
  }
}

class OrderEditDialog extends StatefulWidget {
  final OrderModel order;
  final OrderService service;
  final VoidCallback? onSaved;

  const OrderEditDialog({super.key, required this.order, required this.service, this.onSaved});

  @override
  State<OrderEditDialog> createState() => _OrderEditDialogState();
}

class _OrderEditDialogState extends State<OrderEditDialog> {
  late OrderStatus _status;
  late TextEditingController _notesController;
  late List<OrderItemDraft> _items;

  @override
  void initState() {
    super.initState();
    _status = widget.order.status;
    _notesController = TextEditingController(text: widget.order.notes ?? '');
    _items = widget.order.items
        .map((item) => OrderItemDraft(
              productId: item.productId,
              name: item.productName,
              quantity: item.quantity,
              price: item.price,
              imageUrl: item.imageUrl,
            ))
        .toList();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  double get _total => _items.fold<double>(0, (sum, item) => sum + (item.price * item.quantity));

  String _formatCurrency(double value) {
    final raw = value.toStringAsFixed(0);
    final buffer = StringBuffer();
    for (int index = 0; index < raw.length; index++) {
      final reverseIndex = raw.length - index;
      buffer.write(raw[index]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) buffer.write('.');
    }
    return 'Rp $buffer';
  }

  void _addItem() {
    setState(() {
      _items.add(
        OrderItemDraft(
          productId: 'new-${DateTime.now().microsecondsSinceEpoch}',
          name: 'Item Baru',
          quantity: 1,
          price: 0,
        ),
      );
    });
  }

  void _save() {
    final updated = widget.order.copyWith(
      status: _status,
      notes: _notesController.text.trim(),
      totalAmount: _total,
      items: _items
          .map(
            (item) => OrderItem(
              productId: item.productId,
              productName: item.name,
              quantity: item.quantity,
              price: item.price,
              imageUrl: item.imageUrl,
            ),
          )
          .toList(),
    );
    widget.service.updateOrder(updated);
    context.read<MerchantNotifikasiController>().addNotification(title: 'Pesanan Diperbarui', description: 'Pesanan ${widget.order.orderNumber} (ID ${widget.order.id.length > 8 ? widget.order.id.substring(widget.order.id.length - 8) : widget.order.id}) berhasil diperbarui.', iconKey: 'edit');
    widget.onSaved?.call();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Edit Pesanan',
                            style: TextStyle(fontFamily: 'Quicksand', fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close, size: 20, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(widget.order.orderNumber, style: const TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w600)),
                    const SizedBox(height: 14),
                    const Text('Status', style: TextStyle(fontFamily: 'Quicksand', fontSize: 12, color: Color(0xFF334155))),
                    const SizedBox(height: 6),
                    _buildDropdown(),
                    const SizedBox(height: 14),
                    const Text('Catatan', style: TextStyle(fontFamily: 'Quicksand', fontSize: 12, color: Color(0xFF334155))),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Catatan untuk pesanan ini',
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Text('Item Pesanan', style: TextStyle(fontFamily: 'Quicksand', fontSize: 12, color: Color(0xFF334155))),
                        const Spacer(),
                        IconButton(
                          onPressed: _addItem,
                          icon: const Icon(Icons.add_circle_outline, color: Color(0xFF0F6B43)),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 220),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (var index = 0; index < _items.length; index++) ...[
                              _buildItemRow(index),
                              if (index != _items.length - 1) const SizedBox(height: 10),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('Total Pesanan', style: TextStyle(fontFamily: 'Quicksand', fontSize: 12, fontWeight: FontWeight.w600)),
                        const Spacer(),
                        Text(_formatCurrency(_total), style: const TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w700)),
                      ],
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _save,
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F6B43), foregroundColor: Colors.white),
                            child: const Text('Simpan Perubahan'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<OrderStatus>(
      initialValue: _status,
      items: OrderStatus.values
          .map(
            (status) => DropdownMenuItem(
              value: status,
              child: Text(status.displayName, style: const TextStyle(fontFamily: 'Quicksand')),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) setState(() => _status = value);
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  Widget _buildItemRow(int index) {
    final item = _items[index];
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.fastfood, size: 18, color: Color(0xFF64748B)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(_formatCurrency(item.price), style: const TextStyle(fontFamily: 'Quicksand', fontSize: 12, color: Color(0xFF64748B))),
              ],
            ),
          ),
          IconButton(
            onPressed: () => setState(() => item.quantity = (item.quantity - 1).clamp(0, 999)),
            icon: const Icon(Icons.remove_circle_outline),
            visualDensity: VisualDensity.compact,
          ),
          Text(item.quantity.toString(), style: const TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w600)),
          IconButton(
            onPressed: () => setState(() => item.quantity += 1),
            icon: const Icon(Icons.add_circle_outline),
            visualDensity: VisualDensity.compact,
          ),
          Text(_formatCurrency(item.price * item.quantity), style: const TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w600)),
          IconButton(
            onPressed: () => setState(() => _items.removeAt(index)),
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

class OrderItemDraft {
  final String productId;
  final String name;
  int quantity;
  double price;
  final String? imageUrl;

  OrderItemDraft({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    this.imageUrl,
  });
}

