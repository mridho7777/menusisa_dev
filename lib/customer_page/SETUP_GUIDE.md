# Setup Guide - Customer Page Integration

## 🚀 Quick Start

### 1. Konfigurasi Supabase

Edit file: lib/customer_page/config/supabase_config.dart

\\\dart
class SupabaseConfig {
  // Ganti dengan credentials Supabase Anda
  static const String supabaseUrl = 'https://your-project.supabase.co';
  static const String supabaseAnonKey = 'your-anon-key-here';
}
\\\

### 2. Jalankan SQL Schema

Jalankan file: lib/analisis_4_folder/supabase_schema.sql di Supabase SQL Editor

### 3. Enable Row Level Security (RLS)

Supabase Dashboard → Authentication → Policies

#### Products Table
\\\sql
-- Allow public read for active products
CREATE POLICY "Public can view active products" 
ON products FOR SELECT 
USING (is_active = true AND approval_status = 'approved');
\\\

#### Favorites Table
\\\sql
-- Users can manage their own favorites
CREATE POLICY "Users can manage own favorites" 
ON favorites FOR ALL 
USING (auth.uid() = user_id);
\\\

#### Cart Items Table
\\\sql
-- Users can manage their own cart
CREATE POLICY "Users can manage own cart" 
ON cart_items FOR ALL 
USING (auth.uid() = user_id);
\\\

#### Orders Table
\\\sql
-- Users can view and create their own orders
CREATE POLICY "Users can view own orders" 
ON orders FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Users can create orders" 
ON orders FOR INSERT 
WITH CHECK (auth.uid() = user_id);
\\\

### 4. Insert Sample Data

\\\sql
-- Insert sample categories
INSERT INTO categories (name, slug, display_order) VALUES 
  ('Makanan', 'makanan', 1),
  ('Minuman', 'minuman', 2),
  ('Snack', 'snack', 3),
  ('Lainnya', 'lainnya', 4);

-- Insert sample merchant
INSERT INTO users (email, full_name, role) VALUES 
  ('merchant@test.com', 'Kopi Kita', 'merchant');

INSERT INTO merchants (user_id, merchant_code, shop_name, shop_address, latitude, longitude, status)
SELECT 
  id, 
  'MCH-001', 
  'Kopi Kita', 
  'Seturan Raya No.10, Yogyakarta',
  -7.7556,
  110.3782,
  'active'
FROM users WHERE email = 'merchant@test.com';

-- Insert sample products
INSERT INTO products (merchant_id, category_id, name, description, price, original_price, stock, tag, is_active, approval_status)
SELECT 
  m.id,
  c.id,
  'Paket Nasi Blind Bag',
  'Paket nasi dengan lauk surprise',
  15000,
  45000,
  10,
  'Blind Bag',
  true,
  'approved'
FROM merchants m, categories c 
WHERE m.merchant_code = 'MCH-001' AND c.slug = 'makanan';
\\\

---

## 🔑 Authentication Setup

### Enable Email Authentication

1. Supabase Dashboard → Authentication → Providers
2. Enable "Email" provider
3. (Optional) Disable email confirmation untuk testing

### Test User

Buat test user di Supabase:
\\\sql
-- Via SQL
INSERT INTO auth.users (email, encrypted_password, email_confirmed_at)
VALUES ('test@customer.com', crypt('password123', gen_salt('bf')), NOW());
\\\

Atau via Supabase Dashboard → Authentication → Users → Invite user

---

## 📱 Testing Application

### Mode 1: Dengan Login (Online Mode)
\\\ash
flutter run -t lib/main_customer_page.dart
\\\

Login dengan:
- Email: test@customer.com
- Password: password123

### Mode 2: Tanpa Login (Offline Mode)
- Aplikasi otomatis menggunakan dummy data
- Semua fitur tetap berfungsi (data di local state)

---

## 🔧 Fitur per Screen

### Home Screen
**Supabase Integration:**
- Load products: SupabaseService.getProducts()
- Filter by category
- Pull-to-refresh

**Offline Fallback:**
- Dummy products jika fetch gagal

**Notifications:**
- NotificationPopup saat error/success

---

### Detail Produk Screen
**Supabase Integration:**
- Check favorite status: SupabaseService.isFavorite()
- Toggle favorite: SupabaseService.toggleFavorite()
- Add to cart: SupabaseService.addToCart()

**Offline Fallback:**
- Local state untuk favorites & cart

**Notifications:**
- Popup saat add favorite
- Popup saat add to cart
- Snackbar dengan "Lihat Keranjang" button

---

### Cart Screen
**Supabase Integration:**
- Load cart: SupabaseService.getCartItems()
- Update quantity: SupabaseService.updateCartQuantity()
- Remove item: SupabaseService.removeFromCart()
- Create order: SupabaseService.createOrder()

**Offline Fallback:**
- Local cart state di AppState

**Notifications:**
- Popup saat tambah/kurangi quantity
- Popup saat remove item
- Popup saat checkout sukses
- Success dialog dengan navigate to orders

**Payment Methods:**
- E-Wallet (OVO, GoPay, Dana, ShopeePay)
- Transfer Bank (BCA, Mandiri, BRI, BNI)
- QRIS
- Cash di Tempat

---

### Orders Screen
**Tabs:**
1. **Keranjang** - Cart items (before checkout)
2. **Di Proses** - Order status: processing
3. **Dibuat** - Order status: created
4. **Siap Diambil** - Order status: ready_pickup
5. **Selesai** - Order status: completed
6. **Dibatalkan** ⭐ NEW - Order status: cancelled

