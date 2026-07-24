import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/order_service.dart';
import 'services/supabase_service.dart';

class AppState extends ChangeNotifier {
  final _supabase = SupabaseService.instance;
  final _orderService = OrderService.instance;
  RealtimeChannel? _ordersSub;
  RealtimeChannel? _notificationsSub;
  StreamSubscription<AuthState>? _authSub;

  AppState() {
    _bootstrap();
    _listenAuthChanges();
  }

  void _listenAuthChanges() {
    _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn || event == AuthChangeEvent.tokenRefreshed) {
        refreshFromSupabase();
        _startRealtimeSync();
      } else if (event == AuthChangeEvent.signedOut) {
        _teardownRealtimeSync();
        _clearLocalData();
      }
    });
  }

  Future<void> _bootstrap() async {
    await refreshFromSupabase();
    _startRealtimeSync();
  }

  Future<void> refreshFromSupabase() async {
    if (!_supabase.isAuthenticated) return;
    try {
      final favoriteRows = await _orderService.getFavorites();
      final cartRows = await _orderService.getCartItems();
      final orderRows = await _orderService.getOrders();

      setFavorites(favoriteRows.map((row) => _foodFromProductRow(row['products'] as Map<String, dynamic>? ?? row)).toList());
      setCartItems(cartRows.map((row) => CartItem(
        food: _foodFromProductRow(row['products'] as Map<String, dynamic>? ?? row),
        quantity: (row['quantity'] as num?)?.toInt() ?? 1,
      )).toList());
      setOrders(orderRows.map((row) => _orderFromRow(row)).toList());
    } catch (_) {}
  }

  void _startRealtimeSync() {
    if (!_supabase.isAuthenticated) return;
    _ordersSub?.unsubscribe();
    _notificationsSub?.unsubscribe();
    _ordersSub = _orderService.subscribeToOrders((_) {
      refreshFromSupabase();
    });
    _notificationsSub = _orderService.subscribeToNotifications((_) {
      refreshFromSupabase();
    });
  }

  void _teardownRealtimeSync() {
    _ordersSub?.unsubscribe();
    _notificationsSub?.unsubscribe();
    _ordersSub = null;
    _notificationsSub = null;
  }

  void _clearLocalData() {
    _favoriteItems.clear();
    _cartItems.clear();
    _orders.clear();
    _notifications.clear();
    notifyListeners();
  }

  FoodItem _foodFromProductRow(Map<String, dynamic> row) {
    final merchant = row['merchants'] as Map<String, dynamic>?;
    final category = row['categories'] as Map<String, dynamic>?;
    return FoodItem(
      id: row['id']?.toString() ?? '',
      merchantId: row['merchant_id']?.toString() ?? '',
      title: row['name']?.toString() ?? '',
      store: merchant?['shop_name']?.toString() ?? 'Merchant',
      merchantLogoUrl: merchant?['shop_logo_url']?.toString(),
      imageUrl: row['product_image_url']?.toString() ?? (() {
        final images = row['product_images'] as List<dynamic>?;
        if (images == null || images.isEmpty) return null;
        final primary = images.firstWhere((item) => item['is_primary'] == true, orElse: () => images.first);
        return primary['image_url']?.toString();
      })(),
      price: (row['price'] as num?)?.toDouble() ?? 0,
      originalPrice: (row['original_price'] as num?)?.toDouble() ?? (row['price'] as num?)?.toDouble() ?? 0,
      tag: row['tag']?.toString() ?? '',
      rating: (row['rating'] as num?)?.toDouble() ?? 4.5,
      distance: '${(row['distance_km'] as num?)?.toDouble() ?? 0} km',
      category: category?['name']?.toString() ?? 'Lainnya',
    );
  }

  OrderItem _orderFromRow(Map<String, dynamic> row) {
    final orderItems = (row['order_items'] as List<dynamic>? ?? []).map((item) => OrderLineItem(
      title: item['product_name']?.toString() ?? '',
      quantity: (item['quantity'] as num?)?.toInt() ?? 1,
      price: (item['price'] as num?)?.toInt() ?? 0,
    )).toList();

    final status = switch (row['status']?.toString()) {
      'processing' => OrderStatus.processing,
      'created' => OrderStatus.created,
      'ready_pickup' => OrderStatus.readyPickup,
      'done' => OrderStatus.done,
      'cancelled' => OrderStatus.cancelled,
      _ => OrderStatus.processing,
    };

    final merchant = row['merchants'] as Map<String, dynamic>?;
    return OrderItem(
      orderCode: row['order_code']?.toString() ?? '',
      status: status,
      merchantName: merchant?['shop_name']?.toString() ?? 'Merchant',
      pickupAddress: merchant?['shop_address']?.toString() ?? '-',
      pickupTime: row['pickup_time']?.toString() ?? '-',
      total: (row['total_amount'] as num?)?.toInt() ?? 0,
      items: orderItems,
      createdAt: DateTime.tryParse(row['created_at']?.toString() ?? '') ?? DateTime.now(),
      paymentMethod: row['payment_method']?.toString() ?? 'E-Wallet',
      cancelReason: row['cancelled_reason']?.toString(),
    );
  }

  @override
  void dispose() {
    _teardownRealtimeSync();
    _authSub?.cancel();
    super.dispose();
  }

  int _currentNavIndex = 0;
  int get currentNavIndex => _currentNavIndex;
  int _homeTabIndex = 0;
  int get homeTabIndex => _homeTabIndex;
  int _selectedCategoryIndex = 0;
  int get selectedCategoryIndex => _selectedCategoryIndex;
  bool _showOverlay = false;
  bool get showOverlay => _showOverlay;

  final List<NotificationItem> _notifications = [];
  List<NotificationItem> get notifications => List.unmodifiable(_notifications);
  final List<FoodItem> _favoriteItems = [];
  List<FoodItem> get favoriteItems => List.unmodifiable(_favoriteItems);
  final List<CartItem> _cartItems = [];
  List<CartItem> get cartItems => List.unmodifiable(_cartItems);
  final List<OrderItem> _orders = [];
  List<OrderItem> get orders => List.unmodifiable(_orders);

  bool isFavorite(String foodId) => _favoriteItems.any((item) => item.id == foodId);
  void changeNavIndex(int index) { _currentNavIndex = index; notifyListeners(); }
  void setHomeTabIndex(int index) { _homeTabIndex = index; _selectedCategoryIndex = index; notifyListeners(); }
  void setCategoryIndex(int index) { _selectedCategoryIndex = index; notifyListeners(); }
  void setOverlay(bool val) { _showOverlay = val; notifyListeners(); }

  Future<void> toggleFavorite(FoodItem food) async {
    try {
      await _orderService.toggleFavorite(food.id);
      await refreshFromSupabase();
    } catch (_) {
      final isFav = _favoriteItems.any((item) => item.id == food.id);
      if (isFav) { _favoriteItems.removeWhere((item) => item.id == food.id); } else { _favoriteItems.add(food); }
      notifyListeners();
    }
  }

  Future<bool> addToCart(FoodItem food) async {
    if (_cartItems.isNotEmpty) {
      final merchantId = _cartItems.first.food.merchantId;
      if (merchantId.isNotEmpty && merchantId != food.merchantId) {
        return false;
      }
    }
    try {
      await _orderService.addToCart(food.id, 1);
      await refreshFromSupabase();
      return true;
    } catch (_) {
      final existing = _cartItems.indexWhere((item) => item.food.id == food.id);
      if (existing >= 0) { _cartItems[existing].quantity += 1; } else { _cartItems.add(CartItem(food: food, quantity: 1)); }
      notifyListeners();
      return true;
    }
  }

  Future<void> increaseCartQuantity(String foodId) async {
    final index = _cartItems.indexWhere((item) => item.food.id == foodId);
    if (index < 0) return;
    if (_supabase.isAuthenticated) {
      await _orderService.updateCartQuantity(foodId, _cartItems[index].quantity + 1);
      await refreshFromSupabase();
      return;
    }
    _cartItems[index].quantity += 1;
    notifyListeners();
  }

  Future<void> decreaseCartQuantity(String foodId) async {
    final index = _cartItems.indexWhere((item) => item.food.id == foodId);
    if (index < 0) return;
    if (_supabase.isAuthenticated) {
      await _orderService.updateCartQuantity(foodId, _cartItems[index].quantity - 1);
      await refreshFromSupabase();
      return;
    }
    if (_cartItems[index].quantity <= 1) { _cartItems.removeAt(index); } else { _cartItems[index].quantity -= 1; }
    notifyListeners();
  }

  Future<void> removeCartItem(String foodId) async {
    if (_supabase.isAuthenticated) {
      await _orderService.removeFromCart(foodId);
      await refreshFromSupabase();
      return;
    }
    _cartItems.removeWhere((item) => item.food.id == foodId);
    notifyListeners();
  }

  int get cartTotal => _cartItems.fold<int>(0, (sum, item) => sum + ((item.food.price * item.quantity).round()));
  int get originalTotal => _cartItems.fold<int>(0, (sum, item) => sum + ((item.food.originalPrice * item.quantity).round()));
  String formatRp(int value) => 'Rp${value.toString().replaceAllMapped(RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (m) => '${m[1]}.')}';

  Future<void> addOrderFromCart({String paymentMethod = 'E-Wallet'}) async {
    if (_cartItems.isEmpty) return;
    if (_supabase.isAuthenticated) {
      final merchantId = _cartItems.first.food.merchantId;
      final items = _cartItems.map((item) => {
        'product_id': item.food.id,
        'product_name': item.food.title,
        'product_image_url': '',
        'quantity': item.quantity,
        'price': item.food.price.toInt(),
        'subtotal': (item.food.price * item.quantity).toInt(),
      }).toList();
      await _orderService.createOrder(merchantId: merchantId, items: items, totalAmount: cartTotal.toDouble(), paymentMethod: paymentMethod);
      await refreshFromSupabase();
      return;
    }
    final order = OrderItem(orderCode: 'MS-${DateTime.now().millisecondsSinceEpoch}', status: OrderStatus.processing, merchantName: 'Menunggu konfirmasi', pickupAddress: 'Akan diinformasikan', pickupTime: 'Menunggu konfirmasi', total: cartTotal, paymentMethod: paymentMethod, items: _cartItems.map((item) => OrderLineItem(title: item.food.title, quantity: item.quantity, price: item.food.price.toInt())).toList(), createdAt: DateTime.now());
    _orders.insert(0, order);
    _cartItems.clear();
    notifyListeners();
  }

  Future<void> setOrderStatus(String orderCode, OrderStatus status) async {
    if (_supabase.isAuthenticated) {
      await refreshFromSupabase();
      return;
    }
    final index = _orders.indexWhere((order) => order.orderCode == orderCode);
    if (index >= 0) { _orders[index].status = status; notifyListeners(); }
  }

  Future<void> cancelOrder(String orderCode, String reason) async {
    if (_supabase.isAuthenticated) {
      final order = _orders.firstWhere((o) => o.orderCode == orderCode, orElse: () => OrderItem(orderCode: orderCode, status: OrderStatus.processing, merchantName: '', pickupAddress: '', pickupTime: '', total: 0, items: const [], createdAt: DateTime.now(), paymentMethod: 'E-Wallet'));
      await _orderService.cancelOrder(order.orderCode, reason);
      await refreshFromSupabase();
      return;
    }
    final index = _orders.indexWhere((order) => order.orderCode == orderCode);
    if (index >= 0) {
      _orders[index].status = OrderStatus.cancelled;
      _orders[index].cancelReason = reason;
      notifyListeners();
    }
  }

  void removeNotificationAt(int index) { if (index >= 0 && index < _notifications.length) { _notifications.removeAt(index); notifyListeners(); } }
  void pushNotification({required String title, required String body, required IconData icon, required Color color}) { _notifications.insert(0, NotificationItem(title: title, body: body, icon: icon, color: color)); if (_notifications.length > 5) _notifications.removeLast(); notifyListeners(); }
  void setOrders(List<OrderItem> orders) { _orders.clear(); _orders.addAll(orders); notifyListeners(); }
  void setCartItems(List<CartItem> items) { _cartItems.clear(); _cartItems.addAll(items); notifyListeners(); }
  void setFavorites(List<FoodItem> favorites) { _favoriteItems.clear(); _favoriteItems.addAll(favorites); notifyListeners(); }
}

