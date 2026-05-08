class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  static const String spots = '$baseUrl/spots';
  static String spotById(String id) => '$baseUrl/spots/$id';
  static const String bookings = '$baseUrl/bookings';
  static const String myBookings = '$baseUrl/bookings/my';
  static String cancelBooking(String id) => '$baseUrl/bookings/$id/cancel';
  static const String notifications = '$baseUrl/notifications';
  static const String readAllNotifications = '$baseUrl/notifications/read-all';
  static String readNotification(String id) => '$baseUrl/notifications/$id/read';
  static const String myQueue = '$baseUrl/waitinglist/my';
  static const String joinQueue = '$baseUrl/waitinglist/join';
  static const String leaveQueue = '$baseUrl/waitinglist/leave';
  static const String profile = '$baseUrl/profile';
}
