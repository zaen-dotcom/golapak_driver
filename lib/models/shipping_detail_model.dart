class ShippingDetailModel {
  final Shipping shipping;
  final Transaction transaction;
  final List<Detail> details;

  ShippingDetailModel({
    required this.shipping,
    required this.transaction,
    required this.details,
  });

  factory ShippingDetailModel.fromJson(Map<String, dynamic> json) {
    return ShippingDetailModel(
      shipping: Shipping.fromJson(json['shipping']),
      transaction: Transaction.fromJson(json['transaction']),
      details:
          (json['details'] as List).map((e) => Detail.fromJson(e)).toList(),
    );
  }
}

class Shipping {
  final int id;
  final int transactionId;
  final String name;
  final String phoneNumber;
  final String address;
  final double latitude;
  final double longitude;

  Shipping({
    required this.id,
    required this.transactionId,
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory Shipping.fromJson(Map<String, dynamic> json) => Shipping(
    id: json['id'],
    transactionId: json['transaction_id'],
    name: json['name'],
    phoneNumber: json['phone_number'],
    address: json['address'],
    latitude: _toDouble(json['latitude']),
    longitude: _toDouble(json['longitude']),
  );

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0; // fallback aman
  }
}

class Transaction {
  final int id;
  final String transactionCode;
  final int totalQty;
  final int totalMainCost;
  final int deliveryFee;
  final int grandTotal;
  final String date;
  final String status;

  Transaction({
    required this.id,
    required this.transactionCode,
    required this.totalQty,
    required this.totalMainCost,
    required this.deliveryFee,
    required this.grandTotal,
    required this.date,
    required this.status,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json['id'],
    transactionCode: json['transaction_code'],
    totalQty: json['total_qty'],
    totalMainCost: json['total_main_cost'],
    deliveryFee: json['delivery_fee'],
    grandTotal: json['grand_total'],
    date: json['date'],
    status: json['status'],
  );
}

class Detail {
  final int id;
  final String name;
  final int qty;
  final int mainCost;
  final int mainSubtotal;

  Detail({
    required this.id,
    required this.name,
    required this.qty,
    required this.mainCost,
    required this.mainSubtotal,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    id: json['id'],
    name: json['name'],
    qty: json['qty'],
    mainCost: json['main_cost'],
    mainSubtotal: json['main_subtotal'],
  );
}
