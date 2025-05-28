import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shipping_proccess_provider.dart';
import '../components/card_order.dart';

class InDeliveryScreen extends StatefulWidget {
  const InDeliveryScreen({super.key});

  @override
  InDeliveryScreenState createState() => InDeliveryScreenState();
}

class InDeliveryScreenState extends State<InDeliveryScreen> {
  Future<void> refresh() async {
    await Provider.of<ShipmentProvider>(
      context,
      listen: false,
    ).loadProcessingShipments();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => refresh());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Consumer<ShipmentProvider>(
            builder: (context, provider, _) {
              if (provider.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.error != null) {
                return Center(
                  child: Text(
                    provider.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              if (provider.shipments.isEmpty) {
                return const Center(child: Text('Tidak ada pesanan diterima'));
              }

              return RefreshIndicator(
                onRefresh: refresh,
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: provider.shipments.length,
                  itemBuilder: (context, index) {
                    final shipment = provider.shipments[index];

                    final dynamic rawDeliveryId = shipment.deliveryId;
                    final int? deliveryId =
                        (rawDeliveryId is int)
                            ? rawDeliveryId
                            : (int.tryParse(rawDeliveryId?.toString() ?? ''));

                    if (deliveryId == null) {
                      return CardOrder(data: shipment.toJson());
                    }

                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/detail-indelivery',
                          arguments: {
                            'transactionId':
                                deliveryId, 
                          },
                        );
                      },
                      child: CardOrder(data: shipment.toJson()),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
