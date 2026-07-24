import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/keuangan_model.dart';

class KeuanganService {
  final _client = Supabase.instance.client;

  Future<KeuanganModel> fetchKeuanganData() async {
    final user = _client.auth.currentUser;
    
    if (user == null) {
      return _emptyKeuangan();
    }

    try {
      // Get merchant ID
      final merchantData = await _client
          .from('merchants')
          .select('id')
          .eq('user_id', user.id)
          .maybeSingle();

      if (merchantData == null) {
        return _emptyKeuangan();
      }

      final merchantId = merchantData['id'];

      // Get all completed orders for this merchant
      final orders = await _client
          .from('orders')
          .select('total_amount, commission_amount, platform_fee, created_at, order_code')
          .eq('merchant_id', merchantId)
          .eq('payment_status', 'paid');

      // Calculate totals
      double totalRevenue = 0;
      double totalCommission = 0;
      double totalPlatformFee = 0;

      for (var order in orders) {
        totalRevenue += (order['total_amount'] ?? 0).toDouble();
        totalCommission += (order['commission_amount'] ?? 0).toDouble();
        totalPlatformFee += (order['platform_fee'] ?? 0).toDouble();
      }

      // Net income = total revenue - commission - platform fee
      double netIncome = totalRevenue - totalCommission - totalPlatformFee;

      // Get weekly income (last 7 days)
      final now = DateTime.now();
      final List<double> weeklyIncome = [];
      final List<String> days = [];

      for (int i = 6; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final startOfDay = DateTime(date.year, date.month, date.day);
        final endOfDay = startOfDay.add(const Duration(days: 1));

        final dayOrders = await _client
            .from('orders')
            .select('total_amount, commission_amount, platform_fee')
            .eq('merchant_id', merchantId)
            .eq('payment_status', 'paid')
            .gte('created_at', startOfDay.toIso8601String())
            .lt('created_at', endOfDay.toIso8601String());

        double dayIncome = 0;
        for (var order in dayOrders) {
          double orderTotal = (order['total_amount'] ?? 0).toDouble();
          double orderCommission = (order['commission_amount'] ?? 0).toDouble();
          double orderFee = (order['platform_fee'] ?? 0).toDouble();
          dayIncome += (orderTotal - orderCommission - orderFee);
        }

        weeklyIncome.add(dayIncome);
        days.add('${date.day.toString().padLeft(2, '0')} ${_monthName(date.month)}');
      }

      // Get recent transactions (last 10)
      final recentOrders = await _client
          .from('orders')
          .select('order_code, total_amount, commission_amount, platform_fee, created_at, payment_status')
          .eq('merchant_id', merchantId)
          .order('created_at', ascending: false)
          .limit(10);

      List<KeuanganRecord> transactions = recentOrders.map((order) {
        double amount = (order['total_amount'] ?? 0).toDouble();
        double commission = (order['commission_amount'] ?? 0).toDouble();
        double fee = (order['platform_fee'] ?? 0).toDouble();
        double net = amount - commission - fee;

        return KeuanganRecord(
          id: order['order_code'],
          title: 'Pesanan ${order['order_code']}',
          amount: net,
          type: 'income',
          date: DateTime.parse(order['created_at']),
        );
      }).toList();

      return KeuanganModel(
        title: 'Keuangan',
        subtitle: 'Ringkasan pendapatan, pengeluaran, dan transaksi toko.',
        saldo: netIncome,
        pemasukan: totalRevenue,
        pengeluaran: totalCommission + totalPlatformFee,
        weeklyIncome: weeklyIncome,
        days: days,
        transactions: transactions,
      );
    } catch (e) {
      return _emptyKeuangan();
    }
  }

  KeuanganModel _emptyKeuangan() {
    final now = DateTime.now();
    final days = List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      return '${date.day.toString().padLeft(2, '0')} ${_monthName(date.month)}';
    });

    return KeuanganModel(
      title: 'Keuangan',
      subtitle: 'Ringkasan pendapatan, pengeluaran, dan transaksi toko.',
      saldo: 0,
      pemasukan: 0,
      pengeluaran: 0,
      weeklyIncome: [0, 0, 0, 0, 0, 0, 0],
      days: days,
      transactions: [],
    );
  }

  String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return months[month - 1];
  }
}
