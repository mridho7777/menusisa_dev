class ProductMetric {
  final String title;
  final String value;
  final String delta;
  final String icon;
  final int color;

  const ProductMetric({
    required this.title,
    required this.value,
    required this.delta,
    required this.icon,
    required this.color,
  });
}

class ProductItem {
  final String id;
  final String name;
  final String merchant;
  final String category;
  final String price;
  final int stock;
  final String status;
  final int sold;
  final String createdAt;
  final String imageUrl;
  final String description;

  const ProductItem({
    required this.id,
    required this.name,
    required this.merchant,
    required this.category,
    required this.price,
    required this.stock,
    required this.status,
    required this.sold,
    required this.createdAt,
    required this.imageUrl,
    required this.description,
  });
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

class CategoryDistributionItem {
  final String title;
  final String value;
  final int color;

  const CategoryDistributionItem({
    required this.title,
    required this.value,
    required this.color,
  });
}

class LowStockItem {
  final String name;
  final int stock;
  final String imageUrl;

  const LowStockItem({
    required this.name,
    required this.stock,
    required this.imageUrl,
  });
}

class ActivityItem {
  final String title;
  final String subtitle;
  final String time;
  final int color;
  final String icon;

  const ActivityItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
    required this.icon,
  });
}

const productMetrics = <ProductMetric>[];

const productDistribution = <CategoryDistributionItem>[];

const productItems = <ProductItem>[];

const lowStockProducts = <LowStockItem>[];

const productActivities = <ActivityItem>[];

const productToastMessages = <ProductNotification>[];
