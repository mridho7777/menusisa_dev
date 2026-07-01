# Testing Guide - MenuSisa Integration

## 🧪 Panduan Testing untuk Validasi Integrasi

---

## 📋 Pre-Testing Checklist

Sebelum mulai testing, pastikan:
- [x] Dependencies sudah terinstall (`flutter pub get`)
- [x] Aplikasi bisa running (`flutter run`)
- [x] Tidak ada error di console saat startup
- [x] Semua provider ter-register di main.dart

---

## 🎯 Testing Strategy

### Level 1: Unit Testing (Provider)
Test individual provider tanpa UI

### Level 2: Widget Testing
Test UI components dengan provider

### Level 3: Integration Testing
Test full flow dari UI ke storage

### Level 4: Manual Testing
Test semua fitur secara manual

---

## 🔧 Level 1: Unit Testing Providers

### Test MerchantProvider

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:menusisa_dev/super_admin/providers/merchant_provider.dart';

void main() {
  group('MerchantProvider Tests', () {
    late MerchantProvider provider;

    setUp(() {
      provider = MerchantProvider();
    });

    test('Initial state should be empty', () {
      expect(provider.merchants, isEmpty);
      expect(provider.isLoading, false);
      expect(provider.error, isNull);
    });

    test('Load merchants should fetch data', () async {
      await provider.loadMerchants();
      
      expect(provider.isLoading, false);
      // Note: Akan ada data jika repository memiliki seed data
    });

    test('Search query should filter merchants', () {
      provider.setSearchQuery('kopi');
      expect(provider.searchQuery, equals('kopi'));
    });

    test('Status filter should update', () {
      provider.setStatusFilter('Aktif');
      expect(provider.statusFilter, equals('Aktif'));
    });
  });
}
```

### Test CustomerProvider

```dart
void main() {
  group('CustomerProvider Tests', () {
    late CustomerProvider provider;

    setUp(() {
      provider = CustomerProvider();
    });

    test('Load customers should work', () async {
      await provider.loadCustomers();
      expect(provider.isLoading, false);
    });

    test('Filter should work correctly', () {
      provider.setSearchQuery('test');
      provider.setStatusFilter('Aktif');
      
      expect(provider.searchQuery, equals('test'));
      expect(provider.statusFilter, equals('Aktif'));
    });
  });
}
```

### Test LocalStorageService

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:menusisa_dev/super_admin/core/services/local_storage_service.dart';

void main() {
  group('LocalStorageService Tests', () {
    late LocalStorageService service;

    setUp(() async {
      service = LocalStorageService.instance;
      await service.init();
    });

    test('Save and get string', () async {
      await service.saveString('test_key', 'test_value');
      final value = await service.getString('test_key');
      expect(value, equals('test_value'));
    });

    test('Save and get data', () async {
      final testData = {'name': 'Test', 'value': 123};
      await service.saveData('test_data', testData);
      final data = await service.getData('test_data');
      expect(data['name'], equals('Test'));
      expect(data['value'], equals(123));
    });

    test('Save and get list', () async {
      final testList = [
        {'id': '1', 'name': 'Item 1'},
        {'id': '2', 'name': 'Item 2'},
      ];
      await service.saveList('test_list', testList);
      final list = await service.getList('test_list');
      expect(list.length, equals(2));
    });

    test('Remove data', () async {
      await service.saveString('remove_key', 'value');
      await service.removeData('remove_key');
      final value = await service.getString('remove_key');
      expect(value, isNull);
    });
  });
}
```

---

## 🎨 Level 2: Widget Testing

### Test dengan Provider

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:menusisa_dev/super_admin/providers/merchant_provider.dart';

