import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/menu_provider.dart';
import '../widgets/header/main_header.dart';
import '../widgets/sidebar/sidebar.dart';

class AdminLayout extends StatelessWidget {
  final Widget child;

  const AdminLayout({super.key, required this.child});

  static const double _sidebarWidth = 235;
  static const double _headerHeight = 60;
  static const Duration _animationDuration = Duration(milliseconds: 220);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final forcedCompact = constraints.maxWidth < 1100;
          final provider = context.watch<MenuProvider>();
          final sidebarOpen = forcedCompact ? false : !provider.sidebarCollapsed;

          if (forcedCompact && !provider.sidebarCollapsed) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                context.read<MenuProvider>().setSidebarCollapsed(true);
              }
            });
          }

          final contentLeft = sidebarOpen && !forcedCompact ? _sidebarWidth : 0.0;

          return Stack(
            children: [
              AnimatedPositioned(
                duration: _animationDuration,
                curve: Curves.easeInOutCubicEmphasized,
                left: sidebarOpen ? 0 : -_sidebarWidth,
                top: 0,
                bottom: 0,
                width: _sidebarWidth,
                child: Material(
                  elevation: 16,
                  shadowColor: const Color(0x33000000),
                  child: const Sidebar(),
                ),
              ),
              AnimatedPositioned(
                duration: _animationDuration,
                curve: Curves.easeInOutCubicEmphasized,
                left: contentLeft,
                top: 0,
                right: 0,
                bottom: 0,
                child: Column(
                  children: [
                    SizedBox(height: _headerHeight, child: MainHeader(sidebarOpen: sidebarOpen, forcedCompact: forcedCompact)),
                    Expanded(
                      child: Container(
                        color: const Color(0xFFF8FAF8),
                        child: Align(alignment: Alignment.topLeft, child: SizedBox(width: double.infinity, child: child)),
                      ),
                    ),
                    Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('? 2026 MenuSisa. All rights reserved.', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                          Text('Version 1.0.0', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (sidebarOpen && !forcedCompact)
                Positioned.fill(
                  left: _sidebarWidth,
                  child: IgnorePointer(
                    child: AnimatedOpacity(
                      opacity: 0.04,
                      duration: _animationDuration,
                      curve: Curves.easeOut,
                      child: Container(color: Colors.black),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
