import 'package:flutter/material.dart';
import '../models/pesanan_model.dart';
import '../moduler/order_controller.dart';
import '../moduler/order_filter.dart';
import '../moduler/order_search.dart';
import '../moduler/order_table.dart';

class PesananWidget extends StatefulWidget {
  final PesananModel? data;

  const PesananWidget({super.key, this.data});

  @override
  State<PesananWidget> createState() => _PesananWidgetState();
}

class _PesananWidgetState extends State<PesananWidget> {
  final OrderController _controller = OrderController();
  bool _showOrderList = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    await _controller.loadOrders();
    if (mounted) {
      setState(() {
        _initialized = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: _showOrderList ? _buildOrderList(context) : _buildCard(context),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      key: const ValueKey('pesanan-card'),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F6B43).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIconForModule('pesanan'),
                  color: const Color(0xFF0F6B43),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data?.title ?? 'Pesanan',
                    style: const TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kelola modul pesanan Anda di sini',
                    style: const TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: Color(0xFFE2E8F0)),
          const SizedBox(height: 16),
          Text(
            widget.data?.description ?? 'Memuat informasi...',
            style: const TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 15,
              color: Color(0xFF334155),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _showOrderList = true;
              });
            },
            icon: const Icon(Icons.add, size: 18),
            label: Text(
              'Tambah Data Pesanan',
              style: const TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F6B43),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(BuildContext context) {
    return Container(
      key: const ValueKey('pesanan-list'),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F6B43).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  color: Color(0xFF0F6B43),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daftar Pesanan',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Kelola status, filter, pencarian, dan aksi pesanan',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _showOrderList = false;
                  });
                },
                icon: const Icon(Icons.arrow_back, size: 16),
                label: const Text('Kembali'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (!_initialized)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F6B43)),
                ),
              ),
            )
          else ...[
            _buildTabBar(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: OrderSearch(controller: _controller)),
                const SizedBox(width: 12),
                OrderFilter(controller: _controller),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 420,
              child: OrderTable(controller: _controller),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Row(
            children: List.generate(_controller.tabs.length, (index) {
              final isSelected = _controller.selectedTabIndex == index;
              return GestureDetector(
                onTap: () => _controller.setTabIndex(index),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF0F6B43) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF0F6B43) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Text(
                    _controller.tabs[index],
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : const Color(0xFF64748B),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  IconData _getIconForModule(String module) {
    switch (module) {
      case 'dashboard':
        return Icons.home_outlined;
      case 'produk':
        return Icons.inventory_2_outlined;
      case 'pesanan':
        return Icons.receipt_long_outlined;
      case 'pelanggan':
        return Icons.people_outline;
      case 'keuangan':
        return Icons.account_balance_wallet_outlined;
      case 'notifikasi':
        return Icons.notifications_outlined;
      case 'pengaturan':
        return Icons.settings_outlined;
      case 'profil':
        return Icons.person_outline;
      default:
        return Icons.help_outline;
    }
  }
}
