import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';

class MerchantManagementPage extends StatefulWidget {
  const MerchantManagementPage({super.key});

  @override
  State<MerchantManagementPage> createState() => _MerchantManagementPageState();
}

class _MerchantManagementPageState extends State<MerchantManagementPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<MenuProvider>().setRoute(AppRoutes.merchants);
  }

  @override
  Widget build(BuildContext context) => const Center(child: Text('Merchant Management Page'));
}
