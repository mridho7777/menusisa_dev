// Supabase Integration Reference:
// - customer_id, merchant_id, product_id, order_id, favorite_id, cart_item_id
// - order_code, product_name, merchant_name, category_id, rating, distance_km
// - image_url for product_images, proof_image_url for payment_proofs
// - Use this file as the UI binding layer only; data should come from Supabase tables and joins.
import 'package:flutter/material.dart';

class OrderLine {
  const OrderLine({
    required this.title,
    required this.store,
    required this.price,
    required this.quantity,
    required this.imageLabel,
    this.isSelected = false,
  });

  final String title;
  final String store;
  final int price;
  final int quantity;
  final String imageLabel;
  final bool isSelected;

  int get subtotal => price * quantity;
}

class PaymentMethodData {
  const PaymentMethodData({
    required this.key,
    required this.title,
    required this.accentColor,
    required this.buttonColor,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.instructions,
    required this.primaryAction,
    required this.infoNote,
    this.accountName,
    this.accountNumber,
    this.bankName,
    this.qrLabel,
  });

  final String key;
  final String title;
  final String heroTitle;
  final String heroSubtitle;
  final String primaryAction;
  final String infoNote;
  final String? accountName;
  final String? accountNumber;
  final String? bankName;
  final String? qrLabel;
  final Color accentColor;
  final Color buttonColor;
  final List<String> instructions;
}

enum OrderTabStatus { cart, processing, created, readyPickup, completed, cancelled }

extension OrderTabStatusX on OrderTabStatus {
  String get label => switch (this) {
        OrderTabStatus.cart => 'Keranjang',
        OrderTabStatus.processing => 'Di Proses',
        OrderTabStatus.created => 'Dibuat',
        OrderTabStatus.readyPickup => 'Siap Diambil',
        OrderTabStatus.completed => 'Selesai',
        OrderTabStatus.cancelled => 'Dibatalkan',
      };

  Color get color => switch (this) {
        OrderTabStatus.cart => const Color(0xFF1E6F3B),
        OrderTabStatus.processing => const Color(0xFFF59E0B),
        OrderTabStatus.created => const Color(0xFF2563EB),
        OrderTabStatus.readyPickup => const Color(0xFF7C3AED),
        OrderTabStatus.completed => const Color(0xFF16A34A),
        OrderTabStatus.cancelled => const Color(0xFFEF4444),
      };
}

class OrderHistoryCardData {
  const OrderHistoryCardData({
    required this.code,
    required this.title,
    required this.store,
    required this.timeLabel,
    required this.statusLabel,
    required this.statusColor,
    required this.lines,
    required this.total,
    required this.badgeText,
    required this.badgeColor,
    required this.footerNote,
    required this.primaryButton,
    required this.secondaryButton,
  });

  final String code;
  final String title;
  final String store;
  final String timeLabel;
  final String statusLabel;
  final Color statusColor;
  final List<OrderLine> lines;
  final int total;
  final String badgeText;
  final Color badgeColor;
  final String footerNote;
  final String primaryButton;
  final String secondaryButton;
}

class CartSummaryData {
  const CartSummaryData({
    required this.note,
    required this.items,
    required this.total,
  });

  final String note;
  final List<OrderLine> items;
  final int total;
}
