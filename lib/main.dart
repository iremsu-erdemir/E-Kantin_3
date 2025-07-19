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
import '../models/favorite_menu.dart';
import '../providers/favorite_provider.dart';

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
    return MaterialApp(
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

class AdminMenuDuzenlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final menus = context.watch<FavoriteProvider>().favorites;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Menü Düzenle',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        centerTitle: false,
      ),
      body: menus.isEmpty
          ? Center(
              child: Text("Hiç menü yok. + Yeni Menü Ekle ile menü ekleyin."),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              itemCount: menus.length,
              itemBuilder: (context, index) {
                final menu = menus[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            menu.imagePath,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Menü ${index + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Color(0xFFFF3D3D),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    menu.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '₺35.25', // Fiyatı modelden almak için: menu.price
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Color(0xFF2AD2C9),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                menu.ekmekTipi,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                              ...menu.secilenIcerikler.map(
                                (icerik) => Text(
                                  icerik,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0, top: 18.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // Düzenle sayfasına git
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF3D3D),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Düzenle',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              // Yeni menü ekle işlemi burada yapılacak
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF3D3D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: const Text(
              '+ Yeni Menü Ekle',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
