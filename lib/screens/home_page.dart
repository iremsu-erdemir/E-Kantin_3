import 'package:e_kantin/components/ek_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'login_page.dart';
import 'tost.page.dart';
import '../models/user.dart';
import 'sandwich.page.dart';
import 'kendi_menum_page.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_provider.dart';
import 'favorilerim.dart';
import '../models/notification.dart';
import 'siparisler.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Kullanıcı oturumu kontrolü
    if (UserSingleton().user == null) {
      Future.microtask(() {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => LoginPage()),
          (route) => false,
        );
      });
      return const SizedBox.shrink();
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardRadius = 20;
    final double cardWidth = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: Column(
        children: [
          // Header bölümü
          Container(
            width: screenWidth,
            height: 170,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFD32F2F), Color(0xFFEE4343)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              image: DecorationImage(
                image: AssetImage('assets/images/Pattern.png'),
                repeat: ImageRepeat.repeat,
                alignment: Alignment.topLeft,
                scale: 2.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 48, left: 24, right: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundImage: widget.user.image != null
                          ? AssetImage(widget.user.image!) as ImageProvider
                          : const AssetImage('assets/images/person.png'),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.user.name ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.user.role ?? '',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        barrierColor: Colors.black.withOpacity(0.3),
                        builder: (context) {
                          return Stack(
                            children: [
                              BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                child: Container(color: Colors.transparent),
                              ),
                              Center(
                                child: Material(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  elevation: 0,
                                  child: Container(
                                    width: 320,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 28,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.07),
                                          blurRadius: 18,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          "Çıkmak İstediğinizden\nEmin misiniz?",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 28),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  side: const BorderSide(
                                                    color: Colors.red,
                                                    width: 1.5,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 14,
                                                      ),
                                                  backgroundColor: Colors.white,
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.close,
                                                      color: Colors.red,
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text(
                                                      "Hayır",
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  side: const BorderSide(
                                                    color: Colors.green,
                                                    width: 1.5,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 14,
                                                      ),
                                                  backgroundColor: Colors.white,
                                                ),
                                                onPressed: () {
                                                  UserSingleton().user = null;
                                                  Navigator.of(
                                                    context,
                                                  ).pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const LoginPage(),
                                                    ),
                                                    (route) => false,
                                                  );
                                                },
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.check,
                                                      color: Colors.green,
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text(
                                                      "Evet",
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      width: 80,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Kartlar
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  // Tostlar
                  Container(
                    width: cardWidth,
                    height: 110,
                    margin: const EdgeInsets.only(top: 12),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const TostPage(),
                          ),
                        );
                      },
                      child: _CategoryCardCustom(
                        imagePath: 'assets/images/tost.png',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Sandviçler
                  Container(
                    width: cardWidth,
                    height: 110,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SandwichPage(),
                          ),
                        );
                      },
                      child: _CategoryCardCustom(
                        imagePath: 'assets/images/sandwich.png',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Alt satır: 2 küçük kart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: (cardWidth - 8) / 2,
                        height: 80,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const KendiMenumPage(),
                              ),
                            );
                          },
                          child: _CategoryCardCustom(
                            imagePath: 'assets/images/karisik.png',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: (cardWidth - 8) / 2,
                        height: 80,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    SiparislerPage(initialTab: 2),
                              ),
                            );
                          },
                          child: _CategoryCardCustom(
                            imagePath: 'assets/images/cay.png',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: EKBottomNavBar(
        currentIndex: _selectedIndex,
        parentContext: context,
      ),
    );
  }
}

class _CategoryCardCustom extends StatelessWidget {
  final String imagePath;

  const _CategoryCardCustom({required this.imagePath, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(child: Image.asset(imagePath, fit: BoxFit.cover));
  }
}
