import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/pesanan_controller.dart';
import '../widgets/pesanan_widget.dart';

class PesananView extends StatelessWidget {
  const PesananView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MerchantPesananController()..loadData(),
      child: Consumer<MerchantPesananController>(
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
                Text(
                  'Pesanan',
                  style: const TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 24),
                PesananWidget(data: data),
              ],
            ),
          );
        },
      ),
    );
  }
}
