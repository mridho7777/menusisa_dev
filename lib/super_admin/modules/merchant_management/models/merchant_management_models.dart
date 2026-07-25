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

class MerchantRecord {
  final String id;
  final String merchantId;
  final String shopName;
  final String ownerName;
  final String email;
  final String phone;
  final String status;
  final String registeredAt;
  final String totalProducts;
  final String totalSales;

  const MerchantRecord({
    required this.id,
    required this.merchantId,
    required this.shopName,
    required this.ownerName,
    required this.email,
    required this.phone,
    required this.status,
    required this.registeredAt,
    required this.totalProducts,
    required this.totalSales,
  });

  MerchantRecord copyWith({
    String? id,
    String? merchantId,
    String? shopName,
    String? ownerName,
    String? email,
    String? phone,
    String? status,
    String? registeredAt,
    String? totalProducts,
    String? totalSales,
  }) {
    return MerchantRecord(
      id: id ?? this.id,
      merchantId: merchantId ?? this.merchantId,
      shopName: shopName ?? this.shopName,
      ownerName: ownerName ?? this.ownerName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      registeredAt: registeredAt ?? this.registeredAt,
      totalProducts: totalProducts ?? this.totalProducts,
      totalSales: totalSales ?? this.totalSales,
    );
  }
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

const merchantRecords = <MerchantRecord>[];

// TODO: Integrasi Supabase - Data metrics ini akan diambil dari Supabase
// Query akan menghitung jumlah merchant berdasarkan status dan tanggal registrasi
// Contoh query: SELECT COUNT(*) FROM merchants WHERE status = 'active'
const merchantMetrics = <MerchantMetric>[];

const merchantTopMerchants = <MerchantTopMerchant>[];

const merchantQuickActions = <MerchantQuickAction>[];

const merchantToastMessages = <MerchantNotification>[];

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

const merchantDistributionLegend = <MerchantDistributionLegendItem>[];

