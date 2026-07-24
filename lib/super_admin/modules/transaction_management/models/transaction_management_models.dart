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

const transactionMetrics = <TransactionMetric>[];

const paymentMethodDistribution = <PaymentMethodItem>[];

const transactionItems = <TransactionItem>[];

const topMerchantTransactions = <TopMerchantTransaction>[];
