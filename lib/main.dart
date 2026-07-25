import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Config Supabase
import 'super_admin/core/config/supabase_config.dart';

// State Management
import 'customer_page/app_state.dart' as customer_state;

// Core Utils
import 'core/utils/restart_widget.dart';

// Entry Points
import 'login_role_page/screens/splash_screen.dart' as login_splash;

// Merchant Page
import 'merchant_page/providers/merchant_nav_provider.dart';
import 'merchant_page/providers/merchant_workspace_provider.dart';
import 'merchant_page/modules/produk/controllers/produk_controller.dart';
import 'merchant_page/modules/notifikasi/controllers/notifikasi_controller.dart';

// Super Admin Providers
import 'super_admin/providers/customer_provider.dart';
import 'super_admin/providers/menu_provider.dart';
import 'super_admin/providers/notifications_provider.dart';
import 'super_admin/providers/merchant_provider.dart';
import 'super_admin/modules/dashboard/controllers/dashboard_controller.dart';
import 'super_admin/providers/activity_log_provider.dart';
import 'super_admin/providers/payment_provider.dart';
import 'super_admin/providers/transaction_provider.dart';
import 'super_admin/providers/product_provider.dart';
import 'super_admin/core/services/data_sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase
  try {
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
    );
    debugPrint('✅ Supabase initialized successfully');
    DataSyncService.instance.setSupabaseMode(true);
  } catch (e) {
    debugPrint('❌ Supabase Initialize Error: $e');
  }

  runApp(
    RestartWidget(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => customer_state.AppState()),
          ChangeNotifierProvider(create: (_) => MerchantNavProvider()),
          ChangeNotifierProvider(create: (_) => MerchantWorkspaceProvider()..loadData()),
          ChangeNotifierProvider(create: (_) => MerchantProdukController()),
          ChangeNotifierProvider(create: (_) => MerchantNotifikasiController()),
          ChangeNotifierProvider(create: (_) => MenuProvider()),
          ChangeNotifierProvider(create: (_) => NotificationsProvider()),
          ChangeNotifierProvider(create: (_) => MerchantProvider()),
          ChangeNotifierProvider(create: (_) => DashboardController()),
          ChangeNotifierProvider(create: (_) => CustomerProvider()),
          ChangeNotifierProvider(create: (_) => ActivityLogProvider()),
          ChangeNotifierProvider(create: (_) => PaymentProvider()),
          ChangeNotifierProvider(create: (_) => TransactionProvider()),
          ChangeNotifierProvider(create: (_) => ProductProvider()),
        ],
        child: const MenuSisaApp(),
      ),
    ),
  );
}

class MenuSisaApp extends StatelessWidget {
  const MenuSisaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MenuSisa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF16A34A)),
        useMaterial3: true,
      ),
      home: const login_splash.SplashScreen(),
    );
  }
}

