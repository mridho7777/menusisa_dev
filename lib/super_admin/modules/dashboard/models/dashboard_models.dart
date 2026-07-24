// TODO: Supabase Database Schema Integration
// ==========================================
// Tables needed:
// 1. transactions: id, customer_id, merchant_id, total, method, status, created_at
// 2. merchants: id, name, status, created_at, total_products, total_sales
// 3. customers: id, name, email, phone, created_at, total_orders
// 4. products: id, merchant_id, name, price, stock, status, created_at
// 5. notifications: id, title, message, type, entity_type, is_read, created_at
//
// Real-time subscriptions:
// - Listen to transactions table for auto-update metrics
// - Listen to merchants table for merchant count changes
// - Listen to products table for pending approval count
//
// Queries for metrics:
// - Total Revenue: SELECT SUM(total) FROM transactions WHERE status = 'completed'
// - Total Transactions: SELECT COUNT(*) FROM transactions
// - Active Merchants: SELECT COUNT(*) FROM merchants WHERE status = 'active'
// - Active Customers: SELECT COUNT(*) FROM customers WHERE status = 'active'
// - Pending Approval: SELECT COUNT(*) FROM products WHERE status = 'pending'
// - Platform Fee: SELECT SUM(platform_fee) FROM transactions
// ==========================================
class DashboardMetric {
  final String title;
  final String value;
  final String delta;
  final String icon;
  final int color;

  const DashboardMetric({
    required this.title,
    required this.value,
    required this.delta,
    required this.icon,
    required this.color,
  });
}

class DashboardPendingItem {
  final String title;
  final String value;
  final String actionLabel;

  const DashboardPendingItem({
    required this.title,
    required this.value,
    required this.actionLabel,
  });
}

class DashboardTransaction {
  final String id;
  final String customer;
  final String merchant;
  final String total;
  final String method;
  final String status;
  final String time;

  const DashboardTransaction({
    required this.id,
    required this.customer,
    required this.merchant,
    required this.total,
    required this.method,
    required this.status,
    required this.time,
  });
}

class DashboardMerchant {
  final String rank;
  final String name;
  final String revenue;
  final String orders;
  final int color;

  const DashboardMerchant({
    required this.rank,
    required this.name,
    required this.revenue,
    required this.orders,
    required this.color,
  });
}

class DashboardActivity {
  final String icon;
  final String title;
  final String subtitle;
  final String time;
  final int color;

  const DashboardActivity({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
  });
}

class DashboardNotice {
  final String icon;
  final String title;
  final String subtitle;
  final String time;
  final int color;

  const DashboardNotice({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
  });
}

class DashboardQuickAction {
  final String label;
  final String icon;

  const DashboardQuickAction({required this.label, required this.icon});
}

class DashboardToastMessage {
  final String title;
  final String subtitle;
  final int color;

  const DashboardToastMessage({
    required this.title,
    required this.subtitle,
    required this.color,
  });
}

const dashboardMetrics = <DashboardMetric>[];

const dashboardPendingItems = <DashboardPendingItem>[];

const dashboardTransactions = <DashboardTransaction>[];

const dashboardMerchants = <DashboardMerchant>[];

const dashboardActivities = <DashboardActivity>[];

const dashboardNotices = <DashboardNotice>[];

const dashboardQuickActions = <DashboardQuickAction>[];

const dashboardToasts = <DashboardToastMessage>[];

