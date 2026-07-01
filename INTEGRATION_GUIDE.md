# Integration Guide - MenuSisa Super Admin

## Overview
Panduan ini menjelaskan cara mengintegrasikan semua halaman dengan state management, local storage, dan persiapan Supabase.

## Arsitektur

```
┌─────────────────┐
│   UI Layer      │  (Pages/Widgets)
│   (Flutter)     │
└────────┬────────┘
         │
┌────────▼────────┐
│   Providers     │  (State Management)
│   (Provider)    │
└────────┬────────┘
         │
┌────────▼────────┐
│  Data Services  │  (Data Sync Service)
│                 │
└────┬───────┬────┘
     │       │
┌────▼──┐ ┌──▼────┐
│ Local │ │Supabase│
│Storage│ │ (Cloud)│
└───────┘ └────────┘
```

## 14 Halaman yang Sudah Terintegrasi

### 1. Dashboard (`dashboard_page.dart`)
- **Provider**: `DashboardController`
- **Data**: Statistik real-time
- **Aksi**: Refresh data, filter periode

**Contoh Implementasi:**
```dart
final controller = context.watch<DashboardController>();

// Refresh data
ElevatedButton(
  onPressed: () async {
    await controller.loadDashboardData();
  },
  child: Text('Refresh'),
)
```

### 2. Merchant Management (`merchant_management_page.dart`)
- **Provider**: `MerchantProvider`
- **Storage Key**: `StorageKeys.merchants`
- **Supabase Table**: `merchants`
- **Aksi**: Create, Update, Delete, Approve, Suspend

**Contoh Implementasi:**
```dart
final provider = context.watch<MerchantProvider>();

// Add merchant
await ActionHelper.executeAction(
  context: context,
  action: () => provider.addMerchant(merchantData),
  actionName: 'Tambah Merchant',
  entityType: 'merchant',
  successMessage: 'Merchant berhasil ditambahkan',
);

// Approve merchant
await provider.approveMerchant(merchantId);

// Filter
provider.setSearchQuery('search text');
provider.setStatusFilter('Aktif');
```

### 3. Customer Management (`customer_management_page.dart`)
- **Provider**: `CustomerProvider`
- **Storage Key**: `StorageKeys.customers`
- **Supabase Table**: `customers`
- **Aksi**: Create, Update, Delete, Filter

**Contoh Implementasi:**
```dart
final provider = context.watch<CustomerProvider>();

// Add customer
await provider.addCustomer(customerData);

// Update customer
await provider.updateCustomer(customerId, updatedData);

// Delete customer
final confirmed = await CommonDialogs.showConfirmDialog(
  context: context,
  title: 'Hapus Customer',
  message: 'Yakin ingin menghapus customer ini?',
  isDangerous: true,
);
if (confirmed) {
  await provider.deleteCustomer(customerId);
}
```

### 4. Product Management (`product_management_page.dart`)
- **Provider**: `ProductProvider`
- **Storage Key**: `StorageKeys.products`
- **Supabase Table**: `products`
- **Aksi**: Create, Update, Delete, Filter by category

**Contoh Implementasi:**
```dart
final provider = context.watch<ProductProvider>();

// Show add product dialog
final result = await CommonDialogs.showFormDialog(
  context: context,
  title: 'Tambah Produk',
  fields: [
    FormFieldConfig(
      key: 'name',
      label: 'Nama Produk',
      type: FormFieldType.text,
      validator: (v) => v?.isEmpty ?? true ? 'Wajib diisi' : null,
    ),
    FormFieldConfig(
      key: 'price',
      label: 'Harga',
      type: FormFieldType.number,
    ),
    FormFieldConfig(
      key: 'category',
      label: 'Kategori',
      type: FormFieldType.dropdown,
      options: ['Makanan', 'Minuman', 'Snack'],
    ),
  ],
);

if (result != null) {
  await provider.addProduct(result);
}
```

### 5. Transaction Management (`transaction_management_page.dart`)
- **Provider**: `TransactionProvider`
- **Storage Key**: `StorageKeys.transactions`
- **Supabase Table**: `transactions`
- **Aksi**: View, Update Status, Filter

**Contoh Implementasi:**
```dart
final provider = context.watch<TransactionProvider>();

// Update transaction status
await provider.updateTransactionStatus(transactionId, 'Completed');

// Filter by status
provider.setStatusFilter('Pending');
```

### 6. Payment Monitoring (`payment_monitoring_page.dart`)
- **Provider**: `PaymentProvider`
- **Storage Key**: `StorageKeys.payments`
- **Supabase Table**: `payments`
- **Aksi**: Verify, Refund, Filter

**Contoh Implementasi:**
```dart
final provider = context.watch<PaymentProvider>();

// Verify payment
await ActionHelper.executeAction(
  context: context,
  action: () => provider.verifyPayment(paymentId),
  actionName: 'Verifikasi Pembayaran',
  entityType: 'payment',
  entityId: paymentId,
);

// Refund payment
final reason = await ActionHelper.showInputDialog(
  context: context,
  title: 'Alasan Refund',
  label: 'Alasan',
  maxLines: 3,
);
if (reason != null && reason.isNotEmpty) {
  await provider.refundPayment(paymentId, reason);
}
```

