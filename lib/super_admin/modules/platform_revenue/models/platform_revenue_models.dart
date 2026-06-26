class RevenueMetric {
  final String title;
  final String value;
  final String delta;
  final String icon;
  final int color;

  const RevenueMetric({
    required this.title,
    required this.value,
    required this.delta,
    required this.icon,
    required this.color,
  });
}

class RevenueItem {
  final String id;
  final String date;
  final String source;
  final String category;
  final String value;
  final String status;

  const RevenueItem({
    required this.id,
    required this.date,
    required this.source,
    required this.category,
    required this.value,
    required this.status,
  });
}

class RevenueNotification {
  final String title;
  final String subtitle;
  final String time;
  final int color;
  final String icon;

  const RevenueNotification({
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

class RevenueTopItem {
  final String rank;
  final String name;
  final String amount;
  final int color;

  const RevenueTopItem({
    required this.rank,
    required this.name,
    required this.amount,
    required this.color,
  });
}

const revenueMetrics = [
  RevenueMetric(
    title: 'Total Pendapatan',
    value: 'Rp 245.680.000',
    delta: '+18.3% dari bulan lalu',
    icon: 'money',
    color: 0xFF0F8D55,
  ),
  RevenueMetric(
    title: 'Pendapatan Hari Ini',
    value: 'Rp 12.450.000',
    delta: '+12.5% dari kemarin',
    icon: 'today',
    color: 0xFF2563EB,
  ),
  RevenueMetric(
    title: 'Pendapatan Minggu Ini',
    value: 'Rp 68.200.000',
    delta: '+9.8% dari minggu lalu',
    icon: 'week',
    color: 0xFFF59E0B,
  ),
  RevenueMetric(
    title: 'Pendapatan Bulan Ini',
    value: 'Rp 95.450.000',
    delta: '+15.6% dari bulan lalu',
    icon: 'month',
    color: 0xFF7C3AED,
  ),
  RevenueMetric(
    title: 'Pendapatan Tahun Ini',
    value: 'Rp 1.245.680.000',
    delta: '+22.7% dari tahun lalu',
    icon: 'year',
    color: 0xFFEF4444,
  ),
  RevenueMetric(
    title: 'Pertumbuhan Pendapatan',
    value: '28%',
    delta: 'YoY growth',
    icon: 'growth',
    color: 0xFF14B8A6,
  ),
];

const revenueItems = [
  RevenueItem(
    id: '1',
    date: '20 Mei 2025',
    source: 'Komisi Platform',
    category: 'Commission',
    value: 'Rp 3.750',
    status: 'Masuk',
  ),
  RevenueItem(
    id: '2',
    date: '20 Mei 2025',
    source: 'Biaya Layanan',
    category: 'Service Fee',
    value: 'Rp 1.250',
    status: 'Masuk',
  ),
  RevenueItem(
    id: '3',
    date: '20 Mei 2025',
    source: 'Biaya Transaksi',
    category: 'Transaction Fee',
    value: 'Rp 2.500',
    status: 'Masuk',
  ),
  RevenueItem(
    id: '4',
    date: '20 Mei 2025',
    source: 'Komisi Platform',
    category: 'Commission',
    value: 'Rp 3.600',
    status: 'Masuk',
  ),
  RevenueItem(
    id: '5',
    date: '20 Mei 2025',
    source: 'Biaya Layanan',
    category: 'Service Fee',
    value: 'Rp 2.850',
    status: 'Masuk',
  ),
  RevenueItem(
    id: '6',
    date: '20 Mei 2025',
    source: 'Komisi Platform',
    category: 'Commission',
    value: 'Rp 1.350',
    status: 'Masuk',
  ),
];

const revenueSummaryItems = [
  RevenueSummaryItem(
    title: 'Komisi Platform',
    value: 'Rp 145.200.000',
    note: '60% dari total',
    color: 0xFF0F8D55,
  ),
  RevenueSummaryItem(
    title: 'Biaya Layanan',
    value: 'Rp 68.450.000',
    note: '28% dari total',
    color: 0xFFF59E0B,
  ),
  RevenueSummaryItem(
    title: 'Biaya Transaksi',
    value: 'Rp 32.030.000',
    note: '13% dari total',
    color: 0xFF7C3AED,
  ),
  RevenueSummaryItem(
    title: 'Lainnya',
    value: 'Rp 0',
    note: '0% dari total',
    color: 0xFFEF4444,
  ),
];

const revenueSources = [
  RevenueSourceItem(name: 'Komisi Platform', value: '60%', color: 0xFF0F8D55),
  RevenueSourceItem(name: 'Biaya Layanan', value: '28%', color: 0xFFF59E0B),
  RevenueSourceItem(name: 'Biaya Transaksi', value: '13%', color: 0xFF7C3AED),
  RevenueSourceItem(name: 'Lainnya', value: '0%', color: 0xFFEF4444),
];

const revenueTopItems = [
  RevenueTopItem(
    rank: '1',
    name: 'Kopi Kita',
    amount: 'Rp 8.250.000',
    color: 0xFFF59E0B,
  ),
  RevenueTopItem(
    rank: '2',
    name: 'Burger Enak',
    amount: 'Rp 6.750.000',
    color: 0xFF9CA3AF,
  ),
  RevenueTopItem(
    rank: '3',
    name: 'Ayam Geprek 99',
    amount: 'Rp 5.450.000',
    color: 0xFFCD7F32,
  ),
  RevenueTopItem(
    rank: '4',
    name: 'Pizza Mantap',
    amount: 'Rp 4.850.000',
    color: 0xFF7C3AED,
  ),
  RevenueTopItem(
    rank: '5',
    name: 'Sushi Premium',
    amount: 'Rp 3.950.000',
    color: 0xFF0F766E,
  ),
];

const revenueToastMessages = [
  RevenueNotification(
    title: 'Pendapatan berhasil diperbarui!',
    subtitle: 'Data revenue sudah disinkronkan.',
    time: 'Baru saja',
    color: 0xFF16A34A,
    icon: 'check',
  ),
  RevenueNotification(
    title: 'Data revenue diexport!',
    subtitle: 'File laporan siap diunduh.',
    time: 'Baru saja',
    color: 0xFF0F8D55,
    icon: 'check',
  ),
  RevenueNotification(
    title: 'Sinkronisasi pendapatan gagal!',
    subtitle: 'Coba lagi beberapa saat.',
    time: 'Baru saja',
    color: 0xFFEF4444,
    icon: 'cancel',
  ),
];
