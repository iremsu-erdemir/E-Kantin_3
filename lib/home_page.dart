import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Figma'ya göre bottom bar ikon isimleri (assets/images altında)
  final List<String> _bottomIcons = [
    'cart.png',        // Home
    'wishlist.png',    // Favorites
    'categories.png',  // Orders
    'shop.png',        // Download
    'person.png',      // Profile
  ];

  @override
  void initState() {
    super.initState();
    // Durum çubuğu rengini ayarla
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFFD32F2F), // Kırmızı başlık ile uyumlu
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double headerHeight = 170; // Figma: 375x170
    final double cardWidth = 328;    // Figma: 328
    final double cardHeight = 160;   // Figma: 160
    final double smallCardWidth = 156; // Figma: 156
    final double smallCardHeight = 160;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // Ana arka plan (Rectangle 33)
          Positioned(
            left: 0,
            right: 0,
            top: headerHeight - 16, // başlık altına hizala
            child: Container(
              width: screenWidth,
              height: screenHeight - (headerHeight - 16) - 84, // ekran yüksekliğinden header ve bottom barı çıkar
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
            ),
          ),
          Column(
            children: [
              // Kırmızı başlık alanı
              Container(
                width: screenWidth,
                height: headerHeight,
                decoration: const BoxDecoration(
                  color: Color(0xFFD32F2F),
                  image: DecorationImage(
                    image: AssetImage('assets/images/Pattern.png'),
                    repeat: ImageRepeat.repeat,
                    fit: BoxFit.none,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 48, left: 20, right: 20),
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
                        child: const CircleAvatar(
                          radius: 28,
                          backgroundImage: AssetImage('assets/images/profile.png'),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Cengiz Demir',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Yazılım Şube Müdürü',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white, size: 24),
                        onPressed: () {
                          // Logout işlemi
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ),
              // Kategori kartları
              Expanded(
                child: Container(
                  color: Colors.transparent,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    children: [
                      // Tostlar kartı
                      Center(
                        child: _buildCategoryCard(
                          context,
                          title: 'Tostlar',
                          imagePath: 'assets/images/tost.png',
                          width: cardWidth,
                          height: cardHeight,
                          borderRadius: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Sandviçler kartı
                      Center(
                        child: _buildCategoryCard(
                          context,
                          title: 'Sandviçler',
                          imagePath: 'assets/images/sandwich.png',
                          width: cardWidth,
                          height: cardHeight,
                          borderRadius: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Kendi Menünü Oluştur & Çay Ocağı kartları yan yana
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildCategoryCard(
                            context,
                            title: 'Kendi Menünü Oluştur',
                            imagePath: 'assets/images/karisik.png',
                            width: smallCardWidth,
                            height: smallCardHeight,
                            borderRadius: 16,
                          ),
                          const SizedBox(width: 16),
                          _buildCategoryCard(
                            context,
                            title: 'Çay Ocağı',
                            imagePath: 'assets/images/cay.png',
                            width: smallCardWidth,
                            height: smallCardHeight,
                            borderRadius: 16,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Custom Bottom Bar
              Container(
                color: Colors.white,
                height: 84,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(_bottomIcons.length, (index) {
                    final isSelected = _selectedIndex == index;
                    final iconName = _bottomIcons[index];
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/$iconName',
                              width: 28,
                              height: 28,
                              color: isSelected ? const Color(0xFFD32F2F) : Colors.grey[400],
                            ),
                            const SizedBox(height: 6),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 4,
                              width: 32,
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.black : Colors.transparent,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String title,
    required String imagePath,
    double width = 328,
    double height = 160,
    double borderRadius = 16,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            Image.asset(
              imagePath,
              width: width,
              height: height,
              fit: BoxFit.cover,
            ),
            // Blur ve yarı saydam beyaz arka planlı kategori adı
            Positioned(
              left: 12,
              bottom: 12,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    color: Colors.white.withOpacity(0.30),
                    padding: EdgeInsets.zero,
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
