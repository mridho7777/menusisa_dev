import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/dashboard_controller.dart';
import '../widgets/dashboard_widget.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MerchantDashboardController()..loadData(),
      child: Consumer<MerchantDashboardController>(
        builder: (context, dashController, child) {
          if (dashController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F6B43)),
              ),
            );
          }

          if (dashController.data == null) {
            return const Center(
              child: Text('Tidak ada data'),
            );
          }

          return DashboardWidget(data: dashController.data!);
        },
      ),
    );
  }
}