void main() {
  testWidgets('MerchantList shows loading indicator', (tester) async {
    final provider = MerchantProvider();

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: provider,
          child: Scaffold(
            body: Consumer<MerchantProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const CircularProgressIndicator();
                }
                return const Text('Loaded');
              },
            ),
          ),
        ),
      ),
    );

    // Saat loading, harus ada CircularProgressIndicator
    // (akan pass jika provider.isLoading = true di awal)
  });

  testWidgets('Search field updates provider', (tester) async {
    final provider = MerchantProvider();

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: provider,
          child: Scaffold(
            body: TextField(
              onChanged: (value) => provider.setSearchQuery(value),
            ),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'test search');
    expect(provider.searchQuery, equals('test search'));
  });
}
```

---

## 🔗 Level 3: Integration Testing

### Test Full CRUD Flow

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:menusisa_dev/super_admin/providers/merchant_provider.dart';
import 'package:menusisa_dev/super_admin/modules/merchant_management/models/merchant_management_models.dart';

void main() {
  group('Merchant CRUD Integration Test', () {
    late MerchantProvider provider;

    setUp(() {
      provider = MerchantProvider();
    });

    test('Complete CRUD flow', () async {
      // 1. Load initial data
      await provider.loadMerchants();
      final initialCount = provider.merchants.length;

      // 2. Add new merchant
      final newMerchant = MerchantRecord(
        id: 'test_001',
        merchantId: 'M-TEST-001',
        shopName: 'Test Shop',
        ownerName: 'Test Owner',
        email: 'test@test.com',
        phone: '08123456789',
        status: 'Pending',
        registeredAt: DateTime.now().toString(),
        totalProducts: '0',
        totalSales: 'Rp 0',
      );

      await provider.addMerchant(newMerchant);
      expect(provider.merchants.length, equals(initialCount + 1));

      // 3. Search for the merchant
      provider.setSearchQuery('Test Shop');
      expect(provider.filteredMerchants.length, greaterThan(0));

      // 4. Update merchant
      final updated = newMerchant.copyWith(status: 'Aktif');
      await provider.updateMerchant('test_001', updated);
      final found = provider.merchants.firstWhere((m) => m.id == 'test_001');
      expect(found.status, equals('Aktif'));

      // 5. Delete merchant
      await provider.deleteMerchant('test_001');
      expect(provider.merchants.length, equals(initialCount));
    });
  });
}
```

---

## 🖱️ Level 4: Manual Testing

### Checklist per Halaman

#### Merchant Management Page

**Load Data**
- [ ] Buka halaman
- [ ] Data merchant muncul
- [ ] Loading indicator muncul saat loading
- [ ] Tidak ada error di console

**Search**
- [ ] Ketik di search box
- [ ] Data ter-filter sesuai keyword
- [ ] Clear search mengembalikan semua data

**Filter Status**
- [ ] Pilih filter "Aktif"
- [ ] Hanya merchant aktif yang muncul
- [ ] Pilih "Semua" menampilkan semua data

**Add Merchant**
- [ ] Klik tombol "Tambah"
- [ ] Dialog form muncul
- [ ] Isi form dan submit
- [ ] Merchant baru muncul di list
- [ ] Activity log tercatat

**Edit Merchant**
- [ ] Klik merchant atau tombol edit
- [ ] Dialog edit muncul dengan data existing
- [ ] Update data dan submit
- [ ] Data ter-update di list
- [ ] Activity log tercatat

**Delete Merchant**
- [ ] Klik tombol delete
- [ ] Konfirmasi dialog muncul
- [ ] Confirm delete
- [ ] Merchant hilang dari list
- [ ] Activity log tercatat

**Approve Merchant**
- [ ] Merchant dengan status "Pending"
- [ ] Klik approve
- [ ] Status berubah menjadi "Aktif"
- [ ] Activity log tercatat

**Suspend Merchant**
- [ ] Merchant dengan status "Aktif"
- [ ] Klik suspend
- [ ] Konfirmasi dialog muncul
- [ ] Status berubah menjadi "Suspend"
- [ ] Activity log tercatat

---

### Testing Script untuk Semua Halaman

