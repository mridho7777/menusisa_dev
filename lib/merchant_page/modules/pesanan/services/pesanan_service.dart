import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/pesanan_model.dart';

class PesananService {
  final _client = Supabase.instance.client;

  PesananModel fetchPesananData() {
    return PesananModel(
      title: 'Halaman Pesanan',
      description: 'Pantau dan kelola pesanan masuk, sedang diproses, dan selesai.',
    );
  }

  Future<List<Map<String, dynamic>>> fetchOrders() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    try {
      final merchant = await _client.from('merchants').select('id').eq('user_id', user.id).maybeSingle();
      if (merchant == null) return [];

      final orders = await _client
          .from('orders')
          .select('id, order_code, status, subtotal, platform_fee, commission_amount, total_amount, payment_method, payment_status, customer_note, pickup_time, created_at, updated_at, user_id, users!inner(full_name, phone, email)')
          .eq('merchant_id', merchant['id'])
          .order('created_at', ascending: false);

      return orders.map<Map<String, dynamic>>((order) => {
        'id': order['id'],
        'order_code': order['order_code'],
        'status': order['status'],
        'subtotal': order['subtotal'],
        'platform_fee': order['platform_fee'],
        'commission_amount': order['commission_amount'],
        'total_amount': order['total_amount'],
        'payment_method': order['payment_method'],
        'payment_status': order['payment_status'],
        'customer_note': order['customer_note'],
        'pickup_time': order['pickup_time'],
        'created_at': order['created_at'],
        'updated_at': order['updated_at'],
        'customer_name': order['users']['full_name'] ?? 'Customer',
        'customer_phone': order['users']['phone'] ?? '-',
        'customer_email': order['users']['email'] ?? '-',
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<Map<String, dynamic>?> fetchOrderDetail(String orderId) async {
    try {
      final orderData = await _client.from('orders').select('id, order_code, status, subtotal, platform_fee, commission_amount, total_amount, payment_method, payment_status, customer_note, pickup_time, created_at, updated_at, user_id, users!inner(full_name, phone, email)').eq('id', orderId).maybeSingle();
      if (orderData == null) return null;
      final orderItems = await _client.from('order_items').select('*').eq('order_id', orderId);
      return {...orderData, 'customer_name': orderData['users']['full_name'] ?? 'Customer', 'customer_phone': orderData['users']['phone'] ?? '-', 'customer_email': orderData['users']['email'] ?? '-', 'items': orderItems};
    } catch (_) {
      return null;
    }
  }

  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _client.from('orders').update({'status': newStatus, 'updated_at': DateTime.now().toIso8601String()}).eq('id', orderId);
      return true;
    } catch (_) {
      return false;
    }
  }
}
