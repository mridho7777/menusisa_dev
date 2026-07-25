class PaymentMethodModel {
  final String id;
  final String name;
  final String iconKey;
  bool isActive;

  PaymentMethodModel({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.isActive,
  });

  PaymentMethodModel copyWith({
    String? id,
    String? name,
    String? iconKey,
    bool? isActive,
  }) {
    return PaymentMethodModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconKey: iconKey ?? this.iconKey,
      isActive: isActive ?? this.isActive,
    );
  }
}
