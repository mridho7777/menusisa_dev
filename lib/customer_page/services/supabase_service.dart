import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance {
    _instance ??= SupabaseService._();
    return _instance!;
  }

  SupabaseService._();

  SupabaseClient get client => Supabase.instance.client;

  // Auth helpers
  User? get currentUser => client.auth.currentUser;
  bool get isAuthenticated => currentUser != null;
  String? get userId => currentUser?.id;

  // Products
  Future<List<Map<String, dynamic>>> getProducts({String? category}) async {
    try {
      final rows = List<Map<String, dynamic>>.from(
        await client.from('products').select('''
            *,
            merchants(shop_name, shop_logo_url, latitude, longitude),
            categories(name)
          ''').order('created_at', ascending: false),
      );
      List<Map<String, dynamic>> commissionRows = const <Map<String, dynamic>>[];
      if (rows.isNotEmpty) {
        try {
          commissionRows = List<Map<String, dynamic>>.from(
            await client
                .from('product_commissions')
                .select('product_id, base_price, admin_fee, final_price, status, is_published_to_customer, updated_at')
                .inFilter('product_id', rows.map((row) => row['id']).whereType<Object>().toList()),
          );
        } catch (commissionError) {
          debugPrint('? getProducts commission fallback: $commissionError');
        }
      }
      final productIds = rows.map((row) => row['id']).whereType<Object>().toList();
      final imageRows = productIds.isEmpty
          ? const <Map<String, dynamic>>[]
          : List<Map<String, dynamic>>.from(
              await client
                  .from('product_images')
                  .select('product_id, image_url, is_primary, display_order')
                  .inFilter('product_id', productIds)
                  .order('display_order', ascending: true),
            );
      final imageByProductId = _groupPrimaryImages(imageRows);
      final commissionByProductId = {for (final row in commissionRows) row['product_id']?.toString() ?? '': row};
      final currentUser = client.auth.currentUser;
      Map<String, dynamic>? userLocation;
      if (currentUser != null) {
        try {
          userLocation = await client.from('users').select('latitude, longitude').eq('id', currentUser.id).maybeSingle();
        } catch (_) {
          userLocation = null;
        }
      }

      return rows.where((row) {
        final categoryMap = row['categories'] as Map<String, dynamic>?;
        final matchesCategory = category == null || category == 'Semua' || categoryMap?['name']?.toString() == category;
        final isApproved = row['approval_status']?.toString() == 'approved';
        final isActive = row['is_active'] != false;
        return matchesCategory && isActive && isApproved;
      }).map((row) {
        final merchant = row['merchants'] as Map<String, dynamic>?;
        final distance = _calculateDistanceKm(
          userLocation?['latitude'] as num?,
          userLocation?['longitude'] as num?,
          merchant?['latitude'] as num?,
          merchant?['longitude'] as num?,
        );
        final commission = commissionByProductId[row['id']?.toString() ?? ''];
        final primaryImage = imageByProductId[row['id']?.toString() ?? ''] ?? _pickPrimaryImage(row);
        final mergedRow = commission == null
            ? row
            : {
                ...row,
                'price': commission['final_price'] ?? row['price'],
                'original_price': commission['base_price'] ?? row['original_price'] ?? row['price'],
                'commission_status': commission['status'],
                'is_published_to_customer': commission['is_published_to_customer'],
              };
        return {
          ...mergedRow,
          ...(primaryImage == null ? const <String, dynamic>{} : {'product_image_url': primaryImage}),
          'distance_km': distance,
        };
      }).toList();
    } catch (e) {
      debugPrint('? getProducts fallback: $e');
      final basicRows = List<Map<String, dynamic>>.from(
        await client.from('products').select('id, merchant_id, name, category_id, description, price, original_price, stock, tag, rating, approval_status, is_active, created_at').order('created_at', ascending: false),
      );
      final ids = basicRows.map((row) => row['id']).whereType<Object>().toList();
      final commissions = ids.isEmpty
          ? const <Map<String, dynamic>>[]
          : List<Map<String, dynamic>>.from(
              await client.from('product_commissions').select('product_id, final_price, base_price, status, is_published_to_customer').inFilter('product_id', ids),
            );
      final commissionsById = {for (final row in commissions) row['product_id']?.toString() ?? '': row};
      final output = <Map<String, dynamic>>[];
      final imageRows = ids.isEmpty
          ? const <Map<String, dynamic>>[]
          : List<Map<String, dynamic>>.from(
              await client
                  .from('product_images')
                  .select('product_id, image_url, is_primary, display_order')
                  .inFilter('product_id', ids)
                  .order('display_order', ascending: true),
            );
      final imageByProductId = _groupPrimaryImages(imageRows);
      for (final row in basicRows) {
        final isApproved = row['approval_status']?.toString() == 'approved';
        final isActive = row['is_active'] != false;
        if (!isApproved || !isActive) continue;
        final commission = commissionsById[row['id']?.toString() ?? ''];
        final primaryImage = imageByProductId[row['id']?.toString() ?? ''] ?? _pickPrimaryImage(row);
        output.add({
          ...row,
          if (commission != null) ...{
            'price': commission['final_price'] ?? row['price'],
            'original_price': commission['base_price'] ?? row['original_price'] ?? row['price'],
            'commission_status': commission['status'],
            'is_published_to_customer': commission['is_published_to_customer'],
          },
          ...(primaryImage == null ? const <String, dynamic>{} : {'product_image_url': primaryImage}),
          'distance_km': 0,
        });
      }
      return output;
    }
  }




  String? _normalizeProductImageUrl(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    return client.storage.from('product-images').getPublicUrl(trimmed);
  }

  Map<String, String?> _groupPrimaryImages(List<Map<String, dynamic>> rows) {
    final grouped = <String, String?>{};
    for (final row in rows) {
      final productId = row['product_id']?.toString() ?? '';
      if (productId.isEmpty) continue;
      final candidate = _normalizeProductImageUrl(row['image_url']?.toString().trim());
      if (candidate == null || candidate.isEmpty) continue;
      final isPrimary = row['is_primary'] == true;
      final existing = grouped[productId];
      if (existing == null || isPrimary) {
        grouped[productId] = candidate;
      }
    }
    return grouped;
  }

  String? _pickPrimaryImage(Map<String, dynamic> row) {
    final images = row['product_images'];
    if (images is! List || images.isEmpty) return null;
    final primary = images.firstWhere(
      (item) => item is Map<String, dynamic> && item['is_primary'] == true,
      orElse: () => images.first,
    );
    if (primary is Map<String, dynamic>) {
      final url = _normalizeProductImageUrl(primary['image_url']?.toString());
      if (url != null && url.isNotEmpty) return url;
    }
    return null;
  }

  Future<List<String>> getCategories() async {
    final response = await client.from('categories').select('name').eq('is_active', true).order('display_order', ascending: true);
    final names = response.map<String>((row) => row['name']?.toString() ?? '').where((name) => name.isNotEmpty).toList();
    return ['Semua', ...names];
  }

  // Favorites
  Future<List<Map<String, dynamic>>> getFavorites(String userId) async {
    final response = await client
        .from('favorites')
        .select('''
          *,
          products(
            *,
            merchants(shop_name, shop_logo_url),
            product_images(image_url, is_primary)
          )
        ''')
        .eq('user_id', userId);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> toggleFavorite(String userId, String productId) async {
    final existing = await client
        .from('favorites')
        .select()
        .eq('user_id', userId)
        .eq('product_id', productId)
        .maybeSingle();

    if (existing != null) {
      await client
          .from('favorites')
          .delete()
          .eq('user_id', userId)
          .eq('product_id', productId);
    } else {
      await client.from('favorites').insert({
        'user_id': userId,
        'product_id': productId,
      });
    }
  }

  Future<bool> isFavorite(String userId, String productId) async {
    final result = await client
        .from('favorites')
        .select()
        .eq('user_id', userId)
        .eq('product_id', productId)
        .maybeSingle();

    return result != null;
  }

  // Cart
  Future<List<Map<String, dynamic>>> getCartItems(String userId) async {
    final response = await client
        .from('cart_items')
        .select('''
          *,
          products(
            *,
            merchants(shop_name, shop_logo_url),
            product_images(image_url, is_primary)
          )
        ''')
        .eq('user_id', userId);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> addToCart(String userId, String productId, int quantity) async {
    final existing = await client
        .from('cart_items')
        .select()
        .eq('user_id', userId)
        .eq('product_id', productId)
        .maybeSingle();

    if (existing != null) {
      await client
          .from('cart_items')
          .update({
            'quantity': existing['quantity'] + quantity,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId)
          .eq('product_id', productId);
    } else {
      await client.from('cart_items').insert({
        'user_id': userId,
        'product_id': productId,
        'quantity': quantity,
      });
    }
  }

  Future<void> updateCartQuantity(
    String userId,
    String productId,
    int quantity,
  ) async {
    if (quantity <= 0) {
      await removeFromCart(userId, productId);
    } else {
      await client
          .from('cart_items')
          .update({
            'quantity': quantity,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId)
          .eq('product_id', productId);
    }
  }

  Future<void> removeFromCart(String userId, String productId) async {
    await client
        .from('cart_items')
        .delete()
        .eq('user_id', userId)
        .eq('product_id', productId);
  }

  Future<void> clearCart(String userId) async {
    await client.from('cart_items').delete().eq('user_id', userId);
  }

  // Orders
  Future<Map<String, dynamic>> createOrder({
    required String userId,
    required String merchantId,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
    required String paymentMethod,
    String? customerNote,
  }) async {
    // Generate order code
    final orderCode = 'MS-';

    // Get platform settings
    final settings = await client.from('platform_settings').select();
    final commissionRate =
        (settings.firstWhere((s) => s['key'] == 'commission_rate')['value']
            as Map)['percentage'] ??
        3;
    final platformFee =
        (settings.firstWhere((s) => s['key'] == 'platform_fee')['value']
            as Map)['amount'] ??
        1000;

    final subtotal = totalAmount;
    final commission = subtotal * (commissionRate / 100);
    final total = subtotal + platformFee;

    // Create order
    final order = await client
        .from('orders')
        .insert({
          'order_code': orderCode,
          'user_id': userId,
          'merchant_id': merchantId,
          'status': 'processing',
          'subtotal': subtotal,
          'platform_fee': platformFee,
          'commission_amount': commission,
          'total_amount': total,
          'payment_method': paymentMethod,
          'payment_status': 'pending',
          'customer_note': customerNote,
        })
        .select()
        .single();

    // Insert order items
    for (var item in items) {
      await client.from('order_items').insert({
        'order_id': order['id'],
        'product_id': item['product_id'],
        'product_name': item['product_name'],
        'product_image_url': item['product_image_url'],
        'quantity': item['quantity'],
        'price': item['price'],
        'subtotal': item['subtotal'],
      });
    }

    // Clear cart
    await clearCart(userId);

    // Send notification to user
    await client.from('notifications').insert({
      'user_id': userId,
      'title': 'Pesanan Berhasil!',
      'body': 'Pesanan  berhasil dibuat. Menunggu konfirmasi merchant.',
      'type': 'order',
      'reference_id': order['id'],
    });

    // Send notification to merchant
    final merchant = await client
        .from('merchants')
        .select('user_id')
        .eq('id', merchantId)
        .single();

    await client.from('notifications').insert({
      'user_id': merchant['user_id'],
      'title': 'Pesanan Baru!',
      'body': 'Anda menerima pesanan baru .',
      'type': 'order',
      'reference_id': order['id'],
    });

    return order;
  }

  double _calculateDistanceKm(num? userLat, num? userLng, num? merchantLat, num? merchantLng) {
    if (userLat == null || userLng == null || merchantLat == null || merchantLng == null) {
      return 0;
    }
    const earthRadius = 6371.0;
    final dLat = _degToRad(merchantLat.toDouble() - userLat.toDouble());
    final dLng = _degToRad(merchantLng.toDouble() - userLng.toDouble());
    final a =
        (math.sin(dLat / 2) * math.sin(dLat / 2)) +
        math.cos(_degToRad(userLat.toDouble())) *
            math.cos(_degToRad(merchantLat.toDouble())) *
            (math.sin(dLng / 2) * math.sin(dLng / 2));
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return double.parse((earthRadius * c).toStringAsFixed(1));
  }

  double _degToRad(double degree) => degree * (3.1415926535897932 / 180.0);

  Future<List<Map<String, dynamic>>> getOrders(
    String userId, {
    String? status,
  }) async {
    var query = client
        .from('orders')
        .select('''
          *,
          merchants(shop_name, shop_address),
          order_items(*, products(name, product_images(image_url, is_primary)))
        ''')
        .eq('user_id', userId);

    if (status != null && status != 'all') {
      query = query.eq('status', status);
    }

    return List<Map<String, dynamic>>.from(
      await query.order('created_at', ascending: false),
    );
  }

  Future<void> cancelOrder(String orderId, String reason) async {
    await client
        .from('orders')
        .update({
          'status': 'cancelled',
          'cancelled_by': userId,
          'cancelled_reason': reason,
          'cancelled_at': DateTime.now().toIso8601String(),
        })
        .eq('id', orderId);
  }

  // Notifications
  Future<List<Map<String, dynamic>>> getNotifications(String userId) async {
    final response = await client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(50);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    await client
        .from('notifications')
        .update({'is_read': true, 'read_at': DateTime.now().toIso8601String()})
        .eq('id', notificationId);
  }

  // User Profile
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    return await client.from('users').select().eq('id', userId).maybeSingle();
  }

  Future<void> updateUserProfile(
    String userId, {
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    final data = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (fullName != null) data['full_name'] = fullName;
    if (phone != null) data['phone'] = phone;
    if (avatarUrl != null) data['avatar_url'] = avatarUrl;

    await client.from('users').update(data).eq('id', userId);
  }

  // Real-time subscriptions
  RealtimeChannel subscribeToOrders(
    String userId,
    Function(Map<String, dynamic>) onUpdate,
  ) {
    return client
        .channel('orders:user_id=eq.')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'orders',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            onUpdate(payload.newRecord);
          },
        )
        .subscribe();
  }

  RealtimeChannel subscribeToNotifications(
    String userId,
    Function(Map<String, dynamic>) onNotification,
  ) {
    return client
        .channel('notifications:user_id=eq.')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            onNotification(payload.newRecord);
          },
        )
        .subscribe();
  }
}










