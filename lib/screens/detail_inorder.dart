import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../components/box_container.dart';
import '../components/button.dart';
import '../providers/shipping_detail_provider.dart';
import '../providers/shipping_accept.dart';
import '../theme/colors.dart';
import '../components/alertdialog.dart';

class DetailInOrderScreen extends StatefulWidget {
  final int transactionId;

  const DetailInOrderScreen({super.key, required this.transactionId});

  @override
  State<DetailInOrderScreen> createState() => _DetailInOrderScreenState();
}

class _DetailInOrderScreenState extends State<DetailInOrderScreen> {
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

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return AppColors.primary;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey.shade600;
    }
  }

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: AppColors.text,
      ),
    ),
  );

  Widget _infoItem(IconData icon, String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 22, color: AppColors.primary),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
                fontSize: 15,
              ),
            ),
          ],
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(fontSize: 15),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );

  Widget _productItem(String name, int qty, int subtotal) => Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.fastfood_outlined,
            size: 28,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Qty: $qty',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
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
      const SizedBox(height: 12),
      const Divider(height: 1, color: Colors.grey),
      const SizedBox(height: 12),
    ],
  );

  void _showCustomAlert({
    required String title,
    required String message,
    required String confirmText,
    required VoidCallback onConfirm,
    bool isDestructive = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal by tapping outside
      builder:
          (context) => WillPopScope(
            onWillPop: () async => false, // Prevent dismissal by back button
            child: CustomAlert(
              title: title,
              message: message,
              confirmText: confirmText,
              onConfirm: onConfirm,
              isDestructive: isDestructive,
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreyBlue,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Detail Order',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.text,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer2<ShippingDetailProvider, ShippingAccept>(
        builder: (context, shippingDetailProvider, shippingAcceptProvider, _) {
          if (shippingDetailProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (shippingDetailProvider.error != null) {
            return Center(
              child: Text(
                shippingDetailProvider.error!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 16),
              ),
            );
          }
          final detail = shippingDetailProvider.shippingDetail;
          if (detail == null) {
            return const Center(
              child: Text('Data detail pengiriman tidak tersedia.'),
            );
          }

          final shipping = detail.shipping;
          final transaction = detail.transaction;
          final details = detail.details;

          if (shippingAcceptProvider.errorMessage != null) {
            final errorMessage = shippingAcceptProvider.errorMessage!;
            shippingAcceptProvider.errorMessage =
                null; 
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showCustomAlert(
                title: 'Gagal',
                message: errorMessage,
                confirmText: 'OK',
                onConfirm: () {
                  Navigator.pop(context); 
                },
                isDestructive: true,
              );
            });
          } else if (shippingAcceptProvider.successMessage != null) {
            shippingAcceptProvider.successMessage =
                null; // Clear to prevent duplicates
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showCustomAlert(
                title: 'Berhasil',
                message: 'Pesanan diterima',
                confirmText: 'OK',
                onConfirm: () {
                  Navigator.pop(context);
                  Provider.of<ShippingDetailProvider>(
                    context,
                    listen: false,
                  ).loadShippingDetail(widget.transactionId);
                },
              );
            });
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _sectionTitle('Detail Pengiriman'),
              WhiteBoxContainer(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _infoItem(Icons.person, 'Nama', shipping.name),
                      _infoItem(Icons.phone, 'Telepon', shipping.phoneNumber),
                      _infoItem(Icons.location_on, 'Alamat', shipping.address),
                    ],
                  ),
                ),
              ),
              _sectionTitle('Detail Transaksi'),
              WhiteBoxContainer(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _infoItem(
                        Icons.receipt_long,
                        'Kode Transaksi',
                        transaction.transactionCode,
                      ),
                      _infoItem(
                        Icons.shopping_cart,
                        'Jumlah Produk',
                        transaction.totalQty.toString(),
                      ),
                      _infoItem(
                        Icons.local_shipping,
                        'Ongkir',
                        formatCurrency.format(transaction.deliveryFee),
                      ),
                      _infoItem(
                        Icons.payment,
                        'Total Bayar',
                        formatCurrency.format(transaction.grandTotal),
                      ),
                      _infoItem(
                        Icons.calendar_today,
                        'Tanggal',
                        transaction.date,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info,
                                  size: 22,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Status',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 14,
                              ),
                              decoration: BoxDecoration(
                                color: _statusColor(
                                  transaction.status,
                                ).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                transaction.status.toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: _statusColor(transaction.status),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _sectionTitle('Produk Dibeli'),
              WhiteBoxContainer(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
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
                ),
              ),
              const SizedBox(height: 80),
            ],
          );
        },
      ),
      bottomNavigationBar: Consumer<ShippingAccept>(
        builder: (context, shippingAcceptProvider, _) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            child: CustomButton(
              text: 'Terima Pesanan',
              isLoading: shippingAcceptProvider.isLoading,
              onPressed:
                  shippingAcceptProvider.isLoading
                      ? null
                      : () async {
                        await shippingAcceptProvider.acceptShipping(
                          widget.transactionId,
                        );
                      },
            ),
          );
        },
      ),
    );
  }
}
