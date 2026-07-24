import 'package:flutter/material.dart';
import 'admin_toast.dart';

void showBottomActionMessage(
  BuildContext context, {
  required String title,
  required String subtitle,
  Color color = const Color(0xFF16A34A),
  IconData icon = Icons.check_circle_outline,
}) {
  AdminToastType type = AdminToastType.info;
  
  if (color == const Color(0xFF16A34A) || color.toARGB32() == 0xFF16A34A || color.toARGB32() == 0xFF0F8D55) {
    type = AdminToastType.success;
  } else if (color == const Color(0xFFDC2626) || color.toARGB32() == 0xFFDC2626 || color.toARGB32() == 0xFFEF4444) {
    type = AdminToastType.error;
  } else if (color == const Color(0xFFF59E0B) || color.toARGB32() == 0xFFF59E0B) {
    type = AdminToastType.warning;
  }

  final msg = ' - ';

  AdminToast.show(context, msg, type: type);
}
