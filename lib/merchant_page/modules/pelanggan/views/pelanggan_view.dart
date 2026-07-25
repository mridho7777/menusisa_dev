import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/pelanggan_controller.dart';
import '../widgets/pelanggan_widget.dart';

class PelangganView extends StatelessWidget {
  const PelangganView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MerchantPelangganController()..loadData(),
      child: Consumer<MerchantPelangganController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F6B43)),
              ),
            );
          }
          final data = controller.showCustomerList ? null : null;
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pelanggan',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 24),
                PelangganWidget(controller: controller, data: data),
              ],
            ),
          );
        },
      ),
    );
  }
}
