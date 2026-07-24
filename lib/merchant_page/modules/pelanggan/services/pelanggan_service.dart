import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/pelanggan_model.dart';

class PelangganService {
  final _client = Supabase.instance.client;

  Future<List<PelangganModel>> fetchPelangganData() async {
    final user = _client.auth.currentUser;
    
    if (user == null) {
      return [];
    }

    try {
      // Get merchant ID
      final merchantData = await _client
          .from('merchants')
          .select('id')
          .eq('user_id', user.id)
          .maybeSingle();

      if (merchantData == null) {
        return [];
      }

      final merchantId = merchantData['id'];

      // Get unique customers from orders
      final orders = await _client
          .from('orders')
          .select('''
            user_id,
            total_amount,
            created_at,
            users!inner(id, full_name, email, phone, avatar_url)
          ''')
          .eq('merchant_id', merchantId);

      // Group orders by customer
      Map<String, Map<String, dynamic>> customerMap = {};

      for (var order in orders) {
        String userId = order['user_id'];
        
        if (!customerMap.containsKey(userId)) {
          customerMap[userId] = {
            'id': userId,
            'name': order['users']['full_name'] ?? 'Customer',
            'email': order['users']['email'] ?? '-',
            'phone': order['users']['phone'] ?? '-',
            'avatar_url': order['users']['avatar_url'],
            'total_orders': 0,
            'total_spent': 0.0,
            'last_order_date': order['created_at'],
          };
        }

        customerMap[userId]!['total_orders'] += 1;
        customerMap[userId]!['total_spent'] += (order['total_amount'] ?? 0).toDouble();
        
        // Update last order date if this order is more recent
        DateTime currentLastOrder = DateTime.parse(customerMap[userId]!['last_order_date']);
        DateTime thisOrderDate = DateTime.parse(order['created_at']);
        if (thisOrderDate.isAfter(currentLastOrder)) {
          customerMap[userId]!['last_order_date'] = order['created_at'];
        }
      }

      // Convert to list of PelangganModel
      List<PelangganModel> customers = customerMap.values.map((customer) {
        return PelangganModel(
          id: customer['id'],
          name: customer['name'],
          email: customer['email'],
          phone: customer['phone'],
          avatarUrl: customer['avatar_url'],
          totalOrders: customer['total_orders'],
          totalSpent: customer['total_spent'],
          lastOrderDate: customer['last_order_date'],
        );
      }).toList();

      // Sort by last order date (most recent first)
      customers.sort((a, b) {
        DateTime dateA = DateTime.parse(a.lastOrderDate ?? '2000-01-01');
        DateTime dateB = DateTime.parse(b.lastOrderDate ?? '2000-01-01');
        return dateB.compareTo(dateA);
      });

      return customers;
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>?> fetchCustomerDetail(String customerId) async {
    try {
      final user = _client.auth.currentUser;
      
      if (user == null) {
        return null;
      }

      // Get merchant ID
      final merchantData = await _client
          .from('merchants')
          .select('id')
          .eq('user_id', user.id)
          .maybeSingle();

      if (merchantData == null) {
        return null;
      }

      final merchantId = merchantData['id'];

      // Get customer info
      final customerData = await _client
          .from('users')
          .select('id, full_name, email, phone, avatar_url')
          .eq('id', customerId)
          .maybeSingle();

      if (customerData == null) {
        return null;
      }

      // Get customer's orders from this merchant
      final orders = await _client
          .from('orders')
          .select('id, order_code, status, total_amount, created_at')
          .eq('merchant_id', merchantId)
          .eq('user_id', customerId)
          .order('created_at', ascending: false);

      double totalSpent = 0;
      for (var order in orders) {
        totalSpent += (order['total_amount'] ?? 0).toDouble();
      }

      return {
        'id': customerData['id'],
        'name': customerData['full_name'] ?? 'Customer',
        'email': customerData['email'] ?? '-',
        'phone': customerData['phone'] ?? '-',
        'avatar_url': customerData['avatar_url'],
        'total_orders': orders.length,
        'total_spent': totalSpent,
        'orders': orders,
      };
    } catch (e) {
      return null;
    }
  }
}
