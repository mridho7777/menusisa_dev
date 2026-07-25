import 'package:supabase_flutter/supabase_flutter.dart';
import '../modules/merchant_management/models/merchant_management_models.dart';
import 'base_repository.dart';

class MerchantRepository extends BaseRepository<MerchantRecord> {
  MerchantRepository() : super('merchants');

  @override
  MerchantRecord fromJson(Map<String, dynamic> json) {
    return MerchantRecord(
      id: json['id']?.toString() ?? '',
      merchantId: json['merchant_code']?.toString() ?? json['id']?.toString() ?? '',
      shopName: json['shop_name']?.toString() ?? '',
      ownerName: json['owner_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['shop_phone']?.toString() ?? json['phone']?.toString() ?? '',
      status: json['approval_status']?.toString() ?? 'pending',
      registeredAt: json['created_at']?.toString() ?? json['registered_at']?.toString() ?? '',
      totalProducts: json['total_products']?.toString() ?? '0',
      totalSales: json['total_sales']?.toString() ?? '0',
    );
  }

  @override
  Map<String, dynamic> toJson(MerchantRecord item) {
    return {
      'id': item.id,
      'shop_name': item.shopName,
      'owner_name': item.ownerName,
      'email': item.email,
      'shop_phone': item.phone,
      'approval_status': item.status,
    };
  }

  /// Approve merchant - Update approval_status ke 'approved'
  Future<MerchantRecord> approve(String merchantId) async {
    final currentUser = Supabase.instance.client.auth.currentUser;
    
    final updated = await supabase.client
        .from('merchants')
        .update({
          'approval_status': 'approved',
          'approved_by': currentUser?.id,
          'approved_at': DateTime.now().toIso8601String(),
        })
        .eq('id', merchantId)
        .select()
        .single();
    
    return fromJson(updated);
  }

  /// Reject merchant - Update approval_status ke 'rejected'
  Future<MerchantRecord> reject(String merchantId, String reason) async {
    final currentUser = Supabase.instance.client.auth.currentUser;
    
    final updated = await supabase.client
        .from('merchants')
        .update({
          'approval_status': 'rejected',
          'rejection_reason': reason,
          'approved_by': currentUser?.id,
          'approved_at': DateTime.now().toIso8601String(),
        })
        .eq('id', merchantId)
        .select()
        .single();
    
    return fromJson(updated);
  }

  /// Suspend merchant - Set is_active ke false
  Future<MerchantRecord> suspend(String merchantId) async {
    final updated = await supabase.client
        .from('merchants')
        .update({'is_active': false})
        .eq('id', merchantId)
        .select()
        .single();
    
    return fromJson(updated);
  }

  /// Deactivate merchant - Set is_active ke false
  Future<MerchantRecord> deactivate(String merchantId) async {
    final updated = await supabase.client
        .from('merchants')
        .update({'is_active': false})
        .eq('id', merchantId)
        .select()
        .single();
    
    return fromJson(updated);
  }

  /// Get all merchants with user details
  @override
  Future<List<MerchantRecord>> getAll() async {
    final data = await supabase.client
        .from('merchants')
        .select('''
          *,
          users:user_id (
            id,
            email,
            full_name,
            phone
          )
        ''')
        .order('created_at', ascending: false);
    
    return data.map<MerchantRecord>((json) {
      final userInfo = json['users'] as Map<String, dynamic>?;
      
      return MerchantRecord(
        id: json['id']?.toString() ?? '',
        merchantId: json['id']?.toString() ?? '',
        shopName: json['shop_name']?.toString() ?? '',
        ownerName: userInfo?['full_name']?.toString() ?? '',
        email: userInfo?['email']?.toString() ?? '',
        phone: json['shop_phone']?.toString() ?? userInfo?['phone']?.toString() ?? '',
        status: json['approval_status']?.toString() ?? 'pending',
        registeredAt: json['created_at']?.toString() ?? '',
        totalProducts: '0', // TODO: Count from products table
        totalSales: '0', // TODO: Count from orders table
      );
    }).toList();
  }

  Future<List<MerchantRecord>> search(String query) async {
    final all = await getAll();
    if (query.isEmpty) return all;
    final lowerQuery = query.toLowerCase();
    return all.where((m) {
      return m.shopName.toLowerCase().contains(lowerQuery) ||
          m.ownerName.toLowerCase().contains(lowerQuery) ||
          m.email.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  Future<List<MerchantRecord>> filterByStatus(String status) async {
    final all = await getAll();
    if (status == 'Semua') return all;
    return all.where((m) => m.status == status).toList();
  }
}