### 7. Merchant Revenue (`merchant_revenue_page.dart`)
- **Provider**: `RevenueProvider`
- **Storage Key**: `StorageKeys.revenues`
- **Supabase Table**: `revenues`
- **Aksi**: View, Filter by period, Calculate totals

**Contoh Implementasi:**
```dart
final provider = context.watch<RevenueProvider>();

// Filter by period
provider.setPeriodFilter('Bulan Ini');

// Get totals
final totalRevenue = provider.totalRevenue;
final revenueByMerchant = provider.revenueByMerchant;
```

### 8. Notifications (`notifications_page.dart`)
- **Provider**: `NotificationsProvider`
- **Storage Key**: `StorageKeys.notifications`
- **Supabase Table**: `notifications`
- **Aksi**: Mark as read, Delete, Filter

**Contoh Implementasi:**
```dart
final provider = context.watch<NotificationsProvider>();

// Mark as read
await provider.markAsRead(notificationId);

// Mark all as read
await provider.markAllAsRead();

// Delete notification
await provider.deleteNotification(notificationId);
```

### 9. Activity Logs (`activity_logs_page.dart`)
- **Provider**: `ActivityLogProvider`
- **Storage Key**: `StorageKeys.activityLogs`
- **Supabase Table**: `activity_logs`
- **Aksi**: View, Filter by user/action

**Contoh Implementasi:**
```dart
final provider = context.watch<ActivityLogProvider>();

// Filter
provider.setActionFilter('create');
provider.setUserFilter('Admin Name');

// Get unique filters
final users = provider.uniqueUsers;
final actions = provider.uniqueActions;
```

### 10. System Settings (`system_settings_page.dart`)
- **Provider**: `SystemSettingsProvider`
- **Storage Key**: `StorageKeys.systemSettings`
- **Aksi**: Update settings, Toggle features

**Contoh Implementasi:**
```dart
final provider = context.watch<SystemSettingsProvider>();

// Toggle maintenance mode
await provider.setMaintenanceMode(true);

// Update commission rate
await provider.setCommissionRate(7.5);

// Update SMTP settings
await provider.setSmtpSettings(
  host: 'smtp.gmail.com',
  port: 587,
  username: 'email@example.com',
  password: 'password',
);
```

### 11. Profile (`profile_page.dart`)
- **Provider**: `AuthProvider` (jika ada) atau local storage
- **Storage Key**: `StorageKeys.profileData`
- **Aksi**: View, Update profile

### 12-14. Additional Pages
Ikuti pola yang sama dengan pages di atas.

## Cara Menggunakan di Setiap Halaman

### Step 1: Import Provider
```dart
import 'package:provider/provider.dart';
import '../../providers/[nama_provider].dart';
```

### Step 2: Watch Provider
```dart
final provider = context.watch<ProviderName>();
```

### Step 3: Gunakan Data
```dart
// Show loading
if (provider.isLoading) {
  return CircularProgressIndicator();
}

// Show error
if (provider.error != null) {
  return Text('Error: ${provider.error}');
}

// Show data
ListView.builder(
  itemCount: provider.filteredItems.length,
  itemBuilder: (context, index) {
    final item = provider.filteredItems[index];
    return ListTile(title: Text(item['name']));
  },
)
```

### Step 4: Execute Actions
```dart
// Dengan ActionHelper (recommended)
await ActionHelper.executeAction(
  context: context,
  action: () => provider.deleteItem(id),
  actionName: 'Hapus Item',
  entityType: 'item',
  entityId: id,
);

// Atau langsung
try {
  await provider.addItem(data);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Berhasil ditambahkan')),
  );
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: $e')),
  );
}
```

## Toggle Supabase Mode

### Development (Local Storage)
```dart
// Di main.dart atau settings
DataSyncService.instance.setSupabaseMode(false);
```

### Production (Supabase)
```dart
// Initialize Supabase
await SupabaseService.initialize(
  supabaseUrl: 'YOUR_URL',
  supabaseAnonKey: 'YOUR_KEY',
);

// Enable Supabase mode
DataSyncService.instance.setSupabaseMode(true);
```

## Best Practices

1. **Selalu gunakan ActionHelper** untuk aksi CRUD agar ter-log otomatis
2. **Gunakan CommonDialogs** untuk konsistensi UI
3. **Validate input** sebelum simpan
4. **Handle errors** dengan graceful
5. **Show loading state** saat proses async
6. **Confirm dangerous actions** (delete, suspend, etc)
7. **Log semua aktivitas** penting

## Testing

```dart
// Load data
await provider.loadData();

// Add item
await provider.addItem({'name': 'Test'});

// Verify
expect(provider.items.length, greaterThan(0));
```

## Troubleshooting

### Data tidak muncul
- Pastikan provider sudah di-register di main.dart
- Cek apakah `loadData()` sudah dipanggil
- Periksa error di console

### Data tidak tersimpan
- Cek local storage sudah di-initialize
- Pastikan StorageKey benar
- Periksa error saat save

### Supabase error
- Verify URL dan API key
- Cek RLS policies di Supabase
- Pastikan table schema sesuai
