import 'package:flutter/material.dart';
import '../models/parking_spot.dart';
import '../services/api_service.dart';
import '../services/api_constants.dart';
import '../theme/app_theme.dart';

class SpotDetailsScreen extends StatefulWidget {
  final String spotId;
  const SpotDetailsScreen({super.key, required this.spotId});

  @override
  State<SpotDetailsScreen> createState() => _SpotDetailsScreenState();
}

class _SpotDetailsScreenState extends State<SpotDetailsScreen> {
  ParkingSpot? _spot;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await ApiService.get(ApiConstants.spotById(widget.spotId));
      if (mounted)
        setState(() {
          _spot = ParkingSpot.fromJson(data);
          _loading = false;
        });
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', ''))));
      }
    }
  }

  Color get _statusColor {
    if (_spot == null) return AppColors.muted;
    if (_spot!.isAvailable) return AppColors.available;
    if (_spot!.isOccupied) return AppColors.occupied;
    return AppColors.reserved;
  }

  String get _statusLabel {
    if (_spot == null) return '';
    if (_spot!.isAvailable) return 'Available';
    if (_spot!.isOccupied) return 'Occupied';
    return 'Reserved';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spot ${widget.spotId}'),
        leading: const BackButton(),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _spot == null
              ? const Center(child: Text('Spot not found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Spot header card
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: _statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(Icons.local_parking,
                                    color: _statusColor, size: 36),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Spot ${_spot!.spotId}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: AppColors.foreground)),
                                    Text(
                                        'Zone ${_spot!.zone} · Floor ${_spot!.floor}',
                                        style: const TextStyle(
                                            color: AppColors.muted,
                                            fontSize: 14)),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _statusColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color:
                                                _statusColor.withOpacity(0.3)),
                                      ),
                                      child: Text(_statusLabel,
                                          style: TextStyle(
                                              color: _statusColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Pricing card
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Pricing',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppColors.foreground)),
                              SizedBox(height: 12),
                              _PriceRow(
                                  'First hour', 'FREE', AppColors.secondary),
                              Divider(height: 20),
                              _PriceRow('Additional hours', '10 EGP / hr',
                                  AppColors.primary),
                              Divider(height: 20),
                              _PriceRow('Overstay penalty', '20 EGP / hr',
                                  AppColors.warning),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Notice card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: AppColors.primary.withOpacity(0.2)),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Icon(Icons.info_outline,
                                  color: AppColors.primary, size: 18),
                              SizedBox(width: 8),
                              Text('Important Notes',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary)),
                            ]),
                            SizedBox(height: 10),
                            Text('• Arrive within 15 minutes of booking',
                                style: TextStyle(
                                    color: AppColors.foreground,
                                    fontSize: 13,
                                    height: 1.6)),
                            Text('• Penalties apply for using wrong spot',
                                style: TextStyle(
                                    color: AppColors.foreground,
                                    fontSize: 13,
                                    height: 1.6)),
                            Text('• Overstay is charged at double rate',
                                style: TextStyle(
                                    color: AppColors.foreground,
                                    fontSize: 13,
                                    height: 1.6)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (_spot!.isAvailable)
                        ElevatedButton(
                          onPressed: () => Navigator.pushNamed(
                              context, '/booking',
                              arguments: _spot!.spotId),
                          child: const Text('Book This Spot'),
                        ),
                    ],
                  ),
                ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  const _PriceRow(this.label, this.value, this.valueColor);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(color: AppColors.muted, fontSize: 14)),
        Text(value,
            style: TextStyle(
                color: valueColor, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}
