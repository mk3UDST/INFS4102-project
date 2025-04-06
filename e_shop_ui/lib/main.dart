import 'package:flutter/material.dart';
import 'package:e_shop_ui/screens/splash/splash_screen.dart';
import 'package:e_shop_ui/theme/app_theme.dart';

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
      home: const SplashScreen(), // Ensure SplashScreen is the initial route
      // Removed the custom layout route
      // routes: {'/custom_layout': (context) => const CustomLayoutScreen()},
    );
  }
}
