import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/dashboard_model.dart';

class DashboardService {
  final _client = Supabase.instance.client;

  Future<DashboardModel> fetchDashboardData() async {
    final user = _client.auth.currentUser;
    
    if (user == null) {
      return _emptyDashboard();
    }

    try {
      // Get merchant data
      final merchantData = await _client
          .from('merchants')
          .select('id')
          .eq('user_id', user.id)
          .maybeSingle();

      if (merchantData == null) {
        return _emptyDashboard();
      }

      final merchantId = merchantData['id'];

      // Get total products
      final productsData = await _client
          .from('products')
          .select('id')
          .eq('merchant_id', merchantId);
      
      final productsCount = productsData.length;

      // Get total orders
      final ordersData = await _client
          .from('orders')
          .select('id, total_amount, status')
          .eq('merchant_id', merchantId);

      final ordersCount = ordersData.length;

      // Get total customers (unique user_id from orders)
      final customersData = await _client
          .from('orders')
          .select('user_id')
          .eq('merchant_id', merchantId);

      final uniqueCustomers = customersData.map((e) => e['user_id']).toSet().length;

      // Calculate total revenue
      double totalRevenue = 0;
      for (var order in ordersData) {
        if (order['status'] == 'done') {
          totalRevenue += (order['total_amount'] ?? 0).toDouble();
        }
      }

      // Get recent orders (last 5)
      final recentOrders = await _client
          .from('orders')
          .select('order_code, status, total_amount, created_at')
          .eq('merchant_id', merchantId)
          .order('created_at', ascending: false)
          .limit(5);

      // Get sales trend for last 7 days
      final now = DateTime.now();
      final List<double> salesTrend = [];
      final List<String> days = [];

      for (int i = 6; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final startOfDay = DateTime(date.year, date.month, date.day);
        final endOfDay = startOfDay.add(const Duration(days: 1));

        final dayOrders = await _client
            .from('orders')
            .select('total_amount')
            .eq('merchant_id', merchantId)
            .eq('status', 'done')
            .gte('created_at', startOfDay.toIso8601String())
            .lt('created_at', endOfDay.toIso8601String());

        double dayRevenue = 0;
        for (var order in dayOrders) {
          dayRevenue += (order['total_amount'] ?? 0).toDouble();
        }

        salesTrend.add(dayRevenue);
        days.add('${date.day.toString().padLeft(2, '0')} ${_getMonthName(date.month)}');
      }

      return DashboardModel(
        title: 'Dashboard',
        subtitle: 'Kelola toko dan pantau penjualan dengan mudah.',
        metrics: [
          DashboardMetric(
            id: 'revenue',
            title: 'Total Penjualan',
            value: 'Rp${_formatNumber(totalRevenue.toInt())}',
            subtitle: totalRevenue > 0 ? 'Dari $ordersCount pesanan' : 'Belum ada penjualan',
            amount: totalRevenue,
          ),
          DashboardMetric(
            id: 'orders',
            title: 'Total Pesanan',
            value: '$ordersCount',
            subtitle: ordersCount == 0 ? 'Belum ada pesanan' : '$ordersCount pesanan total',
            amount: ordersCount.toDouble(),
          ),
          DashboardMetric(
            id: 'products',
            title: 'Total Produk',
            value: '$productsCount',
            subtitle: '$productsCount produk tersimpan',
            amount: productsCount.toDouble(),
          ),
          DashboardMetric(
            id: 'customers',
            title: 'Total Pelanggan',
            value: '$uniqueCustomers',
            subtitle: uniqueCustomers == 0 ? 'Belum ada pelanggan' : '$uniqueCustomers pelanggan unik',
            amount: uniqueCustomers.toDouble(),
          ),
        ],
        salesTrend: salesTrend,
        days: days,
        orders: [],
        products: [],
      );
    } catch (e) {
      return _emptyDashboard();
    }
  }

  DashboardModel _emptyDashboard() {
    return DashboardModel(
      title: 'Dashboard',
      subtitle: 'Kelola toko dan pantau penjualan dengan mudah.',
      metrics: [
        DashboardMetric(id: 'revenue', title: 'Total Penjualan', value: 'Rp0', subtitle: 'Belum ada penjualan', amount: 0),
        DashboardMetric(id: 'orders', title: 'Total Pesanan', value: '0', subtitle: 'Belum ada pesanan', amount: 0),
        DashboardMetric(id: 'products', title: 'Total Produk', value: '0', subtitle: '0 produk tersimpan', amount: 0),
        DashboardMetric(id: 'customers', title: 'Total Pelanggan', value: '0', subtitle: 'Belum ada pelanggan', amount: 0),
      ],
      salesTrend: [0, 0, 0, 0, 0, 0, 0],
      days: const ['01 Jul', '02 Jul', '03 Jul', '04 Jul', '05 Jul', '06 Jul', '07 Jul'],
      orders: [],
      products: [],
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return months[month - 1];
  }
}
