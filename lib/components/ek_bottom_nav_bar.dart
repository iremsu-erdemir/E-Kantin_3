import 'package:e_kantin/models/user.dart';
import 'package:flutter/material.dart';
import '../screens/favorilerim.dart';
import '../screens/home_page.dart';
import '../screens/siparisler.dart';
import '../screens/successpayment.dart';

class EKBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final BuildContext? parentContext;
  final int? highlightIndex;
  const EKBottomNavBar({
    Key? key,
    this.currentIndex = 0,
    this.onTap,
    this.parentContext,
    this.highlightIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        final ctx = parentContext ?? context;
        if (index == 0) {
          Navigator.of(ctx).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => HomePage(
                user: User(
                  username: 'demo',
                  password: '',
                  name: 'Demo',
                  role: 'Kullanıcı',
                  image: null,
                ),
              ),
            ),
            (route) => false,
          );
        } else if (index == 1) {
          Navigator.of(ctx).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const FavorilerimPage()),
            (route) => false,
          );
        } else if (index == 2 || index == 3) {
          Navigator.of(ctx).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const SiparislerPage()),
            (route) => false,
          );
        } else {
          // 5. ikon için dummy bir sayfa veya profil
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFFFF3D3D),
      unselectedItemColor: Colors.black54,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_outlined,
            color: currentIndex == 0 ? const Color(0xFFFF3D3D) : Colors.black54,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.favorite_border,
            color: currentIndex == 1 ? const Color(0xFFFF3D3D) : Colors.black54,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.list_rounded,
            color: currentIndex == 2 ? const Color(0xFFFF3D3D) : Colors.black54,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.inventory_2_outlined,
            color: (highlightIndex == 3 || currentIndex == 3)
                ? const Color(0xFFFF3D3D)
                : Colors.black54,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_outline,
            color: currentIndex == 4 ? const Color(0xFFFF3D3D) : Colors.black54,
          ),
          label: '',
        ),
      ],
    );
  }
}
