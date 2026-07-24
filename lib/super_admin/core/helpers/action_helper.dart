import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/activity_log_provider.dart';
import '../../providers/admin_action_notifier.dart';

class ActionHelper {
  static Future<bool> execute(
    BuildContext context, {
    required Future<void> Function() action,
    required String actionName,
    required String entityType,
    String? entityId,
    String? successMessage,
    String? errorMessage,
  }) async {
    final activityLogProvider = context.read<ActivityLogProvider>();
    final adminActionNotifier = context.read<AdminActionNotifier>();

    try {
      await action();
      final description = entityId != null ? ' on  (ID: )' : ' on ';
      await activityLogProvider.logAction('admin_001', 'Super Admin', entityType, actionName, description);

      adminActionNotifier.push(
        AdminActionMessage(
          title: actionName,
          subtitle: successMessage ?? 'Berhasil',
          color: const Color(0xFF16A34A),
          icon: Icons.check_circle_outline,
        ),
      );
      return true;
    } catch (e) {
      adminActionNotifier.push(
        AdminActionMessage(
          title: 'Error',
          subtitle: errorMessage ?? 'Terjadi kesalahan: ',
          color: const Color(0xFFEF4444),
          icon: Icons.error_outline,
        ),
      );
      return false;
    }
  }
}
