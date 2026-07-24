import 'package:supabase_flutter/supabase_flutter.dart';
import 'order_model.dart';

class OrderService {
  final _client = Supabase.instance.client;

  Future<List<OrderModel>> fetchOrders() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    final merchant = await _client.from('merchants').select('id').eq('user_id', user.id).maybeSingle();
    if (merchant == null) return [];

    final data = await _client.from('orders').select('id, order_code, status, total_amount, customer_note, pickup_time, created_at, user_id, users!inner(full_name, phone)').eq('merchant_id', merchant['id']).order('created_at', ascending: false);

    return data.map<OrderModel>((row) => OrderModel(
      id: row['id']?.toString() ?? '',
      orderNumber: row['order_code']?.toString() ?? '',
      customerName: row['users']?['full_name']?.toString() ?? 'Customer',
      customerPhone: row['users']?['phone']?.toString() ?? '-',
      orderDate: DateTime.tryParse(row['created_at']?.toString() ?? '') ?? DateTime.now(),
      status: _statusFromDb(row['status']?.toString() ?? 'processing'),
      totalAmount: (row['total_amount'] ?? 0).toDouble(),
      items: const [],
      notes: row['customer_note']?.toString(),
      deliveryAddress: null,
      pickupTime: DateTime.tryParse(row['pickup_time']?.toString() ?? ''),
    )).toList();
  }

  Future<bool> updateOrderStatus(String id, OrderStatus status) async {
    try {
      await _client.from('orders').update({'status': _dbStatus(status), 'updated_at': DateTime.now().toIso8601String()}).eq('id', id);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> changeStatus(String id, OrderStatus status) => updateOrderStatus(id, status);

  Future<bool> deleteOrder(String id) async {
    try {
      await _client.from('orders').delete().eq('id', id);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateOrder(OrderModel order) async {
    try {
      await _client.from('orders').update({
        'order_code': order.orderNumber,
        'status': _dbStatus(order.status),
        'total_amount': order.totalAmount,
        'customer_note': order.notes,
        'pickup_time': order.pickupTime?.toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', order.id);
      return true;
    } catch (_) {
      return false;
    }
  }

  OrderStatus _statusFromDb(String status) {
    switch (status) {
      case 'created':
      case 'processing':
        return OrderStatus.baru;
      case 'ready_pickup':
        return OrderStatus.siapDiambil;
      case 'done':
        return OrderStatus.selesai;
      case 'cancelled':
        return OrderStatus.dibatalkan;
      default:
        return OrderStatus.baru;
    }
  }

  String _dbStatus(OrderStatus status) {
    switch (status) {
      case OrderStatus.baru:
        return 'created';
      case OrderStatus.diproses:
        return 'processing';
      case OrderStatus.siapDiambil:
        return 'ready_pickup';
      case OrderStatus.selesai:
        return 'done';
      case OrderStatus.dibatalkan:
        return 'cancelled';
    }
  }
}
