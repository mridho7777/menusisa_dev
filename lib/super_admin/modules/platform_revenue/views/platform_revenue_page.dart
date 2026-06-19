import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';

class PlatformRevenuePage extends StatefulWidget {
  const PlatformRevenuePage({super.key});

  @override
  State<PlatformRevenuePage> createState() => _PlatformRevenuePageState();
}

class _PlatformRevenuePageState extends State<PlatformRevenuePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<MenuProvider>().setRoute(AppRoutes.platformRevenue);
  }

  @override
  Widget build(BuildContext context) => const Center(child: Text('Platform Revenue Page'));
}
