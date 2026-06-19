import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';

class ProductManagementPage extends StatefulWidget {
  const ProductManagementPage({super.key});

  @override
  State<ProductManagementPage> createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends State<ProductManagementPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<MenuProvider>().setRoute(AppRoutes.productManagement);
  }

  @override
  Widget build(BuildContext context) => const Center(child: Text('Product Management Page'));
}
