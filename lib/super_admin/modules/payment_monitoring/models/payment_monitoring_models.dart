// TODO: Supabase Integration - PaymentMetric
// Table: payments
// Columns: id (uuid), transaction_id (uuid), merchant_id (uuid), customer_id (uuid),
//          amount (decimal), method (text), status (text), created_at (timestamp)
// Real-time update: Listen to INSERT/UPDATE on payments table
// Metrics calculation:
// - Total Pembayaran Hari Ini: COUNT(*) WHERE DATE(created_at)=CURRENT_DATE
// - Total Sukses: COUNT(*) WHERE status='Sukses'
// - Total Pending: COUNT(*) WHERE status='Pending'
// - Total Gagal: COUNT(*) WHERE status='Gagal'
// - Total Refund: COUNT(*) WHERE status='Refund'
// - Nominal Total: SUM(amount)
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

const paymentMetrics = <PaymentMetric>[];

const paymentMethodStats = <PaymentMethodStat>[];

const paymentItems = <PaymentItem>[];

const topMerchantPayments = <TopMerchantPayment>[];

const paymentToastMessages = <PaymentNotification>[];
