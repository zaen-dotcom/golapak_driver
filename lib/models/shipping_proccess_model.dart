class Shipment {
  final int deliveryId;
  final String status;
  final String transactionCode;
  final int totalQty;
  final int deliveryFee;
  final int grandTotal;
  final String transactionDate;
  final String customerName;

  Shipment({
    required this.deliveryId,
    required this.status,
    required this.transactionCode,
    required this.totalQty,
    required this.deliveryFee,
    required this.grandTotal,
    required this.transactionDate,
    required this.customerName,
  });

  factory Shipment.fromJson(Map<String, dynamic> json) {
    return Shipment(
      deliveryId: json['delivery_id'],
      status: json['status'],
      transactionCode: json['transaction_code'],
      totalQty: json['total_qty'],
      deliveryFee: json['delivery_fee'],
      grandTotal: json['grand_total'],
      transactionDate: json['transaction_date'],
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
      'transaction_date': transactionDate,
      'customer_name': customerName,
    };
  }
}
