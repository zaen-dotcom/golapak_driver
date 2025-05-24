import 'package:flutter/material.dart';
import '../services/shipment_service.dart';
import '../models/shipping_detail_model.dart';

class ShippingDetailProvider with ChangeNotifier {
  ShippingDetailModel? _shippingDetail;
  String? _error;
  bool _loading = false;

  ShippingDetailModel? get shippingDetail => _shippingDetail;
  String? get error => _error;
  bool get isLoading => _loading;

  Future<void> loadShippingDetail(int transactionId) async {
    _loading = true;
    _shippingDetail = null;
    _error = null;
    notifyListeners();

    try {
      _shippingDetail = await fetchShippingDetail(
        transactionId,
      ); // <- fungsi global
    } catch (e) {
      _error = 'Terjadi kesalahan: ${e.toString()}';
    }

    _loading = false;
    notifyListeners();
  }
}