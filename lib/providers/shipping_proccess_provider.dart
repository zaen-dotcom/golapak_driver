import 'package:flutter/material.dart';
import '../models/shipping_proccess_model.dart';
import '../services/shipment_service.dart';

class ShipmentProvider with ChangeNotifier {
  List<Shipment> _shipments = [];
  bool _loading = false;
  String? _error;

  List<Shipment> get shipments => _shipments;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> loadProcessingShipments() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final rawData = await getProcessingShipments();
      _shipments = rawData.map((e) => Shipment.fromJson(e)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
