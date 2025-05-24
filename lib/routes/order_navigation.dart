import 'package:flutter/material.dart';
import '../screens/inorder_screen.dart';
import '../screens/accept_order.dart';

class OrderNavigation extends StatefulWidget {
  const OrderNavigation({Key? key}) : super(key: key);

  @override
  State<OrderNavigation> createState() => _OrderNavigationState();
}

class _OrderNavigationState extends State<OrderNavigation>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Widget> _screens = const [InOrderScreen(), OrderAcceptScreen()];

  final List<String> _tabTitles = ['Pesanan Masuk', 'Terima Pesanan'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTitles.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              color: Colors.white,
              elevation: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: TabBar(
                  controller: _tabController,
                  tabs: _tabTitles.map((title) => Tab(text: title)).toList(),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.2),
                  ),
                  indicatorPadding: const EdgeInsets.all(6),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Theme.of(context).colorScheme.primary,
                  unselectedLabelColor: Colors.grey[600],
                  labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: Theme.of(context).textTheme.bodyLarge,
                  dividerColor: Colors.transparent,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: IndexedStack(
                index: _tabController.index,
                children: _screens,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
