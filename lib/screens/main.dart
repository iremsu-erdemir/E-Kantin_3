import 'package:e_kantin/screens/favorilerim.dart';
import 'package:e_kantin/screens/home_page.dart';
import 'package:e_kantin/models/user.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/ek_bottom_nav_bar.dart';
import 'settings_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CartProvider())],
      child: const EKantinApp(),
    ),
  );
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
      home: LoginPage(),
      routes: {'/settings': (context) => const SettingsPage()},
    );
  }
}

Future<void> saveCard(String card) async {
  final prefs = await SharedPreferences.getInstance();
  final cards = prefs.getStringList('savedCards') ?? [];
  cards.add(card);
  await prefs.setStringList('savedCards', cards);
}

Future<List<String>> loadCards() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('savedCards') ?? [];
}
