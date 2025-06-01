import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/colors.dart';
import '../providers/shipment_provider.dart';
import '../components/card_order.dart';
import '../components/alertdialog.dart';
import '../screens/login_screen.dart';
import '../utils/token_manager.dart';

class InOrderScreen extends StatefulWidget {
  const InOrderScreen({Key? key}) : super(key: key);

  @override
  State<InOrderScreen> createState() => InOrderScreenState();
}

class InOrderScreenState extends State<InOrderScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Future<void> refresh() async {
    try {
      await Provider.of<OrderProvider>(
        context,
        listen: false,
      ).loadPendingOrders();
    } catch (e) {
      print('ERROR DARI REFRESH: $e');

      if (e.toString().contains('401') ||
          e.toString().toLowerCase().contains('unauthenticated')) {
        Future.delayed(Duration.zero, () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder:
                (_) => CustomAlert(
                  title: 'Sesi Berakhir',
                  message: 'Sesi Anda telah berakhir, silakan login kembali.',
                  confirmText: 'Login',
                  onConfirm: () async {
                    Navigator.of(context).pop();
                    await TokenManager.removeToken();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                ),
          );
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refresh();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(
            children: [
              Expanded(
                child: Consumer<OrderProvider>(
                  builder: (context, orderProvider, _) {
                    if (orderProvider.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (orderProvider.error != null) {
                      return Center(
                        child: Text(
                          orderProvider.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    if (orderProvider.orders.isEmpty) {
                      return const Center(
                        child: Text(
                          'Belum ada pesanan',
                          style: TextStyle(fontSize: 16, color: AppColors.text),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: refresh,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: orderProvider.orders.length,
                        itemBuilder: (context, index) {
                          final order = orderProvider.orders[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/detail-inorder',
                                arguments: {'transactionId': order.deliveryId},
                              );
                            },
                            child: CardOrder(data: order.toJson()),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
