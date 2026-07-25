import 'package:supabase_flutter/supabase_flutter.dart';

class MetricsRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Map<String, int>> getProductApprovalMetrics() async {
    try {
      final items = await _supabase.from('products').select('id, approval_status, is_active');
      return {
        'total_products': items.length,
        'total_pending': items.where((row) => row['approval_status'] == 'pending').length,
        'total_approved': items.where((row) => row['approval_status'] == 'approved').length,
        'total_rejected': items.where((row) => row['approval_status'] == 'rejected').length,
        'total_inactive': items.where((row) => row['is_active'] == false).length,
        'total_review': items.where((row) => row['approval_status'] == 'pending').length,
      };
    } catch (_) {
      return {'total_pending': 0, 'total_approved': 0, 'total_rejected': 0, 'total_inactive': 0, 'total_products': 0, 'total_review': 0};
    }
  }

  Future<Map<String, int>> getPaymentMetrics() async {
    try {
      final items = await _supabase.from('payment_monitoring').select('id, status');
      return {
        'total_payments': items.length,
        'total_pending': items.where((row) => row['status'] == 'pending').length,
        'total_verified': items.where((row) => row['status'] == 'verified').length,
        'total_failed': items.where((row) => row['status'] == 'failed').length,
      };
    } catch (_) {
      return {'total_payments': 0, 'total_pending': 0, 'total_verified': 0, 'total_failed': 0};
    }
  }

  Future<Map<String, int>> getTransactionMetrics() async {
    try {
      final items = await _supabase.from('orders').select('id, status');
      return {
        'total_orders': items.length,
        'total_processing': items.where((row) => row['status'] == 'processing').length,
        'total_completed': items.where((row) => row['status'] == 'done').length,
        'total_cancelled': items.where((row) => row['status'] == 'cancelled').length,
      };
    } catch (_) {
      return {'total_orders': 0, 'total_processing': 0, 'total_completed': 0, 'total_cancelled': 0};
    }
  }

  Future<Map<String, int>> getMerchantMetrics() async {
    try {
      final items = await _supabase.from('merchants').select('id, approval_status, is_active');
      return {
        'total_merchants': items.length,
        'total_pending': items.where((row) => row['approval_status'] == 'pending').length,
        'total_approved': items.where((row) => row['approval_status'] == 'approved').length,
        'total_active': items.where((row) => row['is_active'] == true).length,
      };
    } catch (_) {
      return {'total_merchants': 0, 'total_pending': 0, 'total_approved': 0, 'total_active': 0};
    }
  }

  Future<Map<String, int>> getCustomerMetrics() async {
    try {
      final items = await _supabase.from('users').select('id, role').eq('role', 'customer');
      return {'total_customers': items.length};
    } catch (_) {
      return {'total_customers': 0};
    }
  }
}
