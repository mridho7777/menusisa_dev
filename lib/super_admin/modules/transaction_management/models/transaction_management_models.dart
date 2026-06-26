class TransactionMetric {
  final String title;
  final String value;
  final String delta;
  final String icon;
  final int color;

  const TransactionMetric({
    required this.title,
    required this.value,
    required this.delta,
    required this.icon,
    required this.color,
  });
}

class TransactionItem {
  final String id;
  final String orderId;
  final String customer;
  final String merchant;
  final String total;
  final String method;
  final String status;
  final String time;
  final String date;
  final List<String> items;
  final String notes;

  const TransactionItem({
    required this.id,
    required this.orderId,
    required this.customer,
    required this.merchant,
    required this.total,
    required this.method,
    required this.status,
    required this.time,
    required this.date,
    required this.items,
    required this.notes,
  });
}

class TransactionNotification {
  final String title;
  final String subtitle;
  final String time;
  final int color;
  final String icon;

  const TransactionNotification({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
    required this.icon,
  });
}

class PaymentMethodItem {
  final String title;
  final String value;
  final int color;

  const PaymentMethodItem({
    required this.title,
    required this.value,
    required this.color,
  });
}

class TopMerchantTransaction {
  final String rank;
  final String name;
  final String revenue;
  final String transactionCount;
  final int color;

  const TopMerchantTransaction({
    required this.rank,
    required this.name,
    required this.revenue,
    required this.transactionCount,
    required this.color,
  });
}

const transactionMetrics = [
  TransactionMetric(
    title: 'Total Transaksi',
    value: '2.456',
    delta: '+120 dari kemarin',
    icon: 'payments',
    color: 0xFF2563EB,
  ),
  TransactionMetric(
    title: 'Transaksi Berhasil',
    value: '2.124',
    delta: '+98 dari kemarin',
    icon: 'check',
    color: 0xFF0F8D55,
  ),
  TransactionMetric(
    title: 'Transaksi Pending',
    value: '86',
    delta: '+12 dari kemarin',
    icon: 'hourglass',
    color: 0xFFF59E0B,
  ),
  TransactionMetric(
    title: 'Transaksi Gagal',
    value: '42',
    delta: '+5 dari kemarin',
    icon: 'close',
    color: 0xFFEF4444,
  ),
  TransactionMetric(
    title: 'Total Pendapatan',
    value: 'Rp 125.450.000',
    delta: '+12.5% dari kemarin',
    icon: 'money',
    color: 0xFF14B8A6,
  ),
  TransactionMetric(
    title: 'Refund Request',
    value: '18',
    delta: '+3 dari kemarin',
    icon: 'refund',
    color: 0xFF7C3AED,
  ),
];

const paymentMethodDistribution = [
  PaymentMethodItem(title: 'QRIS', value: '1.245 (52%)', color: 0xFF0F8D55),
  PaymentMethodItem(
    title: 'Transfer Bank',
    value: '820 (34%)',
    color: 0xFFF59E0B,
  ),
  PaymentMethodItem(title: 'E-Wallet', value: '270 (11%)', color: 0xFF7C3AED),
  PaymentMethodItem(
    title: 'Bayar di Tempat',
    value: '121 (3%)',
    color: 0xFFEF4444,
  ),
];

const transactionItems = [
  TransactionItem(
    id: '1',
    orderId: '#ORD-20260621-001',
    customer: 'Andi Wijaya',
    merchant: 'Kopi Kita',
    total: 'Rp 125.000',
    method: 'QRIS',
    status: 'Berhasil',
    time: '10:20 WIB',
    date: '21 Jun 2026',
    items: ['Es Kopi Susu x2', 'Nasi Goreng x1'],
    notes: 'Pengiriman cepat',
  ),
  TransactionItem(
    id: '2',
    orderId: '#ORD-20260621-002',
    customer: 'Siti Aisyah',
    merchant: 'Burger Enak',
    total: 'Rp 85.000',
    method: 'Transfer Bank',
    status: 'Pending',
    time: '10:15 WIB',
    date: '21 Jun 2026',
    items: ['Burger Keju x2'],
    notes: 'Menunggu konfirmasi',
  ),
  TransactionItem(
    id: '3',
    orderId: '#ORD-20260621-003',
    customer: 'Budi Santoso',
    merchant: 'Ayam Geprek 99',
    total: 'Rp 45.000',
    method: 'E-Wallet',
    status: 'Diproses',
    time: '10:10 WIB',
    date: '21 Jun 2026',
    items: ['Paket Ayam Geprek x1'],
    notes: '',
  ),
  TransactionItem(
    id: '4',
    orderId: '#ORD-20260621-004',
    customer: 'Dewi Lestari',
    merchant: 'Kopi Kita',
    total: 'Rp 35.000',
    method: 'QRIS',
    status: 'Berhasil',
    time: '10:05 WIB',
    date: '21 Jun 2026',
    items: ['Kopi Americano x1'],
    notes: '',
  ),
  TransactionItem(
    id: '5',
    orderId: '#ORD-20260621-005',
    customer: 'Rizky Pratama',
    merchant: 'Pizza Mantap',
    total: 'Rp 120.000',
    method: 'Transfer Bank',
    status: 'Berhasil',
    time: '10:00 WIB',
    date: '21 Jun 2026',
    items: ['Pizza Margherita x1'],
    notes: 'Tolong tambah keju',
  ),
  TransactionItem(
    id: '6',
    orderId: '#ORD-20260621-006',
    customer: 'Lina Marlina',
    merchant: 'Sushi Premium',
    total: 'Rp 95.000',
    method: 'QRIS',
    status: 'Gagal',
    time: '09:55 WIB',
    date: '21 Jun 2026',
    items: ['Sushi Salmon Roll x2'],
    notes: 'Pembayaran gagal',
  ),
];

const topMerchantTransactions = [
  TopMerchantTransaction(
    rank: '1',
    name: 'Kopi Kita',
    revenue: 'Rp 8.250.000',
    transactionCount: '320',
    color: 0xFFF59E0B,
  ),
  TopMerchantTransaction(
    rank: '2',
    name: 'Burger Enak',
    revenue: 'Rp 6.750.000',
    transactionCount: '280',
    color: 0xFF9CA3AF,
  ),
  TopMerchantTransaction(
    rank: '3',
    name: 'Ayam Geprek 99',
    revenue: 'Rp 5.450.000',
    transactionCount: '210',
    color: 0xFFCD7F32,
  ),
  TopMerchantTransaction(
    rank: '4',
    name: 'Pizza Mantap',
    revenue: 'Rp 4.850.000',
    transactionCount: '180',
    color: 0xFF7C3AED,
  ),
  TopMerchantTransaction(
    rank: '5',
    name: 'Sushi Premium',
    revenue: 'Rp 3.950.000',
    transactionCount: '150',
    color: 0xFF0F766E,
  ),
];
