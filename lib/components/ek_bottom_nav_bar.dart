import 'package:flutter/material.dart';
import '../screens/favorilerim.dart';
import '../screens/home_page.dart';

class EKBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final BuildContext? parentContext;
  final int? highlightIndex; // Kırmızı yapılacak ikonun indexi (opsiyonel)
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
        if (index == 0) {
          // HomePage'e yönlendirme için mevcut user'ı bul
          final ModalRoute? route = ModalRoute.of(parentContext ?? context);
          final user =
              (route?.settings.arguments is Map &&
                  (route!.settings.arguments as Map).containsKey('user'))
              ? (route.settings.arguments as Map)['user']
              : null;
          if (user != null) {
            Navigator.of(parentContext ?? context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePage(user: user)),
              (route) => false,
            );
          }
        } else if (index == 1) {
          Navigator.of(parentContext ?? context).push(
            MaterialPageRoute(builder: (context) => const FavorilerimPage()),
          );
        } else {
          if (onTap != null) onTap!(index);
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
