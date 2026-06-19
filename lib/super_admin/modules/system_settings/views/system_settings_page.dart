import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';

class SystemSettingsPage extends StatefulWidget {
  const SystemSettingsPage({super.key});

  @override
  State<SystemSettingsPage> createState() => _SystemSettingsPageState();
}

class _SystemSettingsPageState extends State<SystemSettingsPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<MenuProvider>().setRoute(AppRoutes.systemSettings);
  }

  @override
  Widget build(BuildContext context) => const Center(child: Text('System Settings Page'));
}
