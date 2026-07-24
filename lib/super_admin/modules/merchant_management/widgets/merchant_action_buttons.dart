import 'package:menusisa_dev/super_admin/shared/widgets/admin_toast.dart';
import 'package:flutter/material.dart';

class MerchantActionButton extends StatelessWidget {
  const MerchantActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.color,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? const Color(0xFF0F8D55),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MerchantActionsBar extends StatelessWidget {
  const MerchantActionsBar({
    super.key,
    required this.onAddMerchant,
    required this.onVerify,
    required this.onSuspend,
    required this.onDeactivate,
    required this.onExport,
    required this.onRefresh,
  });

  final VoidCallback onAddMerchant;
  final VoidCallback onVerify;
  final VoidCallback onSuspend;
  final VoidCallback onDeactivate;
  final VoidCallback onExport;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          MerchantActionButton(
            label: 'Tambah Merchant',
            icon: Icons.add_rounded,
            onPressed: onAddMerchant,
            color: const Color(0xFF0F8D55),
          ),
          MerchantActionButton(
            label: 'Verifikasi',
            icon: Icons.verified_rounded,
            onPressed: onVerify,
            color: const Color(0xFF2563EB),
          ),
          MerchantActionButton(
            label: 'Suspend',
            icon: Icons.lock_rounded,
            onPressed: onSuspend,
            color: const Color(0xFF7C3AED),
          ),
          MerchantActionButton(
            label: 'Nonaktifkan',
            icon: Icons.power_settings_new_rounded,
            onPressed: onDeactivate,
            color: const Color(0xFFEF4444),
          ),
          MerchantActionButton(
            label: 'Export Data',
            icon: Icons.download_rounded,
            onPressed: onExport,
            color: const Color(0xFF059669),
          ),
          MerchantActionButton(
            label: 'Refresh',
            icon: Icons.refresh_rounded,
            onPressed: onRefresh,
            color: const Color(0xFF6B7280),
          ),
        ],
      ),
    );
  }
}

void showMerchantNotification(
  BuildContext context, {
  required String title,
  required String message,
  Color? backgroundColor,
  IconData? icon,
}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  AdminToast.show(context, 'Tindakan berhasil', type: AdminToastType.success);
}
