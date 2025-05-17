import 'package:flutter/material.dart';

class InDeliveryScreen extends StatelessWidget {
  const InDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Ini In Delivery',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
