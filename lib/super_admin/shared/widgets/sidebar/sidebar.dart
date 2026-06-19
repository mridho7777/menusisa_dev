import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = context.watch<MenuProvider>().currentRoute;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0F9A52), Color(0xFF0A6E39)],
        ),
      ),
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logonotext.png',
                  width: 65,
                  height: 65,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 0),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          height: 1.0,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Menu',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111111),
                            ),
                          ),
                          TextSpan(
                            text: 'Sisa',
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.w700,
                              foreground: Paint()
                                ..shader = const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFF046342),
                                    Color(0xFF3B943B),
                                    Color(0xFF97CC39),
                                  ],
                                ).createShader(const Rect.fromLTWH(0, 0, 200, 25)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 0),
                    const Text(
                      'Super Admin Dashboard',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        color: Color(0xFF1F2937),
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _SidebarMenu(label: 'Dashboard', icon: Icons.home, active: currentRoute == AppRoutes.dashboard, onTap: () => _go(context, AppRoutes.dashboard)),
                _SidebarMenu(label: 'Customer Management', icon: Icons.person_outline, active: currentRoute == AppRoutes.customers, onTap: () => _go(context, AppRoutes.customers)),
                _SidebarMenu(label: 'Merchant Management', icon: Icons.storefront_outlined, active: currentRoute == AppRoutes.merchants, onTap: () => _go(context, AppRoutes.merchants)),
                _SidebarMenu(label: 'Product Approval', icon: Icons.verified_outlined, active: currentRoute == AppRoutes.productApproval, onTap: () => _go(context, AppRoutes.productApproval)),
                _SidebarMenu(label: 'Product Management', icon: Icons.inventory_2_outlined, active: currentRoute == AppRoutes.productManagement, onTap: () => _go(context, AppRoutes.productManagement)),
                _SidebarMenu(label: 'Transaction Management', icon: Icons.receipt_long_outlined, active: currentRoute == AppRoutes.transactions, onTap: () => _go(context, AppRoutes.transactions)),
                _SidebarMenu(label: 'Payment Monitoring', icon: Icons.credit_card_outlined, active: currentRoute == AppRoutes.paymentMonitoring, onTap: () => _go(context, AppRoutes.paymentMonitoring)),
                _SidebarMenu(label: 'Platform Commission', icon: Icons.percent_outlined, active: currentRoute == AppRoutes.platformCommission, onTap: () => _go(context, AppRoutes.platformCommission)),
                _SidebarMenu(label: 'Platform Revenue', icon: Icons.show_chart_outlined, active: currentRoute == AppRoutes.platformRevenue, onTap: () => _go(context, AppRoutes.platformRevenue)),
                _SidebarMenu(label: 'Merchant Revenue', icon: Icons.groups_outlined, active: currentRoute == AppRoutes.merchantRevenue, onTap: () => _go(context, AppRoutes.merchantRevenue)),
                _SidebarMenu(label: 'Notifications', icon: Icons.notifications_outlined, active: currentRoute == AppRoutes.notifications, onTap: () => _go(context, AppRoutes.notifications)),
                _SidebarMenu(label: 'System Settings', icon: Icons.settings_outlined, active: currentRoute == AppRoutes.systemSettings, onTap: () => _go(context, AppRoutes.systemSettings)),
                _SidebarMenu(label: 'Activity Log', icon: Icons.article_outlined, active: currentRoute == AppRoutes.activityLog, onTap: () => _go(context, AppRoutes.activityLog)),
                _SidebarMenu(label: 'Profile & Logout', icon: Icons.person_outline, active: currentRoute == AppRoutes.profile, onTap: () => _go(context, AppRoutes.profile)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Butuh Bantuan?', style: TextStyle(fontFamily: 'Quicksand', color: Colors.white, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  const Text('Jika ada kendala, hubungi tim support kami.', style: TextStyle(fontFamily: 'Quicksand', color: Colors.white, fontSize: 12, height: 1.5)),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFBBF24),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Hubungi Support', style: TextStyle(fontFamily: 'Quicksand')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _go(BuildContext context, String route) {
    context.read<MenuProvider>().setRoute(route);
    context.go(route);
  }
}

class _SidebarMenu extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _SidebarMenu({required this.label, required this.icon, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: active ? const Color(0xFFB8E986) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(icon, color: active ? const Color(0xFF0B6F3B) : Colors.white, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(fontFamily: 'Quicksand', color: active ? const Color(0xFF0B6F3B) : Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