**Supabase Integration:**
- Load orders: SupabaseService.getOrders()
- Cancel order: SupabaseService.cancelOrder()

**Status Flow:**
\\\
cart → processing → created → ready_pickup → completed
                ↓
           cancelled
\\\

**Merchant Validation:**
- Status hanya bisa diubah oleh merchant via merchant_page
- Customer hanya bisa cancel order di status "processing" atau "created"

---

### Profile Screen
**Supabase Integration:**
- Load profile: SupabaseService.getUserProfile()
- Update profile: SupabaseService.updateUserProfile()
- Logout: Supabase.client.auth.signOut()

**Editable Fields:**
- Nama Lengkap
- Email
- No. HP
- Alamat
- Avatar (UI ready, upload pending)

**Notifications:**
- Snackbar saat save success/error
- NotificationPopup saat profile updated

---

## 🎨 UI Components

### Notification Popup
\\\dart
NotificationPopup.show(
  context,
  title: 'Judul Notifikasi',
  message: 'Pesan detail',
  icon: Icons.check_circle,
  color: AppColors.primary,
  duration: Duration(seconds: 3),
);
\\\

**Features:**
- Slide & fade animation
- Auto-dismiss
- Tap to dismiss
- Custom icon & color
- Stack management (max 1 active)

---

## 🔄 State Management

### AppState (Provider)
**Properties:**
- cartItems - List<CartItem>
- avoriteItems - List<FoodItem>
- orders - List<OrderItem>
- 
otifications - List<NotificationItem>

**Methods:**
- ddToCart(FoodItem)
- emoveCartItem(String id)
- 	oggleFavorite(FoodItem)
- ddOrderFromCart()
- cancelOrder(String code, String reason)
- pushNotification(...)

---

## 📊 Data Flow

### Add to Cart Flow
\\\
User taps "Tambah" di Detail Produk
  ↓
Check isAuthenticated?
  ├─ Yes: SupabaseService.addToCart() → Supabase cart_items table
  └─ No: AppState.addToCart() → Local state
  ↓
Show NotificationPopup
  ↓
Show Snackbar dengan "Lihat Keranjang"
\\\

### Checkout Flow
\\\
User di Cart Screen, tap "Bayar Sekarang"
  ↓
Validate cart not empty
  ↓
Check isAuthenticated?
  ├─ Yes: SupabaseService.createOrder()
  │        ↓
  │     Insert to orders table
  │        ↓
  │     Insert to order_items table
  │        ↓
  │     Clear cart_items table
  │        ↓
  │     Create notification for customer & merchant
  └─ No: AppState.addOrderFromCart() → Local state
  ↓
Show Success Dialog
  ↓
Navigate to Orders Tab
\\\

### Favorite Flow
\\\
User tap favorite icon
  ↓
Check isAuthenticated?
  ├─ Yes: SupabaseService.toggleFavorite()
  │        ↓
  │     Check existing in favorites table
  │        ├─ Exists: DELETE from favorites
  │        └─ Not exists: INSERT into favorites
  └─ No: AppState.toggleFavorite() → Local state
  ↓
Show NotificationPopup (added/removed)
\\\

---

## 🔐 Security

### Row Level Security (RLS)
Semua tables harus enable RLS untuk security:
- Users hanya bisa akses data mereka sendiri
- Products bisa diakses public (read-only untuk approved)
- Orders hanya bisa dilihat oleh customer & merchant terkait

### API Keys
- **NEVER** commit supabase_config.dart dengan real credentials
- Add to .gitignore:
\\\
lib/customer_page/config/supabase_config.dart
\\\

---

## 🐛 Troubleshooting

### "Supabase connection failed"
- Cek supabaseUrl dan supabaseAnonKey di config
- Cek internet connection
- Aplikasi otomatis fallback ke offline mode

### "RLS policy error"
- Enable RLS policies untuk tables
- Cek user sudah login (auth.uid() tidak null)

### "Products tidak muncul"
- Cek products.is_active = true
- Cek products.approval_status = 'approved'
- Cek RLS policy untuk products table

### "Order tidak bisa dibuat"
- Cek user sudah login
- Cek cart tidak kosong
- Cek RLS policy untuk orders table

---

## 📈 Performance Tips

### Pagination
Implementasi pagination untuk products:
\\\dart
final products = await supabase
  .from('products')
  .select()
  .range(0, 19) // Load 20 items
  .order('created_at', ascending: false);
\\\

### Caching
Gunakan shared_preferences untuk cache:
- Recent products
- User profile
- Cart items

### Image Optimization
- Upload images 1024x1024
- Use CDN dari Supabase Storage
- Lazy load images dengan cached_network_image

---

## 🚀 Deployment

### Build APK
\\\ash
flutter build apk --release -t lib/main_customer_page.dart
\\\

### Build iOS
\\\ash
flutter build ios --release -t lib/main_customer_page.dart
\\\

### Environment Variables
Untuk production, gunakan environment variables:
\\\dart
// supabase_config.dart
class SupabaseConfig {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://default.supabase.co',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'default-key',
  );
}
\\\

Build dengan env:
\\\ash
flutter build apk --release \
  --dart-define=SUPABASE_URL=your-url \
  --dart-define=SUPABASE_ANON_KEY=your-key \
  -t lib/main_customer_page.dart
\\\

---

## 📞 Support

Jika ada kendala atau pertanyaan:
1. Cek CUSTOMER_PAGE_CHANGELOG.md untuk fitur lengkap
2. Cek analisis_customer_page.md untuk struktur kode
3. Hubungi tim development

**Happy Coding! 🎉**
