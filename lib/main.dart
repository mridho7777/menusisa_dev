import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'super_admin/core/routes/app_router.dart';
import 'super_admin/core/services/local_storage_service.dart';
import 'super_admin/modules/dashboard/controllers/dashboard_controller.dart';
import 'super_admin/providers/activity_log_provider.dart';
import 'super_admin/providers/admin_action_notifier.dart';
import 'super_admin/providers/customer_provider.dart';
import 'super_admin/providers/dummy_admin_store.dart';
import 'super_admin/providers/menu_provider.dart';
import 'super_admin/providers/merchant_provider.dart';
import 'super_admin/providers/notifications_provider.dart';
import 'super_admin/providers/payment_provider.dart';
import 'super_admin/providers/product_provider.dart';
import 'super_admin/providers/revenue_provider.dart';
import 'super_admin/providers/system_settings_provider.dart';
import 'super_admin/providers/theme_provider.dart';
import 'super_admin/providers/transaction_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Local Storage
  await LocalStorageService.instance.init();
  
  runApp(const MenuSisaApp());
}

class MenuSisaApp extends StatelessWidget {
  const MenuSisaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Core Providers
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AdminActionNotifier()),
        
        // Dashboard
        ChangeNotifierProvider(create: (_) => DashboardController()),
        
        // Management Providers
        ChangeNotifierProvider(create: (_) => MerchantProvider()),
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => RevenueProvider()),
        
        // System Providers
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
        ChangeNotifierProvider(create: (_) => ActivityLogProvider()),
        ChangeNotifierProvider(create: (_) => SystemSettingsProvider()),
        
        // Legacy Dummy Store (for backward compatibility)
        ChangeNotifierProvider(
          create: (_) => InMemoryRecordStore<DummyRepoItem>(
            seedItems: const [
              DummyRepoItem(id: '1', title: 'Merchant A', subtitle: 'Aktif • Jakarta'),
              DummyRepoItem(id: '2', title: 'Merchant B', subtitle: 'Pending • Bandung'),
              DummyRepoItem(id: '3', title: 'Merchant C', subtitle: 'Active • Surabaya'),
            ],
          ),
        ),
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
