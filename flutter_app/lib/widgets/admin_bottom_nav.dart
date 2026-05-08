import 'package:flutter/material.dart';

const Color _adminAccent = Color(0xFF4F46E5);
const Color _adminMuted = Color(0xFF9CA3AF);

class AdminBottomNav extends StatelessWidget {
  final int currentIndex;

  const AdminBottomNav({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;
    final routes = [
      '/admin-home',
      '/admin-users',
      '/admin-spots',
      '/admin-bookings',
    ];
    if (index < routes.length) {
      Navigator.pushNamedAndRemoveUntil(context, routes[index], (r) => false);
    } else {
      _showMore(context);
    }
  }

  void _showMore(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
            ),
            ListTile(
              leading: const Icon(Icons.notifications_outlined, color: _adminAccent),
              title: const Text('Notifications'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/admin-notifications');
              },
            ),
            ListTile(
              leading: const Icon(Icons.queue_outlined, color: _adminAccent),
              title: const Text('Waiting List'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/admin-waiting-list');
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex > 3 ? 4 : currentIndex,
      onTap: (i) => _onTap(context, i),
      selectedItemColor: _adminAccent,
      unselectedItemColor: _adminMuted,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontSize: 11),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Users'),
        BottomNavigationBarItem(icon: Icon(Icons.local_parking_outlined), activeIcon: Icon(Icons.local_parking), label: 'Spots'),
        BottomNavigationBarItem(icon: Icon(Icons.book_outlined), activeIcon: Icon(Icons.book), label: 'Bookings'),
        BottomNavigationBarItem(icon: Icon(Icons.more_horiz), activeIcon: Icon(Icons.more_horiz), label: 'More'),
      ],
    );
  }
}
