import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/booking.dart';
import '../theme/app_theme.dart';

class ConfirmationScreen extends StatelessWidget {
  final Booking booking;
  const ConfirmationScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.secondary, width: 3),
                ),
                child: const Icon(Icons.check, color: AppColors.secondary, size: 52),
              ),
              const SizedBox(height: 20),
              const Text('Booking Confirmed!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.foreground)),
              const SizedBox(height: 8),
              const Text('Your parking spot is reserved', style: TextStyle(fontSize: 14, color: AppColors.muted)),
              const SizedBox(height: 28),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _DetailRow(Icons.location_on_outlined, 'Spot Location', 'Zone ${booking.zone} — Spot ${booking.spotId}'),
                      const Divider(height: 20),
                      _DetailRow(Icons.access_time, 'Duration', '${booking.duration} hour(s)'),
                      const Divider(height: 20),
                      _DetailRow(Icons.schedule, 'Time', booking.timeRange),
                      const Divider(height: 20),
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(color: AppColors.secondary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                            child: const Icon(Icons.attach_money, color: AppColors.secondary, size: 20),
                          ),
                          const SizedBox(width: 12),
                          const Text('Total Cost', style: TextStyle(color: AppColors.muted, fontSize: 13)),
                          const Spacer(),
                          Text(
                            booking.costDisplay,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.secondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text('Scan at Entry', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.foreground)),
                      const SizedBox(height: 12),
                      QrImageView(data: booking.qrCode, version: QrVersions.auto, size: 180),
                      const SizedBox(height: 8),
                      Text(booking.qrCode, style: const TextStyle(fontSize: 10, color: AppColors.muted)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false),
                child: const Text('Back to Home'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/bookings', (r) => false),
                child: const Text('View My Bookings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.foreground)),
      ],
    );
  }
}
