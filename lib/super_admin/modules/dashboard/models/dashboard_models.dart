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

const dashboardMetrics = [
  DashboardMetric(
    title: 'Total Customer',
    value: '1.245',
    delta: '+24 hari ini',
    icon: 'people',
    color: 0xFF0F8D55,
  ),
  DashboardMetric(
    title: 'Total Merchant',
    value: '128',
    delta: '+8 hari ini',
    icon: 'store',
    color: 0xFFF59E0B,
  ),
  DashboardMetric(
    title: 'Total Produk',
    value: '3.462',
    delta: '+75 hari ini',
    icon: 'inventory_2',
    color: 0xFF1D4ED8,
  ),
  DashboardMetric(
    title: 'Total Pesanan',
    value: '2.860',
    delta: '+132 hari ini',
    icon: 'shopping_cart',
    color: 0xFF7C3AED,
  ),
  DashboardMetric(
    title: 'Total Transaksi',
    value: '2.456',
    delta: '+120 hari ini',
    icon: 'payments',
    color: 0xFF0F766E,
  ),
  DashboardMetric(
    title: 'Pendapatan Platform',
    value: 'Rp 25.450.000',
    delta: '+12.5% dari kemarin',
    icon: 'savings',
    color: 0xFFEF4444,
  ),
];

const dashboardPendingItems = [
  DashboardPendingItem(
    title: 'GMV Platform',
    value: 'Rp 1.245.850.000',
    actionLabel: '+18.2%',
  ),
  DashboardPendingItem(
    title: 'Komisi Platform',
    value: 'Rp 36.540.000',
    actionLabel: '+12.7%',
  ),
  DashboardPendingItem(
    title: 'Total Refund',
    value: 'Rp 2.150.000',
    actionLabel: '-4.3%',
  ),
  DashboardPendingItem(
    title: 'Total Withdrawal Merchant',
    value: 'Rp 652.340.000',
    actionLabel: '+9.8%',
  ),
  DashboardPendingItem(
    title: 'Produk Menunggu Approval',
    value: '12',
    actionLabel: 'Lihat Detail',
  ),
  DashboardPendingItem(
    title: 'Merchant Menunggu Verifikasi',
    value: '4',
    actionLabel: 'Lihat Detail',
  ),
  DashboardPendingItem(
    title: 'Refund Menunggu Persetujuan',
    value: '3',
    actionLabel: 'Lihat Detail',
  ),
  DashboardPendingItem(
    title: 'Laporan Bulanan Siap',
    value: '2026-06',
    actionLabel: 'Lihat Detail',
  ),
];

const dashboardTransactions = [
  DashboardTransaction(
    id: '#ORD-20250520-001',
    customer: 'Andi Wijaya',
    merchant: 'Kopi Kita',
    total: 'Rp 125.000',
    method: 'QRIS',
    status: 'Berhasil',
    time: '10:20 WIB',
  ),
  DashboardTransaction(
    id: '#ORD-20250520-002',
    customer: 'Siti Aisyah',
    merchant: 'Burger Enak',
    total: 'Rp 85.000',
    method: 'Transfer Bank',
    status: 'Pending',
    time: '10:15 WIB',
  ),
  DashboardTransaction(
    id: '#ORD-20250520-003',
    customer: 'Budi Santoso',
    merchant: 'Ayam Geprek 99',
    total: 'Rp 45.000',
    method: 'Bayar di Tempat',
    status: 'Diproses',
    time: '10:10 WIB',
  ),
  DashboardTransaction(
    id: '#ORD-20250520-004',
    customer: 'Dewi Lestari',
    merchant: 'Kopi Kita',
    total: 'Rp 35.000',
    method: 'QRIS',
    status: 'Berhasil',
    time: '10:05 WIB',
  ),
  DashboardTransaction(
    id: '#ORD-20250520-005',
    customer: 'Rizky Pratama',
    merchant: 'Pizza Mantap',
    total: 'Rp 120.000',
    method: 'Transfer Bank',
    status: 'Berhasil',
    time: '10:00 WIB',
  ),
];

