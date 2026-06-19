import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/menu_provider.dart';
import 'current_time_widget.dart';
import 'notification_button.dart';
import 'profile_dropdown.dart';

class MainHeader extends StatelessWidget {
  final bool sidebarOpen;
  final bool forcedCompact;

  const MainHeader({super.key, required this.sidebarOpen, required this.forcedCompact});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => context.read<MenuProvider>().toggleSidebar(),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.menu, color: forcedCompact ? const Color(0xFF9CA3AF) : const Color(0xFF1F2937), size: 22),
            ),
          ),
          const Spacer(),
          const CurrentTimeWidget(),
          const SizedBox(width: 18),
          const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFE5E7EB)),
          const SizedBox(width: 14),
          const NotificationButton(),
          const SizedBox(width: 14),
          const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFE5E7EB)),
          const SizedBox(width: 14),
          const ProfileDropdown(),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
