import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/keuangan_controller.dart';
import '../widgets/keuangan_widget.dart';

class KeuanganView extends StatelessWidget {
  const KeuanganView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MerchantKeuanganController()..loadData(),
      child: Consumer<MerchantKeuanganController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F6B43)),
              ),
            );
          }

          if (controller.data == null) {
            return const Center(
              child: Text('Tidak ada data keuangan'),
            );
          }

          return KeuanganWidget(controller: controller, data: controller.data!);
        },
      ),
    );
  }
}
