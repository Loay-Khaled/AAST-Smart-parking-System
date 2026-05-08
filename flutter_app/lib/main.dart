import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/map_screen.dart';
import 'screens/spot_details_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/confirmation_screen.dart';
import 'screens/bookings_screen.dart';
import 'screens/waiting_list_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/admin_home_screen.dart';
import 'screens/admin_users_screen.dart';
import 'screens/admin_spots_screen.dart';
import 'screens/admin_bookings_screen.dart';
import 'screens/admin_notifications_screen.dart';
import 'screens/admin_waiting_list_screen.dart';
import 'models/booking.dart';

void main() {
  runApp(const AastParkingApp());
}

class AastParkingApp extends StatelessWidget {
  const AastParkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AAST Parking',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/splash',
      routes: {
        '/splash': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const HomeScreen(),
        '/map': (_) => const MapScreen(),
        '/bookings': (_) => const BookingsScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/waiting-list': (_) => const WaitingListScreen(),
        '/notifications': (_) => const NotificationsScreen(),
        // Admin routes
        '/admin-home': (_) => const AdminHomeScreen(),
        '/admin-users': (_) => const AdminUsersScreen(),
        '/admin-spots': (_) => const AdminSpotsScreen(),
        '/admin-bookings': (_) => const AdminBookingsScreen(),
        '/admin-notifications': (_) => const AdminNotificationsScreen(),
        '/admin-waiting-list': (_) => const AdminWaitingListScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/spot-details':
            return MaterialPageRoute(
              builder: (_) => SpotDetailsScreen(spotId: settings.arguments as String),
            );
          case '/booking':
            return MaterialPageRoute(
              builder: (_) => BookingScreen(spotId: settings.arguments as String),
            );
          case '/confirmation':
            return MaterialPageRoute(
              builder: (_) => ConfirmationScreen(booking: settings.arguments as Booking),
            );
        }
        return null;
      },
    );
  }
}
