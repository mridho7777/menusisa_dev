import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';
import '../../services/order_service.dart';
import '../../services/supabase_service.dart';
import '../../widgets/customer_top_header.dart';
import '../../utils/app_colors.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _orderService = OrderService.instance;
  final _supabaseService = SupabaseService.instance;

  List<Map<String, dynamic>> _allOrders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this)
      ..addListener(() {
        if (mounted) setState(() {});
      });
    _loadOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    try {
      final orders = await _orderService.getOrders();
      if (mounted) {
        setState(() {
          _allOrders = orders;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<Map<String, dynamic>> _getOrdersByStatus(String status) {
    if (status == 'cart') {
      return []; // Cart handled separately
    }
    if (status == 'all') {
      return _allOrders;
    }
    return _allOrders.where((order) => order['status'] == status).toList();
  }

  Future<void> _cancelOrder(String orderId) async {
    final reason = await _showCancelDialog();
    if (reason == null) return;

    final success = await _orderService.cancelOrder(orderId, reason);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pesanan berhasil dibatalkan')),
      );
      _loadOrders();
    }
  }

  Future<String?> _showCancelDialog() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Batalkan Pesanan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Alasan pembatalan:'),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Masukkan alasan...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Konfirmasi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final horizontalPadding = constraints.maxWidth < 600
                      ? 16.0
                      : 24.0;

                  return Column(
                    children: [
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          18,
                          horizontalPadding,
                          0,
                        ),
                        children: [
                          const CustomerTopHeader(subtitle: 'Pesanan'),
                          const SizedBox(height: 16),
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pesanan',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Pantau status pesananmu dari keranjang sampai selesai.',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12),
                              Icon(
                                Icons.receipt_long,
                                color: Color(0xFF6366F1),
                                size: 44,
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Container(
                            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: const Color(0xFFE5E7EB)),
                            ),
                            child: TabBar(
                              controller: _tabController,
                              isScrollable: true,
                              dividerColor: Colors.transparent,
                              dividerHeight: 0,
                              labelPadding: const EdgeInsets.only(right: 6),
                              tabAlignment: TabAlignment.start,
                              indicatorColor: Colors.transparent,
                              tabs: const [
                                Tab(
                                  child: _StatusTabChip(
                                    label: 'Keranjang',
                                    color: Color(0xFF6366F1),
                                  ),
                                ),
                                Tab(
                                  child: _StatusTabChip(
                                    label: 'Di Proses',
                                    color: Color(0xFFF59E0B),
                                  ),
                                ),
                                Tab(
                                  child: _StatusTabChip(
                                    label: 'Dibuat',
                                    color: Color(0xFF2563EB),
                                  ),
                                ),
                                Tab(
                                  child: _StatusTabChip(
                                    label: 'Siap Diambil',
                                    color: Color(0xFF1E6F3B),
                                  ),
                                ),
                                Tab(
                                  child: _StatusTabChip(
                                    label: 'Selesai',
                                    color: Color(0xFF16A34A),
                                  ),
                                ),
                                Tab(
                                  child: _StatusTabChip(
                                    label: 'Dibatalkan',
                                    color: Color(0xFFEF4444),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildCartTab(),
                            _buildOrderListTab('processing'),
                            _buildOrderListTab('created'),
                            _buildOrderListTab('ready_pickup'),
                            _buildOrderListTab('done'),
                            _buildOrderListTab('cancelled'),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }

  Widget _buildCartTab() {
    final state = context.watch<AppState>();
    final cartItems = state.cartItems;

    if (cartItems.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: _buildEmptyState(
          'Keranjang Kosong',
          'Belum ada produk di keranjang',
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return _buildCartCard(item, state);
            },
          ),
        ),
        _buildCartFooter(state),
      ],
    );
  }

  Widget _buildCartCard(CartItem item, AppState state) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.fastfood, size: 32),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.food.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Rp ${item.food.price.toInt()}',
                    style: const TextStyle(color: AppColors.primary),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => state.decreaseCartQuantity(item.food.id),
                ),
                Text('${item.quantity}'),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => state.increaseCartQuantity(item.food.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartFooter(AppState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                state.formatRp(state.cartTotal),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.cartItems.isEmpty
                  ? null
                  : () => _checkoutCart(state),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Checkout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _checkoutCart(AppState state) async {
    // Show payment method selection
    final paymentMethod = await _showPaymentMethodDialog();
    if (paymentMethod == null) return;

    try {
      // Create order via Supabase
      final orderItems = state.cartItems
          .map(
            (item) => {
              'product_id': item.food.id,
              'product_name': item.food.title,
              'quantity': item.quantity,
              'price': item.food.price.toInt(),
              'subtotal': (item.food.price * item.quantity).toInt(),
            },
          )
          .toList();

      final merchantId = state.cartItems.first.food.merchantId;
      if (merchantId.isEmpty) {
        throw StateError('Merchant ID kosong');
      }

      await _supabaseService.createOrder(
        userId: _supabaseService.userId!,
        merchantId: merchantId,
        items: orderItems,
        totalAmount: state.cartTotal.toDouble(),
        paymentMethod: paymentMethod,
      );

      if (mounted) {
        state.setCartItems([]); // Clear cart
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pesanan berhasil dibuat!')),
        );
        _loadOrders();
        _tabController.animateTo(1); // Go to "Di Proses" tab
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal membuat pesanan: $e')));
      }
    }
  }

  Future<String?> _showPaymentMethodDialog() async {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Metode Pembayaran'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('E-Wallet'),
              onTap: () => Navigator.pop(context, 'E-Wallet'),
            ),
            ListTile(
              title: const Text('Transfer Bank'),
              onTap: () => Navigator.pop(context, 'Transfer Bank'),
            ),
            ListTile(
              title: const Text('Cash'),
              onTap: () => Navigator.pop(context, 'Cash'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderListTab(String status) {
    final orders = _getOrdersByStatus(status);

    if (orders.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: _buildEmptyState(
          'Tidak Ada Pesanan',
          'Belum ada pesanan dengan status ini',
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadOrders,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return _buildOrderCard(order);
        },
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final orderCode = order['order_code'] ?? '';
    final status = order['status'] ?? '';
    final total = order['total_amount'] ?? 0;
    final createdAt = DateTime.tryParse(order['created_at'] ?? '');
    final merchant = order['merchants'] as Map<String, dynamic>?;
    final items = order['order_items'] as List<dynamic>? ?? [];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  orderCode,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildStatusBadge(status),
              ],
            ),
            const SizedBox(height: 8),
            Text('Toko: ${merchant?['shop_name'] ?? '-'}'),
            const Divider(height: 16),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item['quantity']}x ${item['product_name']}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    Text(
                      'Rp ${item['subtotal']}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  createdAt != null
                      ? '${createdAt.day}/${createdAt.month}/${createdAt.year}'
                      : '-',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  'Rp ${total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            // Show cancel button only for 'processing' status
            if (status == 'processing') ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _cancelOrder(order['id']),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Text('Batalkan Pesanan'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final statusMap = {
      'processing': {'label': 'Di Proses', 'color': const Color(0xFFF59E0B)},
      'created': {'label': 'Dibuat', 'color': const Color(0xFF2563EB)},
      'ready_pickup': {
        'label': 'Siap Diambil',
        'color': const Color(0xFF1E6F3B),
      },
      'done': {'label': 'Selesai', 'color': const Color(0xFF16A34A)},
      'cancelled': {'label': 'Dibatalkan', 'color': const Color(0xFFEF4444)},
    };

    final statusInfo =
        statusMap[status] ?? {'label': status, 'color': Colors.grey};

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: (statusInfo['color'] as Color).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusInfo['label'] as String,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: statusInfo['color'] as Color,
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 16, offset: Offset(0, 6))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Icon(Icons.inbox_outlined, size: 52, color: Color(0xFF9CA3AF)),
          ),
          const SizedBox(height: 18),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
          const SizedBox(height: 8),
          Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF6B7280), height: 1.4)),
        ],
      ),
    );
  }
}

class _StatusTabChip extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusTabChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
