import 'package:flutter/material.dart';

import '../shared/layouts/admin_layout.dart';

class AdminShell extends StatelessWidget {
  final Widget child;

  const AdminShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(child: child);
  }
}
