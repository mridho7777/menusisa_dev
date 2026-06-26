class CommissionMetric {
  final String title;
  final String value;
  final String delta;
  final String icon;
  final int color;

  const CommissionMetric({
    required this.title,
    required this.value,
    required this.delta,
    required this.icon,
    required this.color,
  });
}

class CommissionTransactionItem {
  final String id;
  final String orderId;
  final String date;
  final String merchant;
  final String totalTransaction;
  final String commissionRate;
  final String platformCommission;
  final String paymentMethod;
  final String status;

  const CommissionTransactionItem({
    required this.id,
    required this.orderId,
    required this.date,
    required this.merchant,
    required this.totalTransaction,
    required this.commissionRate,
    required this.platformCommission,
    required this.paymentMethod,
    required this.status,
  });
}

class CommissionNotification {
  final String title;
  final String subtitle;
  final String time;
  final int color;
  final String icon;

  const CommissionNotification({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
    required this.icon,
  });
}

class CommissionChangeItem {
  final String no;
  final String percentage;
  final String changedBy;
  final String date;
  final String note;

  const CommissionChangeItem({
    required this.no,
    required this.percentage,
    required this.changedBy,
    required this.date,
    required this.note,
  });
}

class CommissionTopMerchant {
  final String rank;
  final String name;
  final String commission;
  final int color;

  const CommissionTopMerchant({
    required this.rank,
    required this.name,
    required this.commission,
    required this.color,
  });
}

const commissionMetrics = [
  CommissionMetric(
    title: 'Persentase Komisi Saat Ini',
    value: '3%',
    delta: 'Dari total transaksi',
    icon: 'percent',
    color: 0xFF0F8D55,
  ),
  CommissionMetric(
    title: 'Pendapatan Komisi Hari Ini',
    value: 'Rp 1.250.000',
    delta: '+12.5% dari kemarin',
    icon: 'today',
    color: 0xFF2563EB,
  ),
  CommissionMetric(
    title: 'Pendapatan Komisi Bulan Ini',
    value: 'Rp 25.450.000',
    delta: '+18.3% dari bulan lalu',
    icon: 'month',
    color: 0xFF7C3AED,
  ),
  CommissionMetric(
    title: 'Pendapatan Komisi Tahun Ini',
    value: 'Rp 245.680.000',
    delta: '+22.7% dari tahun lalu',
    icon: 'year',
    color: 0xFFF59E0B,
  ),
  CommissionMetric(
    title: 'Total Transaksi (Bulan Ini)',
    value: '2.860',
    delta: '+132 dari bulan lalu',
    icon: 'transactions',
    color: 0xFFEF4444,
  ),
  CommissionMetric(
    title: 'Merchant Terdampak',
    value: '128',
    delta: '+8 minggu ini',
    icon: 'merchant',
    color: 0xFF14B8A6,
  ),
];

const commissionTransactions = [
  CommissionTransactionItem(
    id: '1',
    orderId: '#ORD-20260520-001',
    date: '20 Mei 2025\n10:20 WIB',
    merchant: 'Kopi Kita',
    totalTransaction: 'Rp 125.000',
    commissionRate: '3%',
    platformCommission: 'Rp 3.750',
    paymentMethod: 'QRIS',
    status: 'Sukses',
  ),
  CommissionTransactionItem(
    id: '2',
    orderId: '#ORD-20260520-002',
    date: '20 Mei 2025\n10:15 WIB',
    merchant: 'Burger Enak',
    totalTransaction: 'Rp 85.000',
    commissionRate: '3%',
    platformCommission: 'Rp 2.550',
    paymentMethod: 'Transfer Bank',
    status: 'Sukses',
  ),
  CommissionTransactionItem(
    id: '3',
    orderId: '#ORD-20260520-003',
    date: '20 Mei 2025\n10:10 WIB',
    merchant: 'Ayam Geprek 99',
    totalTransaction: 'Rp 45.000',
    commissionRate: '3%',
    platformCommission: 'Rp 1.350',
    paymentMethod: 'GoPay',
    status: 'Sukses',
  ),
  CommissionTransactionItem(
    id: '4',
    orderId: '#ORD-20260520-004',
    date: '20 Mei 2025\n09:55 WIB',
    merchant: 'Pizza Mantap',
    totalTransaction: 'Rp 120.000',
    commissionRate: '3%',
    platformCommission: 'Rp 3.600',
    paymentMethod: 'Virtual Account BCA',
    status: 'Sukses',
  ),
  CommissionTransactionItem(
    id: '5',
    orderId: '#ORD-20260520-005',
    date: '20 Mei 2025\n09:45 WIB',
    merchant: 'Sushi Premium',
    totalTransaction: 'Rp 95.000',
    commissionRate: '3%',
    platformCommission: 'Rp 2.850',
    paymentMethod: 'OVO',
    status: 'Sukses',
  ),
];

const commissionChanges = [
  CommissionChangeItem(
    no: '1',
    percentage: '3%',
    changedBy: 'Super Admin',
    date: '15 Mei 2025\n14:30 WIB',
    note: 'Penyesuaian komisi',
  ),
  CommissionChangeItem(
    no: '2',
    percentage: '2.5%',
    changedBy: 'Super Admin',
    date: '10 Apr 2025\n10:20 WIB',
    note: 'Komisi dinaikkan',
  ),
  CommissionChangeItem(
    no: '3',
    percentage: '2%',
    changedBy: 'Super Admin',
    date: '01 Feb 2025\n11:20 WIB',
    note: 'Promo awal',
  ),
  CommissionChangeItem(
    no: '4',
    percentage: '1.5%',
    changedBy: 'Super Admin',
    date: '01 Jan 2025\n00:00 WIB',
    note: 'Komisi awal',
  ),
];

const commissionTopMerchants = [
  CommissionTopMerchant(
    rank: '1',
    name: 'Kopi Kita',
    commission: 'Rp 8.250.000',
    color: 0xFFF59E0B,
  ),
  CommissionTopMerchant(
    rank: '2',
    name: 'Burger Enak',
    commission: 'Rp 6.750.000',
    color: 0xFF9CA3AF,
  ),
  CommissionTopMerchant(
    rank: '3',
    name: 'Ayam Geprek 99',
    commission: 'Rp 5.450.000',
    color: 0xFFCD7F32,
  ),
  CommissionTopMerchant(
    rank: '4',
    name: 'Pizza Mantap',
    commission: 'Rp 4.850.000',
    color: 0xFF7C3AED,
  ),
  CommissionTopMerchant(
    rank: '5',
    name: 'Sushi Premium',
    commission: 'Rp 3.950.000',
    color: 0xFF0F766E,
  ),
];

const commissionToastMessages = [
  CommissionNotification(
    title: 'Komisi platform berhasil diperbarui!',
    subtitle: 'Persentase komisi kini 3%.',
    time: 'Baru saja',
    color: 0xFF16A34A,
    icon: 'check',
  ),
  CommissionNotification(
    title: 'Perubahan komisi akan berlaku untuk transaksi baru.',
    subtitle: 'Transaksi lama tidak terpengaruh.',
    time: 'Baru saja',
    color: 0xFFF59E0B,
    icon: 'warning',
  ),
  CommissionNotification(
    title: 'Gagal memperbarui komisi!',
    subtitle: 'Terjadi kesalahan, silakan coba lagi.',
    time: 'Baru saja',
    color: 0xFFEF4444,
    icon: 'cancel',
  ),
];
