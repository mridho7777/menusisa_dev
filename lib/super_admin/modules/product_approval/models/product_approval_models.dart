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

const productApprovalMetrics = [
  ProductApprovalMetric(
    title: 'Pending Approval',
    value: '24',
    delta: '+8 hari ini',
    icon: 'hourglass',
    color: 0xFFF59E0B,
  ),
  ProductApprovalMetric(
    title: 'Approved',
    value: '1.256',
    delta: '+45 minggu ini',
    icon: 'check',
    color: 0xFF16A34A,
  ),
  ProductApprovalMetric(
    title: 'Rejected',
    value: '18',
    delta: '+3 minggu ini',
    icon: 'close',
    color: 0xFFEF4444,
  ),
  ProductApprovalMetric(
    title: 'Inactive',
    value: '32',
    delta: '+6 minggu ini',
    icon: 'block',
    color: 0xFF7C3AED,
  ),
  ProductApprovalMetric(
    title: 'Total Produk',
    value: '1.330',
    delta: 'Semua Status',
    icon: 'inventory',
    color: 0xFF2563EB,
  ),
];

const productApprovalItems = [
  ProductApprovalItem(
    id: '1',
    name: 'Paket Nasi Ayam Geprek',
    productId: 'PRD-20250520-001',
    merchant: 'Ayam Geprek 99',
    category: 'Makanan',
    price: 'Rp 18.000',
    stock: 25,
    submittedAt: '20 Mei 2025, 09:15 WIB',
    status: 'Pending',
    imageUrl: '',
    description:
        'Nasi putih, ayam geprek, sambal korek, lalapan, tahu goreng, tempe goreng',
  ),
  ProductApprovalItem(
    id: '2',
    name: 'Burger Kopi Spesial',
    productId: 'PRD-20250520-002',
    merchant: 'Burger Enak',
    category: 'Makanan',
    price: 'Rp 22.000',
    stock: 30,
    submittedAt: '20 Mei 2025, 08:45 WIB',
    status: 'Pending',
    imageUrl: '',
    description: 'Burger dengan daging premium, keju, tomat, selada segar',
  ),
  ProductApprovalItem(
    id: '3',
    name: 'Es Kopi Susu Gula Aren',
    productId: 'PRD-20250520-003',
    merchant: 'Kopi Kita',
    category: 'Minuman',
    price: 'Rp 16.000',
    stock: 40,
    submittedAt: '20 Mei 2025, 08:20 WIB',
    status: 'Pending',
    imageUrl: '',
    description: 'Kopi robusta pilihan, susu segar, gula aren asli',
  ),
  ProductApprovalItem(
    id: '4',
    name: 'Pizza Margherita',
    productId: 'PRD-20250520-004',
    merchant: 'Pizza Mantap',
    category: 'Makanan',
    price: 'Rp 35.000',
    stock: 15,
    submittedAt: '20 Mei 2025, 07:50 WIB',
    status: 'Pending',
    imageUrl: '',
    description: 'Pizza klasik dengan topping keju mozarella, basil, tomat',
  ),
  ProductApprovalItem(
    id: '5',
    name: 'Sushi Salmon Roll',
    productId: 'PRD-20250520-005',
    merchant: 'Sushi Premium',
    category: 'Makanan',
    price: 'Rp 28.000',
    stock: 20,
    submittedAt: '20 Mei 2025, 07:30 WIB',
    status: 'Pending',
    imageUrl: '',
    description: 'Sushi roll dengan salmon segar, nori, nasi sushi',
  ),
];

const topMerchantProducts = [
  TopMerchantProduct(
    rank: '1',
    name: 'Kopi Kita',
    productCount: 320,
    color: 0xFFF59E0B,
  ),
  TopMerchantProduct(
    rank: '2',
    name: 'Burger Enak',
    productCount: 280,
    color: 0xFF9CA3AF,
  ),
  TopMerchantProduct(
    rank: '3',
    name: 'Ayam Geprek 99',
    productCount: 210,
    color: 0xFFCD7F32,
  ),
  TopMerchantProduct(
    rank: '4',
    name: 'Pizza Mantap',
    productCount: 180,
    color: 0xFF7C3AED,
  ),
  TopMerchantProduct(
    rank: '5',
    name: 'Sushi Premium',
    productCount: 150,
    color: 0xFF0F766E,
  ),
];
