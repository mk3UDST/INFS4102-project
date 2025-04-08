import 'package:flutter/material.dart';
import 'package:e_shop_ui/screens/splash/splash_screen.dart';
import 'package:e_shop_ui/theme/app_theme.dart';
import 'package:e_shop_ui/screens/order/order_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Shop',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/order': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          return OrderScreen(
            cartItems: args?['cartItems'] ?? [],
            totalAmount: args?['totalAmount'] ?? 0.0,
            cartId: args?['cartId'] ?? 0,
          );
        },
      },
    );
  }
}
