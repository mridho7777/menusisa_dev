class NotificationMetric {
  final String title;
  final String value;
  final String delta;
  final String icon;
  final int color;

  const NotificationMetric({
    required this.title,
    required this.value,
    required this.delta,
    required this.icon,
    required this.color,
  });
}

class NotificationItem {
  final String id;
  final String title;
  final String type;
  final String recipient;
  final String channel;
  final String sender;
  final String sentAt;
  final String status;
  final String readProgress;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.type,
    required this.recipient,
    required this.channel,
    required this.sender,
    required this.sentAt,
    required this.status,
    required this.readProgress,
  });
}

class NotificationChannelStat {
  final String name;
  final String value;
  final int color;

  const NotificationChannelStat({
    required this.name,
    required this.value,
    required this.color,
  });
}

class NotificationSendStat {
  final String label;
  final String value;
  final String note;
  final int color;

  const NotificationSendStat({
    required this.label,
    required this.value,
    required this.note,
    required this.color,
  });
}

class NotificationTopItem {
  final String rank;
  final String name;
  final String count;
  final int color;

  const NotificationTopItem({
    required this.rank,
    required this.name,
    required this.count,
    required this.color,
  });
}

class NotificationActionItem {
  final String title;
  final String subtitle;
  final String time;
  final int color;
  final String icon;

  const NotificationActionItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
    required this.icon,
  });
}

const notificationMetrics = [
  NotificationMetric(
    title: 'Total Notifikasi',
    value: '1.245',
    delta: '+120 dari minggu lalu',
    icon: 'bell',
    color: 0xFF0F8D55,
  ),
  NotificationMetric(
    title: 'Terkirim',
    value: '1.050',
    delta: '+95 dari minggu lalu',
    icon: 'send',
    color: 0xFF2563EB,
  ),
  NotificationMetric(
    title: 'Dibaca',
    value: '892',
    delta: '+88 dari minggu lalu',
    icon: 'read',
    color: 0xFFF59E0B,
  ),
  NotificationMetric(
    title: 'Belum Dibaca',
    value: '158',
    delta: '+12 dari minggu lalu',
    icon: 'unread',
    color: 0xFF7C3AED,
  ),
  NotificationMetric(
    title: 'Gagal Terkirim',
    value: '37',
    delta: '+8 dari minggu lalu',
    icon: 'failed',
    color: 0xFFEF4444,
  ),
  NotificationMetric(
    title: 'Tingkat Dibaca',
    value: '85.1%',
    delta: '+6.4% dari minggu lalu',
    icon: 'percent',
    color: 0xFF14B8A6,
  ),
];

const notificationItems = [
  NotificationItem(
    id: '1',
    title: 'Promo Spesial Ramadhan',
    type: 'Promosi',
    recipient: 'Semua Customer',
    channel: 'Push / Email / SMS',
    sender: 'Super Admin',
    sentAt: '20 Mei 2025\n10:20 WIB',
    status: 'Terkirim',
    readProgress: '1.120 / 1.245 (90%)',
  ),
  NotificationItem(
    id: '2',
    title: 'Pesanan Baru Masuk',
    type: 'Transaksi',
    recipient: 'Merchant',
    channel: 'Push Notification',
    sender: 'Sistem Otomatis',
    sentAt: '20 Mei 2025\n10:15 WIB',
    status: 'Terkirim',
    readProgress: '620 / 680 (91%)',
  ),
  NotificationItem(
    id: '3',
    title: 'Pembayaran Berhasil',
    type: 'Pembayaran',
    recipient: 'Customer',
    channel: 'Push / Email / In-App',
    sender: 'Sistem Otomatis',
    sentAt: '20 Mei 2025\n10:10 WIB',
    status: 'Terkirim',
    readProgress: '1.005 / 1.120 (89%)',
  ),
  NotificationItem(
    id: '4',
    title: 'Produk Disetujui',
    type: 'Produk',
    recipient: 'Merchant',
    channel: 'Push Notification',
    sender: 'Super Admin',
    sentAt: '20 Mei 2025\n09:55 WIB',
    status: 'Terkirim',
    readProgress: '210 / 230 (91%)',
  ),
  NotificationItem(
    id: '5',
    title: 'Stok Produk Rendah',
    type: 'Peringatan',
    recipient: 'Merchant',
    channel: 'Push / Email',
    sender: 'Sistem Otomatis',
    sentAt: '20 Mei 2025\n09:30 WIB',
    status: 'Terkirim',
    readProgress: '310 / 400 (78%)',
  ),
  NotificationItem(
    id: '6',
    title: 'Voucher Spesial Hari Ini',
    type: 'Promosi',
    recipient: 'Semua Customer',
    channel: 'Email',
    sender: 'Super Admin',
    sentAt: '20 Mei 2025\n09:20 WIB',
    status: 'Dijadwalkan',
    readProgress: '0 / 1.300 (0%)',
  ),
  NotificationItem(
    id: '7',
    title: 'Pembayaran Gagal',
    type: 'Pembayaran',
    recipient: 'Customer',
    channel: 'Push / Email / In-App',
    sender: 'Sistem Otomatis',
    sentAt: '20 Mei 2025\n08:45 WIB',
    status: 'Terkirim',
    readProgress: '180 / 220 (82%)',
  ),
  NotificationItem(
    id: '8',
    title: 'Maintenance Sistem',
    type: 'Informasi',
    recipient: 'Semua Pengguna',
    channel: 'Push / Email / SMS',
    sender: 'Super Admin',
    sentAt: '19 Mei 2025\n23:00 WIB',
    status: 'Gagal',
    readProgress: '0 / 1500 (0%)',
  ),
];

