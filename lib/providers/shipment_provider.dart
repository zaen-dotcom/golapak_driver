import 'package:flutter/material.dart';
import '../models/shipping_model.dart';
import '../services/shipment_service.dart';

class OrderProvider extends ChangeNotifier {
  List<Order> _orders = [];
  List<Order> get orders => _orders;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  Future<void> loadPendingOrders() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _orders = await fetchPendingOrders();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
