import 'package:flutter/material.dart';
import 'order_controller.dart';

class OrderFilter extends StatelessWidget {
  final OrderController controller;

  const OrderFilter({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: controller.selectedFilter,
              items: const [
                DropdownMenuItem(value: 'Semua', child: Text('Filter')),
                DropdownMenuItem(value: 'Baru', child: Text('Baru')),
                DropdownMenuItem(value: 'Diproses', child: Text('Diproses')),
                DropdownMenuItem(value: 'Siap Diambil', child: Text('Siap Diambil')),
                DropdownMenuItem(value: 'Selesai', child: Text('Selesai')),
                DropdownMenuItem(value: 'Dibatalkan', child: Text('Dibatalkan')),
              ],
              onChanged: (value) {
                if (value != null) controller.setFilter(value);
              },
              borderRadius: BorderRadius.circular(8),
              icon: const Icon(Icons.filter_list, color: Color(0xFF64748B), size: 18),
              dropdownColor: Colors.white,
              style: const TextStyle(fontFamily: 'Quicksand', color: Color(0xFF1E293B), fontSize: 14),
            ),
          ),
        );
      },
    );
  }
}
