// Supabase Integration: cart_items, orders, order_items, payment_proofs
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../utils/app_colors.dart';
import '../services/supabase_service.dart';
import '../widgets/notification_popup.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _supabase = SupabaseService.instance;
  final TextEditingController _noteController = TextEditingController();
  String _selectedPaymentMethod = 'E-Wallet';
  bool _isProcessing = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _processCheckout() async {
    final state = context.read<AppState>();
    
    if (state.cartItems.isEmpty) {
      NotificationPopup.show(
        context,
        title: 'Keranjang Kosong',
        message: 'Tambahkan produk terlebih dahulu',
        icon: Icons.shopping_cart_outlined,
        color: Colors.orange,
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      if (_supabase.isAuthenticated) {
        final merchantIds = state.cartItems.map((item) => item.food.merchantId).where((id) => id.isNotEmpty).toSet();
        if (merchantIds.length > 1) {
          if (mounted) {
            NotificationPopup.show(
              context,
              title: 'Satu Toko Saja',
              message: 'Keranjang hanya bisa berisi produk dari satu merchant.',
              icon: Icons.store_outlined,
              color: Colors.orange,
            );
          }
          return;
        }
        // Create order via Supabase
        final orderItems = state.cartItems.map((item) => {
          'product_id': item.food.id,
          'product_name': item.food.title,
          'product_image_url': item.food.imageUrl ?? '',
          'quantity': item.quantity,
          'price': item.food.price.toInt(),
          'subtotal': (item.food.price * item.quantity).toInt(),
        }).toList();

        await _supabase.createOrder(
          userId: _supabase.userId!,
          merchantId: state.cartItems.first.food.merchantId,
          items: orderItems,
          totalAmount: state.cartTotal.toDouble(),
          paymentMethod: _selectedPaymentMethod,
          customerNote: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
        );

        if (mounted) {
          NotificationPopup.show(
            context,
            title: 'Pesanan Berhasil!',
            message: 'Pesanan Anda telah dibuat. Menunggu konfirmasi merchant.',
            icon: Icons.check_circle,
            color: AppColors.primary,
          );
          
          // Clear local cart
          state.cartItems.forEach((item) => state.removeCartItem(item.food.id));
          
          _showSuccessDialog();
        }
      } else {
        // Offline mode - use local state
        state.addOrderFromCart(paymentMethod: _selectedPaymentMethod);
        
        if (mounted) {
          NotificationPopup.show(
            context,
            title: 'Pesanan Berhasil!',
            message: 'Pesanan Anda sudah dikonfirmasi.',
            icon: Icons.check_circle,
            color: AppColors.primary,
          );
          
          _showSuccessDialog();
        }
      }
    } catch (e) {
      if (mounted) {
        NotificationPopup.show(
          context,
          title: 'Gagal Membuat Pesanan',
          message: 'Terjadi kesalahan: $e',
          icon: Icons.error_outline,
          color: Colors.red,
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pesanan Berhasil!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Pesanan Anda sudah dikonfirmasi. Silakan cek status pesanan di halaman Pesanan.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to orders tab
                  context.read<AppState>().changeNavIndex(4);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Lihat Pesanan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Keranjang',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: state.cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 120,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Keranjang Kosong',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tambahkan produk untuk mulai berbelanja',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => context.read<AppState>().changeNavIndex(0),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Mulai Belanja'),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Cart Items
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Paket Pesanan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              '\ item',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      ...state.cartItems.map((item) => _CartItemTile(
                            item: item,
                            onAdd: () {
                              state.increaseCartQuantity(item.food.id);
                              NotificationPopup.show(
                                context,
                                title: 'Jumlah Ditambah',
                                message: '\ +1',
                                icon: Icons.add_shopping_cart,
                                color: AppColors.primary,
                              );
                            },
                            onSubtract: () {
                              state.decreaseCartQuantity(item.food.id);
                              NotificationPopup.show(
                                context,
                                title: 'Jumlah Dikurangi',
                                message: '\ -1',
                                icon: Icons.remove_shopping_cart,
                                color: Colors.orange,
                              );
                            },
                            onRemove: () {
                              state.removeCartItem(item.food.id);
                              NotificationPopup.show(
                                context,
                                title: 'Dihapus dari Keranjang',
                                message: '\ telah dihapus',
                                icon: Icons.delete_outline,
                                color: Colors.red,
                              );
                            },
                          )),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Order Summary
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ringkasan Pesanan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _SummaryRow(
                        label: 'Subtotal',
                        value: state.formatRp(state.cartTotal),
                      ),
                      _SummaryRow(
                        label: 'Biaya Layanan',
                        value: 'Rp1.000',
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 12),
                      _SummaryRow(
                        label: 'Total',
                        value: state.formatRp(state.cartTotal + 1000),
                        isBold: true,
                        valueColor: AppColors.primary,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Payment Method
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Metode Pembayaran',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _PaymentMethodOption(
                        title: 'E-Wallet',
                        subtitle: 'OVO, GoPay, Dana, ShopeePay',
                        icon: Icons.account_balance_wallet,
                        selected: _selectedPaymentMethod == 'E-Wallet',
                        onTap: () => setState(() => _selectedPaymentMethod = 'E-Wallet'),
                      ),
                      const SizedBox(height: 12),
                      _PaymentMethodOption(
                        title: 'Transfer Bank',
                        subtitle: 'BCA, Mandiri, BRI, BNI',
                        icon: Icons.account_balance,
                        selected: _selectedPaymentMethod == 'Transfer Bank',
                        onTap: () => setState(() => _selectedPaymentMethod = 'Transfer Bank'),
                      ),
                      const SizedBox(height: 12),
                      _PaymentMethodOption(
                        title: 'QRIS',
                        subtitle: 'Scan QR untuk bayar',
                        icon: Icons.qr_code,
                        selected: _selectedPaymentMethod == 'QRIS',
                        onTap: () => setState(() => _selectedPaymentMethod = 'QRIS'),
                      ),
                      const SizedBox(height: 12),
                      _PaymentMethodOption(
                        title: 'Cash di Tempat',
                        subtitle: 'Bayar saat ambil pesanan',
                        icon: Icons.payments,
                        selected: _selectedPaymentMethod == 'Cash',
                        onTap: () => setState(() => _selectedPaymentMethod = 'Cash'),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Note
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Catatan Pesanan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _noteController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Tulis catatan untuk merchant (opsional)...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Checkout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _processCheckout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                      disabledBackgroundColor: Colors.grey.shade300,
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Bayar Sekarang',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                state.formatRp(state.cartTotal + 1000),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                
                const SizedBox(height: 40),
              ],
            ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({
    required this.item,
    required this.onAdd,
    required this.onSubtract,
    required this.onRemove,
  });

  final CartItem item;
  final VoidCallback onAdd;
  final VoidCallback onSubtract;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.fastfood,
              color: AppColors.primary,
              size: 32,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.food.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.food.store,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: onSubtract,
                    icon: const Icon(Icons.remove_circle_outline),
                    color: AppColors.primary,
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(4),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onAdd,
                    icon: const Icon(Icons.add_circle),
                    color: AppColors.primary,
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(4),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline, size: 16),
                label: const Text('Hapus'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.w700 : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              fontSize: isBold ? 18 : 14,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodOption extends StatelessWidget {
  const _PaymentMethodOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(14),
          color: selected ? AppColors.primaryLight : Colors.transparent,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary.withOpacity(0.2)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: selected ? AppColors.primary : Colors.grey.shade600,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: selected ? AppColors.primary : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? AppColors.primary : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}

