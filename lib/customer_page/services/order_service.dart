import 'package:supabase_flutter/supabase_flutter.dart';

class OrderService {
  static OrderService? _instance;
  static OrderService get instance {
    _instance ??= OrderService._();
    return _instance!;
  }

  OrderService._();

  SupabaseClient get client => Supabase.instance.client;
  User? get currentUser => client.auth.currentUser;
  String? get userId => currentUser?.id;

  Future<List<Map<String, dynamic>>> getOrders({String? statusFilter}) async {
    if (userId == null) return [];

    try {
      PostgrestFilterBuilder queryBuilder = client
          .from('orders')
          .select('''
            *,
            merchants!orders_merchant_id_fkey(id, shop_name, shop_address),
            order_items!order_items_order_id_fkey(
              id,
              product_name,
              product_image_url,
              quantity,
              price,
              subtotal
            )
          ''')
          .eq('user_id', userId!);

      if (statusFilter != null && statusFilter != 'all') {
        queryBuilder = queryBuilder.eq('status', statusFilter);
      }

      final response = await queryBuilder.order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error getting orders: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> createOrder({
    required String merchantId,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
    required String paymentMethod,
    String? customerNote,
  }) async {
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final orderCode = 'MS-${DateTime.now().millisecondsSinceEpoch}';
    final subtotal = totalAmount;
    const platformFee = 1000.0;
    const commissionRate = 0.03;
    final commission = subtotal * commissionRate;
    final total = subtotal + platformFee;

    final order = await client.from('orders').insert({
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
    }).select().single();

    for (final item in items) {
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

    await clearCart();

    await client.from('notifications').insert({
      'recipient': 'customer',
      'entity_type': 'order',
      'entity_id': order['id'],
      'title': 'Pesanan Berhasil!',
      'message': 'Pesanan berhasil dibuat. Menunggu konfirmasi merchant.',
      'type': 'order',
      'is_read': false,
      'created_at': DateTime.now().toIso8601String(),
    });

    final merchant = await client.from('merchants').select('user_id').eq('id', merchantId).single();
    await client.from('notifications').insert({
      'recipient': 'merchant',
      'entity_type': 'order',
      'entity_id': order['id'],
      'title': 'Pesanan Baru!',
      'message': 'Anda menerima pesanan baru.',
      'type': 'order',
      'is_read': false,
      'created_at': DateTime.now().toIso8601String(),
    });

    return order;
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    if (userId == null) return [];
    final response = await client.from('favorites').select('''
      *,
      products(*, merchants(shop_name), product_images(image_url, is_primary), categories(name))
    ''').eq('user_id', userId!);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> toggleFavorite(String productId) async {
    if (userId == null) return;
    final existing = await client.from('favorites').select().eq('user_id', userId!).eq('product_id', productId).maybeSingle();
    if (existing != null) {
      await client.from('favorites').delete().eq('user_id', userId!).eq('product_id', productId);
    } else {
      await client.from('favorites').insert({'user_id': userId, 'product_id': productId});
    }
  }

  Future<bool> isFavorite(String productId) async {
    if (userId == null) return false;
    final result = await client.from('favorites').select().eq('user_id', userId!).eq('product_id', productId).maybeSingle();
    return result != null;
  }

  Future<List<Map<String, dynamic>>> getCartItems() async {
    if (userId == null) return [];
    final response = await client.from('cart_items').select('''
      *,
      products(*, merchants(shop_name), product_images(image_url, is_primary), categories(name))
    ''').eq('user_id', userId!);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> addToCart(String productId, int quantity) async {
    if (userId == null) return;
    final existing = await client.from('cart_items').select().eq('user_id', userId!).eq('product_id', productId).maybeSingle();
    if (existing != null) {
      await client.from('cart_items').update({
        'quantity': (existing['quantity'] as int) + quantity,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('user_id', userId!).eq('product_id', productId);
    } else {
      await client.from('cart_items').insert({'user_id': userId, 'product_id': productId, 'quantity': quantity});
    }
  }

  Future<void> updateCartQuantity(String productId, int quantity) async {
    if (userId == null) return;
    if (quantity <= 0) return removeFromCart(productId);
    await client.from('cart_items').update({'quantity': quantity, 'updated_at': DateTime.now().toIso8601String()}).eq('user_id', userId!).eq('product_id', productId);
  }

  Future<void> removeFromCart(String productId) async {
    if (userId == null) return;
    await client.from('cart_items').delete().eq('user_id', userId!).eq('product_id', productId);
  }

  Future<void> clearCart() async {
    if (userId == null) return;
    await client.from('cart_items').delete().eq('user_id', userId!);
  }

  Future<bool> cancelOrder(String orderId, String reason) async {
    if (userId == null) return false;
    try {
      await client.from('orders').update({
        'status': 'cancelled',
        'cancelled_by': userId,
        'cancelled_reason': reason,
        'cancelled_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', orderId);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    await client.from('notifications').update({
      'is_read': true,
      'read_at': DateTime.now().toIso8601String(),
    }).eq('id', notificationId);
  }

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    return await client.from('users').select().eq('id', userId).maybeSingle();
  }

  Future<void> updateUserProfile(String userId, {String? fullName, String? phone, String? avatarUrl}) async {
    final data = <String, dynamic>{'updated_at': DateTime.now().toIso8601String()};
    if (fullName != null) data['full_name'] = fullName;
    if (phone != null) data['phone'] = phone;
    if (avatarUrl != null) data['avatar_url'] = avatarUrl;
    await client.from('users').update(data).eq('id', userId);
  }

  RealtimeChannel subscribeToOrders(Function(Map<String, dynamic>) onUpdate) {
    if (userId == null) throw Exception('User not authenticated');
    return client.channel('orders:user_id=eq.$userId').onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'orders',
      filter: PostgresChangeFilter(type: PostgresChangeFilterType.eq, column: 'user_id', value: userId!),
      callback: (payload) => onUpdate(payload.newRecord),
    ).subscribe();
  }

  RealtimeChannel subscribeToNotifications(Function(Map<String, dynamic>) onNotification) {
    if (userId == null) throw Exception('User not authenticated');
    return client.channel('notifications:recipient=eq.customer').onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'notifications',
      filter: PostgresChangeFilter(type: PostgresChangeFilterType.eq, column: 'recipient', value: 'customer'),
      callback: (payload) => onNotification(payload.newRecord),
    ).subscribe();
  }
}

