import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'super_admin/core/routes/app_router.dart';
import 'super_admin/modules/dashboard/controllers/dashboard_controller.dart';
import 'super_admin/providers/menu_provider.dart';
import 'super_admin/providers/theme_provider.dart';

void main() {
  runApp(const MenuSisaApp());
}

class MenuSisaApp extends StatelessWidget {
  const MenuSisaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => DashboardController()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'MenuSisa Super Admin',
            theme: themeProvider.lightTheme,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}