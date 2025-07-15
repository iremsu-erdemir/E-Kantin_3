import 'package:e_kantin/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/favorite_provider.dart';
import 'screens/home_page.dart';
import 'models/user.dart';
import 'package:provider/provider.dart';
import 'providers/notification_provider.dart';
import 'providers/debt_provider.dart';
import 'screens/favorilerim.dart';
import 'screens/siparisler.dart';
import 'screens/sepetim_page.dart';
import 'screens/settings_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => DebtProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => DebtProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Kantin',
        theme: ThemeData(primarySwatch: Colors.red, fontFamily: 'Poppins'),
        home: LoginPage(),
        routes: {
          '/homepage': (context) {
            final user = UserSingleton().user;
            if (user == null) {
              return LoginPage();
            }
            return HomePage(user: user);
          },
          '/favorilerim': (context) => FavorilerimPage(),
          '/siparisler': (context) => SiparislerPage(),
          '/sepetim': (context) => SepetimPage(),
          '/profil': (context) => ProfilPage(),
          '/settings': (context) => const SettingsPage(),
        },
      ),
    );
  }
}

class ProfilPage extends StatelessWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: const Center(child: Text('Profil Sayfası')),
    );
  }
}
