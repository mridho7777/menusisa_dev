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

const productMetrics = [
  ProductMetric(
    title: 'Total Produk',
    value: '1.330',
    delta: '+75 dari minggu lalu',
    icon: 'inventory',
    color: 0xFF2563EB,
  ),
  ProductMetric(
    title: 'Produk Aktif',
    value: '1.102',
    delta: '+60 dari minggu lalu',
    icon: 'check',
    color: 0xFF0F8D55,
  ),
  ProductMetric(
    title: 'Produk Nonaktif',
    value: '128',
    delta: '+5 dari minggu lalu',
    icon: 'close',
    color: 0xFFF59E0B,
  ),
  ProductMetric(
    title: 'Stok Rendah',
    value: '35',
    delta: '+2 dari minggu lalu',
    icon: 'low_stock',
    color: 0xFF7C3AED,
  ),
  ProductMetric(
    title: 'Produk Terjual',
    value: '12.560',
    delta: '+320 dari minggu lalu',
    icon: 'sell',
    color: 0xFFEF4444,
  ),
  ProductMetric(
    title: 'Produk Baru',
    value: '84',
    delta: '+18 minggu ini',
    icon: 'new',
    color: 0xFF14B8A6,
  ),
];

const productDistribution = [
  CategoryDistributionItem(
    title: 'Makanan',
    value: '842 (63.3%)',
    color: 0xFF0F8D55,
  ),
  CategoryDistributionItem(
    title: 'Minuman',
    value: '312 (23.5%)',
    color: 0xFFF59E0B,
  ),
  CategoryDistributionItem(
    title: 'Snack',
    value: '98 (7.4%)',
    color: 0xFF7C3AED,
  ),
  CategoryDistributionItem(
    title: 'Lainnya',
    value: '78 (5.8%)',
    color: 0xFFEF4444,
  ),
];

const productItems = [
  ProductItem(
    id: '1',
    name: 'Paket Nasi Ayam Geprek',
    merchant: 'Ayam Geprek 99',
    category: 'Makanan',
    price: 'Rp 18.000',
    stock: 25,
    status: 'Aktif',
    sold: 320,
    createdAt: '20 Mei 2025',
    imageUrl: '',
    description:
        'Nasi putih, ayam geprek, sambal bawang, lalapan, tahu, tempe.',
  ),
  ProductItem(
    id: '2',
    name: 'Burger Keju Spesial',
    merchant: 'Burger Enak',
    category: 'Makanan',
    price: 'Rp 22.000',
    stock: 30,
    status: 'Aktif',
    sold: 280,
    createdAt: '20 Mei 2025',
    imageUrl: '',
    description: 'Burger premium dengan keju, tomat, selada, dan saus khusus.',
  ),
  ProductItem(
    id: '3',
    name: 'Es Kopi Susu Gula Aren',
    merchant: 'Kopi Kita',
    category: 'Minuman',
    price: 'Rp 16.000',
    stock: 40,
    status: 'Aktif',
    sold: 210,
    createdAt: '20 Mei 2025',
    imageUrl: '',
    description: 'Kopi robusta, susu segar, gula aren asli.',
  ),
  ProductItem(
    id: '4',
    name: 'Pizza Margherita',
    merchant: 'Pizza Mantap',
    category: 'Makanan',
    price: 'Rp 35.000',
    stock: 15,
    status: 'Rendah',
    sold: 180,
    createdAt: '20 Mei 2025',
    imageUrl: '',
    description: 'Pizza klasik dengan mozzarella dan basil segar.',
  ),
  ProductItem(
    id: '5',
    name: 'Sushi Salmon Roll',
    merchant: 'Sushi Premium',
    category: 'Makanan',
    price: 'Rp 28.000',
    stock: 20,
    status: 'Aktif',
    sold: 150,
    createdAt: '20 Mei 2025',
    imageUrl: '',
    description: 'Sushi roll salmon segar, nori, dan nasi sushi.',
  ),
  ProductItem(
    id: '6',
    name: 'Teh Manis Dingin',
    merchant: 'Es Teh Indonesia',
    category: 'Minuman',
    price: 'Rp 6.000',
    stock: 8,
    status: 'Rendah',
    sold: 90,
    createdAt: '19 Mei 2025',
    imageUrl: '',
    description: 'Minuman segar penyegar hari.',
  ),
  ProductItem(
    id: '7',
    name: 'Nasi Goreng Spesial',
    merchant: 'Warung Nusantara',
    category: 'Makanan',
    price: 'Rp 20.000',
    stock: 22,
    status: 'Aktif',
    sold: 120,
    createdAt: '19 Mei 2025',
    imageUrl: '',
    description: 'Nasi goreng dengan telur, ayam, dan acar.',
  ),
  ProductItem(
    id: '8',
    name: 'Ayam Bakar Madu',
    merchant: 'Ayam Bakar ID',
    category: 'Makanan',
    price: 'Rp 25.000',
    stock: 12,
    status: 'Rendah',
    sold: 110,
    createdAt: '19 Mei 2025',
    imageUrl: '',
    description: 'Ayam bakar dengan bumbu madu khas.',
  ),
];

const lowStockProducts = [
  LowStockItem(name: 'Teh Manis Dingin', stock: 8, imageUrl: ''),
  LowStockItem(name: 'Ayam Bakar Madu', stock: 12, imageUrl: ''),
  LowStockItem(name: 'Pizza Margherita', stock: 15, imageUrl: ''),
  LowStockItem(name: 'Paket Nasi Ayam Geprek', stock: 25, imageUrl: ''),
  LowStockItem(name: 'Sushi Salmon Roll', stock: 20, imageUrl: ''),
];

const productActivities = [
  ActivityItem(
    title: 'Produk "Burger Keju Spesial" diperbarui',
    subtitle: 'oleh Burger Enak',
    time: '5 menit yang lalu',
    color: 0xFF16A34A,
    icon: 'edit',
  ),
  ActivityItem(
    title: 'Produk "Es Kopi Susu Gula Aren" diaktifkan',
    subtitle: 'oleh Kopi Kita',
    time: '15 menit yang lalu',
    color: 0xFF0F8D55,
    icon: 'check',
  ),
  ActivityItem(
    title: 'Produk "Nasi Goreng Spesial" ditambahkan',
    subtitle: 'oleh Warung Nusantara',
    time: '30 menit yang lalu',
    color: 0xFFF59E0B,
    icon: 'add',
  ),
  ActivityItem(
    title: 'Produk "Ayam Bakar Madu" stok diperbarui',
    subtitle: 'oleh Ayam Bakar ID',
    time: '45 menit yang lalu',
    color: 0xFF7C3AED,
    icon: 'inventory',
  ),
];

const productToastMessages = [
  ProductNotification(
    title: 'Produk berhasil diupdate!',
    subtitle: 'Perubahan data produk telah disimpan.',
    time: 'Baru saja',
    color: 0xFF16A34A,
    icon: 'check',
  ),
  ProductNotification(
    title: 'Stok produk terlalu rendah!',
    subtitle: 'Sisa stok kurang dari 5.',
    time: 'Baru saja',
    color: 0xFFF59E0B,
    icon: 'warning',
  ),
  ProductNotification(
    title: 'Produk ditolak!',
    subtitle: 'Burger Keju Spesial ditolak.',
    time: 'Baru saja',
    color: 0xFFEF4444,
    icon: 'cancel',
  ),
];
