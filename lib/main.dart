import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(const EKantinApp());
}

class EKantinApp extends StatelessWidget {
  const EKantinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Kantin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: const LoginPage(),
    );
  }
}
