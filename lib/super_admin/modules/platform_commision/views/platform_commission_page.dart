import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';

class PlatformCommissionPage extends StatefulWidget {
  const PlatformCommissionPage({super.key});

  @override
  State<PlatformCommissionPage> createState() => _PlatformCommissionPageState();
}

class _PlatformCommissionPageState extends State<PlatformCommissionPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<MenuProvider>().setRoute(AppRoutes.platformCommission);
  }

  @override
  Widget build(BuildContext context) => const Center(child: Text('Platform Commission Page'));
}
