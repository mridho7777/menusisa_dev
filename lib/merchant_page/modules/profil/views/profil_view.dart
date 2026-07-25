import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/profil_controller.dart';
import '../widgets/profil_widget.dart';

class ProfilView extends StatelessWidget {
  const ProfilView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MerchantProfilController()..loadData(),
      child: Consumer<MerchantProfilController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F6B43)),
              ),
            );
          }

          return ProfilWidget(controller: controller, data: controller.data);
        },
      ),
    );
  }
}
