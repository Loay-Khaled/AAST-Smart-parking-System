class User {
  final String id;
  final String name;
  final String email;
  final String carPlate;
  final int totalBookings;
  final double totalSpent;
  final int activePenalties;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.carPlate,
    required this.totalBookings,
    required this.totalSpent,
    required this.activePenalties,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] ?? json['_id'] ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        carPlate: json['carPlate'] ?? '',
        totalBookings: (json['totalBookings'] ?? 0).toInt(),
        totalSpent: (json['totalSpent'] ?? 0).toDouble(),
        activePenalties: (json['activePenalties'] ?? 0).toInt(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'carPlate': carPlate,
        'totalBookings': totalBookings,
        'totalSpent': totalSpent,
        'activePenalties': activePenalties,
      };
}
