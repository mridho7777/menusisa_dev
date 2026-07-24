import 'package:flutter/material.dart';

import '../shared/layouts/admin_layout.dart';
import '../core/services/data_sync_service.dart';

class AdminShell extends StatefulWidget {
  final Widget child;

  const AdminShell({super.key, required this.child});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  @override
  void initState() {
    super.initState();
    // Aktifkan mode Supabase untuk Super Admin
    DataSyncService.instance.setSupabaseMode(true);
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(child: widget.child);
  }
}
