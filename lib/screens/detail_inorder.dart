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

  void _showCustomAlert({
    required String title,
    required String message,
    required String confirmText,
    required VoidCallback onConfirm,
    bool isDestructive = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => WillPopScope(
            onWillPop: () async => false,
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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          'Detail Order',
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
      body: Consumer2<ShippingDetailProvider, ShippingAccept>(
        builder: (context, shippingDetailProvider, shippingAcceptProvider, _) {
          if (shippingDetailProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
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
            shippingAcceptProvider.errorMessage = null;
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
            shippingAcceptProvider.successMessage = null;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showCustomAlert(
                title: 'Antar Pesanan',
                message: 'Pesanan siap diantar, kunjungi tab Delivery.',
                confirmText: 'OK',
                onConfirm: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(
                    context,
                    '/main',
                    arguments: 1,
                  );
                },
              );
            });
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Header
                WhiteBoxContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${transaction.transactionCode}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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

                // Delivery Information
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
                const SizedBox(height: 16),

                // Order Summary
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

                // Products
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
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Consumer<ShippingAccept>(
            builder: (context, shippingAcceptProvider, _) {
              return CustomButton(
                text: 'Antar Pesanan',
                onPressed:
                    shippingAcceptProvider.isLoading
                        ? null
                        : () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            barrierDismissible: false,
                            builder:
                                (_) => CustomAlert(
                                  title: 'Konfirmasi',
                                  message:
                                      'Apakah Anda yakin ingin mengantar pesanan ini?',
                                  confirmText: 'Ya',
                                  cancelText: 'Batal',
                                  onConfirm:
                                      () => Navigator.of(context).pop(true),
                                  onCancel:
                                      () => Navigator.of(context).pop(false),
                                ),
                          );

                          if (confirm == true) {
                            await shippingAcceptProvider.acceptShipping(
                              widget.transactionId,
                            );
                          }
                        },
                isLoading: shippingAcceptProvider.isLoading,
              );
            },
          ),
        ),
      ),
    );
  }
}
