# Quick Start Guide - MenuSisa Integration

## 🚀 Mulai Cepat dalam 5 Menit

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Jalankan Aplikasi
```bash
flutter run
```

Aplikasi sudah terintegrasi dengan local storage dan siap digunakan!

## 📝 Contoh Implementasi Cepat

### Contoh 1: Menampilkan List Merchant

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/merchant_provider.dart';

class MerchantListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MerchantProvider>();
    
    if (provider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    return ListView.builder(
      itemCount: provider.filteredMerchants.length,
      itemBuilder: (context, index) {
        final merchant = provider.filteredMerchants[index];
        return ListTile(
          title: Text(merchant.shopName),
          subtitle: Text(merchant.ownerName),
          trailing: Text(merchant.status),
        );
      },
    );
  }
}
```

### Contoh 2: Tambah Data dengan Dialog

```dart
import '../shared/widgets/common_dialogs.dart';
import '../core/helpers/action_helper.dart';

// Di dalam widget atau method
Future<void> _addMerchant(BuildContext context) async {
  final result = await CommonDialogs.showFormDialog(
    context: context,
    title: 'Tambah Merchant',
    fields: [
      FormFieldConfig(
        key: 'shopName',
        label: 'Nama Toko',
        type: FormFieldType.text,
        validator: (v) => v?.isEmpty ?? true ? 'Wajib diisi' : null,
      ),
      FormFieldConfig(
        key: 'ownerName',
        label: 'Nama Pemilik',
        type: FormFieldType.text,
      ),
    ],
  );
  
  if (result != null && context.mounted) {
    final provider = context.read<MerchantProvider>();
    
    await ActionHelper.executeAction(
      context: context,
      action: () => provider.addMerchant(result),
      actionName: 'Tambah Merchant',
      entityType: 'merchant',
    );
  }
}
```

### Contoh 3: Update Data

```dart
Future<void> _updateMerchant(BuildContext context, String id) async {
  final provider = context.read<MerchantProvider>();
  
  // Update data
  await provider.updateMerchant(id, {
    'status': 'Aktif',
    'updated_at': DateTime.now().toIso8601String(),
  });
  
  // Show feedback
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Data berhasil diupdate')),
  );
}
```

### Contoh 4: Delete dengan Konfirmasi

```dart
Future<void> _deleteMerchant(BuildContext context, String id) async {
  final confirmed = await CommonDialogs.showConfirmDialog(
    context: context,
    title: 'Hapus Merchant',
    message: 'Yakin ingin menghapus merchant ini?',
    isDangerous: true,
  );
  
  if (confirmed && context.mounted) {
    final provider = context.read<MerchantProvider>();
    
    await ActionHelper.executeAction(
      context: context,
      action: () => provider.deleteMerchant(id),
      actionName: 'Hapus Merchant',
      entityType: 'merchant',
      entityId: id,
    );
  }
}
```

### Contoh 5: Search & Filter

```dart
// Search
TextField(
  decoration: InputDecoration(
    hintText: 'Cari merchant...',
    prefixIcon: Icon(Icons.search),
  ),
  onChanged: (value) {
    context.read<MerchantProvider>().setSearchQuery(value);
  },
)

