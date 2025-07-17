import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int)? onTap;
  const CustomBottomNavBar({Key? key, this.selectedIndex = 0, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 8, top: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: _NavBarItem(
              icon: Icons.search,
              label: 'Ana Sayfa',
              selected: selectedIndex == 0,
              onTap: () => onTap?.call(0),
            ),
          ),
          Expanded(
            child: _NavBarItem(
              icon: Icons.favorite_border,
              label: 'Favorilerim',
              selected: selectedIndex == 1,
              onTap: () => onTap?.call(1),
            ),
          ),
          Expanded(
            child: _NavBarItem(
              icon: Icons.notifications_none_outlined,
              label: 'Sepetim',
              selected: selectedIndex == 2,
              onTap: () => onTap?.call(2),
            ),
          ),
          Expanded(
            child: _NavBarItem(
              icon: Icons.person_2_sharp,
              label: 'Siparişlerim',
              selected: selectedIndex == 3,
              onTap: () => onTap?.call(3),
            ),
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
  final VoidCallback? onTap;
  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
