import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';

class TransactionManagementPage extends StatefulWidget {
  const TransactionManagementPage({super.key});

  @override
  State<TransactionManagementPage> createState() => _TransactionManagementPageState();
}

class _TransactionManagementPageState extends State<TransactionManagementPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<MenuProvider>().setRoute(AppRoutes.transactions);
  }

  @override
  Widget build(BuildContext context) => const Center(child: Text('Transaction Management Page'));
}
