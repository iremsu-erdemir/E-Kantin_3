import 'package:flutter/material.dart';
import '../screens/favorilerim.dart';

class EKBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final BuildContext? parentContext;
  const EKBottomNavBar({
    Key? key,
    this.currentIndex = 0,
    this.onTap,
    this.parentContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == 1) {
          // Favoriler (wishlist) ikonuna basınca FavorilerimPage'e yönlendir
          Navigator.of(parentContext ?? context).push(
            MaterialPageRoute(builder: (context) => const FavorilerimPage()),
          );
        } else {
          // Diğer indexler için mevcut davranışı koru
          if (onTap != null) onTap!(index);
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFFFF3D3D),
      unselectedItemColor: Colors.black54,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.list_rounded), label: ''),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2_outlined),
          label: '',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
      ],
    );
  }
}
