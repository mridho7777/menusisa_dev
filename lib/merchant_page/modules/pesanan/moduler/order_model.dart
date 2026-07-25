class OrderModel {
  final String id;
  final String orderNumber;
  final String customerName;
  final String customerPhone;
  final DateTime orderDate;
  final OrderStatus status;
  final double totalAmount;
  final List<OrderItem> items;
  final String? notes;
  final String? deliveryAddress;
  final DateTime? pickupTime;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.customerName,
    required this.customerPhone,
    required this.orderDate,
    required this.status,
    required this.totalAmount,
    required this.items,
    this.notes,
    this.deliveryAddress,
    this.pickupTime,
  });

  OrderModel copyWith({
    String? id,
    String? orderNumber,
    String? customerName,
    String? customerPhone,
    DateTime? orderDate,
    OrderStatus? status,
    double? totalAmount,
    List<OrderItem>? items,
    String? notes,
    String? deliveryAddress,
    DateTime? pickupTime,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      orderDate: orderDate ?? this.orderDate,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      items: items ?? this.items,
      notes: notes ?? this.notes,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      pickupTime: pickupTime ?? this.pickupTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'orderDate': orderDate.toIso8601String(),
      'status': status.toString().split('.').last,
      'totalAmount': totalAmount,
      'items': items.map((item) => item.toJson()).toList(),
      'notes': notes,
      'deliveryAddress': deliveryAddress,
      'pickupTime': pickupTime?.toIso8601String(),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      orderNumber: json['orderNumber'] as String,
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
      orderDate: DateTime.parse(json['orderDate'] as String),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => OrderStatus.baru,
      ),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String?,
      deliveryAddress: json['deliveryAddress'] as String?,
      pickupTime: json['pickupTime'] != null
          ? DateTime.parse(json['pickupTime'] as String)
          : null,
    );
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double price;
  final String? imageUrl;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
    );
  }
}

enum OrderStatus {
  baru,
  diproses,
  siapDiambil,
  selesai,
  dibatalkan,
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.baru:
        return 'Baru';
      case OrderStatus.diproses:
        return 'Diproses';
      case OrderStatus.siapDiambil:
        return 'Siap Diambil';
      case OrderStatus.selesai:
        return 'Selesai';
      case OrderStatus.dibatalkan:
        return 'Dibatalkan';
    }
  }

  String get colorHex {
    switch (this) {
      case OrderStatus.baru:
        return '#3B82F6'; // Blue
      case OrderStatus.diproses:
        return '#F59E0B'; // Orange
      case OrderStatus.siapDiambil:
        return '#8B5CF6'; // Purple
      case OrderStatus.selesai:
        return '#10B981'; // Green
      case OrderStatus.dibatalkan:
        return '#EF4444'; // Red
    }
  }
}
