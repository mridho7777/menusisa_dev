// Supabase Integration Reference:
// - customer_id, merchant_id, product_id, order_id, favorite_id, cart_item_id
// - order_code, product_name, merchant_name, category_id, rating, distance_km
// - image_url for product_images, proof_image_url for payment_proofs
// - Use this file as the UI binding layer only; data should come from Supabase tables and joins.
import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF1E6F3B);
  static const primaryDark = Color(0xFF14532D);
  static const primaryLight = Color(0xFFE8F5E9);
  static const accent = Color(0xFFFFA000);
  static const background = Color(0xFFF7F8FA);
  static const surface = Colors.white;
  static const border = Color(0xFFE5E7EB);
  static const text = Color(0xFF111827);
  static const textDark = text;
  static const textGrey = Color(0xFF6B7280);
  static const textLight = Colors.white;
  static const muted = textGrey;
  static const danger = Color(0xFFEF4444);
  static const error = danger;
  static const success = Color(0xFF16A34A);
  static const warning = Color(0xFFF59E0B);
}

