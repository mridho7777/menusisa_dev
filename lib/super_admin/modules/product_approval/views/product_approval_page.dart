import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';

class ProductApprovalPage extends StatefulWidget {
  const ProductApprovalPage({super.key});

  @override
  State<ProductApprovalPage> createState() => _ProductApprovalPageState();
}

class _ProductApprovalPageState extends State<ProductApprovalPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<MenuProvider>().setRoute(AppRoutes.productApproval);
  }

  @override
  Widget build(BuildContext context) => const Center(child: Text('Product Approval Page'));
}
