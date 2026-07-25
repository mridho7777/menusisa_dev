# MenuSisa - Integration Documentation

## 📋 Overview

Dokumentasi ini menjelaskan integrasi lengkap untuk 14 halaman MenuSisa Super Admin Dashboard dengan:
- ✅ State Management (Provider)
- ✅ Local Storage (SharedPreferences)
- ✅ Persiapan Supabase Integration
- ✅ Action Helpers & Logging
- ✅ Common Dialogs & Widgets

## 🏗️ Struktur Arsitektur

```
┌─────────────────────────────────────────┐
│         UI Layer (14 Pages)             │
│  - Dashboard                            │
│  - Merchant Management                  │
│  - Customer Management                  │
│  - Product Management                   │
│  - Transaction Management               │
│  - Payment Monitoring                   │
│  - Merchant Revenue                     │
│  - Notifications                        │
│  - Activity Logs                        │
│  - System Settings                      │
│  - Profile                              │
│  - dll                                  │
└─────────────┬───────────────────────────┘
              │
┌─────────────▼───────────────────────────┐
│      Provider Layer (State Mgmt)        │
│  - MerchantProvider                     │
│  - CustomerProvider                     │
│  - ProductProvider                      │
│  - TransactionProvider                  │
│  - PaymentProvider                      │
│  - RevenueProvider                      │
│  - NotificationsProvider                │
│  - ActivityLogProvider                  │
│  - SystemSettingsProvider               │
└─────────────┬───────────────────────────┘
              │
┌─────────────▼───────────────────────────┐
│       Service Layer                     │
│  - DataSyncService                      │
│  - LocalStorageService                  │
│  - SupabaseService                      │
└─────────────┬───────────────────────────┘
              │
    ┌─────────┴─────────┐
    │                   │
┌───▼────┐      ┌───────▼────┐
│ Local  │      │  Supabase  │
│Storage │      │   Cloud    │
└────────┘      └────────────┘
```

## 📦 Providers yang Sudah Dibuat

### 1. MerchantProvider
**File**: `lib/super_admin/providers/merchant_provider.dart`
**Storage Key**: `StorageKeys.merchants`
**Supabase Table**: `merchants`

**Methods**:
- `loadMerchants()` - Load all merchants
- `addMerchant(merchant)` - Add new merchant
- `updateMerchant(id, merchant)` - Update merchant
- `deleteMerchant(id)` - Delete merchant
- `approveMerchant(id)` - Approve pending merchant
- `suspendMerchant(id)` - Suspend active merchant
- `deactivateMerchant(id)` - Deactivate merchant
- `setSearchQuery(query)` - Filter by search
- `setStatusFilter(status)` - Filter by status

**Properties**:
- `merchants` - List of all merchants
- `filteredMerchants` - Filtered list
- `isLoading` - Loading state
- `error` - Error message

### 2. CustomerProvider
**File**: `lib/super_admin/providers/customer_provider.dart`
**Storage Key**: `StorageKeys.customers`
**Supabase Table**: `customers`

**Methods**:
- `loadCustomers()`
- `addCustomer(customer)`
- `updateCustomer(id, customer)`
- `deleteCustomer(id)`
- `setSearchQuery(query)`
- `setStatusFilter(status)`

### 3. ProductProvider
**File**: `lib/super_admin/providers/product_provider.dart`
**Storage Key**: `StorageKeys.products`
**Supabase Table**: `products`

**Methods**:
- `loadProducts()`
- `addProduct(product)`
- `updateProduct(id, product)`
- `deleteProduct(id)`
- `setSearchQuery(query)`
- `setCategoryFilter(category)`

### 4. TransactionProvider
**File**: `lib/super_admin/providers/transaction_provider.dart`
**Storage Key**: `StorageKeys.transactions`
**Supabase Table**: `transactions`

**Methods**:
- `loadTransactions()`
- `addTransaction(transaction)`
- `updateTransaction(id, transaction)`
- `deleteTransaction(id)`
- `updateTransactionStatus(id, status)`
- `setSearchQuery(query)`
- `setStatusFilter(status)`

### 5. PaymentProvider
**File**: `lib/super_admin/providers/payment_provider.dart`
**Storage Key**: `StorageKeys.payments`
**Supabase Table**: `payments`

**Methods**:
- `loadPayments()`
- `addPayment(payment)`
- `updatePayment(id, payment)`
- `deletePayment(id)`
- `verifyPayment(id)`
- `refundPayment(id, reason)`
- `setSearchQuery(query)`
- `setStatusFilter(status)`
- `setMethodFilter(method)`

### 6. RevenueProvider
**File**: `lib/super_admin/providers/revenue_provider.dart`
**Storage Key**: `StorageKeys.revenues`
**Supabase Table**: `revenues`

**Methods**:
- `loadRevenues()`
- `addRevenue(revenue)`
- `updateRevenue(id, revenue)`
- `setSearchQuery(query)`
- `setPeriodFilter(period)`

