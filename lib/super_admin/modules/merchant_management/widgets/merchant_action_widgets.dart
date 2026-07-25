import 'package:flutter/material.dart';

class MerchantActionChip extends StatelessWidget {
  const MerchantActionChip({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        side: const BorderSide(color: Color(0xFFD1D5DB)),
        foregroundColor: const Color(0xFF111827),
        backgroundColor: Colors.white,
      ),
    );
  }
}
