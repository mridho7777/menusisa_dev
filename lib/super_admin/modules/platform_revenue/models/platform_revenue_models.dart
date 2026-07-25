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
  final String id; // TODO: Supabase - UUID from database
  final String date;
  final String source;
  final String category;
  final String value;
  final String status;
  final String? merchantId; // TODO: Supabase - Reference to merchants table
  final String? transactionId; // TODO: Supabase - Reference to transactions table
  final DateTime? createdAt; // TODO: Supabase - Timestamp

  const RevenueItem({
    required this.id,
    required this.date,
    required this.source,
    required this.category,
    required this.value,
    required this.status,
    this.merchantId,
    this.transactionId,
    this.createdAt,
  });

  // TODO: Supabase - Factory for converting from database
  factory RevenueItem.fromJson(Map<String, dynamic> json) {
    return RevenueItem(
      id: json['id'] as String,
      date: json['date'] as String,
      source: json['source'] as String,
      category: json['category'] as String,
      value: json['amount']?.toString() ?? '0',
      status: json['status'] as String? ?? 'Masuk',
      merchantId: json['merchant_id'] as String?,
      transactionId: json['transaction_id'] as String?,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  // TODO: Supabase - Convert to JSON for database
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'source': source,
      'category': category,
      'amount': value,
      'status': status,
      'merchant_id': merchantId,
      'transaction_id': transactionId,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  RevenueItem copyWith({
    String? id,
    String? date,
    String? source,
    String? category,
    String? value,
    String? status,
    String? merchantId,
    String? transactionId,
    DateTime? createdAt,
  }) {
    return RevenueItem(
      id: id ?? this.id,
      date: date ?? this.date,
      source: source ?? this.source,
      category: category ?? this.category,
      value: value ?? this.value,
      status: status ?? this.status,
      merchantId: merchantId ?? this.merchantId,
      transactionId: transactionId ?? this.transactionId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
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

const revenueMetrics = <RevenueMetric>[];

const revenueItems = <RevenueItem>[];

const revenueSummaryItems = <RevenueSummaryItem>[];

const revenueSources = <RevenueSourceItem>[];

const revenueTopItems = <RevenueTopItem>[];

const revenueToastMessages = <RevenueNotification>[];