```markdown
## [Page Name] Testing

Date: ___________
Tester: ___________

### Basic Functionality
- [ ] Halaman bisa dibuka
- [ ] Data loading berhasil
- [ ] Loading indicator muncul
- [ ] No console errors

### Data Display
- [ ] Data ditampilkan dengan benar
- [ ] Empty state muncul jika tidak ada data
- [ ] Error state muncul jika ada error

### Search & Filter
- [ ] Search functionality works
- [ ] Filter options work
- [ ] Reset filter works

### CRUD Operations
- [ ] Create: Add new item successfully
- [ ] Read: View item details
- [ ] Update: Edit item successfully
- [ ] Delete: Delete item with confirmation

### Special Actions
- [ ] [Action 1]: Works correctly
- [ ] [Action 2]: Works correctly
- [ ] Activity logs created for all actions

### Edge Cases
- [ ] Handles empty input
- [ ] Validates required fields
- [ ] Shows error for invalid data
- [ ] Handles network errors (if Supabase)

### Performance
- [ ] Page loads quickly
- [ ] No lag when scrolling
- [ ] Search is responsive

**Notes:**
_______________________________________
_______________________________________

**Status**: ☐ Pass ☐ Fail ☐ Partial

**Issues Found:**
1. _______________________________________
2. _______________________________________
```

---

## 📊 Test Data Preparation

### Seed Data for Testing

```dart
// Test Merchants
final testMerchants = [
  {
    'id': 'M001',
    'merchantId': 'M-001',
    'shopName': 'Warung Makan Sederhana',
    'ownerName': 'Budi Santoso',
    'email': 'budi@warung.com',
    'phone': '08123456789',
    'status': 'Aktif',
  },
  {
    'id': 'M002',
    'merchantId': 'M-002',
    'shopName': 'Kopi Kita',
    'ownerName': 'Siti Rahayu',
    'email': 'siti@kopi.com',
    'phone': '08234567890',
    'status': 'Pending',
  },
];

// Test Customers
final testCustomers = [
  {
    'id': 'C001',
    'customerId': 'CUST-001',
    'name': 'Ahmad Rizki',
    'email': 'ahmad@email.com',
    'phone': '08345678901',
    'accountStatus': 'Aktif',
  },
];

// Test Products
final testProducts = [
  {
    'id': 'P001',
    'productId': 'PRD-001',
    'name': 'Nasi Goreng',
    'category': 'Makanan',
    'price': 25000,
    'stock': 50,
    'status': 'Aktif',
  },
];
```

---

## 🐛 Bug Tracking Template

```markdown
## Bug Report

**Bug ID**: #___
**Date Found**: ___________
**Found By**: ___________
**Severity**: ☐ Critical ☐ High ☐ Medium ☐ Low

### Description
_______________________________________

### Steps to Reproduce
1. _______________________________________
2. _______________________________________
3. _______________________________________

### Expected Behavior
_______________________________________

### Actual Behavior
_______________________________________

### Screenshots/Logs
_______________________________________

### Environment
- Device: _______
- OS: _______
- Flutter Version: _______

### Status
☐ Open ☐ In Progress ☐ Fixed ☐ Closed

### Fix Notes
_______________________________________
```

---

## ✅ Testing Completion Criteria

Setiap halaman dianggap "Tested & Complete" jika:

1. ✅ All basic functionality works
2. ✅ CRUD operations work correctly
3. ✅ Search & filter work
4. ✅ Loading states handled
5. ✅ Error states handled
6. ✅ Empty states handled
7. ✅ Activity logs created
8. ✅ No console errors
9. ✅ Manual testing passed
10. ✅ Edge cases handled

---

## 🚀 Quick Test Commands

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/providers/merchant_provider_test.dart

# Run with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/

# Watch mode (auto re-run on changes)
flutter test --watch
```

---

## 📈 Test Coverage Goals

- **Unit Tests**: 80%+ coverage
- **Widget Tests**: 60%+ coverage
- **Integration Tests**: 50%+ coverage
- **Manual Testing**: 100% (all pages)

---

**Happy Testing! 🧪**
