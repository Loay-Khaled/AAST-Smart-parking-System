import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;

  const BottomNav({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;
    final routes = ['/home', '/map', '/bookings', '/profile'];
    Navigator.pushNamedAndRemoveUntil(context, routes[index], (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (i) => _onTap(context, i),
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.muted,
      backgroundColor: AppColors.card,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.map_outlined), activeIcon: Icon(Icons.map), label: 'Map'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), activeIcon: Icon(Icons.calendar_today), label: 'Bookings'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
