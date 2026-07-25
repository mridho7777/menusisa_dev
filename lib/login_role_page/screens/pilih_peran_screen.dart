import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '_parts/page_fade_route.dart';
import 'login_pembeli_screen.dart';
import 'login_penjual_screen.dart';
import 'login_admin_screen.dart';

class PilihPeranScreen extends StatelessWidget {
  const PilihPeranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 900;
              return Container(
                constraints: BoxConstraints(maxWidth: isDesktop ? 600 : double.infinity),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Button
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Pilih Peran Anda',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pilih peran yang sesuai untuk menggunakan MenuSisa.',
                      style: TextStyle(color: AppColors.textGrey, fontSize: 15),
                    ),
                    const SizedBox(height: 32),
                    Expanded(
                      child: ListView(
                        children: [
                          _RoleOptionCard(
                            title: 'Saya Pembeli',
                            description: 'Temukan makanan enak dengan harga hemat.',
                            icon: Icons.person_outline,
                            onTap: () {
                              Navigator.of(context).push(
                                PageFadeRoute(builder: (_) => const LoginPembeliScreen()),
                              );
                            },
                          ),
                          const SizedBox(height: 18),
                          _RoleOptionCard(
                            title: 'Saya Pemilik Toko',
                            description: 'Jual makanan berlebih dengan mudah dan jangkau lebih banyak pelanggan.',
                            icon: Icons.storefront_outlined,
                            onTap: () {
                              Navigator.of(context).push(
                                PageFadeRoute(builder: (_) => const LoginPenjualScreen()),
                              );
                            },
                          ),
                          const SizedBox(height: 18),
                          _RoleOptionCard(
                            title: 'Saya Administrator',
                            description: 'Kelola platform MenuSisa dan verifikasi merchant.',
                            icon: Icons.admin_panel_settings_outlined,
                            color: const Color(0xFF0F6B43),
                            onTap: () {
                              Navigator.of(context).push(
                                PageFadeRoute(builder: (_) => const LoginAdminScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _RoleOptionCard extends StatelessWidget {
  const _RoleOptionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
    this.color,
  });

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? AppColors.primary;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: cardColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cardColor.withOpacity(0.3), width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: cardColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36, color: cardColor),
            ),
          ],
        ),
      ),
    );
  }
}
