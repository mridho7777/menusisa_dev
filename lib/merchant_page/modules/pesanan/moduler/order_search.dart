import 'package:flutter/material.dart';
import 'order_controller.dart';

class OrderSearch extends StatelessWidget {
  final OrderController controller;

  const OrderSearch({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: controller.setSearchQuery,
      decoration: InputDecoration(
        hintText: 'Cari pesanan...',
        hintStyle: const TextStyle(fontFamily: 'Quicksand', color: Color(0xFF94A3B8)),
        prefixIcon: const Icon(Icons.search, size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
    );
  }
}
