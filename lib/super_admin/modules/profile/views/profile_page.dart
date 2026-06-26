import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';
import '../widgets/profile_logout_sections.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<MenuProvider>().setRoute(AppRoutes.profile);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = constraints.maxWidth < 900
            ? const EdgeInsets.fromLTRB(16, 18, 16, 18)
            : const EdgeInsets.fromLTRB(24, 18, 24, 20);

        return SingleChildScrollView(
          padding: padding,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProfileHeader(onBackToNotifications: () {
                    context.go(AppRoutes.notifications);
                  }),
                  const SizedBox(height: 14),
                  LayoutBuilder(
                    builder: (context, sectionConstraints) {
                      final compact = sectionConstraints.maxWidth < 1250;
                      if (compact) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: const [
                            ProfileInfoCard(),
                            SizedBox(height: 14),
                            SecurityPreferencesCard(),
                            SizedBox(height: 14),
                            RecentActivityCard(),
                            SizedBox(height: 14),
                            LogoutCard(),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Expanded(flex: 3, child: ProfileInfoCard()),
                              SizedBox(width: 14),
                              Expanded(flex: 4, child: SecurityPreferencesCard()),
                              SizedBox(width: 14),
                              Expanded(flex: 4, child: RecentActivityCard()),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 3, child: SizedBox()),
                              SizedBox(width: 14),
                              Expanded(flex: 4, child: SizedBox()),
                              SizedBox(width: 14),
                              Expanded(flex: 4, child: LogoutCard()),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.onBackToNotifications});

  final VoidCallback onBackToNotifications;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Profile & Logout', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Row(
          children: [
            TextButton(onPressed: () {}, child: const Text('Beranda')),
            const Text('›', style: TextStyle(color: Color(0xFF94A3B8))),
            const Text('Profile & Logout', style: TextStyle(color: Color(0xFF64748B))),
            const Spacer(),
            TextButton.icon(
              onPressed: onBackToNotifications,
              icon: const Icon(Icons.notifications_outlined, size: 18),
              label: const Text('Notifications'),
            ),
          ],
        ),
        const Text('Kelola informasi profil akun Anda dan lakukan logout dari sistem.', style: TextStyle(color: Color(0xFF64748B))),
      ],
    );
  }
}
