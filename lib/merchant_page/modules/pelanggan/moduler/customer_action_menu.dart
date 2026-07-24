import 'package:flutter/material.dart';

class CustomerActionMenu extends StatelessWidget {
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CustomerActionMenu({super.key, required this.onView, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 18),
      padding: EdgeInsets.zero,
      onSelected: (value) {
        switch (value) {
          case 'view':
            onView();
            break;
          case 'edit':
            onEdit();
            break;
          case 'delete':
            onDelete();
            break;
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'view', child: Text('Lihat')),
        PopupMenuItem(value: 'edit', child: Text('Ubah')),
        PopupMenuItem(value: 'delete', child: Text('Hapus')),
      ],
    );
  }
}
