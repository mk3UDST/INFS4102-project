import 'package:flutter/material.dart';
import 'package:e_shop_ui/screens/splash/splash_screen.dart';
import 'package:e_shop_ui/theme/app_theme.dart'; // Fixed import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Shop',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
