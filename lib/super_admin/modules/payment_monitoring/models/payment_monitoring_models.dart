class PaymentMetric {
  final String title;
  final String value;
  final String delta;
  final String icon;
  final int color;

  const PaymentMetric({
    required this.title,
    required this.value,
    required this.delta,
    required this.icon,
    required this.color,
  });
}

class PaymentItem {
  final String id;
  final String orderId;
  final String transactionId;
  final String customer;
  final String merchant;
  final String method;
  final String amount;
  final String status;
  final String time;
  final String date;
  final String bank;
  final String channel;
  final String notes;

  const PaymentItem({
    required this.id,
    required this.orderId,
    required this.transactionId,
    required this.customer,
    required this.merchant,
    required this.method,
    required this.amount,
    required this.status,
    required this.time,
    required this.date,
    required this.bank,
    required this.channel,
    required this.notes,
  });
}

class PaymentNotification {
  final String title;
  final String subtitle;
  final String time;
  final int color;
  final String icon;

  const PaymentNotification({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
    required this.icon,
  });
}

class PaymentMethodStat {
  final String title;
  final String value;
  final int color;

  const PaymentMethodStat({
    required this.title,
    required this.value,
    required this.color,
  });
}

class TopMerchantPayment {
  final String rank;
  final String name;
  final String total;
  final String transactionCount;
  final int color;

  const TopMerchantPayment({
    required this.rank,
    required this.name,
    required this.total,
    required this.transactionCount,
    required this.color,
  });
}

const paymentMetrics = [
  PaymentMetric(
    title: 'Total Pembayaran',
    value: '2.456',
    delta: '+120 dari minggu lalu',
    icon: 'wallet',
    color: 0xFF0F8D55,
  ),
  PaymentMetric(
    title: 'Pembayaran Berhasil',
    value: '1.856',
    delta: '+98 dari minggu lalu',
    icon: 'check',
    color: 0xFF2563EB,
  ),
  PaymentMetric(
    title: 'Pembayaran Pending',
    value: '246',
    delta: '+12 dari minggu lalu',
    icon: 'hourglass',
    color: 0xFFF59E0B,
  ),
  PaymentMetric(
    title: 'Pembayaran Gagal',
    value: '198',
    delta: '+10 dari minggu lalu',
    icon: 'close',
    color: 0xFFEF4444,
  ),
  PaymentMetric(
    title: 'Pembayaran Expired',
    value: '156',
    delta: '+5 dari minggu lalu',
    icon: 'expired',
    color: 0xFF7C3AED,
  ),
  PaymentMetric(
    title: 'Total Nilai Pembayaran',
    value: 'Rp 245.680.000',
    delta: '+15.6% dari minggu lalu',
    icon: 'money',
    color: 0xFF14B8A6,
  ),
];

const paymentMethodStats = [
  PaymentMethodStat(title: 'QRIS', value: '1.245 (50.7%)', color: 0xFF0F8D55),
  PaymentMethodStat(
    title: 'Transfer Bank',
    value: '820 (33.4%)',
    color: 0xFFF59E0B,
  ),
  PaymentMethodStat(
    title: 'Cash di Tempat',
    value: '321 (13.1%)',
    color: 0xFFEF4444,
  ),
  PaymentMethodStat(
    title: 'Kartu Kredit',
    value: '70 (2.8%)',
    color: 0xFF7C3AED,
  ),
];

