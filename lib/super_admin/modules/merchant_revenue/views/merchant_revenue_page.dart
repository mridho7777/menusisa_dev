import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';

class MerchantRevenuePage extends StatefulWidget {
  const MerchantRevenuePage({super.key});

  @override
  State<MerchantRevenuePage> createState() => _MerchantRevenuePageState();
}

class _MerchantRevenuePageState extends State<MerchantRevenuePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<MenuProvider>().setRoute(AppRoutes.merchantRevenue);
  }

  @override
  Widget build(BuildContext context) => const Center(child: Text('Merchant Revenue Page'));
}