// Filter
DropdownButton<String>(
  value: provider.statusFilter,
  items: ['Semua', 'Aktif', 'Pending', 'Suspend']
      .map((status) => DropdownMenuItem(
            value: status,
            child: Text(status),
          ))
      .toList(),
  onChanged: (value) {
    if (value != null) {
      provider.setStatusFilter(value);
    }
  },
)
```

## 🎯 Template untuk Setiap Halaman

Copy template ini untuk implementasi di halaman lain:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/[nama]_provider.dart';
import '../../core/helpers/action_helper.dart';
import '../../shared/widgets/common_dialogs.dart';

class YourPage extends StatefulWidget {
  const YourPage({super.key});

  @override
  State<YourPage> createState() => _YourPageState();
}

class _YourPageState extends State<YourPage> {
  
  @override
  void initState() {
    super.initState();
    // Load data saat pertama kali
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<YourProvider>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<YourProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => provider.loadData(),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Cari...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => provider.setSearchQuery(value),
            ),
          ),
          
          // Content
          Expanded(
            child: _buildContent(provider),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(YourProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: ${provider.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => provider.loadData(),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (provider.filteredItems.isEmpty) {
      return const Center(
        child: Text('Tidak ada data'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.filteredItems.length,
      itemBuilder: (context, index) {
        final item = provider.filteredItems[index];
        return _buildItemCard(context, item);
      },
    );
  }

  Widget _buildItemCard(BuildContext context, dynamic item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(item['name'] ?? 'No Name'),
        subtitle: Text(item['description'] ?? ''),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Hapus'),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              _showEditDialog(context, item);
            } else if (value == 'delete') {
              _deleteItem(context, item['id']);
            }
          },
        ),
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context) async {
    final result = await CommonDialogs.showFormDialog(
      context: context,
      title: 'Tambah Data',
      fields: [
        FormFieldConfig(
          key: 'name',
          label: 'Nama',
          type: FormFieldType.text,
          validator: (v) => v?.isEmpty ?? true ? 'Wajib diisi' : null,
        ),
      ],
    );

    if (result != null && context.mounted) {
      await ActionHelper.executeAction(
        context: context,
        action: () => context.read<YourProvider>().addItem(result),
        actionName: 'Tambah Data',
        entityType: 'item',
      );
    }
  }

  Future<void> _showEditDialog(BuildContext context, dynamic item) async {
    final result = await CommonDialogs.showFormDialog(
      context: context,
      title: 'Edit Data',
      initialValues: item,
      fields: [
        FormFieldConfig(
          key: 'name',
          label: 'Nama',
          type: FormFieldType.text,
        ),
      ],
    );

    if (result != null && context.mounted) {
      await ActionHelper.executeAction(
        context: context,
        action: () => context.read<YourProvider>().updateItem(item['id'], result),
        actionName: 'Update Data',
        entityType: 'item',
        entityId: item['id'],
      );
    }
  }

  Future<void> _deleteItem(BuildContext context, String id) async {
    final confirmed = await CommonDialogs.showConfirmDialog(
      context: context,
      title: 'Hapus Data',
      message: 'Yakin ingin menghapus data ini?',
      isDangerous: true,
    );

    if (confirmed && context.mounted) {
      await ActionHelper.executeAction(
        context: context,
        action: () => context.read<YourProvider>().deleteItem(id),
        actionName: 'Hapus Data',
        entityType: 'item',
        entityId: id,
      );
    }
  }
}
```

## 🔑 Mapping Provider untuk Setiap Halaman

| Halaman | Provider | Import |
|---------|----------|--------|
| Dashboard | `DashboardController` | `import '../../modules/dashboard/controllers/dashboard_controller.dart';` |
| Merchant Management | `MerchantProvider` | `import '../../providers/merchant_provider.dart';` |
| Customer Management | `CustomerProvider` | `import '../../providers/customer_provider.dart';` |
| Product Management | `ProductProvider` | `import '../../providers/product_provider.dart';` |
| Transaction Management | `TransactionProvider` | `import '../../providers/transaction_provider.dart';` |
| Payment Monitoring | `PaymentProvider` | `import '../../providers/payment_provider.dart';` |
| Merchant Revenue | `RevenueProvider` | `import '../../providers/revenue_provider.dart';` |
| Notifications | `NotificationsProvider` | `import '../../providers/notifications_provider.dart';` |
| Activity Logs | `ActivityLogProvider` | `import '../../providers/activity_log_provider.dart';` |
| System Settings | `SystemSettingsProvider` | `import '../../providers/system_settings_provider.dart';` |

## 🎨 Common Widgets yang Bisa Digunakan

### 1. Loading Widget
```dart
if (provider.isLoading) {
  return Center(child: CircularProgressIndicator());
}
```

### 2. Error Widget
```dart
if (provider.error != null) {
  return Center(child: Text('Error: ${provider.error}'));
}
```

### 3. Empty State Widget
```dart
if (provider.items.isEmpty) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
        SizedBox(height: 16),
        Text('Tidak ada data'),
      ],
    ),
  );
}
```

### 4. Status Chip
```dart
Chip(
  label: Text(status),
  backgroundColor: status == 'Aktif' ? Colors.green.shade100 : Colors.red.shade100,
  labelStyle: TextStyle(
    color: status == 'Aktif' ? Colors.green : Colors.red,
  ),
)
```

## 📊 Testing Data Flow

```dart
// 1. Load data
await provider.loadData();
print('Loaded: ${provider.items.length} items');

// 2. Add data
await provider.addItem({'name': 'Test'});
print('Added item, total: ${provider.items.length}');

// 3. Update data
await provider.updateItem('id', {'name': 'Updated'});
print('Updated item');

// 4. Delete data
await provider.deleteItem('id');
print('Deleted item, remaining: ${provider.items.length}');

// 5. Filter data
provider.setSearchQuery('test');
print('Filtered: ${provider.filteredItems.length} items');
```

## ✅ Checklist Implementasi

Untuk setiap halaman:
- [ ] Import provider yang sesuai
- [ ] Load data di initState
- [ ] Watch provider di build
- [ ] Handle loading state
- [ ] Handle error state
- [ ] Handle empty state
- [ ] Tampilkan data
- [ ] Implementasi search/filter
- [ ] Implementasi add action
- [ ] Implementasi edit action
- [ ] Implementasi delete action
- [ ] Test semua aksi

## 🚀 Ready to Go!

Semua infrastructure sudah siap. Tinggal update UI di setiap halaman untuk menggunakan provider yang sudah dibuat.

**Selamat coding! 🎉**