const dashboardMerchants = [
  DashboardMerchant(
    rank: '1',
    name: 'Kopi Kita',
    revenue: 'Rp 8.250.000',
    orders: '320 Pesanan',
    color: 0xFFF59E0B,
  ),
  DashboardMerchant(
    rank: '2',
    name: 'Burger Enak',
    revenue: 'Rp 6.750.000',
    orders: '280 Pesanan',
    color: 0xFF9CA3AF,
  ),
  DashboardMerchant(
    rank: '3',
    name: 'Ayam Geprek 99',
    revenue: 'Rp 5.450.000',
    orders: '210 Pesanan',
    color: 0xFFCD7F32,
  ),
  DashboardMerchant(
    rank: '4',
    name: 'Pizza Mantap',
    revenue: 'Rp 4.850.000',
    orders: '180 Pesanan',
    color: 0xFF7C3AED,
  ),
  DashboardMerchant(
    rank: '5',
    name: 'Sushi Premium',
    revenue: 'Rp 3.950.000',
    orders: '150 Pesanan',
    color: 0xFF0F766E,
  ),
];

const dashboardActivities = [
  DashboardActivity(
    icon: 'store',
    title: 'Merchant Baru Mendaftar',
    subtitle: 'Kopi Nusantara mendaftar sebagai merchant baru',
    time: '5 menit yang lalu',
    color: 0xFF8B5CF6,
  ),
  DashboardActivity(
    icon: 'shopping_bag',
    title: 'Pesanan Baru',
    subtitle: 'Pesanan #ORD-20250520-001 dari Andi Wijaya',
    time: '10 menit yang lalu',
    color: 0xFFF59E0B,
  ),
  DashboardActivity(
    icon: 'verified',
    title: 'Pembayaran Berhasil',
    subtitle: 'Pembayaran #PAY-20250520-123 berhasil',
    time: '15 menit yang lalu',
    color: 0xFF10B981,
  ),
  DashboardActivity(
    icon: 'inventory_2',
    title: 'Produk Menunggu Approval',
    subtitle: '12 produk baru menunggu persetujuan',
    time: '20 menit yang lalu',
    color: 0xFF14B8A6,
  ),
  DashboardActivity(
    icon: 'percent',
    title: 'Komisi Diubah',
    subtitle: 'Persentase komisi diubah menjadi 3%',
    time: '30 menit yang lalu',
    color: 0xFF3B82F6,
  ),
];

const dashboardNotices = [
  DashboardNotice(
    icon: 'store',
    title: 'Merchant baru mendaftar',
    subtitle: 'Kopi Nusantara menunggu verifikasi',
    time: '5 menit yang lalu',
    color: 0xFF8B5CF6,
  ),
  DashboardNotice(
    icon: 'inventory_2',
    title: 'Produk menunggu approval',
    subtitle: '12 produk baru perlu diperiksa',
    time: '10 menit yang lalu',
    color: 0xFFF59E0B,
  ),
  DashboardNotice(
    icon: 'receipt_long',
    title: 'Refund baru',
    subtitle: 'Refund order #ORD-20250520-002 menunggu review',
    time: '30 menit yang lalu',
    color: 0xFF10B981,
  ),
  DashboardNotice(
    icon: 'payments',
    title: 'Komisi platform diperbarui',
    subtitle: 'Persentase komisi kini 3%',
    time: '45 menit yang lalu',
    color: 0xFF3B82F6,
  ),
  DashboardNotice(
    icon: 'warning',
    title: 'Transaksi besar terdeteksi',
    subtitle: 'Transaksi #TRX-20250520-798 senilai Rp 25.000.000',
    time: '1 jam yang lalu',
    color: 0xFFEF4444,
  ),
];

const dashboardQuickActions = [
  DashboardQuickAction(label: 'Tambah Merchant', icon: 'add'),
  DashboardQuickAction(label: 'Tambah Admin', icon: 'person_add'),
  DashboardQuickAction(label: 'Broadcast Notifikasi', icon: 'campaign'),
  DashboardQuickAction(label: 'Export Laporan', icon: 'description'),
  DashboardQuickAction(label: 'Generate Laporan Bulanan', icon: 'summarize'),
  DashboardQuickAction(label: 'Pengaturan Komisi', icon: 'settings'),
  DashboardQuickAction(label: 'Kelola Promo', icon: 'local_offer'),
  DashboardQuickAction(label: 'Ringkasan Cepat', icon: 'dashboard_customize'),
];

const dashboardToasts = [
  DashboardToastMessage(
    title: 'Komisi Platform berhasil diubah!',
    subtitle: 'Persentase komisi kini 3%',
    color: 0xFF16A34A,
  ),
  DashboardToastMessage(
    title: 'Produk baru menunggu approval',
    subtitle: '12 produk baru perlu diperiksa',
    color: 0xFFF59E0B,
  ),
  DashboardToastMessage(
    title: 'Pembayaran gagal',
    subtitle: 'Pembayaran #PAY-20250520-124 gagal',
    color: 0xFFEF4444,
  ),
];