**Properties**:
- `totalRevenue` - Calculate total
- `revenueByMerchant` - Group by merchant

### 7. NotificationsProvider
**File**: `lib/super_admin/providers/notifications_provider.dart`
**Storage Key**: `StorageKeys.notifications`
**Supabase Table**: `notifications`

**Methods**:
- `loadNotifications()`
- `addNotification(notification)`
- `markAsRead(id)`
- `markAllAsRead()`
- `deleteNotification(id)`
- `setTypeFilter(type)`
- `setShowOnlyUnread(bool)`

**Properties**:
- `unreadCount` - Count unread notifications

### 8. ActivityLogProvider
**File**: `lib/super_admin/providers/activity_log_provider.dart`
**Storage Key**: `StorageKeys.activityLogs`
**Supabase Table**: `activity_logs`

**Methods**:
- `loadLogs()`
- `addLog(log)`
- `logAction(userId, userName, action, description)`
- `setSearchQuery(query)`
- `setActionFilter(action)`
- `setUserFilter(user)`

**Properties**:
- `uniqueUsers` - List of unique users
- `uniqueActions` - List of unique actions

### 9. SystemSettingsProvider
**File**: `lib/super_admin/providers/system_settings_provider.dart`
**Storage Key**: `StorageKeys.systemSettings`

**Methods**:
- `loadSettings()`
- `saveSettings(settings)`
- `updateSetting(key, value)`
- `getSetting(key, defaultValue)`
- `setMaintenanceMode(bool)`
- `setAllowRegistration(bool)`
- `setEnableNotifications(bool)`
- `setCommissionRate(rate)`
- `setSmtpSettings(...)`
- `resetToDefaults()`

## 🛠️ Helper Classes

### ActionHelper
**File**: `lib/super_admin/core/helpers/action_helper.dart`

Membantu eksekusi aksi dengan logging otomatis:

```dart
await ActionHelper.executeAction(
  context: context,
  action: () => provider.deleteMerchant(id),
  actionName: 'Hapus Merchant',
  entityType: 'merchant',
  entityId: id,
  successMessage: 'Merchant berhasil dihapus',
);
```

### CommonDialogs
**File**: `lib/super_admin/shared/widgets/common_dialogs.dart`

Dialog reusable untuk berbagai kebutuhan:

```dart
// Form dialog
final result = await CommonDialogs.showFormDialog(
  context: context,
  title: 'Tambah Merchant',
  fields: [...],
);

// Confirm dialog
final confirmed = await CommonDialogs.showConfirmDialog(
  context: context,
  title: 'Hapus Data',
  message: 'Yakin ingin menghapus?',
  isDangerous: true,
);

// Success dialog
await CommonDialogs.showSuccessDialog(
  context: context,
  title: 'Berhasil',
  message: 'Data berhasil disimpan',
);
```

## 🗄️ Services

### LocalStorageService
**File**: `lib/super_admin/core/services/local_storage_service.dart`

Mengelola penyimpanan data lokal menggunakan SharedPreferences:

```dart
// Save data
await LocalStorageService.instance.saveData('key', data);

// Get data
final data = await LocalStorageService.instance.getData('key');

// Save list
await LocalStorageService.instance.saveList('key', listData);

// Get list
final list = await LocalStorageService.instance.getList('key');
```

### DataSyncService
**File**: `lib/super_admin/core/services/data_sync_service.dart`

Menjembatani local storage dan Supabase:

```dart
// Toggle mode
DataSyncService.instance.setSupabaseMode(true); // atau false

// Fetch data (otomatis pilih source)
final data = await DataSyncService.instance.fetchData(
  'storage_key',
  'supabase_table',
);

// Add item
await DataSyncService.instance.addItem(
  'storage_key',
  'supabase_table',
  itemData,
);
```

### SupabaseService
**File**: `lib/super_admin/core/services/supabase_service.dart`

Service untuk koneksi Supabase (sudah ada):

```dart
// Initialize
await SupabaseService.initialize(
  supabaseUrl: 'YOUR_URL',
  supabaseAnonKey: 'YOUR_KEY',
);

// Use
final data = await SupabaseService.instance.getAll('table');
```

## 📝 Cara Implementasi di Halaman

### Step 1: Import Dependencies

```dart
import 'package:provider/provider.dart';
import '../../providers/merchant_provider.dart';
import '../helpers/action_helper.dart';
import '../../shared/widgets/common_dialogs.dart';
```

### Step 2: Load Data di initState

```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<MerchantProvider>().loadMerchants();
  });
}
```

### Step 3: Watch Provider di Build

```dart
@override
Widget build(BuildContext context) {
  final provider = context.watch<MerchantProvider>();
  
  // Handle loading
  if (provider.isLoading) {
    return Center(child: CircularProgressIndicator());
  }
  
  // Handle error
  if (provider.error != null) {
    return Center(child: Text('Error: ${provider.error}'));
  }
  
  // Show data
  return ListView.builder(
    itemCount: provider.filteredMerchants.length,
    itemBuilder: (context, index) {
      final item = provider.filteredMerchants[index];
      return ListTile(title: Text(item.shopName));
    },
  );
}
```

