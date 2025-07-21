import 'package:flutter/material.dart';
import '../screens/admin_home_page.dart';
import '../screens/favorilerim.dart';
import '../screens/cart.dart';
import '../screens/settings_page.dart';
import '../models/user.dart';

class AdminBottomNavBar extends StatelessWidget {
  final int currentIndex;
  const AdminBottomNavBar({Key? key, this.currentIndex = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 8, top: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context,
            icon: Icons.search_outlined,
            label: 'Ana Sayfa',
            selected: currentIndex == 0,
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) =>
                      AdminHomePage(user: UserSingleton().user!),
                ),
                (route) => false,
              );
            },
          ),
          _buildNavItem(
            context,
            icon: Icons.favorite_border,
            label: 'Favorilerim',
            selected: currentIndex == 1,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => FavorilerimPage()),
              );
            },
          ),
          _buildNavItem(
            context,
            icon: Icons.notifications_none_outlined,
            label: 'Sepetim',
            selected: currentIndex == 2,
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => CartPage()));
            },
          ),
          _buildNavItem(
            context,
            icon: Icons.person_outline,
            label: 'Ayarlar',
            selected: currentIndex == 3,
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected
                  ? const Color(0xFFFF3D3D)
                  : const Color(0xFFBDBDBD),
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
      ),
    );
  }
}
