class PengaturanModel {
  final String title;
  final String description;
  final String storeName;
  final String storeDescription;
  final String storeAddress;
  final String whatsapp;
  final String email;
  final String openTime;
  final String closeTime;
  final String paymentMethod;
  final bool orderNotification;
  final bool promoNotification;
  final bool stockNotification;
  final String photoLabel;
  final String bannerLabel;

  PengaturanModel({
    required this.title,
    required this.description,
    required this.storeName,
    required this.storeDescription,
    required this.storeAddress,
    required this.whatsapp,
    required this.email,
    required this.openTime,
    required this.closeTime,
    required this.paymentMethod,
    required this.orderNotification,
    required this.promoNotification,
    required this.stockNotification,
    required this.photoLabel,
    required this.bannerLabel,
  });

  PengaturanModel copyWith({
    String? title,
    String? description,
    String? storeName,
    String? storeDescription,
    String? storeAddress,
    String? whatsapp,
    String? email,
    String? openTime,
    String? closeTime,
    String? paymentMethod,
    bool? orderNotification,
    bool? promoNotification,
    bool? stockNotification,
    String? photoLabel,
    String? bannerLabel,
  }) {
    return PengaturanModel(
      title: title ?? this.title,
      description: description ?? this.description,
      storeName: storeName ?? this.storeName,
      storeDescription: storeDescription ?? this.storeDescription,
      storeAddress: storeAddress ?? this.storeAddress,
      whatsapp: whatsapp ?? this.whatsapp,
      email: email ?? this.email,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      orderNotification: orderNotification ?? this.orderNotification,
      promoNotification: promoNotification ?? this.promoNotification,
      stockNotification: stockNotification ?? this.stockNotification,
      photoLabel: photoLabel ?? this.photoLabel,
      bannerLabel: bannerLabel ?? this.bannerLabel,
    );
  }
}
