import 'package:flutter/material.dart';

class OrderAcceptScreen extends StatelessWidget {
  const OrderAcceptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Ini Pesanan diterima',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
