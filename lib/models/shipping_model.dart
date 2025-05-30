class Order {
  final int deliveryId;
  final String status;
  final String transactionCode;
  final int totalQty;
  final int deliveryFee;
  final int grandTotal;
  final DateTime transactionDate;
  final String customerName;

  Order({
    required this.deliveryId,
    required this.status,
    required this.transactionCode,
    required this.totalQty,
    required this.deliveryFee,
    required this.grandTotal,
    required this.transactionDate,
    required this.customerName,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      deliveryId: int.tryParse(json['delivery_id'].toString()) ?? 0,
      status: json['status'],
      transactionCode: json['transaction_code'],
      totalQty: int.tryParse(json['total_qty'].toString()) ?? 0,
      deliveryFee: int.tryParse(json['delivery_fee'].toString()) ?? 0,
      grandTotal: int.tryParse(json['grand_total'].toString()) ?? 0,
      transactionDate: DateTime.parse(json['transaction_date']),
      customerName: json['customer_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'delivery_id': deliveryId,
      'status': status,
      'transaction_code': transactionCode,
      'total_qty': totalQty,
      'delivery_fee': deliveryFee,
      'grand_total': grandTotal,
      'transaction_date': transactionDate.toIso8601String(),
      'customer_name': customerName,
    };
  }
}
