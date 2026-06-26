import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../modules/activity_logs/views/activity_log_page.dart';
import '../../modules/customer_management/views/customer_management_page.dart';
import '../../modules/dashboard/views/dashboard_page.dart';
import '../../modules/merchant_management/views/merchant_management_page.dart';
import '../../modules/merchant_revenue/views/merchant_revenue_page.dart';
import '../../modules/notifications/views/notifications_page.dart';
import '../../modules/payment_monitoring/views/payment_monitoring_page.dart';
import '../../modules/platform_commision/views/platform_commission_page.dart';
import '../../modules/platform_revenue/views/platform_revenue_page.dart';
import '../../modules/product_approval/views/product_approval_page.dart';
import '../../modules/product_management/views/product_management_page.dart';
import '../../modules/profile/views/profile_page.dart';
import '../../modules/system_settings/views/system_settings_page.dart';
import '../../modules/transaction_management/views/transaction_management_page.dart';
import '../../shell/admin_shell.dart';
import 'app_routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.dashboard,
    routes: [
      ShellRoute(
        builder: (context, state, child) => AdminShell(child: child),
        routes: [
          GoRoute(path: AppRoutes.dashboard, builder: (_, _) => const DashboardPage()),
          GoRoute(path: AppRoutes.customers, builder: (_, _) => const CustomerManagementPage()),
          GoRoute(path: AppRoutes.merchants, builder: (_, _) => const MerchantManagementPage()),
          GoRoute(path: AppRoutes.productApproval, builder: (_, _) => const ProductApprovalPage()),
          GoRoute(path: AppRoutes.productManagement, builder: (_, _) => const ProductManagementPage()),
          GoRoute(path: AppRoutes.transactions, builder: (_, _) => const TransactionManagementPage()),
          GoRoute(path: AppRoutes.paymentMonitoring, builder: (_, _) => const PaymentMonitoringPage()),
          GoRoute(path: AppRoutes.platformCommission, builder: (_, _) => const PlatformCommissionPage()),
          GoRoute(path: AppRoutes.platformRevenue, builder: (_, _) => const PlatformRevenuePage()),
          GoRoute(path: AppRoutes.merchantRevenue, builder: (_, _) => const MerchantRevenuePage()),
          GoRoute(path: AppRoutes.notifications, builder: (_, _) => const NotificationsPage()),
          GoRoute(path: AppRoutes.systemSettings, builder: (_, _) => const SystemSettingsPage()),
          GoRoute(path: AppRoutes.activityLog, builder: (_, _) => const ActivityLogPage()),
          GoRoute(path: AppRoutes.profile, builder: (_, _) => const ProfilePage()),
        ],
      ),
    ],
    errorBuilder: (_, _) => const Scaffold(body: Center(child: Text('Page not found'))),
  );
}
