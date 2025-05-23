import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/search_screen.dart';
import '../theme/colors.dart';
import '../providers/shipment_provider.dart';
import '../components/card_order.dart';

class InOrderScreen extends StatefulWidget {
  const InOrderScreen({super.key});

  @override
  State<InOrderScreen> createState() => _InOrderScreenState();
}

class _InOrderScreenState extends State<InOrderScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Panggil loadPendingOrders tanpa parameter token
      Provider.of<OrderProvider>(context, listen: false).loadPendingOrders();
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
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            children: [
              // Search bar
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.lightGreyBlue,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.text, size: 22),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        readOnly: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(
                                milliseconds: 350,
                              ),
                              pageBuilder: (_, __, ___) => const SearchScreen(),
                              transitionsBuilder: (_, animation, __, child) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.0, -1.0),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        decoration: InputDecoration(
                          hintText: "Cari...",
                          hintStyle: const TextStyle(
                            color: AppColors.text,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // List orders
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

                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: orderProvider.orders.length,
                      itemBuilder: (context, index) {
                        final order = orderProvider.orders[index];
                        return CardOrder(data: order.toJson());
                      },
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