### Step 4: Implementasi Aksi CRUD

```dart
// Add
await ActionHelper.executeAction(
  context: context,
  action: () => provider.addMerchant(merchant),
  actionName: 'Tambah Merchant',
  entityType: 'merchant',
);

// Update
await provider.updateMerchant(id, updatedData);

// Delete
final confirmed = await CommonDialogs.showConfirmDialog(
  context: context,
  title: 'Hapus',
  message: 'Yakin ingin menghapus?',
  isDangerous: true,
);
if (confirmed) {
  await provider.deleteMerchant(id);
}
```

## 🔧 Konfigurasi

### pubspec.yaml
Pastikan dependencies sudah ditambahkan:

```yaml
dependencies:
  provider: ^6.1.5
  shared_preferences: ^2.3.4
  supabase_flutter: ^2.9.1
```

### main.dart
Semua provider sudah di-register:

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => MerchantProvider()),
    ChangeNotifierProvider(create: (_) => CustomerProvider()),
    ChangeNotifierProvider(create: (_) => ProductProvider()),
    // ... dll
  ],
  child: MaterialApp.router(...),
)
```

## 🚀 Mode Operasi

### Mode 1: Local Storage (Development)
```dart
// Tidak perlu konfigurasi, default mode
DataSyncService.instance.setSupabaseMode(false);
```

Data disimpan di SharedPreferences, cocok untuk:
- Development
- Testing
- Offline mode
- Demo

### Mode 2: Supabase (Production)
```dart
// Initialize Supabase
await SupabaseService.initialize(
  supabaseUrl: 'https://your-project.supabase.co',
  supabaseAnonKey: 'your-anon-key',
);

// Enable Supabase mode
DataSyncService.instance.setSupabaseMode(true);
```

Data disimpan di cloud, cocok untuk:
- Production
- Multi-user
- Real-time sync

## 📊 Database Schema

Lihat file `SUPABASE_SCHEMA.md` untuk:
- Table structures
- Indexes
- Row Level Security
- Triggers
- Setup instructions

## 📚 Dokumentasi Tambahan

1. **SUPABASE_SCHEMA.md** - Database schema lengkap
2. **INTEGRATION_GUIDE.md** - Panduan integrasi detail
3. **.env.example** - Template environment variables

## ✅ Checklist Integrasi per Halaman

### ✅ Sudah Terintegrasi
- [x] Local Storage Service
- [x] Data Sync Service
- [x] Supabase Service
- [x] All Providers (9 providers)
- [x] Action Helper
- [x] Common Dialogs
- [x] Main.dart configuration

### 🔄 Perlu Implementasi di UI
Untuk setiap halaman, replace hardcoded data dengan provider:

1. **Dashboard** - Gunakan DashboardController (sudah ada)
2. **Merchant Management** - Gunakan MerchantProvider
3. **Customer Management** - Gunakan CustomerProvider
4. **Product Management** - Gunakan ProductProvider
5. **Transaction Management** - Gunakan TransactionProvider
6. **Payment Monitoring** - Gunakan PaymentProvider
7. **Merchant Revenue** - Gunakan RevenueProvider
8. **Notifications** - Gunakan NotificationsProvider
9. **Activity Logs** - Gunakan ActivityLogProvider
10. **System Settings** - Gunakan SystemSettingsProvider
11. **Profile** - Gunakan AuthProvider atau local storage
12-14. **Other Pages** - Implementasi sesuai kebutuhan

## 🎯 Next Steps

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Update Setiap Halaman**
   - Ganti hardcoded data dengan provider
   - Hubungkan tombol aksi dengan method provider
   - Tambahkan loading & error states

3. **Setup Supabase (Opsional)**
   - Buat project di Supabase
   - Run SQL schema
   - Update konfigurasi
   - Toggle Supabase mode

4. **Testing**
   - Test CRUD operations
   - Test filters & search
   - Test error handling
   - Test dengan Supabase

## 💡 Tips

1. Selalu gunakan ActionHelper untuk aksi penting (auto logging)
2. Gunakan CommonDialogs untuk konsistensi UI
3. Handle loading & error states
4. Validate input sebelum save
5. Confirm dangerous actions
6. Test dengan local storage dulu sebelum Supabase

## 🆘 Troubleshooting

**Data tidak muncul?**
- Cek provider sudah di-register di main.dart
- Cek loadData() sudah dipanggil
- Periksa console untuk error

**Data tidak tersimpan?**
- Cek LocalStorage sudah initialized
- Pastikan StorageKey benar
- Periksa error message

**Supabase error?**
- Verify URL dan API key
- Cek RLS policies
- Pastikan table schema match

---

**Created**: 2026-06-27
**Version**: 1.0.0
**Status**: ✅ Ready for Implementation
