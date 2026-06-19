import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';

class PaymentMonitoringPage extends StatefulWidget {
  const PaymentMonitoringPage({super.key});

  @override
  State<PaymentMonitoringPage> createState() => _PaymentMonitoringPageState();
}

class _PaymentMonitoringPageState extends State<PaymentMonitoringPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<MenuProvider>().setRoute(AppRoutes.paymentMonitoring);
  }

  @override
  Widget build(BuildContext context) => const Center(child: Text('Payment Monitoring Page'));
}
