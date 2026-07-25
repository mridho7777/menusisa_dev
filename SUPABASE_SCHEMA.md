# MenuSisa - Supabase Database Schema

## Database Tables Structure

### 1. merchants
Tabel untuk menyimpan data merchant/penjual

```sql
CREATE TABLE merchants (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  merchant_id VARCHAR(50) UNIQUE NOT NULL,
  shop_name VARCHAR(255) NOT NULL,
  owner_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  phone VARCHAR(20) NOT NULL,
  status VARCHAR(20) DEFAULT 'Pending',
  address TEXT,
  city VARCHAR(100),
  province VARCHAR(100),
  postal_code VARCHAR(10),
  total_products INTEGER DEFAULT 0,
  total_sales DECIMAL(15,2) DEFAULT 0,
  registered_at TIMESTAMP DEFAULT NOW(),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

### 2. customers
Tabel untuk menyimpan data customer/pembeli

```sql
CREATE TABLE customers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  customer_id VARCHAR(50) UNIQUE NOT NULL,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  phone VARCHAR(20) NOT NULL,
  account_status VARCHAR(20) DEFAULT 'Aktif',
  join_date TIMESTAMP DEFAULT NOW(),
  total_orders INTEGER DEFAULT 0,
  total_spent DECIMAL(15,2) DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

### 3. products
Tabel untuk menyimpan data produk

```sql
CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  product_id VARCHAR(50) UNIQUE NOT NULL,
  merchant_id UUID REFERENCES merchants(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  category VARCHAR(100) NOT NULL,
  price DECIMAL(15,2) NOT NULL,
  stock INTEGER DEFAULT 0,
  status VARCHAR(20) DEFAULT 'Aktif',
  image_url TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

### 4. transactions
Tabel untuk menyimpan data transaksi

```sql
CREATE TABLE transactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  transaction_id VARCHAR(50) UNIQUE NOT NULL,
  customer_id UUID REFERENCES customers(id) ON DELETE SET NULL,
  merchant_id UUID REFERENCES merchants(id) ON DELETE SET NULL,
  total_amount DECIMAL(15,2) NOT NULL,
  status VARCHAR(20) DEFAULT 'Pending',
  payment_status VARCHAR(20) DEFAULT 'Unpaid',
  order_date TIMESTAMP DEFAULT NOW(),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

### 5. payments
Tabel untuk menyimpan data pembayaran

```sql
CREATE TABLE payments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  payment_id VARCHAR(50) UNIQUE NOT NULL,
  transaction_id UUID REFERENCES transactions(id) ON DELETE CASCADE,
  merchant_id UUID REFERENCES merchants(id) ON DELETE SET NULL,
  amount DECIMAL(15,2) NOT NULL,
  payment_method VARCHAR(50) NOT NULL,
  payment_status VARCHAR(20) DEFAULT 'Pending',
  paid_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

### 6. revenues
Tabel untuk menyimpan data revenue

```sql
CREATE TABLE revenues (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  merchant_id UUID REFERENCES merchants(id) ON DELETE CASCADE,
  merchant_name VARCHAR(255) NOT NULL,
  period_date DATE NOT NULL,
  amount DECIMAL(15,2) DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

### 7. notifications
Tabel untuk menyimpan notifikasi

```sql
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID,
  type VARCHAR(50) NOT NULL,
  title VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### 8. activity_logs
Tabel untuk menyimpan log aktivitas

```sql
CREATE TABLE activity_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID,
  user_name VARCHAR(255) NOT NULL,
  action VARCHAR(100) NOT NULL,
  description TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);
```

## Setup Instructions

1. Buat project baru di Supabase
2. Copy SQL schema di atas ke SQL Editor
3. Update konfigurasi dengan SUPABASE_URL dan SUPABASE_ANON_KEY
4. Toggle mode Supabase di aplikasi

