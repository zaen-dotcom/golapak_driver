import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'package:intl/intl.dart';

class CardOrder extends StatelessWidget {
  final Map<String, dynamic> data;

  const CardOrder({Key? key, required this.data}) : super(key: key);

  String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(amount);
  }

  String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy, HH:mm').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = (data['status'] ?? '').toString();
    final transactionCode = data['transaction_code'] ?? '';
    final totalQty = data['total_qty'] ?? 0;
    final deliveryFee = data['delivery_fee'] ?? 0;
    final grandTotal = data['grand_total'] ?? 0;
    final transactionDate = data['transaction_date'] ?? '';
    final customerName = data['customer_name'] ?? '';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status & Code row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  decoration: BoxDecoration(
                    color: getStatusColor(status).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: getStatusColor(status),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Text(
                  transactionCode,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Detail rows
            Row(
              children: [
                Icon(Icons.person_outline, color: AppColors.primary, size: 20),
                const SizedBox(width: 6),
                Text(
                  customerName,
                  style: const TextStyle(fontSize: 14, color: AppColors.text),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Icon(Icons.calendar_today_outlined, color: AppColors.primary, size: 18),
                const SizedBox(width: 6),
                Text(
                  formatDate(transactionDate),
                  style: const TextStyle(fontSize: 13, color: AppColors.blueGreyText),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Icon(Icons.shopping_cart_outlined, color: AppColors.primary, size: 20),
                const SizedBox(width: 6),
                Text(
                  'Qty: $totalQty',
                  style: const TextStyle(fontSize: 14, color: AppColors.text),
                ),
                const Spacer(),
                Text(
                  'Delivery: ${formatCurrency(deliveryFee)}',
                  style: const TextStyle(fontSize: 14, color: AppColors.text),
                ),
              ],
            ),

            const Divider(height: 20),

            // Grand total
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Total: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.text,
                  ),
                ),
                Text(
                  formatCurrency(grandTotal),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
