import 'package:intl/intl.dart';

class Booking {
  final String id;
  final String userId;
  final String spotId;
  final String zone;
  final int duration;
  final double cost;
  final DateTime startTime;
  final DateTime endTime;
  final String status;
  final String qrCode;
  final double penalty;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.userId,
    required this.spotId,
    required this.zone,
    required this.duration,
    required this.cost,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.qrCode,
    required this.penalty,
    required this.createdAt,
  });

  String get costDisplay => cost == 0 ? 'FREE' : '${cost.toStringAsFixed(0)} EGP';

  String get timeRange {
    final fmt = DateFormat('hh:mm a');
    return '${fmt.format(startTime)} - ${fmt.format(endTime)}';
  }

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json['_id'] ?? '',
        userId: json['userId'] ?? '',
        spotId: json['spotId'] ?? '',
        zone: json['zone'] ?? '',
        duration: (json['duration'] ?? 1).toInt(),
        cost: (json['cost'] ?? 0).toDouble(),
        startTime: DateTime.parse(json['startTime']),
        endTime: DateTime.parse(json['endTime']),
        status: json['status'] ?? 'active',
        qrCode: json['qrCode'] ?? '',
        penalty: (json['penalty'] ?? 0).toDouble(),
        createdAt: DateTime.parse(json['createdAt']),
      );
}
