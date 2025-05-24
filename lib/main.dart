import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'routes/main_navigation.dart';
import 'theme/theme.dart';
import 'providers/shipment_provider.dart';
import 'providers/shipping_detail_provider.dart';
import 'package:golapak_driver/screens/detail_inorder.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ShippingDetailProvider()),
      ],

      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/main': (context) => const MainNavigation(),
        '/detail-inorder': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          final transactionId = args['transactionId'] as int;
          return DetailInOrderScreen(transactionId: transactionId);
        },
      },
    );
  }
}
