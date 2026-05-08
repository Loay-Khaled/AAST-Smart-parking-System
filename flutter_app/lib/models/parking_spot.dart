class ParkingSpot {
  final String id;
  final String spotId;
  final String zone;
  final String status;
  final int floor;
  final String? currentBookingId;
  final DateTime? availableAt;

  ParkingSpot({
    required this.id,
    required this.spotId,
    required this.zone,
    required this.status,
    required this.floor,
    this.currentBookingId,
    this.availableAt,
  });

  bool get isAvailable => status == 'available';
  bool get isOccupied => status == 'occupied';
  bool get isReserved => status == 'reserved';

  factory ParkingSpot.fromJson(Map<String, dynamic> json) => ParkingSpot(
        id: json['_id'] ?? '',
        spotId: json['spotId'] ?? '',
        zone: json['zone'] ?? '',
        status: json['status'] ?? 'available',
        floor: (json['floor'] ?? 1).toInt(),
        currentBookingId: json['currentBookingId'],
        availableAt: json['availableAt'] != null ? DateTime.parse(json['availableAt']) : null,
      );
}
