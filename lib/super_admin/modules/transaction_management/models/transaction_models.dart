class TransactionRecord {
  TransactionRecord({
    required this.id,
    required this.orderCode,
    required this.customerName,
    required this.merchantName,
    required this.status,
  });

  final String id;
  final String orderCode;
  final String customerName;
  final String merchantName;
  final String status;

  factory TransactionRecord.fromJson(Map<String, dynamic> json) => TransactionRecord(
        id: json['id']?.toString() ?? '',
        orderCode: json['order_code']?.toString() ?? '',
        customerName: json['customer_name']?.toString() ?? '',
        merchantName: json['merchant_name']?.toString() ?? '',
        status: json['status']?.toString() ?? 'processing',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_code': orderCode,
        'customer_name': customerName,
        'merchant_name': merchantName,
        'status': status,
      };
}
