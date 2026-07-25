// TODO: Supabase Integration - ProductApprovalMetric
// Table: product_approvals
// Columns: id (uuid), product_id (uuid), merchant_id (uuid), name (text), 
//          category (text), price (decimal), status (text), submitted_at (timestamp)
// Real-time update: Listen to INSERT/UPDATE on product_approvals table
// Metrics calculation:
// - Total Menunggu: COUNT(*) WHERE status='Pending'
// - Total Approved: COUNT(*) WHERE status='Approved'
// - Total Ditolak: COUNT(*) WHERE status='Rejected'
// - Total Inactive: COUNT(*) WHERE status='Inactive'
// - Total Produk: COUNT(*)
// - Total Review: COUNT(*) WHERE status='Review'
class ProductApprovalMetric {
  final String title;
  final String value;
  final String delta;
  final String icon;
  final int color;

  const ProductApprovalMetric({
    required this.title,
    required this.value,
    required this.delta,
    required this.icon,
    required this.color,
  });
}

class ProductApprovalItem {
  final String id;
  final String name;
  final String productId;
  final String merchant;
  final String category;
  final String price;
  final int stock;
  final String submittedAt;
  final String status;
  final String imageUrl;
  final String description;

  const ProductApprovalItem({
    required this.id,
    required this.name,
    required this.productId,
    required this.merchant,
    required this.category,
    required this.price,
    required this.stock,
    required this.submittedAt,
    required this.status,
    required this.imageUrl,
    required this.description,
  });

  ProductApprovalItem copyWith({
    String? id,
    String? name,
    String? productId,
    String? merchant,
    String? category,
    String? price,
    int? stock,
    String? submittedAt,
    String? status,
    String? imageUrl,
    String? description,
  }) {
    return ProductApprovalItem(
      id: id ?? this.id,
      name: name ?? this.name,
      productId: productId ?? this.productId,
      merchant: merchant ?? this.merchant,
      category: category ?? this.category,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      submittedAt: submittedAt ?? this.submittedAt,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
    );
  }
}

class ProductNotification {
  final String title;
  final String subtitle;
  final String time;
  final int color;
  final String icon;

  const ProductNotification({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
    required this.icon,
  });
}

class TopMerchantProduct {
  final String rank;
  final String name;
  final int productCount;
  final int color;

  const TopMerchantProduct({
    required this.rank,
    required this.name,
    required this.productCount,
    required this.color,
  });
}

const productApprovalMetrics = <ProductApprovalMetric>[];

const productApprovalItems = <ProductApprovalItem>[];

const topMerchantProducts = <TopMerchantProduct>[];