const notificationChannelStats = [
  NotificationChannelStat(
    name: 'Push Notification',
    value: '620 (49.8%)',
    color: 0xFF0F8D55,
  ),
  NotificationChannelStat(
    name: 'Email',
    value: '380 (30.5%)',
    color: 0xFFF59E0B,
  ),
  NotificationChannelStat(name: 'SMS', value: '180 (14.5%)', color: 0xFFEF4444),
  NotificationChannelStat(
    name: 'In-App',
    value: '65 (5.2%)',
    color: 0xFF7C3AED,
  ),
];

const notificationSendStats = [
  NotificationSendStat(
    label: 'Berhasil Dikirim',
    value: '1.050',
    note: '84.3%',
    color: 0xFF0F8D55,
  ),
  NotificationSendStat(
    label: 'Dibaca',
    value: '892',
    note: '85.1% dari terkirim',
    color: 0xFF2563EB,
  ),
  NotificationSendStat(
    label: 'Belum Dibaca',
    value: '158',
    note: '14.9% dari terkirim',
    color: 0xFFF59E0B,
  ),
  NotificationSendStat(
    label: 'Gagal Terkirim',
    value: '37',
    note: '3.0%',
    color: 0xFFEF4444,
  ),
];

const notificationTopItems = [
  NotificationTopItem(
    rank: '1',
    name: 'Promo Spesial Ramadhan',
    count: '1.245',
    color: 0xFFF59E0B,
  ),
  NotificationTopItem(
    rank: '2',
    name: 'Pesanan Baru Masuk',
    count: '620',
    color: 0xFF9CA3AF,
  ),
  NotificationTopItem(
    rank: '3',
    name: 'Pembayaran Berhasil',
    count: '380',
    color: 0xFFCD7F32,
  ),
  NotificationTopItem(
    rank: '4',
    name: 'Produk Disetujui',
    count: '210',
    color: 0xFF7C3AED,
  ),
  NotificationTopItem(
    rank: '5',
    name: 'Maintenance Sistem',
    count: '65',
    color: 0xFF0F766E,
  ),
];

const notificationActions = [
  NotificationActionItem(
    title: 'Notifikasi berhasil dikirim!',
    subtitle: 'Promo Spesial Ramadhan berhasil dikirim ke 1.245 penerima.',
    time: 'Baru saja',
    color: 0xFF16A34A,
    icon: 'check',
  ),
  NotificationActionItem(
    title: 'Notifikasi dijadwalkan',
    subtitle: 'Voucher Spesial Hari ini akan dikirim 21 Mei 2025, 09:00 WIB.',
    time: 'Baru saja',
    color: 0xFFF59E0B,
    icon: 'warning',
  ),
  NotificationActionItem(
    title: 'Gagal mengirim notifikasi',
    subtitle: 'Maintenance Sistem gagal dikirim ke beberapa penerima.',
    time: 'Baru saja',
    color: 0xFFEF4444,
    icon: 'cancel',
  ),
];
