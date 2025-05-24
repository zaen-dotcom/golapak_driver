import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/colors.dart';
import '../providers/shipment_provider.dart';
import '../components/card_order.dart';

class InOrderScreen extends StatefulWidget {
  const InOrderScreen({Key? key}) : super(key: key);

  @override
  State<InOrderScreen> createState() => InOrderScreenState();
}

class InOrderScreenState extends State<InOrderScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Future<void> refresh() async {
    await Provider.of<OrderProvider>(
      context,
      listen: false,
    ).loadPendingOrders();
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