const paymentItems = [
  PaymentItem(
    id: '1',
    orderId: '#ORD-20260620-001',
    transactionId: 'a1b2-c3d4-5678-90ab',
    customer: 'Andi Wijaya',
    merchant: 'Kopi Kita',
    method: 'QRIS',
    amount: 'Rp 125.000',
    status: 'Berhasil',
    time: '20 Mei 2025, 10:20 WIB',
    date: '20 Mei 2025',
    bank: 'GoPay',
    channel: 'QRIS',
    notes: 'Lunas',
  ),
  PaymentItem(
    id: '2',
    orderId: '#ORD-20260620-002',
    transactionId: 'b2c3-d4e5-6789-01bc',
    customer: 'Siti Aisyah',
    merchant: 'Burger Enak',
    method: 'Transfer Bank',
    amount: 'Rp 85.000',
    status: 'Berhasil',
    time: '20 Mei 2025, 10:15 WIB',
    date: '20 Mei 2025',
    bank: 'BCA',
    channel: 'VA',
    notes: 'Lunas',
  ),
  PaymentItem(
    id: '3',
    orderId: '#ORD-20260620-003',
    transactionId: 'c3d4-e5f6-7890-12cd',
    customer: 'Budi Santoso',
    merchant: 'Ayam Geprek 99',
    method: 'Cash',
    amount: 'Rp 45.000',
    status: 'Pending',
    time: '20 Mei 2025, 10:10 WIB',
    date: '20 Mei 2025',
    bank: '-',
    channel: 'Cash',
    notes: 'Menunggu konfirmasi',
  ),
  PaymentItem(
    id: '4',
    orderId: '#ORD-20260620-004',
    transactionId: 'd4e5-f6g7-8901-23de',
    customer: 'Dewi Lestari',
    merchant: 'Pizza Mantap',
    method: 'QRIS',
    amount: 'Rp 120.000',
    status: 'Berhasil',
    time: '20 Mei 2025, 10:05 WIB',
    date: '20 Mei 2025',
    bank: 'DANA',
    channel: 'QRIS',
    notes: 'Lunas',
  ),
  PaymentItem(
    id: '5',
    orderId: '#ORD-20260620-005',
    transactionId: 'e5f6-g7h8-9012-34ef',
    customer: 'Rizky Pratama',
    merchant: 'Sushi Premium',
    method: 'Transfer Bank',
    amount: 'Rp 95.000',
    status: 'Gagal',
    time: '20 Mei 2025, 09:45 WIB',
    date: '20 Mei 2025',
    bank: 'Mandiri',
    channel: 'VA',
    notes: 'Timeout',
  ),
  PaymentItem(
    id: '6',
    orderId: '#ORD-20260620-006',
    transactionId: 'f6g7-h8i9-0123-45fg',
    customer: 'Maya Sari',
    merchant: 'Es Teh Indonesia',
    method: 'QRIS',
    amount: 'Rp 20.000',
    status: 'Berhasil',
    time: '20 Mei 2025, 09:30 WIB',
    date: '20 Mei 2025',
    bank: 'OVO',
    channel: 'QRIS',
    notes: 'Lunas',
  ),
  PaymentItem(
    id: '7',
    orderId: '#ORD-20260620-007',
    transactionId: 'g7h8-i9j0-1234-56gh',
    customer: 'Fajar Ramadhan',
    merchant: 'Warung Nusantara',
    method: 'Transfer Bank',
    amount: 'Rp 60.000',
    status: 'Pending',
    time: '20 Mei 2025, 09:10 WIB',
    date: '20 Mei 2025',
    bank: 'BRI',
    channel: 'VA',
    notes: 'Menunggu pembayaran',
  ),
  PaymentItem(
    id: '8',
    orderId: '#ORD-20260620-008',
    transactionId: 'h8i9-j0k1-2345-67hi',
    customer: 'Nina Marlina',
    merchant: 'Kopi Kita',
    method: 'Cash',
    amount: 'Rp 35.000',
    status: 'Expired',
    time: '20 Mei 2025, 09:05 WIB',
    date: '20 Mei 2025',
    bank: '-',
    channel: 'Cash',
    notes: 'Kadaluarsa',
  ),
];

const topMerchantPayments = [
  TopMerchantPayment(
    rank: '1',
    name: 'Kopi Kita',
    total: 'Rp 8.250.000',
    transactionCount: '320',
    color: 0xFFF59E0B,
  ),
  TopMerchantPayment(
    rank: '2',
    name: 'Burger Enak',
    total: 'Rp 6.750.000',
    transactionCount: '280',
    color: 0xFF9CA3AF,
  ),
  TopMerchantPayment(
    rank: '3',
    name: 'Ayam Geprek 99',
    total: 'Rp 5.450.000',
    transactionCount: '210',
    color: 0xFFCD7F32,
  ),
  TopMerchantPayment(
    rank: '4',
    name: 'Pizza Mantap',
    total: 'Rp 4.850.000',
    transactionCount: '180',
    color: 0xFF7C3AED,
  ),
  TopMerchantPayment(
    rank: '5',
    name: 'Sushi Premium',
    total: 'Rp 3.950.000',
    transactionCount: '150',
    color: 0xFF0F766E,
  ),
];

const paymentToastMessages = [
  PaymentNotification(
    title: 'Pembayaran berhasil diperbarui!',
    subtitle: 'Order ID #ORD-20260620-003 status diubah.',
    time: 'Baru saja',
    color: 0xFF16A34A,
    icon: 'check',
  ),
  PaymentNotification(
    title: 'Pembayaran pending',
    subtitle: 'Order ID #ORD-20260620-007 menunggu pembayaran.',
    time: 'Baru saja',
    color: 0xFFF59E0B,
    icon: 'warning',
  ),
  PaymentNotification(
    title: 'Pembayaran gagal!',
    subtitle: 'Order ID #ORD-20260620-005 pembayaran gagal.',
    time: 'Baru saja',
    color: 0xFFEF4444,
    icon: 'cancel',
  ),
];
