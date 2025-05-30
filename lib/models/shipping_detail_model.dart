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
    id: int.tryParse(json['id'].toString()) ?? 0,
    transactionId: int.tryParse(json['transaction_id'].toString()) ?? 0,
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
    return 0.0;
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
    id: int.tryParse(json['id'].toString()) ?? 0,
    transactionCode: json['transaction_code'],
    totalQty: int.tryParse(json['total_qty'].toString()) ?? 0,
    totalMainCost: int.tryParse(json['total_main_cost'].toString()) ?? 0,
    deliveryFee: int.tryParse(json['delivery_fee'].toString()) ?? 0,
    grandTotal: int.tryParse(json['grand_total'].toString()) ?? 0,
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
    id: int.tryParse(json['id'].toString()) ?? 0,
    name: json['name'],
    qty: int.tryParse(json['qty'].toString()) ?? 0,
    mainCost: int.tryParse(json['main_cost'].toString()) ?? 0,
    mainSubtotal: int.tryParse(json['main_subtotal'].toString()) ?? 0,
  );
}
