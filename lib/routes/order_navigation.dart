import 'package:flutter/material.dart';

// Placeholder untuk InOrderScreen
class InOrderScreen extends StatelessWidget {
  const InOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Pesanan Masuk',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

// Placeholder untuk OrderAcceptScreen
class OrderAcceptScreen extends StatelessWidget {
  const OrderAcceptScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Terima Pesanan',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class OrderNavigation extends StatefulWidget {
  const OrderNavigation({Key? key}) : super(key: key);

  @override
  State<OrderNavigation> createState() => _OrderNavigationState();
}

class _OrderNavigationState extends State<OrderNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    InOrderScreen(),
    OrderAcceptScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Pesanan Masuk' : 'Terima Pesanan'),
        centerTitle: true,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Pesanan Masuk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Terima Pesanan',
          ),
        ],
      ),
    );
  }
}
