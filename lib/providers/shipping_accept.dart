import 'package:flutter/material.dart';
import '../services/shipment_service.dart';

class ShippingAccept extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  Future<void> acceptShipping(int id) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;
    notifyListeners();

    try {
      final result = await shippingAccept(id: id);
      successMessage = result['message'] ?? 'Berhasil menerima pengiriman';
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
