// Supabase Integration Reference:
// - customer_id, merchant_id, product_id, order_id, favorite_id, cart_item_id
// - order_code, product_name, merchant_name, category_id, rating, distance_km
// - image_url for product_images, proof_image_url for payment_proofs
// - Use this file as the UI binding layer only; data should come from Supabase tables and joins.
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class AuthSidebarArt extends StatelessWidget {
  const AuthSidebarArt({super.key, required this.asset, required this.title});
  final String asset;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E6F3B), Color(0xFF0F4D27)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 24,
            top: 24,
            child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800)),
          ),
          Positioned(
            left: 24,
            top: 70,
            child: const Text('Enak, Hemat, Selamatkan Bumi', style: TextStyle(color: Colors.white70)),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Image.asset(asset, fit: BoxFit.contain, errorBuilder: (ctx, err, stack) => const Icon(Icons.eco, color: Colors.white, size: 140)),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthField extends StatelessWidget {
  const AuthField({super.key, required this.label, required this.hint, this.obscure = false});
  final String label;
  final String hint;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        TextField(
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
          ),
        ),
      ],
    );
  }
}

class PrimaryAuthButton extends StatelessWidget {
  const PrimaryAuthButton({super.key, required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
        child: Text(label),
      ),
    );
  }
}

