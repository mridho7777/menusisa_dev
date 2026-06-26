class MerchantRevenueMetric {
  final String title;
  final String value;
  final String delta;
  final String icon;
  final int color;

  const MerchantRevenueMetric({
    required this.title,
    required this.value,
    required this.delta,
    required this.icon,
    required this.color,
  });
}

class MerchantRevenueItem {
  final String id;
  final String merchant;
  final String category;
  final String totalRevenue;
  final String platformCommission;
  final String payoutToMerchant;
  final String totalTransactions;
  final String averagePerTransaction;
  final String growth;

  const MerchantRevenueItem({
    required this.id,
    required this.merchant,
    required this.category,
    required this.totalRevenue,
    required this.platformCommission,
    required this.payoutToMerchant,
    required this.totalTransactions,
    required this.averagePerTransaction,
    required this.growth,
  });
}

class MerchantRevenueNotification {
  final String title;
  final String subtitle;
  final String time;
  final int color;
  final String icon;

  const MerchantRevenueNotification({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
    required this.icon,
  });
}

class RevenueSummaryItem {
  final String title;
  final String value;
  final String note;
  final int color;

  const RevenueSummaryItem({
    required this.title,
    required this.value,
    required this.note,
    required this.color,
  });
}

class RevenueTopMerchant {
  final String rank;
  final String name;
  final String value;
  final int color;

  const RevenueTopMerchant({
    required this.rank,
    required this.name,
    required this.value,
    required this.color,
  });
}

class RevenueSourceItem {
  final String name;
  final String value;
  final int color;

  const RevenueSourceItem({
    required this.name,
    required this.value,
    required this.color,
  });
}

class QuickInfoItem {
  final String label;
  final String value;

  const QuickInfoItem({required this.label, required this.value});
}

const merchantRevenueMetrics = [
  MerchantRevenueMetric(
    title: 'Total Merchant Aktif',
    value: '128',
    delta: '+8 dari minggu lalu',
    icon: 'people',
    color: 0xFF0F8D55,
  ),
  MerchantRevenueMetric(
    title: 'Total Pendapatan Merchant',
    value: 'Rp 2.856.800.000',
    delta: '+15.2% dari minggu lalu',
    icon: 'money',
    color: 0xFF2563EB,
  ),
  MerchantRevenueMetric(
    title: 'Total Komisi Platform',
    value: 'Rp 85.704.000',
    delta: '+12.8% dari minggu lalu',
    icon: 'percent',
    color: 0xFF7C3AED,
  ),
  MerchantRevenueMetric(
    title: 'Rata-rata Pendapatan / Merchant',
    value: 'Rp 22.318.750',
    delta: '+9.7% dari minggu lalu',
    icon: 'avg',
    color: 0xFFF59E0B,
  ),
  MerchantRevenueMetric(
    title: 'Top Merchant (Pendapatan)',
    value: 'Kopi Kita',
    delta: 'Rp 245.680.000',
    icon: 'store',
    color: 0xFF14B8A6,
  ),
  MerchantRevenueMetric(
    title: 'Payout Merchant',
    value: 'Rp 2.771.096.000',
    delta: '+14.4% dari minggu lalu',
    icon: 'payout',
    color: 0xFFEF4444,
  ),
];

const merchantRevenueItems = [
  MerchantRevenueItem(
    id: '1',
    merchant: 'Kopi Kita',
    category: 'Minuman',
    totalRevenue: 'Rp 245.680.000',
    platformCommission: 'Rp 7.370.400',
    payoutToMerchant: 'Rp 238.309.600',
    totalTransactions: '2.145',
    averagePerTransaction: 'Rp 114.483',
    growth: '+18.7%',
  ),
  MerchantRevenueItem(
    id: '2',
    merchant: 'Burger Enak',
    category: 'Makanan',
    totalRevenue: 'Rp 186.750.000',
    platformCommission: 'Rp 5.602.500',
    payoutToMerchant: 'Rp 181.147.500',
    totalTransactions: '1.856',
    averagePerTransaction: 'Rp 100.456',
    growth: '+12.4%',
  ),
  MerchantRevenueItem(
    id: '3',
    merchant: 'Ayam Geprek 99',
    category: 'Makanan',
    totalRevenue: 'Rp 164.320.000',
    platformCommission: 'Rp 4.929.600',
    payoutToMerchant: 'Rp 159.390.400',
    totalTransactions: '1.425',
    averagePerTransaction: 'Rp 115.332',
    growth: '+22.1%',
  ),
  MerchantRevenueItem(
    id: '4',
    merchant: 'Pizza Mantap',
    category: 'Makanan',
    totalRevenue: 'Rp 129.950.000',
    platformCommission: 'Rp 3.868.500',
    payoutToMerchant: 'Rp 126.081.500',
    totalTransactions: '1.102',
    averagePerTransaction: 'Rp 117.106',
    growth: '+8.9%',
  ),
  MerchantRevenueItem(
    id: '5',
    merchant: 'Sushi Premium',
    category: 'Makanan',
    totalRevenue: 'Rp 95.870.000',
    platformCommission: 'Rp 2.876.100',
    payoutToMerchant: 'Rp 92.993.900',
    totalTransactions: '876',
    averagePerTransaction: 'Rp 109.475',
    growth: '+7.3%',
  ),
  MerchantRevenueItem(
    id: '6',
    merchant: 'Es Teh Indonesia',
    category: 'Minuman',
    totalRevenue: 'Rp 45.200.000',
    platformCommission: 'Rp 1.356.000',
    payoutToMerchant: 'Rp 43.844.000',
    totalTransactions: '642',
    averagePerTransaction: 'Rp 70.404',
    growth: '-2.1%',
  ),
  MerchantRevenueItem(
    id: '7',
    merchant: 'Warung Nusantara',
    category: 'Makanan',
    totalRevenue: 'Rp 38.600.000',
    platformCommission: 'Rp 1.158.000',
    payoutToMerchant: 'Rp 37.442.000',
    totalTransactions: '518',
    averagePerTransaction: 'Rp 74.517',
    growth: '+4.6%',
  ),
  MerchantRevenueItem(
    id: '8',
    merchant: 'Kedai Snack',
    category: 'Snack',
    totalRevenue: 'Rp 21.430.000',
    platformCommission: 'Rp 642.900',
    payoutToMerchant: 'Rp 20.787.100',
    totalTransactions: '356',
    averagePerTransaction: 'Rp 60.196',
    growth: '-1.3%',
  ),
];

