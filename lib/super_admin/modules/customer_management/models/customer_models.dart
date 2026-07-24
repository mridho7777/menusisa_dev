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

const customerRecords = <CustomerRecord>[];

const customerStats = <CustomerStat>[];
