import 'package:flutter/material.dart';

class NotificationActionMenu extends StatelessWidget {
  final VoidCallback onMarkRead;
  final VoidCallback onDelete;

  const NotificationActionMenu({super.key, required this.onMarkRead, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 18),
      padding: EdgeInsets.zero,
      onSelected: (value) {
        if (value == 'read') onMarkRead();
        if (value == 'delete') onDelete();
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'read', child: Text('Tandai dibaca')),
        PopupMenuItem(value: 'delete', child: Text('Hapus')),
      ],
    );
  }
}
