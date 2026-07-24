import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/pengaturan_controller.dart';
import '../widgets/pengaturan_widget.dart';

class PengaturanView extends StatelessWidget {
  const PengaturanView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MerchantPengaturanController()..loadData(),
      child: Consumer<MerchantPengaturanController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F6B43)),
              ),
            );
          }
          final data = controller.data;
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pengaturan',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 24),
                PengaturanWidget(controller: controller, data: data),
              ],
            ),
          );
        },
      ),
    );
  }
}