class FoodItem {
  final String id;
  final String merchantId;
  final String title;
  final String store;
  final String? imageUrl;
  final String? merchantLogoUrl;
  final String stockLabel;
  final double price;
  final double originalPrice;
  final String tag;
  final double rating;
  final String distance;
  final String category;

  FoodItem({required this.id, required this.merchantId, required this.title, required this.store, this.imageUrl, this.merchantLogoUrl, this.stockLabel = '0 porsi', required this.price, required this.originalPrice, required this.tag, required this.rating, required this.distance, required this.category});
}

class CartItem { CartItem({required this.food, required this.quantity}); final FoodItem food; int quantity; }

enum OrderStatus { processing, created, readyPickup, done, cancelled }

class OrderItem {
  final String orderCode;
  OrderStatus status;
  final String merchantName;
  final String pickupAddress;
  final String pickupTime;
  final int total;
  final String paymentMethod;
  final List<OrderLineItem> items;
  final DateTime createdAt;
  String? cancelReason;

  OrderItem({required this.orderCode, required this.status, required this.merchantName, required this.pickupAddress, required this.pickupTime, required this.total, required this.paymentMethod, required this.items, required this.createdAt, this.cancelReason});
}

class OrderLineItem { final String title; final int quantity; final int price; OrderLineItem({required this.title, required this.quantity, required this.price}); }

class NotificationItem { final String title; final String body; final IconData icon; final Color color; NotificationItem({required this.title, required this.body, required this.icon, required this.color}); }
