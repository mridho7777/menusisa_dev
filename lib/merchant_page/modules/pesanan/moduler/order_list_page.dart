import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'order_controller.dart';
import 'order_table.dart';
import 'order_search.dart';
import 'order_filter.dart';

class OrderListPage extends StatelessWidget {
  const OrderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrderController()..loadOrders(),
      child: const OrderListContent(),
    );
  }
}

class OrderListContent extends StatelessWidget {
  const OrderListContent({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<OrderController>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Pesanan',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color(0xFFE2E8F0),
            height: 1,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                _buildTabBar(context, controller),
                const Divider(color: Color(0xFFE2E8F0), height: 1),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(child: OrderSearch(controller: controller)),
                const SizedBox(width: 12),
                OrderFilter(controller: controller),
                const SizedBox(width: 12),
                _buildSortButton(context, controller),
              ],
            ),
          ),
          Expanded(
            child: controller.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F6B43)),
                    ),
                  )
                : OrderTable(controller: controller),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, OrderController controller) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: List.generate(controller.tabs.length, (index) {
          final isSelected = controller.selectedTabIndex == index;
          return GestureDetector(
            onTap: () => controller.setTabIndex(index),
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
                controller.tabs[index],
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
      ),
    );
  }

  Widget _buildSortButton(BuildContext context, OrderController controller) {
    return InkWell(
      onTap: controller.toggleSort,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Icon(
          Icons.sort,
          color: Color(0xFF64748B),
          size: 20,
        ),
      ),
    );
  }
}
