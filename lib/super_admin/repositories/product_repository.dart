import 'package:supabase_flutter/supabase_flutter.dart';
import 'base_repository.dart';

class ProductRepository extends BaseRepository<Map<String, dynamic>> {
  ProductRepository() : super('products');

  @override
  Map<String, dynamic> fromJson(Map<String, dynamic> json) {
    return Map<String, dynamic>.from(json);
  }

  @override
  Map<String, dynamic> toJson(Map<String, dynamic> item) {
    return Map<String, dynamic>.from(item);
  }

  @override
  Future<List<Map<String, dynamic>>> getAll() async {
    final response = await supabase.client
        .from('products')
        .select(
          'id, product_code, merchant_id, category_id, name, description, price, original_price, stock, tag, rating, total_reviews, approval_status, approved_by, approved_at, is_active, created_at, updated_at, merchants(shop_name), categories(name), product_images(image_url, is_primary)',
        );

    final productIds = response
        .map((row) => row['id'])
        .whereType<Object>()
        .toList();
    final commissionRows = productIds.isEmpty
        ? const <Map<String, dynamic>>[]
        : List<Map<String, dynamic>>.from(
            await supabase.client
                .from('product_commissions')
                .select('product_id, id, base_price, admin_fee, commission_rate, final_price, status, is_published_to_customer')
                .inFilter('product_id', productIds),
          );
    final commissionByProductId = {
      for (final row in commissionRows) row['product_id']?.toString() ?? '': row,
    };

    return List<Map<String, dynamic>>.from(response).map((row) {
      final images = row['product_images'] as List<dynamic>?;
      String? primaryImage;
      if (images != null && images.isNotEmpty) {
        final primary = images.firstWhere(
          (item) => item['is_primary'] == true,
          orElse: () => images.first,
        );
        primaryImage = primary['image_url']?.toString();
      }
      final mapped = Map<String, dynamic>.from(row);
      final merchant = row['merchants'] as Map<String, dynamic>?;
      final category = row['categories'] as Map<String, dynamic>?;
      final commission = commissionByProductId[row['id']?.toString() ?? ''];
      if (merchant != null) mapped['merchant_name'] = merchant['shop_name']?.toString();
      if (category != null) mapped['category_name'] = category['name']?.toString();
      if (primaryImage != null && primaryImage.isNotEmpty) {
        mapped['image_url'] = primaryImage;
      }
      if (commission != null) {
        mapped['commission_id'] = commission['id']?.toString();
        mapped['base_price'] = commission['base_price'] ?? mapped['original_price'] ?? mapped['price'];
        mapped['admin_fee'] = commission['admin_fee'] ?? 0;
        mapped['commission_rate'] = commission['commission_rate'] ?? 0;
        mapped['final_price'] = commission['final_price'] ?? mapped['price'];
        mapped['is_published_to_customer'] = commission['is_published_to_customer'] == true;
        mapped['commission_status'] = commission['status']?.toString();
      }
      return mapped;
    }).toList();
  }

  /// Approve product - Update approval_status ke 'approved'
  Future<Map<String, dynamic>> approve(String productId) async {
    final currentUser = Supabase.instance.client.auth.currentUser;

    final updated = await supabase.client
        .from('products')
        .update({
          'approval_status': 'approved',
          'is_active': true,
          'approved_by': currentUser?.id,
          'approved_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', productId)
        .select()
        .single();

    return fromJson(updated);
  }

    Future<Map<String, dynamic>> publishToCustomer(String productId) async {
    final currentUser = Supabase.instance.client.auth.currentUser;
    final product = await supabase.client
        .from('products')
        .select('id, merchant_id, price, original_price, stock, tag, name, description, category_id, approval_status, is_active')
        .eq('id', productId)
        .single();

    final existingCommission = await supabase.client
        .from('product_commissions')
        .select('base_price, admin_fee, commission_rate, final_price, status, is_published_to_customer')
        .eq('product_id', productId)
        .maybeSingle();

    final basePrice = (existingCommission?['base_price'] as num?)?.toDouble() ?? (product['original_price'] as num?)?.toDouble() ?? (product['price'] as num?)?.toDouble() ?? 0;
    final commissionRate = (existingCommission?['commission_rate'] as num?)?.toDouble() ?? 0;
    final adminFee = (existingCommission?['admin_fee'] as num?)?.toDouble() ?? 0;
    final finalPrice = (existingCommission?['final_price'] as num?)?.toDouble() ?? (product['price'] as num?)?.toDouble() ?? 0;

    final updated = await supabase.client
        .from('products')
        .update({
          'approval_status': 'approved',
          'is_active': true,
          'approved_by': currentUser?.id,
          'approved_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', productId)
        .select()
        .single();

    await supabase.client.from('product_commissions').upsert({
      'product_id': productId,
      'merchant_id': product['merchant_id'],
      'base_price': basePrice,
      'admin_fee': adminFee,
      'commission_rate': commissionRate,
      'final_price': finalPrice,
      'status': 'published',
      'is_published_to_customer': true,
      'updated_at': DateTime.now().toIso8601String(),
    }, onConflict: 'product_id');

    return fromJson(updated);
  }

  /// Reject product - Update approval_status ke 'rejected'
  Future<Map<String, dynamic>> reject(String productId, String reason) async {
    final currentUser = Supabase.instance.client.auth.currentUser;

    final updated = await supabase.client
        .from('products')
        .update({
          'approval_status': 'rejected',
          'rejection_reason': reason,
          'approved_by': currentUser?.id,
          'approved_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', productId)
        .select()
        .single();

    return fromJson(updated);
  }

  Future<List<Map<String, dynamic>>> search(String query) async {
    final items = await getAll();
    if (query.trim().isEmpty) return items;

    final lowerQuery = query.toLowerCase();
    return items.where((item) {
      final name = item['name']?.toString().toLowerCase() ?? '';
      final description = item['description']?.toString().toLowerCase() ?? '';
      final category = item['category']?.toString().toLowerCase() ?? '';
      final productCode = item['product_code']?.toString().toLowerCase() ?? '';
      return name.contains(lowerQuery) ||
          description.contains(lowerQuery) ||
          category.contains(lowerQuery) ||
          productCode.contains(lowerQuery);
    }).toList();
  }

  Future<List<Map<String, dynamic>>> filterByCategory(String category) async {
    final items = await getAll();
    if (category == 'Semua') return items;
    return items
        .where((item) => item['category_id']?.toString() == category)
        .toList();
  }

  Future<List<Map<String, dynamic>>> filterByStatus(String status) async {
    final items = await getAll();
    if (status == 'Semua') return items;
    return items
        .where((item) => item['approval_status']?.toString() == status)
        .toList();
  }

  Future<List<Map<String, dynamic>>> filterByActive(bool isActive) async {
    final items = await getAll();
    return items.where((item) => (item['is_active'] == isActive)).toList();
  }
}