const revenueSummaryMerchant = [
  RevenueSummaryItem(
    title: 'Total Pendapatan',
    value: 'Rp 2.856.800.000',
    note: 'Semua merchant aktif',
    color: 0xFF0F8D55,
  ),
  RevenueSummaryItem(
    title: 'Total Komisi Platform',
    value: 'Rp 85.704.000',
    note: '3% rata-rata',
    color: 0xFF2563EB,
  ),
  RevenueSummaryItem(
    title: 'Total Payout ke Merchant',
    value: 'Rp 2.771.096.000',
    note: 'Dana tersalurkan',
    color: 0xFFF59E0B,
  ),
  RevenueSummaryItem(
    title: 'Merchant dengan Pertumbuhan Tertinggi',
    value: 'Ayam Geprek 99',
    note: 'Naik paling tinggi bulan ini',
    color: 0xFF7C3AED,
  ),
  RevenueSummaryItem(
    title: 'Pendapatan Tertinggi',
    value: 'Kopi Kita',
    note: 'Rp 245.680.000',
    color: 0xFF14B8A6,
  ),
  RevenueSummaryItem(
    title: 'Pendapatan Terendah',
    value: 'Es Teh Indonesia',
    note: 'Rp 5.200.000',
    color: 0xFFEF4444,
  ),
  RevenueSummaryItem(
    title: 'Total Merchant Aktif',
    value: '128',
    note: 'Semua merchant aktif',
    color: 0xFF0F8D55,
  ),
];

const revenueSourcesMerchant = [
  RevenueSourceItem(name: 'Makanan', value: '65.0%', color: 0xFF0F8D55),
  RevenueSourceItem(name: 'Minuman', value: '22.5%', color: 0xFFF59E0B),
  RevenueSourceItem(name: 'Snack', value: '7.5%', color: 0xFFEF4444),
  RevenueSourceItem(name: 'Lainnya', value: '5.0%', color: 0xFF7C3AED),
];

const topRevenueMerchants = [
  RevenueTopMerchant(
    rank: '1',
    name: 'Kopi Kita',
    value: 'Rp 245.680.000',
    color: 0xFFF59E0B,
  ),
  RevenueTopMerchant(
    rank: '2',
    name: 'Burger Enak',
    value: 'Rp 186.750.000',
    color: 0xFF9CA3AF,
  ),
  RevenueTopMerchant(
    rank: '3',
    name: 'Ayam Geprek 99',
    value: 'Rp 164.320.000',
    color: 0xFFCD7F32,
  ),
  RevenueTopMerchant(
    rank: '4',
    name: 'Pizza Mantap',
    value: 'Rp 128.950.000',
    color: 0xFF7C3AED,
  ),
  RevenueTopMerchant(
    rank: '5',
    name: 'Sushi Premium',
    value: 'Rp 95.870.000',
    color: 0xFF0F766E,
  ),
];

const quickInfoMerchant = [
  QuickInfoItem(label: 'Total Merchant Aktif', value: '128'),
  QuickInfoItem(label: 'Total Transaksi', value: '8.920'),
  QuickInfoItem(label: 'Rata-rata Transaksi per Merchant', value: '69.69'),
  QuickInfoItem(label: 'Komisi Rata-rata per Merchant', value: 'Rp 669.563'),
  QuickInfoItem(label: 'Payout Rata-rata per Merchant', value: 'Rp 21.649.188'),
];

const merchantRevenueToastMessages = [
  MerchantRevenueNotification(
    title: 'Payout berhasil diproses!',
    subtitle: 'Dana telah dikirim ke merchant Kopi Kita.',
    time: 'Baru saja',
    color: 0xFF16A34A,
    icon: 'check',
  ),
  MerchantRevenueNotification(
    title: 'Komisi bulan ini lebih tinggi',
    subtitle: 'Naik 12.8% dibandingkan bulan lalu.',
    time: 'Baru saja',
    color: 0xFFF59E0B,
    icon: 'warning',
  ),
  MerchantRevenueNotification(
    title: 'Transaksi dibatalkan',
    subtitle: '37 transaksi dibatalkan pada periode ini.',
    time: 'Baru saja',
    color: 0xFFEF4444,
    icon: 'cancel',
  ),
];
