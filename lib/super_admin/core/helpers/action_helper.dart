import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/activity_log_provider.dart';
import '../../providers/admin_action_notifier.dart';

/// Helper untuk mengelola aksi CRUD dengan logging otomatis
class ActionHelper {
  /// Eksekusi aksi dengan feedback dan logging
  static Future<bool> executeAction({
    required BuildContext context,
    required Future<void> Function() action,
    required String actionName,
    required String entityType,
    String? entityId,
    String? successMessage,
    String? errorMessage,
  }) async {
    final adminActionNotifier = context.read<AdminActionNotifier>();
    final activityLogProvider = context.read<ActivityLogProvider>();
    
    try {
      // Show loading
      // Start action
      
      // Execute action
      await action();
      
      // Log activity
      await activityLogProvider.logAction(
        'admin_001', // TODO: Get from auth
        'Super Admin', // TODO: Get from auth
        actionName,
        '$actionName on $entityType${entityId != null ? ' (ID: $entityId)' : ''}',
      );
      
      // Show success feedback
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
      // Show error feedback
      adminActionNotifier.push(
        AdminActionMessage(
          title: '$actionName',
          subtitle: errorMessage ?? 'Gagal: ${e.toString()}',
          color: const Color(0xFFEF4444),
          icon: Icons.error_outline,
        ),
      );
      return false;
    } finally {
      // End action
    }
  }

  /// Show confirmation dialog
  static Future<bool> confirmAction({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Ya',
    String cancelText = 'Batal',
    bool isDangerous = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: isDangerous
                ? ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  )
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Show input dialog
  static Future<String?> showInputDialog({
    required BuildContext context,
    required String title,
    required String label,
    String? initialValue,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) async {
    final controller = TextEditingController(text: initialValue);
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
          maxLines: maxLines,
          keyboardType: keyboardType,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    
    controller.dispose();
    return result;
  }
}
