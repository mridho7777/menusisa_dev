// Supabase Integration Reference:
// - customer_id, merchant_id, product_id, order_id, favorite_id, cart_item_id
// - order_code, product_name, merchant_name, category_id, rating, distance_km
// - image_url for product_images, proof_image_url for payment_proofs
// - Use this file as the UI binding layer only; data should come from Supabase tables and joins.
import 'package:flutter/material.dart';

class CustomToast {
  static void showDynamic({
    required BuildContext context,
    required String title,
    required String message,
    required IconData icon,
    required Color iconColor,
  }) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.hideCurrentSnackBar();
    scaffold.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        backgroundColor: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
        content: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => scaffold.hideCurrentSnackBar(),
              child: const Icon(Icons.close, color: Colors.black45, size: 18),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void show({
    required BuildContext context,
    required String message,
    required IconData icon,
    Color backgroundColor = const Color(0xFF1B6A43),
    Color textColor = Colors.white,
  }) {
    final scaffold = ScaffoldMessenger.of(context);
    
    scaffold.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Row(
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => scaffold.hideCurrentSnackBar(),
              child: Icon(Icons.close, color: textColor.withAlpha(180), size: 18),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Helper untuk toast sukses (Warna Hijau - Gambar 2 & 3)
  static void showSuccess(BuildContext context, String message) {
    show(
      context: context,
      message: message,
      icon: Icons.check_circle_rounded,
      backgroundColor: const Color(0xFF1B6A43),
    );
  }

  // Helper untuk toast peringatan/stok habis (Warna Oranye - Gambar 2 & 3)
  static void showWarning(BuildContext context, String message) {
    show(
      context: context,
      message: message,
      icon: Icons.warning_rounded,
      backgroundColor: Colors.orange.shade800,
    );
  }

  // Helper untuk toast informasi (Warna Biru)
  static void showInfo(BuildContext context, String message) {
    show(
      context: context,
      message: message,
      icon: Icons.info_rounded,
      backgroundColor: Colors.blue.shade700,
    );
  }
}

