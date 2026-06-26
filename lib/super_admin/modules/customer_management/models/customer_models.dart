import "package:flutter/material.dart";

class CustomerRecord {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String registeredAt;
  final String totalOrders;
  final String totalSpent;
  final String accountStatus;
  final String customerTag;

  const CustomerRecord({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.registeredAt,
    required this.totalOrders,
    required this.totalSpent,
    required this.accountStatus,
    required this.customerTag,
  });

  CustomerRecord copyWith({
    String? name,
    String? email,
    String? phone,
    String? registeredAt,
    String? totalOrders,
    String? totalSpent,
    String? accountStatus,
    String? customerTag,
  }) {
    return CustomerRecord(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      registeredAt: registeredAt ?? this.registeredAt,
      totalOrders: totalOrders ?? this.totalOrders,
      totalSpent: totalSpent ?? this.totalSpent,
      accountStatus: accountStatus ?? this.accountStatus,
      customerTag: customerTag ?? this.customerTag,
    );
  }
}

class CustomerStat {
  final String title;
  final String value;
  final String delta;
  final int color;
  final IconData icon;

  const CustomerStat({
    required this.title,
    required this.value,
    required this.delta,
    required this.color,
    required this.icon,
  });
}

const customerRecords = [
  CustomerRecord(id: 'CUS-0001', name: 'Andi Wijaya', email: 'andiwijaya@email.com', phone: '0812-3456-7890', registeredAt: '12 Mei 2025', totalOrders: '15', totalSpent: 'Rp 2.450.000', accountStatus: 'Aktif', customerTag: 'VIP'),
  CustomerRecord(id: 'CUS-0002', name: 'Siti Aisyah', email: 'sitiaisyah@email.com', phone: '0821-1234-5678', registeredAt: '11 Mei 2025', totalOrders: '8', totalSpent: 'Rp 1.250.000', accountStatus: 'Aktif', customerTag: 'Regular'),
  CustomerRecord(id: 'CUS-0003', name: 'Budi Santoso', email: 'budisantoso@email.com', phone: '0813-9876-5432', registeredAt: '10 Mei 2025', totalOrders: '12', totalSpent: 'Rp 1.980.000', accountStatus: 'Aktif', customerTag: 'Gold'),
  CustomerRecord(id: 'CUS-0004', name: 'Dewi Lestari', email: 'dewilestari@email.com', phone: '0815-2222-1111', registeredAt: '9 Mei 2025', totalOrders: '6', totalSpent: 'Rp 950.000', accountStatus: 'Aktif', customerTag: 'Premium'),
  CustomerRecord(id: 'CUS-0005', name: 'Maya Sari', email: 'mayasari@email.com', phone: '0812-7890-1234', registeredAt: '7 Mei 2025', totalOrders: '5', totalSpent: 'Rp 760.000', accountStatus: 'Nonaktif', customerTag: 'Baru'),
  CustomerRecord(id: 'CUS-0006', name: 'Fajar Ramadhan', email: 'fajarramadhan@email.com', phone: '0856-1234-5678', registeredAt: '6 Mei 2025', totalOrders: '9', totalSpent: 'Rp 1.320.000', accountStatus: 'Aktif', customerTag: 'Silver'),
];

const customerStats = [
  CustomerStat(title: 'Total Customer', value: '1.245', delta: '+24 dari kemarin', color: 0xFF0F8D55, icon: Icons.people_alt_rounded),
  CustomerStat(title: 'Customer Aktif', value: '1.102', delta: '+18 dari kemarin', color: 0xFF1D4ED8, icon: Icons.verified_user_rounded),
  CustomerStat(title: 'Customer Nonaktif', value: '87', delta: '-5 dari kemarin', color: 0xFFF59E0B, icon: Icons.person_off_rounded),
  CustomerStat(title: 'Customer Baru', value: '23', delta: '+6 dari kemarin', color: 0xFF7C3AED, icon: Icons.person_add_alt_1_rounded),
];
