import 'package:flutter/material.dart';

class InOrderScreen extends StatelessWidget {
  const InOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Ini In Order', style: Theme.of(context).textTheme.titleLarge),
      ),
    );
  }
}
