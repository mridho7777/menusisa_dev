import 'package:supabase_flutter/supabase_flutter.dart';

/// Repository untuk analytics dan cross-page data integration
class AnalyticsRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> trackEvent(String eventType, String entityType, String entityId, Map<String, dynamic> metadata) async {
    try {
      await _supabase.from('activity_logs').insert({
        'user_id': _supabase.auth.currentUser?.id,
        'user_name': _supabase.auth.currentUser?.email,
        'module': entityType,
        'activity_type': eventType,
        'description': metadata['description'] ?? '',
        'ip_address': '0.0.0.0',
        'device': 'Web Browser',
        'location': 'Unknown',
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (_) {}
  }

  Future<Map<String, dynamic>> getAggregatedDashboard() async {
    try {
      final merchants = await _supabase.from('merchants').select('id, is_active, approval_status');
      final products = await _supabase.from('products').select('id, approval_status');
      final orders = await _supabase.from('orders').select('id, created_at, status, total_amount, payment_method');

      final today = DateTime.now();
      final todayOrders = orders.where((row) {
        final createdAt = DateTime.tryParse(row['created_at']?.toString() ?? '');
        return createdAt != null && createdAt.year == today.year && createdAt.month == today.month && createdAt.day == today.day;
      }).toList();

      final dailyTransactions = <Map<String, dynamic>>[];
      for (var i = 6; i >= 0; i--) {
        final date = today.subtract(Duration(days: i));
        final dayOrders = orders.where((row) {
          final createdAt = DateTime.tryParse(row['created_at']?.toString() ?? '');
          return createdAt != null && createdAt.year == date.year && createdAt.month == date.month && createdAt.day == date.day;
        }).toList();
        dailyTransactions.add({'date': date.toIso8601String(), 'count': dayOrders.length});
      }

      final paymentMethods = <String, int>{};
      for (final order in orders) {
        final method = order['payment_method']?.toString() ?? 'Lainnya';
        paymentMethods[method] = (paymentMethods[method] ?? 0) + 1;
      }

      return {
        'merchants': {
          'total': merchants.length,
          'active': merchants.where((row) => row['is_active'] == true).length,
          'pending': merchants.where((row) => row['approval_status'] == 'pending').length,
        },
        'products': {
          'total': products.length,
          'approved': products.where((row) => row['approval_status'] == 'approved').length,
          'pending': products.where((row) => row['approval_status'] == 'pending').length,
        },
        'transactions': {
          'total': orders.length,
          'today': todayOrders.length,
          'daily': dailyTransactions,
          'payment_methods': paymentMethods,
        },
      };
    } catch (e) {
      return {
        'merchants': {'total': 0, 'active': 0, 'pending': 0},
        'products': {'total': 0, 'approved': 0, 'pending': 0},
        'transactions': {'total': 0, 'today': 0},
      };
    }
  }

  Future<Map<String, dynamic>> getCrossPageData(String entityId, String entityType) async {
    try {
      final data = <String, dynamic>{
        'entity_id': entityId,
        'entity_type': entityType,
        'related_merchants': [],
        'related_products': [],
        'related_transactions': [],
      };

      if (entityType == 'merchant') {
        data['related_products'] = await _supabase.from('products').select().eq('merchant_id', entityId);
        data['related_transactions'] = await _supabase.from('orders').select().eq('merchant_id', entityId);
      }

      return data;
    } catch (_) {
      return {
        'entity_id': entityId,
        'entity_type': entityType,
        'related_merchants': [],
        'related_products': [],
        'related_transactions': [],
      };
    }
  }
}
