class PelangganModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatarUrl;
  final int totalOrders;
  final double totalSpent;
  final String? lastOrderDate;
  final String description;

  PelangganModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl,
    required this.totalOrders,
    required this.totalSpent,
    this.lastOrderDate,
    this.description = 'Daftar riwayat dan informasi pelanggan setia toko Anda.',
  });

  PelangganModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    int? totalOrders,
    double? totalSpent,
    String? lastOrderDate,
    String? description,
  }) {
    return PelangganModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      totalOrders: totalOrders ?? this.totalOrders,
      totalSpent: totalSpent ?? this.totalSpent,
      lastOrderDate: lastOrderDate ?? this.lastOrderDate,
      description: description ?? this.description,
    );
  }
}
