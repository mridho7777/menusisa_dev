import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../providers/menu_provider.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkResponse(
        onTap: () {
          context.read<MenuProvider>().setRoute(AppRoutes.notifications);
          context.go(AppRoutes.notifications);
        },
        radius: 22,
        child: const SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            Icons.notifications_none,
            color: Color(0xFF111827),
            size: 24,
          ),
        ),
      ),
    );
  }
}
