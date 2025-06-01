import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../components/box_container.dart';
import '../providers/shipping_detail_provider.dart';
import '../theme/colors.dart';
import '../components/button.dart';
import 'map_route_screen.dart';
import '../services/shipment_service.dart';
import '../components/alertdialog.dart';
import '../routes/main_navigation.dart';

class DetailInDeliveryScreen extends StatefulWidget {
  final int transactionId;

  const DetailInDeliveryScreen({super.key, required this.transactionId});

  @override
  State<DetailInDeliveryScreen> createState() => _DetailInDeliveryScreenState();
}

class _DetailInDeliveryScreenState extends State<DetailInDeliveryScreen> {
  final formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ShippingDetailProvider>(
        context,
        listen: false,
      ).loadShippingDetail(widget.transactionId);
    });
  }

  Future<void> _handleShippingDone(String transactionCode) async {
    try {
      await markShippingAsDone(transactionCode);
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (_) => CustomAlert(
                title: 'Selesai',
                message: 'Pesanan selesai di antarkan.',
                confirmText: 'OK',
                onConfirm: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => MainNavigation(initialIndex: 1),
                    ),
                    (route) => false,
                  );
                },
              ),
        );
      }
    } catch (e) {
      _showErrorDialog('Gagal menyelesaikan pengiriman: ${e.toString()}');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Gagal'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFFC107);
      case 'cooking':
        return const Color(0xFFFF7043);
      case 'on_delivery':
        return const Color(0xFF42A5F5);
      case 'done':
        return const Color(0xFF4CAF50);
      case 'cancelled':
        return const Color(0xFFE57373);
      default:
        return Colors.grey.shade400;
    }
  }

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 12, top: 8),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade800,
      ),
    ),
  );

  Widget _infoItem(String label, String value, {IconData? icon}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
        ],
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    ),
  );

  Widget _productItem(String name, int qty, int subtotal) => WhiteBoxContainer(
    margin: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.fastfood_outlined,
            size: 20,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    '$qty item',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  const Spacer(),
                  Text(
                    formatCurrency.format(subtotal),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _statusBadge(String status) => Container(
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
    decoration: BoxDecoration(
      color: _statusColor(status).withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: _statusColor(status).withOpacity(0.3),
        width: 1,
      ),
    ),
    child: Text(
      status.toUpperCase(),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: _statusColor(status),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          'Detail Delivery',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Konten scroll
          Consumer<ShippingDetailProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }
              if (provider.error != null) {
                return Center(
                  child: Text(
                    provider.error!,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                    ),
                  ),
                );
              }
              final detail = provider.shippingDetail;
              if (detail == null) {
                return const Center(
                  child: Text('Data detail pengiriman tidak tersedia.'),
                );
              }

              final shipping = detail.shipping;
              final transaction = detail.transaction;
              final details = detail.details;

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WhiteBoxContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Order #${transaction.transactionCode}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _statusBadge(transaction.status),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Placed on ${transaction.date}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    _sectionTitle('Delivery Information'),
                    WhiteBoxContainer(
                      child: Column(
                        children: [
                          _infoItem(
                            'Name',
                            shipping.name,
                            icon: Icons.person_outline,
                          ),
                          const Divider(height: 1, color: Colors.black12),
                          _infoItem(
                            'Phone',
                            shipping.phoneNumber,
                            icon: Icons.phone_outlined,
                          ),
                          const Divider(height: 1, color: Colors.black12),
                          _infoItem(
                            'Address',
                            shipping.address,
                            icon: Icons.location_on_outlined,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => MapRouteScreen(
                                  destinationLat: shipping.latitude,
                                  destinationLng: shipping.longitude,
                                ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.map_outlined,
                        color: AppColors.primary,
                      ),
                      label: const Text(
                        'Lihat Lokasi di Peta',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        alignment: Alignment.centerLeft,
                      ),
                    ),

                    const SizedBox(height: 24),

                    _sectionTitle('Order Summary'),
                    WhiteBoxContainer(
                      child: Column(
                        children: [
                          _infoItem(
                            'Subtotal',
                            formatCurrency.format(
                              transaction.grandTotal - transaction.deliveryFee,
                            ),
                          ),
                          const Divider(height: 1, color: Colors.black12),
                          _infoItem(
                            'Delivery Fee',
                            formatCurrency.format(transaction.deliveryFee),
                          ),
                          const Divider(height: 1, color: Colors.black12),
                          _infoItem(
                            'Total',
                            formatCurrency.format(transaction.grandTotal),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    _sectionTitle('Products (${details.length})'),
                    Column(
                      children:
                          details
                              .map(
                                (product) => _productItem(
                                  product.name,
                                  product.qty,
                                  product.mainSubtotal,
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
              );
            },
          ),

          Positioned(
            bottom: 50,
            left: 16,
            right: 16,
            child: CustomButton(
              text: 'Pesanan Selesai Diantar',
              onPressed: () {
                final provider = Provider.of<ShippingDetailProvider>(
                  context,
                  listen: false,
                );
                final transactionCode =
                    provider.shippingDetail?.transaction.transactionCode;
                if (transactionCode != null) {
                  _handleShippingDone(transactionCode);
                } else {
                  _showErrorDialog('Kode transaksi tidak ditemukan.');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
