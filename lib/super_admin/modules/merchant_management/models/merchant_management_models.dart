class MerchantMetric {
  final String title;
  final String value;
  final String delta;
  final String icon;
  final int color;

  const MerchantMetric({
    required this.title,
    required this.value,
    required this.delta,
    required this.icon,
    required this.color,
  });
}

class MerchantNotification {
  final String title;
  final String subtitle;
  final String time;
  final int color;
  final String icon;

  const MerchantNotification({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
    required this.icon,
  });
}

class MerchantQuickAction {
  final String label;
  final String icon;

  const MerchantQuickAction({required this.label, required this.icon});
}

class MerchantTopMerchant {
  final String rank;
  final String name;
  final String revenue;
  final String orders;
  final int color;

  const MerchantTopMerchant({
    required this.rank,
    required this.name,
    required this.revenue,
    required this.orders,
    required this.color,
  });
}

const merchantMetrics = [
  MerchantMetric(
    title: 'Total Merchant',
    value: '128',
    delta: '+8 minggu ini',
    icon: 'store',
    color: 0xFF0F8D55,
  ),
  MerchantMetric(
    title: 'Merchant Aktif',
    value: '112',
    delta: '+7 minggu ini',
    icon: 'people',
    color: 0xFF2563EB,
  ),
  MerchantMetric(
    title: 'Merchant Pending',
    value: '10',
    delta: '-2 minggu ini',
    icon: 'pending',
    color: 0xFFF59E0B,
  ),
  MerchantMetric(
    title: 'Merchant Suspend',
    value: '4',
    delta: '-1 minggu ini',
    icon: 'lock',
    color: 0xFF7C3AED,
  ),
  MerchantMetric(
    title: 'Merchant Nonaktif',
    value: '2',
    delta: '-1 minggu ini',
    icon: 'close',
    color: 0xFFEF4444,
  ),
  MerchantMetric(
    title: 'Merchant Terverifikasi',
    value: '98',
    delta: '+14 minggu ini',
    icon: 'verified',
    color: 0xFF14B8A6,
  ),
];

const merchantTopMerchants = [
  MerchantTopMerchant(
    rank: '1',
    name: 'Kopi Kita',
    revenue: 'Rp 8.250.000',
    orders: '320 pesanan',
    color: 0xFFF59E0B,
  ),
  MerchantTopMerchant(
    rank: '2',
    name: 'Burger Enak',
    revenue: 'Rp 6.750.000',
    orders: '280 pesanan',
    color: 0xFF9CA3AF,
  ),
  MerchantTopMerchant(
    rank: '3',
    name: 'Ayam Geprek 99',
    revenue: 'Rp 5.450.000',
    orders: '210 pesanan',
    color: 0xFFCD7F32,
  ),
  MerchantTopMerchant(
    rank: '4',
    name: 'Pizza Mantap',
    revenue: 'Rp 4.850.000',
    orders: '180 pesanan',
    color: 0xFF7C3AED,
  ),
  MerchantTopMerchant(
    rank: '5',
    name: 'Sushi Premium',
    revenue: 'Rp 3.950.000',
    orders: '150 pesanan',
    color: 0xFF0F766E,
  ),
];

const merchantQuickActions = [
  MerchantQuickAction(label: 'Tambah Merchant', icon: 'add'),
  MerchantQuickAction(label: 'Verifikasi', icon: 'verified'),
  MerchantQuickAction(label: 'Suspend', icon: 'lock'),
  MerchantQuickAction(label: 'Nonaktifkan', icon: 'power'),
  MerchantQuickAction(label: 'Export Data', icon: 'download'),
  MerchantQuickAction(label: 'Refresh', icon: 'refresh'),
];

const merchantToastMessages = [
  MerchantNotification(
    title: 'Merchant berhasil disetujui!',
    subtitle: 'Merchant Kopi Nusantara telah disetujui.',
    time: 'Baru saja',
    color: 0xFF16A34A,
    icon: 'check',
  ),
  MerchantNotification(
    title: 'Merchant menunggu verifikasi',
    subtitle: 'Merchant baru perlu data tambahan.',
    time: 'Baru saja',
    color: 0xFFF59E0B,
    icon: 'warning',
  ),
  MerchantNotification(
    title: 'Merchant berhasil disuspend',
    subtitle: 'Merchant Ayam Bakar ID disuspend.',
    time: 'Baru saja',
    color: 0xFFEF4444,
    icon: 'cancel',
  ),
];

class MerchantDistributionLegendItem {
  final String title;
  final String value;
  final int color;

  const MerchantDistributionLegendItem({
    required this.title,
    required this.value,
    required this.color,
  });
}

const merchantDistributionLegend = [
  MerchantDistributionLegendItem(
    title: 'Aktif',
    value: '112 (87.5%)',
    color: 0xFF0F8D55,
  ),
  MerchantDistributionLegendItem(
    title: 'Pending',
    value: '10 (7.8%)',
    color: 0xFFF59E0B,
  ),
  MerchantDistributionLegendItem(
    title: 'Suspend',
    value: '4 (3.1%)',
    color: 0xFF7C3AED,
  ),
  MerchantDistributionLegendItem(
    title: 'Nonaktif',
    value: '2 (1.6%)',
    color: 0xFFEF4444,
  ),
];
