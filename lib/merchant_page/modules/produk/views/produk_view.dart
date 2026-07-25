import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/produk_controller.dart';
import '../widgets/produk_widget.dart';
import '../moduler/product_list_page.dart';

class ProdukView extends StatelessWidget {
  const ProdukView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MerchantProdukController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F6B43))));
        }
        if (controller.showListView) {
          return const ProductListPage();
        }
        final data = controller.data;
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Produk', style: const TextStyle(fontFamily: 'Quicksand', fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const SizedBox(height: 24),
            ProdukWidget(data: data),
          ]),
        );
      },
    );
  }
}
