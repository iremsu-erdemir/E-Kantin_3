import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/user.dart';
import '../services/user_service.dart';
import 'login_page.dart';
import 'ozet_sayfa.dart';

class AdminHomePage extends StatelessWidget {
  final User user;
  const AdminHomePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Özet kutusunun yüksekliği (tahmini)
    const double summaryBoxHeight = 100;
    // Kırmızı arka plan yüksekliği: kutunun 1/4'ü kadar daha fazla
    final double redBgHeight = 170 + summaryBoxHeight * 0.25;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // Kırmızı desenli arka plan
          Container(
            width: double.infinity,
            height: redBgHeight,
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
                scale: 3.0,
              ),
            ),
          ),
          // Ana içerik
          Column(
            children: [
              // Profil satırı (üstte)
              Padding(
                padding: const EdgeInsets.only(top: 48, left: 24, right: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage(
                        user.image ?? 'assets/images/turgay.png',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name ?? 'Turgay Tülü',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user.role?.contains('Şube Müdürü') == true
                                ? user.role!.replaceAll(' Şube Müdürü', '')
                                : (user.role ?? 'Kültür ve Sosyal İşler'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Şube Müdürü',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
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
                                  filter: ImageFilter.blur(
                                    sigmaX: 6,
                                    sigmaY: 6,
                                  ),
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
                                            color: Colors.black.withOpacity(
                                              0.07,
                                            ),
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
                                                    backgroundColor:
                                                        Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
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
                                                    backgroundColor:
                                                        Colors.white,
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
                                                        MainAxisAlignment
                                                            .center,
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
                      child: const Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
              // Expanded ile aşağıya devam eden içerik
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(36),
                        topRight: Radius.circular(36),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18.0,
                        vertical: 18,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Özet ve detay kutusu
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Özet Sayfa',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '₺1.567.789,80',
                                      style: TextStyle(
                                        color: Color(0xFFFF3D3D),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const OzetSayfa(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Detayları Gör',
                                    style: TextStyle(
                                      color: Color(0xFFFF3D3D),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Kantin ve Çay Ocağı kutuları
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Kantin',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        '₺1.567.789,80',
                                        style: TextStyle(
                                          color: Color(0xFFFF3D3D),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Çay Ocağı',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        '₺1.567.789,80',
                                        style: TextStyle(
                                          color: Color(0xFFFF3D3D),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          // Menü kartları
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.1,
                            children: [
                              _MenuCard(
                                image: 'assets/images/tost.png',
                                title: 'Tostlar',
                                onTap: () {},
                              ),
                              _MenuCard(
                                image: 'assets/images/sandwich_2.png',
                                title: 'Sandviçler',
                                onTap: () {},
                              ),
                              _MenuCard(
                                image: 'assets/images/karisik.png',
                                title: 'Kendi Menünü Oluştur',
                                onTap: () {},
                              ),
                              _MenuCard(
                                image: 'assets/images/cay.png',
                                title: 'Çay Ocağı',
                                onTap: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _AdminBottomNavBar(),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback onTap;
  const _MenuCard({
    required this.image,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.asset(
            image,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

class _AdminBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const selectedColor = Color(0xFFFF3D3D);
    const unselectedColor = Color(0xFFBDBDBD);
    const indicatorColor = Colors.black;
    final currentIndex = 0;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 8, top: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItem(
            icon: Icons.search_outlined,
            label: 'Ana Sayfa',
            selected: currentIndex == 0,
          ),
          _NavBarItem(
            icon: Icons.favorite_border,
            label: 'Favorilerim',
            selected: currentIndex == 1,
          ),
          _NavBarItem(
            icon: Icons.notifications_none_outlined,
            label: 'Sepetim',
            selected: currentIndex == 2,
          ),
          _NavBarItem(
            icon: Icons.person_outline,
            label: 'Siparişlerim',
            selected: currentIndex == 3,
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: selected ? const Color(0xFFFF3D3D) : const Color(0xFFBDBDBD),
            size: 30,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: selected
                  ? const Color(0xFFFF3D3D)
                  : const Color(0xFFBDBDBD),
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 2),
          selected
              ? Container(
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(2),
                  ),
                )
              : const SizedBox(height: 4),
        ],
      ),
    );
  }
}
